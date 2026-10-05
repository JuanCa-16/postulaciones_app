class UserLogin {
  final String correo;
  final String clave;

  const UserLogin({required this.correo, required this.clave});

  Map<String, dynamic> toJson() {
    return {'correo': correo, 'clave': clave};
  }
}

class UserLoginResponse {
  final String token;

  const UserLoginResponse({required this.token});

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(token: json['token']);
  }
}
