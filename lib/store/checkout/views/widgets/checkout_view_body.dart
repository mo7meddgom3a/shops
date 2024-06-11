import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/checkout/cubit/place_order_cubit.dart';

class CheckOutViewBody extends StatelessWidget {
  CheckOutViewBody({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlaceOrderCubit, PlaceOrderState>(
      listener: (context, state) {
        if (state.state == PlaceOrderStatus.loaded) {
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
        } else if (state.state == PlaceOrderStatus.error) {
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'عنوان التوصيل',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller:
                      context.read<PlaceOrderCubit>().locationController,
                  hintText: 'ادخل عنوان التوصيل',
                ),
                const SizedBox(height: 20),
                const Text(
                  'رقم الهاتف',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  keyboardType: TextInputType.phone,
                  controller:
                      context.read<PlaceOrderCubit>().contactNumberController,
                  hintText: 'ادخل رقم الهاتف',
                ),
                const SizedBox(height: 20),
                const Text(
                  'ملاحظات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: context.read<PlaceOrderCubit>().notesController,
                  hintText: 'ادخل ملاحظاتك هنا',
                  isOptional: true,
                ),
                const SizedBox(height: 20),
                     ElevatedButton(
                      onPressed: () {
                        context.read<PlaceOrderCubit>().getCurrentLocation();
                        context.read<PlaceOrderCubit>().getAddressFromLatLng();
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
                        'اختر الموقع من ',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),

                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<PlaceOrderCubit, PlaceOrderState>(
                  builder: (context, state) {
                    return Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          state.currentLocationName,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<PlaceOrderCubit, PlaceOrderState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final cubit = context.read<PlaceOrderCubit>();
                          await cubit
                              .fetchCartItems(); // Ensure items are fetched before placing order
                          cubit.placeOrder(product: cubit.products);
                          cubit.clearCart();
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
                              'Submit Order',
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
      textAlign: TextAlign.right,
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
