import 'base.dart';
import 'strand.dart';

class StrandProcessing {
  StrandProcessing(this.mainStrand, this.currentIndex,
      {Strand? secondaryStrand, this.copyMode = false})
      : secondaryStrand = secondaryStrand ??
            Strand(
                bases: List<Base?>.filled(mainStrand.bases.length, null,
                    growable: true));

  final Strand mainStrand;
  final Strand secondaryStrand;

  int? currentIndex;
  bool copyMode;

  List<Strand> getStrands() => [
        ...mainStrand.splitAtBreaks(),
        ...secondaryStrand.splitAtBreaks(reversed: true)
      ];
}
