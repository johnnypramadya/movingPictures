import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/app_user.dart';
import '../../../domain/auth/app_user_failure.dart';
import '../../../domain/auth/auth_repository_interface.dart';

part 'user_profile_bloc.freezed.dart';
part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final AuthInterface _authInterface;

  StreamSubscription<Either<AppUserFailure, AppUser>>
      _appUserStreamSubscription;

  UserProfileBloc(this._authInterface) : super(const _Initial());

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    event.map(profileRecieved: (e) async* {
      yield const UserProfileState.loadingProgress();

      _appUserStreamSubscription = _authInterface.watchUserProfile().listen(
            (failureOrProfile) => add(
              UserProfileEvent.profileRecieved(failureOrProfile),
            ),
          );

      yield e.failureOrProfile.fold(
        (f) => UserProfileState.loadFailure(f),
        (profile) => UserProfileState.loadSuccess(profile),
      );
    });
  }

  @override
  Future<void> close() async {
    await _appUserStreamSubscription.cancel();
    return super.close();
  }
}
