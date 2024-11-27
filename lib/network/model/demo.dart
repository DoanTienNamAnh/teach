class LoginRequest {
  String? username;
  String? password;
  String? pin;

  LoginRequest({this.username, this.password, this.pin});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['pin'] = this.pin;
    return data;
  }
}

class LoginResponse {
  String? accessToken;
  String? refreshToken;

  LoginResponse({this.accessToken, this.refreshToken});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refreshToken'] = refreshToken;
    data['refreshToken'] = refreshToken;
    return data;
  }
}