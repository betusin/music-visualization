import 'package:flutter/material.dart';
import 'package:vibration_poc/pair/widget/pair_page.dart';
import 'package:vibration_poc/recorder/widget/animation_with_vibration_page.dart';
import 'package:vibration_poc/recorder/widget/preset_visualization.dart';
import 'package:vibration_poc/vibration/widget/vibration_switcher_and_adjuster.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    PresetVisualization(),
    Expanded(child: VibrationSwitcherAndAdjuster()),
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
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Microphone'),
          BottomNavigationBarItem(icon: Icon(Icons.link), label: 'Pair'),
        ],
        onTap: (value) => setState(() => _selectedIndex = value),
        currentIndex: _selectedIndex,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
