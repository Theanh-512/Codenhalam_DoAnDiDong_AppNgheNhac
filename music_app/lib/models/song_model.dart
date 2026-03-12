class SongModel {
  final int id;
  final String title;
  final int artistId;
  final String artistName;
  final String fileUrl;
  final String? coverImage;
  final int duration;
  final DateTime createdAt;
  bool isFavorite;

  SongModel({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    required this.fileUrl,
    this.coverImage,
    required this.duration,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'],
      title: json['title'],
      artistId: json['artistId'],
      artistName: json['artistName'],
      fileUrl: json['fileUrl'],
      coverImage: json['coverImage'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['createdAt']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artistId': artistId,
      'artistName': artistName,
      'fileUrl': fileUrl,
      'coverImage': coverImage,
      'duration': duration,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}
