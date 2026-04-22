import 'package:flutter/material.dart';

void main() => runApp(const LvlUpApp());

class LvlUpApp extends StatelessWidget {
  const LvlUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LvlUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF00E5FF),
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
      ),
      home: const LvlUpHomePage(),
    );
  }
}

class LvlUpHomePage extends StatelessWidget {
  const LvlUpHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LvlUp - RPG Habit Tracker'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flash_on,
              size: 100,
              color: Color(0xFF00E5FF),
            ),
            SizedBox(height: 30),
            Text(
              'LvlUp',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00E5FF),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Level Up Your Life',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF94A3B8),
              ),
            ),
            SizedBox(height: 50),
            Card(
              color: Color(0xFF1E293B),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'STATUS: MVP WORKING',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Web Demo Live',
                      style: TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
