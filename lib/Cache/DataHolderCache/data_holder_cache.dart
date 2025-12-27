

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nested_json/Constants/Boxes/boxes.dart';

final class DataHolderCache {

  final Box box = Hive.box(BoxesConstants.holder);

  String get key => BoxesConstants.holder;

  dynamic get(){
    return box.get(key);
  }

  Future<void> save(final dynamic data)async{
   await box.put(key,data);
  }
 }