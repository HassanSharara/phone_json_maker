import 'package:flutter/cupertino.dart';
import 'package:nested_json/Handler/handler.dart';
import 'package:nested_json/Models/models.dart';
import 'package:nested_json/Ui/UpdateScreen/update_screen.dart';
import 'package:nested_json/Ui/Widgets/NodeInfo/node_info.dart';

class NodeSingleWidget extends StatefulWidget {
  const NodeSingleWidget({super.key,
   required this.node,
    required this.handler
  });
  final Node node;
  final DataHandler handler;
  @override
  State<NodeSingleWidget> createState() => _NodeSingleWidgetState();
}

class _NodeSingleWidgetState extends State<NodeSingleWidget> {
  Node get node => widget.node;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8,horizontal:5),
      child:GestureDetector(
        onLongPress:(){
          _showActionSheet(context);
        },
        child: CupertinoListTile(
          onTap:(){
            Navigator.push(context,
              CupertinoPageRoute(builder: (BuildContext context)=>
                NodeInfo(node: node, handler: widget.handler)
              )
            );
          },
          trailing: const CupertinoListTileChevron(),
          leading:GestureDetector(
              onTap:(){
                Navigator.push(context,
                 CupertinoPageRoute(
                   builder:(context)=> UpdateScreen(handler: widget.handler,
                     node:widget.node,
                   )
                 )
                );
              },
              child: Icon(CupertinoIcons.helm)),
          subtitle:Text(node.value is String ? node.value:""),
          title:Text(node.key,style:TextStyle(
            fontWeight:FontWeight.bold,
          ),
          semanticsLabel:node.value is String ? node.value.toString():"",
          ),
        ),
      ),
    );
  }
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Options for ${node.key}'),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              node.deleted = true;
              widget.handler.removeDeleters();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
