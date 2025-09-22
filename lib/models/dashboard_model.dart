import 'package:flutter/material.dart';
import 'package:shop_smart/admin/manage_products_screen.dart';
import 'package:shop_smart/screens/edit_upload_product_form.dart';
import 'package:shop_smart/screens/inner_screen/orders/orders_screen.dart';
import 'package:shop_smart/screens/search_screen.dart';
import 'package:shop_smart/services/app_manager.dart';
// 👈 import the screen

class DashboardButtonsModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardButtonsModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  static List<DashboardButtonsModel> dashboardBtnList(context) => [
        DashboardButtonsModel(
          text: "Add a new product",
          imagePath: AssetsManager.fashion,
          onPressed: () {
            Navigator.pushNamed(context, EditOrUploadProductScreen.routeName);
          },
        ),
        DashboardButtonsModel(
          text: "inspect all products",
          imagePath: AssetsManager.shoppingCart,
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
        ),
        DashboardButtonsModel(
          text: "View Orders",
          imagePath: AssetsManager.orderBag,
          onPressed: () {
            Navigator.pushNamed(context, OrdersScreenFree.routeName);
          },
        ),

        // 👇 New Manage Products button
        DashboardButtonsModel(
          text: "Manage Products",
          imagePath: AssetsManager.orderImage, // you can replace with a better icon
          onPressed: () {
            Navigator.pushNamed(context, ManageProductsScreen.routeName);
          },
        ),
      ];
}
