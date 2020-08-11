import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inject/inject.dart';
import 'package:tourists/module_authorization/authprization_module.dart';
import 'package:tourists/module_forms/forms_module.dart';
import 'package:tourists/module_guide/guide_list_module.dart';
import 'package:tourists/module_home/home_module.dart';
import 'package:tourists/module_orders/model/order/order_model.dart';

import 'di/components/app.component.dart';
import 'generated/l10n.dart';
import 'module_chat/chat_module.dart';

typedef Provider<T> = T Function();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    final container = await AppComponent.create();
    runApp(container.app);
  });
}

@provide
class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  final AuthorizationModule _authorizationModule;
  final HomeModule _homeModule;
  final ChatModule _chatModule;
  final FormsModule _formsModule;
  final GuideListModule _guideListModule;
  final OrderModel _orderModel;

  MyApp(this._authorizationModule, this._homeModule, this._chatModule,
      this._guideListModule, this._orderModel, this._formsModule);

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> fullRoutesList = Map();

    fullRoutesList.addAll(_authorizationModule.getRoutes());
    fullRoutesList.addAll(_homeModule.getRoutes());
    fullRoutesList.addAll(_chatModule.getRoutes());
    fullRoutesList.addAll(_formsModule.getRoutes());
    fullRoutesList.addAll(_guideListModule.getRoutes());
    fullRoutesList.addAll(_orderModel.getRoutes());

    return MaterialApp(
        navigatorObservers: <NavigatorObserver>[
          observer
        ],
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
            primaryColor: Colors.greenAccent, accentColor: Colors.greenAccent),
        supportedLocales: S.delegate.supportedLocales,
        title: 'Soyah',
        routes: fullRoutesList,
        initialRoute: UserRoutes.home);
  }
}
