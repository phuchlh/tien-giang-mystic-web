class NewsModel {
  SearchParameters? searchParameters;
  List<News>? news;
  int? credits;

  NewsModel({this.searchParameters, this.news, this.credits});

  NewsModel.fromJson(Map<String, dynamic> json) {
    searchParameters = json['searchParameters'] != null
        ? SearchParameters.fromJson(json['searchParameters'])
        : null;
    if (json['news'] != null) {
      news = <News>[];
      json['news'].forEach((v) {
        news!.add(News.fromJson(v));
      });
    }
    credits = json['credits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (searchParameters != null) {
      data['searchParameters'] = searchParameters!.toJson();
    }
    if (news != null) {
      data['news'] = news!.map((v) => v.toJson()).toList();
    }
    data['credits'] = credits;
    return data;
  }
}

class SearchParameters {
  String? q;
  String? gl;
  String? hl;
  String? type;
  String? location;
  String? engine;

  SearchParameters(
      {this.q, this.gl, this.hl, this.type, this.location, this.engine});

  SearchParameters.fromJson(Map<String, dynamic> json) {
    q = json['q'];
    gl = json['gl'];
    hl = json['hl'];
    type = json['type'];
    location = json['location'];
    engine = json['engine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['q'] = q;
    data['gl'] = gl;
    data['hl'] = hl;
    data['type'] = type;
    data['location'] = location;
    data['engine'] = engine;
    return data;
  }
}

class News {
  String? title;
  String? link;
  String? snippet;
  String? date;
  String? source;
  String? imageUrl;
  int? position;

  News(
      {this.title,
      this.link,
      this.snippet,
      this.date,
      this.source,
      this.imageUrl,
      this.position});

  News.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    link = json['link'];
    snippet = json['snippet'];
    date = json['date'];
    source = json['source'];
    imageUrl = json['imageUrl'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['link'] = link;
    data['snippet'] = snippet;
    data['date'] = date;
    data['source'] = source;
    data['imageUrl'] = imageUrl;
    data['position'] = position;
    return data;
  }
}
