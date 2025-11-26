import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import 'models/user_model.dart';

class AuthRepository {
  final api = ApiClient();

  Future<UserModel> signIn(String email, String password) async {
    final res = await api.post("/auth/login", body: {
      "email": email,
      "password": password,
    });

    return UserModel.fromJson(res.data["user"]);
  }

  Future<UserModel> signUp(String name, String email, String password) async {
    final res = await api.post("/auth/register", body: {
      "name": name,
      "email": email,
      "password": password,
    });

    return UserModel.fromJson(res.data["user"]);
  }
}
