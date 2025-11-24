class Post {
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String date;

  Post({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    const String baseUrl = "https://firmly-splendid-dove.ngrok-free.app/";

    return Post(
      title: json['judul'] ?? '',
      description: json['deskripsi'] ?? '',
      category: (json['kategori'] ?? '').toString().toLowerCase(),
      date: json['tgl_terbit'] ?? '',
      imageUrl: baseUrl + (json['foto'] ?? ''),
    );
  }
}
