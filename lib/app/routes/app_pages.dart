import 'package:get/get.dart';
import 'package:ocr_prueba_ecarpintero/app/bindings/home_binding.dart';
import 'package:ocr_prueba_ecarpintero/app/ui/pages/home_page/home_page.dart';

part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding())
  ];
}
