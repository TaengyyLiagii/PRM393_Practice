import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _notificationService = NotificationService();
  bool _permissionGranted = false;
  String _lastAction = 'None';
  int _notificationCount = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim =
        Tween<double>(begin: 0.9, end: 1.1).animate(_pulseController);
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final granted = await _notificationService.requestPermission();
    if (mounted) {
      setState(() => _permissionGranted = granted);
    }
  }

  Future<void> _sendBasicNotification() async {
    await _notificationService.showNotification(
      id: _notificationCount++,
      title: '🔔 Lab 10.5 Notification',
      body: 'This is a manually triggered local notification!',
    );
    setState(() => _lastAction = 'Basic notification sent');
  }

  Future<void> _sendLoginNotification() async {
    await _notificationService.showLoginSuccessNotification('Student');
    setState(() => _lastAction = 'Login success notification sent');
  }

  Future<void> _sendLogoutNotification() async {
    await _notificationService.showLogoutNotification();
    setState(() => _lastAction = 'Logout notification sent');
  }

  Future<void> _cancelAll() async {
    await _notificationService.cancelAll();
    setState(() => _lastAction = 'All notifications cancelled');
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D0D1A), Color(0xFF1A1000), Color(0xFF0D0D1A)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header
                Center(
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _pulseAnim,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B).withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            size: 52,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Lab 10.5',
                        style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                            letterSpacing: 2),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Local Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'LO7 – Mandatory',
                        style: TextStyle(
                          color: Color(0xFFF59E0B),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Permission status
                _permissionCard(),
                const SizedBox(height: 24),

                // Notification buttons
                const Text(
                  'TRIGGER NOTIFICATIONS',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _notificationButton(
                  onPressed: _sendBasicNotification,
                  icon: Icons.notifications_rounded,
                  label: 'Send Basic Notification',
                  color: const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 12),
                _notificationButton(
                  onPressed: _sendLoginNotification,
                  icon: Icons.login_rounded,
                  label: 'Send Login Success Notification',
                  color: Colors.greenAccent,
                ),
                const SizedBox(height: 12),
                _notificationButton(
                  onPressed: _sendLogoutNotification,
                  icon: Icons.logout_rounded,
                  label: 'Send Logout Notification',
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 12),
                _notificationButton(
                  onPressed: _cancelAll,
                  icon: Icons.cancel_rounded,
                  label: 'Cancel All Notifications',
                  color: Colors.redAccent,
                  outlined: true,
                ),
                const SizedBox(height: 24),

                // Last action
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFF59E0B).withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('LAST ACTION',
                          style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 11,
                              letterSpacing: 1.5)),
                      const SizedBox(height: 6),
                      Text(
                        _lastAction,
                        style: const TextStyle(
                            color: Color(0xFFF59E0B),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _permissionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _permissionGranted
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _permissionGranted
              ? Colors.green.withOpacity(0.4)
              : Colors.orange.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _permissionGranted
                ? Icons.check_circle_outline
                : Icons.warning_amber_rounded,
            color: _permissionGranted ? Colors.greenAccent : Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _permissionGranted
                    ? 'Notification Permission Granted'
                    : 'Notification Permission Pending',
                style: TextStyle(
                  color: _permissionGranted
                      ? Colors.greenAccent
                      : Colors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _permissionGranted
                    ? 'You can now receive local notifications'
                    : 'Grant permission in device settings',
                style: const TextStyle(
                    color: Color(0xFF9CA3AF), fontSize: 12),
              ),
            ],
          ),
          if (!_permissionGranted) ...[
            const Spacer(),
            TextButton(
              onPressed: _requestPermission,
              child: const Text('Grant',
                  style: TextStyle(color: Colors.orange)),
            ),
          ]
        ],
      ),
    );
  }

  Widget _notificationButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    bool outlined = false,
  }) {
    if (outlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
