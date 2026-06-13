import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/event_details_screen.dart';
import 'screens/seat_selection_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/booking_success_screen.dart';
import 'screens/my_bookings_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/settings_screen.dart'; // placeholder if missing
import 'screens/organizer/organizer_dashboard_screen.dart';
import 'screens/organizer/create_event_screen.dart';
import 'screens/organizer/edit_event_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String eventDetails = '/eventDetails';
  static const String seatSelection = '/seatSelection';
  static const String checkout = '/checkout';
  static const String bookingSuccess = '/bookingSuccess';
  static const String myBookings = '/myBookings';
  static const String bookings = '/bookings';
  static const String notifications = '/notifications';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';
  static const String profileEdit = '/profileEdit';
  static const String settings = '/settings';
  // Organizer screens
  static const String organizerDashboard = '/organizer/dashboard';
  static const String createEvent = '/organizer/createEvent';
  static const String editEvent = '/organizer/editEvent';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.splash: (_) => const SplashScreen(),
  AppRoutes.onboarding: (_) => const OnboardingScreen(),
  AppRoutes.login: (_) => const LoginScreen(),
  AppRoutes.register: (_) => const RegisterScreen(),
  AppRoutes.home: (_) => const HomeScreen(),
  AppRoutes.explore: (_) => const ExploreScreen(),
  AppRoutes.eventDetails: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return EventDetailsScreen(event: args['event']);
  },
  AppRoutes.seatSelection: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return SeatSelectionScreen(event: args['event']);
  },
  AppRoutes.checkout: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return CheckoutScreen(
      event: args['event'],
      selectedSeats: args['selectedSeats'],
    );
  },
  AppRoutes.bookingSuccess: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return BookingSuccessScreen(
      booking: args['booking'],
      event: args['event'],
      selectedSeats: args['selectedSeats'],
    );
  },
  AppRoutes.myBookings: (_) => const MyBookingsScreen(),
  AppRoutes.bookings: (_) => const BookingsScreen(),
  AppRoutes.notifications: (_) => const NotificationsScreen(),
  AppRoutes.wishlist: (_) => const WishlistScreen(),
  AppRoutes.profile: (_) => const ProfileScreen(),
  AppRoutes.profileEdit: (_) => const ProfileEditScreen(),
  AppRoutes.settings: (_) => const SettingsScreen(),
  AppRoutes.organizerDashboard: (_) => const OrganizerDashboardScreen(),
  AppRoutes.createEvent: (_) => const CreateEventScreen(),
  AppRoutes.editEvent: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return EditEventScreen(event: args?['event']);
  },
};
