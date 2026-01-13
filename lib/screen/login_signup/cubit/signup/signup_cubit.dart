import 'package:bloc/bloc.dart';
import 'package:content_managing_app/services/firebase_funtions/firebase_auth_funtions.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  Future<void> signUpButtonPressed(String name, String email, String password)async{
    emit(SignupLoadingState());
    try {
      await FirebaseAuthFunction.instance.signUpWithEmail(email: email, password: password, name: name);
      emit(SignedInState());
    } catch (e) {
      emit(SignupErrorState(e.toString()));
    }
  }
}
