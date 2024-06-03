class Course_list_Vo {
  //필드
  int product_no; //상품
  String productname;
  int price;
  String? text;
  String? picture;
  String? size;

  int cate_no; //카테고리
  String cate_name;

  //생성자
  Course_list_Vo({
    required this.product_no,
    required this.productname,
    required this.price,
    required this.text,
    required this.picture,
    required this.size,
    required this.cate_no,
    required this.cate_name,
  });

  //map--> personVo형식으로 변환
  factory Course_list_Vo.fromJson(Map<String, dynamic> apiData) {
    return Course_list_Vo(
      product_no: apiData['product_no'],
      productname: apiData['productname'],
      price: apiData['price'],
      text: apiData['text'],
      picture: apiData['picture'],
      size: apiData['size'],
      cate_no: apiData['cate_no'],
      cate_name: apiData['cate_name'],
    );
  }

  //현재의 PersonVo를 Map형식으로 내보내줌
  Map<String, dynamic> toJson() {
    return {
      'product_no': product_no,
      'productname': productname,
      'price': price,
      'text': text,
      'picture': picture,
      'size': size,
      'cate_no': cate_no,
      'cate_name': cate_name,
    };
  }

  @override
  String toString() {
    return 'Course_list_Vo{product_no: $product_no, productname: $productname, price: $price, text: $text, picture: $picture, size: $size, cate_no: $cate_no, cate_name: $cate_name}';
  }
}
