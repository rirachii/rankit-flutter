// import 'package:flutter/material.dart';
// import 'package:supabase/supabase.dart';

// class ResetPasswordDialog extends StatefulWidget {
//   final SupabaseClient client;

//   ResetPasswordDialog({required this.client});

//   @override
//   _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
// }

// class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
//   final _emailController = TextEditingController();

//   Future<void> _resetPassword() async {
//     final email = _emailController.text.trim();

//     final response = await widget.client.auth.resetPasswordForEmail(email);

//     if (response.error == null) {
//       print('Password reset link sent');
//     } else {
//       print(response.error!.message);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Reset Password'),
//       content: TextField(
//         controller: _emailController,
//         decoration: InputDecoration(
//           labelText: 'Email',
//         ),
//         keyboardType: TextInputType.emailAddress,
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: Text('Cancel'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         TextButton(
//           child: Text('Reset Password'),
//           onPressed: _resetPassword,
//         ),
//       ],
//     );
//   }
// }
