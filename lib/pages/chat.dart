import 'package:flutter/material.dart';
import 'package:nutricare/firebasestuff/authentication.dart';
import 'package:nutricare/firebasestuff/chatservice.dart';
import 'package:nutricare/models/chatmessagemodel.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      final userDetails = await Authentication().getUserDetails();
      final username = userDetails.username;
      final senderId = userDetails.uid;

      await _chatService.sendMessage(text, senderId, username);
      _controller.clear();
    }
  }

  Widget _buildMessageItem(ChatMessage message) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(message.username.isNotEmpty ? message.username[0] : 'U'),
        backgroundColor: Colors.grey,
      ),
      title: Text(message.text),
      subtitle: Text('Sent by: ${message.username}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageItem(message);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}