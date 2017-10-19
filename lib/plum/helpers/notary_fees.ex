defmodule Plum.Helpers.NotaryFees do
  @fees [
    {500.00, 0},
    {1000.00, 480},
    {1500.00, 520},
    {2000.00, 610},
    {2500.00, 700},
    {3000.00, 790},
    {3500.00, 880},
    {4000.00, 970},
    {4500.00, 1060},
    {5000.00, 1150},
    {6000.00, 1240},
    {7000.00, 1410},
    {8000.00, 1590},
    {9000.00, 1770},
    {10000.00, 1950},
    {11000.00, 2090},
    {12000.00, 2160},
    {13000.00, 2240},
    {14000.00, 2310},
    {15000.00, 2400},
    {16000.00, 2480},
    {17000.00, 2550},
    {18000.00, 2630},
    {19000.00, 2700},
    {20000.00, 2770},
    {22000.00, 2840},
    {24000.00, 2990},
    {26000.00, 3140},
    {28000.00, 3290},
    {30000.00, 3420},
    {32000.00, 3560},
    {34000.00, 3710},
    {36000.00, 3850},
    {38000.00, 4010},
    {40000.00, 4140},
    {42000.00, 4290},
    {44000.00, 4430},
    {45000.00, 4570},
    {46000.00, 4650},
    {48000.00, 4720},
    {50000.00, 4870},
    {55000.00, 5010},
    {60000.00, 5370},
    {65000.00, 5730},
    {70000.00, 6080},
    {75000.00, 6420},
    {80000.00, 6760},
    {85000.00, 7110},
    {90000.00, 7450},
    {95000.00, 7800},
    {100000.00, 8140},
    {110000.00, 8480},
    {120000.00, 9170},
    {130000.00, 9860},
    {140000.00, 10550},
    {150000.00, 11240},
    {160000.00, 11930},
    {170000.00, 12610},
    {180000.00, 13300},
    {190000.00, 13980},
    {200000.00, 14670},
    {210000.00, 15370},
    {220000.00, 16050},
    {230000.00, 16740},
    {240000.00, 17440},
    {250000.00, 18120},
    {260000.00, 18810},
    {270000.00, 19490},
    {280000.00, 20190},
    {290000.00, 20880},
    {300000.00, 21560},
    {320000.00, 22250},
    {340000.00, 23620},
    {360000.00, 24990},
    {380000.00, 26380},
    {400000.00, 27760},
    {420000.00, 29130},
    {440000.00, 30520},
    {450000.00, 31890},
    {460000.00, 32570},
    {480000.00, 33260},
    {500000.00, 34630},
    {520000.00, 36020},
    {540000.00, 37390},
    {550000.00, 38770},
    {560000.00, 39460},
    {580000.00, 40150},
    {600000.00, 41530},
    {625000.00, 42900},
    {650000.00, 44620},
    {675000.00, 46340},
    {700000.00, 48060},
    {725000.00, 49790},
    {750000.00, 51500},
    {775000.00, 53220},
    {800000.00, 54950},
    {825000.00, 56660},
    {850000.00, 58380},
    {875000.00, 60120},
    {900000.00, 61830},
    {925000.00, 63550},
    {950000.00, 65280},
    {975000.00, 66990},
    {10000000, 68710},
    {11000000, 70440},
    {12000000, 77310},
    {12500000, 84210},
    {13000000, 87640},
    {14000000, 91090},
    {15000000, 97960},
    {16500000, 104850},
    {18000000, 115180},
    {20000000, 125500},
    {10000000000, 139270}
  ]

  def notary_fees(price) do
    @fees
    |> Enum.reject(fn {thresh, _} -> thresh < price end)
    |> List.first
    |> elem(1)
  end
end