
import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/checkout/cubit/place_order_cubit.dart';
import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutViewBody extends StatelessWidget {
  CheckOutViewBody({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlaceOrderCubit, PlaceOrderState>(
      listener: (context, state) {
        if (state is PlaceOrderSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Order placed successfully!'),
              action: SnackBarAction(
                label: 'View',
                onPressed: () {
                  Navigator.pop(context, 'StoreProfile');
                },
              ),
            ),
          );

          // Navigate back after successful order placement
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        } else if (state is PlaceOrderFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to place order"),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: context.read<PlaceOrderCubit>().locationController,
                  hintText: 'Enter your delivery address',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Contact Number',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  keyboardType: TextInputType.phone,
                  controller: context.read<PlaceOrderCubit>().contactNumberController,
                  hintText: 'Enter your contact number',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Notes',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: context.read<PlaceOrderCubit>().notesController,
                  hintText: 'Enter any additional notes',
                  isOptional: true,
                ),
                const SizedBox(height: 20),
                BlocBuilder<PlaceOrderCubit, PlaceOrderState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await context.read<PlaceOrderCubit>().totalCartPrice();
                          List<ProductModel> products = context.read<PlaceOrderCubit>().products;
                          context.read<PlaceOrderCubit>().placeOrder(product: products);

                          context.read<PlaceOrderCubit>().clearCart();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: ColorConstant.primaryColor,
                        padding: const EdgeInsets.all(16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Place Order',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.isOptional = false,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (!isOptional && (value == null || value.isEmpty)) {
          return 'Please fill this field';
        }
        return null;
      },
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
