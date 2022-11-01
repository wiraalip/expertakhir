import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_tv_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_tv_watchlist_series.dart';
import 'package:ditonton/domain/usecases/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_event.dart';
part 'tv_state.dart';

class NowPlayingSeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetNowPlayingSeries _getNowPlayingSeries;

  NowPlayingSeriesBloc(this._getNowPlayingSeries) : super(SeriesEmpty()) {
    on<FetchNowPlayingSeries>((event, emit) async {
      emit(SeriesLoading());
      final result = await _getNowPlayingSeries.execute();

      result.fold((failure) {
        emit(SeriesHasError(failure.message));
      }, (tvData) {
        emit(SeriesHasData(tvData));
      });
    });
  }
}

class PopularSeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetPopularSeries _getPopularSeries;

  PopularSeriesBloc(this._getPopularSeries) : super(SeriesEmpty()) {
    on<FetchPopularSeries>((event, emit) async {
      emit(SeriesLoading());
      final result = await _getPopularSeries.execute();

      result.fold((failure) {
        emit(SeriesHasError(failure.message));
      }, (tvData) {
        emit(SeriesHasData(tvData));
      });
    });
  }
}

class TopRatedSeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetTopRatedSeries _getTopRatedSeries;

  TopRatedSeriesBloc(this._getTopRatedSeries) : super(SeriesEmpty()) {
    on<FetchTopRatedSeries>((event, emit) async {
      emit(SeriesLoading());
      final result = await _getTopRatedSeries.execute();

      result.fold((failure) {
        emit(SeriesHasError(failure.message));
      }, (tvData) {
        emit(SeriesHasData(tvData));
      });
    });
  }
}

class SeriesDetailBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetSeriesDetail _getSeriesDetail;

  SeriesDetailBloc(this._getSeriesDetail) : super(SeriesEmpty()) {
    on<FetchSeriesDetail>((event, emit) async {
      final id = event.id;
      emit(SeriesLoading());
      final result = await _getSeriesDetail.execute(id);

      result.fold(
        (failure) {
          emit(SeriesHasError(failure.message));
        },
        (tv) {
          emit(SeriesDetailHasData(tv));
        },
      );
    });
  }
}

class RecommendationsSeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetSeriesRecommendations _getSeriesRecommendations;

  RecommendationsSeriesBloc(this._getSeriesRecommendations)
      : super(SeriesEmpty()) {
    on<FetchSeriesRecommendations>((event, emit) async {
      final int id = event.id;

      emit(SeriesLoading());
      final result = await _getSeriesRecommendations.execute(id);

      result.fold((failure) {
        emit(SeriesHasError(failure.message));
      }, (tvData) {
        emit(SeriesHasData(tvData));
      });
    });
  }
}

class WatchlistSeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final GetWatchlistSeries getWatchlistSeries;
  final GetWatchListStatusSeries getWatchListStatusSeries;
  final SaveWatchlistSeries saveWatchlistSeries;
  final RemoveWatchlistSeries removeWatchlistSeries;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistSeriesBloc(this.getWatchlistSeries, this.getWatchListStatusSeries,
      this.saveWatchlistSeries, this.removeWatchlistSeries)
      : super(SeriesEmpty()) {
    on<FetchWatchlistSeries>((event, emit) async {
      emit(SeriesLoading());
      final result = await getWatchlistSeries.execute();

      result.fold((failure) {
        emit(SeriesHasError(failure.message));
      }, (tvData) {
        emit(WatchlistSeriesHasData(tvData));
      });
    });
    on<AddWatchlistSeries>((event, emit) async {
      final tv = event.tv;

      emit(SeriesLoading());
      final result = await saveWatchlistSeries.execute(tv);

      result.fold((failure) {
        emit(SeriesHasError(failure.message));
      }, (successMessage) {
        emit(WatchlistSeriesMessage(successMessage));
      });
    });
    on<LoadWatchlistSeriesStatus>((event, emit) async {
      final id = event.id;

      emit(SeriesLoading());
      final result = await getWatchListStatusSeries.execute(id);

      emit(LoadSeriesWatchlistData(result));
    });
    on<RemoveWatchlistSerieses>((event, emit) async {
      final tv = event.tv;

      emit(SeriesLoading());
      final result = await removeWatchlistSeries.execute(tv);

      result.fold((failure) {
        emit(SeriesHasError(failure.message));
      }, (successMessage) {
        emit(WatchlistSeriesMessage(successMessage));
      });
    });
  }
}
