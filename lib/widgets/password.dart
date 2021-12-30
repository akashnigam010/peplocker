import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peplocker/utils/app_colors.dart';

class Password extends StatelessWidget {
  final double width;
  final String label;
  final bool isInvalid;
  final String errorMessage;
  final TextEditingController controller;
  final Function() onEditingComplete;
  final Function(String _) onSubmitted;

  const Password(
      {Key key,
      this.width,
      this.label,
      this.isInvalid,
      this.errorMessage,
      this.controller,
      this.onEditingComplete,
      this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextField(
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        cursorColor: Color(AppColors.black),
        style: TextStyle(color: Color(AppColors.black), fontSize: 16.0),
        keyboardType: TextInputType.name,
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(AppColors.black)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(AppColors.black)),
          ),
          labelText: label,
          labelStyle: TextStyle(color: Color(AppColors.black)),
          errorText: isInvalid ? errorMessage : null,
          errorStyle: TextStyle(color: Color(AppColors.black)),
        ),
        maxLines: 1,
        controller: controller,
        textInputAction: TextInputAction.next,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
