import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nu365/core/constants/app_theme.dart';
import 'package:nu365/features/scan/logic/scan_bloc.dart';
import 'package:nu365/features/scan/logic/scan_event.dart';
import 'package:nu365/features/scan/logic/scan_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Sử dụng BlocConsumer thay vì BlocBuilder để xử lý cả state và events
    return BlocConsumer<ScanBloc, ScanState>(
      listener: (context, state) {
        // Không cần xử lý navigation ở đây vì đã được xử lý trong wrapper
      },
      builder: (context, state) {
        // Update loading state
        _isLoading = state is ScanLoading;

        if (_isLoading) {
          // Thay thế CircularProgressIndicator bằng Skeletonizer
          return Skeletonizer(
            enabled: true,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 60,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    height: 32,
                    width: 180,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.7,
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[300],
                      ),
                      height: 48,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                        color: Colors.grey[100],
                      ),
                      height: 48,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                size: 80,
                color: AppTheme.primaryPurple,
              ),
              const SizedBox(height: 24),
              const Text(
                'Scan Your Food',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Take a photo of your meal to get instant nutritional information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _takePicture(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt),
                            SizedBox(width: 8),
                            Text(
                              'Take Photo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(context),
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Upload Image'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Truyền context vào các phương thức để đảm bảo sử dụng đúng context
  Future<void> _takePicture(BuildContext context) async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80,
      );

      if (photo != null && context.mounted) {
        // Sử dụng BlocProvider.of với listen: false
        BlocProvider.of<ScanBloc>(context, listen: false)
            .add(TakeImgEvent(imgfile: File(photo.path)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking picture: $e')),
        );
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null && context.mounted) {
        // Sử dụng BlocProvider.of với listen: false
        BlocProvider.of<ScanBloc>(context, listen: false)
            .add(TakeImgEvent(imgfile: File(image.path)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }
}
