import 'package:flutter/material.dart';
import 'package:nu365/features/scan/models/prediction.dart';
import 'package:nu365/features/scan/models/scan_result.dart';
import 'package:nu365/features/scan/presentation/widgets/nutrition_tab_content.dart';
import 'package:nu365/features/scan/presentation/widgets/ingredients_tab_content.dart';
import 'package:nu365/core/constants/app_theme.dart';

class ScanResultsTabs extends StatefulWidget {
  final List<FoodInfo> nutrition;
  final List<Prediction> predictions;

  const ScanResultsTabs({
    super.key,
    required this.nutrition,
    required this.predictions,
  });

  @override
  State<ScanResultsTabs> createState() => _ScanResultsTabsState();
}

class _ScanResultsTabsState extends State<ScanResultsTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryPurple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryPurple,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Nutrition'),
              Tab(text: 'Ingredients'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                NutritionTabContent(nutrition: widget.nutrition),
                IngredientsTabContent(predictions: widget.predictions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
