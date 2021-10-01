import 'package:questt/helper/string.dart';

final Uri getVerifyUsersMobile = Uri.parse(baseUrl + 'login');
final Uri getSignUp = Uri.parse(baseUrl + 'teacher/signup');
final Uri getVerifyOtpApi =
    Uri.parse(baseUrl + 'verify-otp?includes=preference');
final Uri getSubjectApi =
    Uri.parse(baseUrl + 'teacher/subject?includes=chapters');
final Uri getLogoutApi =
    Uri.parse(baseUrl + 'logout');

Uri getChapterApi(String id) {
  return Uri.parse(baseUrl + 'teacher/chapter?subjects' + '=' + id);
}
