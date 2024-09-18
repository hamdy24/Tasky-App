import 'package:equatable/equatable.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoadingProfile extends AuthenticationState {}

class AuthenticationLoadedProfile extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {}
