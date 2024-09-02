import 'dart:math';

import 'package:tic_tac_toe/data/gameplay_data.dart';

class GeneratePlayGridThree {

  int easyMove(List<int?> board) {
  List<int> emptySpots = [];

  for (int i = 0; i < board.length; i++) {
    if (board[i] == null) {
      emptySpots.add(i);
    }
  }

  if (emptySpots.isEmpty) {
    throw Exception("No empty spots available on the board");
    // Or handle the situation according to your game logic
  }

  Random random = Random();
  return emptySpots[random.nextInt(emptySpots.length)];
}

  

  int? checkWinningMove(List<int?> board, int player) {
    List<List<int>> winningPatterns = [
      // Horizontal wins
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      
      // Vertical wins
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      
      // Diagonal wins
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

  int mediumMove(List<int?> board, int player) {
    // Try to win
    int? move = checkWinningMove(board, player);
    
    if (move != null) {
      return move;
    }
    
    return easyMove(board);
  }

  int hardMove(List<int?> board, int player) {
    return minimax(board, player).index;
  }

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
}

class Move {
  int index;
  int score;

  Move({this.index = -1, this.score = 0});
}











class GeneratePlayGridFour {
  
  int easyMove(List<int?> gameplayList) {
    final availablePositions = <int>[];
    for (int i = 0; i < gameplayList.length; i++) {
      if (gameplayList[i] == null) {
        availablePositions.add(i);
      }
    }
    return availablePositions[Random().nextInt(availablePositions.length)];
  }

  int mediumMove(List<int?> gameplayList, int currentPlayer) {
    // Check for a winning move first
    for (var pattern in GameplayData.winningPatternsGrid4) {
      int? winningPosition = findWinningPosition(gameplayList, pattern, currentPlayer);
      if (winningPosition != null) {
        return winningPosition;
      }
    }
    // If no winning move, return an easy move
    return easyMove(gameplayList);
  }

  int hardMove(List<int?> gameplayList, int currentPlayer) {
    // 1. Check for a winning move first
    for (var pattern in GameplayData.winningPatternsGrid4) {
      int? winningPosition = findWinningPosition(gameplayList, pattern, currentPlayer);
      if (winningPosition != null) {
        return winningPosition;
      }
    }

    // 2. Block the opponent from winning
    int opponent = (currentPlayer == 0) ? 1 : 0;
    for (var pattern in GameplayData.winningPatternsGrid4) {
      int? blockingPosition = findWinningPosition(gameplayList, pattern, opponent);
      if (blockingPosition != null) {
        return blockingPosition;
      }
    }

    // 3. Otherwise, make the best strategic move
    return easyMove(gameplayList);
  }

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
    if (count == 2 && emptyPosition != null) {
      return emptyPosition;
    }
    return null;
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

  int mediumMove(List<int?> gameplayList, int currentPlayer) {
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

  int hardMove(List<int?> gameplayList, int currentPlayer, int opponent) {
    // Check for a winning move first
    for (var pattern in GameplayData.winningPatternsGrid5) {
      int? winningPosition = findWinningPosition(gameplayList, pattern, currentPlayer);
      if (winningPosition != null) {
        return winningPosition;
      }
    }
    // Block opponent's winning move
    for (var pattern in GameplayData.winningPatternsGrid5) {
      int? blockingPosition = findWinningPosition(gameplayList, pattern, opponent);
      if (blockingPosition != null) {
        return blockingPosition;
      }
    }
    // Otherwise, make a medium move
    return mediumMove(gameplayList, currentPlayer);
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
