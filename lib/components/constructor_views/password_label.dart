// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../buttons/classic_button.dart';
//
// class PasswordLabel extends StatefulWidget {
//   PasswordLabel({super.key});
//
//   @override
//   State<PasswordLabel> createState() => _PasswordLabelState();
//
// }
//
// class _PasswordLabelState  extends State<PasswordLabel>{
//   static void _showSnackbar(BuildContext context, String text) {
//     final snackBar = SnackBar(
//       content: Text(text),
//       duration: Duration(seconds: 2), // Set the duration for which the Snackbar is displayed
//     );
//
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   TextEditingController first_old_password = TextEditingController();
//   TextEditingController second_old_password = TextEditingController();
//   TextEditingController new_password = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
//
//
//   static void ChangePassword(BuildContext context){
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           content: Container(
//             height: 170,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 50,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         // borderSide: BorderSide(color: Colors.blue, width: 0.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: SizedBox(
//                     height: 50,
//                     child: TextField(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           // borderSide: BorderSide(color: Colors.blue, width: 0.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50,
//                   child: TextField(
//                     controller: new_password.text,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         // borderSide: BorderSide(color: Colors.blue, width: 0.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             Center(
//               child: TextButton(
//                 onPressed: () {
//                   _showSnackbar(context, "Пароль изменен");
//                 },
//                 style: TextButton.styleFrom(
//                   primary: Colors.white, // Set the text color here
//                   backgroundColor: Colors.deepOrange, // Set the background color here
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                   child: Text('Изменить пароль', style: TextStyle(fontSize: 20),),
//                 ),
//               ),
//             )
//           ],
//         )
//     );
//   }
// }
