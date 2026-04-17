import 'package:altahris_mobile/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  // bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = sl<SharedPreferences>();
    final savedEmail = prefs.getString('remembered_email');
    if (savedEmail != null) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberMe = true;
      });
    }
  }

  Future<void> _handleRememberMe() async {
    final prefs = sl<SharedPreferences>();
    if (_rememberMe) {
      await prefs.setString('remembered_email', _emailController.text.trim());
    } else {
      await prefs.remove('remembered_email');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _handleRememberMe();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomePage(user: state.user),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Positioned(top: 0, left: 0, right: 0, child: _buildHeader()),
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Invisible header to maintain spacing for the scrolling content
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: false,
                        child: _buildHeader(),
                      ),
                      _buildLoginForm(context, state),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/header_bg.png'),
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/logo/logo.png',
              height: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Alta',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Your Friendly HRIS',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 30),
            // Illustration placeholder - using logo or a generic icon if specific img not found
            Image.asset('assets/img/login_img.png', scale: 3.8),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthState state) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Start your workday with Alta HRIS.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 32),

              CustomTextField(
                label: "Email",
                placeholder: 'budi@alta.co.id',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              CustomTextField(
                label: 'Password',
                placeholder: 'Enter your password',
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (val) {
                        setState(() {
                          _rememberMe = val ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Remember Me'),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6D00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              LoginRequested(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              ),
                            );
                          }
                        },
                  child: state is AuthLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
