using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;

namespace AOC
{
  class Program
  {
    static void Main()
    {
      var lines = File.ReadAllLines(@"input.txt");

      int[] numbers = lines[0].Split(',').Select(s => int.Parse(s)).ToArray();
      string[] gameBoardLines = lines[2..^0];
      
      var boards = GetGameBoards(gameBoardLines);      
      
      // keep track of each winner and the index of the last number called during their win
      List<int> orderOfWinners = new List<int>();
      List<int> lastNumberIndexCalledDuringWins = new List<int>();

      RunThroughNumbers(numbers, boards, orderOfWinners, lastNumberIndexCalledDuringWins);

      Console.WriteLine(ComputeScoreOfWinner(numbers, boards, 0, orderOfWinners, lastNumberIndexCalledDuringWins));
      Console.WriteLine(ComputeScoreOfWinner(numbers, boards, 99, orderOfWinners, lastNumberIndexCalledDuringWins));
    }
    
    static int[, ,] GetGameBoards(String[] gameBoardLines)
    {
      gameBoardLines = gameBoardLines.Where(s => !string.IsNullOrEmpty(s)).ToArray();
      int[, ,] gameBoards = new int[100, 5, 5];

      int currentRowIndex = 0;
      foreach (var i in Enumerable.Range(0, 100))
      {
        foreach (var j in Enumerable.Range(0, 5))
        {
          // Convert string into row of ints to use as current row
          int[] currentRow = gameBoardLines[currentRowIndex].Split(' ').Where(s => !string.IsNullOrEmpty(s)).Select(s => int.Parse(s)).ToArray();
          
          foreach (var k in Enumerable.Range(0, 5))
          {
            gameBoards[i, j ,k] = currentRow[k];
          }

          currentRowIndex += 1;
        }
      }

      return gameBoards;
    }

    static void RunThroughNumbers(int[] numbers, int[, ,] gameBoards, List<int> orderOfWinners, List<int> lastNumberIndexCalledDuringWins) {
      List<int> numbersSoFar = new List<int>();

      foreach (var i in numbers)
      {
        numbersSoFar.Add(i);

        // don't check for winner until 5 numbers have been called
        if (numbersSoFar.Count() < 5) {
          continue;
        }

        FindWinners(numbersSoFar, gameBoards, orderOfWinners, lastNumberIndexCalledDuringWins);
        if (orderOfWinners.Count() == 100)
        {
          break;
        }
      }
    }

    static void FindWinners(List<int> numbersSoFar, int[, ,] gameBoards, List<int> orderOfWinners, List<int> lastNumberIndexCalledDuringWins)
    {
      foreach (var i in Enumerable.Range(0, gameBoards.GetLength(0)))
      {
        // Skip the board if they won already
        if (orderOfWinners.Contains(i))
        {
          continue;
        }

        if (BoardIsWinner(gameBoards, i, numbersSoFar))
        {
          orderOfWinners.Add(i);
          lastNumberIndexCalledDuringWins.Add(numbersSoFar.Count());
        }
      }
    }

    static Boolean BoardIsWinner(int[, ,] gameBoards, int boardIndex, List<int> numbersSoFar)
    {
      Boolean winner = false;

      foreach (var j in Enumerable.Range(0, 5))
      {
        // check row
        if (numbersSoFar.Contains(gameBoards[boardIndex, j, 0]) && numbersSoFar.Contains(gameBoards[boardIndex, j, 1])
          && numbersSoFar.Contains(gameBoards[boardIndex, j, 2]) && numbersSoFar.Contains(gameBoards[boardIndex, j, 3])
          && numbersSoFar.Contains(gameBoards[boardIndex, j, 4]))
        {
          winner = true;
        }
        // check column
        else if (numbersSoFar.Contains(gameBoards[boardIndex, 0, j]) && numbersSoFar.Contains(gameBoards[boardIndex, 1, j])
          && numbersSoFar.Contains(gameBoards[boardIndex, 2, j]) && numbersSoFar.Contains(gameBoards[boardIndex, 3, j])
          && numbersSoFar.Contains(gameBoards[boardIndex, 4, j]))
        {
          winner = true;
        }
      }

      return winner;
    }

    static int ComputeScoreOfWinner(int[] numbers, int[, ,] gameBoards, int winnerNumber, List<int> orderOfWinners, List<int> lastNumberIndexCalledDuringWins)
    {
      int boardUnmarkedSquaresSum = 0;
      int boardIndexOfWinner = orderOfWinners[winnerNumber];
      List<int> numbersCalledDuringWin = numbers.ToList().GetRange(0, lastNumberIndexCalledDuringWins[winnerNumber]);

      foreach (var row in Enumerable.Range(0, 5))
      {
        foreach (var col in Enumerable.Range(0, 5))
        {
          var currentBoardSquareValue = gameBoards[boardIndexOfWinner, row, col];
          if (!numbersCalledDuringWin.Contains(currentBoardSquareValue))
          {
            boardUnmarkedSquaresSum += currentBoardSquareValue;
          }
        }
      }

      return boardUnmarkedSquaresSum * numbersCalledDuringWin.Last();
    }
  }
}
