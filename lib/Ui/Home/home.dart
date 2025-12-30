
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nested_json/Handler/handler.dart';
import 'package:nested_json/Models/models.dart';
import 'package:nested_json/Ui/SingleStringViewer/single_string_viewer.dart';
import 'package:nested_json/Ui/UpdateScreen/update_screen.dart';
import 'package:nested_json/Ui/Widgets/NodeUi/node_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DataHandler handler = DataHandler();

  @override
  void initState() {
    super.initState();
    handler.init();
  }

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(

      navigationBar:CupertinoNavigationBar(
        padding:EdgeInsetsDirectional.symmetric(
          horizontal:5,
          vertical:1
        ),
        middle: Text("Data Holder"),

      ),

      child:SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisSize:MainAxisSize.min,
                  children: [
                    CupertinoButton(onPressed: (){
                      handler.import();
                    }, child: Text("Import")),

                    CupertinoButton(onPressed: (){
                      handler.save();
                    }, child: Text("save"))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical:12
                  ),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton.filled(
                          onPressed: (){
                            Navigator.push(context, 
                              CupertinoPageRoute(builder: (_)=>
                               SingleStringViewer(value: handler.exportAsString())
                              )
                            );
                          },
                          padding:const EdgeInsets.symmetric(
                            vertical:2,
                            horizontal:8
                          ),
                          child: Text("export as string"),
                      ) ,

                      CupertinoButton.filled(
                          onPressed: ()async{
                            setState(() {
                              _loading = true;
                            });
                           try {
                             final j = handler.exportAsJson();
                             final fut = Future.delayed(const Duration(seconds:1));
                             final String? d = await FilePicker.platform.getDirectoryPath();
                             if(d == null )return;
                             final File file  = File("${d}/jsons/nested_${DateTime.now().millisecondsSinceEpoch}.json");
                             await file.create(recursive:true);
                             await file.writeAsString(j);
                             await fut;
                             SharePlus.instance.share(
                                 ShareParams(files:[XFile(file.path)]));
                           }catch(e){
                             print("object $e");
                           }finally {
                             setState(() {
                                _loading = false;
                             });
                           }

                          },
                          padding:const EdgeInsets.symmetric(
                              vertical:2,
                              horizontal:8
                          ),
                          child: _loading ? CupertinoActivityIndicator(
                            radius:8,
                            color:Colors.white,
                          ): Text("export as json file")
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: handler.notifier,
                    builder:(BuildContext context,_,__){
                      final nodes = handler.nodes;
                          
                      if(nodes.isEmpty){
                        return Center(
                          child:Text("There is no Data"),
                        );
                      }
                      return GestureDetector(
                        onLongPress:(){
                          _showPopActions();
                        },
                        child: CustomScrollView(
                          slivers: [
                            SliverList.builder(
                              itemCount: nodes.length,
                              itemBuilder:(BuildContext context,final int index){
                                final Node node = nodes[index];
                                return NodeSingleWidget(node: node,handler: handler,);
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        
            Align(
              alignment:Alignment.bottomLeft,
              child:GestureDetector(
                onTap:(){
                  Navigator.push(context, 
                    CupertinoPageRoute(builder: (_)=>
                      UpdateScreen(handler: handler)
                    )
                  );
                },
                child: Container(
                  height:60,
                  width:60 ,
                  margin:const EdgeInsets.all(20),
                  decoration:BoxDecoration(
                    color:Colors.blue.withValues(alpha:0.2),
                    borderRadius:BorderRadius.circular(20),
                  ),
                  child:Icon(Icons.add,color:Colors.black,
                    size:28,
                  ),
                ),
              ),
            )
          ],
        ),
      ));
  }

  void _showPopActions() {
    final context =this.context;

    showCupertinoModalPopup(
        context: context,
        builder: (context)=>CupertinoActionSheet(
          title:Text("Nodes Options"),
          actions: [
            CupertinoActionSheetAction(onPressed: (){
              final node = handler.copiedNode;
              if(node!=null){
                handler.nodes.add(Node.copy(node)..key = "${node.key} - Copy");
                handler.update();
              }
              Navigator.pop(context);
            },
                child: Text("Paste")),

            CupertinoActionSheetAction(onPressed: (){
              Navigator.pop(context);
            },
              isDestructiveAction:true,
                child: Text("cancel"),
            )
          ],
        ));
  }
}
