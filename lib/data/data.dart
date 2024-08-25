class Data {

  static List<List<int?>> winningPatterns = [
  // Horizontal wins
  [0, 0, 0, null, null, null, null, null, null], // Top Row
  [null, null, null, 0, 0, 0, null, null, null], // Middle Row
  [null, null, null, null, null, null, 0, 0, 0], // Bottom Row

  // Vertical wins
  [0, null, null, 0, null, null, 0, null, null], // Left Column
  [null, 0, null, null, 0, null, null, 0, null], // Middle Column
  [null, null, 0, null, null, 0, null, null, 0], // Right Column

  // Diagonal wins
  [0, null, null, null, 0, null, null, null, 0], // Top-left to Bottom-right
  [null, null, 0, null, 0, null, 0, null, null], // Top-right to Bottom-left
];

//0 for O, 1 for X
  static int userChoice = 0;

  
}