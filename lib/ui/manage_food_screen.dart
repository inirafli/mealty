import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealty/provider/manage_food_provider.dart';
import 'package:mealty/provider/profile_provider.dart';
import 'package:mealty/widgets/foodpost/food_image_picker.dart';

import 'package:provider/provider.dart';

import '../common/post_state.dart';
import '../provider/food_provider.dart';
import '../widgets/common/custom_loading_indicator.dart';
import '../widgets/common/custom_snackbar.dart';
import '../widgets/common/sub_screen_header.dart';
import '../widgets/foodpost/food_location_picker.dart';
import '../widgets/foodpost/food_price_input.dart';
import '../widgets/foodpost/food_stock_input.dart';
import '../widgets/foodpost/food_text_field.dart';
import '../widgets/foodpost/food_type_selector.dart';
import '../widgets/foodpost/sale_time_input.dart';
import '../widgets/foodpost/selling_type_selector.dart';

class ManageFoodScreen extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? foodData;

  const ManageFoodScreen({super.key, this.isEdit = false, this.foodData});

  @override
  State<ManageFoodScreen> createState() => _ManageFoodScreenState();
}

class _ManageFoodScreenState extends State<ManageFoodScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ManageFoodProvider>(context, listen: false)
          .initializeData(foodData: widget.foodData);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: onPrimary,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: SingleChildScrollView(
              child: SafeArea(
                top: false,
                child: Consumer<ManageFoodProvider>(
                  builder: (context, manageFoodProvider, child) {
                    if (manageFoodProvider.isLoading) {
                      return Center(
                        child: CustomProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                          strokeWidth: 2.0,
                          size: 24.0,
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          child: FoodImagePicker(
                            imageFile: manageFoodProvider.imageFile,
                            imageUrl: widget.foodData?['image'],
                            onImageRemove: manageFoodProvider.removeImage,
                            onPickImageFromGallery:
                                manageFoodProvider.pickImageFromGallery,
                            onCaptureImageWithCamera:
                                manageFoodProvider.captureImageWithCamera,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: onPrimary,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6.0),
                                    FoodTextFields(
                                      nameController:
                                          manageFoodProvider.nameController,
                                      descriptionController: manageFoodProvider
                                          .descriptionController,
                                    ),
                                    const SizedBox(height: 24.0),
                                    FoodTypeSelector(
                                      selectedType: manageFoodProvider
                                          .selectedFoodCategory,
                                      onSelectType:
                                          manageFoodProvider.selectFoodCategory,
                                    ),
                                    const SizedBox(height: 8.0),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: onPrimary,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6.0),
                                    SellingTypeSelector(
                                      selectedType: manageFoodProvider
                                          .selectedSellingType,
                                      onSelectType:
                                          manageFoodProvider.selectSellingType,
                                    ),
                                    const SizedBox(height: 24.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: PriceInput(
                                            controller: manageFoodProvider
                                                .priceController,
                                            isEditable: manageFoodProvider
                                                    .selectedSellingType ==
                                                'commercial',
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          child: StockInput(
                                            controller: manageFoodProvider
                                                .stockController,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24.0),
                                    SaleTimeInput(
                                      controller:
                                          manageFoodProvider.saleTimeController,
                                      onSelectDateTime:
                                          manageFoodProvider.selectSaleTime,
                                      initialDateTime:
                                          manageFoodProvider.saleTime,
                                    ),
                                    const SizedBox(height: 8.0),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: onPrimary,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, bottom: 8.0),
                                  child: FoodLocationPicker(
                                    latitude: manageFoodProvider.latitude,
                                    longitude: manageFoodProvider.longitude,
                                    onLocationPicked:
                                        manageFoodProvider.setLocation,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SubScreenHeader(
              title: widget.isEdit ? 'Ubah Makanan' : 'Tambah Makanan',
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: Consumer3<ManageFoodProvider, FoodProvider, ProfileProvider>(
            builder: (context, manageFoodProvider, foodProvider,
                profileProvider, child) {
              return ElevatedButton(
                onPressed:
                    manageFoodProvider.postState.status == PostStatus.loading
                        ? null
                        : () async {
                            if (widget.isEdit) {
                              await manageFoodProvider
                                  .updateFoodPost(widget.foodData!['id']);
                            } else {
                              await manageFoodProvider.addFoodPost();
                            }

                            if (!context.mounted) return;

                            if (manageFoodProvider.postState.status ==
                                PostStatus.error) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(CustomSnackBar(
                                  contentText:
                                      manageFoodProvider.postState.errorMessage,
                                  context: context,
                                ));
                            } else if (manageFoodProvider.postState.status ==
                                PostStatus.success) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(CustomSnackBar(
                                  contentText: widget.isEdit
                                      ? 'Berhasil mengubah unggahan Makanan.'
                                      : 'Berhasil menambahkan unggahan Makanan.',
                                  context: context,
                                ));

                              await foodProvider.fetchPosts();
                              await profileProvider.refreshUserFoodPosts();

                              if (context.mounted) {
                                context.pop();
                              }
                            }
                          },
                child: manageFoodProvider.postState.status == PostStatus.loading
                    ? CustomProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 16.0,
                        strokeWidth: 2,
                      )
                    : Text(
                        widget.isEdit ? 'Ubah Makanan' : 'Unggah Makanan',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
