import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/core/models/baseline_profile.dart';

Map<String, dynamic> _json({
  List<List<num>> rows = const [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
  List<Map<String, num>> points = const [
    {'input': 0, 'output': 0},
    {'input': 0.5, 'output': 0.6},
    {'input': 1, 'output': 1},
  ],
}) =>
    {
      'name': 'test',
      'version': '1',
      'description': 'd',
      'grading_matrix': {'rows': rows},
      'tone_curve': {'control_points': points},
      'saturation': {'multiplier': 0.9},
      'vignette': {'enabled': true, 'strength': 0.2, 'radius': 0.6, 'feather': 0.3},
      'sharpening': {'radius': 2, 'amount': 0.5, 'threshold': 0.02},
    };

void main() {
  group('BaselineProfile', () {
    test('parses and interpolates the tone curve', () {
      final p = BaselineProfile.fromJson(_json());
      expect(p.gradingMatrixFlat, [1, 0, 0, 0, 1, 0, 0, 0, 1]);
      expect(p.evaluateToneCurve(0.25), closeTo(0.3, 1e-9));
      expect(p.evaluateToneCurve(0.5), closeTo(0.6, 1e-9));
      expect(p.evaluateToneCurve(-1), 0);
      expect(p.evaluateToneCurve(2), 1);
    });

    test('sorts unordered control points', () {
      final p = BaselineProfile.fromJson(_json(points: [
        {'input': 1, 'output': 1},
        {'input': 0, 'output': 0},
        {'input': 0.5, 'output': 0.6},
      ]));
      expect(p.toneCurvePoints.map((e) => e.$1).toList(), [0, 0.5, 1]);
      expect(p.evaluateToneCurve(0.25), closeTo(0.3, 1e-9));
    });

    test('treats duplicate inputs as a step instead of dividing by zero', () {
      final p = BaselineProfile.fromJson(_json(points: [
        {'input': 0, 'output': 0},
        {'input': 0.5, 'output': 0.4},
        {'input': 0.5, 'output': 0.6},
        {'input': 1, 'output': 1},
      ]));
      final y = p.evaluateToneCurve(0.5);
      expect(y.isNaN, isFalse);
      expect(y, anyOf(0.4, 0.6));
    });

    test('rejects a non-3x3 grading matrix', () {
      expect(
        () => BaselineProfile.fromJson(_json(rows: [[1, 0], [0, 1]])),
        throwsFormatException,
      );
    });

    test('rejects an empty tone curve', () {
      expect(
        () => BaselineProfile.fromJson(_json(points: const [])),
        throwsFormatException,
      );
    });
  });
}
