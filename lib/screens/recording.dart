import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:testingp/screens/voiceEffects.dart';
class Recording extends StatefulWidget {

  @override
  State<Recording> createState() => _RecordingState();
}
class _RecordingState extends State<Recording> {
  final record = Record();
  recordVoice () async {
    if (await record.hasPermission()) {
      final tempDir = await getExternalStorageDirectory();
      print(tempDir);
      var ran='audio';
      File input =File('${tempDir?.path}/$ran.mp3',);
      var audioPath = input.path;
      await record.start(
        path: audioPath,
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
    }
    bool isRecording = await record.isRecording();
    print(isRecording);
  }
  stopRecording ()async{
    final result = await record.stop();
    print(result);
      Navigator.of(context).push( MaterialPageRoute(builder: (context) => const VoiceChanger()));
  }
  bool _isReording= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recording'),
        ),
        body: Center(
            child: Container(
              height: 300,
                width: 300,
                margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
               Radius.circular(150)
                ),
                border: Border.all(
                  width: 2,
                  color: Colors.lightBlueAccent,
                  style: BorderStyle.solid,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white54,
                radius: 200,
                child:IconButton(
                  iconSize: 70,
                  icon: Icon( _isReording ? Icons.stop : Icons.record_voice_over),
                  onPressed: () {
                    if (_isReording == true) {
                      stopRecording();
                      setState(() {
                        _isReording = false;
                      });
                    } else {
                      recordVoice();
                      setState(() {
                        _isReording = true;
                      });
                    }
                  },
                ),

                /* IconButton(
                  onPressed: () {
            if (_isReording == true) {
            stopRecording();
            setState(() {
            _isReording = false;
            });
            } else {
            recordVoice();
            setState(() {
            _isReording = true;
            });
            }
            },
              child:
              Icon(_isReording ? Icons.pause : Icons.play_arrow),
            ),*/
              ),
            ),
            )
        );
  }
}