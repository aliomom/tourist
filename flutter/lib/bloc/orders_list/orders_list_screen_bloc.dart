import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:inject/inject.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tourists/services/orders/orders_service.dart';

@provide
class OrdersListScreenBloc {
  static const int STATUS_CODE_INIT = 621;
  static const int STATUS_CODE_LOAD_ERROR = 631;
  static const int STATUS_CODE_LOAD_SUCCESS = 641;

  final OrdersService _ordersService;
  OrdersListScreenBloc(this._ordersService);

  PublishSubject<Pair<int, dynamic>> _orderListSubject = new PublishSubject();
  Stream<Pair<int, dynamic>> get ordersStream => _orderListSubject.stream;

  getOrdersList() {
    _ordersService.getOrders().then( (ordersList) {
      if (ordersList == null) {
        _orderListSubject.add(Pair(STATUS_CODE_LOAD_ERROR, null));
      } else {
        _orderListSubject.add(Pair(STATUS_CODE_LOAD_SUCCESS, ordersList));
      }
    });
  }

}