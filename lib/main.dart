import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocr_prueba_ecarpintero/app/bindings/home_binding.dart';
import 'package:ocr_prueba_ecarpintero/app/ui/theme/appTheme.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: Routes.HOME,
    theme: appThemeData,
    defaultTransition: Transition.fade,
    initialBinding: HomeBinding(),
    getPages: AppPages.pages,
    //home: HomeBinding(),
  ));
}
