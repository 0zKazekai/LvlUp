import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
// THEME CONSTANTS
// ─────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF0A0E1A);
  static const cardBg = Color(0xFF0F172A);
  static const cardBg2 = Color(0xFF131929);
  static const cyan = Color(0xFF00E5FF);
  static const purple = Color(0xFF8B5CF6);
  static const green = Color(0xFF10B981);
  static const red = Color(0xFFEF4444);
  static const textSecondary = Color(0xFF94A3B8);
  static const border = Color(0xFF1E293B);
  static const rankC = Color(0xFF00E5FF);   // cyan
  static const rankD = Color(0xFF10B981);   // green
  static const rankE = Color(0xFF6B7280);   // grey-purple
  static const rankB = Color(0xFFF59E0B);   // amber
  static const rankA = Color(0xFFEF4444);   // red
  static const rankS = Color(0xFFEC4899);   // pink
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────
class Quest {
  final String rank;
  final String arc;
  final String title;
  final String description;
  final int xpReward;
  final String statEmoji;
  final String statLabel;
  final int statReward;
  final String timeEstimate;
  bool completed;

  Quest({
    required this.rank,
    required this.arc,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.statEmoji,
    required this.statLabel,
    required this.statReward,
    required this.timeEstimate,
    this.completed = false,
  });

  Color get rankColor {
    switch (rank) {
      case 'S': return AppColors.rankS;
      case 'A': return AppColors.rankA;
      case 'B': return AppColors.rankB;
      case 'C': return AppColors.rankC;
      case 'D': return AppColors.rankD;
      default:  return AppColors.rankE;
    }
  }
}

class CharacterStats {
  int str;
  int vit;
  int intel;
  int cha;
  final int maxStat;

  CharacterStats({
    this.str = 5,
    this.vit = 5,
    this.intel = 9,
    this.cha = 7,
    this.maxStat = 20,
  });
}

// ─────────────────────────────────────────────
// MAIN APP ENTRY
// ─────────────────────────────────────────────
void main() {
  runApp(const LvlUPApp());
}

class LvlUPApp extends StatelessWidget {
  const LvlUPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LvlUP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

// ─────────────────────────────────────────────
// MAIN SHELL (Bottom Nav)
// ─────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.grid_view_rounded, label: 'System'),
    _NavItem(icon: Icons.dynamic_feed_rounded, label: 'Feed'),
    _NavItem(icon: Icons.auto_awesome_rounded, label: 'My Arc'),
    _NavItem(icon: Icons.people_rounded, label: 'Network'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const SystemScreen(),
          _PlaceholderPage(title: 'Feed', icon: Icons.dynamic_feed_rounded),
          _PlaceholderPage(title: 'My Arc', icon: Icons.auto_awesome_rounded),
          _PlaceholderPage(title: 'Network', icon: Icons.people_rounded),
          _PlaceholderPage(title: 'Profile', icon: Icons.person_rounded),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final active = i == _currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: active ? AppColors.cyan : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                          color: active ? AppColors.cyan : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SYSTEM SCREEN (Main Dashboard)
// ─────────────────────────────────────────────
class SystemScreen extends StatefulWidget {
  const SystemScreen({super.key});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> with TickerProviderStateMixin {
  final CharacterStats _stats = CharacterStats();
  late AnimationController _xpBarController;
  late AnimationController _statsController;
  late Animation<double> _xpAnimation;

  final double _currentXP = 325;
  final double _maxXP = 1000;
  final int _level = 1;

  final List<Quest> _quests = [
    Quest(
      rank: 'C',
      arc: 'Fitness Arc',
      title: 'Morning Training Protocol',
      description: 'Complete a 20-minute workout to boost your physical stats.',
      xpReward: 250,
      statEmoji: '💪',
      statLabel: 'STR',
      statReward: 3,
      timeEstimate: '30m',
    ),
    Quest(
      rank: 'D',
      arc: 'Scholar Arc',
      title: 'Knowledge Acquisition',
      description: 'Read for 30 minutes or complete a learning module.',
      xpReward: 200,
      statEmoji: '🧠',
      statLabel: 'INT',
      statReward: 4,
      timeEstimate: '45m',
    ),
    Quest(
      rank: 'E',
      arc: 'Entrepreneur Arc',
      title: 'Social Connection Quest',
      description: "Reach out to someone you haven't spoken to in a while.",
      xpReward: 150,
      statEmoji: '✨',
      statLabel: 'CHA',
      statReward: 2,
      timeEstimate: '60m',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _xpBarController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _statsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _xpAnimation = CurvedAnimation(parent: _xpBarController, curve: Curves.easeOutCubic);

    Future.delayed(const Duration(milliseconds: 300), () {
      _xpBarController.forward();
      _statsController.forward();
    });
  }

  @override
  void dispose() {
    _xpBarController.dispose();
    _statsController.dispose();
    super.dispose();
  }

  int get _completedQuests => _quests.where((q) => q.completed).length;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildXPBar()),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverToBoxAdapter(child: _buildSystemNotification()),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildQuestsHeader()),
          SliverToBoxAdapter(child: const SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildQuestCard(_quests[i], i),
              ),
              childCount: _quests.length,
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildCharacterStats()),
          SliverToBoxAdapter(child: const SizedBox(height: 32)),
        ],
      ),
    );
  }

  // ── HEADER ──
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // LVLUP gradient text
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.cyan, AppColors.purple],
            ).createShader(bounds),
            child: Text(
              'LvlUP',
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const Spacer(),
          // Awakened badge
          Row(
            children: [
              const Icon(Icons.bolt, color: AppColors.cyan, size: 18),
              const SizedBox(width: 4),
              Text(
                'Awakened',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── XP BAR ──
  Widget _buildXPBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'LV.$_level',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.cyan,
                ),
              ),
              const Spacer(),
              Text(
                '${_currentXP.toInt()} / ${_maxXP.toInt()} XP',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _xpAnimation,
            builder: (_, __) {
              return LayoutBuilder(
                builder: (ctx, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final filled = (_currentXP / _maxXP) * _xpAnimation.value;
                  return Stack(
                    children: [
                      Container(
                        height: 6,
                        width: totalWidth,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 6,
                        width: totalWidth * filled,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [AppColors.purple, Color(0xFF3B82F6)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.purple.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ── SYSTEM NOTIFICATION ──
  Widget _buildSystemNotification() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.cyan.withOpacity(0.25),
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.cardBg,
              AppColors.purple.withOpacity(0.08),
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.cyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
              ),
              child: const Center(
                child: Text('!', style: TextStyle(color: AppColors.cyan, fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SYSTEM NOTIFICATION',
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.cyan,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your training window is open. Do not waste it, Player.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── QUESTS HEADER ──
  Widget _buildQuestsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            "TODAY'S QUESTS",
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          Text(
            '$_completedQuests/${_quests.length} Complete',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.cyan,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── QUEST CARD ──
  Widget _buildQuestCard(Quest quest, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300 + index * 100),
        opacity: quest.completed ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Colored rank border strip
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: quest.rankColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: quest.rankColor.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                // Card content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rank + Arc + Time row
                        Row(
                          children: [
                            _RankBadge(rank: quest.rank, color: quest.rankColor),
                            const SizedBox(width: 8),
                            Text(
                              quest.arc,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.access_time_rounded, size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 3),
                            Text(
                              quest.timeEstimate,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Title
                        Text(
                          quest.title,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: quest.completed
                                ? AppColors.textSecondary
                                : Colors.white,
                            decoration: quest.completed ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Description
                        Text(
                          quest.description,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Rewards + Proof button
                        Row(
                          children: [
                            const Icon(Icons.bolt, color: AppColors.cyan, size: 16),
                            const SizedBox(width: 2),
                            Text(
                              '+${quest.xpReward} XP',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.cyan,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(quest.statEmoji, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 3),
                            Text(
                              '+${quest.statReward}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.purple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            _ProofButton(
                              completed: quest.completed,
                              onProofSubmitted: () {
                                setState(() => quest.completed = true);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── CHARACTER STATS ──
  Widget _buildCharacterStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHARACTER STATS',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatRing(
                  label: 'STR',
                  value: _stats.str,
                  max: _stats.maxStat,
                  color: AppColors.red,
                  controller: _statsController,
                ),
                _StatRing(
                  label: 'VIT',
                  value: _stats.vit,
                  max: _stats.maxStat,
                  color: AppColors.green,
                  controller: _statsController,
                ),
                _StatRing(
                  label: 'INT',
                  value: _stats.intel,
                  max: _stats.maxStat,
                  color: AppColors.cyan,
                  controller: _statsController,
                ),
                _StatRing(
                  label: 'CHA',
                  value: _stats.cha,
                  max: _stats.maxStat,
                  color: AppColors.purple,
                  controller: _statsController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RANK BADGE WIDGET
// ─────────────────────────────────────────────
class _RankBadge extends StatelessWidget {
  final String rank;
  final Color color;

  const _RankBadge({required this.rank, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        'RANK $rank',
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROOF BUTTON WITH IMAGE PICKER
// ─────────────────────────────────────────────
class _ProofButton extends StatelessWidget {
  final bool completed;
  final VoidCallback onProofSubmitted;

  const _ProofButton({required this.completed, required this.onProofSubmitted});

  Future<void> _showPickerSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Submit Quest Proof',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _SheetOption(
                icon: Icons.camera_alt_rounded,
                label: 'Take a Photo',
                onTap: () {
                  Navigator.pop(ctx);
                  onProofSubmitted();
                },
              ),
              const SizedBox(height: 12),
              _SheetOption(
                icon: Icons.photo_library_rounded,
                label: 'Choose from Gallery',
                onTap: () {
                  Navigator.pop(ctx);
                  onProofSubmitted();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.green.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.green.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 15),
            const SizedBox(width: 5),
            Text(
              'Done',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => _showPickerSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cyan.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt_rounded, color: AppColors.cyan, size: 15),
            const SizedBox(width: 5),
            Text(
              'Proof',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.cyan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.cyan, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STAT RING WIDGET
// ─────────────────────────────────────────────
class _StatRing extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final Color color;
  final AnimationController controller;

  const _StatRing({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return CustomPaint(
              size: const Size(68, 68),
              painter: _RingPainter(
                progress: (value / max) * controller.value,
                color: color,
                trackColor: color.withOpacity(0.12),
              ),
              child: SizedBox(
                width: 68,
                height: 68,
                child: Center(
                  child: Text(
                    '$value',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    const strokeWidth = 5.0;

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = trackColor,
    );

    // Arc
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, color.opacity * 2);

      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress,
        false,
        arcPaint,
      );

      // Glow layer
      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..color = color.withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
