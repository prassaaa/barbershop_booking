import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/models/barber_model.dart';

class WeeklyScheduleEditor extends ConsumerStatefulWidget {
  final VoidCallback? onScheduleChanged;

  const WeeklyScheduleEditor({
    super.key,
    this.onScheduleChanged,
  });

  @override
  ConsumerState<WeeklyScheduleEditor> createState() => _WeeklyScheduleEditorState();
}

class _WeeklyScheduleEditorState extends ConsumerState<WeeklyScheduleEditor> {
  late Map<String, BarberShift> _weeklyShifts;

  final List<DayInfo> _days = [
    DayInfo('monday', 'Monday', 'Mon'),
    DayInfo('tuesday', 'Tuesday', 'Tue'),
    DayInfo('wednesday', 'Wednesday', 'Wed'),
    DayInfo('thursday', 'Thursday', 'Thu'),
    DayInfo('friday', 'Friday', 'Fri'),
    DayInfo('saturday', 'Saturday', 'Sat'),
    DayInfo('sunday', 'Sunday', 'Sun'),
  ];

  @override
  void initState() {
    super.initState();
    _initializeSchedule();
  }

  void _initializeSchedule() {
    // TODO: Load current barber schedule from provider
    _weeklyShifts = {
      for (var day in _days)
        day.key: day.key == 'sunday'
            ? const BarberShift(
                isWorking: false,
                breakTimes: [],
              )
            : const BarberShift(
                isWorking: true,
                startTime: '09:00',
                endTime: '17:00',
                breakTimes: ['12:00-13:00'],
              ),
    };
  }

  @override
  Widget build(BuildContext context) {
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
              'Weekly Schedule',
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Days List
            ..._days.map((day) => 
              _buildDayScheduleCard(day)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayScheduleCard(DayInfo dayInfo) {
    final shift = _weeklyShifts[dayInfo.key]!;
    final isToday = _isToday(dayInfo.key);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        color: isToday 
            ? AppColors.primary.withValues(alpha: 0.05)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isToday 
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.grey.shade300,
            width: isToday ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Day Header
              Row(
                children: [
                  // Day Name
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayInfo.fullName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isToday ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        if (isToday)
                          Text(
                            'Today',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Working Toggle
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'OFF',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: !shift.isWorking ? AppColors.error : AppColors.textSecondary,
                            fontWeight: !shift.isWorking ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: shift.isWorking,
                          onChanged: (value) {
                            _updateDayWorking(dayInfo.key, value);
                          },
                          activeColor: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ON',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: shift.isWorking ? AppColors.success : AppColors.textSecondary,
                            fontWeight: shift.isWorking ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Working Hours (if working)
              if (shift.isWorking) ...[
                const SizedBox(height: 16),
                _buildWorkingHoursSection(dayInfo.key, shift),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkingHoursSection(String dayKey, BarberShift shift) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Working Hours
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Working Hours',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildTimeButton(
                          shift.startTime ?? '09:00',
                          () => _selectTime(dayKey, 'start'),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'to',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildTimeButton(
                          shift.endTime ?? '17:00',
                          () => _selectTime(dayKey, 'end'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Break Times
          Row(
            children: [
              Icon(
                Icons.coffee,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Break Times',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _addBreakTime(dayKey),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.warning,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (shift.breakTimes.isEmpty)
                      Text(
                        'No breaks',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: shift.breakTimes.map((breakTime) =>
                          _buildBreakTimeChip(dayKey, breakTime)
                        ).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String time, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            time,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreakTimeChip(String dayKey, String breakTime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            breakTime,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _removeBreakTime(dayKey, breakTime),
            child: Icon(
              Icons.close,
              size: 14,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  void _updateDayWorking(String dayKey, bool isWorking) {
    setState(() {
      _weeklyShifts[dayKey] = _weeklyShifts[dayKey]!.copyWith(
        isWorking: isWorking,
      );
    });
    widget.onScheduleChanged?.call();
  }

  Future<void> _selectTime(String dayKey, String timeType) async {
    final currentShift = _weeklyShifts[dayKey]!;
    final currentTime = timeType == 'start' 
        ? currentShift.startTime ?? '09:00'
        : currentShift.endTime ?? '17:00';
    
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(currentTime.split(':')[0]),
        minute: int.parse(currentTime.split(':')[1]),
      ),
    );

    if (selectedTime != null) {
      final timeString = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      
      setState(() {
        _weeklyShifts[dayKey] = timeType == 'start'
            ? currentShift.copyWith(startTime: timeString)
            : currentShift.copyWith(endTime: timeString);
      });
      widget.onScheduleChanged?.call();
    }
  }

  void _addBreakTime(String dayKey) {
    showDialog(
      context: context,
      builder: (context) => _BreakTimeDialog(
        onBreakTimeAdded: (breakTime) {
          setState(() {
            final currentShift = _weeklyShifts[dayKey]!;
            final updatedBreakTimes = [...currentShift.breakTimes, breakTime];
            _weeklyShifts[dayKey] = currentShift.copyWith(
              breakTimes: updatedBreakTimes,
            );
          });
          widget.onScheduleChanged?.call();
        },
      ),
    );
  }

  void _removeBreakTime(String dayKey, String breakTime) {
    setState(() {
      final currentShift = _weeklyShifts[dayKey]!;
      final updatedBreakTimes = currentShift.breakTimes
          .where((time) => time != breakTime)
          .toList();
      _weeklyShifts[dayKey] = currentShift.copyWith(
        breakTimes: updatedBreakTimes,
      );
    });
    widget.onScheduleChanged?.call();
  }

  bool _isToday(String dayKey) {
    final today = DateTime.now().weekday;
    final dayIndex = _days.indexWhere((day) => day.key == dayKey);
    return today - 1 == dayIndex; // Monday = 0
  }
}

class DayInfo {
  final String key;
  final String fullName;
  final String shortName;

  DayInfo(this.key, this.fullName, this.shortName);
}

class _BreakTimeDialog extends StatefulWidget {
  final Function(String) onBreakTimeAdded;

  const _BreakTimeDialog({required this.onBreakTimeAdded});

  @override
  State<_BreakTimeDialog> createState() => _BreakTimeDialogState();
}

class _BreakTimeDialogState extends State<_BreakTimeDialog> {
  TimeOfDay _startTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 13, minute: 0);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Break Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Start Time'),
            trailing: Text(
              _startTime.format(context),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _startTime,
              );
              if (time != null) {
                setState(() {
                  _startTime = time;
                });
              }
            },
          ),
          ListTile(
            title: const Text('End Time'),
            trailing: Text(
              _endTime.format(context),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _endTime,
              );
              if (time != null) {
                setState(() {
                  _endTime = time;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final startString = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
            final endString = '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';
            final breakTime = '$startString-$endString';
            
            widget.onBreakTimeAdded(breakTime);
            Navigator.pop(context);
          },
          child: const Text('Add Break'),
        ),
      ],
    );
  }
}
