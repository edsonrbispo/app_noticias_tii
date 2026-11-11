import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginServices {
  static const String baseUrl = "http://10.0.2.2:8000/api";

  Future<String> login(String email, String password) async {
    try {
      final resposta = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        final token = dados['token'];
        final nome = dados['usuario']['nome'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('nome', nome);

        return nome;
      }

      if (resposta.statusCode == 401 || resposta.statusCode == 422) {
        throw 'E-mail ou Senha Inválidos';
      }
    } catch (e) {
      throw Exception('$e');
    }

    return '';
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('nome');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getNome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nome');
  }
}
