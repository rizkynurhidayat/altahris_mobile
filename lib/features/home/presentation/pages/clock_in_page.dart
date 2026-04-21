import 'dart:io';
import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:altahris_mobile/core/utils/permission_handler.dart';
import 'package:altahris_mobile/core/widgets/success_dialog.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:altahris_mobile/core/di/injection_container.dart';

class ClockInPage extends StatefulWidget {
  final bool isClockIn;
  const ClockInPage({super.key, this.isClockIn = true});

  @override
  State<ClockInPage> createState() => _ClockInPageState();
}

class _ClockInPageState extends State<ClockInPage> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _checkInitialPermissions();
  }

  Future<void> _checkInitialPermissions() async {
    await AppPermissionHandler.checkAndRequestCameraPermission();
    await AppPermissionHandler.checkAndRequestLocationPermission();
  }

  Future<void> _takePhoto() async {
    final cameraGranted =
        await AppPermissionHandler.checkAndRequestCameraPermission();
    if (!cameraGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required')),
        );
      }
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 50,
      );

      if (photo == null) return;

      setState(() {
        _image = photo;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error taking photo: $e')));
      }
    }
  }

  Future<void> _submitAttendance(BuildContext context) async {
    if (_image == null) return;

    setState(() {
      _isLocating = true;
    });

    try {
      // 1. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location services are disabled. Please enable them.',
              ),
            ),
          );
        }
        setState(() => _isLocating = false);
        return;
      }

      // 2. Check and request location permission using Geolocator
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission is denied')),
            );
          }
          setState(() => _isLocating = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied.'),
            ),
          );
        }
        setState(() => _isLocating = false);
        return;
      }

      // 3. Get current position with a timeout
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (mounted) {
        if (widget.isClockIn) {
          context.read<HomeBloc>().add(
            PerformClockIn(
              imagePath: _image!.path,
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );
        } else {
          context.read<HomeBloc>().add(
            PerformClockOut(
              imagePath: _image!.path,
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );
        }
      }
    } catch (e) {
      print('Location Error: $e');
      if (mounted) {
        String errorMessage = 'Error getting location';
        if (e.toString().contains('Timeout')) {
          errorMessage =
              'Location request timed out. Please try again or move to an open area.';
        } else {
          errorMessage = 'Error: ${e.toString()}';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLocating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>(),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is ClockInSuccess || state is ClockOutSuccess) {
            SuccessDialog.show(
              context,
              title: 'Success',
              message: 'Attendance recorded successfully!',
              onDismiss: () {
                Navigator.pop(context);
                context.read<HomeBloc>().add(FetchHomeData());
              },
            );
            // Future.delayed(const Duration(seconds: 2), () {
            //   if (mounted) Navigator.pop(context);
            // });
          } else if (state is ClockInFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ClockOutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.isClockIn ? 'Clock In' : 'Clock Out',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            centerTitle: true,
            elevation: 0,
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final isLoading =
                  state is ClockInLoading ||
                  state is ClockOutLoading ||
                  _isLocating;

              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: _image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No photo taken yet',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(_image!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_image != null) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _submitAttendance(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.all(5),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      widget.isClockIn
                                          ? 'Submit Clock In'
                                          : 'Submit Clock Out',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: _image == null
                              ? ElevatedButton.icon(
                                  onPressed: isLoading ? null : _takePhoto,
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Take Photo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.all(0)
                                  ),
                                )
                              : OutlinedButton(
                                  onPressed: isLoading ? null : _takePhoto,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Retake Photo',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
