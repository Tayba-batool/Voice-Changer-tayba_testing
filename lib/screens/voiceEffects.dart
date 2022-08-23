import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
class VoiceChanger extends StatefulWidget {
  const VoiceChanger({Key? key}) : super(key: key);
  bool get isSelected => false;
  @override
  State<VoiceChanger> createState() => _VoiceChangerState();
}

class _VoiceChangerState extends State<VoiceChanger> {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  final AudioPlayer audioPlayer = new AudioPlayer();

  List<String> Filtersname= ['Indoors', 'Mountains', 'Metal', 'Indsuperequalizeroor','Atremolo', 'Avibrato', 'Loudnorm', 'Sofalizer'];
  List<String> Filterscode= ['aecho=0.8:0.9:40|50|70:0.4|0.3|0.2', 'aecho=0.8:0.9:500|1000:0.2|0.1', 'aecho=0.8:0.88:8:0.8', 'superequalizer=1b=10:2b=10:3b=1:4b=5:5b=7:6b=5:7b=2:8b=3:9b=4:10b=5:11b=6:12b=7:13b=8:14b=8:15b=9:16b=9:17b=10:18b=10','tremolo=f=1:d=0.8', 'vibrato=f=4', 'loudnorm=I=-16:TP=-1.5:LRA=14', 'sofalizer=sofa=temp/hrtf c_nh877.sofa:type=freq:radius=1'];
  AudioPlayer advancedPlayer = new AudioPlayer();


  Duration musiclength = new Duration();
  Duration position = new Duration();

  Widget slider(){
    return Slider.adaptive(
        value: position.inSeconds.toDouble(),
        max:musiclength.inSeconds.toDouble(),
        activeColor: Colors.blueAccent,
        inactiveColor: Colors.grey,
        divisions: 50,
        label: 'String',
        onChanged: (value) {
          seekTosec(value.toInt());
        });
  }

  void seekTosec(int sec){
    Duration newpos = Duration(seconds:sec);
    audioPlayer.seek(newpos);
  }

  play() async{
    final tempDir = await getExternalStorageDirectory();
    var rand='output';
    File audiopath =File('${tempDir?.path}/$rand.mp3');
    int result = await audioPlayer.play(audiopath.path, isLocal: true);
    if(result == 1){ //play success
      print("audio is playing.");
    }else{
      print("Error while playing audio.");
    }
  }

  stop(){
    audioPlayer.stop();
  }

  voicechange(String a) async{
    var ran='audio';
    var rand='output';
    final tempDir = await getExternalStorageDirectory();
    File input =await File('${tempDir?.path}/$ran.mp3',);
    final tempDirec = await getExternalStorageDirectory();
    File output =await File('${tempDirec?.path}/$rand.mp3',);
    await _flutterFFmpeg.execute('-y -i ${input.path} -filter_complex \'$a\' ${output.path}');
    play();
    stop();
  }

  int _value = 6;
  int selectedIndex =-1;
  bool _isplaying =false;
  bool _isaudio =false;
  double _currentSliderValue = 20;

  @override
  void initState() {
    print("init");
    super.initState();
    audioPlayer.onDurationChanged.listen((d) => setState(() => musiclength = d));
    audioPlayer.onAudioPositionChanged.listen((p) => setState(() => position = p));
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        position = Duration(seconds: 0);
      });
    });
  }
  final appbar=AppBar(
    title: Text('Filters'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(itemCount:Filtersname.length, itemBuilder:(context, index)
              {
                return Card(
                  child: ListTile(
                      title:_isaudio==false&&index==selectedIndex?
                   slider()

                   :Text(Filtersname[index].toString()),
                      trailing: Container(
                        height: 50,
                        width: 120,
                        child:
                       Row(
                        children:<Widget> [
                         Icon(Icons.save),
                         SizedBox(
                          height: 30,
                          width: 30,
                        ),
                        IconButton(
                          iconSize: 40,
                          icon: Icon( _isplaying&&index==selectedIndex? Icons.pause : Icons.play_arrow, ),
                          onPressed: () {
                           /* if (_isplaying = true) {
                              stop();
                              setState(() {
                                selectedIndex = index;
                                _isplaying = false;
                              });*/
                              if (_isplaying == false) {
                                voicechange(Filterscode[index]);
                                setState(() {
                                  selectedIndex = index;
                                  _isplaying = true;
                                });
                              }
                              else {
                                stop();
                                setState(() {
                                  selectedIndex = index;
                                  _isplaying = false;
                                });
                              }
                            }
                          // }
                        ),
                        ]
                       ),
                      ),
                     /* ),*/
                      leading:Icon(Icons.record_voice_over),
                  ),
                );
              },
              ),
            ),
          )
        ],
      ),
    );
  }
}