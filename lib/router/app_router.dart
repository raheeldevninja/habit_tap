import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker_app/features/habits/presentation/habits_main_screen.dart';

import '../features/habits/presentation/home_screen.dart';
import '../features/habits/presentation/add_habit_screen.dart';
import '../features/habits/presentation/edit_habit_screen.dart';
import '../features/habits/presentation/habit_details_screen.dart';
import '../features/statistics/presentation/statistics_screen.dart';
import '../features/habits/presentation/habit_history_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/habits/presentation/icon_selection_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HabitsMainScreen();
          },
        ),
        GoRoute(
          path: '/add',
          builder: (BuildContext context, GoRouterState state) {
            return const AddHabitScreen();
          },
        ),
        GoRoute(
          path: '/edit/:id',
          builder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id']!;
            return EditHabitScreen(habitId: id);
          },
        ),
        GoRoute(
          path: '/details/:id',
          builder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id']!;
            return HabitDetailsScreen(habitId: id);
          },
        ),
        GoRoute(
          path: '/history/:id',
          builder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id']!;
            return HabitHistoryScreen(habitId: id);
          },
        ),
        GoRoute(
          path: '/statistics',
          builder: (BuildContext context, GoRouterState state) {
            return const StatisticsScreen();
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
        GoRoute(
          path: '/select-icon',
          builder: (BuildContext context, GoRouterState state) {
            return const IconSelectionScreen();
          },
        ),
      ],
    ),
  ],
);
