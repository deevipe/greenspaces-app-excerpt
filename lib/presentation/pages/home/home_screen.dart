// Flutter imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/exceptions.dart';
import 'package:gisogs_greenspacesapp/domain/utils/shared_preferences.dart';
import 'package:gisogs_greenspacesapp/internal/dependencies/use_case_module.dart';
import 'package:gisogs_greenspacesapp/presentation/pages/home/components/app_bar_title.dart';
import 'package:gisogs_greenspacesapp/presentation/utils/helper_utils.dart';
import 'package:gisogs_greenspacesapp/resources/resources.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initDicitionaries();
  }

  Future<bool> _onWillPop() async {
    return Navigator.canPop(context);
  }

  Future<void> _initDicitionaries() async {
    final String userTokenId = SharedStorageService.getString(PreferenceKey.userTokenId);
    try {
      // Подгрузим словари из API в локальную базу
      await UseCaseModule.protocol().getDictionaries(userTokenId: userTokenId);

      /// Подгрузим списки организаций для представителей / спп и списики пользователей,
      /// которыe в дальнейшем сами будем фильтровать из локальной б/д
      await UseCaseModule.protocol().getOrgsAndUsers(userTokenId: userTokenId);

      await UseCaseModule.protocol().getDistricts(userTokenId: userTokenId);
      await UseCaseModule.protocol().getMunicipalities(userTokenId: userTokenId);
    } on AuthorizationException {
      await HelperUtils.needAuthAction(context: context);
    } catch (_) {
      debugPrint('Some error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.barsBg,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          centerTitle: true,
          title: const AppBarUser(),
          leading: AutoLeadingButton(
            showIfParentCanPop: false,
            builder: (_, type, callback) {
              return type == LeadingType.noLeading
                  ? const SizedBox.shrink()
                  : Container(
                      margin: const EdgeInsets.only(left: 12.0),
                      child: IconButton(
                        splashRadius: .1,
                        splashColor: AppColors.transparent,
                        onPressed: () {
                          if (context.router.currentPath == '/protocol/create') {
                            HelperUtils.showWarningDialog(context: context);
                          } else {
                            if (callback != null) {
                              callback();
                            }
                          }
                        },
                        icon: SvgPicture.asset(
                          AppIcons.arrowLeft,
                        ),
                      ),
                    );
            },
          ),
          leadingWidth: 46,
          actions: [
            IconButton(
              splashRadius: .1,
              splashColor: AppColors.transparent,
              onPressed: () => HelperUtils.showLogoutDialog(context: context),
              icon: SvgPicture.asset(
                AppIcons.logoutIcon,
                width: 24.54,
              ),
            ),
          ],
        ),
        extendBody: true,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              image: DecorationImage(
                image: AssetImage(AppImages.authBg),
                fit: BoxFit.cover,
              ),
            ),
            child: AutoRouter(
              navigatorKey: navigatorKey,
            ),
          ),
        ),
      ),
    );
  }
}
