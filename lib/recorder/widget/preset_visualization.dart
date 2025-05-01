import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_kit/collection_repo/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:vibration_poc/auth/service/auth_service.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/util/preset.dart';
import 'package:vibration_poc/storage/serivce/firebase_storage_service.dart';
import 'package:vibration_poc/vibration/model/vibration_metadata.dart';
import 'package:vibration_poc/vibration/widget/vibration_observer.dart';
import 'package:vibration_poc/web_view/widget/web_page_display.dart';

class PresetVisualization extends StatefulWidget {
  final String? initialFileId;
  final String? initialPreset;
  final bool showFilePicker;
  final bool showVibrationStatus;

  const PresetVisualization({
    super.key,
    this.initialFileId,
    this.initialPreset,
    this.showFilePicker = true,
    this.showVibrationStatus = true,
  });

  @override
  State<PresetVisualization> createState() => _PresetVisualizationState();
}

class _PresetVisualizationState extends State<PresetVisualization> {
  final _firebaseStorageService = get<FirebaseStorageService>();
  final _vibrationRepo = get<FirestoreRepository<VibrationMetadata>>();
  final _authService = get<AuthService>();

  late String _selectedPreset;
  String? _fileName;
  late String? _fileId;

  @override
  void initState() {
    super.initState();
    _selectedPreset = widget.initialPreset ?? presets.first;
    _fileId = widget.initialFileId;
  }

  @override
  void dispose() {
    _deleteVibrationForCurrentUser();
    super.dispose();
  }

  void _deleteVibrationForCurrentUser() {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      _vibrationRepo.delete(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = presets.map((presetName) => DropdownMenuEntry(value: presetName, label: presetName));
    final uid = _authService.currentUser?.uid;

    return Column(
      spacing: smallGapSize,
      children: [
        if (widget.showFilePicker) _buildFilePicker(),
        DropdownMenu(
          dropdownMenuEntries: entries.toList(),
          initialSelection: presets.first,
          onSelected: (value) => value != null ? setState(() => _selectedPreset = value) : null,
        ),
        if (uid != null)
          VibrationObserver(
            deviceId: uid,
            direction: Axis.horizontal,
            showVibrationStatus: widget.showVibrationStatus,
          ),
        _buildVisualization(uid),
      ],
    );
  }

  Widget _buildFilePicker() {
    if (Platform.isIOS) {
      setState(() {
        _fileName = 'Picked one of the sample songs.';
        _fileId = '12.mp3';
      });
      return ElevatedButton(onPressed: null, child: Text("Picking files not supported on iOS devices"));
    }
    return Padding(
      padding: const EdgeInsets.only(left: smallGapSize),
      child: Row(
        spacing: smallGapSize,
        children: [
          ElevatedButton(onPressed: _pickFile, child: Text("Pick a File")),
          if (_fileName != null) Flexible(child: Text(_fileName!, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildVisualization(String? uid) {
    _deleteVibrationForCurrentUser();

    if (_fileId == null) {
      return Text("Pick a file to visualize");
    }

    final deviceIdParam = uid == null ? '' : '&deviceId=$uid';
    final url =
        'https://music-visualization-iota.vercel.app/visualization?file=$_fileId&preset=$_selectedPreset$deviceIdParam';

    return Expanded(child: WebPageDisplay(url: url));
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      final fileId = await _firebaseStorageService.uploadFile(result);

      setState(() {
        _fileName = result.files.first.name;
        _fileId = fileId;
      });
    }
  }
}
