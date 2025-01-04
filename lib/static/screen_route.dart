enum ScreenRoute {
  login('login'),
  register('register'),
  home('home'),
  addProduct('add_product'),
  detailProduct('detail_product'),
  detailTransaction('detail_ransaction');

  final String name;
  const ScreenRoute(this.name);
}
