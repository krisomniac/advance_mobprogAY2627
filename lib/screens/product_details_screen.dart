import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../widgets/custom_text.dart';

//details page, uses future builder
class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                product.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: Icon(Icons.image, size: 48.sp),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: product.title,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      CustomText(
                        text: '\$${product.price.toStringAsFixed(2)}',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(width: 12.w),
                      Icon(Icons.star, size: 16.sp, color: Colors.amber),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: product.rating.toStringAsFixed(1),
                        fontSize: 13.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: '${product.brand} · ${product.category}',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 16.h),
                  CustomText(
                    text: 'Description',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 6.h),
                  CustomText(
                    text: product.description,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 16.h),
                  CustomText(
                    text: 'Stock: ${product.stock} available',
                    fontSize: 12.sp,
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const CustomText(
                        text: 'Read All',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}