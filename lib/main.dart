import 'package:flutter/material.dart';

// ==========================================
// 1. CONFIGURACIÓN VISUAL (COLORES Y TEMA)
// ==========================================
class AppColors {
  static const Color background = Color(0xFF0D0D0D); // Fondo casi negro
  static const Color primary = Color(0xFFE50914);    // Rojo Streaming
  static const Color card = Color(0xFF262626);       // Gris oscuro (Tarjetas)
  static const Color input = Color(0xFF333333);      // Gris Input
  static const Color textMain = Colors.white;
  static const Color textSec = Color(0xFFB3B3B3);    // Gris texto secundario
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streaming App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        fontFamily: 'Inter', // Asegúrate de tener esta fuente o usará la por defecto
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.card,
        ),
      ),
      // PUNTO DE PARTIDA: PANTALLA DE LOGIN
      home: const LoginScreen(),
    );
  }
}

// ==========================================
// 2. PANTALLA: LOGIN (VALIDACIÓN + SUSCRIPCIÓN)
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _handleLogin() {
    final String email = _emailController.text.trim();
    final String pass = _passController.text.trim();

    // 1. Validar vacíos
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Ingrese las credenciales"),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    // 2. Validar credenciales demo
    if (email == "demo@example.com" && pass == "demo1234") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilesScreen()));
    } else {
      // 3. Error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Usuario o contraseña incorrectos"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("STREAM", style: TextStyle(fontSize: 45, fontWeight: FontWeight.w900, color: AppColors.primary)),
              const SizedBox(height: 8),
              const Text("Disfruta donde quieras.", style: TextStyle(color: AppColors.textSec, fontSize: 16)),
              const SizedBox(height: 40),

              // Inputs
              _buildInput("Email (demo@example.com)", _emailController),
              const SizedBox(height: 16),
              _buildInput("Contraseña (demo1234)", _passController, obscure: true),

              const SizedBox(height: 24),

              // Botón Iniciar Sesión
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: _handleLogin,
                  child: const Text("INICIAR SESIÓN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 20),
              const Text("¿Primera vez en Stream?", style: TextStyle(color: AppColors.textSec, fontSize: 14)),
              const SizedBox(height: 10),

              // Botón Suscríbete
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Flujo Nuevo Usuario -> Suscripción
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()));
                  },
                  child: const Text("SUSCRÍBETE AHORA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),
              const Text("Recuperar contraseña", style: TextStyle(color: AppColors.textSec)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController ctrl, {bool obscure = false}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.input,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSec),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }
}

// ==========================================
// 3. PANTALLA: SELECCIÓN DE PERFILES
// ==========================================
class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = [
      {"name": "Papá", "color": Colors.redAccent},
      {"name": "Mamá", "color": Colors.blueAccent},
      {"name": "Niños", "color": Colors.amber},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: const Text("STREAM", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(onPressed: (){}, child: const Text("Editar", style: TextStyle(color: Colors.white)))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿Quién está viendo?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            const SizedBox(height: 40),

            // Grilla
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                ...profiles.map((p) => _buildProfileAvatar(context, p["name"] as String, p["color"] as Color)),
                // Botón Agregar
                _buildAddProfile(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, String name, Color color) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainWrapper())),
      child: Column(
        children: [
          Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))
          ),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(color: AppColors.textSec)),
        ],
      ),
    );
  }

  Widget _buildAddProfile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Al tocar +, vamos a Crear Perfil
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProfileScreen()));
      },
      child: Column(
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(4)),
            child: const Icon(Icons.add, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 10),
          const Text("Agregar", style: TextStyle(color: AppColors.textSec)),
        ],
      ),
    );
  }
}

// ==========================================
// 4. FLUJO DE SUSCRIPCIÓN (Plan -> Crear Perfil)
// ==========================================
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlanIndex = 1;
  final _plans = const [
    {"name": "Básico", "price": "\$5.99", "q": "Buena - 720p"},
    {"name": "Estándar", "price": "\$9.99", "q": "Muy buena - 1080p"},
    {"name": "Premium", "price": "\$14.99", "q": "La mejor - 4K+HDR"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Elige tu plan", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const Text("Cancela cuando quieras.", style: TextStyle(color: AppColors.textSec)),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  itemCount: _plans.length,
                  separatorBuilder: (_,__) => const SizedBox(height: 15),
                  itemBuilder: (_, index) {
                    final plan = _plans[index];
                    final isSelected = _selectedPlanIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPlanIndex = index),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected ? null : Border.all(color: AppColors.card, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(plan["name"]!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(plan["q"]!, style: TextStyle(color: isSelected ? Colors.white : AppColors.textSec)),
                            ]),
                            Text(plan["price"]!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProfileScreen())),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                  child: const Text("CONTINUAR"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Crear Perfil"),
            GestureDetector(
              // Al guardar, vamos directo a la APP principal
              onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainWrapper()), (r) => false),
              child: const Text("Guardar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(8))),
            const SizedBox(height: 10),
            const Text("CAMBIAR", style: TextStyle(color: AppColors.textSec)),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(
                  filled: true, fillColor: AppColors.input,
                  hintText: "Nombre", hintStyle: const TextStyle(color: AppColors.textSec),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 5. NAVEGADOR PRINCIPAL (Bottom Nav)
// ==========================================
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),         // Index 0
    SearchScreen(),       // Index 1
    DownloadsScreen(),    // Index 2
    UserProfileScreen(),  // Index 3 (Detalles Perfil)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        height: 75,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.95),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10, offset: const Offset(0, 5))]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(Icons.home, 0),
            _navItem(Icons.search, 1),
            _navItem(Icons.download, 2),
            _navItem(Icons.person, 3), // Este lleva a la pantalla de usuario
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    bool active = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Icon(icon, color: active ? Colors.white : AppColors.textSec, size: 28),
    );
  }
}

// ==========================================
// 6. PANTALLAS PRINCIPALES (TABS)
// ==========================================

// --- TAB 1: HOME ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(height: 500, color: const Color(0xFF4D1A1A), child: const Center(child: Icon(Icons.movie_creation, size: 100, color: Colors.white12))),
              Container(height: 500, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, AppColors.background], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("ORIGINAL SERIES", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, height: 1)),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MovieDetailScreen())),
                    icon: const Icon(Icons.play_arrow), label: const Text("Reproducir"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                  )
                ]),
              )
            ],
          ),
          _list("Tendencias"),
          _list("Mi Lista"),
        ],
      ),
    );
  }
  Widget _list(String title) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(padding: const EdgeInsets.all(20), child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
      SizedBox(height: 160, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 20), scrollDirection: Axis.horizontal, itemCount: 5, separatorBuilder: (_,__) => const SizedBox(width: 10), itemBuilder: (_,__) => Container(width: 110, color: AppColors.card)))
    ],
  );
}

// --- TAB 2: SEARCH ---
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final genres = ["Acción", "Comedia", "Drama", "Terror"];
    final colors = [Colors.red[900], Colors.blue[900], Colors.yellow[900], Colors.green[900]];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(decoration: InputDecoration(filled: true, fillColor: AppColors.card, prefixIcon: const Icon(Icons.search), hintText: "Buscar...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.8, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: genres.length,
                itemBuilder: (_, i) => Container(alignment: Alignment.bottomLeft, padding: const EdgeInsets.all(10), color: colors[i], child: Text(genres[i], style: const TextStyle(fontWeight: FontWeight.bold))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- TAB 3: DOWNLOADS ---
class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text("Descargas")),
      body: ListView(
        children: [
          ListTile(
            leading: Container(width: 100, height: 60, color: AppColors.card),
            title: const Text("Stranger Codes"),
            subtitle: const Text("1.2 GB"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          )
        ],
      ),
    );
  }
}

// --- TAB 4: USER PROFILE (DETALLES DEL PERFIL) ---
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.redAccent.shade700, borderRadius: BorderRadius.circular(8))),
                const SizedBox(height: 10),
                const Text("Papá", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                TextButton.icon(onPressed: (){}, icon: const Icon(Icons.edit, size: 16, color: Colors.grey), label: const Text("Administrar perfiles", style: TextStyle(color: Colors.grey))),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                _menuItem(Icons.check, "Mi Lista"),
                _menuItem(Icons.settings, "Configuración"),
                _menuItem(Icons.person_outline, "Cuenta"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false),
            child: const Text("Cerrar Sesión", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
          const SizedBox(height: 80), // Padding navbar
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(leading: Icon(icon, color: Colors.white), title: Text(title, style: const TextStyle(color: Colors.white)), trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey));
  }
}

// ==========================================
// 7. PANTALLA DETALLE PELÍCULA
// ==========================================
class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 300, color: const Color(0xFF1A334D), child: Stack(children: [Center(child: Icon(Icons.play_circle, size: 60, color: Colors.white54)), Positioned(top: 50, left: 20, child: BackButton(color: Colors.white))])),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("THE CYBER SPACE", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(children: [const Text("2024", style: TextStyle(color: Colors.grey)), const SizedBox(width: 10), Container(padding: const EdgeInsets.all(4), color: Colors.grey, child: const Text("16+", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))]),
                const SizedBox(height: 20),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.play_arrow), label: const Text("Reproducir"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black))),
                const SizedBox(height: 20),
                const Text("Sinopsis de la película futurista aquí.", style: TextStyle(color: Colors.grey, fontSize: 14)),
              ]),
            )
          ],
        ),
      ),
    );
  }
}