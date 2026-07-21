import 'dart:async';

class AuthService {
  // Mock credentials
  static const String _mockEmail = 'student@lab10.com';
  static const String _mockPassword = 'password123';
  static const String _mockToken = 'mock_token_abc123xyz';

  /// Simulates a backend authentication call with a 1.5s delay.
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email == _mockEmail && password == _mockPassword) {
      return {
        'success': true,
        'token': _mockToken,
        'user': {
          'id': 1,
          'email': email,
          'name': 'Lab10 Student',
        },
      };
    } else {
      return {
        'success': false,
        'message': 'Invalid email or password. Please try again.',
      };
    }
  }
}
