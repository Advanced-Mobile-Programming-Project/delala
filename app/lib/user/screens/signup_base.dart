import 'package:delala/user/screens/signup.dart';

class SignUp extends StatefulWidget {
  static String routeName = "/sign_up";

  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> with TickerProviderStateMixin {
  AnimationController _slideController;
  AnimationController _step1Controller;
  AnimationController _step2Controller;
  AnimationController _step3Controller;
  AnimationController _shakeController;

  StreamController<bool> _passwordIsNewController;

  String _passwordNonce;

  int _currentStep = 1;
  int _pausedStep = 1;
  Tween<Offset> _slideTween;
  double _progressValue = 0;
  bool _willPopValue = true;

  List<Widget> _listOfStepWidget;

  void _initAnimationControllers() {
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _step1Controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 700),
    );

    _step2Controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 700),
    );

    _step3Controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 700),
    );

    _shakeController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _slideTween = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0));

    _slideController.forward();
    _step1Controller.forward();
  }

  void _initStreams() {
    _passwordIsNewController = StreamController();
  }

  void _switchStep(int step) {
    if (this._pausedStep < step) {
      return;
    }

    _listOfStepWidget = [
      SignUpInit(),
      SignUpFinish(disable: _disableBackButton),
      SignUpCompleted(
        controller: _shakeController,
      ),
    ];

    // Changing size of previous step
    switch (this._currentStep) {
      case 1:
        setState(() {
          _step1Controller.reverse();
          _step1Controller.dispose();
          _step1Controller = AnimationController(
            vsync: this,
            duration: Duration(microseconds: 700),
          );
        });
        break;

      case 2:
        setState(() {
          _step2Controller.reverse();
          _step2Controller.dispose();
          _step2Controller = AnimationController(
            vsync: this,
            duration: Duration(microseconds: 700),
          );
        });
        break;

      case 3:
        setState(() {
          _step3Controller.reverse();
          _step3Controller.dispose();
          _step3Controller = AnimationController(
            vsync: this,
            duration: Duration(microseconds: 700),
          );
        });
        break;
    }

    switch (step) {
      case 1:
        _progressValue = 0;
        _step1Controller.forward();
        _listOfStepWidget[0] = SignUpInit(visible: true);
        break;

      case 2:
        _progressValue = 0.5;
        _step2Controller.forward();
        _listOfStepWidget[1] = SignUpFinish(
          visible: true,
          nonce: _passwordNonce,
          disable: _disableBackButton,
        );
        break;

      case 3:
        _progressValue = 1;
        _step3Controller.forward();
        _listOfStepWidget[2] = SignUpCompleted(
          controller: _shakeController,
          visible: true,
        );
        break;
    }

    // Called just for rendering the screen
    setState(() {
      this._currentStep = step;
    });
  }

  void _changeStep(int step) {
    _listOfStepWidget = [
      SignUpInit(),
      SignUpFinish(disable: _disableBackButton),
      SignUpCompleted(controller: _shakeController),
    ];

    // Changing size of previous step
    switch (this._currentStep) {
      case 1:
        setState(() {
          _step1Controller.reverse();
          _step1Controller.dispose();
          _step1Controller = AnimationController(
            vsync: this,
            duration: Duration(microseconds: 700),
          );
        });
        break;

      case 2:
        setState(() {
          _step2Controller.reverse();
          _step2Controller.dispose();
          _step2Controller = AnimationController(
            vsync: this,
            duration: Duration(microseconds: 700),
          );
        });
        break;

      case 3:
        setState(() {
          _step3Controller.reverse();
          _step3Controller.dispose();
          _step3Controller = AnimationController(
            vsync: this,
            duration: Duration(microseconds: 700),
          );
        });
        break;

      case 4:
        _pausedStep = 4;
        _progressValue = 1;
        _shakeController.forward();
        _listOfStepWidget[3] = SignUpCompleted(
          controller: _shakeController,
          visible: true,
        );
        break;
    }

    switch (step) {
      case 1:
        _pausedStep = 1;
        _progressValue = 0;
        _step1Controller.forward();
        _listOfStepWidget[0] = SignUpInit(visible: true);
        break;
      case 2:
        _pausedStep = 2;
        _progressValue = 0.5;
        _step2Controller.forward();
        _listOfStepWidget[1] = SignUpFinish(
          visible: true,
          nonce: _passwordNonce,
          isNewStream: _passwordIsNewController.stream,
          disable: _disableBackButton,
        );

        // Making is new
        _passwordIsNewController.add(true);
        break;

      case 3:
        _pausedStep = 3;
        _progressValue = 1;
        _shakeController.forward();
        _listOfStepWidget[2] = SignUpCompleted(
          controller: _shakeController,
          visible: true,
        );
        break;
    }

    setState(() {
      this._currentStep = step;
    });
  }

  Future<bool> _onWillPop() async {
    return _willPopValue;
  }

  void _disableBackButton() {
    print("Will pop value changed");
    _willPopValue = false;
  }

  @override
  void initState() {
    super.initState();

    _initAnimationControllers();
    _initStreams();

    _listOfStepWidget = [
      SignUpInit(visible: true),
      SignUpFinish(disable: _disableBackButton),
      SignUpCompleted(controller: _shakeController)
    ];
  }

  @override
  void dispose() {
    _slideController.dispose();
    _step1Controller.dispose();
    _step2Controller.dispose();
    _step3Controller.dispose();
    _shakeController.dispose();

    _passwordIsNewController.close();

    super.dispose();
  }

  void _handleBlocResponse(UserState state) {
    if (state is UserCreatePage1) {
    } else if (state is UserCreatePage1) {
      _changeStep(1);
    } else if (state is UserCreatePage2) {
      _changeStep(2);
    } else if (state is UserCreatePage3) {
      _changeStep(3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sign Up",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 10,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                _handleBlocResponse(state);
              },
              builder: (context, state) {
                return SlideTransition(
                  position: _slideTween.animate(_slideController),
                  child: FadeTransition(
                    opacity: _slideController,
                    child: Container(
                      margin: EdgeInsets.only(top: 25),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 25, 15, 15),
                              child: Column(children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 200,
                                          child: Text(
                                            "Create Your Dela Account",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25),
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            LinearProgressIndicator(
                                              value: _progressValue,
                                              minHeight: 2,
                                              backgroundColor: Color.fromRGBO(
                                                  216, 219, 224, 1),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ButtonTheme(
                                                  minWidth: 0,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 0),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  child: FlatButton(
                                                    child: StepIcon(
                                                      iconData: _currentStep > 1
                                                          ? CustomIcons.checked
                                                          : CustomIcons
                                                              .number_1,
                                                      sizeController:
                                                          _step1Controller,
                                                      iconColor: _currentStep ==
                                                              1
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .secondary
                                                          : Theme.of(context)
                                                              .accentColor,
                                                    ),
                                                    onPressed: _pausedStep >=
                                                                1 &&
                                                            _pausedStep < 3
                                                        ? () => _switchStep(1)
                                                        : null,
                                                  ),
                                                ),
                                                ButtonTheme(
                                                  minWidth: 0,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 0),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  child: FlatButton(
                                                    child: StepIcon(
                                                      iconData: _currentStep > 2
                                                          ? CustomIcons.checked
                                                          : CustomIcons
                                                              .number_2,
                                                      sizeController:
                                                          _step2Controller,
                                                      iconColor: _currentStep ==
                                                              2
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .secondary
                                                          : _pausedStep == 2
                                                              ? Color.fromRGBO(
                                                                  4,
                                                                  148,
                                                                  255,
                                                                  0.4)
                                                              : _currentStep > 2
                                                                  ? Theme.of(
                                                                          context)
                                                                      .accentColor
                                                                  : Color
                                                                      .fromRGBO(
                                                                          216,
                                                                          219,
                                                                          224,
                                                                          1),
                                                    ),
                                                    onPressed: _pausedStep >=
                                                                2 &&
                                                            _pausedStep < 3
                                                        ? () => _switchStep(2)
                                                        : null,
                                                  ),
                                                ),
                                                ButtonTheme(
                                                  minWidth: 0,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 0),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  child: FlatButton(
                                                    child: StepIcon(
                                                      iconData: _currentStep > 3
                                                          ? CustomIcons.checked
                                                          : CustomIcons
                                                              .number_3,
                                                      sizeController:
                                                          _step3Controller,
                                                      iconColor: _currentStep ==
                                                              3
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .secondary
                                                          : _pausedStep == 3
                                                              ? Color.fromRGBO(
                                                                  4,
                                                                  148,
                                                                  255,
                                                                  0.4)
                                                              : _currentStep > 3
                                                                  ? Theme.of(
                                                                          context)
                                                                      .accentColor
                                                                  : Color
                                                                      .fromRGBO(
                                                                          216,
                                                                          219,
                                                                          224,
                                                                          1),
                                                    ),
                                                    onPressed: _pausedStep >=
                                                                3 &&
                                                            _pausedStep < 4
                                                        ? () => _switchStep(3)
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: _listOfStepWidget,
                                )
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
