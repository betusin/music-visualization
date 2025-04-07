import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/util/preset.dart';
import 'package:vibration_poc/storage/serivce/firebase_storage_service.dart';
import 'package:vibration_poc/web_view/widget/web_page_display.dart';

class PresetVisualization extends StatefulWidget {
  const PresetVisualization({super.key});

  @override
  State<PresetVisualization> createState() => _PresetVisualizationState();
}

class _PresetVisualizationState extends State<PresetVisualization> {
  final _firebaseStorageService = get<FirebaseStorageService>();
  String _selectedPreset = presets.first;
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    final entries = presets.map((presetName) => DropdownMenuEntry(value: presetName, label: presetName));

    return Column(
      spacing: smallGapSize,
      children: [
        _buildFilePicker(),
        DropdownMenu(
          dropdownMenuEntries: entries.toList(),
          initialSelection: presets.first,
          onSelected: (value) => value != null ? setState(() => _selectedPreset = value) : null,
        ),
        _buildVisualization(),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Row(
      spacing: smallGapSize,
      children: [
        ElevatedButton(onPressed: _pickFile, child: Text("Pick a File")),
        if (_fileName != null) Text(_fileName!),
      ],
    );
  }

  Widget _buildVisualization() {
    if (_fileName == null) {
      return Text("Pick a file to visualize");
    }
    return Expanded(
      child: WebPageDisplay(
          // TODO(betka): not loading the proper audio file
          url: 'https://music-visualization-iota.vercel.app/visualization?file=$_fileName&preset=$_selectedPreset'),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      _firebaseStorageService.uploadFile(result);
      setState(() => _fileName = result.files.first.name);
    }
  }
}
