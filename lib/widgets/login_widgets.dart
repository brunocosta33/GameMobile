import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hint,
    required this.obscure,
    required this.icon,
    required this.controller,
    this.validator,
  });

  final String hint;
  final bool obscure;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white24,
            width: 1,
          ),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          contentPadding: const EdgeInsets.only(
            top: 30,
            right: 30,
            bottom: 30,
            left: 5,
          ),
        ),
        validator: validator,
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu e-mail';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            InputField(
              hint: "E-mail",
              obscure: false,
              icon: Icons.email_outlined,
              controller: emailController,
              validator: _emailValidator,
            ),
            InputField(
              hint: "Senha",
              obscure: true,
              icon: Icons.lock_outline,
              controller: passwordController,
              validator: _passwordValidator,
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(top: 160),
      ),
      onPressed: onPressed,
      child: const Text(
        "Crie a sua conta!",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          color: Colors.white,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onPressed;
  StaggerAnimation({super.key, required this.controller, required this.onPressed})
      : buttonSqueeze = Tween(begin: 320.0, end: 60.0).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.150),
        )),
        buttonZoomOut = Tween(
          begin: 60.0,
          end: 1000.0,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: const Interval(0.5, 1, curve: Curves.bounceOut),
        ));
  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: InkWell(
        onTap: onPressed,
        child: Hero(
          tag: "fade",
          child: buttonZoomOut.value == 60
              ? Container(
                  width: buttonSqueeze.value,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(247, 64, 106, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: _buildInside(context),
                )
              : Container(
                  width: buttonZoomOut.value,
                  height: buttonZoomOut.value,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(247, 64, 106, 1.0),
                    shape: buttonZoomOut.value < 500
                        ? BoxShape.circle
                        : BoxShape.rectangle,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInside(BuildContext context) {
    if (buttonSqueeze.value > 75) {
      return const Text(
        "Sign in",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      );
    } else {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}
