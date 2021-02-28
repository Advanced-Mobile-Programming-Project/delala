import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labjobfeature/house/bloc/bloc.dart';
import 'package:labjobfeature/house/house.dart';

class HouseBloc extends Bloc<HouseEvent, HouseState> {
  final HouseRepository houseRepository;

  HouseBloc({@required this.houseRepository})
      : assert(houseRepository != null),
        super(HouseLoading());

  @override
  Stream<HouseState> mapEventToState(HouseEvent event) async* {

    if (event is HouseLoad) {
      yield HouseLoading();
      try {
        final houses = await houseRepository.getHouses();
        yield HousesLoadSuccess(houses);
      } catch (_) {
        yield HouseOperationFailure();
      }
    }

    if (event is HouseCreate) {
      try {
        await houseRepository.createHouse(event.house);
        final houses = await houseRepository.getHouses();
        yield HousesLoadSuccess(houses);
      } catch (err) {
        print(err);
        yield HouseOperationFailure();
      }
    }

    if(event is HouseUpdate){
      try {
        await houseRepository.updateHouse(event.house);
        final houses = await houseRepository.getHouses();
        yield HousesLoadSuccess(houses);
      } catch (err) {
        print(err);
        yield HouseOperationFailure();
      }
    }

    if(event is HouseDelete){
      try {
        await houseRepository.deleteHouse(event.house.id);
        final houses = await houseRepository.getHouses();
        yield HousesLoadSuccess(houses);
      } catch (_) {
        yield HouseOperationFailure();
      }
    }
  }
}
