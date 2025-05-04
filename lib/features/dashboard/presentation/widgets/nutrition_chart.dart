import 'package:flutter/material.dart';

class NutritionChart extends StatefulWidget {
  final Map<String, List<double>> weeklyNutrition;

  const NutritionChart({Key? key, required this.weeklyNutrition})
      : super(key: key);

  @override
  State<NutritionChart> createState() => _NutritionChartState();
}

class _NutritionChartState extends State<NutritionChart> {
  int _selectedIndex = 0;
  final List<String> _nutrients = ['calories', 'protein', 'fat', 'carbs'];
  final List<Color> _colors = [
    Colors.red.shade400,
    Colors.blue.shade400,
    Colors.amber.shade400,
    Colors.green.shade400,
  ];
  final List<String> _labels = ['Calories', 'Protein', 'Chất béo', 'Carbs'];
  final List<String> _days = ['Th2', 'Th3', 'Th4', 'Th5', 'Th6', 'Th7', 'CN'];

  @override
  Widget build(BuildContext context) {
    final selectedNutrient = _nutrients[_selectedIndex];
    final data =
        widget.weeklyNutrition[selectedNutrient] ?? List.filled(7, 0.0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theo dõi 7 ngày qua',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _nutrients.length,
                (index) => _buildNutrientSelector(index),
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              height: 200,
              child: Column(
                children: [
                  Expanded(
                    child: _buildCustomBarChart(data),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      7,
                      (index) => Text(
                        _days[index],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBarChart(List<double> data) {
    final double maxValue = _getMaxValue(data);

    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${maxValue.round()}', style: const TextStyle(fontSize: 10)),
            Text('${(maxValue * 0.75).round()}',
                style: const TextStyle(fontSize: 10)),
            Text('${(maxValue * 0.5).round()}',
                style: const TextStyle(fontSize: 10)),
            Text('${(maxValue * 0.25).round()}',
                style: const TextStyle(fontSize: 10)),
            const Text('0', style: TextStyle(fontSize: 10)),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              data.length,
              (index) => _buildBar(data[index], maxValue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBar(double value, double maxValue) {
    final heightPercentage = maxValue > 0 ? value / maxValue : 0;

    return Tooltip(
      message: _selectedIndex == 0
          ? '${value.round()} calories'
          : '${value.round()}g',
      child: Container(
        width: 30,
        height: (170 * heightPercentage).toDouble(),
        decoration: BoxDecoration(
          color: _colors[_selectedIndex],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientSelector(int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? _colors[index].withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? _colors[index] : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          _labels[index],
          style: TextStyle(
            color: isSelected ? _colors[index] : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  double _getMaxValue(List<double> data) {
    if (data.isEmpty) return 100;
    final max =
        data.reduce((value, element) => value > element ? value : element);
    return max > 0 ? (max * 1.2).ceilToDouble() : 100;
  }
}
