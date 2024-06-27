import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductDetailsViewBody extends StatelessWidget {
  const ProductDetailsViewBody({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set text direction to right-to-left
      child: ListView(
        children: [
          CarouselSlider.builder(
            itemCount: product.imageUrl.length,
            options: CarouselOptions(
              aspectRatio: 16 / 9,
              enlargeCenterPage: true,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            itemBuilder: (context, index, realIndex) {
              final imageUrl = product.imageUrl[index];
              return Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Placeholder(); // Placeholder for failed images
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${product.price} SAR",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'الوصف',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    product.description ?? 'No description available',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    softWrap: true, // Enable text wrapping
                    overflow: TextOverflow.fade, // Handle overflow gracefully
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
