import 'package:flutter/material.dart';
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
      child: Center(
        child: TextField(
          keyboardType: TextInputType.number,
          controller: _textEditingController,
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
        ),
      ),
    );
  }
}
