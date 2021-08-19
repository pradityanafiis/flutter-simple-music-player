import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player_app/data/api/api_service.dart';
import 'package:music_player_app/data/model/song.dart';

@immutable
abstract class SearchArtistState {}

class SearchArtistInitialState extends SearchArtistState {}

class SearchArtistLoadingState extends SearchArtistState {}

class SearchArtistSuccessState extends SearchArtistState {
  final List<Song> songList;

  SearchArtistSuccessState(this.songList);
}

class SearchArtistFailureState extends SearchArtistState {
  final String message;

  SearchArtistFailureState(this.message);
}

class SearchArtistCubit extends Cubit<SearchArtistState> {
  final ApiService apiService;

  SearchArtistCubit({required this.apiService})
      : super(SearchArtistInitialState());

  searchArtist(String artistName) async {
    emit(SearchArtistLoadingState());
    final _response = await apiService.searchArtist(artistName);
    if (_response is Exception) {
      emit(SearchArtistFailureState(_response.toString()));
    } else {
      final int _resultCount = _response['resultCount'];
      if (_resultCount > 0)
        emit(SearchArtistSuccessState(Song.createList(_response['results'])));
      else
        emit(SearchArtistFailureState('Artist not found!'));
    }
  }
}
