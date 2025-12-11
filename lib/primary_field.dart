 
 
import 'package:flutter/material.dart';

class PrimaryInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController txtController;
  final String? Function(String?)? validator;
  final int? maxline;
  final bool? isObscure;

  const PrimaryInputField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.txtController,
    this.validator,
    this.maxline,
    this.isObscure
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:   EdgeInsets.all(10),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        controller: txtController,
        maxLines: maxline??1,
        obscureText: isObscure??false,
        decoration: InputDecoration(
        
      
          labelText: label,
          
          labelStyle: TextStyle(
            fontSize: 12
          ), 
          hintText: hintText,
          // maintainHintHeight: true,
          hintStyle: TextStyle(
            fontSize: 12
          ),
          
          
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.red.withOpacity(0.5))),
        ),
        validator: validator, // validation hook
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget? child;
  final double? txtWidth;
  final double? txtRadius;
  final String? labelName;
  final bool? labelYn;
  final Color? labelColor;

  const TextFieldContainer({
    super.key,
    this.child,
    this.txtWidth,
    this.txtRadius,
    this.labelName,
    this.labelYn,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        labelYn == true
            ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  labelName ?? "",
                  style: TextStyle(
                      fontSize: 12, color: labelColor ?? Colors.black),
                ),
              )
            : Container(
                // height: Global().isWindows(context) ? 0 : 17,
                height: 0,
              ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration:
              boxOutlineDecoration(Colors.transparent, txtRadius!, labelColor),
          child: child,
        ),
      ],
    );
  }
}

BoxDecoration boxOutlineDecoration(color, double radius, [labelColor]) =>
    BoxDecoration(
      color: color,
      border: Border.all(
        color: Colors.grey,
        width: 2,
      ),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
