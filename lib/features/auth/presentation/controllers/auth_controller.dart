import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../domain/models/auth_user.dart';

enum AuthStatus {
  initial,
  sendingOtp,
  otpSent,
  verifying,
  authenticated,
  error,
}

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.rollNumber = '2501640100567',
    this.email = 'aarav.sharma@gmail.com',
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final String rollNumber;
  final String email;
  final AuthUser? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    String? rollNumber,
    String? email,
    AuthUser? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      rollNumber: rollNumber ?? this.rollNumber,
      email: email ?? this.email,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  void updateCredentials({String? rollNumber, String? email}) {
    state = state.copyWith(
      rollNumber: rollNumber,
      email: email,
      status: AuthStatus.initial,
      errorMessage: null,
    );
  }

  Future<bool> sendOtp({required String rollNumber, required String email}) async {
    state = state.copyWith(
      status: AuthStatus.sendingOtp,
      rollNumber: rollNumber,
      email: email,
      errorMessage: null,
    );

    try {
      await _repository.sendOtp(rollNumber: rollNumber, email: email);
      state = state.copyWith(status: AuthStatus.otpSent);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceFirst('FormatException: ', ''),
      );
      return false;
    }
  }

  Future<bool> verifyOtp({required String otp}) async {
    state = state.copyWith(
      status: AuthStatus.verifying,
      errorMessage: null,
    );

    try {
      final user = await _repository.verifyOtp(
        rollNumber: state.rollNumber,
        email: state.email,
        otp: otp,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceFirst('FormatException: ', ''),
      );
      return false;
    }
  }

  void reset() {
    state = const AuthState();
  }
}
