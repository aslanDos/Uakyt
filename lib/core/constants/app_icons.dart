import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum AppIcon {
  archive('Archive', LucideIcons.archive),
  apple('Apple', LucideIcons.apple),
  milk('Milk', LucideIcons.milk),
  candy('Candy', LucideIcons.candy),
  chefHat('Chef hat', LucideIcons.chefHat),
  cupSoda('Cup', LucideIcons.cupSoda),
  drumstick('Drumstick', LucideIcons.drumstick),
  kebab('Kebab', LucideIcons.utensilsCrossed),
  salad('Salad', LucideIcons.salad),
  utensils('Utensils', LucideIcons.utensils),
  beef('Beef', LucideIcons.beef),
  soup('Soup', LucideIcons.soup),
  lollipop('Lollipop', LucideIcons.lollipop),
  cherry('Cherry', LucideIcons.cherry),
  egg('Egg', LucideIcons.egg),
  hamburger('Hamburger', LucideIcons.hamburger),
  banana('Banana', LucideIcons.banana),
  sandwich('Sandwich', LucideIcons.sandwich),
  wine('Wine', LucideIcons.wine),
  cake('Cake', LucideIcons.cake),
  carrot('Carrot', LucideIcons.carrot),
  coffee('Coffee', LucideIcons.coffee),
  eggFried('Fried egg', LucideIcons.eggFried),
  fish('Fish', LucideIcons.fish),
  cookingPot('Pot', LucideIcons.cookingPot),
  popcorn('Popcorn', LucideIcons.popcorn),
  basket('Basket', LucideIcons.shoppingBasket),
  beer('Beer', LucideIcons.beer),
  cakeSlice('Cake slice', LucideIcons.cakeSlice),
  pizza('Pizza', LucideIcons.pizza),
  iceCream('Ice cream', LucideIcons.iceCreamCone),
  cookie('Cookie', LucideIcons.cookie);

  const AppIcon(this.label, this.icon);

  final String label;
  final IconData icon;

  static AppIcon fromName(String name) {
    return AppIcon.values.firstWhere(
      (icon) => icon.name == name,
      orElse: () => AppIcon.archive,
    );
  }

  // static const List<AppIcon> food = [
  //   apple,
  //   milk,
  //   candy,
  //   chefHat,
  //   cupSoda,
  //   drumstick,
  //   kebab,
  //   salad,
  //   utensils,
  //   beef,
  //   soup,
  //   lollipop,
  //   cherry,
  //   egg,
  //   hamburger,
  //   banana,
  //   sandwich,
  //   wine,
  //   cake,
  //   carrot,
  //   coffee,
  //   eggFried,
  //   fish,
  //   cookingPot,
  //   popcorn,
  //   basket,
  //   beer,
  //   cakeSlice,
  //   pizza,
  //   iceCream,
  //   cookie,
  // ];
}
