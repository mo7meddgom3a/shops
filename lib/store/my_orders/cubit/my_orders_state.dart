part of 'my_orders_cubit.dart';

@immutable
class OrdersState extends Equatable{
  final List<OrderModel> orders;
  const OrdersState(this.orders);


  OrdersState copyWith({
    List<OrderModel>? orders,
  }) {
    return OrdersState(
      orders ?? this.orders,
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [orders];

}

class OrdersLoading extends OrdersState {
  const OrdersLoading(List<OrderModel> orders) : super(orders);
}

class OrdersLoaded extends OrdersState {
  @override
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders) : super(orders);
}

class OrdersError extends OrdersState {
  final String errorMessage;

  OrdersError(this.errorMessage) : super([]);
}

// final class OrdersInitial extends OrdersState {}

// final class OrdersLoading extends OrdersState {}

// final class OrdersLoaded extends OrdersState {
//   final List<OrderModel> orders;
//
//   OrdersLoaded({required this.orders});
// }

// final class OrdersError extends OrdersState {
//   final String error;
//
//   OrdersError({required this.error});
// }
//
// final class OrderStatusUpdated extends OrdersState {}
//
// final class OrderStatusUpdateError extends OrdersState {
//   final String error;
//
//   OrderStatusUpdateError({required this.error});
// }

//Order Model
