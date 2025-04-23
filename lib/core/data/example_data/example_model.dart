import 'package:objectbox/objectbox.dart';

@Entity()
class ExampleModel {
  int id = 0;
  String content;

  ExampleModel({required this.content});
}
