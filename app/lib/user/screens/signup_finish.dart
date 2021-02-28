import 'package:delala/user/screens/signup.dart';
import 'package:http/http.dart' as http;

class SignUpFinish extends StatefulWidget {
  final String nonce;
  final bool visible;
  final Function changeStep;
  final Stream<bool> isNewStream;

  SignUpFinish({this.nonce, this.visible, this.changeStep, this.isNewStream});

  _SignUpFinish createState() => _SignUpFinish();
}

class _SignUpFinish extends State<SignUpFinish> {
  FocusNode _newPasswordFocusNode;
  FocusNode _verifyPasswordFocusNode;

  TextEditingController _newPasswordController;
  TextEditingController _verifyPasswordController;

  String nonce;
  String _newPasswordErrorText;
  String _verifyPasswordErrorText;
  String _errorText = "";
  bool _errorFlag = false;
  bool _loading = false;

  GlobalKey<FormState> _formKey;

  // autoValidateNewPassword checks for invalid characters only
  String _autoValidateNewPassword(String value) {
    if (value.isEmpty) {
      return null;
    }
    var exp = RegExp(r"^[a-zA-Z0-9\._\-&!?=#]*$");

    if (!exp.hasMatch(value)) {
      return ReCase("invalid characters used in password").sentenceCase;
    }

    return null;
  }

  String _validateNewPassword(String value) {
    if (value.length < 8) {
      return ReCase("password should contain at least 8 characters")
          .sentenceCase;
    }

    var exp = RegExp(r"^[a-zA-Z0-9\._\-&!?=#]{8}[a-zA-Z0-9\._\-&!?=#]*$");

    if (!exp.hasMatch(value)) {
      return ReCase("invalid characters used in password").sentenceCase;
    }

    return null;
  }

  String _validateVerifyPassword() {
    var newPassword = _newPasswordController.text;
    var verifyPassword = _verifyPasswordController.text;

    if (newPassword != verifyPassword) {
      return ReCase("password doesn't match").sentenceCase;
    }

    return null;
  }

  Future<void> _onSuccess(http.Response response) async {
    // var jsonData = json.decode(response.body);
    // var accessToken = AccessToken.fromJson(jsonData);
    //
    // OnePay.of(context).appStateController.add(accessToken);
    //
    // // Saving data to shared preferences
    // await setLocalAccessToken(accessToken);
    // await setLoggedIn(true);
    //
    // setState(() {
    //   _errorFlag = false;
    // });
    //
    // // This is only used for checking the step 3 icon
    // widget.changeStep(4);
    //
    // // Disabling the back button so the user will wait
    // widget.disable();
    //
    // // This delay is used to make the use comfortable with registration process
    // Future.delayed(Duration(seconds: 4)).then((value) => Navigator.of(context)
    //     .pushNamedAndRemoveUntil(
    //         AppRoutes.authorizedRoute, (Route<dynamic> route) => false));
  }

  Future<void> _onError(http.Response response) async {
    String error = "";
    switch (response.statusCode) {
      case HttpStatus.badRequest:
        var jsonData = json.decode(response.body);
        error = jsonData["error"];

        switch (error) {
          case "password should contain at least 8 characters":
            setState(() {
              _newPasswordErrorText = ReCase(error).sentenceCase;
            });
            break;
          case "invalid characters used in password":
            setState(() {
              _newPasswordErrorText = ReCase(error).sentenceCase;
            });
            break;
          case "password does not match":
            setState(() {
              _verifyPasswordErrorText = ReCase(error).sentenceCase;
            });
            break;
          case "invalid token used":
            setState(() {
              _errorText = ReCase("the token used is invalid or has expired")
                  .sentenceCase;
              _errorFlag = true;
            });
            break;
          default:
            setState(() {
              _errorText = ReCase(error).sentenceCase;
              _errorFlag = true;
            });
        }
        return;
      case HttpStatus.internalServerError:
        error = FailedOperationError;
        break;
      default:
        error = SomethingWentWrongError;
    }

    showServerError(context, error);
  }

  Future<void> _handleResponse(http.Response response) async {
    // if (response.statusCode == HttpStatus.ok) {
    //   await _onSuccess(response);
    // } else {
    //   await _onError(response);
    // }
  }

  Future<void> _makeRequest(String newPassword, String verifyPassword) async {
    // var requester = HttpRequester(path: "/oauth/user/register/finish.json");
    // try {
    //   var response =
    //       await http.post(requester.requestURL, headers: <String, String>{
    //     'Content-Type': 'application/x-www-form-urlencoded',
    //   }, body: <String, String>{
    //     'password': newPassword,
    //     'vPassword': verifyPassword,
    //     'nonce': nonce,
    //   });
    //
    //   // Stop loading after response received
    //   setState(() {
    //     _loading = false;
    //   });
    //
    //   await _handleResponse(response);
    // } on SocketException {
    //   setState(() {
    //     _loading = false;
    //   });
    //
    //   showUnableToConnectError(context);
    // } catch (e) {
    //   setState(() {
    //     _loading = false;
    //   });
    //
    //   showServerError(context, SomethingWentWrongError);
    // }
  }

  void _signUpFinish() async {
    // Cancelling if loading
    if (_loading) {
      return;
    }

    // nonce = widget.nonce ?? this.nonce;
    // var newPassword = _newPasswordController.text;
    // var verifyPassword = _verifyPasswordController.text;
    //
    // var newPasswordError = _validateNewPassword(newPassword);
    // var verifyPasswordError = _validateVerifyPassword();
    //
    // if (newPasswordError != null) {
    //   setState(() {
    //     _newPasswordErrorText = newPasswordError;
    //   });
    // }
    //
    // if (verifyPasswordError != null) {
    //   setState(() {
    //     _verifyPasswordErrorText = verifyPasswordError;
    //   });
    // }
    //
    // if (newPasswordError != null || verifyPasswordError != null) {
    //   return;
    // }
    //
    // // Removing the final error at the start
    // setState(() {
    //   _loading = true;
    //   _newPasswordErrorText = null;
    //   _verifyPasswordErrorText = null;
    //   _errorFlag = false;
    // });

    // await _makeRequest(newPassword, verifyPassword);

    // This is only used for checking the step 3 icon
    widget.changeStep(3);

    // Disabling the back button so the user will wait
    widget.disable();
  }

  void initState() {
    super.initState();

    _newPasswordFocusNode = FocusNode();
    _verifyPasswordFocusNode = FocusNode();

    _newPasswordController = TextEditingController();
    _verifyPasswordController = TextEditingController();

    _formKey = GlobalKey<FormState>();

    _newPasswordFocusNode.addListener(() {
      if (!_newPasswordFocusNode.hasFocus) {
        var newPassword = _newPasswordController.text;
        if (newPassword != null && newPassword.isNotEmpty) {
          setState(() {
            _newPasswordErrorText = _validateNewPassword(newPassword);
          });
        }
      }
    });

    _verifyPasswordFocusNode.addListener(() {
      if (!_verifyPasswordFocusNode.hasFocus) {
        var verifyPassword = _verifyPasswordController.text;
        if (verifyPassword != null && verifyPassword.isNotEmpty) {
          setState(() {
            _verifyPasswordErrorText = _validateVerifyPassword();
          });
        }
      }
    });

    widget.isNewStream?.listen((event) {
      if (event) {
        setState(() {
          _newPasswordController.clear();
          _verifyPasswordController.clear();

          _newPasswordErrorText = null;
          _verifyPasswordErrorText = null;

          _errorText = "";
          _errorFlag = false;
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible ?? false,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  "Secure your account with robust password, password should be contain at least 8 characters.",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child: PasswordFormField(
                focusNode: _newPasswordFocusNode,
                controller: _newPasswordController,
                errorText: _newPasswordErrorText,
                autoValidate: true,
                validator: _autoValidateNewPassword,
                onChanged: (_) => this.setState(() {
                  _newPasswordErrorText = null;
                }),
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child: TextFormField(
                focusNode: _verifyPasswordFocusNode,
                controller: _verifyPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Verify Password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorText: _verifyPasswordErrorText,
                ),
                onChanged: (_) => this.setState(() {
                  _verifyPasswordErrorText = null;
                }),
                onFieldSubmitted: (_) => _signUpFinish(),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Visibility(
                      child: ErrorText(_errorText),
                      visible: _errorFlag,
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: LoadingButton(
                      loading: _loading,
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: _signUpFinish,
                      padding: EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
