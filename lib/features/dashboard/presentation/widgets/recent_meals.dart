import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RecentMeals extends StatelessWidget {
  final List<Map<String, dynamic>> recentMeals;

  const RecentMeals({Key? key, required this.recentMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
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
                  'Bữa ăn gần đây',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/history');
                  },
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
            if (recentMeals.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    'Không có bữa ăn nào gần đây',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
               ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentMeals.length,
                  itemBuilder: (context, index) {
                    final meal = recentMeals[index];
                    return _buildMealItem(context, meal);
                  },
                ),

          ],
        ),
      ),
    );
  }

  Widget _buildMealItem(BuildContext context, Map<String, dynamic> meal) {
    final mealId = meal['meal_id'] as String;
    final mealTime = DateTime.parse(meal['meal_time']);
    final imageUrl = meal['image_url'] as String?;
    final note = meal['note'] as String?;
    final totalCalories = (meal['total_calories'] as num?)?.toDouble() ?? 0;
    final foodItemCount = meal['food_item_count'] as int? ?? 0;

    final dateFormatter = DateFormat('dd/MM/yyyy - HH:mm');
    final formattedDate = dateFormatter.format(mealTime);

    return InkWell(
      onTap: () {
        context.go('/history');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.dining, size: 40, color: Colors.grey),
              ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  if (note != null && note.isNotEmpty)
                    Text(
                      note,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '$foodItemCount món',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 16.0),
                      Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.orange.shade600,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${totalCalories.round()} kcal',
                        style: TextStyle(color: Colors.orange.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
