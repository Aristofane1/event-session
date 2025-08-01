import 'package:event_session/config/themes/app_themes.dart';
import 'package:event_session/core/widgets/customButton.dart';
import 'package:flutter/material.dart' hide ButtonStyle;

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String _selectedTimeOption = 'Today';
  DateTime? _selectedDate;
  final Set<String> _selectedStatuses = {'Paid', 'Completed'};
  String _selectedEventType = 'Offline';

  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = 'Ex 01.01.2023';
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Widget _buildTimeOption(String text) {
    bool isSelected = _selectedTimeOption == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeOption = text;
          _dateController.text = "";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 39,
        decoration: BoxDecoration(
          color: isSelected ? AppThemes.primaryColor : const Color(0xFFFFF2CF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String text) {
    bool isSelected = _selectedStatuses.contains(text);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedStatuses.remove(text);
          } else {
            _selectedStatuses.add(text);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? AppThemes.primaryColor : const Color(0xFFFFF9EF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 6),
            isSelected
                ? Icon(Icons.close, size: 16, color: Colors.white)
                : Icon(Icons.add, size: 16, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTypeOption(String text) {
    bool isSelected = _selectedEventType == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEventType = text;
        });
      },
      child: Container(
        height: 39,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppThemes.primaryColor : const Color(0xFFFFF2CF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            'Filter',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Time & Date Section
          const Text(
            'Time & Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Time options
          Row(
            children: [
              _buildTimeOption('Today'),
              const SizedBox(width: 12),
              _buildTimeOption('Tomorrow'),
              const SizedBox(width: 12),
              _buildTimeOption('This week'),
            ],
          ),
          const SizedBox(height: 16),

          // Choose from calendar
          const Text(
            'Choose from calendar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Date picker field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: TextField(
              controller: _dateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                hintText: "Ex 01.01.2023",
                hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: AppThemes.primaryColor,
                  size: 20,
                ),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() {
                    _selectedTimeOption = "";
                    _selectedDate = date;
                    _dateController.text =
                        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 16),

          // Status Section
          const Text(
            'Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Status chips
          Wrap(
            children: [
              _buildStatusChip('Paid'),
              _buildStatusChip('Completed'),
              _buildStatusChip('Canceled'),
              _buildStatusChip('Upcoming'),
            ],
          ),
          const SizedBox(height: 16),

          // Pict Event Type Section
          const Text(
            'Pict Event Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Event type options
          Row(
            children: [
              Expanded(child: _buildEventTypeOption('Offline')),
              const SizedBox(width: 16),
              Expanded(child: _buildEventTypeOption('Online')),
            ],
          ),
          const SizedBox(height: 40),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttonStyle: ButtonStyle.outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: "Save",
                  onPressed: () {
                    Navigator.of(context).pop({
                      'timeOption': _selectedTimeOption,
                      'selectedDate': _selectedDate,
                      'statuses': _selectedStatuses.toList(),
                      'eventType': _selectedEventType,
                    });
                  },
                  color: AppThemes.secondaryColor,
                  buttonStyle: ButtonStyle.elevated,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
