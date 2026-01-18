// lib/features/more/more_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/toast_service.dart'; // ✅ Import ToastService
import '../transactions/model/expense_model.dart';
import '../budget/model/monthly_budget.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('More'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // PREMIUM CARD
          _buildPremiumCard(context),

          const SizedBox(height: 24),

          // GENERAL SECTION
          _buildSectionTitle('General'),
          const SizedBox(height: 8),
          _buildSettingsCard([
            _SettingsItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => _showComingSoon(context, 'Settings'),
            ),
            _SettingsItem(
              icon: Icons.palette_outlined,
              title: 'Appearance',
              subtitle: 'Dark mode',
              onTap: () => _showComingSoon(context, 'Appearance'),
            ),
            _SettingsItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => _showComingSoon(context, 'Notifications'),
            ),
          ]),

          const SizedBox(height: 24),

          // SUPPORT & SHARE
          _buildSectionTitle('Support & Share'),
          const SizedBox(height: 8),
          _buildSettingsCard([
            _SettingsItem(
              icon: Icons.help_outline,
              title: 'Help & FAQ',
              onTap: () => _showComingSoon(context, 'Help & FAQ'),
            ),
            _SettingsItem(
              icon: Icons.share_outlined,
              title: 'Invite a Friend',
              onTap: () => _showComingSoon(context, 'Invite'),
            ),
            _SettingsItem(
              icon: Icons.star_outline,
              title: 'Rate Us',
              onTap: () => _showComingSoon(context, 'Rate Us'),
            ),
          ]),

          const SizedBox(height: 24),

          // ABOUT SECTION
          _buildSectionTitle('About'),
          const SizedBox(height: 8),
          _buildSettingsCard([
            _SettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => _showComingSoon(context, 'Privacy Policy'),
            ),
            _SettingsItem(
              icon: Icons.info_outline,
              title: 'App Version',
              subtitle: '1.0.0',
              showArrow: false,
              onTap: () => _showAppVersion(context),
            ),
          ]),

          const SizedBox(height: 32),

          // LOGOUT BUTTON (Clear Data)
          _buildLogoutButton(context),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ---------------- PREMIUM CARD ----------------
  Widget _buildPremiumCard(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showComingSoon(context, 'Premium Features'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.accent.withOpacity(0.2),
                AppColors.primary.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: AppColors.accent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Go Premium',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Unlock advanced features',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.accent,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.mutedText,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<_SettingsItem> items) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon, color: AppColors.text, size: 20),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(fontSize: 16, color: AppColors.text),
                ),
                subtitle: item.subtitle != null
                    ? Text(
                  item.subtitle!,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.mutedText),
                )
                    : null,
                trailing: item.showArrow
                    ? const Icon(Icons.arrow_forward_ios,
                    color: AppColors.mutedText, size: 16)
                    : null,
                onTap: item.onTap,
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 56,
                  endIndent: 16,
                  color: AppColors.background,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.delete_forever, color: Colors.red, size: 20),
        ),
        title: const Text(
          'Clear All Data',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
        subtitle: const Text(
          'Delete all expenses and budgets',
          style: TextStyle(fontSize: 12, color: AppColors.mutedText),
        ),
        onTap: () => _showClearDataDialog(context),
      ),
    );
  }

  // ---------------- DIALOGS ----------------

  // 1. Coming Soon Popup
  void _showComingSoon(BuildContext context, String featureName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 56, // Added padding
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.construction, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  featureName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'We are working hard to bring this feature to you in the next update. Stay tuned!',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Okay'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. App Version Popup
  void _showAppVersion(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 56, // Added padding
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.savings_outlined, color: AppColors.primary, size: 24),
                SizedBox(width: 8),
                Text(
                  'SpendLite',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Simple, secure, and smart budget tracking designed to help you save money.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.card,
                  foregroundColor: AppColors.text,
                  side: const BorderSide(color: AppColors.mutedText),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Clear Data Dialog
  void _showClearDataDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 56, // Added padding
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Clear All Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to delete all your expenses and budgets? This action cannot be undone.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 24),

            // Delete Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  try {
                    await Hive.box<Expense>('expenses').clear();
                    await Hive.box<MonthlyBudget>('budgets').clear();

                    if (context.mounted) {
                      Navigator.pop(context);
                      // ✅ UPDATED: Use ToastService for TOP notification
                      ToastService.show(context, 'All data cleared successfully');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      // ✅ UPDATED: Use ToastService for TOP error
                      ToastService.show(context, 'Failed to clear data', isError: true);
                    }
                  }
                },
                child: const Text('Delete All Data'),
              ),
            ),
            const SizedBox(height: 8),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.mutedText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- SETTINGS ITEM MODEL ----------------
class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool showArrow;
  final VoidCallback? onTap;

  _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.showArrow = true,
    this.onTap,
  });
}