import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String userID;

  const ChatPage({Key? key, required this.userID}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _messages = []; // Lista pentru a stoca mesajele

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat cu Asistentul Virtual'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                bool isSentByUser = index % 2 ==
                    0; // Alternăm mesajele pentru a afișa cine le-a trimis
                return ListTile(
                  title: Align(
                    alignment: isSentByUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: isSentByUser ? Colors.blue[100] : Colors.grey[300],
                      child: Text(_messages[index]),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Introduceți mesajul aici...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ),
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      print("Sending message: ${_controller.text}");
      setState(() {
        _messages.add(_controller
            .text); // Adăugăm mesajul utilizatorului la lista de mesaje
      });
      _fetchResponse(_controller.text);
      _controller.clear();
    }
  }

  Future<void> _fetchResponse(String query) async {
    const apiKey =
        'sk-proj-Gi5rzEWv9nJv1gfmjErzT3BlbkFJqVuzTXZkakRJY5ytEGA5'; // Înlocuiește cu cheia ta API reală
    const url =
        'https://api.openai.com/v1/completions'; // URL-ul pentru GPT-3.5 completions

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    var prompt =
        "Vă rog să răspundeți la întrebări legate doar despre cel mai vândut produs care de pe aplicație sunt sandalele de piele și avem produse de damă, bărbați și copii\n\nIntrebare: $query";

    var body = jsonEncode({
      'model': 'gpt-3.5-turbo-instruct', // Specifică modelul GPT-3.5
      'prompt': prompt,
      'max_tokens': 150,
      'temperature': 0.7
    });

    print("Making request to URL: $url");
    print("Headers: $headers");
    print("Body: $body");

    try {
      var response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var message =
            data['choices'][0]['text'].trim(); // Extragem textul din răspuns
        setState(() {
          _messages.add(message); // Adăugăm răspunsul la lista de mesaje
        });
      } else {
        setState(() {
          _messages
              .add('Error: Failed to load response: ${response.statusCode}');
        });
      }
    } catch (e) {
      print("Exception occurred: $e");
      setState(() {
        _messages.add('Error: $e');
      });
    }
  }
}
