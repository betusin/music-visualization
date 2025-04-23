import 'package:flutter/material.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/pair/enum/pair_request_status.dart';
import 'package:vibration_poc/pair/model/pair_request.dart';
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
      stream: _pairingService.currentRequests,
      builder: (context, pairRequests) {
        if (pairRequests.isEmpty) {
          return Text('No requests waiting for acceptance');
        }

        final code = pairRequests.where((element) => element.status == PairRequestStatus.pending).firstOrNull?.code;
        if (code == null) {
          _pairingService.createPairingDoc();
        }

        return Column(
          spacing: standardGapSize,
          children: [
            Center(child: _buildCodeCard(context, code)),
            Column(
              children: pairRequests
                  .where((pairRequest) => pairRequest.status == PairRequestStatus.waitingForConfirmation)
                  .mapToList((pairRequest) => _buildRequest(pairRequest)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCodeCard(BuildContext context, int? code) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: cardCircularRadius),
      color: colorScheme.primaryContainer,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(standardGapSize),
        child: Text(
          '$code',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildRequest(PairRequest pairRequest) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: smallGapSize),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: smallGapSize,
        children: [
          Text('code: ${pairRequest.code}'),
          if (pairRequest.status == PairRequestStatus.waitingForConfirmation) _buildAcceptRejectButtons(pairRequest),
        ],
      ),
    );
  }

  Widget _buildAcceptRejectButtons(PairRequest pairRequest) {
    final requestId = pairRequest.id;
    return Row(
      spacing: smallGapSize,
      children: [
        ElevatedButton(
          // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => _pairingService.updatePairRequestStatus(requestId, PairRequestStatus.rejected),
          child: Text('Reject'),
        ),
        ElevatedButton(
          onPressed: () {
            _pairingService.updatePairRequestStatus(requestId, PairRequestStatus.accepted);
            // TODO(betka): ! could be dangerous
            _pairingService.pairDevices(pairRequest.watchId!);
          },
          child: Text('Accept'),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _pairingService.createPairingDoc();
  }
}
