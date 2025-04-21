enum PairRequestStatus {
  pending('pending'),
  waitingForConfirmation('waitingForConfirmation'),
  accepted('accepted'),
  rejected('rejected');

  final String value;

  const PairRequestStatus(this.value);
}
