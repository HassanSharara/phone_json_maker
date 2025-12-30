
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nested_json/Handler/handler.dart';
import 'package:nested_json/Models/models.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key,required this.handler,
    this.node,
    this.fatherNode
  });
  final DataHandler handler;
  final Node? node,fatherNode;
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

enum ValueType {
  string,
  node
}
class _UpdateScreenState extends State<UpdateScreen> {

  final TextEditingController key = TextEditingController();
  final ValueNotifier<ValueType> notifier = ValueNotifier(
    ValueType.string
  );
  final TextEditingController value = TextEditingController();

  Node? get node => widget.node;

  @override
  void initState() {
    key.text = node?.key ??'';
    if(node?.value is String) {
      value.text = node?.value??"";
    } else {
      notifier.value = ValueType.node;
    }
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    Future.delayed(const Duration(seconds:5))
    .then((_){
      key.dispose();
      notifier.dispose();
    });
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:CupertinoNavigationBar(
        middle: Text("Update Node"),
      ),
      child: SafeArea(
        child: ListView(
          padding:const EdgeInsets.symmetric(
            horizontal:5,
            vertical:10
          ),
          children: [
            const SizedBox(height:20),
            if(widget.fatherNode!=null)
            Column(
              mainAxisAlignment:MainAxisAlignment.center,
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                Container(
                  padding:const EdgeInsets.all(18),
                  decoration:BoxDecoration(
                    shape:BoxShape.circle,
                    color:Colors.blue
                  ),
                  child:Text(widget.fatherNode!.key,
                    style:TextStyle(
                      color: Colors.white,
                      fontSize:11
                    ),
                  ),
                ),
                const SizedBox(height:2,),
                const Icon(Icons.arrow_downward_rounded)
              ],
            ),
            const SizedBox(height:20),
            CupertinoTextField(
              controller: key,
              placeholder: "Key",
              maxLines:2,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),

            const SizedBox(height:20),
            ValueListenableBuilder(
              valueListenable:notifier,
              builder:(BuildContext context,type,_){
                return ListView(
                  shrinkWrap:true,
                  primary:false,
                  children: [
                    GestureDetector(
                      onTap:(){
                        showCupertinoModalPopup(context: context,
                            builder:(BuildContext context){
                           return CupertinoActionSheet(
                             title: Text("chose value type"),
                             actions: [
                             for(final t in ValueType.values)
                               CupertinoActionSheetAction(
                                   onPressed: (){
                                     notifier.value = t;
                                     Navigator.pop(context);
                                   },
                                   child: Text(t.name))
                             ],
                           );
                            });
                      },
                      child: CupertinoListTile(
                        title:Text(type.name,
                         style:TextStyle(
                           fontWeight:FontWeight.bold,
                         ),
                        ),
                        trailing:const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                    if(type == ValueType.string)
                    ...[

                        const SizedBox(height:20),
                        CupertinoTextField(
                          controller: value,
                          placeholder: "Value",
                          maxLines: 10,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),

                      ]



                  ],
                );
              },
            ),

            const SizedBox(height:30,),

            CupertinoButton(onPressed: _save, child: Text("save"))
          ],
        ),
      ),
    );
  }

  _save()async{
    if(key.text.isEmpty){
      return;
    }
    final node = this.node ?? Node("","");
    node.key = key.text;
    if(notifier.value == ValueType.node) {
      node.value = <Node>[];
    }else {
      node.value = value.text;
    }
    if(this.node == null ) {
      if(widget.fatherNode != null ) {
        final l = widget.fatherNode!.value as List<Node>;
        l.add(node);
      } else {
        widget.handler.nodes.add(node);
      }
    }
    await widget.handler.update();
    final context= this.context;
    if(!context.mounted)return;
    Navigator.pop(context);
  }
}
