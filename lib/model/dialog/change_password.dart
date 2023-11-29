import 'package:flutter/material.dart';

import '../../services/db/profile_db.dart';
import '../../services/db/user_db.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController first_old_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController second_new_password = TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  bool isValid1 = true;
  bool isValid2 = true;
  bool isValid3 = true;

  String error = "";

  static void _showSnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2), // Set the duration for which the Snackbar is displayed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  Widget PasswordField(int number, TextEditingController controller, String text) {
    bool isValid;
    bool _obscureText;
    if (number == 1) {
      isValid = isValid1;
      _obscureText = _obscureText1;
    } else if (number == 2) {
      isValid = isValid2;
      _obscureText = _obscureText2;
    } else {
      isValid = isValid3;
      _obscureText = _obscureText3;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        height: 65,
        child: Padding(
          padding: EdgeInsets.only(bottom: isValid ? 15.0 : 0),
          child: TextField(
            controller: controller,
            obscureText: _obscureText,
            onChanged: (String value){
              setState(() {
                if (number == 1) isValid1 = controller.text.length > 0;
                else if (number == 2) isValid2 = controller.text.length > 0;
                else isValid3 = controller.text.length > 0;
              });
            },
            decoration: InputDecoration(
              hintText: text,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                // borderSide: BorderSide(color: Colors.blue, width: 0.0),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    if (number == 1) _obscureText1 = !_obscureText1;
                    else if (number == 2) _obscureText2 = !_obscureText2;
                    else _obscureText3 = !_obscureText3;
                  });
                },
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              ),
              errorText: isValid ? null : 'неправильный ввод',
              errorStyle: TextStyle(height: 0.5),
            ),
          ),
        ),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Container(
        height: 250,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15
                ),
              ),
            ),
            PasswordField(1, first_old_password, 'Введите старый пароль'),
            PasswordField(2, new_password, 'Введите новый пароль'),
            PasswordField(3, second_new_password, 'Введите пароль еще раз'),

            // SizedBox(
            //   height: _isValid ? 50 : 70,
            //   child: TextField(
            //     controller: second_new_password,
            //     obscureText: true,
            //     onChanged: (String value){
            //       setState(() {
            //         _isValid = second_new_password.text.length > 0;
            //       });
            //     },
            //     decoration: InputDecoration(
            //       hintText: 'Введите пароль еще раз',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //         // borderSide: BorderSide(color: Colors.blue, width: 0.0),
            //       ),
            //       errorText: _isValid ? null : 'Invalid email format',
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () async {
              int status;
              if (first_old_password.text.isEmpty || new_password.text.isEmpty || second_new_password.text.isEmpty) {
                setState(() {
                  error = "Введите все поля";
                });
              }
              else if (second_new_password.text != new_password.text) {
                setState(() {
                  error = "Проверьте новый пароль";
                });
              }
              else {
                status = await ProfileDB.updatePassword(login: UserDB.uid, password: second_new_password.text);
                if (status == 200) {
                  _showSnackbar(context, "Пароль изменен");
                  Navigator.of(context).pop();
                  print("baaaaaaaaaad");
                  first_old_password.clear();
                  new_password.clear();
                  second_new_password.clear();
                }
              }

            },
            style: TextButton.styleFrom(
              primary: Colors.white, // Set the text color here
              backgroundColor: Colors.deepOrange, // Set the background color here
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text('Изменить пароль', style: TextStyle(fontSize: 20),),
            ),
          ),
        )
      ],
    );
  }
}
