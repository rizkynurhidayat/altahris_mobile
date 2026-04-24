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
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final camera = await Permission.camera.isGranted;
    final location = await Permission.locationWhenInUse.isGranted;
    final storage = await Permission.storage.isGranted;
    final photos = await Permission.photos.isGranted;

    if (mounted) {
      setState(() {
        _permissionsGranted = camera && location && (storage || photos);
      });
    }
  }

  Future<void> _requestPermissions() async {
    // Request multiple permissions at once
    await [
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.storage,
      Permission.photos,
    ].request();

    await _checkPermissions();
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
      // titlePadding: EdgeInsets.only(top: 24),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      pages: [
        PageViewModel(
          title: "Welcome to Alta",
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
          image: _buildImage('assets/img/payslip_donwload_confirm.png', 300),
          decoration: pageDecoration,
          bodyWidget: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "For the best experience, AltaHRIS requires access to your Location, Camera, and Media.",
                  style: bodyStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _permissionsGranted
                        ? null
                        : () {
                            _requestPermissions();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _permissionsGranted
                          ? 'Permissions Granted'
                          : 'Allow Permissions',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      onDone: _permissionsGranted ? () => _onIntroEnd(context) : () {},
      onSkip: () => {},
      showSkipButton: false,
      showNextButton: true,
      showDoneButton: true,
      next: const Text("Next"),
      doneStyle: ElevatedButton.styleFrom(
        backgroundColor: _permissionsGranted ? AppColors.primary : Colors.transparent,
        foregroundColor: Colors.grey,
        // disabledBackgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      done: Text(
        "Done",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _permissionsGranted ? Colors.white : Colors.grey,
        ),
      ),
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
