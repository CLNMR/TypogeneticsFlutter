// ignore_for_file: avoid_print

import 'models/enzyme.dart';
import 'models/strand.dart';

void main() {
  var strands = [Strand.fromStr('AACGCA')]; // cSpell:disable-line
  final enzymes = <Enzyme>[];

  for (var i = 0; i < 2; i++) {
    enzymes.clear();
    for (final strand in strands) {
      print(strand);
      final enzymesFromStrand = strand.translate();
      for (final enzyme in enzymesFromStrand) {
        print('=> $enzyme');
      }
      enzymes.addAll(enzymesFromStrand);
      print('');
    }
    print('--- Enzymes: ${enzymes.length} ---\n');

    for (final enzyme in enzymes) {
      print(enzyme);
      final newStrands = <Strand>[];
      for (final strand in strands) {
        print('  $strand');
        final strandsFromEnzymeAndStrand = enzyme.process(strand);
        for (final strand in strandsFromEnzymeAndStrand) {
          print('  => $strand');
        }
        newStrands.addAll(strandsFromEnzymeAndStrand);
        print('');
      }
      strands = newStrands.toList();
    }
    print('--- Strands: ${strands.length} ---\n');
  }
}
