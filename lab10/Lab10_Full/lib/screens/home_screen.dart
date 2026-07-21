import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomeScreen({super.key, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _notificationSent = false;

  Future<void> _logout() async {
    await NotificationService().showLogoutNotification();
    await AuthService().logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _sendTestNotification() async {
    await NotificationService().showNotification(
      id: 99,
      title: '🔔 Test Notification',
      body: 'Local notifications are working correctly in Lab10 Full!',
    );
    setState(() => _notificationSent = true);
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.userData['firstName'] ?? '';
    final lastName = widget.userData['lastName'] ?? '';
    final email = widget.userData['email'] ?? '';
    final image = widget.userData['image'] ?? '';
    final token = widget.userData['accessToken'] ??
        widget.userData['token'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF080B16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0B3B),
        title: const Text(
          'Lab10 Full – Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF6D28D9)),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // User header
            Center(
              child: Column(
                children: [
                  // Avatar
                  image.isNotEmpty
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(image),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6D28D9), Color(0xFF3B82F6)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6D28D9).withOpacity(0.5),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person,
                              size: 52, color: Colors.white),
                        ),
                  const SizedBox(height: 14),
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(email,
                      style: const TextStyle(
                          color: Color(0xFF9CA3AF), fontSize: 14)),
                  const SizedBox(height: 12),
                  // Feature badges row
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      _badge('✓ API Login', Colors.green),
                      _badge('✓ Session Saved', Colors.blue),
                      _badge('✓ Notification Sent', Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Token display
            _sectionCard(
              title: 'SESSION TOKEN',
              color: const Color(0xFF6D28D9),
              child: SelectableText(
                token.length > 80 ? '${token.substring(0, 80)}...' : token,
                style: const TextStyle(
                  color: Color(0xFF6D28D9),
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Integration checklist
            _sectionCard(
              title: 'INTEGRATION CHECKLIST',
              color: const Color(0xFF3B82F6),
              child: Column(
                children: [
                  _checkItem('Splash Screen auto-routing', true),
                  _checkItem('Real API Login (DummyJSON)', true),
                  _checkItem('Session persistence (SharedPreferences)', true),
                  _checkItem('Auto-Login on app restart', true),
                  _checkItem('Local notification on login', true),
                  _checkItem(
                      'Firebase Google Sign-In (requires setup)', false),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Test notification button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sendTestNotification,
                icon: const Icon(Icons.notifications_active_rounded),
                label: Text(_notificationSent
                    ? 'Notification Sent! ✓'
                    : 'Send Test Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _notificationSent
                      ? Colors.green.shade700
                      : const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout & Clear Session'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }

  Widget _sectionCard({
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0B3B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _checkItem(String label, bool done) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: done ? Colors.greenAccent : const Color(0xFF4B5563),
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(label,
              style: TextStyle(
                  color: done ? Colors.white : const Color(0xFF6B7280),
                  fontSize: 13)),
        ],
      ),
    );
  }
}
