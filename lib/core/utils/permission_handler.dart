import 'package:permission_handler/permission_handler.dart';

class AppPermissionHandler {
  static Future<void> requestAllPermissions() async {
    await [
      Permission.camera,
      Permission.locationWhenInUse,
      Permission.storage,
      Permission.photos,
    ].request();
  }

  static Future<bool> checkAndRequestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    
    final result = await Permission.camera.request();
    return result.isGranted;
  }

  static Future<bool> checkAndRequestLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isGranted) return true;

    final result = await Permission.locationWhenInUse.request();
    return result.isGranted;
  }

  static Future<bool> checkAndRequestStoragePermission() async {
    // Note: On Android 13+, Permission.storage might not be enough.
    // We request photos/videos specifically if storage fails or as extra.
    final status = await Permission.storage.status;
    if (status.isGranted) return true;

    final result = await Permission.storage.request();
    if (result.isGranted) return true;

    // For Android 13+ (API 33+)
    final photosStatus = await Permission.photos.request();
    return photosStatus.isGranted;
  }
}
