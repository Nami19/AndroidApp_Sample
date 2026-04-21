import 'package:flutter/material.dart';
import 'Selecting.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _regPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isRegPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;
  bool _isRegisterMode = false;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const _adminEmail = 'admin@gmail.com';
  static const _adminPassword = 'admin123';
  static const _studentEmail = 'student@dbtc.edu.ph';
  static const _studentPassword = 'student123';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }

    if (email == _adminEmail && password == _adminPassword) {
      setState(() => _errorMessage = null);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SelectionScreen(userType: UserType.admin),
        ),
      );
    } else if (email == _studentEmail && password == _studentPassword) {
      setState(() => _errorMessage = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Redirecting to Student Course Selection...'),
          backgroundColor: Color(0xFF1565C0),
        ),
      );
    } else {
      setState(() => _errorMessage = 'Invalid email or password.');
    }
  }

  void _toggleMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
      _errorMessage = null;
    });
    _animController.reset();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A1628),
              Color(0xFF0D2250),
              Color(0xFF0A1628)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: _isRegisterMode
                  ? _buildRegisterView()
                  : _buildLoginView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF00C853)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1565C0).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(Icons.school_rounded,
                color: Colors.white, size: 48),
          ),
          const SizedBox(height: 16),
          const Text(
            'ScholarTrack',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Text(
            'Student Attendance Management System',
            style: TextStyle(color: Color(0xFF90CAF9), fontSize: 12),
          ),
          const SizedBox(height: 44),
          _buildLabel('Email Address'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'admin@gmail.com',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          _buildLabel('Password'),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _passwordController,
            hint: '••••••••',
            isVisible: _isPasswordVisible,
            onToggle: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: Colors.red.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.redAccent, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_errorMessage!,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Login',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: _toggleMode,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white38, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Register new account',
                  style: TextStyle(fontSize: 15)),
            ),
          ),
          const SizedBox(height: 28),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              text: 'By signing in you agree to our ',
              style:
                  TextStyle(color: Color(0xFF78909C), fontSize: 12),
              children: [
                TextSpan(
                  text: 'Terms',
                  style: TextStyle(
                      color: Color(0xFF42A5F5),
                      decoration: TextDecoration.underline),
                ),
                TextSpan(text: ' & '),
                TextSpan(
                  text: 'Privacy',
                  style: TextStyle(
                      color: Color(0xFF42A5F5),
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Column(
              children: [
                Text('Create New Account',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Join us today!',
                    style: TextStyle(
                        color: Color(0xFF90CAF9), fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 36),
          _buildLabel('Full Name'),
          const SizedBox(height: 8),
          _buildTextField(
              controller: _fullNameController,
              hint: 'Admin',
              icon: Icons.person_outline),
          const SizedBox(height: 18),
          _buildLabel('Email Address'),
          const SizedBox(height: 8),
          _buildTextField(
              controller: _regEmailController,
              hint: 'admin@gmail.com',
              icon: Icons.email_outlined),
          const SizedBox(height: 18),
          _buildLabel('Password'),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _regPasswordController,
            hint: '••••••••',
            isVisible: _isRegPasswordVisible,
            onToggle: () => setState(
                () => _isRegPasswordVisible = !_isRegPasswordVisible),
          ),
          const SizedBox(height: 18),
          _buildLabel('Confirm Password'),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _confirmPasswordController,
            hint: '••••••••',
            isVisible: _isConfirmPasswordVisible,
            onToggle: () => setState(() =>
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Checkbox(
                  value: _agreeToTerms,
                  onChanged: (v) =>
                      setState(() => _agreeToTerms = v ?? false),
                  fillColor: WidgetStateProperty.resolveWith((states) =>
                      states.contains(WidgetState.selected)
                          ? const Color(0xFF1976D2)
                          : Colors.transparent),
                  side: const BorderSide(color: Color(0xFF42A5F5)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 10),
              const Text('I agree to Terms & Conditions',
                  style: TextStyle(
                      color: Color(0xFFB0BEC5), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _agreeToTerms
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Account created successfully!'),
                            backgroundColor: Color(0xFF1976D2)),
                      );
                      _toggleMode();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Sign Up',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: GestureDetector(
              onTap: _toggleMode,
              child: RichText(
                text: const TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(
                      color: Color(0xFF78909C), fontSize: 13),
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(
                          color: Color(0xFF42A5F5),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 13));

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: Color(0xFF546E7A), fontSize: 14),
        prefixIcon:
            Icon(icon, color: const Color(0xFF546E7A), size: 20),
        filled: true,
        fillColor: const Color(0xFF0D2A50),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF1A3A6B))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF1A3A6B))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF42A5F5), width: 1.5)),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: Color(0xFF546E7A), fontSize: 14),
        prefixIcon: const Icon(Icons.lock_outline,
            color: Color(0xFF546E7A), size: 20),
        suffixIcon: IconButton(
          icon: Icon(
              isVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: const Color(0xFF546E7A),
              size: 20),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFF0D2A50),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF1A3A6B))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF1A3A6B))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF42A5F5), width: 1.5)),
      ),
    );
  }
}