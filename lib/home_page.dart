import 'package:app_noticias_tii/detalhe_noticia_page.dart';
import 'package:app_noticias_tii/login_page.dart';
import 'package:app_noticias_tii/models/categoria.dart';
import 'package:app_noticias_tii/models/noticia.dart';
import 'package:app_noticias_tii/services/categoria_service.dart';
import 'package:app_noticias_tii/services/login_services.dart';
import 'package:app_noticias_tii/services/noticia_service.dart';
import 'package:app_noticias_tii/sobre_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NoticiaService _noticiaService = NoticiaService();
  late Future<List<Noticia>> _listaNoticias;

  final CategoriaService _categoriaService = CategoriaService();

  final LoginServices _loginServices = LoginServices();

  List<Categoria> _listaCategorias = [];
  String _categoriaSelecionada = 'Todas';

  String _textoPesquisa = '';
  bool _buscando = false;

  bool _logado = false;

  @override
  void initState() {
    super.initState();
    _listaNoticias = _noticiaService.getNoticias();
    carregarCategorias();
    _checarSessao();
  }

  Future<void> _checarSessao() async {
    final token = await _loginServices.getToken();
    if (mounted) {
      setState(() {
        _logado = token != null;
      });
    }
  }

  Future<void> carregarCategorias() async {
    try {
      final categorias = await _categoriaService.getCategorias();
      setState(() {
        _listaCategorias = categorias;
      });
    } catch (e) {
      debugPrint('Erro ao carregar a categorias: $e');
    }
  }

  List<Noticia> aplicarFiltro(List<Noticia> noticias) {
    if (_textoPesquisa.isNotEmpty) {
      return noticias.where((noticia) {
        return noticia.titulo.toLowerCase().contains(
              _textoPesquisa.toLowerCase(),
            ) ||
            noticia.resumo.toLowerCase().contains(_textoPesquisa.toLowerCase());
      }).toList();
    }

    if (_categoriaSelecionada != 'Todas') {
      return noticias.where((noticia) {
        return noticia.categoriaNome == _categoriaSelecionada;
      }).toList();
    }

    return noticias;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buscando
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar...',
                ),
                onChanged: (valor) {
                  setState(() {
                    _textoPesquisa = valor;
                  });
                },
              )
            : Image.asset(
                'assets/img/logotipo.png',
                height: 20,
              ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _buscando = !_buscando;
                  if (!_buscando) {
                    _textoPesquisa = "";
                  }
                });
              },
              icon: Icon(_buscando ? Icons.close : Icons.search),
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Image.asset('assets/img/logotipo.png'),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SobrePage()),
                );
              },
            ),

            const Divider(),
            if (_logado)
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () async {
                  await _loginServices.logout();
                  if (mounted) {
                    Navigator.pop(context);
                    setState(() {
                      _logado = false;
                    });
                  }
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Entrar'),
                onTap: () async {
                  Navigator.pop(context);
                  final entrou = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  if (entrou == true) {
                    setState(() {
                      _logado = true;
                    });
                  }
                },
              ),
          ],
        ),
      ),

      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: ListView.builder(
              itemCount: _listaCategorias.length + 1,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (context, index) {
                final categoria = index == 0
                    ? 'Todas'
                    : _listaCategorias[index - 1].nome;

                final selecionada = _categoriaSelecionada == categoria;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _categoriaSelecionada = categoria;
                    });
                  },
                  child: Container(
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
                  ),
                );
              },
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

                final todasNoticias = asyncSnapshot.data ?? [];

                final noticias = aplicarFiltro(todasNoticias);

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

                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalheNoticiaPage(noticia: noticia),
                        ),
                      ),

                      child: Card(
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
