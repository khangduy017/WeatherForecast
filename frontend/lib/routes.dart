import 'package:flutter/material.dart';
import 'package:frontend/ui/email_subscription_screen/email_subscription_screen.dart';
import 'package:frontend/ui/home_screen/home_screen.dart';
import 'package:frontend/ui/weather_history_screen/weather_history_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
        routes: [
          GoRoute(
            path: 'weather-history',
            name: 'weather-history',
            pageBuilder: (context, state) {
              return customTransitionPage(
                  state.pageKey, const WeatherHistoryScreen());
            },
          ),
          GoRoute(
            path: 'email-subscription',
            name: 'email-subscription',
            pageBuilder: (context, state) {
              return customTransitionPage(
                  state.pageKey, const EmailSubscriptionScreen());
            },
          ),
        ]),
  ],
);

CustomTransitionPage customTransitionPage(LocalKey key, Widget child) {
  return CustomTransitionPage(
      transitionDuration: const Duration(milliseconds: 250),
      key: key,
      child: child,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child);
      });
}
