import 'package:ditonton/presentation/bloc/tv/tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/nowplaying-series';

  @override
  _NowPlayingSeriesPageState createState() => _NowPlayingSeriesPageState();
}

class _NowPlayingSeriesPageState extends State<NowPlayingSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<NowPlayingSeriesBloc>().add(FetchNowPlayingSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingSeriesBloc, SeriesState>(
          builder: (context, state) {
            if (state is SeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = state.tv[index];
                  return SeriesCard(series);
                },
                itemCount: state.tv.length,
              );
            } else if (state is SeriesHasError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Text('No Data'),
              );
            }
          },
        ),
      ),
    );
  }
}
