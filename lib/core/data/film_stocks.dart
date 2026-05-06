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
    promptFragment:
        'Kodak Portra 400 film rendering — warm amber-golden skin tones with '
        'exceptional smoothness, rich saturated reds and oranges with depth and '
        'detail retention, slightly muted natural blues, warm midtone bias '
        'throughout the colour palette, characteristic fine Kodak grain '
        'shadow-weighted in darker areas, exceptionally gradual highlight rolloff '
        'through warm transitional zone before clipping, generous exposure latitude '
        'with organic tonal depth',
  ),

  // ── Kodak Portra 160 ────────────────────────────────────────────────────
  // Identical colour science to Portra 400 but with near-invisible fine grain.
  FilmStock(
    id: 'portra_160',
    name: 'Portra 160',
    description: 'Portra warmth at lower ISO — finest grain, maximum refinement',
    tier: StockTier.pro,
    colourMatrix: [
      1.01,  0.01, -0.01,
      0.00,  1.01,  0.01,
     -0.02, -0.01,  0.97,
    ],
    redCurve:   [0.018, 0.86, 0.83, 1.95],
    greenCurve: [0.018, 0.88, 0.84, 1.85],
    blueCurve:  [0.012, 0.89, 0.82, 2.10],
    shadowHueDeg: 4.0,    shadowHueStrength: 0.15,
    highlightHueDeg: 2.0, highlightHueStrength: 0.10,
    halationTint: [1.0, 0.38, 0.08],
    intensity: 85.0,
    promptFragment:
        'Kodak Portra 160 film rendering — warm amber-golden skin tones with '
        'exceptional smoothness, identical colour science to Portra 400 with '
        'finer grain approaching invisible at normal viewing, rich reds and warm '
        'midtones, gradual highlight rolloff, classic Kodak Portra portrait palette '
        'at lower ISO with maximum tonal refinement — ideal conditions portrait '
        'rendering',
  ),

  // ── Kodak Ektar 100 ─────────────────────────────────────────────────────
  // Cool, highly saturated. Extraordinary blues. Not a portrait film.
  FilmStock(
    id: 'ektar_100',
    name: 'Ektar 100',
    description: 'Vivid saturated colour, extraordinary blues, precision landscape film',
    tier: StockTier.pro,
    colourMatrix: [
      1.04, -0.01, -0.02,   // R row: vivid reds
     -0.01,  1.02,  0.00,   // G row: slight green push
     -0.04, -0.02,  1.09,   // B row: strong blue saturation
    ],
    redCurve:   [0.000, 0.95, 0.82, 2.1],
    greenCurve: [0.005, 0.93, 0.84, 1.9],
    blueCurve:  [0.010, 0.89, 0.83, 1.8],
    shadowHueDeg: -8.0,    shadowHueStrength: 0.25,
    highlightHueDeg: 0.0,  highlightHueStrength: 0.05,
    halationTint: [0.90, 0.50, 0.22],
    intensity: 85.0,
    promptFragment:
        'Kodak Ektar 100 film rendering — high saturation vivid colour with '
        'precise cool-leaning palette, extraordinary blue saturation in sky and '
        'water, vivid reds and oranges with jewel-like precision, cool green '
        'foliage rendering, clean bright whites and cool-leaning grey neutrals, '
        'extremely fine nearly-invisible grain structure, slightly reduced exposure '
        'latitude compared to Portra — demands precise exposure for optimal colour '
        'saturation',
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
    promptFragment:
        'Kodak Gold 200 film rendering — saturated warm golden colour palette, '
        'boosted reds and oranges with deep compressed blues, punchy shadow '
        'rendering with golden warm tone bias throughout, consumer film warmth '
        'with characteristic colour saturation, moderate grain with vintage '
        'holiday photograph aesthetic',
  ),

  // ── Cinestill 800T ──────────────────────────────────────────────────────
  // Tungsten-balanced motion picture stock. Cool cast in daylight, famous
  // warm orange halation (the rem-jet effect). High grain, filmic contrast.
  FilmStock(
    id: 'cinestill_800t',
    name: 'Cinestill 800T',
    description: 'Tungsten cool cast, warm halation glow, cinematic grain',
    tier: StockTier.pro,
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
    halationTint: [1.0, 0.20, 0.00],
    intensity: 85.0,
    promptFragment:
        'Cinestill 800T film rendering — tungsten-balanced night city colour '
        'science with deep blue-teal shadows, characteristic warm orange halation '
        'glow surrounding bright light sources (neon, street lamps, windows), '
        'motion-picture film character without anti-halation backing, cool colour '
        'cast in shadow and ambient areas contrasting with warm halation blooms, '
        'cinematic available-light quality with dreamlike light source rendering',
  ),

  // ── Cinestill 400D ──────────────────────────────────────────────────────
  // Daylight-balanced counterpart to 800T. Accurate filmic colour in daylight,
  // halation still present but with cooler daylight-toned halos.
  FilmStock(
    id: 'cinestill_400d',
    name: 'Cinestill 400D',
    description: 'Daylight-balanced cinematic colour with characteristic halation',
    tier: StockTier.pro,
    colourMatrix: [
      1.01,  0.00,  0.00,
      0.00,  1.00,  0.00,
      0.00,  0.00,  1.01,
    ],
    redCurve:   [0.015, 0.90, 0.78, 2.5],
    greenCurve: [0.015, 0.92, 0.80, 2.3],
    blueCurve:  [0.015, 0.90, 0.76, 2.8],
    shadowHueDeg: -5.0,    shadowHueStrength: 0.20,
    highlightHueDeg: 8.0,  highlightHueStrength: 0.25,
    halationTint: [1.0, 0.42, 0.18],
    intensity: 85.0,
    promptFragment:
        'Cinestill 400D film rendering — daylight-balanced motion-picture colour '
        'with accurate natural rendering in ambient light, characteristic halation '
        'glow around bright light sources with cooler daylight-toned halos, subtle '
        'filmic colour character without 800T\'s strong tungsten cast, clean '
        'midtones with smooth tonal transitions, cinematic quality in natural '
        'light conditions',
  ),

  // ── Fuji Velvia 50 ──────────────────────────────────────────────────────
  // Hyper-saturated slide film. Landscape and nature photography.
  // Steep contrast, vivid blues, luminous greens.
  FilmStock(
    id: 'velvia_50',
    name: 'Velvia 50',
    description: 'Hyper-saturated vivid colour, extraordinary blues, landscape film',
    tier: StockTier.pro,
    colourMatrix: [
      1.06,  0.00, -0.08,   // R row: vivid reds
     -0.01,  1.07, -0.02,   // G row: luminous greens
     -0.09, -0.04,  1.16,   // B row: extraordinary blue boost
    ],
    redCurve:   [0.000, 1.02, 0.72, 3.6],
    greenCurve: [0.000, 1.01, 0.74, 3.4],
    blueCurve:  [0.000, 1.01, 0.75, 3.0],
    shadowHueDeg: -15.0,   shadowHueStrength: 0.45,
    highlightHueDeg: 0.0,  highlightHueStrength: 0.05,
    halationTint: [0.82, 0.55, 0.15],
    intensity: 85.0,
    promptFragment:
        'Fujifilm Velvia 50 slide film rendering — hyper-saturated vivid colour '
        'beyond natural reality, extraordinary deep blue sky and water saturation, '
        'luminous intense green foliage, vivid warm reds and sunset colours, deep '
        'blue-teal shadow rendering, steep contrast curve with quick shadow falloff '
        'and compressed highlight rolloff, near-invisible fine grain, landscape and '
        'nature photography with maximum colour impact',
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
    halationTint: [0.82, 0.48, 0.18],
    intensity: 85.0,
    promptFragment:
        'Fujifilm Superia 400 film rendering — characteristic green-tinged cool '
        'Fuji colour palette, slight green shadow cast, punchy saturated colours '
        'with Fuji\'s natural cool bias, visible grain with good fine detail, '
        'cool midtone rendering contrasting with warm light sources',
  ),

  // ── Fuji Acros 100 ──────────────────────────────────────────────────────
  // Finest-quality B&W. Near-invisible grain, exceptional shadow detail,
  // medium contrast. Fine-art and landscape photography.
  FilmStock(
    id: 'acros_100',
    name: 'Acros 100',
    description: 'Finest-quality black and white — near-invisible grain, exceptional shadow detail',
    tier: StockTier.pro,
    colourMatrix: [
      0.299, 0.587, 0.114,
      0.299, 0.587, 0.114,
      0.299, 0.587, 0.114,
    ],
    redCurve:   [0.005, 0.97, 0.83, 1.8],
    greenCurve: [0.005, 0.97, 0.83, 1.8],
    blueCurve:  [0.005, 0.97, 0.83, 1.8],
    shadowHueDeg: 0.0, shadowHueStrength: 0.0,
    highlightHueDeg: 0.0, highlightHueStrength: 0.0,
    halationTint: [0.95, 0.92, 0.90],
    intensity: 85.0,
    promptFragment:
        'Fujifilm Acros 100 film rendering — technically refined fine-art black '
        'and white, exceptional shadow detail retention with smooth shadow-to-midtone '
        'transitions, full rich midtone rendering with organic tonal depth, gradual '
        'highlight rolloff, nearly invisible fine regular grain at base ISO, medium '
        'contrast with full tonal range — the highest-quality B&W film rendering, '
        'suited to fine art and landscape photography',
  ),

  // ── Ilford HP5 Plus 400 ─────────────────────────────────────────────────
  // British B&W with refined tonal nuance. Medium-high contrast.
  // More shadow detail than Tri-X, slightly less chunky grain.
  FilmStock(
    id: 'hp5_plus',
    name: 'HP5 Plus',
    description: 'British B&W with refined tone — versatile portrait and documentary film',
    tier: StockTier.pro,
    colourMatrix: [
      0.299, 0.587, 0.114,
      0.299, 0.587, 0.114,
      0.299, 0.587, 0.114,
    ],
    redCurve:   [0.010, 1.02, 0.78, 2.8],
    greenCurve: [0.010, 1.02, 0.78, 2.8],
    blueCurve:  [0.010, 1.02, 0.78, 2.8],
    shadowHueDeg: 0.0, shadowHueStrength: 0.0,
    highlightHueDeg: 0.0, highlightHueStrength: 0.0,
    halationTint: [0.95, 0.91, 0.87],
    intensity: 85.0,
    promptFragment:
        'Ilford HP5 Plus 400 film rendering — British B&W with refined tonal '
        'nuance, medium-high contrast with better shadow detail retention than '
        'Tri-X, rich differentiated midtones with film grain texture, gradual '
        'highlight rolloff, characteristic silver-halide grain visible but '
        'slightly less chunky than Tri-X, versatile tonal range suited to '
        'portrait, documentary and architectural work',
  ),

  // ── Ilford Delta 400 Professional ───────────────────────────────────────
  // Tabular-grain B&W. Finer and more regular than HP5 or Tri-X.
  // Medium contrast with excellent shadow and highlight latitude.
  FilmStock(
    id: 'delta_400',
    name: 'Delta 400',
    description: 'Finest-grain ISO 400 B&W — precise tabular grain, modern refinement',
    tier: StockTier.pro,
    colourMatrix: [
      0.299, 0.587, 0.114,
      0.299, 0.587, 0.114,
      0.299, 0.587, 0.114,
    ],
    redCurve:   [0.005, 0.99, 0.80, 2.3],
    greenCurve: [0.005, 0.99, 0.80, 2.3],
    blueCurve:  [0.005, 0.99, 0.80, 2.3],
    shadowHueDeg: 0.0, shadowHueStrength: 0.0,
    highlightHueDeg: 0.0, highlightHueStrength: 0.0,
    halationTint: [0.94, 0.91, 0.89],
    intensity: 85.0,
    promptFragment:
        'Ilford Delta 400 Professional film rendering — fine tabular-grain B&W '
        'with precise tonal rendering, excellent shadow detail in lower registers, '
        'careful midtone separation, gradual highlight rolloff, refined grain '
        'character finer than conventional crystal films, medium contrast with '
        'full tonal latitude, modern high-quality B&W rendering bridging film '
        'and digital quality',
  ),

  // ── Kodak Tri-X 400 ─────────────────────────────────────────────────────
  // Classic black-and-white. Deep blacks, compressed highlights, chunky
  // silver-halide grain character.
  FilmStock(
    id: 'trix_400',
    name: 'Tri-X 400',
    description: 'High-contrast black and white, classic silver grain',
    colourMatrix: [
      0.299, 0.587, 0.114,
      0.299, 0.587, 0.114,
      0.299, 0.587, 0.114,
    ],
    redCurve:   [0.010, 1.05, 0.76, 3.2],
    greenCurve: [0.010, 1.05, 0.76, 3.2],
    blueCurve:  [0.010, 1.05, 0.76, 3.2],
    shadowHueDeg: 0.0, shadowHueStrength: 0.0,
    highlightHueDeg: 0.0, highlightHueStrength: 0.0,
    halationTint: [0.95, 0.90, 0.85],
    intensity: 85.0,
    promptFragment:
        'Kodak Tri-X 400 film rendering — high-contrast photojournalistic black '
        'and white, deep dense blacks with compressed shadow transitions, full '
        'midtone separation, slightly compressed highlights with gradual rolloff, '
        'characteristic chunky irregular silver-halide grain shadow-weighted in '
        'dark regions, documentary authority and graphic tonal depth, classic '
        'photojournalism aesthetic from 1950s–present',
  ),
];
