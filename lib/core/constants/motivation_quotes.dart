import 'dart:math';

class MotivationQuotes {
  static const List<String> quotes = [
    "The secret of getting ahead is getting started.",
    "Quality is not an act, it is a habit.",
    "Don't watch the clock; do what it does. Keep going.",
    "Well done is better than well said.",
    "The only bad workout is the one that did not happen.",
    "You are what you repeatedly do. Excellence, then, is not an act, but a habit.",
    "Small daily improvements are the key to staggering long-term results.",
    "Discipline is choosing between what you want now and what you want most.",
    "Success is the sum of small efforts, repeated day in and day out.",
    "Your habits will determine your future.",
    "Motivation is what gets you started. Habit is what keeps you going.",
    "The chains of habit are too light to be felt until they are too heavy to be broken.",
    "Goals on cards are just dreams. Habits on the ground are reality.",
    "Consistency is more important than perfection.",
    "You don't rise to the level of your goals. You fall to the level of your systems.",
    "Every action you take is a vote for the person you wish to become.",
    "The best way to predict your future is to create it.",
    "A year from now you may wish you had started today.",
  ];

  static String getRandomQuote() {
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }
}
