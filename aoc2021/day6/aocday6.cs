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
      var inputLine = File.ReadAllLines(@"input.txt");
      int[] lanternFish = inputLine[0].Split(',').Select(s => int.Parse(s)).ToArray();
      Dictionary<int, long> fishWithoutOffspringTable = new Dictionary<int, long>() { {0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}, {7, 0}, {8, 0} };
      Dictionary<int, long> fishWithOffspringTable = new Dictionary<int, long>() { {0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0} };

      for (var i = 0; i < lanternFish.Count(); i++)
      {
        fishWithoutOffspringTable[lanternFish[i]] += 1;
      }

      GoForwardXDays(ref fishWithoutOffspringTable, ref fishWithOffspringTable, 80);
      Console.WriteLine("Lantern fish count after 80 days: {0}", GetTotalFishCount(fishWithoutOffspringTable, fishWithOffspringTable));

      GoForwardXDays(ref fishWithoutOffspringTable, ref fishWithOffspringTable, 256-80);
      Console.WriteLine("Lantern fish count after 256 days: {0}", GetTotalFishCount(fishWithoutOffspringTable, fishWithOffspringTable));
    }

    static void GoForwardXDays(ref Dictionary<int, long> fishWithoutOffspringTable, ref Dictionary<int, long> fishWithOffspringTable, int days) {
      int day = 0;

      do
      {
        Dictionary<int, long> newFishWithoutOffspringTable = new Dictionary<int, long>() { {0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}, {7, 0}, {8, 0} };
        Dictionary<int, long> newFishWithOffspringTable = new Dictionary<int, long>() { {0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0} };
        
        newFishWithoutOffspringTable[8] = fishWithoutOffspringTable[0] + fishWithOffspringTable[0];
        newFishWithoutOffspringTable[7] = fishWithoutOffspringTable[8];
        newFishWithoutOffspringTable[6] = fishWithoutOffspringTable[7];
        newFishWithoutOffspringTable[5] = fishWithoutOffspringTable[6];
        newFishWithoutOffspringTable[4] = fishWithoutOffspringTable[5];
        newFishWithoutOffspringTable[3] = fishWithoutOffspringTable[4];
        newFishWithoutOffspringTable[2] = fishWithoutOffspringTable[3];
        newFishWithoutOffspringTable[1] = fishWithoutOffspringTable[2];
        newFishWithoutOffspringTable[0] = fishWithoutOffspringTable[1];

        newFishWithOffspringTable[6] = fishWithOffspringTable[0] + fishWithoutOffspringTable[0];
        newFishWithOffspringTable[5] = fishWithOffspringTable[6];
        newFishWithOffspringTable[4] = fishWithOffspringTable[5];
        newFishWithOffspringTable[3] = fishWithOffspringTable[4];
        newFishWithOffspringTable[2] = fishWithOffspringTable[3];
        newFishWithOffspringTable[1] = fishWithOffspringTable[2];
        newFishWithOffspringTable[0] = fishWithOffspringTable[1];

        fishWithOffspringTable = newFishWithOffspringTable;
        fishWithoutOffspringTable = newFishWithoutOffspringTable;

        day += 1;
      } while (day < days);
    }

    static long GetTotalFishCount(Dictionary<int, long> fishWithoutOffspringTable, Dictionary<int, long> fishWithOffspringTable)
    {
      long fishCount = 0;

      fishCount += fishWithOffspringTable.Sum(f => f.Value);
      fishCount += fishWithoutOffspringTable.Sum(f => f.Value);

      return fishCount;
    }
  }
}
