import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../states/onboarding_state.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingViewModel>().loadSlides();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) {
          final state = viewModel.state;

          if (state.status == OnboardingStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.terracota,
              ),
            );
          }

          if (state.status == OnboardingStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Error cargando onboarding'),
            );
          }

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => viewModel.updateIndex(index),
                itemCount: state.slides.length,
                itemBuilder: (context, index) {
                  final slide = state.slides[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          color: AppColors.arena,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.landscape,
                            size: 100,
                            color: AppColors.verdeSelva,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          slide.title,
                          style: AppTextStyles.headline1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          slide.description,
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        state.slides.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: state.currentIndex == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: state.currentIndex == index
                                ? AppColors.terracota
                                : AppColors.neutralLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (state.currentIndex < state.slides.length - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          state.currentIndex < state.slides.length - 1
                              ? 'Siguiente'
                              : 'Comenzar',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
