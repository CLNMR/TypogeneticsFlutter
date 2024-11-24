import 'package:test/test.dart';
import 'package:typogenetics_flutter/models/amino_acids.dart';
import 'package:typogenetics_flutter/models/base.dart';
import 'package:typogenetics_flutter/models/strand.dart';
import 'package:typogenetics_flutter/models/strand_processing.dart';

void main() {
  setUp(() {});

  test('cut function works', () {
    // Arrange
    final mainStrand =
        Strand([Base.A, Base.C, Base.G, null, Base.T, Base.A, Base.A, Base.T]);
    final secondaryStrand =
        Strand([null, null, Base.C, Base.C, Base.A, Base.T, Base.T, null]);
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
        [null, null, Base.C, Base.C, Base.A, Base.T, null, Base.T, null]);
  });

  test('delete function works on single strand', () {
    // Arrange
    final mainStrand = Strand(<Base?>[Base.A, Base.C, Base.G]);
    final strandsProcessing = StrandProcessing(mainStrand, 1);

    // Act
    AminoAcids.del.process(strandsProcessing);

    // Assert
    expect(mainStrand.bases, [Base.A, Base.G]);
  });

  test('delete function works on both strands', () {
    // Arrange
    final mainStrand = Strand(<Base?>[Base.A, Base.C, Base.G]);
    final secondaryStrand = Strand(<Base?>[Base.T, Base.G, Base.C]);
    final strandsProcessing =
        StrandProcessing(mainStrand, 1, secondaryStrand: secondaryStrand);

    // Act
    AminoAcids.del.process(strandsProcessing);

    // Assert
    expect(mainStrand.bases, [Base.A, null, Base.G]);
    expect(secondaryStrand.bases, [Base.T, Base.G, Base.C]);
  });

  test('switch function works', () {
    // Arrange
    final mainStrand = Strand(<Base?>[Base.A, Base.T, Base.C, Base.G]);
    final secondaryStrand = Strand(<Base?>[Base.T, Base.A, Base.G, Base.C]);
    final strandsProcessing =
        StrandProcessing(mainStrand, 1, secondaryStrand: secondaryStrand);

    // Act
    AminoAcids.swi.process(strandsProcessing);

    // Assert
    expect(mainStrand.bases, [Base.C, Base.G, Base.A, Base.T]);
    expect(secondaryStrand.bases, [Base.G, Base.C, Base.T, Base.A]);
    expect(strandsProcessing.currentIndex, 2);
  });

  test('move right function works', () {
    // Arrange
    final mainStrand = Strand(<Base?>[Base.A, Base.T, Base.C, Base.G]);
    final strandsProcessing = StrandProcessing(mainStrand, 2);

    // Act
    AminoAcids.mvr.process(strandsProcessing);

    // Assert
    expect(strandsProcessing.currentIndex, 3);

    // Act
    AminoAcids.mvr.process(strandsProcessing);

    // Assert
    expect(strandsProcessing.currentIndex, null);
  });

  test('move left function works', () {
    // Arrange
    final mainStrand = Strand(<Base?>[Base.A, null, Base.C, Base.G]);
    final strandsProcessing = StrandProcessing(mainStrand, 3);

    // Act
    AminoAcids.mvl.process(strandsProcessing);

    // Assert
    expect(strandsProcessing.currentIndex, 2);

    // Act
    AminoAcids.mvl.process(strandsProcessing);

    // Assert
    expect(strandsProcessing.currentIndex, null);
  });

  test('insert A function works', () {
    // Arrange
    final mainStrand = Strand(<Base?>[Base.A, Base.T, Base.C, Base.G]);
    final strandsProcessing = StrandProcessing(mainStrand, 1);

    // Act
    AminoAcids.ina.process(strandsProcessing);

    // Assert
    expect(mainStrand.bases, [Base.A, Base.T, Base.A, Base.C, Base.G]);
    expect(strandsProcessing.currentIndex, 2);
  });

  test('insert A in copy mode function works', () {
    // Arrange
    final mainStrand = Strand(<Base?>[Base.A, Base.T, Base.C, Base.G]);
    final strandsProcessing = StrandProcessing(mainStrand, 1, copyMode: true);

    // Act
    AminoAcids.ina.process(strandsProcessing);

    // Assert
    expect(mainStrand.bases, [Base.A, Base.T, Base.A, Base.C, Base.G]);
    expect(strandsProcessing.secondaryStrand.bases,
        [null, null, Base.T, null, null]);
    expect(strandsProcessing.currentIndex, 2);
  });

  test('find pyrimidine to the right function works', () {
    // Arrange
    final mainStrand = Strand([Base.T, Base.A, Base.A, Base.G, Base.C, Base.C]);
    final strandsProcessing = StrandProcessing(mainStrand, 0, copyMode: true);

    // Act
    AminoAcids.rpy.process(strandsProcessing);

    // Assert
    expect(mainStrand.bases, [Base.T, Base.A, Base.A, Base.G, Base.C, Base.C]);
    expect(strandsProcessing.secondaryStrand.bases,
        [null, Base.T, Base.T, Base.C, Base.G, null]);
    expect(strandsProcessing.currentIndex, 4);
  });

  test('find pyrimidine to the right function works with null', () {
    // Arrange
    final mainStrand = Strand([Base.T, Base.A, Base.A, null, Base.C, Base.C]);
    final strandsProcessing = StrandProcessing(mainStrand, 0);

    // Act
    AminoAcids.rpy.process(strandsProcessing);

    // Assert
    expect(mainStrand.bases, [Base.T, Base.A, Base.A, null, Base.C, Base.C]);
    expect(strandsProcessing.secondaryStrand.bases,
        [null, null, null, null, null, null]);
    expect(strandsProcessing.currentIndex, null);
  });
}
