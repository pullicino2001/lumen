/// App-wide constants. No magic numbers anywhere else in the codebase.
library;

/// Subscription entitlement IDs (must match billing provider config).
const String kEntitlementPro = 'pro';
const String kEntitlementProMax = 'pro_max';

/// Number of film looks available on the free tier.
const int kFreeTierLookCount = 3;

/// Number of lens profiles available on the free tier.
const int kFreeTierLensProfileCount = 1;

/// Basic editor parameter ranges.
const double kExposureMin = -5.0;
const double kExposureMax = 5.0;
const double kTemperatureMin = 2000.0;
const double kTemperatureMax = 16000.0;
const double kTintMin = -150.0;
const double kTintMax = 150.0;
const double kAdjustmentMin = -100.0;
const double kAdjustmentMax = 100.0;

/// Default temperature (daylight).
const double kDefaultTemperature = 5500.0;

/// Asset paths.
const String kAssetLuts = 'assets/luts/';
const String kAssetLensProfiles = 'assets/lens_profiles/';
const String kAssetShaders = 'assets/shaders/';
const String kAssetAiModelConfig = 'assets/config/ai_model_config.json';
