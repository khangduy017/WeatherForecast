import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/utils/logger.dart';
import 'package:frontend/widgets/my_button.dart';
import 'package:frontend/widgets/shake_error.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyForm extends StatefulWidget {
  const VerifyForm({Key? key, required this.onVerify}) : super(key: key);
  final Function(String) onVerify;

  @override
  _VerifyFormState createState() => _VerifyFormState();
}

class _VerifyFormState extends State<VerifyForm> {
  final TextEditingController otpCode = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double fieldWidth = 65;
    double fieldHeight = 80;
    if (screenSize.width <= 700) {
      fieldWidth = screenSize.width * 0.1;
      fieldHeight = 70;
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ShakeWidget(
                  key: _shakeKey,
                  shakeCount: 3,
                  shakeOffset: 10,
                  child: PinCodeTextField(
                    onCompleted: (value) {
                      print(value);
                    },
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                    controller: otpCode,
                    length: 6,
                    cursorHeight: 30,
                    cursorWidth: 1.5,
                    animationType: AnimationType.fade,
                    enableActiveFill: true,
                    textStyle: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldWidth: fieldWidth,
                      fieldHeight: fieldHeight,
                      inactiveColor: Colors.grey.shade400,
                      selectedColor: primaryColor,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      inactiveBorderWidth: 1,
                      activeBorderWidth: 2,
                      selectedBorderWidth: 1.5,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 35,
          ),
          MyButton(
              onPressed: () {
                logger.d(otpCode.text);
                widget.onVerify(otpCode.text);
              },
              color: primaryColor,
              size: 66,
              text: 'Confirm'),
          const SizedBox(
            height: 15,
          ),
          Wrap(
            spacing: 5,
            children: [
              const Text(
                'Haven\'t received the OTP code?',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 160, 160, 160),
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  'Resend',
                  style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
