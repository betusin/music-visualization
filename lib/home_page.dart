import 'package:flutter/material.dart';
import 'package:vibration_poc/background_service/widget/start_stop_buttons.dart';
import 'package:vibration_poc/recorder/widget/animation_with_vibration_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    AnimationWithVibration(),
    Expanded(child: StartStopButtons()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Vibration Demo')),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
          BottomNavigationBarItem(icon: Icon(Icons.vibration), label: 'Vibration'),
        ],
        onTap: (value) => setState(() => _selectedIndex = value),
        currentIndex: _selectedIndex,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
