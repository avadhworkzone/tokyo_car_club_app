abstract class ExploreEvent {}

class LoadExploreData extends ExploreEvent {}

class SelectCarBrand extends ExploreEvent {
  final String brand;
  SelectCarBrand(this.brand);
}

class SelectCarType extends ExploreEvent {
  final String type;
  SelectCarType(this.type);
}

class SelectLocation extends ExploreEvent {
  final String location;
  SelectLocation(this.location);
}