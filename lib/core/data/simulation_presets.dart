import '../models/film_stock.dart';

class SimulationCamera {
  const SimulationCamera({
    required this.id,
    required this.name,
    required this.shortName,
    required this.promptDescriptor,
  });

  final String id;
  final String name;
  final String shortName;
  final String promptDescriptor;
}

class SimulationLens {
  const SimulationLens({
    required this.id,
    required this.name,
    required this.promptDescriptor,
  });

  final String id;
  final String name;
  final String promptDescriptor;
}

const List<SimulationCamera> kSimulationCameras = [
  SimulationCamera(
    id: 'leica_m6',
    name: 'Leica M6',
    shortName: 'M6',
    promptDescriptor:
        'Leica M6 rangefinder camera, precise tonal balance, natural perspective, street photography rendering, clean mechanical quality',
  ),
  SimulationCamera(
    id: 'canon_ae1',
    name: 'Canon AE-1',
    shortName: 'AE-1',
    promptDescriptor:
        'Canon AE-1 SLR camera, warm nostalgic 1970s-80s aesthetic, rich midtones, classic consumer film look',
  ),
  SimulationCamera(
    id: 'nikon_f3',
    name: 'Nikon F3',
    shortName: 'F3',
    promptDescriptor:
        'Nikon F3 professional SLR, sharp and accurate, high contrast rendering, journalistic photographic quality',
  ),
  SimulationCamera(
    id: 'contax_t2',
    name: 'Contax T2',
    shortName: 'T2',
    promptDescriptor:
        'Contax T2 compact 35mm camera with Zeiss lens, razor-sharp rendering, beautiful bokeh, slightly cool tones, luxury snap aesthetic',
  ),
  SimulationCamera(
    id: 'pentax_67',
    name: 'Pentax 67',
    shortName: 'P67',
    promptDescriptor:
        'Pentax 67 medium format SLR, expansive tonal range, three-dimensional depth, large-negative quality, painterly rendering',
  ),
  SimulationCamera(
    id: 'hasselblad_500',
    name: 'Hasselblad 500',
    shortName: 'H500',
    promptDescriptor:
        'Hasselblad 500C/M medium format camera, clinical precision, modular Scandinavian engineering, exceptional sharpness, luxury portrait quality',
  ),
  SimulationCamera(
    id: 'mamiya_rb67',
    name: 'Mamiya RB67',
    shortName: 'RB67',
    promptDescriptor:
        'Mamiya RB67 medium format studio camera, extremely detailed tonal gradations, creamy highlight transitions, portrait-optimised rendering',
  ),
];

const List<SimulationLens> kSimulationLenses = [
  SimulationLens(
    id: 'lens_28mm',
    name: '28mm f/2.8',
    promptDescriptor:
        '28mm wide-angle lens, expansive field of view, subtle barrel distortion at edges, environmental depth, immersive perspective',
  ),
  SimulationLens(
    id: 'lens_35mm',
    name: '35mm f/1.4',
    promptDescriptor:
        '35mm f/1.4 lens, classic street focal length, smooth bokeh at wide aperture, slight wide-angle character, reportage quality',
  ),
  SimulationLens(
    id: 'lens_50mm',
    name: '50mm f/1.4',
    promptDescriptor:
        '50mm f/1.4 standard lens, natural human-eye perspective, clean rendering, creamy out-of-focus areas, versatile neutral character',
  ),
  SimulationLens(
    id: 'lens_85mm',
    name: '85mm f/1.8',
    promptDescriptor:
        '85mm f/1.8 portrait lens, compressed background, flattering facial perspective, smooth spherical bokeh, subject isolation',
  ),
  SimulationLens(
    id: 'lens_105mm',
    name: '105mm f/2.5',
    promptDescriptor:
        '105mm f/2.5 classic portrait lens, strong subject compression, swirly Petzval-influenced bokeh, dramatic background separation',
  ),
];

String buildSimulationPrompt({
  required SimulationCamera camera,
  required SimulationLens lens,
  FilmStock? stock,
}) {
  final filmPart = stock != null
      ? '${stock.name} film stock, ${stock.description}'
      : 'natural colour rendering, no specific film stock';

  return 'Analog photograph shot on ${camera.promptDescriptor}, '
      'using ${lens.promptDescriptor}, '
      'loaded with $filmPart. '
      'Photorealistic analog film simulation. '
      'Preserve the exact scene composition, subject positioning, and lighting direction. '
      'Maintain all people and objects from the original. '
      'Film grain, optical character, authentic analog aesthetic.';
}
