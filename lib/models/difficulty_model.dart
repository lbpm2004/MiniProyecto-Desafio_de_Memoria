enum Difficulty {
  facil(rows: 4, cols: 3, name: "Fácil", colorDisplay: Colors.lightGreenAccent),
  medio(rows: 4, cols: 3, name: "Medio", colorDisplay: Colors.deepPurple[300]),
  dificil(rows: 4, cols: 3, name: "Difícil", colorDisplay: Colors.pink[300]);

  final int rows;
  final int cols;
  final String name;

  const Difficulty({required this.rows, required this.cols, required this.name, required this.colorDisplay});

  int get totalCards => rows * cols;
}