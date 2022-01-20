class NewsListItemModel {

  final String title;
  final DateTime publishDate;
  final String imgUrlString;

  NewsListItemModel({
    required this.title,
    required this.publishDate,
    required this.imgUrlString,
  });
  
  static NewsListItemModel fromDict(Map<dynamic, dynamic> map) {

    NewsListItemModel model = NewsListItemModel(
      title: map['itemTitle'] ?? 'DefaultNewsItemTitle',
      publishDate: DateTime.fromMillisecondsSinceEpoch(int.parse(map['pubDate'])),
      imgUrlString: (map['itemImageNew'] as List).length > 0 ? ((map['itemImageNew'] as List).first as Map)['imgUrl'] : ''
    );
    
    return model;
  }
}