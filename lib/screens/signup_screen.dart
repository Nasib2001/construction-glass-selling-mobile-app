import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state_provider.dart';
import '../widgets/glass_card.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _siteIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _siteIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister(AppStateProvider state) async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text('You must accept the Z87 Occupational Safety Agreement', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate company database verification
    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) {
      state.signUpUser(
        _nameController.text,
        _emailController.text,
        _companyController.text,
        _siteIdController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      // Clear route stack and go back to home gate
      Navigator.popUntil(context, (route) => route.isFirst);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFFF9E00),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.shield_rounded, color: Colors.black),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'COMPLIANCE CREDENTIALS ISSUED. WELCOME, ${state.userName.toUpperCase()}',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          // Background Color
          Positioned.fill(
            child: Container(
              color: const Color(0xFF060913),
              child: Stack(
                children: [
                  Positioned(
                    top: -100,
                    left: -100,
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF9E00).withOpacity(0.06),
                            blurRadius: 160.0,
                            spreadRadius: 50.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Scroll Area
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Back arrow to Login
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.04),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text(
                      'CREDENTIAL REGISTRATION',
                      style: GoogleFonts.orbitron(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Text(
                      'REGISTER NEW SITE SUPERVISOR OR AUDITOR PROFILE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main Sign Up Form Card
                    Form(
                      key: _formKey,
                      child: GlassCard(
                        borderRadius: 28,
                        fillGradientStart: Colors.white.withOpacity(0.05),
                        fillGradientEnd: Colors.white.withOpacity(0.01),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Segmented Switch Tab
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.08)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        color: Colors.transparent,
                                        child: Center(
                                          child: Text(
                                            'LOGIN PORTAL',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.6),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF9E00).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFFF9E00).withOpacity(0.3)),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'CREATE ACCOUNT',
                                          style: TextStyle(
                                            color: Color(0xFFFF9E00),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Full Name Field
                            _buildLabel('FULL NAME'),
                            _buildTextField(
                              controller: _nameController,
                              hintText: 'Enter full name (e.g. John Doe)',
                              icon: Icons.person_outline_rounded,
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Full name is required';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // Email Address Field
                            _buildLabel('CORPORATE EMAIL ADDRESS'),
                            _buildTextField(
                              controller: _emailController,
                              hintText: 'Enter corporate work email',
                              icon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Email is required';
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                                  return 'Enter a valid corporate email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // Company Name
                            _buildLabel('COMPANY / FIRM'),
                            _buildTextField(
                              controller: _companyController,
                              hintText: 'Enter employer (e.g. Apex Masonry)',
                              icon: Icons.corporate_fare_rounded,
                            ),
                            const SizedBox(height: 14),

                            // Workplace Site ID
                            _buildLabel('WORK SITE ID clearance'),
                            _buildTextField(
                              controller: _siteIdController,
                              hintText: 'Enter dynamic site ID (e.g. SITE-8709)',
                              icon: Icons.pin_drop_outlined,
                            ),
                            const SizedBox(height: 14),

                            // Password Key
                            _buildLabel('SECURITY PASSCODE KEY'),
                            _buildTextField(
                              controller: _passwordController,
                              hintText: 'Choose minimum 6 character password key',
                              icon: Icons.key_rounded,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: Colors.white54,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Password key is required';
                                if (val.length < 6) return 'Password must be at least 6 characters';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Safety policy checkbox
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _agreedToTerms,
                                  onChanged: (val) {
                                    setState(() {
                                      _agreedToTerms = val ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFFFF9E00),
                                  checkColor: Colors.black,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'I certify that all entries are valid and agree to the Z87 Occupational Safety standards compliance terms.',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 10,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Submit Action Button
                            GestureDetector(
                              onTap: _isLoading ? null : () => _handleRegister(state),
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF9E00), Color(0xFFFFB703)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF9E00).withOpacity(0.2),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.app_registration_rounded, color: Colors.black, size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              'AUTHORIZE REGISTRATION',
                                              style: GoogleFonts.orbitron(
                                                textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 11,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 12),
          prefixIcon: Icon(icon, color: const Color(0xFFFF9E00), size: 16),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
        ),
      ),
    );
  }
}
