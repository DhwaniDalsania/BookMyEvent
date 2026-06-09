class ApiConstants {
  static String get baseUrl {
    // Default to Render production URL.
    //   flutter run --dart-define=DEV_HOST_IP=127.0.0.1
    const devHost = String.fromEnvironment('DEV_HOST_IP');
    if (devHost.isNotEmpty) {
      return 'http://$devHost:3000';
    }
    return 'https://bookmyevent-4rrq.onrender.com';
  }
}
