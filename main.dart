import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boite a Outils',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF00ADB5),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  bool _isTimerActive = false;
  double _seconds = 0.0;
  Timer? _timer;
  String _calcInput = "0";

  void _toggleTimer() {
    if (_isTimerActive) {
      _timer?.cancel();
      setState(() { _isTimerActive = false; });
    } else {
      _isTimerActive = true;
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() { _seconds += 0.1; });
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerActive = false;
      _seconds = 0.0;
    });
  }

  void _pressCalc(String value) {
    setState(() {
      if (value == "C") {
        _calcInput = "0";
      } else if (value == "=") {
        try {
          _calcInput = "Resultat"; 
        } catch (e) {
          _calcInput = "Erreur";
        }
      } else {
        _calcInput = _calcInput == "0" ? value : _calcInput + value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boite a Outils', style: TextStyle(color: Color(0xFF00ADB5), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // TÂCHES
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        decoration: const InputDecoration(filled: true, fillColor: Color(0xFF1E1E1E), hintText: 'Ajouter une tache...'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Color(0xFF00ADB5)),
                      onPressed: () {
                        if (_taskController.text.isNotEmpty) {
                          setState(() { _tasks.add(_taskController.text); _taskController.clear(); });
                        }
                      },
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) => Card(
                      color: const Color(0xFF1E1E1E),
                      child: ListTile(
                        title: Text(_tasks[index]),
                        trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => _tasks.removeAt(index))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TIMER
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${_seconds.toStringAsFixed(1)}s', style: const TextStyle(fontSize: 60, fontFamily: 'monospace')),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _toggleTimer,
                      style: ElevatedButton.styleFrom(backgroundColor: _isTimerActive ? Colors.orange : Colors.green),
                      child: Text(_isTimerActive ? 'Stop' : 'Start'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(onPressed: _resetTimer, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: const Text('Reset')),
                  ],
                )
              ],
            ),
          ),
          // CALCULATRICE
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8)),
                  child: Text(_calcInput, style: const TextStyle(fontSize: 36, fontFamily: 'monospace')),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: ['7','8','9','/','4','5','6','*','1','2','3','-','C','0','=','+'].map((btn) {
                      return ElevatedButton(
                        onPressed: () => _pressCalc(btn),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D2D2D)),
                        child: Text(btn, style: const TextStyle(fontSize: 20)),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF00ADB5),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E1E1E),
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Taches'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calc'),
        ],
      ),
    );
  }
}
