import 'package:dans_productivity_app_flutter/src/screens/create-log.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      width: 53,
      child: FloatingActionButton(
          backgroundColor: Colors.black,
          elevation: 1.5,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateLogScreen()));
          },
          child: Text(
            String.fromCharCode(Icons.add_rounded.codePoint),
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: Icons.add_rounded.fontFamily,
              package: Icons.add_rounded.fontPackage,
            ),
          )),
    );
  }
}
