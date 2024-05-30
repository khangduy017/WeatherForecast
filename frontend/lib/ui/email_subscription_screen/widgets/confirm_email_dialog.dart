import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/functions/determinePosition.dart';
import 'package:frontend/functions/showToast.dart';
import 'package:frontend/services/forecast_subscription/forecast_subscription.dart';
import 'package:frontend/services/reponse.dart';
import 'package:frontend/ui/email_subscription_screen/widgets/verify_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmEmailDialog extends StatefulWidget {
  const ConfirmEmailDialog({
    Key? key,
    required this.email,
    required this.success,
  }) : super(key: key);

  final String email;
  final Function() success;

  @override
  State<ConfirmEmailDialog> createState() => _ConfirmEmailDialogState();
}

class _ConfirmEmailDialogState extends State<ConfirmEmailDialog> {
  ForecastSubscriptionService forecastSubscriptionService =
      ForecastSubscriptionService();
  bool loading = false;

  void verifyCode(String email, String code) async {
    String location = await determinePosition();
    ResponseAPI responseAPI =
        await forecastSubscriptionService.verifyCode(email, code, location);
    setState(() {
      loading = false;
    });
    if (responseAPI.statusCode == 200) {
      widget.success();
      // showDialog(
      //     context: context, builder: (context) => const ConfirmEmailDialog());
      Navigator.of(context).pop();
      ToastService.show(
          context: context,
          message: 'Registration successful!',
          status: StatusToast.success);
      saveSubscribeGmail(email);
    } else {
      ToastService.show(
          context: context,
          message: 'Your OTP code is incorrect, please check it again!',
          status: StatusToast.error);
    }
  }

  void resendCode(String email) async {
    ResponseAPI responseAPI =
        await forecastSubscriptionService.resendCode(email);

    if (responseAPI.statusCode == 200) {
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      ToastService.show(
          context: context,
          message: responseAPI.data.toString(),
          status: StatusToast.error);
    }
  }

  Future<void> saveSubscribeGmail(String gmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('subscribeGmail', gmail);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      EasyLoading.show(status: 'Loading...');
    } else {
      EasyLoading.dismiss();
    }
    final screenSize = MediaQuery.of(context).size;
    double formHeight = screenSize.height * 0.6;
    double formWidth = screenSize.width * 0.35;
    double padding = 20;
    if (screenSize.width <= 1400) {
      formWidth = screenSize.width * 0.45;
    }
    if (screenSize.width <= 1100) {
      formWidth = screenSize.width * 0.56;
    }
    if (screenSize.width <= 850) {
      formWidth = screenSize.width * 0.8;
      padding = 10;
    }
    // if (screenSize.width <= 600) {
    //   formWidth = screenSize.width;
    // }

    // print(screenSize.width);

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: formWidth,
        height: formHeight,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(padding, 25, padding, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter OTP code',
                    style: TextStyle(
                      height: 1,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Please check your email to enter the verification code we have sent in order to authenticate your email address.',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 160, 160, 160)),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  VerifyForm(
                    onVerify: (p0) {
                      setState(() {
                        loading = true;
                      });
                      verifyCode(widget.email, p0);
                      // ToastService.show(
                      //     context: context,
                      //     message:
                      //         'Your OTP code is incorrect, please check it again!',
                      //     status: StatusToast.error);
                    },
                    resendCode: () {
                      setState(() {
                        loading = true;
                      });
                      resendCode(widget.email);
                    },
                  )
                ],
              ),
            ),
            Positioned(
              right: -5,
              top: -5,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: greyColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
