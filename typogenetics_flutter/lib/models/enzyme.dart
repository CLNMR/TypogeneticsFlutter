import 'amino_acids.dart';
import 'base.dart';
import 'strand.dart';
import 'strand_processing.dart';

class Enzyme {
  Enzyme(this.aminoAcids);

  final List<AminoAcids> aminoAcids;

  Base get attachesTo {
    final index = aminoAcids.skip(1).take(aminoAcids.length - 2).fold(
        0, (index, aminoAcid) => index + aminoAcid.turnDirection.indexChange);
    return [Base.A, Base.G, Base.T, Base.C][index % 4];
  }

  List<Strand> process(Strand strand) {
    int? attachIndex = strand.bases.indexWhere((base) => base == attachesTo);
    if (attachIndex == -1) attachIndex = null;
    final strandProcessing = StrandProcessing(strand, attachIndex);
    for (final aminoAcid in aminoAcids) {
      if (strandProcessing.currentIndex == null) {
        break;
      }
      aminoAcid.process(strandProcessing);
    }
    return strandProcessing.getStrands();
  }

  void add(AminoAcids aminoAcid) {
    aminoAcids.add(aminoAcid);
  }
}
