import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/model/db/CartProductStorage.dart';
import 'package:haveli/view/screens/cart_screen.dart';
import 'package:haveli/view/screens/favourites_screen.dart';
import 'package:haveli/view/screens/products_screen.dart';
import 'package:haveli/view/screens/profile_screen.dart';
import 'package:haveli/view/screens/search_screen.dart';
import '../../model/category.dart';
import '../../model/product.dart';
import '../base/products_grid.dart';

List<Widget> navigationBody = <Widget>[
  const Home(),
  const CartScreen(),
  const FavoriteScreen(),
  const ProfileScreen()
];

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxInt index = 0.obs;
    return Scaffold(
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            currentIndex: index.value,
            onTap: (current) {
              index.value = current;
            },
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(EvaIcons.home), label: "Home".tr),
              BottomNavigationBarItem(
                  icon: const Icon(EvaIcons.shoppingCart), label: "Cart".tr),
              BottomNavigationBarItem(
                  icon: const Icon(EvaIcons.heart), label: "Favourite".tr),
              BottomNavigationBarItem(
                  icon: const Icon(EvaIcons.settings), label: "Settings".tr),
            ],
          );
        }),
        body: Obx(() => navigationBody[index.value]));
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GetBuilder(
          init: CartProductStorage(),
          builder: (cart) {
            var total = 0.0;
            var productCount = 0;
            if (cart.products != null) {
              for (var product in cart.products!) {
                total +=
                    product.product.price!.replaceAll(",", ".").toDouble() *
                        product.quantity.toInt();
                productCount += product.quantity.toInt();
              }
            }
            return Visibility(
              visible:
                  cart.products != null ? cart.products!.isNotEmpty : false,
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(const CartScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(total.toStringAsFixed(2)),
                      Text("Show Shopping Cart".tr),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: cart.products != null
                              ? Text(productCount.toString())
                              : Text("0"))
                    ],
                  )).width(Get.width).paddingSymmetric(horizontal: 20),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
          title: CupertinoSearchTextField(
        style: const TextStyle(color: Colors.orange),
        onSubmitted: (text) {
          Get.to(SearchScreen(
            searchText: text,
          ));
        },
        decoration: BoxDecoration(
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(20)),
      )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${"Hello".tr} , ${FirebaseAuth.instance.currentUser?.displayName ?? "Guest".tr} ",
              style: GoogleFonts.aBeeZee(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ).paddingAll(10),
            _recommendedProductListView(),
            Text(
              "Categories".tr,
              style: GoogleFonts.aBeeZee(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ).paddingAll(10),
            _categories(),
            //Expanded(child: _products())
          ],
        ),
      ),
    );
  }
}

Widget _categories() {
  RxInt catIndex = 0.obs;
  RxList products = [].obs;
  RxString categoryTitle = "".obs;
  return Column(
    children: [
      StreamBuilder(
          stream: FirebaseDatabase.instance.ref().child("categories").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              var categories = snapshot.data?.snapshot.children.toList();
              if (categories == null || categories.isEmpty) {
                return Center(
                  child: Text("there is no products".tr),
                );
              }
              return SizedBox(
                height: 110,
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          Category category =
                              Category.fromJson(categories[index].value as Map);
                          if (index == 0) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              products.value = categories[index]
                                  .child("products")
                                  .children
                                  .toList();
                              categoryTitle.value = category.title;
                            });
                          }
                          return Obx(
                            () => Card(
                              color: catIndex.value == index
                                  ? Colors.orange
                                  : Colors.transparent,
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    height: 60,
                                    width: 70,
                                    imageUrl: category.imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const SpinKitFadingCircle(
                                            color: Colors.deepOrange),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Text(category.title)
                                ],
                              ),
                            ).onTap(() {
                              catIndex.value = index;
                              products.value = categories[index]
                                  .child("products")
                                  .children
                                  .toList();
                              categoryTitle.value = category.title;
                            }),
                          );
                        })),
              );
            } else {
              return const Center(
                  child: SpinKitSpinningLines(
                color: Colors.red,
              ));
            }
          }),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Popular".tr,
            style: GoogleFonts.aBeeZee(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange),
          ),
          // Obx(() {
          //   return Visibility(
          //     visible: products.value.length > 4,
          //     child: Text(
          //       "Show All".tr,
          //       style: GoogleFonts.aBeeZee(
          //           decoration: TextDecoration.underline,
          //           fontSize: 16,
          //           color: Colors.orange),
          //     ).onTap(() {
          //       Get.to(ProductsScreen(
          //           products: products, category: categoryTitle.value));
          //     }),
          //   );
          // }),
        ],
      ).paddingAll(10),
      Obx(() {
        products.sort((a, b) {
          int num1 = int.tryParse(Product.fromJson(a.value).title!.substring(
                  0,
                  Product.fromJson(a.value).title!.contains(".")
                      ? Product.fromJson(a.value).title!.indexOf(".")
                      : 0)) ??
              0;
          int num2 = int.tryParse(Product.fromJson(b.value).title!.substring(
                  0,
                  Product.fromJson(b.value).title!.contains(".")
                      ? Product.fromJson(b.value).title!.indexOf(".")
                      : 0)) ??
              0;
          return num1.compareTo(num2);
        });
        return products.isEmpty
            ? Center(
                child: Text("No products Found".tr),
              )
            : ProductsGrid(products: products, length: products.length)
                .paddingBottom(70);
      })
    ],
  ).paddingTop(5);
}

Widget _recommendedProductListView() {
  RxInt currentIndex = 0.obs;
  final CarouselController _controller = CarouselController();

  return StreamBuilder(
      stream: FirebaseDatabase.instance.ref().child("slider").onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          var images = snapshot.data?.snapshot.value as List<dynamic>?;
          if (images == null || images.isEmpty) {
            return Container();
          }
          return CarouselSlider(
            items: images.map((url) {
              return Container(
                width: Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                child: CachedNetworkImage(
                  imageUrl: url,
                  imageBuilder: (context, imageProvider) => ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const SpinKitSpinningLines(color: Colors.red),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 160.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              // Set the duration for each slide
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, _) {
                currentIndex.value = index;
              },
            ),
            carouselController: _controller,
          );
        } else {
          return const Center(
              child: SpinKitSpinningLines(
            color: Colors.red,
          ));
        }
      }).paddingTop(5);
}
