class ApiRoute {
  static const String BASE_URL = 'https://casier-api.vercel.app/api';

  // Auth
  static const String LOGIN = '/auth/login';
  static const String REGISTER = '/auth/register';

  // Products
  static const String PRODUCTS = '/products';

  // Cart
  static const String CART = '/cart';
  static const String CART_ADD = '/cart/add';
  static String cartRemove(String productId) => '/cart/remove/$productId';
  static const String CART_CLEAR = '/cart/clear';

  // Transactions
  static const String TRANSACTIONS = '/transactions';
  static const String TRANSACTIONS_NOTIFICATION = '/transactions/notification';
  static String transactionDetail(String id) => '/transactions/$id';

  // Discounts
  static const String DISCOUNTS = '/discounts';
  static String discountCheck(String code) => '/discounts/check/$code';

  // Taxes
  static const String TAXES = '/taxes';

  // Categories
  static const String CATEGORIES = '/categories';
}