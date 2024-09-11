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
  // Horizontal lines
  [0, 1, 2], [1, 2, 3], [4, 5, 6], [5, 6, 7], 
  [8, 9, 10], [9, 10, 11], [12, 13, 14], [13, 14, 15],
  
  // Vertical lines
  [0, 4, 8], [4, 8, 12], [1, 5, 9], [5, 9, 13],
  [2, 6, 10], [6, 10, 14], [3, 7, 11], [7, 11, 15],
  
  // Diagonals
  [0, 5, 10, 15], // Top-left to bottom-right (main diagonal)
  [3, 6, 9, 12],  // Top-right to bottom-left (anti-diagonal)
  [0, 6, 12],     // Off-center diagonal
  [1, 7, 13],     // Another off-center diagonal
  [2, 8, 14],     // Off-center diagonal from 2 to 14
  [3, 9, 15]      // Off-center diagonal from 3 to 15
];


  static List<List<int>> winningPatternsGrid5 = [
  // ---- 4 in a Row ----

  // Rows (4 in a row)
  [0, 1, 2, 3], [1, 2, 3, 4], // Row 1
  [5, 6, 7, 8], [6, 7, 8, 9], // Row 2
  [10, 11, 12, 13], [11, 12, 13, 14], // Row 3
  [15, 16, 17, 18], [16, 17, 18, 19], // Row 4
  [20, 21, 22, 23], [21, 22, 23, 24], // Row 5
  
  // Columns (4 in a row)
  [0, 5, 10, 15], [5, 10, 15, 20], // Column 1
  [1, 6, 11, 16], [6, 11, 16, 21], // Column 2
  [2, 7, 12, 17], [7, 12, 17, 22], // Column 3
  [3, 8, 13, 18], [8, 13, 18, 23], // Column 4
  [4, 9, 14, 19], [9, 14, 19, 24], // Column 5

  // Diagonals (4 in a row)
  [0, 6, 12, 18], [1, 7, 13, 19], // Main diagonal 1
  [5, 11, 17, 23], [4, 8, 12, 16], [9, 13, 17, 21], // Anti-diagonals

  // ---- 5 in a Row ----

  // Rows (5 in a row)
  [0, 1, 2, 3, 4], // Row 1
  [5, 6, 7, 8, 9], // Row 2
  [10, 11, 12, 13, 14], // Row 3
  [15, 16, 17, 18, 19], // Row 4
  [20, 21, 22, 23, 24], // Row 5
  
  // Columns (5 in a row)
  [0, 5, 10, 15, 20], // Column 1
  [1, 6, 11, 16, 21], // Column 2
  [2, 7, 12, 17, 22], // Column 3
  [3, 8, 13, 18, 23], // Column 4
  [4, 9, 14, 19, 24], // Column 5
  
  // Diagonals (5 in a row)
  [0, 6, 12, 18, 24], // Main diagonal
  [4, 8, 12, 16, 20], // Anti-diagonal
];



}