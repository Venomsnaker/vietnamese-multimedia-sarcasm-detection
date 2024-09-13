import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    // if (message.isEmpty) return;

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
  const String url = "https://gradio-chatinterface-random-response.hf.space/call/chat";

  final postResponse = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "data": ["Are you sentient?"],
      "session_hash": DateTime.now().millisecondsSinceEpoch.toString(),
    }));

  if (postResponse.statusCode == 200) {
    final postResponseData = jsonDecode(postResponse.body);
    final eventID = postResponseData['event_id'];

    if (eventID != null) {
      final client = http.Client();
      try {
        final request = http.Request("GET", Uri.parse("$url/$eventID"));
        final streamedResponse = await client.send(request);

        final completer = Completer<String>();
        final buffer = StringBuffer();

        streamedResponse.stream.transform(utf8.decoder).listen(
          (String chunk) {
            buffer.write(chunk);
            if (chunk.trim().endsWith('"]]')) {
              // Found the end of the response
              completer.complete(buffer.toString());
            }
          },
          onDone: () {
            if (!completer.isCompleted) {
              completer.complete(buffer.toString());
            }
          },
          onError: (error) {
            if (!completer.isCompleted) {
              completer.completeError(error);
            }
          },
          cancelOnError: true,
        );

        final result = await completer.future.timeout(const Duration(seconds: 30));
        return _parseResponse(result);
      } finally {
        client.close();
      }

    //   final getResponse = await http.get(
    //     Uri.parse("$url/$eventID"),
    //   ).timeout(const Duration(seconds: 15));

    //   if (getResponse.statusCode == 200) {
    //     final getResponseData = getResponse.body;
    //     int dataStart = getResponseData.indexOf('data:') + 'data:'.length;
    //     String dataSection = getResponseData.substring(dataStart).trim();
    //     dataSection = dataSection.replaceAll(RegExp(r'^\[\s*"\s*|\s*"\s*\]\s*$'), '');
    //     return dataSection;
    //   } else {
    //     throw Exception("Failed to fetch get response!");
    //   }
    // } else {
    //   throw Exception("Event ID not found in post response");
    }
  } else {
    throw Exception("Falied to fetch post response");
  }
}

String? _parseResponse(String response) {
  final matches = RegExp(r'data: (.+)').allMatches(response);
  if (matches.isNotEmpty) {
    final lastMatch = matches.last;
    final jsonStr = lastMatch.group(1);
    if (jsonStr != null) {
      try {
        final decoded = jsonDecode(jsonStr);
        if (decoded is List && decoded.isNotEmpty && decoded[0] is List) {
          return decoded[0][1] as String?;
        }
      } catch (e) {
        print("Error parsing JSON: $e");
      }
    }
  }
  return null;
}
