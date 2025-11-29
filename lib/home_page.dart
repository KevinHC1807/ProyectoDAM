import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'map_page.dart';
import 'login_page.dart';

const Color kGreenPrimary = Color(0xFF00D26A);
const Color kGreenDark = Color(0xFF006B3F);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 4 páginas = 4 items en el BottomNavigationBar
    final pages = <Widget>[
      const _DashboardPage(),          // 0
      const MapPage(),                 // 1: Mapa (OSM)
      const _RoutinesPlaceholderPage(),// 2
      _ProfilePage(
        onLogout: () async {
          await _authService.logout();
        },
      ),                               // 3
    ];


    final titles = <String>[
      'Inicio',
      'Mapa',
      'Rutinas',
      'Perfil',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenDark,
        title: Text(
          'FitPoints - ${titles[_currentIndex]}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: kGreenPrimary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Rutinas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

//
//  ---------- PÁGINA INICIO (DASHBOARD) ----------
//

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Header degradado
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [kGreenDark, kGreenPrimary],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hola 👋',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Bienvenido a FitPoints',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Empieza tu día con una buena rutina o encuentra un lugar '
                    'para entrenar cerca de ti.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Tarjetas rápidas
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _HomeCard(
                  icon: Icons.map,
                  title: 'Mapa de puntos',
                  subtitle: 'Ver lugares para entrenar',
                  onTap: () {
                    // Aquí podrías navegar al tab de Mapa cambiando el índice
                    // usando un callback si lo necesitas.
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HomeCard(
                  icon: Icons.fitness_center,
                  title: 'Rutinas',
                  subtitle: 'Ver entrenamientos',
                  onTap: () {
                    // Similar: cambiar a la pestaña de rutinas si quieres
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _HomeCard(
            icon: Icons.directions_walk,
            title: 'Podómetro',
            subtitle: 'Revisa tus pasos de hoy',
            onTap: () {
              // Aquí luego enlazamos al módulo de pasos
            },
          ),
        ),

        const SizedBox(height: 24),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Hoy para ti',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: const [
              _RoutineItem(
                title: 'Rutina Full Body 20 min',
                level: 'Principiante',
                type: 'Sin equipo',
              ),
              _RoutineItem(
                title: 'Cardio en parque',
                level: 'Intermedio',
                type: 'Running / Caminata',
              ),
              _RoutineItem(
                title: 'Fuerza en barra',
                level: 'Avanzado',
                type: 'Calistenia',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: kGreenPrimary.withOpacity(0.15),
              child: Icon(icon, color: kGreenPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineItem extends StatelessWidget {
  final String title;
  final String level;
  final String type;

  const _RoutineItem({
    required this.title,
    required this.level,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.bolt, color: kGreenPrimary),
        title: Text(title),
        subtitle: Text('$level · $type'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Más adelante abrimos el detalle de la rutina
        },
      ),
    );
  }
}

//
//  ---------- PLACEHOLDER RUTINAS ----------
//

class _RoutinesPlaceholderPage extends StatelessWidget {
  const _RoutinesPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Aquí irán las rutinas de ejercicio 💪',
        textAlign: TextAlign.center,
      ),
    );
  }
}

//
//  ---------- PERFIL + CERRAR SESIÓN ----------
//

class _ProfilePage extends StatelessWidget {
  final Future<void> Function() onLogout;

  const _ProfilePage({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perfil',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aquí luego mostraremos tus datos (nombre, correo, edad) '
                'y si eres admin, accesos al módulo de administración.',
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await onLogout();
                // Navegar al login y limpiar historial
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'FitPoints',
              style: TextStyle(
                color: kGreenPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


