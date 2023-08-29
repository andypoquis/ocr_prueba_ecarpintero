import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:excel/excel.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_prueba_ecarpintero/app/data/models/despiece%20.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  final ImagePicker picker = ImagePicker();

  RxString pathImage = ''.obs;
  RxBool isImage = false.obs;

  Size imageSize = const Size(0, 0);

  int positionRow = 0;
  int sizeRow = 0;

  RxString textObtained = ''.obs;
  RxString textColumn = ''.obs;

  RxString jsonDespieceS = ''.obs;

  RxList<List<Point<int>>> pointsAmount = RxList<List<Point<int>>>();
  RxList<List<Point<int>>> pointsPiecesCountLog = RxList<List<Point<int>>>();
  RxList<List<Point<int>>> pointsPiecesCountWidth = RxList<List<Point<int>>>();

  RxList<Point<int>> pointInitial = RxList<Point<int>>();
  RxList<List<Point<int>>> pointsHitchL1 = RxList<List<Point<int>>>();
  RxList<List<Point<int>>> pointsHitchL2 = RxList<List<Point<int>>>();
  RxList<List<Point<int>>> pointsHitchA1 = RxList<List<Point<int>>>();

  Rx<Despiece> despiece = Rx<Despiece>(Despiece(
      material: "",
      brand: "",
      thickness: "",
      colorQuality: "",
      piecesCount: PiecesCount(amount: [], long: [], width: []),
      hitch: Hitch(l1: [], l2: [], a1: []),
      drilling: Drilling(amount: [], side: []),
      slot: Slot(side: [], distance: [], prof: [], es: [])));

  Rx<PiecesCount> piecesCount =
      Rx<PiecesCount>(PiecesCount(amount: [], long: [], width: []));

  late InputImage inputImage;

  pickerImageOnPressed() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      pathImage(image.path);
      inputImage = InputImage.fromFile(File(pathImage.value));
    }
  }

  extractText() async {
    pointsAmount = RxList<List<Point<int>>>();
    pointsPiecesCountLog = RxList<List<Point<int>>>();
    pointsPiecesCountWidth = RxList<List<Point<int>>>();

    pointInitial = RxList<Point<int>>();
    pointsHitchL1 = RxList<List<Point<int>>>();
    pointsHitchL2 = RxList<List<Point<int>>>();
    pointsHitchA1 = RxList<List<Point<int>>>();

    int count = 0;
    int count_rows = 0;
    String cornerPointText = "";

    textObtained.value = "";
    textColumn.value = "";

    int rowPosition = 84;

    despiece.value = Despiece(
        material: "",
        brand: "",
        thickness: "",
        colorQuality: "",
        piecesCount: PiecesCount(amount: [], long: [], width: []),
        hitch: Hitch(l1: [], l2: [], a1: []),
        drilling: Drilling(amount: [], side: []),
        slot: Slot(side: [], distance: [], prof: [], es: []));

    TextRecognizer recognizerText = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText =
        await recognizerText.processImage(inputImage);
    final image = File(inputImage.filePath!);
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());

    sizeRow = (decodedImage.width - 84) ~/ 20;

    print(decodedImage.height);
    print(decodedImage.width);

    for (TextBlock block in recognizedText.blocks) {
      final List<Point<int>> cornerPointsElement = block.cornerPoints;
      count++;

      //print(cornerPointsElement.length);
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          textObtained.value += "line $count: " + block.text + "\n";
        }
      }

      despiece.value.material = despiece.value.material.isEmpty
          ? search_word("material", block.text, cornerPointsElement.obs)
          : despiece.value.material;
      despiece.value.brand = despiece.value.brand.isEmpty
          ? search_word("Marca", block.text, cornerPointsElement.obs)
          : despiece.value.brand;
      despiece.value.thickness = despiece.value.thickness.isEmpty
          ? search_word("espesor", block.text, cornerPointsElement.obs)
          : despiece.value.thickness;
      despiece.value.colorQuality = despiece.value.colorQuality.isEmpty
          ? search_word("color", block.text, cornerPointsElement.obs)
          : despiece.value.colorQuality;

      for (int i = 0; i < 4; i++) {
        /*print("(" +
            cornerPointsElement[i].x.toString() +
            "," +
            cornerPointsElement[i].y.toString() +
            ")");*/
        cornerPointText += "(" +
            cornerPointsElement[i].x.toString() +
            "," +
            cornerPointsElement[i].y.toString() +
            ")";
      }

      if (cornerPointsElement[0].x >= decodedImage.width * 0.33 &&
          cornerPointsElement[1].x <= decodedImage.width * 0.3842) {
        textColumn.value += block.text;
        despiece.value.piecesCount.amount.add(block.text);

        pointsAmount.add(cornerPointsElement);
      }
      textColumn.value += "\n";
      if (cornerPointsElement[0].x >= decodedImage.width * 0.35 &&
          cornerPointsElement[1].x <= decodedImage.width * 0.4472) {
        //textColumn.value += block.text;
        pointsPiecesCountLog.add(cornerPointsElement);
        despiece.value.piecesCount.long.add(block.text);
      }
      if (cornerPointsElement[0].x >= decodedImage.width * 0.4372 &&
          cornerPointsElement[1].x <= decodedImage.width * 0.49) {
        //textColumn.value += block.text;
        despiece.value.piecesCount.width.add(block.text);
        pointsPiecesCountWidth.add(cornerPointsElement);
      }
      if (cornerPointsElement[0].x >= decodedImage.width * 0.5034 &&
          cornerPointsElement[1].x <= decodedImage.width * 0.53) {
        //textColumn.value += block.text;
        pointsHitchL1.add(cornerPointsElement);
        despiece.value.hitch.l1.add(block.text);
      }
      if (cornerPointsElement[0].x >= decodedImage.width * 0.5432 &&
          cornerPointsElement[1].x <= decodedImage.width * 0.583) {
        //textColumn.value += block.text;
        pointsHitchL2.add(cornerPointsElement);
        despiece.value.hitch.l2.add(block.text);
      }
      if (cornerPointsElement[0].x >= decodedImage.width * 0.5962 &&
          cornerPointsElement[1].x <= decodedImage.width * 0.623) {
        //textColumn.value += block.text;
        pointsHitchA1.add(cornerPointsElement);
        despiece.value.hitch.a1.add(block.text);
      }

      // textObtained.value += "Cordenada: " + cornerPointText + "\n";
    }
    cornerPointText = "";

    print("rows: " + pointsAmount.value.length.toString());

    //orderText();
    despiece.value.piecesCount.amount =
        orderText(despiece.value.piecesCount.amount, pointsAmount);
    despiece.value.piecesCount.long =
        orderText(despiece.value.piecesCount.long, pointsPiecesCountLog);
    despiece.value.piecesCount.width =
        orderText(despiece.value.piecesCount.width, pointsPiecesCountWidth);
    despiece.value.hitch.l1 = orderText(despiece.value.hitch.l1, pointsHitchL1);
    despiece.value.hitch.l2 = orderText(despiece.value.hitch.l2, pointsHitchL2);
    despiece.value.hitch.a1 = orderText(despiece.value.hitch.a1, pointsHitchA1);

    final despieceJson = json.encode(despiece.value.toJson());
    jsonDespieceS(despieceJson);
    print(despieceJson);
  }

  List<String> orderText(
      List<String> items, RxList<List<Point<int>>> pointsOrder) {
    int sizeRowPoint = 0;
    sizeRow = 0;

    sizeRow = getSizeRow(pointsOrder);

    for (int i = 0; i < pointsOrder.length - 1; i++) {
      int separation = pointsOrder[i + 1][0].y - pointsOrder[i][2].y;
      //print("Separation: " + separation.toString());

      int x = (separation + sizeRow) ~/ (sizeRow + 5 + sizeRow);
      //print("cantidad de separación: " + (x - 1).toString());

      for (int j = 1; j < x; j++) {
        if (i < pointsOrder.length - 2) {
          items.insert(i + 1, "");
        } else {
          items.insert(i + 1, "");
        }
      }

      if (i == 0) {
        separation = pointsOrder[i][0].y - pointInitial[2].y;
        print("Point initial: " + pointInitial[2].toString());
        print("Separation: " + (separation.toString()));
      }
    }

    print(
        "sizeRowPoint: " + sizeRowPoint.toString() + "  " + sizeRow.toString());
    return items;
  }

  convertrExcel() async {
    var excel = Excel.createExcel();
    var sheet = excel['sheet1'];
    sheet.appendRow(['Material']);

    sheet.merge(CellIndex.indexByString("C5"), (CellIndex.indexByString("C6")));
    sheet.cell(CellIndex.indexByString("C5")).value = "N°";

    sheet.merge(CellIndex.indexByString("D5"), (CellIndex.indexByString("D6")));
    sheet.cell(CellIndex.indexByString("D5")).value = "TABLERO";

    sheet.merge(CellIndex.indexByString("E5"), (CellIndex.indexByString("G5")));
    sheet.cell(CellIndex.indexByString("E5")).value = "PIEZAS A CORTAR";

    sheet.cell(CellIndex.indexByString("E6")).value = "CANTA";
    sheet.cell(CellIndex.indexByString("F6")).value = "LONG";
    sheet.cell(CellIndex.indexByString("G6")).value = "ANCHO";

    sheet.merge(CellIndex.indexByString("H5"), (CellIndex.indexByString("K5")));
    sheet.cell(CellIndex.indexByString("H5")).value = "ENCHAPE";

    sheet.cell(CellIndex.indexByString("H6")).value = "L1";
    sheet.cell(CellIndex.indexByString("I6")).value = "L2";
    sheet.cell(CellIndex.indexByString("J6")).value = "A1";
    sheet.cell(CellIndex.indexByString("K6")).value = "A2";

    sheet.merge(CellIndex.indexByString("L5"), (CellIndex.indexByString("M5")));
    sheet.cell(CellIndex.indexByString("L5")).value = "PERFORACION";

    sheet.cell(CellIndex.indexByString("L6")).value = "CANT";
    sheet.cell(CellIndex.indexByString("M6")).value = "LADO";

    sheet.merge(CellIndex.indexByString("N5"), (CellIndex.indexByString("Q5")));
    sheet.cell(CellIndex.indexByString("N5")).value = "RANURAS";

    sheet.cell(CellIndex.indexByString("N6")).value = "LADO";
    sheet.cell(CellIndex.indexByString("O6")).value = "DIST";
    sheet.cell(CellIndex.indexByString("P6")).value = "PROF";
    sheet.cell(CellIndex.indexByString("Q6")).value = "ES";

    for (int i = 0; i < 20; i++) {
      sheet.cell(CellIndex.indexByString("C${i + 7}")).value =
          (i + 1).toString();
    }

    sheet.cell(CellIndex.indexByString("D7")).value = despiece.value.material;
    sheet.cell(CellIndex.indexByString("D8")).value = despiece.value.brand;
    sheet.cell(CellIndex.indexByString("D9")).value = despiece.value.thickness;
    sheet.cell(CellIndex.indexByString("D10")).value =
        despiece.value.colorQuality;

    for (int i = 0; i < despiece.value.piecesCount.amount.length; i++) {
      sheet.cell(CellIndex.indexByString("E${i + 7}")).value =
          despiece.value.piecesCount.amount[i];
    }

    for (int i = 0; i < despiece.value.piecesCount.long.length; i++) {
      sheet.cell(CellIndex.indexByString("F${i + 7}")).value =
          despiece.value.piecesCount.long[i];
    }
    for (int i = 0; i < despiece.value.piecesCount.width.length; i++) {
      sheet.cell(CellIndex.indexByString("G${i + 7}")).value =
          despiece.value.piecesCount.width[i];
    }

    for (int i = 0; i < despiece.value.hitch.l1.length; i++) {
      sheet.cell(CellIndex.indexByString("H${i + 7}")).value =
          despiece.value.hitch.l1[i];
    }
    for (int i = 0; i < despiece.value.hitch.l2.length; i++) {
      sheet.cell(CellIndex.indexByString("I${i + 7}")).value =
          despiece.value.hitch.l2[i];
    }
    for (int i = 0; i < despiece.value.hitch.a1.length; i++) {
      sheet.cell(CellIndex.indexByString("J${i + 7}")).value =
          despiece.value.hitch.a1[i];
    }
    /* for (int i = 0; i < despiece.value.hitch.a2.length; i++) {
      sheet.cell(CellIndex.indexByString("K7")).value =
          despiece.value.hitch.a2[i];
    }*/
    /* for (int i = 0; i < despiece.value.drilling.; i++) {
      sheet.cell(CellIndex.indexByString("L7")).value =
          despiece.value.perforation[i];
    }*/
    for (var row = 4; row <= 5; row++) {
      for (var col = 2; col <= 16; col++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
            .cellStyle = CellStyle(backgroundColorHex: "#5DADE2");
      }
    }
    excel.save(fileName: 'despiece.xlsx');
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final filePath = '${directory.path}/despiece.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(excel.save()!);

      // Abrir el archivo con una aplicación externa
      OpenFile.open(filePath);
    } else {
      print('No se pudo obtener el directorio de almacenamiento externo.');
    }
  }

  int getSizeRow(RxList<List<Point<int>>> pointCount) {
    int size = 0;
    int total = 0;
    for (int i = 0; i < pointCount.length; i++) {
      int x = pointCount[i][2].y - pointCount[i][0].y;
      total += x;
    }
    if (pointCount.length != 0) {
      size = total ~/ pointCount.length;
    } else {
      // Manejo para cuando pointCount.length es cero
      size = 0; // O cualquier otro valor que tenga sentido en tu contexto
    }
    return size;
  }

  String search_word(
      String word, String search, RxList<Point<int>> pointRecibe) {
    bool isContains = search.toLowerCase().contains(word.toLowerCase());
    if (isContains) {
      pointInitial = pointRecibe;
      return search;
    }
    return "";
  }

  captureDocumentImage() async {
    final imagesPath = await CunningDocumentScanner.getPictures();
    if (imagesPath!.isNotEmpty) {
      pathImage(imagesPath[0]);
      inputImage = InputImage.fromFile(File(pathImage.value));
      extractText();
    }
  }
}
