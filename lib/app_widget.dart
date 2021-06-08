
import 'package:cad_sprint/app/screens/sprint/sprint_module.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
     return MaterialApp(
       theme: ThemeData.light(),
       home: SprintModule(),
     );
  }
}