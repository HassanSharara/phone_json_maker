

import 'package:flutter/cupertino.dart';
import 'package:nested_json/Services/initializer.dart';
import 'package:nested_json/Ui/Home/home.dart';

Future<void> main()async {
  await AppInitializer.init();
  runApp(const App());
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner:false,
      home:const Launcher(),
    );
  }
}

class Launcher extends StatelessWidget {
  const Launcher({super.key});

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}
