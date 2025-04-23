import 'package:flutter/material.dart';
import 'package:nu365/core/constants/app_theme.dart';

class NutritionChart extends StatefulWidget {
  const NutritionChart({Key? key}) : super(key: key);

  @override
  State<NutritionChart> createState() => _NutritionChartState();
}

class _NutritionChartState extends State<NutritionChart> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<int> _caloriesData = [1200, 1450, 1800, 1600, 1350, 1500, 1450];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutrition History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Calories'),
                Tab(text: 'Protein'),
                Tab(text: 'Carbs'),
                Tab(text: 'Fat'),
              ],
            ),
            SizedBox(
              height: 200,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBarChart(_caloriesData, 'kcal'),
                  _buildPlaceholderChart('Protein chart data'),
                  _buildPlaceholderChart('Carbs chart data'),
                  _buildPlaceholderChart('Fat chart data'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(List<int> data, String unit) {
    final maxValue = data.reduce((a, b) => a > b ? a : b) * 1.1;
    
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          data.length,
          (index) {
            final value = data[index];
            final barHeight = (value / maxValue) * 150;
            
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  children: [
                    Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _days[index],
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderChart(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
