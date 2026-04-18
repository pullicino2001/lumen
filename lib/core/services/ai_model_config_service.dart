import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import '../constants.dart';

/// Represents the config for a single AI model slot.
class AiModelSlotConfig {
  const AiModelSlotConfig({
    required this.provider,
    required this.modelId,
    required this.endpoint,
    required this.apiKeyEnv,
    required this.parameters,
  });

  final String provider;
  final String modelId;
  final String endpoint;
  final String apiKeyEnv;
  final Map<String, dynamic> parameters;

  factory AiModelSlotConfig.fromJson(Map<String, dynamic> json) =>
      AiModelSlotConfig(
        provider: json['provider'] as String,
        modelId: json['model_id'] as String,
        endpoint: json['endpoint'] as String,
        apiKeyEnv: json['api_key_env'] as String,
        parameters:
            (json['parameters'] as Map<String, dynamic>?) ?? const {},
      );
}

/// Reads [kAssetAiModelConfig] at startup and exposes the active model config
/// for each slot (generation, enhancement).
///
/// If the config is missing or malformed the relevant slot is null and the
/// feature is gracefully disabled — never a crash.
class AiModelConfigService {
  AiModelConfigService._();

  static final _log = Logger();

  AiModelSlotConfig? _generation;
  AiModelSlotConfig? _enhancement;

  /// The active generation model config, or null if unavailable.
  AiModelSlotConfig? get generation => _generation;

  /// The active enhancement model config, or null if unavailable.
  AiModelSlotConfig? get enhancement => _enhancement;

  /// Loads and parses the config file. Call once at app startup.
  Future<void> load() async {
    try {
      final raw = await rootBundle.loadString(kAssetAiModelConfig);
      final json = jsonDecode(raw) as Map<String, dynamic>;

      if (json['generation'] != null) {
        _generation = AiModelSlotConfig.fromJson(
          json['generation'] as Map<String, dynamic>,
        );
      }
      if (json['enhancement'] != null) {
        _enhancement = AiModelSlotConfig.fromJson(
          json['enhancement'] as Map<String, dynamic>,
        );
      }
    } catch (e) {
      _log.w('AiModelConfigService: failed to load config — AI features disabled. $e');
      _generation = null;
      _enhancement = null;
    }
  }

  static Future<AiModelConfigService> create() async {
    final service = AiModelConfigService._();
    await service.load();
    return service;
  }
}
