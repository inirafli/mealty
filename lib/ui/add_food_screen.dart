import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealty/provider/add_food_provider.dart';
import 'package:mealty/widgets/foodpost/food_image_picker.dart';

import 'package:provider/provider.dart';

import '../common/post_state.dart';
import '../provider/food_provider.dart';
import '../widgets/common/custom_loading_indicator.dart';
import '../widgets/common/custom_snackbar.dart';
import '../widgets/foodpost/add_post_header.dart';
import '../widgets/foodpost/food_location_picker.dart';
import '../widgets/foodpost/food_price_input.dart';
import '../widgets/foodpost/food_text_field.dart';
import '../widgets/foodpost/food_type_selector.dart';
import '../widgets/foodpost/sale_time_input.dart';
import '../widgets/foodpost/selling_type_selector.dart';

class AddFoodScreen extends StatelessWidget {
  const AddFoodScreen({super.key});

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.0, vertical: 12.0),
                  child: Consumer<AddFoodProvider>(
                    builder: (context, addFoodProvider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FoodImagePicker(
                            imageFile: addFoodProvider.imageFile,
                            onImageRemove: addFoodProvider.removeImage,
                            onPickImageFromGallery:
                                addFoodProvider.pickImageFromGallery,
                            onCaptureImageWithCamera:
                                addFoodProvider.captureImageWithCamera,
                          ),
                          const SizedBox(height: 24.0),
                          FoodTextFields(
                            nameController: addFoodProvider.nameController,
                            descriptionController:
                                addFoodProvider.descriptionController,
                          ),
                          const SizedBox(height: 24.0),
                          FoodTypeSelector(
                            selectedType: addFoodProvider.selectedFoodCategory,
                            onSelectType: addFoodProvider.selectFoodCategory,
                          ),
                          const SizedBox(height: 24.0),
                          SellingTypeSelector(
                            selectedType: addFoodProvider.selectedSellingType,
                            onSelectType: addFoodProvider.selectSellingType,
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            children: [
                              Expanded(
                                child: PriceInput(
                                  controller: addFoodProvider.priceController,
                                  isEditable:
                                      addFoodProvider.selectedSellingType ==
                                          'commercial',
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: SaleTimeInput(
                                  controller:
                                      addFoodProvider.saleTimeController,
                                  onSelectDateTime:
                                      addFoodProvider.selectSaleTime,
                                  initialDateTime: addFoodProvider.saleTime,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          FoodLocationPicker(
                            latitude: addFoodProvider.latitude,
                            longitude: addFoodProvider.longitude,
                            onLocationPicked: addFoodProvider.setLocation,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AddPostHeader(
              title: 'Tambah Makanan',
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: Consumer2<AddFoodProvider, FoodProvider>(
            builder: (context, addFoodProvider, foodProvider, child) {
              return ElevatedButton(
                onPressed:
                    addFoodProvider.postState.status == PostStatus.loading
                        ? null
                        : () async {
                            await addFoodProvider.addFoodPost();

                            if (!context.mounted) return;

                            if (addFoodProvider.postState.status ==
                                PostStatus.error) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(CustomSnackBar(
                                  contentText:
                                      addFoodProvider.postState.errorMessage,
                                  context: context,
                                ));
                            } else if (addFoodProvider.postState.status ==
                                PostStatus.success) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(CustomSnackBar(
                                  contentText:
                                      'Berhasil menambahkan unggahan Makanan.',
                                  context: context,
                                ));

                              if (context.mounted) {
                                context.go('/main');
                              }

                              await foodProvider.fetchPosts();
                            }
                          },
                child: addFoodProvider.postState.status == PostStatus.loading
                    ? CustomProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 16.0,
                        strokeWidth: 2,
                      )
                    : Text(
                        'Unggah Makanan',
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
