class UsersData {
  String status;
  String message;
  int code;

  @override
  String toString() {
    return 'UsersData{status: $status, message: $message, code: $code, data: $data}';
  }

  LogInData data;

  UsersData({this.status, this.message, this.code, this.data});

  UsersData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    code = json['code'];
    data = json['data'] != null ? new LogInData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class LogInData {
  String id;
  String token;
  String pin;

  @override
  String toString() {
    return 'LogInData{id: $id, token: $token, pin: $pin, user: $user}';
  }

  User user;

  LogInData({this.id, this.token, this.pin, this.user});

  LogInData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    pin = json['pin'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['pin'] = this.pin;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  Data data;

  @override
  String toString() {
    return 'User{data: $data}';
  }

  User({this.data});

  User.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String id;
  String token;
  String name;
  String gender;
  String mobile;
  String email;
  int tnc;
  String verifiedAt;
  String profileImageKey;
  String userType;
  String emailVerified;
  bool isGraduated;
  int notificationCount;

  Data(
      {this.id,
      this.token,
      this.name,
      this.gender,
      this.mobile,
      this.email,
      this.tnc,
      this.verifiedAt,
      this.profileImageKey,
      this.userType,
      this.emailVerified,
      this.isGraduated,
      this.notificationCount});

  @override
  String toString() {
    return 'Data{id: $id, token: $token, name: $name, gender: $gender, mobile: $mobile, email: $email, tnc: $tnc, verifiedAt: $verifiedAt, profileImageKey: $profileImageKey, userType: $userType, emailVerified: $emailVerified, isGraduated: $isGraduated, notificationCount: $notificationCount}';
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    name = json['name'];
    gender = json['gender'];
    mobile = json['mobile'];
    email = json['email'];
    tnc = json['tnc'];
    verifiedAt = json['verified_at'];
    profileImageKey = json['profile_image_key'];
    userType = json['user_type'];
    emailVerified = json['email_verified'];
    isGraduated = json['is_graduated'];
    notificationCount = json['notification_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['tnc'] = this.tnc;
    data['verified_at'] = this.verifiedAt;
    data['profile_image_key'] = this.profileImageKey;
    data['user_type'] = this.userType;
    data['email_verified'] = this.emailVerified;
    data['is_graduated'] = this.isGraduated;
    data['notification_count'] = this.notificationCount;
    return data;
  }
}
