import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/pair/service/pairing_service.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';

class PairWithPhonePage extends StatefulWidget {
  const PairWithPhonePage({super.key});

  @override
  State<PairWithPhonePage> createState() => _PairWithPhonePageState();
}

class _PairWithPhonePageState extends State<PairWithPhonePage> {
  final _pairingService = get<PairingService>();
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: HandlingStreamBuilder(
        stream: _pairingService.getPairLinksPerCurrentWatch,
        builder: (context, pairLinks) {
          return Center(
            // TODO(betka): could also display the status of waiting request
            child: pairLinks.isEmpty ? _buildTextField() : Text('Paired with ${pairLinks.firstOrNull?.deviceId}'),
          );
        },
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      keyboardType: TextInputType.number,
      controller: _textEditingController,
      decoration: InputDecoration(label: Text('Insert pairing code'), hintText: '123456'),
      onSubmitted: (value) async {
        final code = int.tryParse(value.trim());

        if (code == null) {
          // TODO(betka): error handling
          return;
        }

        final pairRequest = await _pairingService.getPairRequestByCode(code);

        if (pairRequest == null) {
          // TODO(betka): error handling
          return;
        }

        _pairingService.updatePairRequestToWait(pairRequest.id);
        _textEditingController.clear();
      },
    );
  }
}
