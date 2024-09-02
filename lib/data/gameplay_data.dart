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
    [0, 5, 10, 15], [3, 6, 9, 12], // Diagonals

  // Horizontal patterns
  [0, 1, 2], [1, 2, 3],
  [4, 5, 6], [5, 6, 7],
  [8, 9, 10], [9, 10, 11],
  [12, 13, 14], [13, 14, 15],

  // Vertical patterns
  [0, 4, 8], [4, 8, 12],
  [1, 5, 9], [5, 9, 13],
  [2, 6, 10], [6, 10, 14],
  [3, 7, 11], [7, 11, 15],

  // Diagonal patterns
  [0, 5, 10], [5, 10, 15],
  [3, 6, 9], [6, 9, 12],
  ];

  static List<List<int>> winningPatternsGrid5 = [
  // Rows
  [0, 1, 2, 3, 4], [5, 6, 7, 8, 9], [10, 11, 12, 13, 14], [15, 16, 17, 18, 19], [20, 21, 22, 23, 24],
  
  // Columns
  [0, 5, 10, 15, 20], [1, 6, 11, 16, 21], [2, 7, 12, 17, 22], [3, 8, 13, 18, 23], [4, 9, 14, 19, 24],
  
  // Diagonals
  [0, 6, 12, 18, 24], [4, 8, 12, 16, 20],
  
  // Rows with three consecutive cells (winning with 3 in a row)
  [0, 1, 2], [1, 2, 3], [2, 3, 4], // Row 1
  [5, 6, 7], [6, 7, 8], [7, 8, 9], // Row 2
  [10, 11, 12], [11, 12, 13], [12, 13, 14], // Row 3
  [15, 16, 17], [16, 17, 18], [17, 18, 19], // Row 4
  [20, 21, 22], [21, 22, 23], [22, 23, 24], // Row 5
  
  // Columns with three consecutive cells (winning with 3 in a row)
  [0, 5, 10], [5, 10, 15], [10, 15, 20], // Column 1
  [1, 6, 11], [6, 11, 16], [11, 16, 21], // Column 2
  [2, 7, 12], [7, 12, 17], [12, 17, 22], // Column 3
  [3, 8, 13], [8, 13, 18], [13, 18, 23], // Column 4
  [4, 9, 14], [9, 14, 19], [14, 19, 24], // Column 5
  
  // Diagonals with three consecutive cells (winning with 3 in a row)
  [0, 6, 12], [6, 12, 18], [12, 18, 24], // Main diagonal 1
  [4, 8, 12], [8, 12, 16], [12, 16, 20], // Anti-diagonal 1
  [1, 7, 13], [5, 11, 17], [9, 13, 17], [3, 7, 11], [19, 13, 7], [7, 13, 19], // Other diagonals
];


}