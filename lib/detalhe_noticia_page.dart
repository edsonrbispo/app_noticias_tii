import 'models/noticia.dart';
import 'package:flutter/material.dart';

class DetalheNoticiaPage extends StatelessWidget {
  final Noticia noticia;

  const DetalheNoticiaPage({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notícia'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              color: const Color(0xFFE4E9EF),
              child: noticia.imagem != null
                  ? Image.network(
                      noticia.imagem!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, erro, stack) =>
                          const Icon(Icons.image_outlined),
                    )
                  : const Icon(Icons.image_outlined),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4F8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          noticia.categoriaNome,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),

                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        noticia.dataFormatada,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    noticia.titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1b2a4a),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    noticia.resumo,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5B6B79),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
