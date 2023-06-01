class Validator {
  static const String _emailRule =
      r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$";
  static const String _passwordRule =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?~]).{9,}$';

  static String? emailValidator(String email) {
    if (email == "") {
      return "Email is Empty";
    }
    var isValid = RegExp(_emailRule).hasMatch(email);
    if (!isValid) {
      return "Email invalid";
    }
    return null;
  }

  static String passwordValidator(String pass) {
    if (pass == "") {
      return "Password is Empty";
    }
    if (pass.length < 8) {
      return "Password require minimum 8 characters";
    }
    var isValid = RegExp(_passwordRule).hasMatch(pass);
    if (!isValid) {
      return "Password invalid";
    }
    return "";
  }

  ///Bkav Nhungltk: validate mat khau
  /// Mat khau co do dai toi thieu la 8
  /// Chứa 3 trong 4 kiểu ký tự (a – z, A – Z, 0 – 9, !@#$%^&*)
  ///  Khong chua khoang trang
  static bool validateFormatPass(String pass) {
    RegExp regExp1 = RegExp(
        r"^(?=(.*\d))(?=.*[!@#$%^&*])(?=.*[a-z])(?=(.*[A-Z]))(?=(.*)).{8,}");
    RegExp regExp2 =
        RegExp(r"^(?=(.*\d))(?=.*[!@#$%^&*])(?=.*[a-z])(?=(.*)).{8,}");
    RegExp regExp3 =
        RegExp(r"^(?=(.*\d))(?=.*[!@#$%^&*])(?=.*[A-Z])(?=(.*)).{8,}");
    RegExp regExp4 =
        RegExp(r"^(?=(.*\d))(?=.*[a-z])(?=(.*[A-Z]))(?=(.*)).{8,}");
    RegExp regExp5 =
        RegExp(r"^(?=.*[!@#$%^&*])(?=.*[a-z])(?=(.*[A-Z]))(?=(.*)).{8,}");
    return (regExp1.hasMatch(pass) ||
            regExp2.hasMatch(pass) ||
            regExp3.hasMatch(pass) ||
            regExp4.hasMatch(pass) ||
            regExp5.hasMatch(pass)) &&
        !pass.contains(" ");
  }

  ///Bkav Nhungltk: validate mat khau
  /// mật khẩu co do dai toi thieu la 8
  /// Chứa chu thuong,chu hoa va so
  ///  Khong chua khoang trang
  static bool validateFormatPassWord(String pass) {
    RegExp regExp =
        RegExp(r"^(?=(.*\d))(?=.*[a-z])(?=(.*[A-Z]))(?=(.*)).{8,}");
    return regExp.hasMatch(pass) && !pass.contains(" ");
  }

  static bool validatePhone(String? phone) {
    RegExp regExp1 = RegExp(r'(?:0+([35789]))+(\d{8}$)');
    RegExp regExp2 = RegExp(r'^(?:[(][+]\d{1,3}[)])?\d{8,10}$');
    RegExp regExp3 = RegExp(r'^(?:[(]\d{1,3}[)])?\d{9,11}$');
    return (regExp1.hasMatch(phone!) ||
            regExp2.hasMatch(phone) ||
            regExp3.hasMatch(phone)) &&
        !phone.contains(" ");
  }

  ///Bkav HoangCV: validate Ho va ten
  ///chua chu thuong, chu hoa, so va chu tieng viet co dau
  ///chua khoang trang
  static bool validateFormatName(String name) {
    RegExp regExp1 = RegExp(
        r'^[a-zA-Z\d ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỂưạảấầẩẫậắằẳẵặẹẻẽềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+$');
    return regExp1.hasMatch(name);
  }

  ///Bkav HoangCV: validate sdt
  /// chua cac so tu 0->9 va co 10 ky tu
  static bool validateFormatPhone(String? phone) {
    RegExp regExp = RegExp(r'^(?:[+0]9)?\d{10}$');
    //Logger.loggerDebug("Bkav HoangCV: validateFormatPhone: ${regExp.hasMatch(phone!)}");
    return (regExp.hasMatch(phone!) && !phone.contains(" "));
  }

  ///Bkav HoangCV: validate email
  /// phai co dang bkav@mail.com
  static bool isEmail(String? em) {
    // String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    String p =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em!);
  }

  ///Bkav HoangCV: validate số tax - ma so thue
  /// chua 10 -> 14 ky tu gom
  static bool validatorTaxCode(String? taxCode) {
    String p = r'^(?:[[0-9]{10}[-])?[0-9]{3}$';
    String q = r'^(?:[[0-9]{10})$';
    RegExp regExp1 = RegExp(p);
    RegExp regExp2 = RegExp(q);
    return regExp1.hasMatch(taxCode!) || regExp2.hasMatch(taxCode);
  }

  ///Bkav HoangCV: validate otp code
  /// chua 6 ky tu tu 0->9
  static bool validatorOtp(String? taxCode) {
    String q = r'^(?:[[0-9]{6})$';
    RegExp regExp = RegExp(q);
    return regExp.hasMatch(taxCode!);
  }

  /// Bkav HanhNTHe: validate chieu dai cua chuoi string [text] theo [length]
  static bool validateLength({required String text, int length = 8}) {
    if (text.length < length) {
      return false;
    }
    return true;
  }
}
