import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peplocker/utils/app_colors.dart';

class Password extends StatelessWidget {
  final double width;
  final String label;
  final bool isInvalid;
  final String errorMessage;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Function() onEditingComplete;
  final Function(String _) onSubmitted;

  const Password(
      {Key key,
      this.width,
      this.label,
      this.isInvalid,
      this.errorMessage,
      this.controller,
      this.focusNode,
      this.hintText,
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
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(AppColors.black), fontSize: 20.0),
        keyboardType: TextInputType.text,
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(AppColors.black)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(AppColors.black)),
          ),
          hintText: hintText,
          hintStyle:
              TextStyle(color: Color(AppColors.greyBlack), fontSize: 16.0),
          floatingLabelBehavior: FloatingLabelBehavior.never,
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
