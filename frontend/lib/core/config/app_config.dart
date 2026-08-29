class AppConfig {
  static const apiBaseUrl = String.fromEnvironment('GONGFIT_API_URL', defaultValue: 'http://localhost:8000');
}
