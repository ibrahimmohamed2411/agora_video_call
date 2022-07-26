import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_video_call/src/pages/call.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRole? _role = ClientRole.Broadcaster;
  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.network(
                'https://tinyurl.com/2p889y4k',
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  errorText:
                      _validateError ? 'Channel name is mandatory' : null,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  hintText: 'Channel name',
                ),
              ),
              RadioListTile(
                title: const Text('BroadCaster'),
                value: ClientRole.Broadcaster,
                groupValue: _role,
                onChanged: (ClientRole? value) {
                  setState(() {
                    _role = value;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Audience'),
                value: ClientRole.Audience,
                groupValue: _role,
                onChanged: (ClientRole? value) {
                  setState(() {
                    _role = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: onJoin,
                child: Text('Join'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => CallPage(
            role: _role,
            channelName: _channelController.text,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    debugPrint(status.toString());
  }
}
