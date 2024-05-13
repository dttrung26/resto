// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:resto/screens/auth/components/sign_in_form.dart';
// import 'package:resto/screens/authentication/sign_in/sign_in_form.dart';
// import 'package:resto/screens/findRestaurants/find_restaurants_screen.dart';

// void main() {
//   testWidgets('Test SignInForm widget', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: Scaffold(body: SignInForm())));
//     expect(find.byType(TextFormField), findsNWidgets(2));
//     await tester.enterText(
//         find.byType(TextFormField).first, 'example@email.com');
//     expect(find.text('Password'), findsOneWidget);
//     await tester.enterText(find.byType(TextFormField).last, 'password123');
//     await tester.tap(find.text('Sign in'));
//     await tester.pump();

//     expect(find.byType(FindRestaurantsScreen), findsOneWidget);
//   });
// }
