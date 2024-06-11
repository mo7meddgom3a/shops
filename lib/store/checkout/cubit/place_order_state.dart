  part of 'place_order_cubit.dart';


  enum PlaceOrderStatus { initial, loading, loaded, error }

  class PlaceOrderState extends Equatable {
     List<ProductModel> products;
    final String mapLocation;
    final PlaceOrderStatus state;
    final String? errorMessage;
    final LatLng currentLocation;
    final bool locationFetched;
    final String currentLocationName;

     PlaceOrderState({
      this.currentLocation = const LatLng(24.774265, 46.738586),
      this.state = PlaceOrderStatus.initial,
      this.errorMessage,
      this.locationFetched = false,
      this.currentLocationName = "",
      this.mapLocation = "",
      this.products = const [],
    });

    PlaceOrderState copyWith({
      PlaceOrderStatus? state,
      String? errorMessage,
      LatLng? currentLocation,
      bool? locationFetched,
      String? currentLocationName,
      String? mapLocation,
    }) {
      return PlaceOrderState(
        currentLocation: currentLocation ?? this.currentLocation,
        state: state ?? this.state,
        errorMessage: errorMessage ?? this.errorMessage,
        locationFetched: locationFetched ?? this.locationFetched,
        currentLocationName: currentLocationName ?? this.currentLocationName,
        mapLocation: mapLocation ?? this.mapLocation,
      );
    }

    @override
    List<Object?> get props => [
      state,
      errorMessage,
      currentLocation,
      locationFetched,
      currentLocationName,
      mapLocation
    ];
  }
