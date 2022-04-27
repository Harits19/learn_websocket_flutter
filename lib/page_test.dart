import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PageTest extends StatefulWidget {
  const PageTest({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  _PageTestState createState() => _PageTestState();
}

// const _url = 'ws://192.168.1.212:3021/ws';
// const _url = 'ws://192.168.197.114:3021/ws'; // no message received if using ip address
const _version = "2";

class _PageTestState extends State<PageTest> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;
  final _data = <String>[];
  late final _url = widget.url;
  String _messageOnDone = "";
  String _messageOnError = "";

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _listenWebsocketV2();
  }

  _listenWebsocketV2() {
    _channel = WebSocketChannel.connect(Uri.parse(_url));
    _channel.stream.listen(
      (event) {
        print(event);
        _data.add(event);
        setState(() {});
      },
      onDone: () {
        final message = "Web socket is closed";
        _messageOnDone = message;
        setState(() {});
      },
      onError: (error) {
        print(error.toString());
        _messageOnError = error.toString();
        setState(() {});
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(labelText: 'Send a message'),
                ),
              ),
              Text("Connect on : " + _url),
              Text("Version : " + _version),
              Text("Debug onDone : " + _messageOnDone),
              Text("Debug onError : " + _messageOnError),
              const SizedBox(height: 24),
              Text(_data.toString()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _sendMessage,
          tooltip: 'Send message',
          child: const Icon(Icons.send),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
