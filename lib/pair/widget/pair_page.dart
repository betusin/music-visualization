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
      stream: _pairingService.currentPendingRequests,
      builder: (context, pairRequests) {
        if (pairRequests.isEmpty) {
          return Text('No requests waiting for acceptance');
        }

        return Column(
          children: pairRequests.mapToList((pairRequest) => _buildRequest(pairRequest)),
        );
      },
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
          // if (pairData.status == PairRequestStatus.waitingForConfirmation)
          _buildAcceptRejectButtons(pairRequest.id),
        ],
      ),
    );
  }

  Widget _buildAcceptRejectButtons(String requestId) {
    return Row(
      spacing: smallGapSize,
      children: [
        ElevatedButton(
          // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => _pairingService.updatePairRequestStatus(requestId, PairRequestStatus.rejected),
          child: Text('Reject'),
        ),
        ElevatedButton(
          onPressed: () => _pairingService.updatePairRequestStatus(requestId, PairRequestStatus.accepted),
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
