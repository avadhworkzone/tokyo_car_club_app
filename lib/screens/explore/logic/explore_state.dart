abstract class ExploreState {}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<String> carBrands;
  final List<Map<String, dynamic>> carTypes;
  final List<Map<String, String>> locations;
  final String? selectedBrand;
  final String? selectedType;
  final String? selectedLocation;

  ExploreLoaded({
    required this.carBrands,
    required this.carTypes,
    required this.locations,
    this.selectedBrand,
    this.selectedType,
    this.selectedLocation,
  });

  ExploreLoaded copyWith({
    List<String>? carBrands,
    List<Map<String, dynamic>>? carTypes,
    List<Map<String, String>>? locations,
    String? selectedBrand,
    String? selectedType,
    String? selectedLocation,
  }) {
    return ExploreLoaded(
      carBrands: carBrands ?? this.carBrands,
      carTypes: carTypes ?? this.carTypes,
      locations: locations ?? this.locations,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedType: selectedType ?? this.selectedType,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}