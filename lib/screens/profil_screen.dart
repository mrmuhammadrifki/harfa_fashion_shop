import 'package:chatting_app/provider/firebase_auth_provider.dart';
import 'package:chatting_app/provider/shared_preference_provider.dart';
import 'package:chatting_app/static/firebase_auth_status.dart';
import 'package:chatting_app/static/screen_route.dart';
import 'package:chatting_app/utils/base_color.dart';
import 'package:chatting_app/utils/ext_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = context.watch<FirebaseAuthProvider>().profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: BaseColor.primary,
                backgroundImage: profile?.photoUrl != null
                    ? NetworkImage(profile!.photoUrl!)
                    : null,
                child: profile?.photoUrl == null
                    ? Text(
                        _getInitials(
                          profile?.name == null ||
                                  profile?.name?.isEmpty == true
                              ? profile?.email ?? ''
                              : profile?.name ?? '',
                        ),
                      ).spd28m().white()
                    : null,
              ),
              const SizedBox(height: 16),
              if (profile?.name?.isNotEmpty == true || profile?.name != null)
                Text(
                  profile?.name ?? '',
                ).spd20sm(),
              const SizedBox(height: 8),
              Text(
                profile?.email ?? '',
              ).spd16m().grey(),
              const SizedBox(height: 16),
              Consumer<FirebaseAuthProvider>(
                builder: (context, value, child) {
                  return switch (value.authStatus) {
                    FirebaseAuthStatus.signingOut => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    _ => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _tapToSignOut,
                          child: const Text('Logout'),
                        ),
                      ),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words =
        name.trim().split(' ').where((word) => word.isNotEmpty).toList();

    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }

    return '';
  }

  void _tapToSignOut() async {
    final sharedPreferenceProvider = context.read<SharedPreferenceProvider>();
    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    await firebaseAuthProvider.signOutUser().then((value) async {
      await sharedPreferenceProvider.logout();
      navigator.pushReplacementNamed(
        ScreenRoute.login.name,
      );
    }).whenComplete(() {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(firebaseAuthProvider.message ?? ""),
      ));
    });
  }
}
