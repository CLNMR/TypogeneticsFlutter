import 'amino_acids.dart';
import 'base.dart';
import 'enzyme.dart';

class Strand {
  Strand({List<Base?>? bases}) : bases = bases ?? [];

  factory Strand.fromStr(String str) {
    final bases = str.split('').map((e) {
      switch (e) {
        case 'A':
          return Base.A;
        case 'T':
          return Base.T;
        case 'C':
          return Base.C;
        case 'G':
          return Base.G;
        case ' ':
          return null;
        default:
          throw Exception('Invalid base: $e');
      }
    }).toList();
    return Strand(bases: bases);
  }

  List<Base?> bases;

  List<Strand> splitAtBreaks({bool reversed = false}) {
    final splitBases = <Strand>[];
    var currentList = <Base>[];

    final reversedBases = bases.reversed;

    for (final base in reversed ? reversedBases : bases) {
      if (base == null) {
        if (currentList.isNotEmpty) {
          splitBases.add(Strand(bases: currentList));
          currentList = [];
        }
      } else {
        currentList.add(base);
      }
    }

    if (currentList.isNotEmpty) {
      splitBases.add(Strand(bases: currentList));
    }

    return splitBases;
  }

  List<Enzyme> translate() {
    final enzymes = <Enzyme>[];
    var currentAminoAcids = <AminoAcids>[];
    for (var i = 0; i < bases.length - 1; i += 2) {
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

  @override
  String toString() {
    final baseStr = bases.map((base) => base?.name ?? ' ').join();
    return baseStr;
  }
}
