import 'package:app_noticias_tii/models/noticia.dart';
import 'package:app_noticias_tii/services/noticia_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NoticiaService _noticiaService = NoticiaService();
  late Future<List<Noticia>> _listaNoticias;

  @override
  void initState() {
    super.initState();
    _listaNoticias = _noticiaService.getNoticias();
  }

  static final List<String> categorias = [
    'Todas',
    'Tecnologia',
    'Educação',
    'Economia',
    'Esporte',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/img/logotipo.png',
          height: 20,
        ),
        centerTitle: true,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: categorias.map((categoria) {
                final selecionada = categoria == "Todas";
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selecionada
                          ? Colors.black
                          : const Color(0xFFEDEDED),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    categoria,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _listaNoticias,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (asyncSnapshot.hasError) {
                  return Center(
                    child: Text('${asyncSnapshot.error}'),
                  );
                }

                final noticias = asyncSnapshot.data ?? [];

                if (noticias.isEmpty) {
                  return const Center(
                    child: Text('Nenhum Notícia Encontrada'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: noticias.length,
                  itemBuilder: (context, index) {
                    final noticia = noticias[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Colors.white,
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color(0xFFCBD2D9),
                        ),
                      ),
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
