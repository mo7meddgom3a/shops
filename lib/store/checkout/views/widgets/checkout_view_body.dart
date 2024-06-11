import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/checkout/cubit/place_order_cubit.dart';
import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutViewBody extends StatelessWidget {
  CheckOutViewBody({Key? key}) : super(key: key);

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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'عنوان التوصيل',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: context.read<PlaceOrderCubit>().locationController,
                  hintText: 'ادخل عنوان التوصيل',
                ),
                SizedBox(height: 20),
                Text(
                  'رقم الهاتف',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  keyboardType: TextInputType.phone,
                  controller: context.read<PlaceOrderCubit>().contactNumberController,
                  hintText: 'ادخل رقم الهاتف',
                ),
                SizedBox(height: 20),
                Text(
                  'ملاحظات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: context.read<PlaceOrderCubit>().notesController,
                  hintText: 'ادخل ملاحظاتك هنا',
                  isOptional: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to pick location from map
                    _pickLocationFromMap(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: ColorConstant.primaryColor,
                    padding: const EdgeInsets.all(16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'اختر الموقع من الخريطة',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
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
                      child: Text(
                        'تأكيد الطلب',
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

  void _pickLocationFromMap(BuildContext context) {
    // Implement logic to pick location from map
    // Example: You can navigate to another screen where user can pick location from map
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
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
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
    );
  }
}
