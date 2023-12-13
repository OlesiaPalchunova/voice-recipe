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

  String error1 = "";
  String error2 = "";
  String error3 = "";

  String _error = "";

  static void _showSnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2), // Set the duration for which the Snackbar is displayed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  Widget PasswordField(int number, TextEditingController controller, String text) {
    bool isValid;
    String error;
    bool _obscureText;
    if (number == 1) {
      isValid = isValid1;
      error = error1;
      _obscureText = _obscureText1;
    } else if (number == 2) {
      isValid = isValid2;
      error = error2;
      _obscureText = _obscureText2;
    } else {
      isValid = isValid3;
      error = error3;
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
              int count_digits = 0;
              for (int i = 0; i < controller.text.length; i++) {
                if (controller.text[i].codeUnits[0] >= "0".codeUnits[0] &&
                    controller.text[i].codeUnits[0] <=
                        "9".codeUnits[0]) count_digits++;
              }
              int len = controller.text.length;
              if (len >= 4 && len <= 32 && count_digits > 0 && count_digits < len) isValid = true;
              else isValid = false;



              if (len == 0) error = "поле не должно быть пустым";
              else if (len < 4) error = "пароль слишком короткий";
              else if (len > 32) error = "пароль слишком длинный";
              else if (count_digits == 0) error = "должна быть хотя бы одна цифра";
              else if (count_digits == len) error = "должна быть хотя бы одна не цифра";
              else error = "атварт";

              print("((((((isValid))))))");
              print(isValid);
              print(error);

              setState(() {

                if (number == 1) {
                  isValid1 = isValid;
                  error1 = error;
                } else if (number == 2) {
                  isValid2 = isValid;
                  error2 = error;
                } else {
                  isValid3 = isValid;
                  error3 = error;
                }
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
              errorText: isValid ? null : error,
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
                _error,
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
                  _error = "Введите все поля";
                });
              }
              else if (second_new_password.text != new_password.text) {
                setState(() {
                  _error = "Проверьте новый пароль";
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
