import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testingp/screens/recording.dart';

void main() {
  runApp(
      MaterialApp(title: 'Voice Changer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  Recording(),)
      );

 }
