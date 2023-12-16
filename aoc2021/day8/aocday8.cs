using System;
using System.IO;
using System.Linq;

namespace AOC
{
  class Program
  {
    static void Main()
    {
      var input = File.ReadAllLines(@"input.txt");
      string[,] signalPatterns = new String[input.Count(), 10];
      string[,] fourDigitOutputs = new String[input.Count(), 4];
      int countsOf1478 = 0;
      
      foreach (var i in Enumerable.Range(0, input.Count())) 
      {
        string[] signalPatternsOnInputLine = input[i].Split(" | ")[0].Split(' ');
        for (var j = 0; j < 10; j++)
        {
          signalPatterns[i, j] = signalPatternsOnInputLine[j];
        }

        string[] fourDigitOutputsOnInputLine = input[i].Split(" | ")[1].Split(' ');
        for (var j = 0; j < 4; j++)
        {
          fourDigitOutputs[i, j] = fourDigitOutputsOnInputLine[j];
        }
      }

      FindCountsOf1478(fourDigitOutputs, ref countsOf1478);

      Console.WriteLine("Counts of digis 1, 4, 7, and 8: {0}", countsOf1478);
    }

    static void FindCountsOf1478(string[,] fourDigitOutputs, ref int countsOf1478)
    {
      int[] uniqueOutputDigitCounts = new int[] { 2, 3, 4, 7 };

      foreach (var i in Enumerable.Range(0, fourDigitOutputs.GetLength(0)))
      {
        for (var j = 0; j < 4; j++)
        {
          if(uniqueOutputDigitCounts.Contains(fourDigitOutputs[i, j].Length))
          {
            countsOf1478 += 1;
          }
        }
      }
    }
  }
}
