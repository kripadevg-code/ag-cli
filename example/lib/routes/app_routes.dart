/// All route path constants live here.
abstract class AppRoutes {
  static const initial = _Routes.home;
  static const home = _Routes.home;
  static const login = _Routes.login;

  // TODO: add routes here (ag module generates stubs in ROUTE_TODO.md)
  static const authLogin = _Routes.authLogin;
  static const profile = _Routes.profile;
  static const settings = _Routes.settings;
  static const productsDetails = _Routes.productsDetails;
}

abstract class _Routes {
  static const home = '/home';
  static const login = '/login';
  static const authLogin = '/auth_login';
  static const profile = '/profile';
  static const settings = '/settings';
  static const productsDetails = '/products_details';
}
