import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        //TODO instead take a ontap callback from the function itself and do widget.onTap for properly functioning
      },
      child: const Icon(AntDesign.leftcircleo),
    );
  }
}
