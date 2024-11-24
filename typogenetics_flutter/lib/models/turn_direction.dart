enum TurnDirection {
  left(-1),
  right(1),
  straight(0);

  const TurnDirection(this.indexChange);

  final int indexChange;
}
