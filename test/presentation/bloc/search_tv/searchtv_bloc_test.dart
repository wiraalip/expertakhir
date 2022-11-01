import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/bloc/search_tv/searchtv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'searchtv_bloc_test.mocks.dart';

@GenerateMocks([SearchSeries])
void main() {
  late MockSearchSeries mockSearchSeries;
  late SearchTVBloc searchTVBloc;

  setUp(() {
    mockSearchSeries = MockSearchSeries();
    searchTVBloc = SearchTVBloc(mockSearchSeries);
  });

  group('Search Series Bloc Test', () {
    final tvModel = TV(
      genreIds: [10765, 10759, 18],
      id: 84773,
      name: 'The Lord of the Rings: The Rings of Power',
      originalName: "The Lord of the Rings: The Rings of Power",
      overview:
          "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
      popularity: 5205.091,
      posterPath: "/mYLOqiStMxDK3fYZFirgrMt8z5d.jpg",
      voteAverage: 7.7,
      voteCount: 983,
      backdropPath: '/1rO4xoCo4Z5WubK0OwdVll3DPYo.jpg',
    );
    final tTVList = <TV>[tvModel];
    const tQuery = 'All American';
    test('initial state should empty', () {
      expect(searchTVBloc.state, SearchTVEmpty());
    });

    blocTest<SearchTVBloc, SearchTVState>(
        'should emit [Loading, HasData] when data is gotten',
        build: () {
          when(mockSearchSeries.execute(tQuery))
              .thenAnswer((_) async => Right(tTVList));
          return searchTVBloc;
        },
        act: (bloc) => bloc.add(OnQueryChange(tQuery)),
        wait: const Duration(milliseconds: 100),
        expect: () => [SearchTVLoading(), SearchTVHasData(tTVList)],
        verify: (bloc) {
          verify(mockSearchSeries.execute(tQuery));
        });
  });
}
