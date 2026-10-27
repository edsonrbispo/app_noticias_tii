import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Sobre',
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logotipo.png',
                width: 280,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 28),

              // Descrição do aplicativo
              const Text(
                'Portal de Notícias é um aplicativo '
                'desenvolvido, que vai consumir uma API '
                'própria desenvolvida em Laravel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5B6B79),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
