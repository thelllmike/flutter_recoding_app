
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:voice_recording_app/RecordingScreen/recordnav.dart';
import 'package:voice_recording_app/dashboard.dart';

class RecordingScreen extends StatefulWidget {
  // const RecordingScreen({super.key});

  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final voiceRecordingsBox = Hive.box('voiceRecordingsBox');
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = " ";
  int recordingCount = 0;


  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
  }

  @override
  void dispose() {
    super.dispose();
    audioRecord.dispose();
    audioPlayer.dispose();
  }

Future<void> startRecording() async {
  if (recordingCount < 5) {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e, stackTrace) {
      print('Error Start Recording::::::: $e');
      print('Stack Trace:::::::>>>>>>> $stackTrace');
    }
  } else {
    // showRecordingLimitAlert(context);
  }
}

  Future<void> stopRecording() async {
  try {
    String? path = await audioRecord.stop();

    // Save with a name starting with 'audio'
    final directory = await path_provider.getApplicationDocumentsDirectory();
    final DateTime now = DateTime.now();
    final String newFileName = 'speak_${now.toIso8601String()}.aac';
    final newPath = '${directory.path}/$newFileName';

    File(path!).renameSync(newPath);

    setState(() {
      isRecording = false;
      audioPath = newPath;
      voiceRecordingsBox.add(audioPath);
      recordingCount++;
       if(recordingCount == 5){
          showRecordingLimitAlert(context);
       }
     
    });
  } catch (e) {
    print('Error stop Recording $e');
  }
}

  @override
  Widget build(BuildContext context) {
      final voiceRecordings = voiceRecordingsBox.values.cast<String>()
    .where((path) => path.contains('/speak_')) // Filter paths that contain 'audio_'
    .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recorder'),
      ),
      body: voiceRecordings.length != 0
          ? ListView.builder(
          itemCount: voiceRecordings.length,
          itemBuilder: (context, index) {
            final filePath = voiceRecordings[index];
            return ListTile(
              title: Text('Voice Recording $index'),
              onTap: () {},
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.play_circle,
                        color: Colors.green,
                      ),
                      onPressed: () async {
                        try {
                          Source urlSource = UrlSource(filePath);
                          await audioPlayer.play(urlSource);
                        } catch (e) {
                          print('Error Playing Recording $e');
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        try {
                          voiceRecordingsBox.deleteAt(index).then((value) {
                            const snackBar = SnackBar(
                              content: Text('Delete Voice Message'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            setState(() {});
                          });
                        } catch (e) {
                          print('Error Playing Recording $e');
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          })
             
          : const Center(child: Text(" Empty Data")),
              floatingActionButton: recordingCount < 5
    ? ElevatedButton(
        onPressed: isRecording ? stopRecording : startRecording,
        child: isRecording
            ? const Text("Stop Recording")
            : const Text("Start Recording"),
      ): const SizedBox(
        
      ),
    
    );
  }



void showRecordingLimitAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Recording Limit Reached'),
        content: Text('You have reached the maximum recording limit (5 recordings).'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => NavigationScreen()),
              );
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}



}
  
