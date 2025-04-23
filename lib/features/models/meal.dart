class Meal {
  final int id;
  final String name;
  final String time;
  final String type;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String image;

  Meal({
    required this.id,
    required this.name,
    required this.time,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.image,
  });
}

class DayMeals {
  final String date;
  final List<Meal> meals;

  DayMeals({
    required this.date,
    required this.meals,
  });
}

// Sample data
final List<DayMeals> mealHistory = [
  DayMeals(
    date: 'Today',
    meals: [
      Meal(
        id: 1,
        name: 'Avocado Toast',
        time: '8:30 AM',
        type: 'Breakfast',
        calories: 350,
        protein: 12,
        carbs: 30,
        fat: 18,
        image: 'assets/images/placeholder.png',
      ),
      Meal(
        id: 2,
        name: 'Chicken Salad',
        time: '12:45 PM',
        type: 'Lunch',
        calories: 420,
        protein: 35,
        carbs: 15,
        fat: 22,
        image: 'assets/images/placeholder.png',
      ),
      Meal(
        id: 3,
        name: 'Protein Smoothie',
        time: '4:15 PM',
        type: 'Snack',
        calories: 280,
        protein: 20,
        carbs: 35,
        fat: 5,
        image: 'assets/images/placeholder.png',
      ),
      Meal(
        id: 4,
        name: 'Grilled Salmon',
        time: '7:30 PM',
        type: 'Dinner',
        calories: 400,
        protein: 40,
        carbs: 5,
        fat: 22,
        image: 'assets/images/placeholder.png',
      ),
    ],
  ),
  DayMeals(
    date: 'Yesterday',
    meals: [
      Meal(
        id: 5,
        name: 'Oatmeal with Berries',
        time: '8:00 AM',
        type: 'Breakfast',
        calories: 320,
        protein: 10,
        carbs: 45,
        fat: 8,
        image: 'assets/images/placeholder.png',
      ),
      Meal(
        id: 6,
        name: 'Turkey Sandwich',
        time: '1:00 PM',
        type: 'Lunch',
        calories: 450,
        protein: 30,
        carbs: 40,
        fat: 15,
        image: 'assets/images/placeholder.png',
      ),
      Meal(
        id: 7,
        name: 'Vegetable Stir Fry',
        time: '7:00 PM',
        type: 'Dinner',
        calories: 380,
        protein: 25,
        carbs: 30,
        fat: 18,
        image: 'assets/images/placeholder.png',
      ),
    ],
  ),
];
