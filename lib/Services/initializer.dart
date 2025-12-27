


import 'package:hive_flutter/adapters.dart';
import 'package:nested_json/Constants/Boxes/boxes.dart';

final class AppInitializer {
  AppInitializer._();

  static Future<void> init()async{
    await Hive.initFlutter();
    await Hive.openBox(BoxesConstants.holder);
  }
}