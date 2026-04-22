import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/user_provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _username = '';
  String _selectedArc = 'Fitness';
  
  late AnimationController _dotsController;
  late Animation<int> _dotsAnimation;

  final List<ArcInfo> _arcs = [
    ArcInfo(
      name: 'Fitness',
      emoji: ' ',
      color: AppColors.statStr,
      description: 'Physical strength and endurance',
    ),
    ArcInfo(
      name: 'Scholar',
      emoji: ' ',
      color: AppColors.statInt,
      description: 'Knowledge and intellectual growth',
    ),
    ArcInfo(
      name: 'Entrepreneur',
      emoji: ' ',
      color: AppColors.purple,
      description: 'Business and innovation',
    ),
    ArcInfo(
      name: 'Mindset',
      emoji: ' ',
      color: AppColors.cyan,
      description: 'Mental wellness and clarity',
    ),
    ArcInfo(
      name: 'Creative',
      emoji: ' ',
      color: AppColors.rankB,
      description: 'Artistic expression and creation',
    ),
    ArcInfo(
      name: 'Social',
      emoji: ' ',
      color: AppColors.statCha,
      description: 'Connections and relationships',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _dotsAnimation = Tween<int>(
      begin: 0,
      end: 3,
    ).animate(CurvedAnimation(
      parent: _dotsController,
      curve: Curves.stepCurve,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    final userProvider = context.read<UserProvider>();
    userProvider.updateUsername(_username.isEmpty ? 'Player' : _username);
    userProvider.updateArcFocus(_selectedArc);
    
    // Navigate to main app
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                ],
              ),
            ),
            
            // Dot indicators
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index 
                          ? AppColors.cyan 
                          : AppColors.textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large lightning icon
          const Text(
            ' ',
            style: TextStyle(fontSize: 120),
          ),
          
          const SizedBox(height: 40),
          
          // Terminal text with animated dots
          AnimatedBuilder(
            animation: _dotsAnimation,
            builder: (context, child) {
              final dots = '.' * (_dotsAnimation.value % 4);
              return Text(
                'SYSTEM INITIALIZING$dots',
                style: AppTextStyles.terminal.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              );
            },
          ),
          
          const SizedBox(height: 60),
          
          // Welcome heading
          Text(
            'Welcome, Player',
            style: AppTextStyles.h1.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            'Your journey begins now',
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 60),
          
          // Next button
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              foregroundColor: AppColors.bg,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              minimumSize: const Size(200, 50),
            ),
            child: Text(
              'NEXT',
              style: AppTextStyles.buttonPrimary.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large icon
          Icon(
            Icons.person,
            size: 100,
            color: AppColors.cyan.withOpacity(0.8),
          ),
          
          const SizedBox(height: 40),
          
          // Prompt
          Text(
            'What do they call you?',
            style: AppTextStyles.h2.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'This is how other players will know you',
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          // Username input field
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.textSecondary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your username',
                hintStyle: AppTextStyles.bodySecondary.copyWith(
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Next button
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              foregroundColor: AppColors.bg,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              minimumSize: const Size(200, 50),
            ),
            child: Text(
              'NEXT',
              style: AppTextStyles.buttonPrimary.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large icon
          Icon(
            Icons.auto_awesome,
            size: 100,
            color: AppColors.purple.withOpacity(0.8),
          ),
          
          const SizedBox(height: 40),
          
          // Prompt
          Text(
            'Choose Your Primary Arc',
            style: AppTextStyles.h2.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'This will be your main focus area',
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 30),
          
          // Arc selection grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _arcs.length,
              itemBuilder: (context, index) {
                final arc = _arcs[index];
                final isSelected = _selectedArc == arc.name;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedArc = arc.name;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? arc.color.withOpacity(0.2) 
                          : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? arc.color 
                            : AppColors.textSecondary.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: arc.color.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            arc.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            arc.name,
                            style: AppTextStyles.label.copyWith(
                              color: isSelected ? arc.color : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            arc.description,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.textSecondary.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Begin button
          ElevatedButton(
            onPressed: _completeOnboarding,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              foregroundColor: AppColors.bg,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              minimumSize: const Size(200, 50),
            ),
            child: Text(
              'BEGIN',
              style: AppTextStyles.buttonPrimary.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArcInfo {
  final String name;
  final String emoji;
  final Color color;
  final String description;

  const ArcInfo({
    required this.name,
    required this.emoji,
    required this.color,
    required this.description,
  });
}
