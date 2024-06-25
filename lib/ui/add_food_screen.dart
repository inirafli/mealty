import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealty/provider/add_food_provider.dart';
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

class AddFoodScreen extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? foodData;

  const AddFoodScreen({super.key, this.isEdit = false, this.foodData});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddFoodProvider>(context, listen: false)
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
                child: Consumer<AddFoodProvider>(
                  builder: (context, addFoodProvider, child) {
                    if (addFoodProvider.isLoading) {
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
                            imageFile: addFoodProvider.imageFile,
                            onImageRemove: addFoodProvider.removeImage,
                            onPickImageFromGallery:
                                addFoodProvider.pickImageFromGallery,
                            onCaptureImageWithCamera:
                                addFoodProvider.captureImageWithCamera,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
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
                                          addFoodProvider.nameController,
                                      descriptionController:
                                          addFoodProvider.descriptionController,
                                    ),
                                    const SizedBox(height: 24.0),
                                    FoodTypeSelector(
                                      selectedType:
                                          addFoodProvider.selectedFoodCategory,
                                      onSelectType:
                                          addFoodProvider.selectFoodCategory,
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
                                      selectedType:
                                          addFoodProvider.selectedSellingType,
                                      onSelectType:
                                          addFoodProvider.selectSellingType,
                                    ),
                                    const SizedBox(height: 24.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: PriceInput(
                                            controller:
                                                addFoodProvider.priceController,
                                            isEditable: addFoodProvider
                                                    .selectedSellingType ==
                                                'commercial',
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          child: StockInput(
                                            controller:
                                                addFoodProvider.stockController,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24.0),
                                    SaleTimeInput(
                                      controller:
                                          addFoodProvider.saleTimeController,
                                      onSelectDateTime:
                                          addFoodProvider.selectSaleTime,
                                      initialDateTime: addFoodProvider.saleTime,
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
                                    latitude: addFoodProvider.latitude,
                                    longitude: addFoodProvider.longitude,
                                    onLocationPicked:
                                        addFoodProvider.setLocation,
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
          child: Consumer2<AddFoodProvider, FoodProvider>(
            builder: (context, addFoodProvider, foodProvider, child) {
              return ElevatedButton(
                onPressed:
                    addFoodProvider.postState.status == PostStatus.loading
                        ? null
                        : () async {
                            if (widget.isEdit) {
                              await addFoodProvider
                                  .updateFoodPost(widget.foodData!['id']);
                            } else {
                              await addFoodProvider.addFoodPost();
                            }

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
                                  contentText: widget.isEdit
                                      ? 'Berhasil mengubah unggahan Makanan.'
                                      : 'Berhasil menambahkan unggahan Makanan.',
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
