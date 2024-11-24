import 'amino_acids.dart';
import 'base.dart';
import 'enzyme.dart';

class Strand {
  Strand(this.bases);

  List<Base?> bases;

  List<Strand> splitAtBreaks({bool reversed = false}) {
    final splitBases = <Strand>[];
    var currentList = <Base>[];

    final reversedBases = bases.reversed;

    for (final base in reversed ? reversedBases : bases) {
      if (base == null) {
        if (currentList.isNotEmpty) {
          splitBases.add(Strand(currentList));
          currentList = [];
        }
      } else {
        currentList.add(base);
      }
    }

    if (currentList.isNotEmpty) {
      splitBases.add(Strand(currentList));
    }

    return splitBases;
  }

  List<Enzyme> translate() {
    final enzymes = <Enzyme>[];
    var currentAminoAcids = <AminoAcids>[];
    for (var i = 0; i < bases.length - 2; i += 2) {
      if (bases[i] == Base.A && bases[i + 1] == Base.A) {
        if (currentAminoAcids.isNotEmpty) {
          enzymes.add(Enzyme(currentAminoAcids));
          currentAminoAcids = [];
        }
      } else {
        currentAminoAcids.add(AminoAcids.values.firstWhere(
            (acid) => acid.baseTuple == (bases[i]!, bases[i + 1]!)));
      }
    }
    if (currentAminoAcids.isNotEmpty) {
      enzymes.add(Enzyme(currentAminoAcids));
      currentAminoAcids = [];
    }
    return enzymes;
  }
}
