import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_colors.dart';
import 'login_page.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _requestPermissions() async {
    // Request multiple permissions at once
    await [
      Permission.location,
      Permission.camera,
      Permission.storage,
      Permission.photos,
    ].request();

    _onIntroEnd(context);
  }

  void _onIntroEnd(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_run', false);

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(assetName, width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, color: AppColors.textSecondary);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true, // Prevent skip by swiping
      // freeze: true, // Disable manual swipe to force user to click buttons
      pages: [
        PageViewModel(
          title: "Welcome to AltaHRIS",
          body:
              "Smart solution for your attendance management and HR needs in your hand.",
          image: _buildImage('assets/logo/logo.png', 200),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Easy Access",
          body:
              "Apply for leave, check payslips, and monitor your attendance anytime and anywhere.",
          image: _buildImage('assets/img/login_img.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "App Permissions",
          body:
              "For the best experience, AltaHRIS requires access to your Location, Camera, and Media.",
          image: _buildImage('assets/img/payslip_donwload_confirm.png', 300),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _requestPermissions(),
      onSkip: () => {}, // No skip allowed
      showSkipButton: false,
      showNextButton: true,
      showDoneButton:
          true, // We use the button in the footer of the last page or custom logic
      // next: const Icon(Icons.arrow_forward, color: AppColors.primary),
      next: const Text("Next"),
      done: const Text("Allow"),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: AppColors.primaryLight,
        activeColor: AppColors.primary,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
