import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_app/cubit/audio_player_cubit.dart';
import 'package:music_player_app/cubit/search_artist_cubit.dart';
import 'package:music_player_app/data/model/song.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AudioPlayerCubit, AudioPlayerState>(
      listener: (context, state) {
        if (state is AudioPlayerInitialState) Navigator.pop(context);
        if (state is AudioPlayerPlayingState) _showMediaPlayer();
        if (state is AudioPlayerPauseState) Navigator.pop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Icon(Icons.music_note),
          title: Text('Simple Music Player'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_upward),
          onPressed: () => _showMediaPlayer(),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search artist....'),
                onSubmitted: (value) =>
                    context.read<SearchArtistCubit>().searchArtist(value),
              ),
            ),
            BlocBuilder<SearchArtistCubit, SearchArtistState>(
              builder: (context, state) {
                if (state is SearchArtistLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SearchArtistFailureState) {
                  return Center(child: Text(state.message));
                } else if (state is SearchArtistSuccessState) {
                  return _buildSongTileList(state.songList);
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongTileList(List<Song> songList) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: songList.length,
        itemBuilder: (context, index) {
          AudioPlayerState _audioPlayerState =
              context.watch<AudioPlayerCubit>().state;
          Song _song = songList[index];
          int? _trackId;

          if (_audioPlayerState is AudioPlayerPlayingState) {
            _trackId = _audioPlayerState.selectedSong.trackId;
          }

          return Builder(
            builder: (context) {
              return ListTile(
                onTap: () {
                  context.read<AudioPlayerCubit>().play(_song);
                },
                leading: Image.network(_song.artworkUrl100),
                title: Text(_song.trackName),
                subtitle: Text(_song.artistName),
                trailing: ((_audioPlayerState is AudioPlayerPlayingState) &&
                        _trackId == _song.trackId)
                    ? CircularProgressIndicator()
                    : Text(_song.collectionName),
              );
            },
          );
        },
      ),
    );
  }

  void _showMediaPlayer() {
    _scaffoldKey.currentState!.showBottomSheet((context) {
      return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (state is AudioPlayerPlayingState) {
                      context
                          .read<AudioPlayerCubit>()
                          .pause(state.selectedSong);
                    } else if (state is AudioPlayerPauseState) {
                      context.read<AudioPlayerCubit>().resume(state.lastSong);
                    }
                  },
                  icon: (state is AudioPlayerPlayingState)
                      ? Icon(Icons.pause_circle)
                      : Icon(Icons.play_circle),
                ),
                if (state is AudioPlayerPlayingState) ...[
                  Text(
                      '${state.selectedSong.artistName} - ${state.selectedSong.trackName}'),
                ]
              ],
            ),
          );
        },
      );
    });
  }
}
