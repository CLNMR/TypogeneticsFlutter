import 'base.dart';
import 'strand_processing.dart';
import 'turn_direction.dart';

enum AminoAcids {
  cut('Cut strand(s)', _cut, (Base.A, Base.C), TurnDirection.straight),
  del('Delete a base from a strand', _del, (Base.A, Base.G),
      TurnDirection.straight),
  swi('Switch to other strand', _swi, (Base.A, Base.T), TurnDirection.right),
  mvr('Move one to the right', _mvr, (Base.C, Base.A), TurnDirection.straight),
  mvl('Move one to the left', _mvl, (Base.C, Base.C), TurnDirection.straight),
  cop('Turn on copy mode', _cop, (Base.C, Base.G), TurnDirection.right),
  off('Turn off copy mode', _off, (Base.C, Base.T), TurnDirection.left),
  ina('Insert A', _ina, (Base.G, Base.A), TurnDirection.straight),
  inc('Insert C', _inc, (Base.G, Base.C), TurnDirection.right),
  ing('Insert G', _ing, (Base.G, Base.G), TurnDirection.right),
  int('Insert T', _int, (Base.G, Base.T), TurnDirection.left),
  rpy('Search for Pyrimidine to the right', _rpy, (Base.T, Base.A),
      TurnDirection.right),
  rpu('Search for Purine to the right', _rpu, (Base.T, Base.C),
      TurnDirection.left),
  lpy('Search for Pyrimidine to the left', _lpy, (Base.T, Base.G),
      TurnDirection.left),
  lpu('Search for Purine to the left', _lpu, (Base.T, Base.T),
      TurnDirection.straight);

  const AminoAcids(
      this.description, this.process, this.baseTuple, this.turnDirection);

  final String description;
  final void Function(StrandProcessing strandsProcessing) process;
  final (Base, Base) baseTuple;
  final TurnDirection turnDirection;
}

/// Cut strand(s)
void _cut(StrandProcessing strandsProcessing) {
  final index = strandsProcessing.currentIndex!;
  final mainStrand = strandsProcessing.mainStrand;
  final secondaryStrand = strandsProcessing.secondaryStrand;
  mainStrand.bases.insert(index + 1, null);
  secondaryStrand.bases.insert(index + 1, null);
}

/// Delete a base from a strand
void _del(StrandProcessing strandsProcessing) {
  final index = strandsProcessing.currentIndex!;
  final mainStrand = strandsProcessing.mainStrand;
  final secondaryStrand = strandsProcessing.secondaryStrand;
  final baseOfSecondaryStrand = secondaryStrand.bases[index];
  if (baseOfSecondaryStrand == null) {
    mainStrand.bases.removeAt(index);
    secondaryStrand.bases.removeAt(index);
  } else {
    mainStrand.bases[index] = null;
  }
}

/// Switch to other strand
void _swi(StrandProcessing strandsProcessing) {
  final mainStrand = strandsProcessing.mainStrand;
  final secondaryStrand = strandsProcessing.secondaryStrand;
  strandsProcessing.currentIndex =
      mainStrand.bases.length - strandsProcessing.currentIndex! - 1;
  final temp = mainStrand.bases;
  mainStrand.bases = secondaryStrand.bases.reversed.toList();
  secondaryStrand.bases = temp.reversed.toList();
}

/// Move one to the right
void _mvr(StrandProcessing strandsProcessing) {
  _move(strandsProcessing, 1);
}

/// Move one to the left
void _mvl(StrandProcessing strandsProcessing) {
  _move(strandsProcessing, -1);
}

void _move(StrandProcessing strandsProcessing, int offset) {
  strandsProcessing.currentIndex = strandsProcessing.currentIndex! + offset;
  if (strandsProcessing.currentIndex! <= 0 ||
      strandsProcessing.currentIndex! >=
          strandsProcessing.mainStrand.bases.length ||
      strandsProcessing.mainStrand.bases[strandsProcessing.currentIndex!] ==
          null) {
    strandsProcessing.currentIndex = null;
  } else {
    if (strandsProcessing.copyMode) {
      strandsProcessing.secondaryStrand.bases[strandsProcessing.currentIndex!] =
          strandsProcessing
              .mainStrand.bases[strandsProcessing.currentIndex!]!.complementary;
    }
  }
}

/// Turn on copy mode
void _cop(StrandProcessing strandsProcessing) {
  strandsProcessing.copyMode = true;
  final index = strandsProcessing.currentIndex!;
  final mainStrand = strandsProcessing.mainStrand;
  final secondaryStrand = strandsProcessing.secondaryStrand;
  secondaryStrand.bases[index] = mainStrand.bases[index]!.complementary;
}

/// Turn off copy mode
void _off(StrandProcessing strandsProcessing) {
  strandsProcessing.copyMode = false;
}

/// Insert A
void _ina(StrandProcessing strandsProcessing) {
  _insertBase(strandsProcessing, Base.A);
}

/// Insert C
void _inc(StrandProcessing strandsProcessing) {
  _insertBase(strandsProcessing, Base.C);
}

/// Insert G
void _ing(StrandProcessing strandsProcessing) {
  _insertBase(strandsProcessing, Base.G);
}

/// Insert T
void _int(StrandProcessing strandsProcessing) {
  _insertBase(strandsProcessing, Base.T);
}

void _insertBase(StrandProcessing strandsProcessing, Base base) {
  final index = strandsProcessing.currentIndex! + 1;
  final mainStrand = strandsProcessing.mainStrand;
  final secondaryStrand = strandsProcessing.secondaryStrand;
  mainStrand.bases.insert(index, base);
  if (strandsProcessing.copyMode) {
    secondaryStrand.bases.insert(index, base.complementary);
  } else {
    secondaryStrand.bases.insert(index, null);
  }
  strandsProcessing.currentIndex = index;
}

/// Search for Pyrimidine to the right
void _rpy(StrandProcessing strandsProcessing) {
  _move(strandsProcessing, 1);
  while (strandsProcessing.currentIndex != null &&
      !strandsProcessing
          .mainStrand.bases[strandsProcessing.currentIndex!]!.isPyrimidine) {
    _move(strandsProcessing, 1);
  }
}

/// Search for Purine to the right
void _rpu(StrandProcessing strandsProcessing) {
  _move(strandsProcessing, 1);
  while (strandsProcessing.currentIndex != null &&
      !strandsProcessing
          .mainStrand.bases[strandsProcessing.currentIndex!]!.isPurine) {
    _move(strandsProcessing, 1);
  }
}

/// Search for Pyrimidine to the left
void _lpy(StrandProcessing strandsProcessing) {
  _move(strandsProcessing, -1);
  while (strandsProcessing.currentIndex != null &&
      !strandsProcessing
          .mainStrand.bases[strandsProcessing.currentIndex!]!.isPyrimidine) {
    _move(strandsProcessing, -1);
  }
}

/// Search for Purine to the left
void _lpu(StrandProcessing strandsProcessing) {
  _move(strandsProcessing, -1);
  while (strandsProcessing.currentIndex != null &&
      !strandsProcessing
          .mainStrand.bases[strandsProcessing.currentIndex!]!.isPurine) {
    _move(strandsProcessing, -1);
  }
}
