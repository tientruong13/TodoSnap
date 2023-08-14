// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final double? height, width;
  final String? initialValue;
  const CreateTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.width,
    this.height,
    this.initialValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: -1),
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
