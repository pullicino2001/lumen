import '../models/film_stock.dart';

/// All film stocks available in the app, in display order.
const List<FilmStock> kFilmStocks = [
  // ── Kodak Portra 400 ────────────────────────────────────────────────────
  // Natural skin tones, subtle warmth, smooth highlight rolloff, fine grain.
  FilmStock(
    id: 'portra_400',
    name: 'Portra 400',
    description: 'Natural warmth, smooth highlights, timeless portraits',
    colourMatrix: [
      1.02,  0.01, -0.01,   // R row: slight warm boost
      0.00,  1.01,  0.01,   // G row: near-identity
     -0.03, -0.01,  0.96,   // B row: slight blue reduction
    ],
    redCurve:   [0.020, 0.85, 0.82, 2.0],
    greenCurve: [0.020, 0.87, 0.83, 1.9],
    blueCurve:  [0.015, 0.88, 0.80, 2.2],
    shadowHueDeg: 5.0,    shadowHueStrength: 0.20,
    highlightHueDeg: 3.0, highlightHueStrength: 0.12,
    halationTint: [1.0, 0.38, 0.08],
    intensity: 85.0,
  ),

  // ── Kodak Gold 200 ──────────────────────────────────────────────────────
  // Warm, saturated, golden shadows. The classic consumer Kodak look.
  FilmStock(
    id: 'gold_200',
    name: 'Gold 200',
    description: 'Warm golden tones, punchy shadows, saturated colours',
    colourMatrix: [
      1.05,  0.02, -0.01,   // R row: stronger warm
      0.00,  1.02,  0.00,   // G row: slight green push
     -0.05, -0.03,  0.91,   // B row: compressed blues
    ],
    redCurve:   [0.035, 0.82, 0.78, 2.5],
    greenCurve: [0.025, 0.84, 0.80, 2.2],
    blueCurve:  [0.010, 0.92, 0.76, 3.0],
    shadowHueDeg: 14.0,   shadowHueStrength: 0.35,
    highlightHueDeg: 7.0, highlightHueStrength: 0.22,
    halationTint: [1.0, 0.42, 0.05],
    intensity: 85.0,
  ),

  // ── Cinestill 800T ──────────────────────────────────────────────────────
  // Tungsten-balanced motion picture stock. Cool cast in daylight, famous
  // warm orange halation (the rem-jet effect). High grain, filmic contrast.
  FilmStock(
    id: 'cinestill_800t',
    name: 'Cinestill 800T',
    description: 'Tungsten cool cast, warm halation glow, cinematic grain',
    colourMatrix: [
      0.91, -0.02,  0.02,   // R row: red pulled back
      0.00,  0.97,  0.01,   // G row: slight reduction
      0.07,  0.05,  1.13,   // B row: strong blue push
    ],
    redCurve:   [0.010, 0.95, 0.73, 3.0],
    greenCurve: [0.010, 0.93, 0.75, 2.8],
    blueCurve:  [0.030, 0.87, 0.83, 2.0],
    shadowHueDeg: -16.0,   shadowHueStrength: 0.42,
    highlightHueDeg: 22.0, highlightHueStrength: 0.50,
    halationTint: [1.0, 0.20, 0.00],   // intense warm orange
    intensity: 85.0,
  ),

  // ── Fuji Superia 400 ────────────────────────────────────────────────────
  // Green cast (especially in shadows), punchy colours, slightly cool.
  // The distinctive Fuji look — distinct from any Kodak stock.
  FilmStock(
    id: 'superia_400',
    name: 'Superia 400',
    description: 'Green-tinged shadows, punchy colours, cool Fuji character',
    colourMatrix: [
      0.97, -0.01,  0.01,   // R row: slight red reduction
      0.02,  1.03,  0.02,   // G row: green lifted
     -0.01,  0.02,  0.98,   // B row: near-identity
    ],
    redCurve:   [0.012, 0.90, 0.82, 1.9],
    greenCurve: [0.028, 0.86, 0.83, 1.9],
    blueCurve:  [0.018, 0.88, 0.81, 2.0],
    shadowHueDeg: -10.0,   shadowHueStrength: 0.30,
    highlightHueDeg: -4.0, highlightHueStrength: 0.15,
    halationTint: [0.82, 0.48, 0.18],   // cooler, less orange
    intensity: 85.0,
  ),

  // ── Kodak Tri-X 400 ─────────────────────────────────────────────────────
  // Classic black-and-white. Deep blacks, compressed highlights, chunky
  // silver-halide grain character.
  FilmStock(
    id: 'trix_400',
    name: 'Tri-X 400',
    description: 'High-contrast black and white, classic silver grain',
    colourMatrix: [
      0.299, 0.587, 0.114,   // R row: luminance
      0.299, 0.587, 0.114,   // G row: luminance
      0.299, 0.587, 0.114,   // B row: luminance
    ],
    redCurve:   [0.010, 1.05, 0.76, 3.2],
    greenCurve: [0.010, 1.05, 0.76, 3.2],
    blueCurve:  [0.010, 1.05, 0.76, 3.2],
    shadowHueDeg: 0.0, shadowHueStrength: 0.0,
    highlightHueDeg: 0.0, highlightHueStrength: 0.0,
    halationTint: [0.95, 0.90, 0.85],   // subtle warm paper base
    intensity: 85.0,
  ),
];
