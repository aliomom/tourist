import 'package:flutter/material.dart';
import 'package:tourists/generated/l10n.dart';
import 'package:tourists/module_chat/chat_routes.dart';
import 'package:tourists/module_orders/model/order/order_model.dart';
import 'package:tourists/utils/time/time_formatter.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderModel orderModel;
  final Function(OrderModel) onAcceptOrder;
  final Function(OrderModel) onAcceptAvailableOrder;
  final Function(OrderModel) onPayOrder;

  BuildContext context;

  OrderItemWidget(this.orderModel,
      {this.onAcceptOrder, this.onAcceptAvailableOrder, this.onPayOrder});

  @override
  Widget build(BuildContext context) {
    this.context = context;

    // This will be the children of the flex
    List<Widget> widgetLayout = [];

    // If there is guide assigned, Show Multiple Choices
    if (orderModel.guidUserID != null) {
      if (orderModel.status == 'pending')
        widgetLayout.add(_getPendingOrder(orderModel));
      else if (orderModel.status == 'onGoing') {
        // There is a chat here
        widgetLayout.add(_getOnGoingOrder(orderModel));
      } else if (orderModel.status == 'finished') {
        widgetLayout.add(_getFinishedOrder(orderModel));
      }
    } else
      widgetLayout.add(_getAvailableOrder(orderModel));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black45)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.vertical,
            children: widgetLayout,
          ),
        ),
      ),
    );
  }

  Widget _getAvailableOrder(OrderModel orderModel) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(),
                child: Image.asset("resources/images/logo.jpg"),
              ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).request_for_guide,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 8,
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(orderModel.city),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("|"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(orderModel.language),
                        )
                      ],
                    ),
                    Container(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
            // Order date
            Flexible(
                child: Text(TimeFormatter.getDartDate(orderModel.date)
                    .toString()
                    .substring(5, 10)))
          ],
        ),
        RaisedButton(
          onPressed: () {
            onAcceptAvailableOrder(orderModel);
          },
          child: Text(S.of(context).accept_order),
        )
      ],
    );
  }

  Widget _getPendingOrder(OrderModel orderModel) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                  height: 72,
                  width: 72,
                  alignment: Alignment.center,
//                  decoration: BoxDecoration(color: Colors.greenAccent),
                  child: Image.asset(
                    'resources/images/logo.jpg',
                    fit: BoxFit.contain,
                  )),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      orderModel.touristUserID
                          .substring(orderModel.touristUserID.length - 4),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 8,
                    ),
                    Text(orderModel.city + ' | ' + orderModel.language),
                    Container(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
            // Order date
            Flexible(
                child: Text(TimeFormatter.getDartDate(orderModel.date)
                    .toString()
                    .substring(5, 10)))
          ],
        ),
        RaisedButton(
          onPressed: () {
            this.onAcceptOrder(orderModel);
          },
          child: Text(S.of(context).accept_order),
        )
      ],
    );
  }

  Widget _getOnGoingOrder(OrderModel orderModel) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                  height: 72,
                  width: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.greenAccent),
                  child: Image.asset(
                    'resources/images/logo.jpg',
                    fit: BoxFit.contain,
                  )),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      orderModel.touristUserID
                          .substring(orderModel.touristUserID.length - 4),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 8,
                    ),
                    Text(orderModel.city + ' | ' + orderModel.language),
                    Container(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
            // Order date
            Flexible(
                child: Text(TimeFormatter.getDartDate(orderModel.date)
                    .toString()
                    .substring(5, 10)))
          ],
        ),
        RaisedButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(ChatRoutes.chatRoute, arguments: orderModel.roomID);
          },
        )
      ],
    );
  }

  Widget _getFinishedOrder(OrderModel orderModel) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
              height: 72,
              width: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.greenAccent),
              child: Image.asset(
                'resources/images/logo.jpg',
                fit: BoxFit.contain,
              )),
        ),
        Flexible(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  orderModel.touristUserID
                      .substring(orderModel.touristUserID.length - 4),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 8,
                ),
                Text(orderModel.city + ' | ' + orderModel.language),
                Container(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        // Order date
        Flexible(
            flex: 1,
            child: Text(TimeFormatter.getDartDate(orderModel.date)
                .toString()
                .substring(5, 10)))
      ],
    );
  }
}
