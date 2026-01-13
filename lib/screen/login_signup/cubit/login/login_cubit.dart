import 'package:bloc/bloc.dart';
import 'package:content_managing_app/services/firebase_funtions/firebase_auth_funtions.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> logInButtonPressed(String email, String password) async{
    emit(LogInLoadingState());
    try {
      await FirebaseAuthFunction.instance.loginWithEmail(email: email, password: password);
      emit(LogedInState());
    } catch (e) {
      emit(LogInErrorState(e.toString()));
    }
  }
}
