class GameplayData {

  static List<List<int?>> winningPatternsGrid3 = [
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

static List<List<int>> winningPatternsGrid4 = [
    [0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15], // Rows
    [0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15], // Columns
    [0, 5, 10, 15], [3, 6, 9, 12] // Diagonals
  ];

}