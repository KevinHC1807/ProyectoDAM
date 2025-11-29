import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  // Centro por defecto (Tepic aprox)
  static const LatLng _center = LatLng(21.5010, -104.8940);

  // Ejemplo de puntos (luego los podemos leer de Firestore)
  final List<_FitPoint> _points = [
    _FitPoint(
      name: 'Parque La Loma',
      type: 'Parque',
      level: 'Principiante',
      description: 'Circuito para caminar, trotar y hacer ejercicio al aire libre.',
      position: const LatLng(21.5015, -104.8945),
    ),
    _FitPoint(
      name: 'Gym PowerFit',
      type: 'Gimnasio',
      level: 'Intermedio',
      description: 'Gimnasio con pesas, cardio y clases grupales.',
      position: const LatLng(21.5030, -104.8925),
    ),
  ];

  _FitPoint? _selectedPoint;

  void _centerOnDefault() {
    _mapController.move(_center, 14);
  }

  @override
  Widget build(BuildContext context) {
    const greenPrimary = Color(0xFF00D26A);
    const greenDark = Color(0xFF006B3F);

    return Scaffold(
      body: Stack(
        children: [
          // Mapa
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _center,
              initialZoom: 16,   // 👈 más cerca
              minZoom: 10,
              maxZoom: 19,
            ),
            children: [
              // Capa base de OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.proyecto_final',
              ),

              // Marcadores
              MarkerLayer(
                markers: _points.map((p) {
                  return Marker(
                    point: p.position,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPoint = p;
                        });
                      },
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Encabezado flotante
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [greenDark, greenPrimary],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Mapa de FitPoints',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Encuentra parques, gimnasios y puntos para entrenar cerca de ti.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Botón flotante para centrar
          Positioned(
            right: 16,
            bottom: 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Botón de zoom +
                FloatingActionButton(
                  heroTag: 'zoom_in_button',
                  backgroundColor: Colors.white,
                  mini: true,
                  onPressed: () {
                    final camera = _mapController.camera;
                    _mapController.move(
                      camera.center,
                      camera.zoom + 1, // 👈 acerca 1 nivel
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Botón de zoom -
                FloatingActionButton(
                  heroTag: 'zoom_out_button',
                  backgroundColor: Colors.white,
                  mini: true,
                  onPressed: () {
                    final camera = _mapController.camera;
                    _mapController.move(
                      camera.center,
                      camera.zoom - 1, // 👈 aleja 1 nivel
                    );
                  },
                  child: const Icon(
                    Icons.remove,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Botón de centrar
                FloatingActionButton(
                  heroTag: 'center_button',
                  backgroundColor: Colors.white,
                  mini: false,
                  onPressed: _centerOnDefault,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),


          // Tarjeta inferior con detalle del punto
          if (_selectedPoint != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.place, color: greenPrimary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedPoint!.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _selectedPoint = null;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_selectedPoint!.type} · Nivel: ${_selectedPoint!.level}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_selectedPoint!.description.isNotEmpty)
                        Text(
                          _selectedPoint!.description,
                          style: const TextStyle(fontSize: 13),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // Aquí después podríamos abrir detalle completo,
                              // iniciar navegación, etc.
                            },
                            icon: const Icon(Icons.fitness_center, size: 18),
                            label: const Text(
                              'Ver rutinas sugeridas',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Modelo sencillo para los puntos
class _FitPoint {
  final String name;
  final String type;
  final String level;
  final String description;
  final LatLng position;

  const _FitPoint({
    required this.name,
    required this.type,
    required this.level,
    required this.description,
    required this.position,
  });
}


