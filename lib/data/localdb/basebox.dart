import 'package:hive/hive.dart';

abstract class BaseBox<T>{

   Future<Box<T>> getBoxes();

   Future<void> initHiveAdapters();

   Future<List<T>> getAllData() async => await getBoxes().then((box) => box.values.toList().cast<T>());

   Future<void> add(T model) async {
     await getBoxes().then((box) async {
        await box.add(model);
     });
   }

   Future<void> update(T models)async {
     try {
       await getBoxes();
       if(models is HiveObject){
              await models.save();
            }
     } catch (e) {
       print(e);
     }
   }

   Future<void> delete(T models)async {
     try {
       await getBoxes();
       if(models is HiveObject){
              await models.delete();
            }
     } catch (e) {
       print(e);
     }
   }

   Future<void> deleteAll() async => await getBoxes().then((box) async => await box.clear());
}