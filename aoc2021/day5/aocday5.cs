using System;
using System.IO;
using System.Linq;

namespace AOC
{
  class Program
  {
    static void Main()
    {
      var inputLines = File.ReadAllLines(@"input.txt");
      var formattedInputLines = FormatInputLines(inputLines);

      int[,] oceanFloor = new int[1000, 1000];

      AddVerticalAndHorizontalLinesToFloor(formattedInputLines, oceanFloor);
      Console.WriteLine("Intersections considering horizontal + vertical lines: {0}", CountPointsWithMultipleOverlaps(oceanFloor));

      AddDiagonalLinesToOceanFloor(formattedInputLines, oceanFloor);
      Console.WriteLine("Intersections considering horizontal + vertical + diagonal lines: {0}", CountPointsWithMultipleOverlaps(oceanFloor));
    }

    static int[, ,] FormatInputLines(string[] inputLines)
    {
      int[, ,] formattedInputLines = new int[500, 2, 2];

      foreach (var i in Enumerable.Range(0, 500))
      {
        string[] currentLine = inputLines[i].Split(" -> ");

        foreach (var x in Enumerable.Range(0, 2))
        {
          int[] currentPoint = currentLine[x].Split(',').Select(s => int.Parse(s)).ToArray();

          foreach (var y in Enumerable.Range(0, 2))
          {
            formattedInputLines[i, x, y] = currentPoint[y];
          }
        }
      }
      
      return formattedInputLines;
    }
    
    static void AddVerticalAndHorizontalLinesToFloor(int[, ,] formattedInputLines, int[,] oceanFloor)
    {
      foreach (var lineSegmentNumber in Enumerable.Range(0, formattedInputLines.GetLength(0)))
      {
        int x1 = formattedInputLines[lineSegmentNumber, 0, 0];
        int x2 = formattedInputLines[lineSegmentNumber, 1, 0];
        int y1 = formattedInputLines[lineSegmentNumber, 0, 1];
        int y2 = formattedInputLines[lineSegmentNumber, 1, 1];

        if (x1 == x2) // horizontal line
        {
          if (y2 > y1)
          {
            for (var i = y1; i <= y2; i++)
            {
              oceanFloor[x1, i] += 1;
            }
          }
          else if (y1 > y2)
          {
            for (var i = y2; i <= y1; i++)
            {
              oceanFloor[x1, i] += 1;
            }
          }
        }
        else if (y1 == y2) // vertical line
        {
          if (x2 > x1)
          {
            for (var i = x1; i <= x2; i++)
            {
              oceanFloor[i, y1] += 1;
            }
          }
          else if (x1 > x2)
          {
            for (var i = x2; i <= x1; i++)
            {
              oceanFloor[i, y1] += 1;
            }
          }
        }
      }
    }

    static void AddDiagonalLinesToOceanFloor(int[, ,] formattedInputLines, int[,] oceanFloor)
    {
      foreach (var lineSegmentNumber in Enumerable.Range(0, formattedInputLines.GetLength(0)))
      {
        int x1 = formattedInputLines[lineSegmentNumber, 0, 0];
        int x2 = formattedInputLines[lineSegmentNumber, 1, 0];
        int y1 = formattedInputLines[lineSegmentNumber, 0, 1];
        int y2 = formattedInputLines[lineSegmentNumber, 1, 1];
        // used at starting point when assigning values to ocean floor when walking diagonals
        int j = y1;

        // skip horizontal and vertical lines as they have been accounted for in the ocean floor grid already
        if (x1 == x2 || y1 == y2)
        {
          continue;
        }

        if (x2 > x1)
        {
          if (y2 > y1)
          {
            for (var i = x1; i <= x2; i++)
            {
              oceanFloor[i, j] += 1;
              j += 1;
            }
          }
          else
          {
            for (var i = x1; i <= x2; i++)
            {
              oceanFloor[i, j] += 1;
              j -= 1;
            }
          }
        }
        else if (x1 > x2)
        {
          if (y2 > y1)
          {
            for (var i = x1; i >= x2; i--)
            {
              oceanFloor[i, j] += 1;
              j += 1;
            }
          }
          else
          {
            for (var i = x1; i >= x2; i--)
            {
              oceanFloor[i, j] += 1;
              j -= 1;
            }
          }
        }
      }
    }

    static int CountPointsWithMultipleOverlaps(int[,] oceanFloor)
    {
      int count = 0;

      foreach (var x in Enumerable.Range(0, oceanFloor.GetLength(0)))
      {
        foreach (var y in Enumerable.Range(0, oceanFloor.GetLength(1)))
        {
          if (oceanFloor[x, y] > 1)
          {
            count += 1;
          }
        }
      }

      return count;
    }
  }
}
