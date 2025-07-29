import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Controllers
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

    // Container animations
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

    // Form animations
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

    // Button animations
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

    // Background animation
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

  @override
  void dispose() {
    _containerController.dispose();
    _formController.dispose();
    _buttonController.dispose();
    _backgroundController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
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
                    
                    // Welcome Back Header
                    FadeTransition(
                      opacity: _containerOpacityAnimation,
                      child: SlideTransition(
                        position: _containerSlideAnimation,
                        child: _buildWelcomeHeader(),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Login Form Container
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
                    
                    // Login Button
                    ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: FadeTransition(
                        opacity: _buttonOpacityAnimation,
                        child: _buildLoginButton(),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Bottom Section
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
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        // Back Button
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        
        const SizedBox(height: 40),
        
        // ShopAssist Logo/Title
        Text(
          'ShopAssist',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
            letterSpacing: 1.2,
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Welcome Back Text
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
          ),
        ),
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
                // Email/Phone Field
                _buildInputLabel('Email / Phone'),
                const SizedBox(height: 8),
                _buildAnimatedTextField(
                  controller: _emailController,
                  hintText: 'Enter your email or phone',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email or phone';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Password Field
                _buildInputLabel('Password'),
                const SizedBox(height: 8),
                _buildAnimatedTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: const Color(0xFF4FC3F7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: const Color(0xFF2C3E50),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: Colors.grey[400],
              ),
              suffixIcon: suffixIcon,
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
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4FC3F7),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Login',
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

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Add haptic feedback
      HapticFeedback.lightImpact();

      // Simulate login process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navigate to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }
}
