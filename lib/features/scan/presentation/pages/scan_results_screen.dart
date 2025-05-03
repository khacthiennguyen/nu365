import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/scan/logic/scan_bloc.dart';
import 'package:nu365/features/scan/logic/scan_event.dart';
import 'package:nu365/features/scan/logic/scan_state.dart';
import 'package:nu365/features/scan/models/prediction.dart';
import 'package:nu365/features/scan/models/scan_result.dart';
import 'package:nu365/features/scan/presentation/widgets/food_image_container.dart';
import 'package:nu365/features/scan/presentation/widgets/scan_results_actions.dart';
import 'package:nu365/features/scan/presentation/widgets/scan_results_tabs.dart';

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

  @override
  void initState() {
    super.initState();
    // Không cần gọi lại event FetchFoodData vì nó đã được gọi trong ScanBloc
    // khi nhận được ScanSuccess
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
                onSave: () {
                  // Add save logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Food added to meal log')),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
