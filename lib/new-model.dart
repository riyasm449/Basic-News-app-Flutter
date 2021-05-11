class Article {
  String source;
  String title;
  String author;
  String description;
  String imgUrl;
  DateTime publshedAt;
  String content;
  String articleUrl;

  Article(
      {this.source,
      this.title,
      this.description,
      this.author,
      this.content,
      this.publshedAt,
      this.imgUrl,
      this.articleUrl});
}
