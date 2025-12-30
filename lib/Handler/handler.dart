

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:nested_json/Cache/DataHolderCache/data_holder_cache.dart';
import 'package:nested_json/Models/models.dart';

final class DataHandler {

  final DataHolderCache cache = DataHolderCache();
  final ValueNotifier<bool> notifier = ValueNotifier(false);
  List<Node> nodes = [];

  init(){
    final dynamic data = cache.get();
    if( data is! Map)return;
    nodes = data.toListOfNode;
    _changeNotifier();
  }

  _changeNotifier(){
    if(_disposed)return;
    notifier.value = !notifier.value;
  }


  update(){
    save();
    _changeNotifier();
  }
  save()async{
    await cache.save(nodes.toMap);
  }


  Node? copiedNode;
  copyNode(final Node node){
    copiedNode = node;
  }
  duplicateNode(final Node node){
    final r = nodes.getNode(node);
    if(r == null )return;
    r.$1.insert(r.$2,Node.copy(node)..key = "${node.key} - Copy");
    update();
  }

  bool _disposed = false;
  dispose(){
    if(_disposed)return;
    _disposed = true;
    notifier.dispose();
  }


  removeDeleters(){
    nodes.removeDeleters();
    update();
  }
}

extension Deleters on List<Node>{

  (List<Node>,int,Node)? getNode(final Node node){
    for(int i =0;i<length;i++){
      final n = this[i];
      if( n == node) return (this,i,n);
      final v = n.value;
      if(v is List<Node>)return v.getNode(node);
    }
    return null;
  }
  removeDeleters(){
    removeWhere((e){
      final r = e.deleted;
      return r;
    });
    for( final e in this){
      final v = e.value;
      if( v is List<Node>)v.removeDeleters();
    }
  }
}
extension Importers on DataHandler {

  import() async {
    try{
      final files = await FilePicker.platform.pickFiles(
        allowMultiple:false,
        );
      if( files != null && files.files.isEmpty)return;
      final File file = File(files!.files.first.path.toString());
      final data = await file.readAsString();
      final j = json.decode(data);

      if( j is! Map)return;
      nodes = j.toListOfNode;
      _changeNotifier();
    }
    catch(_){
    }
  }
}
extension Exporters on DataHandler {

  String exportAsString(){
    String res = "";
    for(final node in nodes){
      res += node.totalNodeToString();
      res+="\n";
    }
    return res;
  }

  String exportAsJson(){
    final map = nodes.toMap;
    final j = json.encode(map);
    return j;
  }
}

