import 'package:meta/meta.dart';
import 'package:labjobfeature/house/house.dart';

class HouseRepository{
  final HouseDataProvider dataProvider;

  HouseRepository({@required this.dataProvider}):assert(dataProvider != null);

  Future<House> createHouse(House house) async {
    print(await dataProvider.createHouse(house));
    return await dataProvider.createHouse(house);
  }

  Future<List<House>> getHouses() async {
    return await dataProvider.getHouses();
  }

  Future<void> updateHouse(House house) async{
    return await dataProvider.updateHouse(house);
  }

  Future<void> deleteHouse(String id) async{
    return await dataProvider.deleteHouse(id);
  }

}