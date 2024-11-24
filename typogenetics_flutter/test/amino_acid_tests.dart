import 'package:test/test.dart';
import 'package:typogenetics_flutter/models/amino_acids.dart';
import 'package:typogenetics_flutter/models/base.dart';
import 'package:typogenetics_flutter/models/strand.dart';
import 'package:typogenetics_flutter/models/strand_processing.dart';

void main() {
  test('cut function works', () {
    // Arrange
    final mainStrand =
        Strand([Base.A, Base.C, Base.G, null, Base.T, Base.A, Base.A, Base.T]);
    final secondaryStrand =
        Strand([null, Base.T, Base.T, Base.A, Base.C, Base.C, null, null]);
    final strandsProcessing = StrandProcessing(
      mainStrand,
      5,
      secondaryStrand: secondaryStrand,
    );

    // Act
    AminoAcids.cut.process(strandsProcessing);

    // Assert
    expect(mainStrand.bases,
        [Base.A, Base.C, Base.G, null, Base.T, Base.A, null, Base.A, Base.T]);
    expect(secondaryStrand.bases,
        [null, Base.T, null, Base.T, Base.A, Base.C, Base.C, null, null]);
  });
}
