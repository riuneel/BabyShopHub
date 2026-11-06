import 'package:flutter/material.dart';
import 'package:babyshophub/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        title: const Text(
          'Need Help?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.4),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.phone,
                          size: 26,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '+2347073205697',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColors.secondary.withOpacity(0.4),
                      thickness: 1,
                      indent: 5,
                      endIndent: 5,
                      height: 24,
                    ),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.mail,
                          size: 26,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'rabiumuhammadnabeel@gmail.com',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary.withOpacity(0.8),
                          ),
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

    );
  }
}
