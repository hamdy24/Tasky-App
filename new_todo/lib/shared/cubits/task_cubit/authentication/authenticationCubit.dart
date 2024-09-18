import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/user.dart';
import '../../../../repositories/authentication_repository.dart';
import '../../../network/local/cache_helper.dart';
import 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  static AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  static AuthenticationCubit get(context) => BlocProvider.of(context);
  AuthenticationCubit() : super(AuthenticationInitial());

  static bool isLoginPressed = false;
  static bool isPassVisible = false;
  static int LoginState = 0; // 0 un-determined / 1 done / 2 failed
  static int SignUpState = 0; // 0 un-determined / 1 done / 2 failed
  static bool isProfileEmpty = true;

  static String accessToken = '';
  static String refreshToken = '';
  static String userID = '';
  static String userName = '';
  static String userPhone = '';
  static String userPassword = '';
  static String userLevel = '';
  static int userYears = 0;
  static String userAddress = '';
  static bool isUserLogged = false;

  void passVisibility(bool state){
    emit(AuthenticationLoading());
    isPassVisible = state;
    emit(AuthenticationAuthenticated());
  }

  void refreshExpiredToken() async {
    emit(AuthenticationLoading());
    try {
       await authenticationRepository.refreshOldToken();
       CacheHelper.storeData(key: 'accessToken', value: AuthenticationCubit.accessToken);
       emit(AuthenticationAuthenticated());
    } on Exception catch (e) {
      print('Token Refresh Exception<<<<<<<<<>>>>>>>>>>>>>>>>>>>');
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> checkAuth() async {
    emit(AuthenticationLoading());
    isUserLogged = await authenticationRepository.isSignedIn();
    if (isUserLogged) {
      emit(AuthenticationAuthenticated());
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<bool> loginWith({required String phone,required String password}) async {
    emit(AuthenticationLoading());
    isLoginPressed = true;
    try {
      await authenticationRepository.signIn(phone, password);
      LoginState = 1 ;// success
    } on Exception catch (e) {
      LoginState = 2; // failed
    }
    emit(AuthenticationAuthenticated());
    isLoginPressed = false;
    return true;
  }

  Future<bool> signUpWith({required User user}) async {
    emit(AuthenticationLoading());
    isLoginPressed = true;
    try {
      await authenticationRepository.signUp(user);
      SignUpState = 1 ;// success
    } on Exception catch (e) {
      SignUpState = 2; // failed
    }
    emit(AuthenticationAuthenticated());
    isLoginPressed = false;
    return true;
  }

  Future<void> logout() async {
    emit(AuthenticationLoading());
    await authenticationRepository.signOut(refreshToken);///////////////////////////
    isUserLogged = false;
    CacheHelper.storeData(key: 'accessToken', value: '');
    CacheHelper.storeData(key: 'refreshToken', value: '');
    emit(AuthenticationUnauthenticated());
  }
  void getUserData() async {
    emit(AuthenticationLoadingProfile());
    try {
      await authenticationRepository.getProfile();
      isProfileEmpty = false;
      emit(AuthenticationLoadedProfile());

    } on Exception catch (e) {
      print(e);
      emit(AuthenticationError());

    }
///////////////////////////
  }
}
