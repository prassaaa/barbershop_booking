import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../widgets/weekly_schedule_editor.dart';
import '../widgets/schedule_quick_actions.dart';

class BarberSchedulePage extends ConsumerStatefulWidget {
  const BarberSchedulePage({super.key});

  @override
  ConsumerState<BarberSchedulePage> createState() => _BarberSchedulePageState();
}

class _BarberSchedulePageState extends ConsumerState<BarberSchedulePage> {
  bool _hasUnsavedChanges = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await _showUnsavedChangesDialog();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Manage Schedule',
          actions: [
            if (_hasUnsavedChanges)
              TextButton(
                onPressed: _saveChanges,
                child: Text(
                  'Save',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              const ScheduleQuickActions(),
              
              const SizedBox(height: 24),
              
              // Weekly Schedule Editor
              WeeklyScheduleEditor(
                onScheduleChanged: () {
                  setState(() {
                    _hasUnsavedChanges = true;
                  });
                },
              ),
              
              const SizedBox(height: 24),
              
              // Schedule Templates
              _buildScheduleTemplates(),
              
              const SizedBox(height: 24),
              
              // Save Button
              if (_hasUnsavedChanges)
                _buildSaveSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Weekly Schedule',
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            'Set your working hours for each day of the week. Customers will only be able to book appointments during your available hours.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Current Week Status
          _buildCurrentWeekStatus(),
        ],
      ),
    );
  }

  Widget _buildCurrentWeekStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'You\'re working 6 days this week (Monday - Saturday)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTemplates() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Templates',
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Apply common schedule patterns to save time',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Template Options
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildTemplateChip(
                  'Monday - Friday',
                  'Work weekdays only',
                  Icons.business_center,
                  () => _applyTemplate('weekdays'),
                ),
                _buildTemplateChip(
                  'Monday - Saturday',
                  'Work 6 days a week',
                  Icons.calendar_view_week,
                  () => _applyTemplate('six_days'),
                ),
                _buildTemplateChip(
                  'Weekend Only',
                  'Saturday & Sunday',
                  Icons.weekend,
                  () => _applyTemplate('weekend'),
                ),
                _buildTemplateChip(
                  'All Days',
                  'Work every day',
                  Icons.all_inclusive,
                  () => _applyTemplate('all_days'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateChip(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'You have unsaved changes',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _discardChanges,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                  ),
                  child: const Text('Discard'),
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _showUnsavedChangesDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes to your schedule. Do you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Discard',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  void _applyTemplate(String template) {
    // TODO: Implement template application
    setState(() {
      _hasUnsavedChanges = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied $template template'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _saveChanges() {
    // TODO: Implement save logic
    setState(() {
      _hasUnsavedChanges = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Schedule saved successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _discardChanges() {
    setState(() {
      _hasUnsavedChanges = false;
    });
    
    // TODO: Reset schedule to original state
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes discarded'),
      ),
    );
  }
}
