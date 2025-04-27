import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/pair/enum/pair_request_status.dart';
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
  int? _sentCode;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Center(
        child: HandlingStreamBuilder(
          stream: _pairingService.getPairLinksPerCurrentWatch,
          builder: (context, pairLinks) {
            if (pairLinks.isNotEmpty) {
              final pairLink = pairLinks.first;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Paired with ${pairLink.deviceName}'),
                  ElevatedButton(
                      onPressed: () {
                        setState(() => _sentCode = null);
                        _pairingService.unpairDevices(pairLink.id);
                      },
                      child: Text('Unpair')),
                ],
              );
            }

            return _sentCode == null ? _buildTextField() : _buildRequestStatus();
          },
        ),
      ),
    );
  }

  Widget _buildRequestStatus() {
    return HandlingStreamBuilder(
      stream: _pairingService.requestsByCodeStream(_sentCode!),
      builder: (context, requests) {
        if (requests.isEmpty) {
          // this should never happen
          return Text('No requests found');
        }

        final request = requests.first;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusInfo(request.status),
            ElevatedButton(
              onPressed: () => _pairingService.updatePairRequestStatus(request.id, PairRequestStatus.pending),
              child: Text('Unpair'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusInfo(PairRequestStatus status) {
    final (icon, label) = switch (status) {
      PairRequestStatus.pending => (Icons.hourglass_empty, 'Pending...'),
      PairRequestStatus.waitingForConfirmation => (Icons.hourglass_bottom, 'Waiting...'),
      PairRequestStatus.accepted => (Icons.check_circle_outline_outlined, 'Accepted'),
      PairRequestStatus.rejected => (Icons.cancel_outlined, 'Rejected'),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        Text(label),
      ],
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
        setState(() => _sentCode = code);
      },
    );
  }
}
