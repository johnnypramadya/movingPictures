import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/home/series/series_interface.dart';
import '../../../../domain/home/shared_classes/cast/cast.dart';
import '../../../../domain/home/shared_classes/cast/cast_failure.dart';

part 'casts_bloc.freezed.dart';
part 'casts_event.dart';
part 'casts_state.dart';

@injectable
class CastsBloc extends Bloc<CastsEvent, CastsState> {
  final SeriesInterface seriesInterface;
  CastsBloc(this.seriesInterface) : super(const _Initial());

  @override
  Stream<CastsState> mapEventToState(
    CastsEvent event,
  ) async* {
    yield* event.map(getCastCalled: (e) async* {
      yield const CastsState.loading();
      final failureOrSeries = await seriesInterface.getCast(e.serieId);

      yield failureOrSeries.fold(
        (f) => CastsState.loadFailure(f),
        (casts) => CastsState.loadSuccess(casts),
      );
    });
  }
}
