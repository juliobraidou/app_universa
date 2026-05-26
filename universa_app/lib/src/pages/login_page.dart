import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/token_storage.dart';
import '../viewmodels/login_view_model.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _bgTop = Color(0xFF050510);
  static const _bgBottom = Color(0xFF1A1A40);
  static const _logoPurple = Color(0xFFD152FF);
  static const _secondText = Color(0xFF7474C5);
  static const _mutedText = Color(0xFF8E9AAF);
  static const _inputBg = Color(0xFF333333);
  static const _buttonPurple = Color(0xFF7B79D6);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _redirectIfAlreadyLoggedIn();
  }

  Future<void> _redirectIfAlreadyLoggedIn() async {
    final token = await context.read<TokenStorage>().readToken();
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/dash');
    }
  }

  Future<void> _handleLogin(
    BuildContext context,
    LoginViewModel viewModel,
  ) async {
    final student = await viewModel.login(
      _emailController.text,
      _passwordController.text,
    );
    if (!context.mounted) return;
    if (student == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Falha no login'),
        ),
      );
      return;
    }
    Navigator.pushNamedAndRemoveUntil(context, '/dash', (_) => false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    const borderRadius = BorderRadius.all(Radius.circular(6));
    final borderSide = BorderSide(color: _mutedText.withValues(alpha: 0.6));

    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.roboto(color: _mutedText, fontSize: 16),
      filled: true,
      fillColor: _inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: _secondText),
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 130),
                Text(
                  'Universa',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.caramel(
                    fontSize: 96,
                    color: _logoPurple,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Portal Academico',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(fontSize: 20, color: _secondText),
                ),
                const SizedBox(height: 80),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'RA ou Email Institucional',
                    style: GoogleFonts.roboto(fontSize: 20, color: _secondText),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                  decoration: _inputDecoration('ra@universidade.edu.br'),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Senha',
                    style: GoogleFonts.roboto(fontSize: 20, color: _secondText),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                  decoration: _inputDecoration('***********'),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: CustomButton(
                    title: viewModel.isLoading ? 'Entrando...' : 'Entrar',
                    color: _buttonPurple,
                    titleColor: Colors.white,
                    onPressed: viewModel.isLoading
                        ? () {}
                        : () => _handleLogin(context, viewModel),
                  ),
                ),
                const SizedBox(height: 28),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: _mutedText,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Esqueci minha senha',
                    style: GoogleFonts.roboto(fontSize: 14, color: _mutedText),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
