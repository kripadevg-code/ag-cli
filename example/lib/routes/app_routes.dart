/// All route path constants live here.
abstract class AppRoutes {
  static const initial = _Routes.home;
  static const home = _Routes.home;

  // TODO: add routes here (ag module generates stubs in ROUTE_TODO.md)
  static const orders = _Routes.orders;
}

abstract class _Routes {
  static const home = '/home';
  static const orders = '/orders';
}
