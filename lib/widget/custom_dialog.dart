// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/widget/animated_opacity_widget.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    this.onPressed,
  }) : super(key: key);
  final void Function()? onPressed;
  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.only(top: 1.w),
      titlePadding: EdgeInsets.all(2.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: OpacytiWidget(
        number: 1,
        child: Text(
          'Delete Confirm'.tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      children: [
        OpacytiWidget(
          number: 1,
          child: Column(
            children: [
              Lottie.asset('assets/delete.json', height: 15.w, width: 15.w),
              Padding(
                padding: EdgeInsets.all(0.5.w),
                child: Text(
                  'Are you sure?'.tr(),
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0.5.w),
                child: Text('Do you really want to delete?'.tr(),
                    style: TextStyle(fontSize: 16.sp)),
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        vibrateForAhalfSeconds();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'No'.tr(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onPressed,
                      child: Text(
                        'Yes'.tr(),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
