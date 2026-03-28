import 'package:flutter/material.dart';

class HabitIcons {
  static const Map<String, List<IconData>> iconCategories = {
    'Health & Wellness': [
      Icons.water_drop,
      Icons.fitness_center,
      Icons.self_improvement,
      Icons.nightlight_round,
      Icons.restaurant,
      Icons.medication,
      Icons.monitor_weight,
      Icons.spa,
      Icons.favorite,
      Icons.healing,
      Icons.accessibility_new,
      Icons.bedtime,
      Icons.medical_services,
      Icons.visibility,
      Icons.clean_hands,
      Icons.sanitizer,
      Icons.bathtub,
      Icons.face,
      Icons.wash,
      Icons.pool,
    ],
    'Productivity & Work': [
      Icons.menu_book,
      Icons.psychology,
      Icons.edit,
      Icons.laptop,
      Icons.work,
      Icons.timer,
      Icons.event,
      Icons.note_alt,
      Icons.calculate,
      Icons.terminal,
      Icons.code,
      Icons.lightbulb,
      Icons.schedule,
      Icons.notifications_active,
      Icons.task_alt,
      Icons.inventory,
      Icons.mail,
      Icons.phone,
      Icons.groups,
      Icons.assignment,
    ],
    'Fitness & Sports': [
      Icons.directions_run,
      Icons.directions_bike,
      Icons.sports_basketball,
      Icons.sports_soccer,
      Icons.sports_tennis,
      Icons.run_circle, 
      Icons.hiking,
      Icons.surfing,
      Icons.kayaking,
      Icons.skateboarding,
      Icons.downhill_skiing,
      Icons.snowboarding,
      Icons.sports_gymnastics,
      Icons.sports_martial_arts,
      Icons.sports_handball,
      Icons.sports_volleyball,
      Icons.sports_kabaddi,
      Icons.sports_golf,
      Icons.sports_esports,
      Icons.stadium,
    ],
    'Finances': [
      Icons.savings,
      Icons.payments,
      Icons.account_balance,
      Icons.account_balance_wallet,
      Icons.receipt_long,
      Icons.pie_chart,
      Icons.show_chart,
      Icons.trending_up,
      Icons.attach_money,
      Icons.credit_card,
      Icons.monetization_on,
      Icons.shopping_cart,
      Icons.store,
      Icons.sell,
      Icons.loyalty,
    ],
    'Hobbies & Lifestyle': [
      Icons.camera_alt,
      Icons.music_note,
      Icons.videogame_asset,
      Icons.audiotrack,
      Icons.palette,
      Icons.brush,
      Icons.piano,
      Icons.movie,
      Icons.theater_comedy,
      Icons.castle,
      Icons.map,
      Icons.explore,
      Icons.flight,
      Icons.hotel,
      Icons.brunch_dining,
      Icons.coffee,
      Icons.local_bar,
      Icons.celebration,
      Icons.outdoor_grill,
      Icons.local_florist,
      Icons.eco,
      Icons.pets,
      Icons.auto_stories,
      Icons.draw,
      Icons.carpenter,
    ],
    'Household': [
      Icons.home,
      Icons.cleaning_services,
      Icons.iron,
      Icons.local_laundry_service,
      Icons.kitchen,
      Icons.grass,
      Icons.roofing,
      Icons.stroller,
      Icons.family_restroom,
      Icons.child_care,
    ],
  };

  static List<IconData> getAllIcons() {
    return iconCategories.values.expand((element) => element).toList();
  }

  static List<IconData> searchIcons(String query) {
    if (query.isEmpty) return getAllIcons();
    final lowerQuery = query.toLowerCase();
    
    // Simple mock search - in a real app, you'd map icons to keywords
    // For now, we'll return all icons if it's a generic search, or filter by category name
    List<IconData> results = [];
    iconCategories.forEach((category, icons) {
      if (category.toLowerCase().contains(lowerQuery)) {
        results.addAll(icons);
      }
    });

    if (results.isEmpty) {
      // If no category match, we just return a subset or all for now
      // Ideally we'd have a map of IconData -> Keywords
      return getAllIcons().take(50).toList(); 
    }
    
    return results;
  }
  
  // Mapping of common habit keywords to icons
  static final Map<IconData, List<String>> _iconKeywords = {
    Icons.water_drop: ['water', 'drink', 'hydrate', 'thirst'],
    Icons.fitness_center: ['gym', 'workout', 'weights', 'lift', 'exercise', 'fitness'],
    Icons.menu_book: ['read', 'study', 'learn', 'book', 'education'],
    Icons.self_improvement: ['meditate', 'zen', 'yoga', 'mindfulness', 'calm'],
    Icons.nightlight_round: ['sleep', 'rest', 'night', 'bed'],
    Icons.restaurant: ['eat', 'food', 'meal', 'diet', 'nutrition'],
    Icons.directions_run: ['run', 'cardio', 'walk', 'jog', 'sprint'],
    Icons.psychology: ['brain', 'mental', 'think', 'thought', 'logic'],
    Icons.savings: ['money', 'save', 'budget', 'finance', 'cash'],
    Icons.edit: ['write', 'journal', 'diary', 'noting'],
    Icons.laptop: ['work', 'code', 'office', 'computer'],
    Icons.directions_bike: ['cycle', 'bike', 'bicycle'],
    Icons.coffee: ['coffee', 'caffeine', ' morning'],
    Icons.pets: ['dog', 'cat', 'pet', 'animal', 'walk'],
    Icons.eco: ['nature', 'environment', 'green', 'plants'],
    Icons.cleaning_services: ['clean', 'house', 'tidy', 'chore'],
    Icons.palette: ['art', 'paint', 'draw', 'creative', 'color'],
    Icons.music_note: ['music', 'song', 'sing', 'instrument'],
    Icons.videogame_asset: ['game', 'play', 'gaming', 'esports'],
    Icons.shopping_cart: ['shop', 'buy', 'grocery', 'market'],
    Icons.flight: ['travel', 'trip', 'plane', 'vacation'],
    Icons.camera_alt: ['photo', 'picture', 'camera', 'photography'],
    Icons.calculate: ['math', 'numbers', 'accounting', 'calc'],
    Icons.code: ['program', 'develop', 'tech', 'software'],
    Icons.timer: ['focus', 'pomodoro', 'time', 'limit'],
    Icons.event: ['plan', 'schedule', 'date', 'calendar'],
    Icons.payments: ['bill', 'pay', 'expense'],
    Icons.receipt_long: ['tax', 'finance', 'invoice'],
    Icons.medication: ['pill', 'health', 'medicine', 'sick'],
    Icons.monitor_weight: ['lose', 'weight', 'scale'],
    Icons.spa: ['relax', 'massage'],
    Icons.favorite: ['love', 'heart', 'romance'],
    Icons.healing: ['recover', 'therapy'],
    Icons.accessibility_new: ['stretch', 'body'],
    Icons.bedtime: ['sleep', 'early'],
    Icons.medical_services: ['health', 'doctor', 'medicine'],
    Icons.visibility: ['eyes', 'vision'],
    Icons.clean_hands: ['wash', 'hygiene'],
    Icons.bathtub: ['shower', 'bath'],
    Icons.wash: ['clothes', 'laundry'],
    Icons.pool: ['swim'],
    Icons.work: ['job', 'office'],
    Icons.lightbulb: ['idea', 'creative'],
    Icons.inventory: ['stock', 'organization'],
    Icons.mail: ['email', 'letter'],
    Icons.phone: ['call', 'speak'],
    Icons.groups: ['people', 'social', 'family'],
    Icons.assignment: ['task', 'homework'],
    Icons.sports_basketball: ['basketball', 'hoop'],
    Icons.sports_soccer: ['soccer', 'football'],
    Icons.sports_tennis: ['tennis', 'racket'],
    Icons.hiking: ['mountain', 'climb', 'trail'],
    Icons.surfing: ['ocean', 'wave'],
    Icons.kayaking: ['boat', 'row'],
    Icons.skateboarding: ['skate', 'board'],
    Icons.snowboarding: ['snow', 'winter'],
    Icons.sports_martial_arts: ['karate', 'fight'],
    Icons.sports_golf: ['golf', 'club'],
    Icons.stadium: ['game', 'match'],
    Icons.account_balance: ['bank', 'investment'],
    Icons.account_balance_wallet: ['wallet', 'money'],
    Icons.pie_chart: ['report', 'stats'],
    Icons.show_chart: ['invest', 'grow'],
    Icons.credit_card: ['card', 'bank'],
    Icons.monetization_on: ['coin', 'gold'],
    Icons.store: ['business'],
    Icons.sell: ['price', 'discount'],
    Icons.loyalty: ['points', 'customer'],
    Icons.videocam: ['video', 'record'],
    Icons.brush: ['paint', 'art'],
    Icons.piano: ['instrument', 'music'],
    Icons.movie: ['film', 'cinema'],
    Icons.theater_comedy: ['acting', 'stage'],
    Icons.explore: ['compass', 'adventure'],
    Icons.hotel: ['sleep', 'stay'],
    Icons.brunch_dining: ['breakfast', 'food'],
    Icons.local_bar: ['drink', 'alcohol'],
    Icons.celebration: ['party', 'event'],
    Icons.outdoor_grill: ['bbq', 'cook'],
    Icons.grass: ['mow', 'yard', 'garden'],
    Icons.iron: ['clothes', 'press'],
    Icons.kitchen: ['cook', 'fridge'],
    Icons.stroller: ['baby', 'child'],
    Icons.child_care: ['nanny', 'kid'],
  };

  static List<IconData> searchByKeywords(String query) {
    if (query.isEmpty) return getAllIcons();
    final lowerQuery = query.toLowerCase();
    
    final Set<IconData> results = {};
    
    // First check keywords
    _iconKeywords.forEach((icon, keywords) {
      if (keywords.any((k) => k.contains(lowerQuery))) {
        results.add(icon);
      }
    });
    
    // Then check category names if results are low
    iconCategories.forEach((category, icons) {
      if (category.toLowerCase().contains(lowerQuery)) {
        results.addAll(icons);
      }
    });

    return results.toList();
  }
}
