import 'dart:math';

import 'package:tic_tac_toe/data/gameplay_data.dart';

class GeneratePlayGridThree {

  // Easy move - Random available position
  int easyMove(List<int?> board) {
    List<int> emptySpots = [];

    for (int i = 0; i < board.length; i++) {
      if (board[i] == null) {
        emptySpots.add(i);
      }
    }

    if (emptySpots.isEmpty) {
      throw Exception("No empty spots available on the board");
    }

    Random random = Random();
    return emptySpots[random.nextInt(emptySpots.length)];
  }

  // Medium move - Try to win, else make an easy move
  int mediumMove(List<int?> board) {
    int currentPlayer = determineCurrentPlayer(board);

    // Try to win
    int? move = checkWinningMove(board, currentPlayer);
    if (move != null) {
      return move;
    }

    // Make an easy move if no winning move
    return easyMove(board);
  }

  // Hard move - Uses minimax algorithm to make the best move
  int hardMove(List<int?> board) {
    int currentPlayer = determineCurrentPlayer(board);
    return minimax(board, currentPlayer).index;
  }

  // Minimax algorithm to determine the best move
  Move minimax(List<int?> board, int player) {
    List<int> availableSpots = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == null) {
        availableSpots.add(i);
      }
    }

    // Check for terminal states (win, loss, draw)
    if (checkWinner(board, 1)) {
      return Move(score: 10);
    } else if (checkWinner(board, 0)) {
      return Move(score: -10);
    } else if (availableSpots.isEmpty) {
      return Move(score: 0);
    }

    // List to store all possible moves
    List<Move> moves = [];

    for (int spot in availableSpots) {
      // Create a move
      Move move = Move();
      move.index = spot;

      // Apply the move
      board[spot] = player;

      // Recursively evaluate the move
      if (player == 1) {
        move.score = minimax(board, 0).score;
      } else {
        move.score = minimax(board, 1).score;
      }

      // Undo the move
      board[spot] = null;

      // Add the move to the list of moves
      moves.add(move);
    }

    // Pick the best move
    Move bestMove = Move(index: -1, score: player == 1 ? -10000 : 10000);

    for (Move move in moves) {
      if ((player == 1 && move.score > bestMove.score) ||
          (player == 0 && move.score < bestMove.score)) {
        bestMove = move;
      }
    }

    return bestMove;
  }

  // Check if the player has won
  bool checkWinner(List<int?> board, int player) {
    List<List<int>> winningPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winningPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        return true;
      }
    }

    return false;
  }

  // Check for a winning move for the current player
  int? checkWinningMove(List<int?> board, int player) {
    List<List<int>> winningPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winningPatterns) {
      int count = 0;
      int? emptySpot;

      for (int i in pattern) {
        if (board[i] == player) {
          count++;
        } else if (board[i] == null) {
          emptySpot = i;
        }
      }

      if (count == 2 && emptySpot != null) {
        return emptySpot;
      }
    }

    return null;
  }

  // Determine whose turn it is based on the state of the board
  int determineCurrentPlayer(List<int?> board) {
    int countX = board.where((x) => x == 1).length;
    int countO = board.where((x) => x == 0).length;

    // If the counts are equal, it's X's (1) turn; otherwise, it's O's (0) turn
    return countX == countO ? 1 : 0;
  }
}

// Move class to represent a move with index and score
class Move {
  int index;
  int score;

  Move({this.index = -1, this.score = 0});
}













class GeneratePlayGridFour {

  // Easy move - Random available position
  int easyMove(List<int?> gameplayList) {
    final availablePositions = <int>[];
    for (int i = 0; i < gameplayList.length; i++) {
      if (gameplayList[i] == null) {
        availablePositions.add(i);
      }
    }
    return availablePositions[Random().nextInt(availablePositions.length)];
  }

  // Medium move - Try to win, else make an easy move
  int mediumMove(List<int?> gameplayList) {
    int currentPlayer = determineCurrentPlayer(gameplayList);

    // Check for a winning move first
    for (var pattern in GameplayData.winningPatternsGrid4) {
      int? winningPosition = findWinningPosition(gameplayList, pattern, currentPlayer);
      if (winningPosition != null) {
        return winningPosition;
      }
    }

    // If no winning move, return a random move (easy)
    return easyMove(gameplayList);
  }

  // Hard move - Improved strategy: Win, block, or strategic move
  int hardMove(List<int?> gameplayList) {
    int currentPlayer = determineCurrentPlayer(gameplayList);
    int opponent = (currentPlayer == 0) ? 1 : 0;

    // 1. Check for a winning move
    for (var pattern in GameplayData.winningPatternsGrid4) {
      int? winningPosition = findWinningPosition(gameplayList, pattern, currentPlayer);
      if (winningPosition != null) {
        return winningPosition;
      }
    }

    // 2. Block opponent's winning move
    for (var pattern in GameplayData.winningPatternsGrid4) {
      int? blockingPosition = findWinningPosition(gameplayList, pattern, opponent);
      if (blockingPosition != null) {
        return blockingPosition;
      }
    }

    // 3. Make the most strategic move
    return bestStrategicMove(gameplayList);
  }

  // Determines the current player based on the board state
  int determineCurrentPlayer(List<int?> gameplayList) {
  int countX = gameplayList.where((x) => x == 1).length;
  int countO = gameplayList.where((x) => x == 0).length;
  
  // X always plays first, so if the counts of X and O are equal, it's X's (1) turn. 
  // If X has more moves than O, it's O's (0) turn.
  return countX > countO ? 0 : 1;
}


  // Finds the winning position for the current player
  int? findWinningPosition(List<int?> gameplayList, List<int> pattern, int currentPlayer) {
  int count = 0;
  int? emptyPosition;

  for (var pos in pattern) {
    if (gameplayList[pos] == currentPlayer) {
      count++;
    } else if (gameplayList[pos] == null) {
      emptyPosition = pos;
    }
  }

  // Adjust to check for patterns of different lengths
  // If all but one of the positions in the pattern are filled by the current player, return the empty one
  if (count == pattern.length - 1 && emptyPosition != null) {
    return emptyPosition;
  }

  return null;
}


  // A helper to find the best available strategic move
  int bestStrategicMove(List<int?> gameplayList) {
    List<int> center = [5, 6, 9, 10];  // 4x4 center positions
    List<int> corners = [0, 3, 12, 15]; // 4x4 corner positions
    List<int> sides = [1, 2, 4, 7, 8, 11, 13, 14]; // remaining side positions

    // Check for the best move in the order of priority
    for (var pos in center) {
      if (gameplayList[pos] == null) {
        return pos;
      }
    }

    for (var pos in corners) {
      if (gameplayList[pos] == null) {
        return pos;
      }
    }

    for (var pos in sides) {
      if (gameplayList[pos] == null) {
        return pos;
      }
    }

    return easyMove(gameplayList); // Default to an easy move if no strategic move is found
  }
}




class GeneratePlayGridFive {
  int easyMove(List<int?> gameplayList) {
    final availablePositions = <int>[];
    for (int i = 0; i < gameplayList.length; i++) {
      if (gameplayList[i] == null) {
        availablePositions.add(i);
      }
    }
    return availablePositions[Random().nextInt(availablePositions.length)];
  }

  int mediumMove(List<int?> gameplayList) {
    // Determine whose turn it is by counting filled positions
    int currentPlayer = determineCurrentPlayer(gameplayList);

    // Check for a winning move first
    for (var pattern in GameplayData.winningPatternsGrid5) {
      int? winningPosition = findWinningPosition(gameplayList, pattern, currentPlayer);
      if (winningPosition != null) {
        return winningPosition;
      }
    }
    // If no winning move, return an easy move
    return easyMove(gameplayList);
  }

  int hardMove(List<int?> gameplayList) {
    int currentPlayer = determineCurrentPlayer(gameplayList);
    int opponent = (currentPlayer == 0) ? 1 : 0;

    // 1. Check for a winning move first
    for (var pattern in GameplayData.winningPatternsGrid5) {
      int? winningPosition = findWinningPosition(gameplayList, pattern, currentPlayer);
      if (winningPosition != null) {
        return winningPosition;
      }
    }

    // 2. Block the opponent from winning
    for (var pattern in GameplayData.winningPatternsGrid5) {
      int? blockingPosition = findWinningPosition(gameplayList, pattern, opponent);
      if (blockingPosition != null) {
        return blockingPosition;
      }
    }

    // 3. Otherwise, make a medium move
    return mediumMove(gameplayList);
  }

  // Helper function to determine the current player based on the state of the game
  int determineCurrentPlayer(List<int?> gameplayList) {
    int countX = gameplayList.where((x) => x == 1).length;
    int countO = gameplayList.where((x) => x == 0).length;

    // If equal, it's player X's turn, otherwise it's player O's turn
    return countX == countO ? 1 : 0;
  }

  int? findWinningPosition(List<int?> gameplayList, List<int> pattern, int player) {
    int count = 0;
    int? emptyPosition;
    for (var pos in pattern) {
      if (gameplayList[pos] == player) {
        count++;
      } else if (gameplayList[pos] == null) {
        emptyPosition = pos;
      }
    }
    if (count == 4 && emptyPosition != null) { // Adjust for 5x5 grid where 5 in a row is a win
      return emptyPosition;
    }
    return null;
  }
}
