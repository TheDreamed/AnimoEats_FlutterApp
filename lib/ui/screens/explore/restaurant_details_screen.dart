import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_ninja/bloc/profile/profile_bloc.dart';
import 'package:food_ninja/bloc/restaurant/restaurant_bloc.dart';
import 'package:food_ninja/models/food.dart';
import 'package:food_ninja/models/restaurant.dart';
import 'package:food_ninja/ui/widgets/buttons/like_button.dart';
import 'package:food_ninja/ui/widgets/food_card.dart';
import 'package:food_ninja/ui/widgets/image_placeholder.dart';
import 'package:food_ninja/ui/widgets/items/testimonial_item.dart';
import 'package:food_ninja/utils/app_colors.dart';
import 'package:food_ninja/utils/app_styles.dart';
import 'package:food_ninja/utils/custom_text_style.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final List<Food> foods = [];
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RestaurantBloc>(context).add(
      LoadRestaurantFoods(widget.restaurant.foodList),
    );
    BlocProvider.of<RestaurantBloc>(context).add(
      FetchOrderCount(restaurantId: widget.restaurant.id!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.secondaryColor,
              ),
            ),
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background: widget.restaurant.image != null
                      ? Image.network(
                          widget.restaurant.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              ImagePlaceholder(
                            iconData: Icons.restaurant,
                            iconSize: 100,
                          ),
                        )
                      : ImagePlaceholder(
                          iconData: Icons.restaurant,
                          iconSize: 100,
                        ),
                ),
                //Border radius
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 34,
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 34,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: AppStyles.largeBorderRadius,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor.withOpacity(0.1),
                                AppColors.primaryDarkColor.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                colors: AppColors.primaryGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(rect);
                            },
                            child: Text(
                              'Popular',
                              style: CustomTextStyle.size14Weight400Text(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          "assets/svg/location.svg",
                        ),
                        const SizedBox(width: 12),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            return LikeButton(
                              isLiked: widget.restaurant.isFavorite,
                              onTap: () {
                                BlocProvider.of<ProfileBloc>(context).add(
                                  ToggleFavoriteRestaurant(
                                    restaurantId: widget.restaurant.id!,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    widget.restaurant.name,
                    style: CustomTextStyle.size27Weight600Text(),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svg/star.svg",
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${widget.restaurant.rating} Rating",
                        style: CustomTextStyle.size14Weight400Text(
                          AppColors.grayColor.withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(width: 25),
                      SvgPicture.asset(
                        "assets/svg/shopping-bag.svg",
                      ),
                      const SizedBox(width: 10),
                      BlocBuilder<RestaurantBloc, RestaurantState>(
                        builder: (context, state) {
                          if (state is OrderCountFetched) {
                            return Text(
                              "${state.count} ${state.count == 1 ? "Order" : "Orders"}",
                              style: CustomTextStyle.size14Weight400Text(
                                AppColors.grayColor.withOpacity(0.3),
                              ),
                            );
                          }
                          return Text(
                            "0 Orders",
                            style: CustomTextStyle.size14Weight400Text(
                              AppColors.grayColor.withOpacity(0.3),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // description
                  widget.restaurant.description != null &&
                          widget.restaurant.description!.isNotEmpty
                      ? Text(
                          widget.restaurant.description!,
                          style: CustomTextStyle.size14Weight400Text(),
                        )
                      : Center(
                          child: Text(
                            "No description available",
                            style: CustomTextStyle.size14Weight400Text(
                              AppColors.grayColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),

                  // menu
                  Text(
                    "Menu",
                    style: CustomTextStyle.size18Weight600Text(),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<RestaurantBloc, RestaurantState>(
                    builder: (context, state) {
                      if (state is RestaurantFoodsLoaded) {
                        foods.clear();
                        foods.addAll(state.foods);
                      }
                      return foods.isNotEmpty
                          ? SizedBox(
                              height: 190,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                children: foods
                                    .map(
                                      (food) => Row(
                                        children: [
                                          FoodCard(
                                            food: food,
                                          ),
                                          const SizedBox(width: 20),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          : Center(
                              child: Text(
                                "No foods available",
                                style: CustomTextStyle.size14Weight400Text(
                                  AppColors.grayColor.withOpacity(0.3),
                                ),
                              ),
                            );
                    },
                  ),
                  const SizedBox(height: 20),

                  // testimonials
                  Text(
                    "Testimonials",
                    style: CustomTextStyle.size18Weight600Text(),
                  ),
                  const SizedBox(height: 20),
                  widget.restaurant.testimonials.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.restaurant.testimonials.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return TestimonialItem(
                              testimonial:
                                  widget.restaurant.testimonials[index],
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "No testimonials available",
                            style: CustomTextStyle.size14Weight400Text(
                              AppColors.grayColor.withOpacity(0.3),
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
