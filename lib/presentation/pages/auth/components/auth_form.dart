// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_colors.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_decorations.dart';
import 'package:gisogs_greenspacesapp/config/constants/app_dictionary.dart';
import 'package:gisogs_greenspacesapp/config/constants/errors_const.dart';
import 'package:gisogs_greenspacesapp/config/router/app_auto_router.gr.dart';
import 'package:gisogs_greenspacesapp/config/theme/text_styles.dart';
import 'package:gisogs_greenspacesapp/presentation/state/actions/auth_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/app_state.dart';
import 'package:gisogs_greenspacesapp/presentation/state/thunk_actions/user_thunk_actions.dart';
import 'package:gisogs_greenspacesapp/presentation/state/view_models/user/auth_view_model.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/buttons/rounded_button.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/custom_checkbox.dart';
import 'package:gisogs_greenspacesapp/presentation/uikit/inputs/input_block.dart';

// Project imports:

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController loginController;
  late TextEditingController passwordController;
  late bool loginHasError;
  late bool passwordHasError;
  bool obscureText = true;
  bool processForm = false;
  bool rememberMe = true;
  String loginErrorText = '';
  String passwordErrorText = '';

  @override
  void initState() {
    super.initState();
    loginController = TextEditingController();
    passwordController = TextEditingController();
    loginHasError = false;
    passwordHasError = false;
  }

  bool _customValidation() {
    bool isLoginValid = false;
    bool isPasswordValid = false;

    // first check email field
    isLoginValid = loginController.text != '';
    isPasswordValid = passwordController.text != '';

    if (isLoginValid && isPasswordValid) {
      return true;
    } else {
      // make different conditions not to call set state multiple times
      if (isLoginValid == false && isPasswordValid) {
        setState(() {
          loginHasError = true;
          passwordHasError = false;
          loginErrorText = AppDictionary.fillInput;
          passwordErrorText = '';
        });
      } else if (isLoginValid && isPasswordValid == false) {
        setState(() {
          loginHasError = false;
          passwordHasError = true;
          loginErrorText = '';
          passwordErrorText = AppDictionary.fillInput;
        });
      } else {
        setState(() {
          loginHasError = true;
          passwordHasError = true;
          loginErrorText = AppDictionary.fillInput;
          passwordErrorText = AppDictionary.fillInput;
        });
      }

      return false;
    }
  }

  void resetEmailError() {
    setState(() {
      loginHasError = false;
      loginErrorText = '';
    });
  }

  void resetPasswordError() {
    setState(() {
      passwordHasError = false;
      passwordErrorText = '';
    });
  }

  void sendFormHandler() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      // implicitly clear all active errors
      loginHasError = false;
      loginErrorText = '';
      passwordHasError = false;
      passwordErrorText = '';
      processForm = true;
    });
    if (_customValidation()) {
      StoreProvider.of<AppState>(context).dispatch(UpdateAuthCredentials(login: loginController.text, password: passwordController.text));
      StoreProvider.of<AppState>(context).dispatch(doLogin);
    } else {
      setState(() => processForm = false);
    }
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthViewModel>(
        distinct: true,
        onDidChange: (oldState, newState) {
          if (newState.authSuccess == true) {
            context.router.pushAndPopUntil(
              const HomeRoute(),
              predicate: (Route<dynamic> route) {
                return false;
              },
            );
          }

          if (newState.authSuccess == false && newState.errorMessage != null) {
            setState(() => processForm = false);
            switch (newState.errorCode) {
              case AuthErrorCode.other:
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(newState.errorMessage!),
                ));
                break;
              case AuthErrorCode.notFound:
              case AuthErrorCode.wrongLogin:
                setState(() {
                  loginHasError = true;
                  loginErrorText = newState.errorMessage!;
                });
                break;
              case AuthErrorCode.wrongCredentials:
                setState(() {
                  passwordHasError = true;
                  passwordErrorText = newState.errorMessage!;
                });
                break;
              default:
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(GeneralErrors.generalError),
                ));
                break;
            }
          }
        },
        converter: (store) => store.state.authScreenState,
        builder: (_, state) {
          if (state.isProcessing) {
            processForm = true;
          }
          return GestureDetector(
            onTap: () => debugPrint('tapped'),
            child: Form(
              key: _formKey,
              child: Stack(clipBehavior: Clip.none, children: [
                Container(
                  height: MediaQuery.of(context).size.height - 90.0,
                  width: MediaQuery.of(context).size.width - 56,
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                ),
                AnimatedPositioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 300 : 0,
                  left: 28,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    height: 280.0,
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                    width: MediaQuery.of(context).size.width - 56,
                    decoration: AppDecorations.boxShadowDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 21.0),
                          child: Text(
                            AppDictionary.authHeader,
                            style: AppTextStyle.openSans24W700.apply(color: AppColors.primaryDark),
                          ),
                        ),
                        InputBlock(
                            isPassword: false,
                            label: AppDictionary.authLoginLabel,
                            controller: loginController,
                            errorMessage: loginErrorText,
                            isError: loginHasError,
                            resetError: resetEmailError,
                            darkBorder: true,
                            isProcessing: processForm),
                        InputBlock(
                            isPassword: true,
                            label: AppDictionary.authPasswordLabel,
                            controller: passwordController,
                            errorMessage: passwordErrorText,
                            isError: passwordHasError,
                            resetError: resetPasswordError,
                            darkBorder: true,
                            isProcessing: processForm),
                        // const SizedBox(height: 19.5),
                        CustomCheckBox(
                          callback: () => StoreProvider.of<AppState>(context).dispatch(toggleRememberMe(value: !state.rememberMe)),
                          label: AppDictionary.authRememberMe,
                          checked: state.rememberMe,
                        ),
                        // const SizedBox(
                        //   height: 12.0,
                        // ),
                        AppRoundedButton(
                          label: AppDictionary.authLoginBtn,
                          isProcessing: processForm,
                          color: AppColors.green,
                          labelStyle: AppTextStyle.openSans20W700.apply(color: AppColors.primaryLight),
                          handler: sendFormHandler,
                        )
                      ],
                    ),
                  ),
                )
              ]),
            ),
          );
        });
  }
}
