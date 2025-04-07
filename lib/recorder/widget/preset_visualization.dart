import 'package:flutter/material.dart';
import 'package:vibration_poc/recorder/util/preset.dart';
import 'package:vibration_poc/web_view/widget/web_page_display.dart';

class PresetVisualization extends StatefulWidget {
  const PresetVisualization({super.key});

  @override
  State<PresetVisualization> createState() => _PresetVisualizationState();
}

class _PresetVisualizationState extends State<PresetVisualization> {
  String _selectedPreset = presets.first;

  @override
  Widget build(BuildContext context) {
    const fileName = '12.mp3';

    final entries = presets.map((presetName) => DropdownMenuEntry(value: presetName, label: presetName));

    return Column(
      children: [
        DropdownMenu(
          dropdownMenuEntries: entries.toList(),
          initialSelection: presets.first,
          onSelected: (value) => value != null ? setState(() => _selectedPreset = value) : null,
        ),
        Expanded(
          child: WebPageDisplay(
              url: 'https://music-visualization-iota.vercel.app/visualization?file=$fileName&preset=$_selectedPreset'),
        ),
      ],
    );
  }
}
