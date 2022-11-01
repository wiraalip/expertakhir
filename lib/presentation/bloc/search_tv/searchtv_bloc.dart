import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'searchtv_state.dart';
part 'searchtv_event.dart';

class SearchTVBloc extends Bloc<SearchTVEvent, SearchTVState> {
  final SearchSeries _searchSeries;

  SearchTVBloc(this._searchSeries) : super(SearchTVEmpty()) {
    on<OnQueryChange>((event, emit) async {
      final query = event.query;

      emit(SearchTVLoading());
      final result = await _searchSeries.execute(query);

      result.fold((failure) {
        emit(SearchTVError(failure.message));
      }, (data) {
        emit(SearchTVHasData(data));
      });
    });
  }
}
