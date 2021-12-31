import 'package:flutter/cupertino.dart';
import 'package:peplocker/utils/app_colors.dart';

class RegisterBox extends StatelessWidget {
  final Widget child;
  final String title;
  final double height;
  const RegisterBox({Key key, this.child, this.title, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 10.0),
          ),
        ),
        SizedBox(height: 30),
        Container(
          height: height,
          padding: EdgeInsets.all(10.0),
          // margin: EdgeInsets.only(left: 40.0, right: 40.0, top: height / 20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: Color(AppColors.primaryColor),
          ),
          child: child,
        ),
      ],
    );
  }
}
