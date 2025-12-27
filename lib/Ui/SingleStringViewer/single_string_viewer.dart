
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class SingleStringViewer extends StatelessWidget {
  const SingleStringViewer({super.key,
   required this.value
  });
  final String value;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:CupertinoNavigationBar(
      ),
      child:SafeArea(
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              const SizedBox(height:8,),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton.filled(onPressed: (){
                    Clipboard.setData(ClipboardData(text: value));
                  }, child: Text("Copy")),
                  CupertinoButton.filled(onPressed: (){
                    SharePlus.instance.share(ShareParams(text:value));
                  }, child: Text("Share")),
                ],
              ),
              const SizedBox(height:20,),
              Expanded(child: SizedBox.expand(child: Text(value,textAlign:TextAlign.start,))),
            ],
          ),
        ),
      ),
    );
  }
}
