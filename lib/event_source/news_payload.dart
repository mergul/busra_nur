class NewsPayload {
  String newsId;
  String newsOwner;
  List<String> tags;
  List<String> topics;
  bool clean;
  String newsOwnerId;
  String topic;
  String thumb;
  DateTime date;
  int count;
  String ownerUrl;

  NewsPayload(
      {this.newsId,
      this.newsOwner,
      this.tags,
      this.topics,
      this.clean,
      this.newsOwnerId,
      this.topic,
      this.thumb,
      this.date,
      this.count, this.ownerUrl});
  factory NewsPayload.fromJson(dynamic json) {
    return NewsPayload(
        newsId: json['newsId'],
        newsOwner: json['newsOwner'],
        tags: new List<String>.from(json['tags']),
        topics: new List<String>.from(json['topics']),
        clean: json['clean'],
        newsOwnerId: json['newsOwnerId'],
        topic: json['topic'],
        thumb: json['thumb'],
        date: DateTime.fromMillisecondsSinceEpoch(json['date']),
        count: json['count'],
        ownerUrl: json['ownerUrl']);
  }
}
