class Song {
  final int trackId;
  final String artistName;
  final String collectionName;
  final String trackName;
  final String previewUrl;
  final String artworkUrl100;

  Song({
    required this.trackId,
    required this.artistName,
    required this.collectionName,
    required this.trackName,
    required this.previewUrl,
    required this.artworkUrl100,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        trackId: json["trackId"],
        artistName: json["artistName"],
        collectionName: json["collectionName"],
        trackName: json["trackName"],
        previewUrl: json["previewUrl"],
        artworkUrl100: json["artworkUrl100"],
      );

  static List<Song> createList(List<dynamic> data) =>
      data.map<Song>((song) => Song.fromJson(song)).toList();
}
