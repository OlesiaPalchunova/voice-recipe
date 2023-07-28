import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String initialText;

  TextFormFieldWidget({required this.initialText});

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  TextEditingController _textEditingController = TextEditingController();

  TextEditingController getText(){
    return _textEditingController;
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 20.0),
      child: TextFormField(
        controller: _textEditingController,
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          hintText: 'Введите текст...',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}