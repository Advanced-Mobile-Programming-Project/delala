import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:delala/models/errors.dart';
import 'package:delala/user/bloc/bloc.dart';
import 'package:delala/user/bloc/user_bloc.dart';
import 'package:delala/user/bloc/user_event.dart';
import 'package:delala/user/bloc/user_state.dart';
import 'package:delala/user/models/user.dart';
import 'package:delala/utils/show.snackbar.dart';
import 'package:delala/widgets/button/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:http/http.dart' as http;
import 'package:recase/recase.dart';

class SignUpInit extends StatefulWidget {
  final bool visible;
  final StreamController<String> nonceController;

  SignUpInit({this.visible, @required this.nonceController});

  _SignUpInit createState() => _SignUpInit();
}

class _SignUpInit extends State<SignUpInit> {
  FocusNode _userNameFocusNode;
  FocusNode _phoneFocusNode;
  FocusNode _buttonFocusNode;

  TextEditingController _userNameController;
  TextEditingController _phoneController;

  String _userNameErrorText;
  String _phoneNumberErrorText;
  String _phoneNumberHint = "*  *  *   *  *  *   *  *  *  *";
  String _areaCode = '+251';
  String _countryCode = "ET";
  bool _loading = false;

  String _autoValidateUserName(String value) {
    if (value.isEmpty) {
      return null;
    }
    return _validateUserName(value);
  }

  String _validateUserName(String value) {
    var exp1 = RegExp(r"^[a-zA-Z]\w*$");
    var exp2 = RegExp(r"^[a-zA-Z]");

    if (!exp2.hasMatch(value)) {
      return ReCase("name should only start with a letter").sentenceCase;
    }

    if (!exp1.hasMatch(value)) {
      return ReCase("first name should only contain alpha numerical values")
          .sentenceCase;
    }

    return null;
  }

  Future<String> _validatePhoneNumber(String value) async {
    if (value.isEmpty) {
      return ReCase(EmptyEntryError).sentenceCase;
    }

    try {
      // Validating phone number
      await FlutterLibphonenumber().parse(await _transformPhoneNumber(value));
    } catch (e) {
      return ReCase(InvalidPhoneNumberError).sentenceCase;
    }

    return null;
  }

  Future<String> _transformPhoneNumber(String phoneNumber) async {
    try {
      Map<String, dynamic> parsed =
          await FlutterLibphonenumber().parse(_areaCode + phoneNumber);
      phoneNumber = _areaCode + parsed["national_number"];
      return phoneNumber;
    } catch (e) {}

    return phoneNumber;
  }

  void _signUpInit() async {
    // Cancelling if loading
    if (_loading) {
      return;
    }

    var userName = _userNameController.text;
    var phoneNumber = _phoneController.text;

    var userNameError = _validateUserName(userName);
    var phoneNumberError = await _validatePhoneNumber(phoneNumber);

    if (userName.isEmpty) {
      setState(() {
        _userNameErrorText = ReCase(EmptyEntryError).sentenceCase;
      });
    } else if (userNameError != null) {
      setState(() {
        _userNameErrorText = userNameError;
      });
    }

    if (phoneNumberError != null) {
      setState(() {
        _phoneNumberErrorText = phoneNumberError;
      });
    }

    if (userNameError != null || phoneNumberError != null) {
      return;
    }

    // Removing the final error at the start
    setState(() {
      _loading = true;
      _userNameErrorText = null;
      _phoneNumberErrorText = null;
    });

    phoneNumber = _withCountryCode(await _transformPhoneNumber(phoneNumber));
    final UserEvent event = UserCreate(
      User.forEvent(userName: userName, phoneNumber: phoneNumber),
    );

    BlocProvider.of<UserBloc>(context).add(event);

    // Stop loading after response received
    setState(() {
      _loading = false;
    });
  }

  void _onSuccess(http.Response response) {
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     CoursesList.routeName, (route) => false);
  }

  void _onError(http.Response response) {
    String error = "";
    switch (response.statusCode) {
      case HttpStatus.badRequest:
        var jsonData = json.decode(response.body);
        jsonData.forEach((key, value) {
          error = jsonData[key];
          switch (key) {
            case "user_name":
              _userNameErrorText = ReCase(error).sentenceCase;
              break;
            case "phone_number":
              if (error == PhoneNumberAlreadyExistsErrorB) {
                error = PhoneNumberAlreadyExistsError;
              }
              _phoneNumberErrorText = ReCase(error).sentenceCase;
              break;
          }
        });
        return;
      case HttpStatus.internalServerError:
        error = FailedOperationError;
        break;
      default:
        error = SomethingWentWrongError;
    }

    showServerError(context, error);
  }

  void _handleBlocResponse(UserState state) {
    if (state is UserLoadSuccess) {
      _onSuccess(state.response);
    } else if (state is OperationFailure) {
      if (state.e is SocketException) {
        showUnableToConnectError(context);
      } else {
        showServerError(context, SomethingWentWrongError);
      }
    } else if (state is UserOperationFailure) {
      _onError(state.response);
    }
  }

  String _withCountryCode(String phoneNumber) {
    return phoneNumber + "[" + _countryCode + "]";
  }

  String _getPhoneNumberHint() {
    var selectedCountry = CountryManager().countries.firstWhere(
        (element) =>
            element.phoneCode == _areaCode.replaceAll(RegExp(r'[^\d]+'), ''),
        orElse: () => null);

    String hint = selectedCountry?.exampleNumberMobileNational ??
        " *  *  *  *  *  *  *  *  *";
    hint = hint
        .replaceAll(RegExp(r'[\d]'), " * ")
        .replaceAll(RegExp(r'[\-\(\)]'), "");
    return hint;
  }

  String _formatTextController(String phoneNumber) {
    if (phoneNumber.isEmpty) return "";

    String formatted = LibPhonenumberTextFormatter(
      phoneNumberType: PhoneNumberType.mobile,
      phoneNumberFormat: PhoneNumberFormat.national,
      overrideSkipCountryCode: _countryCode,
    )
        .formatEditUpdate(
            TextEditingValue.empty, TextEditingValue(text: phoneNumber))
        .text;
    return formatted.trim();
  }

  @override
  void initState() {
    super.initState();

    FlutterLibphonenumber().init();

    _userNameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _buttonFocusNode = FocusNode();

    _userNameController = TextEditingController();
    _phoneController = TextEditingController();

    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) {
        var phoneNumber = _phoneController.text;
        if (phoneNumber != null && phoneNumber.isNotEmpty) {
          _validatePhoneNumber(phoneNumber).then((value) {
            if (mounted) {
              setState(() {
                _phoneNumberErrorText = value;
              });
            }
          });
        }
        setState(() {
          _phoneNumberHint = _getPhoneNumberHint();
        });
      } else {
        setState(() {
          _phoneNumberHint = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        _handleBlocResponse(state);
        return Visibility(
          visible: widget.visible ?? false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _userNameController,
                  focusNode: _userNameFocusNode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    isDense: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "First Name",
                    errorText: _userNameErrorText,
                  ),
                  autovalidateMode: AutovalidateMode.always,
                  validator: _autoValidateUserName,
                  onChanged: (_) => this.setState(() {
                    _userNameErrorText = null;
                  }),
                  textCapitalization: TextCapitalization.sentences,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Contact Information",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    decoration: InputDecoration(
                      prefixIcon: CountryCodePicker(
                        textStyle: TextStyle(fontSize: 11),
                        initialSelection: _countryCode,
                        favorite: ['+251'],
                        onChanged: (CountryCode countryCode) {
                          _countryCode = countryCode.code;
                          _areaCode = countryCode.dialCode;
                          _phoneController.text =
                              _formatTextController(_phoneController.text);
                          setState(() {
                            _phoneNumberHint = _getPhoneNumberHint();
                          });
                        },
                        alignLeft: false,
                      ),
                      border: const OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Phone number",
                      hintText: _phoneNumberHint,
                      errorText: _phoneNumberErrorText,
                      errorMaxLines: 2,
                    ),
                    enableInteractiveSelection: false,
                    inputFormatters: [
                      LibPhonenumberTextFormatter(
                        phoneNumberType: PhoneNumberType.mobile,
                        phoneNumberFormat: PhoneNumberFormat.national,
                        overrideSkipCountryCode: _countryCode,
                      ),
                    ],
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => this.setState(() {
                          _phoneNumberErrorText = null;
                        }),
                    onFieldSubmitted: (_) => _signUpInit()),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: LoadingButton(
                        loading: _loading,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(_buttonFocusNode);
                          _signUpInit();
                        },
                        padding: EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
