import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class recordingu extends StatefulWidget {
  const recordingu({super.key});

  @override
  State<recordingu> createState() => _recordinguState();
}

class _recordinguState extends State<recordingu> {

 final voiceRecordingsBox = Hive.box('voiceRecordingsBox');
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = " ";

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

    Future<String?> getApplicationSupportDirectoryPath() async {
    try {
      final appSupportDir = await path_provider.getApplicationSupportDirectory();
      return appSupportDir.path;
    } catch (e) {
      print('Error getting application support directory path: $e');
      return null;
    }
  }


  Future<void> startRecording() async {
  try {
    if (await audioRecord.hasPermission()) {
      final appSupportDirPath = await getApplicationSupportDirectoryPath();
      if (appSupportDirPath != null) {
        // Create a new folder for recordings
        final recordingsDirPath = '$appSupportDirPath/recordings';
        final customPath = '$recordingsDirPath/custom_audio_file.wav';

        // Check if the recordings directory exists, if not, create it
        final recordingsDir = Directory(recordingsDirPath);
        if (!await recordingsDir.exists()) {
          await recordingsDir.create(recursive: true);
        }

        await audioRecord.start(path: customPath);
        setState(() {
          isRecording = true;
          audioPath = customPath;
        });
      } else {
        print('Error: Application support directory path is null.');
      }
    }
  } catch (e, stackTrace) {
    print('Error Start Recording::::::: $e');
    print('Stack Trace:::::::>>>>>>> $stackTrace');
  }
}



// Future<void> startRecording() async {
//     try {
//       if (await audioRecord.hasPermission()) {
//         final appSupportDirPath = await getApplicationSupportDirectoryPath();
//         if (appSupportDirPath != null) {
//           final customPath = '$appSupportDirPath/custom_audio_file.wav'; // Change the file name and extension as needed
//           await audioRecord.start(path: customPath);
//           setState(() {
//             isRecording = true;
//             audioPath = customPath;
//           });
//         } else {
//           print('Error: Application support directory path is null.');
//         }
//       }
//     } catch (e, stackTrace) {
//       print('Error Start Recording::::::: $e');
//       print('Stack Trace:::::::>>>>>>> $stackTrace');
//     }
//   }


  // Future<void> startRecording() async {
  //   try {
  //     if (await audioRecord.hasPermission()) {
  //       await audioRecord.start();
  //       setState(() {
  //         isRecording = true;
  //       });
  //     }
  //   } catch (e, stackTrace) {
  //     print('Error Start Recording::::::: $e');
  //     print('Stack Trace:::::::>>>>>>> $stackTrace');
  //   }
  // }


 Future<void> stopRecording() async {
  try {
    String? path = await audioRecord.stop();

    // Save with a name starting with 'audio'
    final directory = await path_provider.getApplicationDocumentsDirectory();
    final DateTime now = DateTime.now();
    final String newFileName = 'record_${now.toIso8601String()}.aac';
    final newPath = '${directory.path}/$newFileName';

    File(path!).renameSync(newPath);

    setState(() {
      isRecording = false;
      audioPath = newPath;
      voiceRecordingsBox.add(audioPath);
    });
  } catch (e) {
    print('Error stop Recording $e');
  }
}

  // Future<void> playRecording({required String  audioPath1}) async {
  //   try {
  //     Source urlSource = UrlSource(audioPath1);
  //     await audioPlayer.play(urlSource);
  //     //print('Hive Playing Recording ${voiceRecordingsBox.values.cast<String>().toList().toString()}');
  //   } catch (e) {
  //     print('Error Playing Recording $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final voiceRecordings = voiceRecordingsBox.values.cast<String>()
    .where((path) => path.contains('/record_')) // Filter paths that contain 'audio_'
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
      floatingActionButton: ElevatedButton(
        onPressed: isRecording ? stopRecording : startRecording,
        child: isRecording
            ? const Text("Stop Recording")
            : const Text("Start Recording"),
      ),
    );
  }
}