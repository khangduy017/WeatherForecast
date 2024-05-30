import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

class DivideWidget extends StatelessWidget {
  const DivideWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(
            color: greyColor, // Set the color to grey
          ),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text("or",
                style: TextStyle(color: greyColor, fontSize: 20))),
        const Expanded(
          child: Divider(
            color: greyColor, // Set the color to grey
          ),
        ),
      ],
    );
  }
}
