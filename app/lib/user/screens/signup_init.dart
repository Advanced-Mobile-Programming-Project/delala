import 'signup.dart';

class SignUpInit extends StatefulWidget {
  final bool visible;

  SignUpInit({this.visible});

  _SignUpInit createState() => _SignUpInit();
}

class _SignUpInit extends State<SignUpInit> {
  FocusNode _firstNameFocusNode;
  FocusNode _lastNameFocusNode;
  FocusNode _phoneFocusNode;
  FocusNode _buttonFocusNode;

  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _phoneController;

  String _firstNameErrorText;
  String _lastNameErrorText;
  String _phoneNumberErrorText;
  String _phoneNumberHint = "*  *  *   *  *  *   *  *  *  *";
  String _areaCode = '+251';
  String _countryCode = "ET";
  bool _loading = false;

  User user;

  String _autoValidateFirstName(String value) {
    if (value.isEmpty) {
      return null;
    }
    return _validateFirstName(value);
  }

  String _validateFirstName(String value) {
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

  String _autoValidateLastName(String value) {
    if (value.isEmpty) {
      return null;
    }

    return _validateLastName(value);
  }

  String _validateLastName(String value) {
    var exp = RegExp(r"^\w*$");

    if (!exp.hasMatch(value)) {
      return ReCase("last name should only contain alpha numerical values")
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

    var firstName = _firstNameController.text;
    var lastName = _lastNameController.text;
    var phoneNumber = _phoneController.text;

    var firstNameError = _validateFirstName(firstName);
    var lastNameError = _validateLastName(lastName);
    var phoneNumberError = await _validatePhoneNumber(phoneNumber);

    if (firstName.isEmpty) {
      setState(() {
        _firstNameErrorText = ReCase(EmptyEntryError).sentenceCase;
      });
    } else if (firstNameError != null) {
      setState(() {
        _firstNameErrorText = firstNameError;
      });
    }

    if (lastNameError != null) {
      setState(() {
        _lastNameErrorText = lastNameError;
      });
    }

    if (phoneNumberError != null) {
      setState(() {
        _phoneNumberErrorText = phoneNumberError;
      });
    }

    if (firstNameError != null ||
        lastNameError != null ||
        phoneNumberError != null) {
      return;
    }

    // Removing the final error at the start
    setState(() {
      _loading = true;
      _firstNameErrorText = null;
      _phoneNumberErrorText = null;
    });

    phoneNumber = _withCountryCode(await _transformPhoneNumber(phoneNumber));
    final UserEvent event = UserCreateInit(
      User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber),
    );
    // user = User(
    //     firstName: "Benyam", lastName: "Simayehu", phoneNumber: "0900010197");
    // final UserEvent event = UserCreateInit(user);

    BlocProvider.of<UserBloc>(context).add(event);
  }

  void _onSuccess(User user) {
    UserEvent event = UserCreateToPage2();
    BlocProvider.of<UserBloc>(context).add(event);

    event = UserCreatePauseEvent(user);
    BlocProvider.of<UserBloc>(context).add(event);
  }

  void _onError(Map<String, dynamic> errMap) {
    errMap.forEach((key, error) {
      switch (key) {
        case "first_name":
          setState(() {
            _firstNameErrorText = ReCase(error).sentenceCase;
          });
          break;
        case "last_name":
          setState(() {
            _lastNameErrorText = ReCase(error).sentenceCase;
          });
          break;
        case "phone_number":
          if (error == PhoneNumberAlreadyExistsErrorB) {
            error = PhoneNumberAlreadyExistsError;
          }
          _phoneNumberErrorText = ReCase(error).sentenceCase;
          break;
        case "error":
          if (errMap[key] == FailedOperationError) {
            showServerError(context, FailedOperationError);
          } else if (errMap[key] == SomethingWentWrongError) {
            showServerError(context, SomethingWentWrongError);
          }
          return;
      }
    });
  }

  void _handleBuilderResponse(UserState state) {
    print("Hello builder...............");
    if (state is UserCreateInitSuccess) {
      _onSuccess(state.user);
      // Stop loading after response received
      _loading = false;
    } else if (state is UserCreateInitFailure) {
      _onError(state.errorMap);
      _loading = false;
    }
    if (state is OperationFailure) {
      _loading = false;
    }
  }

  void _handleListenerResponse(UserState state) {
    if (state is OperationFailure) {
      showServerError(context, SomethingWentWrongError);
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

    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _buttonFocusNode = FocusNode();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
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
    _firstNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible ?? false,
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          _handleListenerResponse(state);
        },
        builder: (context, state) {
          // Bloc response handler
          _handleBuilderResponse(state);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _firstNameController,
                  focusNode: _firstNameFocusNode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    isDense: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "First Name",
                    errorText: _firstNameErrorText,
                  ),
                  autovalidateMode: AutovalidateMode.always,
                  validator: _autoValidateFirstName,
                  onChanged: (_) => this.setState(() {
                    _firstNameErrorText = null;
                  }),
                  textCapitalization: TextCapitalization.sentences,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextFormField(
                  controller: _lastNameController,
                  focusNode: _lastNameFocusNode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Last Name",
                    errorText: _lastNameErrorText,
                    isDense: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  autovalidateMode: AutovalidateMode.always,
                  validator: _autoValidateLastName,
                  onChanged: (_) => this.setState(() {
                    _lastNameErrorText = null;
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
          );
        },
      ),
    );
  }
}
