class AppImages {
  AppImages._();

  // Top category Row Images
  static const String flipkartTile = 'assets/images/flipkartTile.png';
  static const String minutes = 'assets/images/9minutes.png';
  static const String travel = 'assets/images/travel.png';
  static const String grocery = 'assets/images/grocery.png';

  // Banner images
  static const String banner1 = 'assets/images/bannerImage1.jpeg';
  static const String banner2 = 'assets/images/bannerImage2.jpeg';
  static const String banner3 = 'assets/images/bannerImage3.jpeg';
  static const String banner4 = 'assets/images/bannerImage4.jpeg';
  static const String banner5 = 'assets/images/bannerImage5.jpeg';

  // Still looking for images
  static const String stillLook1 = 'assets/images/stillLook1.webp';
  static const String stillLook2 = 'assets/images/stillLook2.jpg';
  static const String stillLook3 = 'assets/images/stillLook3.jpg';
  static const String babygifts = 'assets/images/baby gifts.jpg';
  static const String bedsheets = 'assets/images/bedsheets.jpg';
  static const String bedminton= 'assets/images/bedminton.jpg';
  static const String shoes= 'assets/images/campus black shoes.jpg';
  static const String biographies= 'assets/images/biographies.jpg';
  static const String comics= 'assets/images/comics.jpg';
  static const String cookware= 'assets/images/cookware.jpg';
  static const String dryFruits= 'assets/images/dry fruits.jpg';
  static const String fans= 'assets/images/fans.jpg';
  static const String gymCombo= 'assets/images/gym combo.jpg';
  static const String headphone= 'assets/images/headphone.jpg';
  static const String heater= 'assets/images/heater.jpg';
  static const String mackbook= 'assets/images/mackbook.jpg';
  static const String moisturizer= 'assets/images/moisturizer.webp';
  static const String mobile= 'assets/images/mobile phones.jpg';
  static const String moto= 'assets/images/moto.jpg';
  static const String perfume= 'assets/images/perfumes.jpg';
  static const String remoteCar= 'assets/images/remote control car.jpg';
  static const String tv= 'assets/images/tv.jpg';
  static const String washingMachine= 'assets/images/washing machines.jpg';
  static const String oilAndGhee= 'assets/images/oil and ghee.jpg';


  // placeholder image
  static const String placeholder = stillLook1;

  // List of Map (id -> image)
  static const List<Map<String, String>> productImages = [
    {'id': 'ff8081819782e69e019bc67597d65d9b', 'image': stillLook1},
    {'id': 'ff8081819782e69e019bc67cade95dcb', 'image': stillLook2},
    {'id': 'ff8081819782e69e019bc67eeeae5dd5', 'image': stillLook3},
    {'id': 'ff8081819782e69e019bda13575e0eb1', 'image': mackbook},
    {'id': 'ff8081819782e69e019bda1465e30eb6', 'image': shoes},
    {'id': 'ff8081819782e69e019bda0ca7f50e93', 'image': mobile},
    {'id': 'ff8081819782e69e019bda11d7e50ea8', 'image': moto},
    {'id': 'ff8081819782e69e019bda1699ec0ebd', 'image': moisturizer},
    {'id': 'ff8081819782e69e019bda1766b70ec0', 'image': perfume},
    {'id': 'ff8081819782e69e019bda1a3c150ed3', 'image': tv},
    {'id': 'ff8081819782e69e019bda0b8f8d0e90', 'image': washingMachine},
    {'id': 'ff8081819782e69e019bda1b78210ed8', 'image': bedsheets},
    {'id': 'ff8081819782e69e019bda1c256a0edc', 'image': cookware},
    {'id': 'ff8081819782e69e019bda1d78bd0ee7', 'image': fans},
    {'id': 'ff8081819782e69e019bda1e457a0ee8', 'image': heater},
    {'id': 'ff8081819782e69e019bda1f76c00eeb', 'image': bedminton},
    {'id': 'ff8081819782e69e019bda1ffa8e0eee', 'image': gymCombo},
    {'id': 'ff8081819782e69e019bda21c7150ef3', 'image': remoteCar},
    {'id': 'ff8081819782e69e019bda225dc30ef4', 'image': babygifts},
    {'id': 'ff8081819782e69e019bda236ff30efa', 'image': dryFruits},
    {'id': 'ff8081819782e69e019bda240dc60efd', 'image': oilAndGhee},
    {'id': 'ff8081819782e69e019bda257f8f0f00', 'image': comics},
    {'id': 'ff8081819782e69e019bda2616e80f01', 'image': biographies},

  ];

  static String getImageByProductId(String productId) {
    try {
      final int index = productImages.indexWhere(
            (element) => element['id'] == productId,
      );

      if (index == -1) {
        return placeholder; // id not found
      }

      return productImages[index]['image'] ?? placeholder;
    } catch (e) {
      // Any unexpected error → safe fallback
      return placeholder;
    }
  }

}
