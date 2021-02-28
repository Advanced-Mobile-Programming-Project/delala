import 'package:equatable/equatable.dart';
import 'package:labjobfeature/main.dart';
import 'package:labjobfeature/house/house.dart';

class HouseState extends Equatable {
  const HouseState();

  @override
  List<Object> get props => [];
}

class HouseLoading extends HouseState {}

class HousesLoadSuccess extends HouseState {
  final List<House> houses;

  const HousesLoadSuccess([this.houses = const []]);

  @override
  List<Object> get props => [houses];
}

class HouseOperationFailure extends HouseState {}
