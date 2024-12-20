import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ThemeProvider.dart';

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte de profil'),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          Row(
            children: [
              if (!isDarkMode) const Icon(Icons.wb_sunny, color: Colors.yellow),
              Switch(
                value: isDarkMode,
                onChanged: themeProvider.toggleTheme,
                activeColor: Colors.black,
              ),
              if (isDarkMode) const Icon(Icons.nightlight_round, color: Colors.yellow),
            ],
          ),
        ],
      ),
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _getProfileCard(context, Theme.of(context).textTheme.bodyMedium!.color!),
            Positioned(
              top: -50,
              left: 0,
              right: 0,
              child: _getAvatar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getProfileCard(BuildContext context, Color textColor) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 60),
          Text(
            "Judas Bricot",
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _socialMediaRow(
            'https://cdn4.iconfinder.com/data/icons/social-media-logos-6/512/112-gmail_email_mail-512.png',
            "judas.bricot@mail.fr",
            textColor,
          ),
          const SizedBox(height: 8),
          _socialMediaRow(
            'https://www.omnicoreagency.com/wp-content/uploads/2018/09/Instagram-Logo-PNG-2018.png',
            "judas.bricot",
            textColor,
          ),
          const SizedBox(height: 8),
          _socialMediaRow(
            'https://cdn.iconscout.com/icon/free/png-256/free-github-40-432516.png',
            "judasbricot",
            textColor,
          ),
        ],
      ),
    );
  }

  Widget _getAvatar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.deepOrangeAccent,
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 70,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Image.network(
            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
            fit: BoxFit.cover,
            width: 140,
            height: 140,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 50, color: Colors.red);
            },
          ),
        ),
      ),
    );
  }

  Widget _socialMediaRow(String logoUrl, String text, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          logoUrl,
          width: 20,
          height: 20,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, size: 20, color: Colors.red);
          },
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}