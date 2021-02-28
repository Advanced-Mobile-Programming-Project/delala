import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final FocusNode focusNode;
  final Function validator;
  final TextEditingController controller;
  final Function onChanged;
  final Function onFieldSubmitted;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool autoValidate;
  final Widget prefix;
  final bool isDense;
  final String labelText;
  final String errorText;

  PasswordFormField({
    this.focusNode,
    this.validator,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.keyboardType,
    this.autoValidate,
    this.prefix,
    this.isDense,
    this.labelText,
    this.errorText,
  });

  _PasswordFormField createState() => _PasswordFormField();
}

class _PasswordFormField extends State<PasswordFormField> {
  bool visible;

  @override
  void initState() {
    super.initState();
    visible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          prefixIcon: widget.prefix,
          border: const OutlineInputBorder(),
          isDense: widget.isDense ?? false,
          labelText: widget.labelText ?? "Password",
          errorText: widget.errorText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                visible = !visible;
              });
            },
            child: Icon(
              visible ? Icons.visibility_off : Icons.visibility,
              size: widget.isDense ?? false ? 24 : null,
            ),
          )),
      obscureText: !visible,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType ?? TextInputType.visiblePassword,
      autovalidate: widget.autoValidate ?? false,
    );
  }
}
