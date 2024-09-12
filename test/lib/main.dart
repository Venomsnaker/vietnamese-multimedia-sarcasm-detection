import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestApp(),
    );
  }
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  String _response = '';
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() async {
    final message = _controller.text;
    if (message.isEmpty) return;

    try {
      final response = await fetchChatResponse(message);
      setState(() {
        _response = response ?? "No response";
      });
    } catch (e) {
      setState(() {
        _response = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[800],
          title: const Text("Hugging Face Space Testing"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration:
                    const InputDecoration(labelText: 'Enter your message'),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: _sendMessage, child: const Text('Send')),
              const SizedBox(
                height: 32,
              ),
              const Text(
                "Response: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              Text(
                _response,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}

Future<String?> fetchChatResponse(String message) async {
  const String url = "https://venomsnaker-upstage-solar-rag.hf.space/call/predict";

  final postResponse = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "data": [message],
    }));

  if (postResponse.statusCode == 200) {
    final postResponseData = jsonDecode(postResponse.body);
    final eventID = postResponseData['event_id'];

    if (eventID != null) {
      final getResponse = await http.get(
        Uri.parse("$url/$eventID"),
        headers: {
          "Keep-Alive": "timeout=5, max=1"
        }
      ).timeout(const Duration(seconds: 15));

      if (getResponse.statusCode == 200) {
        final getResponseData = getResponse.body;
        int dataStart = getResponseData.indexOf('data:') + 'data:'.length;
        String dataSection = getResponseData.substring(dataStart).trim();
        dataSection = dataSection.replaceAll(RegExp(r'^\[\s*"\s*|\s*"\s*\]\s*$'), '');
        return dataSection;
      } else {
        throw Exception("Failed to fetch get response!");
      }
    } else {
      throw Exception("Event ID not found in post response");
    }
  } else {
    throw Exception("Falied to fetch post response");
  }
}
