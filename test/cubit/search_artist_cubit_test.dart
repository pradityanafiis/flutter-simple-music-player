import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player_app/cubit/search_artist_cubit.dart';
import 'package:music_player_app/data/api/api_service.dart';

import '../fake_json.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late final MockApiService _mockApiService;

  setUpAll(() {
    _mockApiService = MockApiService();
  });

  setUp(() {
    reset(_mockApiService);
  });

  blocTest<SearchArtistCubit, SearchArtistState>(
    'Success',
    build: () {
      when(() => _mockApiService.searchArtist(any()))
          .thenAnswer((_) async => Future.value(FakeJson.artistFound));
      return SearchArtistCubit(apiService: _mockApiService);
    },
    act: (cubit) async => await cubit.searchArtist("artistName"),
    expect: () => [
      isA<SearchArtistLoadingState>(),
      isA<SearchArtistSuccessState>(),
    ],
  );

  blocTest<SearchArtistCubit, SearchArtistState>(
    'Not Found',
    build: () {
      when(() => _mockApiService.searchArtist(any()))
          .thenAnswer((_) async => Future.value(FakeJson.artistNotFound));
      return SearchArtistCubit(apiService: _mockApiService);
    },
    act: (cubit) async => await cubit.searchArtist("artistName"),
    expect: () => [
      isA<SearchArtistLoadingState>(),
      isA<SearchArtistFailureState>(),
    ],
  );

  blocTest<SearchArtistCubit, SearchArtistState>(
    'Exception',
    build: () {
      when(() => _mockApiService.searchArtist(any()))
          .thenAnswer((_) async => Exception());
      return SearchArtistCubit(apiService: _mockApiService);
    },
    act: (cubit) async => await cubit.searchArtist("artistName"),
    expect: () => [
      isA<SearchArtistLoadingState>(),
      isA<SearchArtistFailureState>(),
    ],
  );
}
