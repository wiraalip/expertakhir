import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv/tv_bloc.dart';
import '../widgets/tv_card_list.dart';

class PopularSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-series';

  @override
  _PopularSeriesPageState createState() => _PopularSeriesPageState();
}

class _PopularSeriesPageState extends State<PopularSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<PopularSeriesBloc>().add(FetchPopularSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularSeriesBloc, SeriesState>(
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
              return const Text('No Data');
            }
          },
        ),
      ),
    );
  }
}
