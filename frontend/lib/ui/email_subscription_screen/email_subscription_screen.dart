import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/functions/showToast.dart';
import 'package:frontend/services/forecast_subscription/forecast_subscription.dart';
import 'package:frontend/services/reponse.dart';
import 'package:frontend/ui/email_subscription_screen/widgets/confirm_email_dialog.dart';
import 'package:frontend/utils/logger.dart';
import 'package:frontend/widgets/my_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailSubscriptionScreen extends StatefulWidget {
  const EmailSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<EmailSubscriptionScreen> createState() =>
      _EmailSubscriptionScreenState();
}

class _EmailSubscriptionScreenState extends State<EmailSubscriptionScreen> {
  final inputController = TextEditingController();
  ForecastSubscriptionService forecastSubscriptionService =
      ForecastSubscriptionService();
  bool subscription = false;
  bool loading = false;
  String email = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubscribeGmail();
  }

  Future<void> getSubscribeGmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool containsKey = prefs.containsKey('subscribeGmail');
    subscription = containsKey;
    if (containsKey) {
      email = prefs.getString('subscribeGmail') ?? '';
    }
    setState(() {});
  }

  void subscribeForecastWeather(String email) async {
    ResponseAPI responseAPI =
        await forecastSubscriptionService.subsribeForecastWeather(email);

    if (responseAPI.statusCode == 200) {
      setState(() {
        loading = false;
        email = email;
      });
      showDialog(
          context: context,
          builder: (context) => ConfirmEmailDialog(
                email: email,
                success: () => setState(() {
                  subscription = true;
                }),
              ));
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

  Future<void> removeSubscribeGmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('subscribeGmail');
  }

  void unsubscribeForecastWeather() async {
    String? email = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool containsKey = prefs.containsKey('subscribeGmail');
    if (containsKey) {
      email = prefs.getString('subscribeGmail');
    }
    if (email == null || email.isEmpty) {
      ToastService.show(
          context: context,
          message: 'Unsubscribe successful!',
          status: StatusToast.success);
      setState(() {
        loading = false;
        subscription = false;
      });
      removeSubscribeGmail();
      return;
    }
    ResponseAPI responseAPI =
        await forecastSubscriptionService.unsubsribeForecastWeather(email);

    if (responseAPI.statusCode == 200) {
      setState(() {
        loading = false;
        subscription = false;
      });
      ToastService.show(
          context: context,
          message: 'Unsubscribe successful!',
          status: StatusToast.success);
      removeSubscribeGmail();
    } else {
      setState(() {
        loading = false;
      });
      ToastService.show(
          context: context,
          message: 'Ubsubscribe failed!',
          status: StatusToast.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      EasyLoading.show(status: 'Loading...');
    } else {
      EasyLoading.dismiss();
    }
    double widthScreen = MediaQuery.of(context).size.width;
    double formSize = widthScreen * 0.4;

    if (widthScreen <= 800) {
      formSize = widthScreen * 0.8;
    } else if (widthScreen <= 1200) {
      formSize = widthScreen * 0.6;
    }

    return Scaffold(
      backgroundColor: backgroudColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: primaryColor,
        centerTitle: false,
        leadingWidth: widthScreen * 0.06,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Forecast Subscription',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              width: formSize,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: !subscription
                  ? Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter your email address',
                            style: TextStyle(
                              height: 1,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Please enter your email address to subscribe to our service and receive the most accurate weather forecast every morning.',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 160, 160, 160)),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    loading = true;
                                  });
                                  subscribeForecastWeather(value);
                                } else {
                                  ToastService.show(
                                      context: context,
                                      message:
                                          'Please enter your email address!',
                                      status: StatusToast.error);
                                }
                              },
                              controller: inputController,
                              onChanged: (value) {
                                if (value.length == 1 || value.isEmpty) {
                                  setState(() {});
                                }
                              },
                              style: const TextStyle(fontSize: 20),
                              cursorColor: Colors.black,
                              cursorHeight: 24,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                                hintText: 'Example@gmail...',
                                hintStyle: const TextStyle(
                                    fontSize: 22,
                                    color: greyColor,
                                    fontWeight: FontWeight.w400),
                                suffixIcon: inputController.text.isNotEmpty
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              inputController.clear();
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromARGB(
                                                    255, 191, 191, 191),
                                              ),
                                              child: const FaIcon(
                                                FontAwesomeIcons.xmark,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(width: 1),
                                suffixIconConstraints:
                                    const BoxConstraints(minWidth: 50),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: greyColor,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: greyColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          MyButton(
                              onPressed: () {
                                print(inputController.text);
                                // showDialog(
                                //     context: context,
                                //     builder: (context) => ConfirmEmailDialog(
                                //           email: '',
                                //           success: () {},
                                //         ));
                                if (inputController.text.isNotEmpty) {
                                  setState(() {
                                    loading = true;
                                  });
                                  subscribeForecastWeather(
                                      inputController.text);
                                } else {
                                  ToastService.show(
                                      context: context,
                                      message:
                                          'Please enter your email address!',
                                      status: StatusToast.error);
                                }
                              },
                              color: primaryColor,
                              size: 66,
                              text: 'Subscribe'),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'You have successfully registered!',
                          style: TextStyle(
                            height: 1,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                                'Every morning, we will send the weather information to the email address ',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 160, 160, 160),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: email,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 90, 90, 90)),
                              ),
                              const TextSpan(
                                text: '.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 160, 160, 160),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        MyButton(
                            onPressed: () {
                              setState(() {
                                loading = true;
                              });
                              unsubscribeForecastWeather();
                            },
                            color: primaryColor,
                            size: 66,
                            text: 'Unsubscribe'),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
