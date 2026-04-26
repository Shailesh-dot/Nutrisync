class ApiConfig {
  // ─── DIRECT LOCAL CONNECTION (no ngrok needed) ───────────────────────────
  //
  // Choose the correct base URL based on how you're running the Flutter app:
  //
  //  1. Android EMULATOR (most common for development)
  //     The emulator maps 10.0.2.2 → your PC's localhost.
  static const String baseUrl = 'http://192.168.29.9:8000';
  //
  //  2. Physical Android/iOS device on the SAME Wi-Fi network
  //     Replace the IP below with your PC's local IP (run `ipconfig` on Windows
  //     to find it, look for the IPv4 address of your Wi-Fi adapter).
  //     e.g. static const String baseUrl = 'http://192.168.1.105:8000';
  //
  //  3. Flutter DESKTOP (Windows/Mac/Linux) running on the same machine
  //     e.g. static const String baseUrl = 'http://127.0.0.1:8000';
  // ─────────────────────────────────────────────────────────────────────────

  // API Endpoints
  static const String generateRecipe = '/api/v1/generate-recipe';
  static const String healthCheck = '/health';

  // Standard JSON headers (no ngrok bypass needed)
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
      };

  // Timeout – Gemini generation can take a few seconds
  static const Duration timeoutDuration = Duration(minutes: 3);
}
