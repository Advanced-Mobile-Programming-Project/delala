import 'package:equatable/equatable.dart';
import 'package:labjobfeature/house/house.dart';

abstract class HouseEvent extends Equatable{
  const HouseEvent();
}

class HouseLoad extends HouseEvent{
  const HouseLoad();

  @override
  List<Object> get props => [];

}

class HouseCreate extends HouseEvent{
  final House house;

  const HouseCreate(this.house);

  @override
  List<Object> get props => [house];

  @override
  String toString() => 'house Created {house: $house}';
}

class HouseUpdate extends HouseEvent{
  final House house;

  const HouseUpdate(this.house);

  @override
  List<Object> get props => [house];

  @override
  String toString() => 'house Updated {house: $house}';

}

class HouseDelete extends HouseEvent{
   final House house;

   const HouseDelete(this.house);

   @override
   List<Object> get props => [house];

   @override
   String toString() => 'house Deleted {house: $house}';
}


