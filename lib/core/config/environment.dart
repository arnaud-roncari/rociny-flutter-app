/// Base API endpoint (backend server)
String kEndpoint = "https://a60e4b56208c.ngrok-free.app";

/// Current app version
String kAppVersion = "1.0.0";

// Alternative local endpoint for development
// String kEndpoint = "http://127.0.0.1:3000";

/// Stripe publishable key (test mode)
String kStripePublishableKey =
    "pk_test_51RHp2GP8RWGgBaM7hRc6vy2pT5W5otJAICwAg2wBGnEAvaTTX918fXwGKV4SuCo3V4MzxgDXUZeR6F2ZRTB8TNI000rTdw8YAR";

/// OneSignal App ID (used for push notifications)
String kOneSignalPublishableKey = "c182cc06-c092-4176-8888-8652f2a9cb78";

/// Google OAuth client ID for web (used for Google Sign-In)
String kGooglePublishableClientWebId = "949880046138-orc7r7tnt5rv8k6trhes46o4rdjkkj7d.apps.googleusercontent.com";

/// JWT token (set after login, used for authenticated requests)
String? kJwt;

/// Selected app language (e.g., "en", "fr")
late String kLanguage;

/// True if the app is opened for the first time
late bool kFirstLaunch;

/// List of departments (loaded dynamically from backend or config)
late List<String> kDepartments;

/// List of target audiences (e.g., "students", "parents")
late List<String> kTargetAudiences;

/// List of content themes (e.g., "fashion", "tech")
late List<String> kThemes;

/// Predefined age ranges used in filters
const List<String> kAgeRanges = [
  '13-17',
  '18-24',
  '25-34',
  '35-44',
  '45-54',
  '55-64',
  '65+',
];

/// Platform commission percentage
late double kCommission;
