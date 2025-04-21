import 'package:flutter/material.dart';
import 'package:vibration_poc/background_service/widget/start_stop_buttons.dart';
import 'package:vibration_poc/pair/widget/pair_page.dart';
import 'package:vibration_poc/recorder/widget/animation_with_vibration_page.dart';
import 'package:vibration_poc/recorder/widget/preset_visualization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    PresetVisualization(),
    // TODO(betka): add start vibration based on input/imported file??
    Expanded(child: StartStopButtons()),
    // TODO(betka): change for better sketch
    AnimationWithVibration(),
    PairPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Vibration Demo')),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: 'Visualization'),
          BottomNavigationBarItem(icon: Icon(Icons.vibration), label: 'Vibration'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
          BottomNavigationBarItem(icon: Icon(Icons.link), label: 'Pair'),
        ],
        onTap: (value) => setState(() => _selectedIndex = value),
        currentIndex: _selectedIndex,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
