import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        height: size.height,
        child: Stack(
          children: [
            Flexible(
                flex: 1,
                child: Container(
                  color: Color(0xffF4F4F4),
                )),
            Container(
                height: size.height * 0.5,
                decoration: const BoxDecoration(
                    color: Color(0xff5835D4),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(35),
                        bottomLeft: Radius.circular(35)))),
            Center(
              child: TextButton(
                onPressed: () => controller.captureDocumentImage(),
                child: Container(
                  height: size.height * 0.25,
                  width: size.width * 0.85,
                  decoration: BoxDecoration(
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 15.0,
                            offset: Offset(0.0, 0.75))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Obx(() => controller.pathImage == ''
                        ? FractionallySizedBox(
                            widthFactor: 0.27,
                            heightFactor: 0.40,
                            child: Image.network(
                              "https://cdn3d.iconscout.com/3d/premium/thumb/upload-5621285-4673829.png",
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: FractionallySizedBox(
                              widthFactor: 1,
                              heightFactor: 1,
                              child: Image.file(
                                File(controller.pathImage.value),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 75),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.dialog(Container(
                          color: Colors.white,
                          child: Obx(() => controller.jsonDespieceS.value != ""
                              ? JsonView.string(
                                  theme: const JsonViewTheme(
                                      viewType: JsonViewType.base,
                                      defaultTextStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 10,
                                          decoration: TextDecoration.none),
                                      backgroundColor: Colors.white),
                                  controller.jsonDespieceS.value)
                              : Container()),
                        ));
                      },
                      child: const Text('Obtener Json'),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    ElevatedButton(
                      onPressed: () => controller.convertrExcel(),
                      child: Text('Generar Excel'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
