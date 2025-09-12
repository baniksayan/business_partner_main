// lib/views/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  // OTP Controllers
  final List<TextEditingController> _otpControllers = 
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = 
      List.generate(6, (index) => FocusNode());

  late AnimationController _containerController;
  late AnimationController _formController;
  late AnimationController _buttonController;
  late AnimationController _backgroundController;

  late Animation<double> _containerScaleAnimation;
  late Animation<Offset> _containerSlideAnimation;
  late Animation<double> _containerOpacityAnimation;
  
  late Animation<double> _formOpacityAnimation;
  late Animation<Offset> _formSlideAnimation;
  
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _buttonOpacityAnimation;
  
  late Animation<double> _backgroundOpacityAnimation;

  // State Management
  bool _isOtpSent = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  int _resendTimer = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _containerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _containerScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _containerController,
      curve: Curves.elasticOut,
    ));

    _containerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _containerController,
      curve: Curves.easeOutBack,
    ));

    _containerOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _containerController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _formOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _formController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    ));

    _formSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutCubic,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    ));

    _buttonOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeIn,
    ));

    _backgroundOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() async {
    _backgroundController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _containerController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _formController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _buttonController.forward();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 60;
      _canResend = false;
    });
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendTimer--;
          if (_resendTimer == 0) {
            _canResend = true;
          }
        });
      }
      return _resendTimer > 0 && mounted;
    });
  }

  @override
  void dispose() {
    _containerController.dispose();
    _formController.dispose();
    _buttonController.dispose();
    _backgroundController.dispose();
    _emailController.dispose();
    
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return AnimatedBuilder(
            animation: Listenable.merge([
              _containerController,
              _formController,
              _buttonController,
              _backgroundController,
            ]),
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFF8F9FA).withOpacity(_backgroundOpacityAnimation.value),
                      const Color(0xFFE9ECEF).withOpacity(_backgroundOpacityAnimation.value),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        
                        // Header
                        FadeTransition(
                          opacity: _containerOpacityAnimation,
                          child: SlideTransition(
                            position: _containerSlideAnimation,
                            child: _buildWelcomeHeader(),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Form
                        ScaleTransition(
                          scale: _containerScaleAnimation,
                          child: FadeTransition(
                            opacity: _containerOpacityAnimation,
                            child: SlideTransition(
                              position: _containerSlideAnimation,
                              child: _buildLoginForm(),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Button
                        ScaleTransition(
                          scale: _buttonScaleAnimation,
                          child: FadeTransition(
                            opacity: _buttonOpacityAnimation,
                            child: _buildActionButton(),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Bottom
                        FadeTransition(
                          opacity: _formOpacityAnimation,
                          child: SlideTransition(
                            position: _formSlideAnimation,
                            child: _buildBottomSection(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        // Logo
        Text(
          'Business Partner',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
            letterSpacing: 1.2,
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Title
        Text(
          _isOtpSent ? 'Verify OTP' : 'Welcome Back!',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
          ),
        ),
        
        // OTP instruction
        if (_isOtpSent) ...[
          const SizedBox(height: 8),
          Text(
            'Enter the 6-digit code sent to',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            _emailController.text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4FC3F7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FadeTransition(
        opacity: _formOpacityAnimation,
        child: SlideTransition(
          position: _formSlideAnimation,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isOtpSent) ...[
                  // Email Input
                  _buildInputLabel('Email / Phone'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmailOrPhone,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: const Color(0xFF2C3E50),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your email or phone',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.grey[400],
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF4FC3F7), width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red, width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                ] else ...[
                  // OTP Input
                  _buildInputLabel('Enter OTP'),
                  const SizedBox(height: 16),
                  _buildOtpInput(),
                  const SizedBox(height: 24),
                  _buildResendSection(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          width: 45,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _otpFocusNodes[index].hasFocus 
                  ? const Color(0xFF4FC3F7)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: TextFormField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C3E50),
            ),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 5) {
                  _otpFocusNodes[index + 1].requestFocus();
                } else {
                  _otpFocusNodes[index].unfocus();
                }
              } else {
                if (index > 0) {
                  _otpFocusNodes[index - 1].requestFocus();
                }
              }
              
              if (_isOtpComplete()) {
                _handleVerifyOtp();
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildResendSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        if (_canResend && !_isSendingOtp)
          GestureDetector(
            onTap: _handleResendOtp,
            child: Text(
              'Resend',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4FC3F7),
              ),
            ),
          )
        else
          Text(
            _isSendingOtp 
                ? 'Sending...' 
                : 'Resend in ${_resendTimer}s',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF2C3E50),
      ),
    );
  }

  Widget _buildActionButton() {
    bool isLoading = _isSendingOtp || _isVerifyingOtp;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading 
            ? null 
            : (_isOtpSent ? _handleVerifyOtp : _handleSendOtp),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4FC3F7),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                _isOtpSent ? 'Verify OTP' : 'Send OTP',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        if (_isOtpSent)
          TextButton(
            onPressed: () {
              setState(() {
                _isOtpSent = false;
                _clearOtpFields();
              });
            },
            child: Text(
              'Change Email/Phone',
              style: TextStyle(
                fontFamily: 'Inter',
                color: const Color(0xFF4FC3F7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Text(
          "Don't have an account? Contact Admin.",
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Validation
  String? _validateEmailOrPhone(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your email or phone';
    }
    
    value = value!.trim();
    
    if (RegExp(r'^\d+$').hasMatch(value)) {
      if (value.length < 10) {
        return 'Please enter a valid phone number';
      }
    } else {
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    
    return null;
  }

  bool _isOtpComplete() {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  void _clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  // API Methods
  void _handleSendOtp() async {
    if (_isSendingOtp) return;
    
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSendingOtp = true;
      });
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.sendOtp(_emailController.text.trim());
      
      setState(() {
        _isSendingOtp = false;
      });
      
      if (success) {
        setState(() {
          _isOtpSent = true;
        });
        _startResendTimer();
        _showSuccessMessage('✅ OTP sent successfully to ${_emailController.text}');
      } else {
        _showErrorMessage('❌ ${authProvider.errorMessage ?? "Failed to send OTP"}');
      }
    }
  }

  // **UPDATED: _handleVerifyOtp method with better role handling**
void _handleVerifyOtp() async {
  if (_isVerifyingOtp) return;
  
  if (!_isOtpComplete()) {
    _showErrorMessage('⚠️ Please enter the complete 6-digit OTP');
    return;
  }
  
  setState(() {
    _isVerifyingOtp = true;
  });
  
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  String otpCode = _getOtpCode();
  
  final success = await authProvider.verifyOtp(
    _emailController.text.trim(), 
    otpCode
  );
  
  setState(() {
    _isVerifyingOtp = false;
  });
  
  if (success) {
    // **ENHANCED DEBUG INFO**
    print('======= USER DEBUG INFO =======');
    print('✅ User authenticated successfully');
    print('📧 Email: ${authProvider.userEmail}');
    print('👤 User name: ${authProvider.userName}');
    print('🔢 User roles: ${authProvider.userRoles}');
    print('🏢 Is business partner: ${authProvider.isBusinessPartner}');
    print('📱 Current user data: ${authProvider.currentUser}');
    print('===============================');
    
    // **ROLE CHECK - WITH ENHANCED LOGIC**
    if (authProvider.isBusinessPartner) {
      print('✅ AUTHORIZED: User has business partner access');
      _showSuccessMessage('🎉 Welcome Business Partner!');
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      print('❌ UNAUTHORIZED: User roles ${authProvider.userRoles} do not contain role 2');
      _showBusinessPartnerErrorDialog();
      await authProvider.logout();
    }
  } else {
    _showErrorMessage('❌ ${authProvider.errorMessage ?? "Invalid OTP. Please try again."}');
    _clearOtpFields();
    if (_otpFocusNodes.isNotEmpty) {
      _otpFocusNodes[0].requestFocus();
    }
  }
}


  void _handleResendOtp() async {
    if (_isSendingOtp) return;
    
    setState(() {
      _isSendingOtp = true;
    });
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.sendOtp(_emailController.text.trim());
    
    setState(() {
      _isSendingOtp = false;
    });
    
    if (success) {
      _startResendTimer();
      _clearOtpFields();
      _showSuccessMessage('📨 New OTP sent successfully to ${_emailController.text}');
    } else {
      _showErrorMessage('❌ ${authProvider.errorMessage ?? "Failed to resend OTP"}');
    }
  }

  // Role Authorization Error Dialog
  void _showBusinessPartnerErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.business_center, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text(
                'Access Denied',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are not authorized as a Business Partner.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: const Color(0xFF2C3E50),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'This app is exclusively for Business Partners. Please contact the administrator if you believe this is an error.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isOtpSent = false;
                  _clearOtpFields();
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Message Helpers
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
