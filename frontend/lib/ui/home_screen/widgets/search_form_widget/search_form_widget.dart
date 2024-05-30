import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/functions/determinePosition.dart';
import 'package:frontend/functions/showToast.dart';
import 'package:frontend/services/weather/weather.dart';
import 'package:frontend/ui/home_screen/widgets/divide_widget/divide_widget.dart';
import 'package:frontend/utils/logger.dart';
import 'package:frontend/widgets/my_button.dart';

class SearchFormWidget extends StatefulWidget {
  const SearchFormWidget({super.key, required this.onSearch});
  final Function(String) onSearch;

  @override
  _SearchFormWidgetState createState() => _SearchFormWidgetState();
}

class _SearchFormWidgetState extends State<SearchFormWidget> {
  final inputController = TextEditingController();
  WeatherService weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter a City Name',
          style: TextStyle(
            height: 1,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 60,
          child: TextFormField(
            onFieldSubmitted: (value) {
              if (inputController.text.isNotEmpty) {
                widget.onSearch(inputController.text);
              } else {
                ToastService.show(
                    context: context,
                    message: 'Please enter a city name!',
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              hintText: 'E.g., New York, London, Tokyo',
              hintStyle: const TextStyle(
                  fontSize: 22, color: greyColor, fontWeight: FontWeight.w400),
              suffixIcon: inputController.text.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              color: Color.fromARGB(255, 191, 191, 191),
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
              suffixIconConstraints: const BoxConstraints(minWidth: 50),
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
        const SizedBox(height: 24),
        MyButton(
            onPressed: () {
              print(inputController.text);
              if (inputController.text.isNotEmpty) {
                widget.onSearch(inputController.text);
              } else {
                ToastService.show(
                    context: context,
                    message: 'Please enter a city name!',
                    status: StatusToast.error);
              }
            },
            color: primaryColor,
            size: 66,
            text: 'Search'),
        const SizedBox(height: 18),
        const DivideWidget(),
        const SizedBox(height: 18),
        MyButton(
            onPressed: () async {
              EasyLoading.show();
              String latLng = await determinePosition();
              logger.d(latLng);
              widget.onSearch(latLng);
              inputController.clear();
            },
            color: const Color(0xff6C757E),
            size: 66,
            text: 'Use Current Location'),
      ],
    );
  }
}
