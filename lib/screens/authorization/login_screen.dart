import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:voice_recipe/model/auth/auth.dart';
import 'package:voice_recipe/screens/authorization/forgot_password_screen.dart';
import 'package:voice_recipe/screens/authorization/register_screen.dart';

import '../../components/appbars/title_logo_panel.dart';
import '../../components/buttons/classic_button.dart';
import '../../components/custom_positioned.dart';
import '../../components/labels/input_label.dart';
import '../../components/labels/password_label.dart';
import '../../components/buttons/login/ref_button.dart';
import '../../components/buttons/login/sign_in_button.dart';
import '../../config.dart';

enum Method {
  email, google
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const route = '/login';

  static const fontSize = 18.0;

  static double buttonWidth(BuildContext context) =>
      Config.loginPageWidth(context) * 0.8;

  static double labelHeight(BuildContext context) =>
      Config.loginPageHeight(context) / 13;

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  static Widget voiceRecipeIcon(
      BuildContext context, double height, double iconSize) {
    return SizedBox(
      height: height,
      child: SizedBox(
        height: iconSize,
        width: iconSize,
        child: Image.asset("assets/images/voice_recipe.png"),
      ),
    );
  }

  static SizedBox inputWrapper(Widget child, BuildContext context) {
    return SizedBox(
      height: labelHeight(context),
      width: buttonWidth(context),
      child: child,
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool isShowLoading = false;
  bool isShowConfetti = false;
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;
  late SMITrigger confetti;

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  String get email => _emailController.text.trim();

  String get password => _passwordController.text.trim();

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Config.backgroundColor;
    Color textColor = Config.iconColor;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Config.iconColor,
        backgroundColor: Config.backgroundColor,
        title: const TitleLogoPanel(
          title: Config.appName,
        ),
      ),
      backgroundColor: Config.backgroundEdgeColor,
      body: GestureDetector(
        onTap: () {
          _emailFocusNode.unfocus();
          _passwordFocusNode.unfocus();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: Config.maxLoginPageWidth,
                  child: Column(
                    children: [
                      LoginScreen.voiceRecipeIcon(
                          context,
                          Config.loginPageHeight(context) / 3,
                          Config.loginPageHeight(context) / 6),
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Еще нет аккаунта?',
                                  style: TextStyle(
                                      color: textColor.withOpacity(0.8),
                                      fontSize: LoginScreen.fontSize,
                                      fontFamily: Config.fontFamily),
                                ),
                                const SizedBox(
                                  width: Config.padding,
                                ),
                                InkWell(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(RegisterScreen.route),
                                  child: Text(
                                    'Создать',
                                    style: TextStyle(
                                        color: textColor.withOpacity(0.8),
                                        fontSize: LoginScreen.fontSize,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Config.fontFamilyBold),
                                  ),
                                )
                              ],
                            ),
                            LoginScreen.inputWrapper(
                                InputLabel(
                                  focusNode: _emailFocusNode,
                                  labelText: 'Email',
                                  controller: _emailController,
                                  onSubmit: () => login(Method.email),
                                ),
                                context),
                            LoginScreen.inputWrapper(
                                PasswordLabel(
                                  focusNode: _passwordFocusNode,
                                  hintText: "Пароль",
                                  controller: _passwordController,
                                  onSubmit: () => login(Method.email),
                                ),
                                context),
                            RefButton(
                              text: "Забыли пароль?",
                              onTap: () => _onForgotPassword(context),
                            ),
                            SizedBox(
                                height: Config.loginPageHeight(context) / 12,
                                width: LoginScreen.buttonWidth(context),
                                child: ClassicButton(
                                  onTap: () => login(Method.email),
                                  text: "Войти",
                                  customBorderColor: Colors.black54,
                                )),
                            Container(
                              margin: const EdgeInsets.only(top: Config.margin),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  SignInButton(
                                      width: LoginScreen.buttonWidth(context),
                                      backgroundColor:
                                      Config.darkModeOn ? const Color(0xff202020) : Colors.white,
                                      textColor: Config.darkModeOn ? Colors.white : Colors.black,
                                      text: "Войти через Google",
                                      imageURL: "assets/images/icons/google.png",
                                      onPressed: () => login(Method.google),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isShowLoading
                ? CustomPositioned(
              child: RiveAnimation.asset(
                'assets/RiveAssets/check.riv',
                fit: BoxFit.cover,
                onInit: _onCheckRiveInit,
              ),
            )
                : const SizedBox(),
            isShowConfetti
                ? CustomPositioned(
              scale: 6,
              child: RiveAnimation.asset(
                "assets/RiveAssets/confetti.riv",
                onInit: _onConfettiRiveInit,
                fit: BoxFit.cover,
              ),
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  void login(Method method) async {
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    bool logged = false;
    if (method == Method.email) {
      logged = await AuthenticationManager()
          .signIn(context, email, password);
    } else {
      logged = await AuthenticationManager()
          .signInWithGoogle(context);
    }
    if (logged) {
      success.fire();
      Future.delayed(
        const Duration(seconds: 2),
            () {
          setState(() {
            isShowLoading = false;
          });
          confetti.fire();
          // Navigate & hide confetti
          Future.delayed(const Duration(seconds: 1), () {
            // Navigator.pop(context);
            Navigator.of(context).pop();
          });
        },
      );
    } else {
      error.fire();
      Future.delayed(
        const Duration(seconds: 2),
            () {
          setState(() {
            isShowLoading = false;
          });
          reset.fire();
        },
      );
    }
  }

  void _onForgotPassword(BuildContext context) {
    Navigator.of(context).pushNamed(ForgotPasswordScreen.route);
  }
}


