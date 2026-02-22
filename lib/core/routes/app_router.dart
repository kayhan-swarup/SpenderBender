import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/setup_cash/setup_cash_screen.dart';
import '../../presentation/screens/add_account/add_account_screen.dart';
import '../../presentation/screens/all_transactions/all_transactions_screen.dart';
import '../../presentation/shared/bottom_navigation/main_bottom_nav.dart';
import '../../providers/account_provider.dart';
import '../../core/constants/app_constants.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) async {
          final accountRepo = ref.read(accountRepositoryProvider);
          final hasAccounts = await accountRepo.hasAccounts(AppConstants.defaultUserId);

          if (!hasAccounts) {
            return '/setup-cash';
          }
          return '/home';
        },
      ),
      GoRoute(
        path: '/setup-cash',
        builder: (context, state) => const SetupCashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainBottomNav(),
      ),
      GoRoute(
        path: '/add-account',
        builder: (context, state) => const AddAccountScreen(),
      ),
      GoRoute(
        path: '/all-transactions',
        builder: (context, state) => const AllTransactionsScreen(),
      ),
    ],
  );
});
