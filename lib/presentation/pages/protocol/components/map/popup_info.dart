import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/domain/entity/map/toris_layer_entity.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

class PopupInfoCard extends StatelessWidget {
  final bool toggled;
  final TorisLayerEntity? data;
  final String label;
  final Function callback;
  final Function closeHandler;
  final Function routingFunction;
  const PopupInfoCard({
    Key? key,
    required this.toggled,
    required this.data,
    required this.closeHandler,
    required this.label,
    required this.callback,
    required this.routingFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: toggled ? MediaQuery.of(context).size.height * .15 : MediaQuery.of(context).size.height,
      left: 0,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onVerticalDragEnd: (detail) {
          if (detail.primaryVelocity! > 1000) {
            closeHandler();
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 24.0,
          decoration: AppDecorations.boxShadowDecoration,
          margin: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
          padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 15.31),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AppIcons.filledPin,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?.name ?? '',
                          style: AppTextStyle.openSans14W500.apply(color: AppColors.primaryDark),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          data?.name == data?.address ? '' : data?.address ?? '',
                          style: AppTextStyle.openSans14W500.apply(color: AppColors.dark400),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              AppRoundedButton(
                color: AppColors.green,
                isProcessing: false,
                handler: callback,
                label: label.toUpperCase(),
                labelStyle: AppTextStyle.openSans14W700.apply(color: AppColors.white),
              ),
              const SizedBox(
                height: 5.0,
              ),
              AppRoundedButton(
                isProcessing: false,
                color: AppColors.green,
                label: BtnLabel.close.toUpperCase(),
                handler: closeHandler,
                labelStyle: AppTextStyle.openSans14W700.apply(color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
