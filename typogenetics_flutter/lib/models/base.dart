enum Base {
  A,
  C,
  G,
  T;

  Base get complementary {
    switch (this) {
      case A:
        return T;
      case C:
        return G;
      case G:
        return C;
      case T:
        return A;
    }
  }

  bool get isPurine => this == A || this == G;
  bool get isPyrimidine => this == C || this == T;
}
