class Post {
  final String name;
  final String handle;
  final String text;
  final String avatarUrl;
  final String imageUrl;
  final int comments;
  final int likes;

  Post({
    required this.name,
    required this.handle,
    required this.text,
    required this.avatarUrl,
    required this.imageUrl,
    required this.comments,
    required this.likes,
  });
}
