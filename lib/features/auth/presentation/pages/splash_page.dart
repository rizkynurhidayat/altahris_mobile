import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    // Check auth status after a mandatory delay to show splash animation
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final state = context.read<AuthBloc>().state;
        _navigateBasedOnState(state);
      }
    });
  }

  void _navigateBasedOnState(AuthState state) {
    if (_isNavigated) return;

    if (state is AuthAuthenticated) {
      _isNavigated = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage(user: state.user),
        ),
      );
    } else if (state is AuthUnauthenticated || state is AuthFailure) {
      _isNavigated = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // If auth state changes while we are waiting for the delay,
        // it will be caught by the Future.delayed anyway.
        // But if the state becomes available AFTER the delay, we catch it here.
        if (!_isNavigated) {
          // Optional: only navigate here if we've already passed the initial delay
          // For now, let's keep it simple. If auth happens late, navigate.
          _navigateBasedOnState(state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Image.asset(
                          'assets/logo/logo.png',
                          width: 100,
                        ),
                      const SizedBox(height: 24),
                      const Text(
                        'AltaHRIS',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please wait while we load your data',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 48),
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
