import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _auth;
  AuthCubit(this._auth) : super(Unauthenticated());

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());
    try {
      User? user = await _auth.register(
        email: email,
        password: password,
      );
      if (user != null) {
        await _auth.updateDisplayName(name);
        emit(Authenticated(userName: name));
      } else {
        emit(AuthError(message: "User registration failed"));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      User? user = await _auth.login(
        email: email,
        password: password,
      );
      if (user != null) {
        emit(Authenticated(userName: user.email ?? "User"));
      } else {
        emit(AuthError(message: "User login failed"));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _auth.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
