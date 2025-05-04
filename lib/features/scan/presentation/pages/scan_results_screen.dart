import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/scan/logic/scan_bloc.dart';
import 'package:nu365/features/scan/logic/scan_state.dart';
import 'package:nu365/features/scan/models/prediction.dart';
import 'package:nu365/features/scan/models/scan_result.dart';
import 'package:nu365/features/scan/presentation/widgets/food_image_container.dart';
import 'package:nu365/features/scan/presentation/widgets/scan_results_actions.dart';
import 'package:nu365/features/scan/presentation/widgets/scan_results_tabs.dart';
import 'package:nu365/features/scan/services/result_scan_service.dart';
import 'package:nu365/setup_service_locator.dart';

class ScanResultsScreen extends StatefulWidget {
  final List<Prediction> predictions;
  final File imageFile;

  const ScanResultsScreen({
    super.key,
    required this.imageFile,
    required this.predictions,
  });

  @override
  State<ScanResultsScreen> createState() => _ScanResultsScreenState();
}

class _ScanResultsScreenState extends State<ScanResultsScreen> {
  List<FoodInfo>? foodInfoList;
  bool isLoading = true;
  bool _isSaving = false;
  final _resultScanService = sl<ResultScanService>();

  @override
  void initState() {
    super.initState();
    // Không cần gọi lại event FetchFoodData vì nó đã được gọi trong ScanBloc
    // khi nhận được ScanSuccess
  }

  // Hàm hiển thị dialog nhập ghi chú
  Future<String?> _showNoteDialog() async {
    final textController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ghi chú bữa ăn'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Nhập ghi chú về bữa ăn này',
              counterText: '0/50',
            ),
            maxLength: 50,
            onChanged: (text) {
              // Cập nhật counter text khi nhập liệu
              textController.buildTextSpan(
                context: context,
                withComposing: false,
                style: const TextStyle(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, textController.text),
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.3;

    return BlocConsumer<ScanBloc, ScanState>(
      listener: (context, state) {
        if (state is FecthFoodDataSuccess) {
          setState(() {
            foodInfoList = state.foodInfoList;
            isLoading = false;
          });
        }
      },
      builder: (context, state) {
        if (state is ScanLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              // Image container
              FoodImageContainer(
                imageFile: widget.imageFile,
                size: imageSize,
              ),

              // Tab view with nutrition and ingredients
              isLoading || foodInfoList == null
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : ScanResultsTabs(
                      nutrition: foodInfoList!,
                      predictions: widget.predictions,
                    ),

              // Bottom action buttons
              ScanResultsActions(
                onRetake: () => Navigator.pop(context),
                onSave: () async {
                  if (foodInfoList == null || _isSaving) return;

                  // Hiển thị dialog nhập ghi chú
                  final note = await _showNoteDialog();
                  if (note == null) {
                    // Người dùng đã hủy
                    return;
                  }

                  setState(() {
                    _isSaving = true;
                  });

                  try {
                    // Use ResultScanService to save scan results
                    final success = await _resultScanService.saveScanResults(
                      foodInfoList: foodInfoList!,
                      imageFile: widget.imageFile,
                      note: note.isNotEmpty ? note : 'Scanned meal',
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Food added to meal log')),
                      );
                      Navigator.pop(context);
                    } else {
                      throw Exception('Failed to save meal');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Error saving meal: ${e.toString()}')),
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isSaving = false;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
