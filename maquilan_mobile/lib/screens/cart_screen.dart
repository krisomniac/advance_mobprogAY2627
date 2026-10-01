import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';
import '../widgets/custom_text.dart';
import 'detail_screen.dart';

// renders carts endpoint
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<Cart?> _cartFuture;

  // local map to track quantities of each cart item, keyed by product id
  final Map<int, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    // fetch the cart for the current user (userId = 1) when the screen is initialized
    _cartFuture = CartService().getCartByUserId(currentUserId);
  }

  double _lineTotal(CartProduct item) {
    final qty = _quantities[item.id] ?? item.quantity;
    final rawTotal = item.price * qty;
    return rawTotal - (rawTotal * item.discountPercentage / 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Cart',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FutureBuilder<Cart?>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: CustomText(
                text: 'Error: ${snapshot.error}',
                fontSize: 14.sp,
              ),
            );
          }

          final cart = snapshot.data;
          if (cart == null || cart.products.isEmpty) {
            return Center(
              child: CustomText(text: 'Your cart is empty.', fontSize: 14.sp),
            );
          }

          for (final item in cart.products) {
            _quantities.putIfAbsent(item.id, () => item.quantity);
          }

          final subtotal = cart.products.fold<double>(
            0,
            (sum, item) => sum + _lineTotal(item),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: cart.products.length,
                  itemBuilder: (context, index) {
                    final item = cart.products[index];
                    final qty = _quantities[item.id] ?? item.quantity;

                    return GestureDetector(
                      // clicking a cart item opens the detail screen for that product
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(productId: item.id),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(
                                  item.thumbnail,
                                  width: 56.w,
                                  height: 56.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Icon(Icons.image, size: 24.sp),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: item.title,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text:
                                          '\$${item.price.toStringAsFixed(2)}',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CustomText(
                                      text:
                                          '${item.discountPercentage.toStringAsFixed(0)}% off · \$${_lineTotal(item).toStringAsFixed(2)} total',
                                      fontSize: 11.sp,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.add_circle,
                                        color: Colors.amber),
                                    onPressed: () {
                                      setState(() {
                                        _quantities[item.id] = qty + 1;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.h),
                                    child:
                                        CustomText(text: '$qty', fontSize: 13.sp),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.amber),
                                    onPressed: qty <= 1
                                        ? null
                                        : () {
                                            setState(() {
                                              _quantities[item.id] = qty - 1;
                                            });
                                          },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(text: 'Subtotal:', fontSize: 14),
                        CustomText(
                          text: '\$${subtotal.toStringAsFixed(2)}',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order confirmed!')),
                          );
                        },
                        child: const CustomText(
                          text: 'Confirm Order',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}