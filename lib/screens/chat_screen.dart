import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final int eventId;
  final int senderId;

  ChatScreen({required this.eventId, required this.senderId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  // List<String> _messages = [];
  // List<Map<String, dynamic>> messages = [];
  // List<List<dynamic>> messages = [];
  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    fetchChatMessages();
  }

  Future<void> fetchChatMessages() async {
    String apiUrl = 'https://thescavengerhunt.azurewebsites.net/api/chat/${widget.eventId}';
    print("fetch");
    
    final response = await http.get(Uri.parse(apiUrl));
    print(response.body.runtimeType);

   
    if (response.statusCode == 200) {
      
      
      setState(() {
     messages = jsonDecode(response.body);
     print("message $messages");
       
      });
    }
  }

  Future<void> _sendMessage() async {
    String apiUrl = 'https://thescavengerhunt.azurewebsites.net/api/chat';
    Map<String, dynamic> body = {
      'event_id': widget.eventId,
      'sender_id': widget.senderId,
      'message': _messageController.text,
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));

    if (response.statusCode == 201) {
      _messageController.clear();
      fetchChatMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:Text(messages[index][3]),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
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
