import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/widget/color_utils.dart';

class ColorPickerBuilder extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  ColorPickerBuilder({required this.color, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    //https://stackoverflow.com/questions/45424621/inkwell-not-showing-ripple-effect
    return ClipOval(
      child: Container(
        height: 9.w,
        width: 9.w,
        child: Material(
          color: color,
          child: InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 3.w, right: 3.w, top: 3.w, bottom: 3.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select a color'.tr(),
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2.w),
                          SingleChildScrollView(
                            child: BlockPicker(
                              availableColors: ColorUtils.defaultColors,
                              pickerColor: color,
                              onColorChanged: onColorChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
