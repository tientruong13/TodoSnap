import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/Functions/option/vibration.dart';
import 'package:task_app/Page/Setting/theme/presentation/providers/theme_provider.dart';
import 'package:task_app/Page/Setting/theme/presentation/settings/widgets/primary_color_option.dart';

import 'package:task_app/Page/Setting/theme/presentation/styles/app_colors.dart';

class PrimaryColorSwitcher extends StatelessWidget {
  const PrimaryColorSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<ThemeProvider>(
        builder: (c, themeProvider, _) {
          return Wrap(
            children: List.generate(
              AppColors.primaryColorOptions.length,
              (i) => PrimaryColorOption(
                  color: AppColors.primaryColorOptions[i],
                  isSelected: themeProvider.selectedPrimaryColor ==
                      AppColors.primaryColorOptions[i],
                  onTap: () {
                    vibrateForAhalfSeconds();
                    themeProvider.setSelectedPrimaryColor(
                      AppColors.primaryColorOptions[i],
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
