import 'package:flutter/cupertino.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/constants.dart';

class LoginBox extends StatelessWidget {
  final Widget child;
  const LoginBox({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            Constants.appName.toUpperCase(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 15.0),
          ),
        ),
        Container(
          height: height / 3,
          padding: EdgeInsets.all(30.0),
          margin: EdgeInsets.only(left: 40.0, right: 40.0, top: height / 12),
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
