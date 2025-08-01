import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chatbot/widgets/message.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<Message> _messages = [
    Message(message: "Hi, what can I help you?", isUser: false),
  ];
  //make it private with _
  final TextEditingController _textEditingController = TextEditingController();
  bool _isLoading = false;
  // integrate with API and adjust the prompt and response
  Future<void> handleSubmit() async {
    // to prevent error or breaking happen
    try {
      // change a state
      setState(() {
        _isLoading = true;
      });

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'YOUR_API_KEY',
      );

      final prompt = _textEditingController.text;
      // Add user message first
      setState(() {
        _messages.add(Message(isUser: true, message: prompt));
        _textEditingController.clear();
      });

      // wait the model to response the prompt
      final response = await model.generateContent([Content.text(prompt)]);

      // change the message become stateful message
      setState(() {
        _messages.add(
          Message(
            isUser: false,
            message:
                response.text != null ? response.text!.trim() : "No response",
            //text! means the value must not be null
          ),
        );
      });
    } catch (e) {
      print(e);
      // Consider showing an error to the user
    } finally {
      // change back loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // everytime that need to create a new page need to write inside Scaffold()
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Gemini Chatbot",
          // make the font bold
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // put a Avatar for the chat
        leading: Padding(
          padding: const EdgeInsets.only(left: 6, top: 6, bottom: 6),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              "https://scx2.b-cdn.net/gfx/news/2019/3-robot.jpg",
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //stretch the column to the max of width
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // make it can scroll when there are lots of messages
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return _messages[index];
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemCount: _messages.length,
              ),
            ),
            // make a loading effect when the message is laoding
            Visibility(
              visible: _isLoading,
              child: Center(child: CircularProgressIndicator()),
            ),
            Row(
              // send message widget at the bottom of the chat
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Ask something here...", //placehorlder
                    ),
                    controller: _textEditingController,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: handleSubmit,
                    icon: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
