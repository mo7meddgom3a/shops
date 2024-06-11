import 'package:anwer_shop/core/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anwer_shop/core/colors.dart';
import 'package:anwer_shop/store/search/cubit/search_cubit.dart';
import 'package:anwer_shop/store/store_items/models/product_model.dart';
import 'package:anwer_shop/store/store_items/views/widgets/product_card.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) _clearSearchAndPop(context);
      },
      child: Scaffold(
        backgroundColor: ColorConstant.bgColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _clearSearchAndPop(context);
            },
          ),
          backgroundColor: ColorConstant.primaryColor,
          title: const Text(
            'بحث',
            style: TextStyle(color: Colors.white),
            textDirection: TextDirection.rtl,
          ),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث...',
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white),
                            onPressed: () {
                              _searchController.clear();
                              context.read<SearchCubit>().search('');
                            },
                          )
                        : null,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  onChanged: (value) {
                    context.read<SearchCubit>().search(value);
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitial) {
                      return const Center(
                          child: Text('أدخل كلمة للبحث',
                              style: TextStyle(color: Colors.white)));
                    } else if (state is SearchLoading) {
                      return  Center(child: loadingIndicator(color: Colors.white));
                    } else if (state is SearchLoaded) {
                      if (state.items.isEmpty) {
                        return const Center(
                            child: Text('لا توجد نتائج',
                                style: TextStyle(color: Colors.white)));
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: .8),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final ProductModel item = state.items[index];
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ProductCard(
                                product: item,
                                widthFactor: 1.1,
                                leftPositionValue: 120,
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is SearchError) {
                      return Center(
                          child: Text('خطأ: ${state.message}',
                              style: const TextStyle(color: Colors.white)));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearSearchAndPop(BuildContext context) {
    _searchController.clear();
    context.read<SearchCubit>().search('');
    Navigator.of(context).pop();
  }
}
