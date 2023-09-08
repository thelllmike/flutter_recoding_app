import 'package:flutter/material.dart';
import 'package:voice_recording_app/RecordingScreen/recording_screen.dart';
import 'package:voice_recording_app/RecordingScreen/recordingi.dart';
import 'package:voice_recording_app/RecordingScreen/recordingu.dart';



// ignore: camel_case_types
class NavigationScreen extends StatelessWidget {
    const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                "Recording Option",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
             const SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: [
            

Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust the alignment as needed
  children: <Widget>[
    ElevatedButton(
      onPressed: () {
        // Navigate to the RecordingScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecordingScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: const Color(0xff0095ff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      ),
      child: const Text(
        'Record A',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
     const SizedBox(
              height: 20,
            ),
    ElevatedButton(
      onPressed: () {
        // Navigate to the RecordingScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => recordingi()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: const Color(0xff0095ff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      ),
      child: const Text(
        'Record I',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
     const SizedBox(
              height: 20,
            ),
    ElevatedButton(
      onPressed: () {
        // Navigate to the RecordingScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => recordingu()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: const Color(0xff0095ff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      ),
      child: const Text(
        'Record U',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
  ],
),


                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
