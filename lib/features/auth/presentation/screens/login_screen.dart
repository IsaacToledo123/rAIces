import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final auth = context.read<AuthService>();
    final ok = auth.login(_userCtrl.text, _passCtrl.text);
    if (ok) {
      context.read<UserPreferencesService>().savePreferences(
        interests: auth.currentUser!.interests,
        budget: auth.currentUser!.defaultBudget,
      );
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 52, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo ────────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.accent, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'rAIces',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.accent,
                    letterSpacing: 4,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 52),

              Text(
                'Bienvenido\nde vuelta.',
                style: AppTextStyles.headline1.copyWith(
                  color: Colors.white,
                  fontSize: 38,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Turismo comunitario en el Istmo de Tehuantepec.',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white38,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 52),

              // ── Usuario ──────────────────────────────────────────────────
              Text(
                'Usuario',
                style: AppTextStyles.caption.copyWith(color: Colors.white54),
              ),
              const SizedBox(height: 8),
              _DarkField(
                controller: _userCtrl,
                hint: 'Jos_robles',
                prefix: Icons.person_outline,
                onChanged: (_) => context.read<AuthService>().clearError(),
              ),
              const SizedBox(height: 20),

              // ── Contraseña ────────────────────────────────────────────────
              Text(
                'Contraseña',
                style: AppTextStyles.caption.copyWith(color: Colors.white54),
              ),
              const SizedBox(height: 8),
              _DarkField(
                controller: _passCtrl,
                hint: '••••••••',
                prefix: Icons.lock_outline,
                obscure: _obscure,
                onChanged: (_) => context.read<AuthService>().clearError(),
                suffix: IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white38,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 14),

              // ── Error ────────────────────────────────────────────────────
              Consumer<AuthService>(
                builder: (context, auth, _) {
                  if (auth.error == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 14, color: AppColors.accent),
                        const SizedBox(width: 6),
                        Text(
                          auth.error!,
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.accent),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // ── Botón ────────────────────────────────────────────────────
              ElevatedButton(
                onPressed: _loading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.5),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Iniciar sesión',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              const SizedBox(height: 48),

              // ── Footer ───────────────────────────────────────────────────
              Center(
                child: Text(
                  'POC · Turismo comunitario · Istmo de Tehuantepec',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white24,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Dark text field helper ───────────────────────────────────────────────────

class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final bool obscure;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  const _DarkField({
    required this.controller,
    required this.hint,
    required this.prefix,
    this.obscure = false,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      cursorColor: AppColors.accent,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: Icon(prefix, color: Colors.white38, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}
