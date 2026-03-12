class PlaylistModel {
  final int id;
  final String name;
  final String userId;
  final DateTime createdAt;
  final int songCount;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.createdAt,
    required this.songCount,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      songCount: json['songCount'] ?? 0,
    );
  }
}
