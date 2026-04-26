import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedGoal = 'Weight Loss';

  final List<String> _goals = [
    'Weight Loss',
    'Muscle Gain',
    'Maintenance',
    'Improve Immunity',
    'Better Digestion',
  ];

  final List<Map<String, dynamic>> _stats = [
    {'label': 'Recipes Generated', 'value': '24', 'icon': Icons.restaurant_menu_rounded},
    {'label': 'Saved Recipes', 'value': '8', 'icon': Icons.bookmark_rounded},
    {'label': 'Days Active', 'value': '12', 'icon': Icons.calendar_today_rounded},
    {'label': 'Avg. Calories', 'value': '1840', 'icon': Icons.local_fire_department_rounded},
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.person_outline_rounded, 'label': 'Edit Profile', 'color': AppTheme.primaryGreen},
    {'icon': Icons.fitness_center_rounded, 'label': 'Nutrition Goals', 'color': AppTheme.infoBlue},
    {'icon': Icons.history_rounded, 'label': 'Recipe History', 'color': AppTheme.warningAmber},
    {'icon': Icons.share_rounded, 'label': 'Share NutriSync', 'color': AppTheme.accentTeal},
    {'icon': Icons.star_outline_rounded, 'label': 'Rate the App', 'color': AppTheme.carbsColor},
    {'icon': Icons.help_outline_rounded, 'label': 'Help & Support', 'color': AppTheme.textSecondary},
    {'icon': Icons.privacy_tip_outlined, 'label': 'Privacy Policy', 'color': AppTheme.textSecondary},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Header ────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryGreenDark,
                    AppTheme.primaryGreen,
                    AppTheme.accentTeal,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    // Background circles
                    Positioned(
                      right: -40,
                      top: -20,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      child: Column(
                        children: [
                          // Appbar row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.restaurant_menu_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'NutriSync',
                                    style: AppTheme.headlineMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.settings_outlined,
                                      size: 22, color: Colors.white),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          // Avatar
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(Icons.person_rounded,
                                    size: 44, color: Colors.white),
                              )
                                  .animate()
                                  .scale(
                                    begin: const Offset(0.5, 0.5),
                                    end: const Offset(1.0, 1.0),
                                    duration: 600.ms,
                                    curve: Curves.elasticOut,
                                  )
                                  .fadeIn(duration: 400.ms),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: AppTheme.softShadow,
                                ),
                                child: const Icon(Icons.edit_rounded,
                                    size: 14, color: AppTheme.primaryGreen),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'SHAILESH S',
                            style: AppTheme.headlineLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0, delay: 200.ms, duration: 400.ms),
                          const SizedBox(height: 4),
                          Text(
                            'Nutrition Enthusiast • Keto Lover',
                            style: AppTheme.bodySmall.copyWith(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 300.ms, duration: 400.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Stats Row ──────────────────────────────────
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppTheme.mediumShadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _stats.asMap().entries.map((entry) {
                      return _buildStatItem(entry.value, entry.key);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),

          // ─── Body ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),

                  // Goal Section
                  _buildSectionTitle('Nutrition Goal'),
                  const SizedBox(height: 12),
                  _buildGoalSelector()
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.05, end: 0, delay: 300.ms, duration: 400.ms),

                  const SizedBox(height: 28),

                  // Settings
                  _buildSectionTitle('Preferences'),
                  const SizedBox(height: 12),
                  _buildSettingsCard()
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideY(begin: 0.05, end: 0, delay: 400.ms, duration: 400.ms),

                  const SizedBox(height: 28),

                  // Menu
                  _buildSectionTitle('Account'),
                  const SizedBox(height: 12),
                  _buildMenuCard()
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms)
                      .slideY(begin: 0.05, end: 0, delay: 500.ms, duration: 400.ms),

                  const SizedBox(height: 20),

                  // Logout
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.errorRed.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded,
                              color: AppTheme.errorRed, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Log Out',
                            style: AppTheme.titleMedium.copyWith(
                              color: AppTheme.errorRed,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms),

                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'NutriSync v1.0.0 • AI Powered',
                      style: AppTheme.bodySmall.copyWith(fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTheme.headlineLarge.copyWith(fontSize: 18))
        .animate()
        .fadeIn(duration: 400.ms);
  }

  Widget _buildStatItem(Map<String, dynamic> stat, int index) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.surfaceGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(stat['icon'] as IconData,
              color: AppTheme.primaryGreen, size: 22),
        )
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              delay: (100 * index).ms + 400.ms,
              duration: 400.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(delay: (100 * index).ms + 400.ms, duration: 300.ms),
        const SizedBox(height: 8),
        Text(
          stat['value'] as String,
          style: AppTheme.headlineMedium.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          stat['label'] as String,
          style: AppTheme.bodySmall.copyWith(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGoalSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Goal',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _goals.map((goal) {
              final isSelected = goal == _selectedGoal;
              return GestureDetector(
                onTap: () => setState(() => _selectedGoal = goal),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppTheme.primaryGradient : null,
                    color: isSelected ? null : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: isSelected ? AppTheme.greenGlow : [],
                  ),
                  child: Text(
                    goal,
                    style: AppTheme.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          _buildToggleTile(
            icon: Icons.notifications_outlined,
            label: 'Push Notifications',
            subtitle: 'Daily meal reminders',
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ),
          Divider(height: 1, color: AppTheme.dividerColor.withOpacity(0.5)),
          _buildToggleTile(
            icon: Icons.dark_mode_outlined,
            label: 'Dark Mode',
            subtitle: 'Enable dark theme',
            value: _darkModeEnabled,
            onChanged: (val) => setState(() => _darkModeEnabled = val),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.surfaceGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.titleMedium.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTheme.bodySmall.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: _menuItems.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final isLast = i == _menuItems.length - 1;
          return Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              (item['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: item['color'] as Color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item['label'] as String,
                          style: AppTheme.titleMedium.copyWith(fontSize: 14),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppTheme.textTertiary, size: 22),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 70,
                  color: AppTheme.dividerColor.withOpacity(0.5),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
