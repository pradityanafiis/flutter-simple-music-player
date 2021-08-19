import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player_app/data/model/song.dart';

@immutable
abstract class AudioPlayerState {}

class AudioPlayerInitialState extends AudioPlayerState {}

class AudioPlayerLoadingState extends AudioPlayerState {}

class AudioPlayerPlayingState extends AudioPlayerState {
  final Song selectedSong;

  AudioPlayerPlayingState(this.selectedSong);
}

class AudioPlayerPauseState extends AudioPlayerState {
  final Song lastSong;

  AudioPlayerPauseState(this.lastSong);
}

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayerCubit() : super(AudioPlayerInitialState()) {
    _audioPlayer.onPlayerCompletion.listen((_) {
      emit(AudioPlayerInitialState());
    });
  }

  void play(Song song) async {
    await _audioPlayer.play(song.previewUrl);
    emit(AudioPlayerPlayingState(song));
  }

  void pause(Song song) async {
    await _audioPlayer.pause();
    emit(AudioPlayerPauseState(song));
  }

  void resume(Song song) async {
    await _audioPlayer.resume();
    emit(AudioPlayerPlayingState(song));
  }
}
