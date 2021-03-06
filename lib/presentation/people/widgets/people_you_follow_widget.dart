import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/people/people_bloc.dart';
import '../../../domain/people/people.dart';
import '../../../injection.dart';
import '../../core/app_colors.dart';
import '../../core/component_widgets/movie_loading_wigdet.dart';
import '../../core/component_widgets/primary_button_widget.dart';

class PeopleYouFollowWidget extends StatelessWidget {
  const PeopleYouFollowWidget({
    Key key,
    @required this.state,
  }) : super(key: key);

  final dynamic state;

  @override
  Widget build(BuildContext context) {
    final appTextTheme = Theme.of(context).textTheme;
    final peopleLength = state.people.length as int;

    int bigI;

    for (var i = 0; i < peopleLength; i++) {
      bigI = i;
    }

    return BlocProvider(
      create: (context) => getIt<PeopleBloc>()
        ..add(PeopleEvent.watchFullPeople(state.people[bigI].email as String)),
      child: BlocBuilder<PeopleBloc, PeopleState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return state.maybeMap(
            watchFullPeopleSuccess: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("People you follow",
                        style: appTextTheme.headline5),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.people.length,
                        itemBuilder: (context, i) {
                          final Person person = state.people[i];
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppColors.gray,
                            ),
                            width: double.infinity,
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 60.0,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.network(
                                        person.photoURL,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        person.name,
                                        style: appTextTheme.headline6,
                                      ),
                                      PrimaryButton(
                                        appTextTheme: appTextTheme,
                                        name: "Unfollow",
                                        color: AppColors.red,
                                        onpressed: () async => context
                                            .read<PeopleBloc>()
                                            .add(PeopleEvent.unfollowed(
                                                person.email)),
                                        isFullButton: false,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              );
            },
            loading: (_) => const MovieLoadingWidget(),
            orElse: () => null,
          );
        },
      ),
    );
  }
}
