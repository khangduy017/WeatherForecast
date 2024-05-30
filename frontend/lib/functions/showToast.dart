import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/constants/colors.dart';

enum StatusToast {
  info,
  warning,
  error,
  success,
  none,
}

class ToastService {
  static void show(
      {required BuildContext context,
      String message = '',
      StatusToast status = StatusToast.none}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2000),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(getIcon(status), color: Colors.white),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        backgroundColor: getColorToast(status),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 120,
            right: MediaQuery.of(context).size.width * 0.025,
            left: MediaQuery.of(context).size.width - 450),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );

    // Future.delayed(const Duration(milliseconds: 250), () {
    //   showToast(
    //     message,
    //     context: context,
    //     animation: StyledToastAnimation.none,
    //     reverseAnimation: StyledToastAnimation.fade,
    //     position: StyledToastPosition.top,
    //     animDuration: const Duration(milliseconds: 500),
    //     duration: const Duration(milliseconds: 2500),
    //     curve: Curves.easeIn,
    //     reverseCurve: Curves.linear,
    //     backgroundColor: getColorToast(status),
    //     textStyle: const TextStyle(color: Colors.white, fontSize: 18),
    //     borderRadius: const BorderRadius.all(Radius.circular(6)),
    //   );
    // });
  }
}

Color getColorToast(StatusToast type) {
  switch (type) {
    case StatusToast.info:
      return priorityColor;
    case StatusToast.warning:
      return statusColor;
    case StatusToast.error:
      return cardinalColor;
    case StatusToast.success:
      return fandangoColor;
    default:
      return raisinBlackColor;
  }
}

IconData getIcon(StatusToast type) {
  switch (type) {
    case StatusToast.warning:
      return FontAwesomeIcons.triangleExclamation;
    case StatusToast.error:
      return FontAwesomeIcons.solidCircleXmark;
    case StatusToast.success:
      return FontAwesomeIcons.solidCircleCheck;
    default:
      return FontAwesomeIcons.circleExclamation;
  }
}
