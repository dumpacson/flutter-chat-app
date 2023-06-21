import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String email;

  const ChatPage({Key? key, required this.email}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];

  void _sendMessage(String message) {
    // Create a new message object and add it to the list
    final newMessage = Message(sender: widget.email, message: message);
    setState(() {
      _messages.insert(0, newMessage); // Insert the new message at index 0
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat 1',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF582841),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: _messages.isEmpty
                  ? Center(
                      child: Text(
                        'No messages sent.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Align(
                          alignment: message.sender == widget.email
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: message.sender == widget.email
                                  ? const Color(0xFF582841)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              message.message,
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        );
                      },
                      reverse: true, // Reverse the list to display the newer messages at the bottom
                    ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (message) {
                      _sendMessage(message);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String sender;
  final String message;

  Message({required this.sender, required this.message});
}
