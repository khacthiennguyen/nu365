import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nu365/core/constants/app_theme.dart';

class PersonalInfoSection extends StatelessWidget {
  final String email;
  final DateTime? dateOfBirth;
  final bool isEditMode;
  final TextEditingController emailController;
  final void Function() onSelectDate;

  const PersonalInfoSection({
    super.key,
    required this.email,
    required this.dateOfBirth,
    required this.isEditMode,
    required this.emailController,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    final String birthDateText = dateOfBirth != null
        ? DateFormat('dd/MM/yyyy').format(dateOfBirth!)
        : 'Chưa thiết lập';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thông tin cá nhân',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                Icon(
                  Icons.person,
                  color: AppTheme.primaryPurple,
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoField(
              label: 'Email',
              value: email,
              isEditable: false,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildDateOfBirthField(birthDateText),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required bool isEditable,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        isEditMode && isEditable
            ? TextField(
                controller: controller,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  hintText: 'Nhập $label',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ],
    );
  }

  Widget _buildDateOfBirthField(String birthDateText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngày sinh',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        isEditMode
            ? InkWell(
                onTap: onSelectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(birthDateText),
                      const Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
              )
            : Text(
                birthDateText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ],
    );
  }
}
