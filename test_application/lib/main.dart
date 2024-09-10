import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> fetchChatResponse(String message) async {
  // Define the API URLs
  final String url = 'https://venomsnaker-upstage-solar-rag.hf.space/call/chat';

  // POST request to send the message
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'data': [message],
    }),
  );


  if (response.statusCode == 200) {
    print('POST response body: ${jsonDecode(response.body)['event_id']}');
    // Parse the JSON response
    final postResponseData = jsonDecode(response.body);

    // Extract EVENT_ID from the response
    final eventId = postResponseData['event_id'];

    if (eventId != null) {
      // Polling the server to check the event status
      while (true) {
        // GET request to fetch the chat response
        final eventResponse = await http.get(Uri.parse('$url/eventId'));

        if (eventResponse.statusCode == 200) {
          // Parse the event response
          final eventResponseData = jsonDecode(eventResponse.body);
          final status = eventResponseData['event'];

          if (status == 'complete') {
            // Return the response data
            return eventResponseData['data'][0];
          } else {
            // Wait before retrying
            await Future.delayed(Duration(seconds: 1));
          }
        } else {
          throw Exception('Failed to fetch chat response');
        }
      }
    } else {
      throw Exception('Event ID not found in response');
    }
  } else {
    throw Exception('Failed to send message');
  }
}

void main() {
  runApp(
    MaterialApp(
      home: ChatScreen(),
    ),
  );
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _response = '';
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() async {
    final message = _controller.text;
    if (message.isEmpty) return;

    try {
      final response = await fetchChatResponse(message);
      setState(() {
        _response = response ?? 'No response';
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your message',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
            SizedBox(height: 20),
            Text(
              'Response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
