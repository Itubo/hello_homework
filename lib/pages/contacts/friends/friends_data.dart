

//model
class Friends {
  final String? imageUrl;//图片 URL
  final String? name;//好友名称
  final String? indexLetter;//索引字母(组头)
  final String? imageAssets;//图片
  final int? uid;
  //构造方法
  Friends({this.imageUrl,this.name,this.indexLetter,this.imageAssets,this.uid});
}
//好友列表
List <Friends> datas =
[
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/women/27.jpg',
      name: 'Lina',
      indexLetter: 'L'
  ),
  Friends(
      imageUrl: 'https://randomuser.me/api/portraits/men/15.jpg',
      name: 'Betty',
      indexLetter: 'B'
  ),

];

