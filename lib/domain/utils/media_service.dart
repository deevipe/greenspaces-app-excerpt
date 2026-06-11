import 'package:camera/camera.dart';
import 'package:photo_manager/photo_manager.dart';

class AppMediaService {
  static Future<void> initCameraAndGallery() async {
    try {
      final List<CameraDescription> cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        final CameraController controller = CameraController(
          cameras.first,
          ResolutionPreset.max,
          enableAudio: false,
        );

        // Инициализируем для запроса на доступ
        await controller.initialize();

        // освободим контроллер, так как сейчас он нам не нужен
        controller.dispose();
      }
    } catch (e) {
      print(e);
    }

    await PhotoManager.requestPermissionExtend();
  }
}
