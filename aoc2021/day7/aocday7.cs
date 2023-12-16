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
      int[] yCoords = input[0].Split(',').Select(s => int.Parse(s)).ToArray();
      int constantFuelCost = 999999999;
      int nonconstantFuelCost = 999999999;

      CalculateFuelCosts(yCoords, ref constantFuelCost);
      CalculateNonconstantFuelCosts(yCoords, ref nonconstantFuelCost);

      Console.WriteLine("Fuel cost of most efficient constant fuel consumption path: {0}", constantFuelCost);
      Console.WriteLine("Fuel cost of most efficient nonconstant fuel consumption path: {0}", nonconstantFuelCost);
    }

    static void CalculateFuelCosts(int[] yCoords, ref int constantFuelCost)
    {
      foreach (var currentPositionIndex in Enumerable.Range(0, yCoords.Count()))
      {
        int currentPositionConstantFuelCost = 0;

        foreach (var crabPositionIndex in Enumerable.Range(0, yCoords.Count()))
        {
          if (crabPositionIndex == currentPositionIndex) { continue; }

          var currentYPosition = yCoords[currentPositionIndex];
          var currentCrabPosition = yCoords[crabPositionIndex];

          currentPositionConstantFuelCost += Math.Abs(currentYPosition - currentCrabPosition);
        }

        if (currentPositionConstantFuelCost < constantFuelCost) { constantFuelCost = currentPositionConstantFuelCost; }
      }
    }

    static void CalculateNonconstantFuelCosts(int[] yCoords, ref int nonconstantFuelCost)
    {
      foreach (var currentYPosition in Enumerable.Range(0, yCoords.Max()))
      {
        {
          int currentPositionNonconstantFuelCost = 0;

          foreach (var crabPositionIndex in Enumerable.Range(0, yCoords.Count()))
          {
            var currentCrabPosition = yCoords[crabPositionIndex];

            int distance = Math.Abs(currentYPosition - currentCrabPosition);
            // see triangular numbers
            currentPositionNonconstantFuelCost += ((distance) * (distance + 1))/2;
          }

          if (currentPositionNonconstantFuelCost < nonconstantFuelCost) { nonconstantFuelCost = currentPositionNonconstantFuelCost; }
        }
      }
    }
  }
}
