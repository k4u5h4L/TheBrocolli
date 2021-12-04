class News {
  String title;
  String photo;
  String description;
  String date;
  String author;
  bool trending = false;

  News(
      {this.title,
      this.photo,
      this.description,
      this.date,
      this.author,
      this.trending = false});
}
