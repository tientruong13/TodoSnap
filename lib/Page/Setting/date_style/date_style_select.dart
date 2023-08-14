import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/Page/Setting/provider/setting_provider.dart';
import 'package:task_app/widget/animated_bottom_to_top_widget.dart';

class SelectDateStyle extends StatelessWidget {
  final List<String> dateFormatOptions = [
    'MMM d',
    'MMMM d',
    'MM/dd',
    'dd/MM',
    'MM-dd',
    'dd-MM',
    'd MMM',
    'd MMMM',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
      builder: (_, dateFormatProvider, __) {
        return ListView.builder(
          itemCount: dateFormatOptions.length,
          itemBuilder: (context, index) {
            bool isSelected = dateFormatProvider.selectedDateFormat != null &&
                dateFormatProvider.selectedDateFormat!.format ==
                    dateFormatOptions[index];

            return BottomToTopWidget(
              index: index,
              child: Container(
                color: isSelected ? Colors.white : Colors.transparent,
                child: ListTile(
                  title: Text(
                    DateFormat(dateFormatOptions[index],
                            Localizations.localeOf(context).toString())
                        .format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.blue : null,
                    ),
                  ),
                  trailing:
                      isSelected ? Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () {
                    dateFormatProvider.setDateFormat(dateFormatOptions[index]);
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
