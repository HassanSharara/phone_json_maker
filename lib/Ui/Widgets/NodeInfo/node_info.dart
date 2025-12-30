
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nested_json/Handler/handler.dart';
import 'package:nested_json/Models/models.dart';
import 'package:nested_json/Ui/UpdateScreen/update_screen.dart';
import 'package:nested_json/Ui/Widgets/NodeUi/node_ui.dart';

class NodeInfo extends StatelessWidget {
  const NodeInfo({super.key,
   required this.node,
    required this.handler
  });
  final Node node;
  final DataHandler handler;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:CupertinoNavigationBar(
        middle:Text("Node info"),
      ),
      child:SafeArea(child:
        Stack(
          children: [
            ValueListenableBuilder(
              valueListenable:handler.notifier,
              builder:(BuildContext context,_,__){
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: const SizedBox(height:20,),),
                    SliverToBoxAdapter(
                        child:
                        Column(
                          mainAxisAlignment:MainAxisAlignment.center,
                          crossAxisAlignment:CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:const EdgeInsets.all(30),
                              decoration:BoxDecoration(
                                  shape:BoxShape.circle,
                                  color:node.isHide ? Colors.blueGrey:Colors.blue
                              ),
                              child:Text(node.key,
                                style:TextStyle(
                                    color: Colors.white,
                                    fontSize:10
                                ),
                              ),
                            ),
                            const SizedBox(height:2,),
                            const Icon(Icons.arrow_downward_rounded)
                          ],
                        ),),

                    SliverToBoxAdapter(child: const SizedBox(height:10,),),


                    if (node.value is String)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,
                           vertical:20
                          ),
                          child: Text(node.value,style:TextStyle(
                            fontWeight:FontWeight.bold,
                            fontSize:20
                          ),
                           textAlign:TextAlign.center,
                          ),
                        ),
                      )
                    else ...[

                      SliverList.builder(
                        itemCount:(node.value as List).length,
                        itemBuilder:(BuildContext context,final int index){
                          final l = node.value as List<Node>;
                          return NodeSingleWidget(node: l[index], handler: handler);
                        },
                      )
                    ]
                  ],
                );
              },
            ),

            Align(
              alignment: const Alignment(-0.9,0.9),
              child: GestureDetector(
                onTap:(){
                  Navigator.push(context, 
                   CupertinoPageRoute(builder: (_)=>
                    UpdateScreen(handler: handler,fatherNode:node,)
                   )
                  );
                },
                child: Container(
                  height:60,
                  width:60,
                  padding:const EdgeInsets.all(10),
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(20),
                    color:Colors.blue.shade200
                  ),
                  child:const Icon(Icons.add,color:Colors.black,),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
  void _showPopActions(final BuildContext context) {

    showCupertinoModalPopup(
        context: context,
        builder: (context)=>CupertinoActionSheet(
          title:Text("Nodes Options"),
          actions: [
            CupertinoActionSheetAction(onPressed: (){
              final n = handler.copiedNode;
              final value = node.value;
              if(n!=null && value is List<Node>){
                value.add(Node.copy(n)..key = '${n.key} - Copy');
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
