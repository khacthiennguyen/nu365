
import 'package:nu365/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

// Định nghĩa interface ObjectBox
abstract class ObjectBoxService {
  Future<Store?> getStore();
  void closeStore();
  Future<void> addItem<T>(T entity);
  Future<List<T>> getAllItems<T>();
  Future<void> deleteItem<T>(int id);
  Future<void> updateItem<T>(T entity);
}

class ObjectBoxImpl implements ObjectBoxService {
  static Store? _store;

  @override
  Future<Store?> getStore() async {
    if (_store == null) {
      _store = await openStore();
    }
    return _store;
  }

  @override
  void closeStore() {
    _store?.close();
    _store = null;
  }

  @override
  Future<void> addItem<T>(T entity) async {
    await getStore();
    final box = _store!.box<T>();
    box.put(entity);
  }

  @override
  Future<List<T>> getAllItems<T>() async {
    await getStore();
    final box = _store!.box<T>();
    return box.getAll();
  }

  @override
  Future<void> updateItem<T>(T entity) async {
    await getStore();
    final box = _store!.box<T>();
    final id = (entity as dynamic).id;
    if (!box.contains(id)) {
      throw Exception("Entity with ID $id does not exist.");
    }
    box.put(entity);
  }

  @override
  Future<void> deleteItem<T>(int id) async {
    await getStore();
    final box = _store!.box<T>();
    box.remove(id);
  }
}
