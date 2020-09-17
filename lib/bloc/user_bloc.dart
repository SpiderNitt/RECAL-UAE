import 'package:duration/duration.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iosrecal/models/User.dart';
import 'package:iosrecal/repositories/user_repository.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({@required this.userRepository}) : assert(userRepository != null), super(null);

  @override
  UserState get initialState => UserEmpty();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async*{
    // TODO: implement mapEventToState
    if(event is FetchUserProfile) {
       yield UserLoading();
      try {
        final User user = await userRepository.fetchUserProfile(event.props);
        yield UserLoaded(user: user);
      }catch (_) {
        yield UserError();
      }
    }
  }

}

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class FetchUserProfile extends UserEvent {
  const FetchUserProfile();

  @override
  List<Object> get props => [];
}

class UserState extends Equatable {
  const UserState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}
class UserEmpty extends UserState {

}
class UserLoading extends UserState {

}
class UserLoaded extends UserState {
  final User user;
  const UserLoaded({@required this.user}) : assert(user != null);
  @override
  // TODO: implement props
  List<Object> get props => [user];
}
class UserError extends UserState {

}