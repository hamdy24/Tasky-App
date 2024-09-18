

class AppTranslations{

  static String tr(String key){
    String str;
    String lang = '';

    if('ar' == lang){
      str = arabic[key]!;
    }else{
      str = english[key]!;
    }


    return str;
  }

  static Map<String,String> arabic = {
    "appTitle": "TechCart",
    "filterBTN": "تصفية",
    "productsTab": "المنتجات",
    "brandsTab": "الاصناف",
    "cartTab": "السلة",
    "storesTab": "المتاجر",
    "accountPage": "الحساب",
    "langChangeTxt": "اللغة المستخدمة",
    "modeChangeTxt": "وضع العرض",
    "showLocationTxt": "إظهار الموقع",
    "loginTxt": "تسجيل الدخول",
    "loginBTN": "التسجيل",
    "buyBTN": "إشتر الآن",
    "viewOrdersBTN": "عرض الطلبات",
    "addCartBTN": "إضافة للسلة",
    "addFavBTN": "إضافة للمفضلة",
    "searchGPS": "البحث",
    'resetPass':'هل نسيت كلمة المرور',
    'signUp':'إنشاء حساب',
    'emailField':'رقم الهاتف لأو الإيميل',
    'passField':'كلمة السر',
    'lang':'ألعربية',
    'adminBadge' : 'أدمن',
    'inProductCart_AddBTN' : "أضف الي السلة",
    'inProductCart_RemoveBTN' : "إزالة من السلة"
  };
  static Map<String,String> english = {
    "appTitle": "TechCart",
    "filterBTN": "Filters",
    "productsTab": "Products",
    "brandsTab": "Brands",
    "cartTab": "Cart",
    "storesTab": "Stores",
    "accountPage": "Account",
    "langChangeTxt": "App Language",
    "modeChangeTxt": "App Mode",
    "showLocationTxt": "Show Location",
    "loginTxt": "Login Now",
    "loginBTN": "Login",
    "buyBTN": "Buy Now",
    "viewOrdersBTN": "Orders",
    "addCartBTN": "Add to Cart",
    "addFavBTN": "Add to Favourite",
    "searchGPS": "Search",
    'resetPass':'Reset Password',
    'signUp':'Sign Up',
    'emailField':'Email or Phon',
    'passField':'Password',
    'lang':'En',
    'adminBadge' : 'Admin',
    'inProductCart_AddBTN' : "Add to Cart",
    'inProductCart_RemoveBTN' : "Remove from Cart"
  };
}