import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/pair/service/pairing_service.dart';

class PairPage extends StatefulWidget {
  const PairPage({super.key});

  @override
  State<PairPage> createState() => _PairPageState();
}

class _PairPageState extends State<PairPage> {
  final _pairingService = get<PairingService>();

  @override
  Widget build(BuildContext context) {
    return HandlingStreamBuilder(
      stream: _pairingService.currentPairingData,
      builder: (context, pairData) {
        if (pairData == null) {
          return Text('Unable to pair');
        }

        return Text('code: ${pairData.pairCode}');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pairingService.createPairingDoc();
  }
}
