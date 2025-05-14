import 'package:flutter/material.dart';
import 'package:vibration_poc/pair/widget/pair_page_content.dart';
import 'package:vibration_poc/recorder/widget/animation_with_vibration_page.dart';
import 'package:vibration_poc/recorder/widget/preset_visualization.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    PresetVisualization(),
    AnimationWithVibration(),
    PairPageContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Music Visualization',
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: 'Visualization'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Real-time'),
          BottomNavigationBarItem(icon: Icon(Icons.link), label: 'Pair'),
        ],
        onTap: (value) => setState(() => _selectedIndex = value),
        currentIndex: _selectedIndex,
      ),
      child: _pages[_selectedIndex],
    );
  }
}
