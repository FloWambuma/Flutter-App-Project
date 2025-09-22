import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart/consts/app_constants.dart';
import 'package:shop_smart/providers/products_provider.dart';
import 'package:shop_smart/screens/products/ctg_roundedimage.dart';
import 'package:shop_smart/screens/products/latest_arrival.dart';
import 'package:shop_smart/widgets/app_name_text.dart';
import 'package:shop_smart/widgets/title_text.dart';

class HomeScreen extends StatelessWidget {
  static const routName = "/HomeScreen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AppConstants.safeAsset("assets/images/cart/shopping_cart.png")),
        ),
        title: const AppNameTextWidget(fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              SizedBox(
                height: size.height * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Swiper(
                    autoplay: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        AppConstants.banners[index],
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: AppConstants.banners.length,
                    pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.red,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              const TitlesTextWidget(label: "Latest Arrivals"),
              const SizedBox(height: 15.0),
              SizedBox(
                height: size.height * 0.2,
                child: productsProvider.getProducts.isEmpty
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 40,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "No latest arrivals yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productsProvider.getProducts.length,
                        itemBuilder: (context, index) {
                          final product = productsProvider.getProducts[index];
                          return ChangeNotifierProvider.value(
                            value: product,
                            child: const LatestArrivalProductsWidget(),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 15.0),
              const TitlesTextWidget(label: "Categories"),
              const SizedBox(height: 15.0),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  AppConstants.CategoriesList.length,
                  (index) {
                    return CategoryRoundedWidget(
                      image: AppConstants.safeAsset(AppConstants.CategoriesList[index].image),
                      name: AppConstants.CategoriesList[index].name,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
