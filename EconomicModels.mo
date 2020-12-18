// PK SFC models of GFC and Secular Stagnation, open with OMEdit https://openmodelica.org/
// Copyright (C) 2020 Adam Kaczynski
// Based on Monetary Economics Wynne Godley and Marc Lavoie (2007) Chapter 11 GROWTH
// and work of Gennaro Zezza (2006)
//
// This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    
model EconomicModels
  // Vector of dates used to define actual historical data
  Real years[:] = {1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990,
                   1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000,
                   2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010,
                   2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019};
// Real GDP (quarterly data)
// U.S. Bureau of Economic Analysis, Real Gross Domestic Product [GDPC1], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/GDPC1, November 10, 2020.
  Real y_values[:] = {6837.641,6696.753,6688.794,6813.535,
                      6947.042,6895.559,6978.135,6902.105,
                      6794.878,6825.876,6799.781,6802.497,
                      6892.144,7048.982,7189.896,7339.893,
                      7483.371,7612.668,7686.059,7749.151,
                      7824.247,7893.136,8013.674,8073.239,
                      8148.603,8185.303,8263.639,8308.021,
                      8369.93,8460.233,8533.635,8680.162,
                      8725.006,8839.641,8891.435,9009.913,
                      9101.508,9170.977,9238.923,9257.128,
                      9358.289,9392.251,9398.499,9312.937,
                      9269.367,9341.642,9388.845,9421.565,
                      9534.346,9637.732,9732.979,9834.51,
                      9850.973,9908.347,9955.641,10091.049,
                      10188.954,10327.019,10387.382,10506.372,
                      10543.644,10575.1,10665.06,10737.478,
                      10817.896,10998.322,11096.976,11212.205,
                      11284.587,11472.137,11615.636,11715.393,
                      11832.486,11942.032,12091.614,12287.0,
                      12403.293,12498.694,12662.385,12877.593,
                      12924.179,13160.842,13178.419,13260.506,
                      13222.69,13299.984,13244.784,13280.859,
                      13397.002,13478.152,13538.072,13559.032,
                      13634.253,13751.543,13985.073,14145.645,
                      14221.147,14329.523,14464.984,14609.876,
                      14771.602,14839.782,14972.054,15066.597,
                      15267.026,15302.705,15326.368,15456.928,
                      15493.328,15582.085,15666.738,15761.967,
                      15671.383,15752.308,15667.032,15328.027,
                      15155.94,15134.117,15189.222,15356.058,
                      15415.145,15557.277,15671.967,15750.625,
                      15712.754,15825.096,15820.7,16004.107,
                      16129.418,16198.807,16220.667,16239.138,
                      16382.964,16403.18,16531.685,16663.649,
                      16616.54,16841.475,17047.098,17143.038,
                      17305.752,17422.845,17486.021,17514.062,
                      17613.264,17668.203,17764.388,17876.179,
                      17977.299,18054.052,18185.636,18359.432,
                      18530.483,18654.383,18752.355,18813.923,
                      18950.347,19020.599,19141.744,19253.959};

  Real quarters[:] = {1980.00,1980.25,1980.50,1980.75,
                      1981.00,1981.25,1981.50,1981.75,
                      1982.00,1982.25,1982.50,1982.75,
                      1983.00,1983.25,1983.50,1983.75,
                      1984.00,1984.25,1984.50,1984.75,
                      1985.00,1985.25,1985.50,1985.75,
                      1986.00,1986.25,1986.50,1986.75,
                      1987.00,1987.25,1987.50,1987.75,
                      1988.00,1988.25,1988.50,1988.75,
                      1989.00,1989.25,1989.50,1989.75,
                      1990.00,1990.25,1990.50,1990.75,
                      1991.00,1991.25,1991.50,1991.75,
                      1992.00,1992.25,1992.50,1992.75,
                      1993.00,1993.25,1993.50,1993.75,
                      1994.00,1994.25,1994.50,1994.75,
                      1995.00,1995.25,1995.50,1995.75,
                      1996.00,1996.25,1996.50,1996.75,
                      1997.00,1997.25,1997.50,1997.75,
                      1998.00,1998.25,1998.50,1998.75,
                      1999.00,1999.25,1999.50,1999.75,
                      2000.00,2000.25,2000.50,2000.75,
                      2001.00,2001.25,2001.50,2001.75,
                      2002.00,2002.25,2002.50,2002.75,
                      2003.00,2003.25,2003.50,2003.75,
                      2004.00,2004.25,2004.50,2004.75,
                      2005.00,2005.25,2005.50,2005.75,
                      2006.00,2006.25,2006.50,2006.75,
                      2007.00,2007.25,2007.50,2007.75,
                      2008.00,2008.25,2008.50,2008.75,
                      2009.00,2009.25,2009.50,2009.75,
                      2010.00,2010.25,2010.50,2010.75,
                      2011.00,2011.25,2011.50,2011.75,
                      2012.00,2012.25,2012.50,2012.75,
                      2013.00,2013.25,2013.50,2013.75,
                      2014.00,2014.25,2014.50,2014.75,
                      2015.00,2015.25,2015.50,2015.75,
                      2016.00,2016.25,2016.50,2016.75,
                      2017.00,2017.25,2017.50,2017.75,
                      2018.00,2018.25,2018.50,2018.75,
                      2019.00,2019.25,2019.50,2019.75};

  // Semega, J. L., Fontenot, K. R., & Kollar, M. A. (2017). Income and poverty in the United States: 2016. U.S. Census Bureau, Current Population Reports, (P60-259). Table 2 A
  // retrieved from https://www2.census.gov/programs-surveys/demo/tables/p60/263/tableA2.xls
  // data extended to cover 2018 and 2019 by repeating the sample from 2017
  Real high_income_ratios[:] = {0.450, 0.451,	0.452, 0.456, 0.461,	0.462, 0.463, 0.468,	
                                0.466, 0.465,	0.469, 0.489, 0.491,	0.487, 0.490, 0.494,	
                                0.492, 0.494,	0.498, 0.501, 0.497,	0.498, 0.501, 0.504,	
                                0.505, 0.497,	0.500, 0.503, 0.503,	0.511, 0.510, 0.510,	
                                0.514, 0.512, 0.511, 0.515, 0.515, 0.515, 0.515};
  

// Government expenditures to GDP ratio
// U.S. Bureau of Economic Analysis, Government Consumption Expenditures and Gross Investment [GCEA], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/GCEA, November 9, 2020.
// U.S. Bureau of Economic Analysis, Gross Domestic Product [GDPA], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/GDPA, November 9, 2020.
  Real GCEA_GDPA[:] = {0.20404503589288821288,
                       0.21277449025641271025,
                       0.21093808044935138268,
                       0.20504936951609775380,
                       0.20984568028561557915,
                       0.21313420229708463411,
                       0.21245815066891991395,
                       0.20602841091596997807,
                       0.20417365348005346020,
                       0.20770184318876082818,
                       0.21093273622556461549,
                       0.20620131475001177088,
                       0.19901002528373671496,
                       0.19242878918701137166,
                       0.18972233250071435593,
                       0.18491582314747627993,
                       0.18036999367651749590,
                       0.17782649699315345328,
                       0.17863359978435544884,
                       0.17818797978648206113,
                       0.18420977030231655758,
                       0.19098730498413648783,
                       0.19297962358287647167,
                       0.19149670084405009772,
                       0.18992566871348799541,
                       0.18996078716379160641,
                       0.19311313561022595015,
                       0.20267935943048404302,
                       0.21271551419855806644,
                       0.21042129523029936129,
                       0.20256428436407798910,
                       0.19367837527019652458,
                       0.18662119788850076775,
                       0.18074618402946998327,
                       0.17711249529218757822,
                       0.17600804477976215086,
                       0.17433446690320514067,
                       0.17442195054585318618,
                       0.17486280413410468401};

// Trade deficit to GDP ratio (data *(-1))
// U.S. Bureau of Economic Analysis, Balance on Current Account, NIPA's [NETFI], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/NETFI, November 9, 2020.
// U.S. Bureau of Economic Analysis, Gross Domestic Product [GDP], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/GDP, November 9, 2020.
  Real NETFI_GDP[:] = {-0.00053357557088104946,
                      -0.00019882100062853091,
                      0.00227298049497713056,
                      0.02009593521481535311,
                      0.02113651278152546187,
                      0.02846672969683847934,
                      0.03196421295696287882,
                      0.02500644541736738406,
                      0.01935875562236028722,
                      0.01533229769402528751,
                      -0.00771808221729334247,
                      0.00342427325540278939,
                      0.00851762377926665427,
                      0.01306500093034341758,
                      0.01584916506132641274,
                      0.01308094536318886980,
                      0.01577943846780717368,
                      0.01859351174310436611,
                      0.02489035031830901204,
                      0.03700662720660707236,
                      0.03954146705982185032,
                      0.03624235236193469023,
                      0.04706833017585628551,
                      0.04455809309414992355,
                      0.05203232231857837466,
                      0.05771139860803489697,
                      0.05498604398514727275,
                      0.04843383462428842077,
                      0.02653400624555951639,
                      0.02796869852289362049,
                      0.03110161909449720355,
                      0.02983890268504680283,
                      0.02403179414627675481,
                      0.02099054900872896138,
                      0.02333303838902864953,
                      0.02320900808850775272,
                      0.01912401523383964650,
                      0.02014739987694034472,
                      0.02519693176169006099};
// Civilian labour force
// U.S. Bureau of Labor Statistics, Civilian Labor Force Level [CLF16OV], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/CLF16OV, November 9, 2020.
  Real CLF16OV[:] = {108912000,
                     111083000,
                     112327000,
                     114581000,
                     116354000,
                     118611000,
                     120729000,
                     122622000,
                     124497000,
                     126142000,
                     126664000,
                     128554000,
                     129941000,
                     131951000,
                     132511000,
                     135113000,
                     137155000,
                     138634000,
                     140177000,
                     143248000,
                     144305000,
                     145066000,
                     146729000,
                     148059000,
                     150030000,
                     152732000,
                     153918000,
                     154655000,
                     153111000,
                     153650000,
                     153995000,
                     155628000,
                     155182000,
                     156332000,
                     158035000,
                     159710000,
                     160538000,
                     163111000,
                     164550006};

// Employment Level 
// U.S. Bureau of Labor Statistics, Employment Level [CE16OV], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/CE16OV, November 9, 2020.
  Real CE16OV[:]={99645000,
                  99032000,
                  102996000,
                  106223000,
                  108216000,
                  110728000,
                  113793000,
                  116104000,
                  117830000,
                  118241000,
                  117466000,
                  118997000,
                  121464000,
                  124721000,
                  125088000,
                  127860000,
                  130679000,
                  132602000,
                  134523000,
                  137614000,
                  136047000,
                  136426000,
                  138411000,
                  140125000,
                  142752000,
                  145970000,
                  146273000,
                  143369000,
                  138013000,
                  139301000,
                  140902000,
                  143330000,
                  144778000,
                  147615000,
                  150128000,
                  152216000,
                  153977000,
                  156825000,
                  158803000};

// Annual net change in household debt 
// Board of Governors of the Federal Reserve System (US), Consumer Loans, All Commercial Banks [CONSUMER], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/CONSUMER, November 9, 2020.
// Board of Governors of the Federal Reserve System (US), Households and Nonprofit Organizations; One-TO-Four-Family Residential Mortgages; Liability, Level [HHMSDODNS], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/HHMSDODNS, November 9, 2020.
  Real D_HH_DEBT[:] = {81378266666,
                       52514958333,
                       64837191666,
                       160742241666,
                       223795575000,
                       213106858333,
                       222196608333,
                       225050325000,
                       224380141666,
                       252571816666,
                       178566108333,
                       159148133333,
                       172143041666,
                       212616800000,
                       213791725000,
                       234582483333,
                       221855016666,
                       247801283333,
                       361217216666,
                       407201091666,
                       499916866666,
                       629716216666,
                       848917491666,
                       974870033333,
                       1053824191666,
                       1128836258333,
                       819618241666,
                       325770583333,
                       -107200041666,
                       -138411333333,
                       -290257925000,
                       -218908016666,
                       -140941491666,
                       -31832408333,
                       90886641666,
                       251213225000,
                       307854108333,
                       348904233333,
                       344428933333};
  
// Effective Federal Funds Rate
// Board of Governors of the Federal Reserve System (US), Effective Federal Funds Rate [FEDFUNDS], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/FEDFUNDS, November 9, 2020.
  Real FUNDRATE[:]={0.163783333333333333,
                    0.122583333333333333,
                    0.090866666666666667,
                    0.102250000000000000,
                    0.081008333333333333,
                    0.068050000000000000,
                    0.066575000000000000,
                    0.075683333333333333,
                    0.092166666666666667,
                    0.080991666666666667,
                    0.056875000000000000,
                    0.035216666666666667,
                    0.030225000000000000,
                    0.042016666666666667,
                    0.058366666666666667,
                    0.052983333333333333,
                    0.054600000000000000,
                    0.053533333333333333,
                    0.049700000000000000,
                    0.062358333333333333,
                    0.038875000000000000,
                    0.016666666666666667,
                    0.011275000000000000,
                    0.013491666666666667,
                    0.032133333333333333,
                    0.049641666666666667,
                    0.050191666666666667,
                    0.019275000000000000,
                    0.0016000000000000000000,
                    0.0017500000000000000000,
                    0.0010166666666666666667,
                    0.0014000000000000000000,
                    0.0010750000000000000000,
                    0.0008916666666666666667,
                    0.0013250000000000000000,
                    0.0039500000000000000000,
                    0.0100166666666666666667,
                    0.018316666666666667,
                    0.021583333333333333};
  
// Unemployment rate
// U.S. Bureau of Labor Statistics, Unemployment Rate [UNRATE], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/UNRATE, November 14, 2020.
  Real UNRATE[:]={0.07616666666666666700,
0.09708333333333333300,
0.09600000000000000000,
0.07508333333333333300,
0.07191666666666666700,
0.07000000000000000000,
0.06175000000000000000,
0.05491666666666666700,
0.05258333333333333300,
0.05616666666666666700,
0.06850000000000000000,
0.07491666666666666700,
0.06908333333333333300,
0.06100000000000000000,
0.05591666666666666700,
0.05408333333333333300,
0.04941666666666666700,
0.04500000000000000000,
0.04216666666666666700,
0.03966666666666666700,
0.04741666666666666700,
0.05783333333333333300,
0.05991666666666666700,
0.05541666666666666700,
0.05083333333333333300,
0.04608333333333333300,
0.04616666666666666700,
0.05800000000000000000,
0.09283333333333333300,
0.09608333333333333300,
0.08933333333333333300,
0.08075000000000000000,
0.07358333333333333300,
0.06158333333333333300,
0.05275000000000000000,
0.04875000000000000000,
0.04341666666666666700,
0.03891666666666666700,
0.03666666666666666700};

// Personal Saving Rate
// U.S. Bureau of Economic Analysis, Personal Saving Rate [PSAVERT], 
// retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/PSAVERT, November 14, 2020.
  
  Real PSAVERT[:] = {11.7166666666666667,
12.0416666666666667,
10.0500000000000000,
11.3250000000000000,
9.1666666666666667,
8.8250000000000000,
7.9083333333333333,
8.4750000000000000,
8.3750000000000000,
8.3666666666666667,
8.8000000000000000,
9.4500000000000000,
7.9250000000000000,
6.9083333333333333,
6.9916666666666667,
6.5583333333333333,
6.3333333333333333,
6.8000000000000000,
5.0416666666666667,
4.8083333333333333,
5.0166666666666667,
5.8333333333333333,
5.5333333333333333,
5.1166666666666667,
3.0833333333333333,
3.8000000000000000,
3.6583333333333333,
4.9833333333333333,
6.1083333333333333,
6.5500000000000000,
7.1416666666666667,
8.8250000000000000,
6.3916666666666667,
7.3500000000000000,
7.5416666666666667,
6.8833333333333333,
7.1833333333333333,
7.8416666666666667,
7.5416666666666667};


  partial class BaseEconomy
    //--------------------------------------------
    // Auxiliary
    //--------------------------------------------
    function Ramp
      input Real u;
      output Real y;
    algorithm
      y := if u > 0 then u else 0; 
    end Ramp;

   function AlmostEqual
      input Real u1, u2;
      output Boolean y;
    algorithm
      y := if abs(u1 - u2) < 0.05 * abs(u1) then true else false;
    end AlmostEqual;
   
   // generates a continuous sequence of edges 
   function RampEdges
      input Real t[:];
      input Real u[:];
      input Real ti;
      output Real y;
      protected Real t1, t2, u1, u2;      
   algorithm
     assert((size(u, 1) - 1) * 2 == size(t, 1), "2 * (number of levels - 1) must be == number of time values ");
     y := u[1];
     for i in 1 : size(t, 1) - 1 loop
       assert(t[i] < t[i + 1], "time values must be increasing");   
     end for;   
     for i in 0 : (size(t, 1) / 2 - 1 ) loop
       t1 := t[2 * i + 1];
       t2 := t[2 * i + 2];
       u1 := u[i + 1];
       u2 := u[i + 2];
       y := if ti < t1 then y elseif ti < t2 then (u1 + (u2 - u1)/(t2 - t1) * (ti - t1)) else u2;
     end for;
   end RampEdges;
   
   // provides a smoothened sequence of edges
   block FilteredRampEdges
    parameter Real t[:];
    parameter Real u[:];
    output Real y;
    protected Modelica.Blocks.Continuous.SecondOrder  filter(y_start = u[1], yd_start = 0, w = 24, D = 1, initType = Modelica.Blocks.Types.Init.InitialState);  
    equation
    filter.u = RampEdges(t, u, time + 0.0831);
    y = filter.y;
   end FilteredRampEdges;
  
   // provides a smoothened sequence of linear segments interpolating samples
   block FilteredInterpolate
    parameter Real t[:];
    parameter Real u[:];
    output Real y;
    protected Modelica.Blocks.Continuous.SecondOrder  filter(y_start = u[1], yd_start = 0, w = 24, D = 1, initType = Modelica.Blocks.Types.Init.InitialState);  
    equation
    filter.u = Modelica.Math.Vectors.interpolate(t, u, time + 0.0831);
    y = filter.y;
   end FilteredInterpolate;
  
    //--------------------------------------------
    // Exogenous parameters
    //--------------------------------------------
    Real ER_max;         // High employment rate threshold
    Real ER_min;         // Low employment rate threshold
    Real ER_pr0;         // Low employment rate threshold for productivity growth - bottom (0)
    Real ER_pr1;         // Low employment rate threshold for productivity growth - top (gr_pr0)
    Real GYR;            // Government expenditures to GDP target ratio  
    Real HILD;           // Fraction of labour demand satisfied by high-income households    
    Real HILE;           // Fraction of lending going to high-income households
    Real HIN;            // Number of high income individuals to total population ratio
    Real IHMOV;          // Nominal housing investment (construction spending) to Mortgage Origination Volume ratio
    Real LF_N;           // Labour force to total population ratio 
    Real NCAR;           // Normal capital adequacy ratio of banks
    Real Omega_3;        // Nominal wage adjustment parameter
    Real REMOR;          // Real estate value to mortgage debt stock ratio  
    Real Theta_f;        // Profit tax rate
    Real Theta_hh;       // Personal income tax rate, high income households
    Real Theta_hl;       // Personal income tax rate, low income households
    Real UBR;            // Unemployment benefits to wages ratio  
    Real alpha_2;        // Propensity to consume out of wealth;
    Real beta;           // Expected real sales adjustment coefficient
    Real delta;          // Rate of depreciation of fixed capital    
    Real delta_rep;      // Household loans repayment rate
    Real delta_RES;      // Rate of depreciation of residential buildings
    Real epsilon;        // Expected real regular disposable income adjustment coeficient
    Real epsilon_GYR;    // Government expenditure adjustment coefficient
    Real epsilon_M;      // Actual Markup adjustment coefficient
    Real epsilon_vh;     // Expected real wealth of high-income households adjustment coefficient
    Real epsilon_vhr;    // Expected real wealth of high-income households adjustment coefficient in a recession
    Real eta;            // New mortgage loans coefficient
    Real eta_LD;         // Employment adjustment coefficient (hiring)    
    Real eta_LDr;        // Employment adjustment coefficient in a recession
    Real gamma;          // Inventories stock adjustment coefficient
    Real gamma_u;        // Real capital growth to capacity utilisation coefficient
    Real gr_N;           // Population growth rate
    Real gr_g;           // Growth rate of real government expenditures
    Real gr_pr0;         // Maximum labour productivity growth rate
    Real lambda_20;      // Portfolio choice parameter
    Real lambda_22;      // Portfolio choice parameter    
    Real lambda_24;      // Portfolio choice parameter
    Real lambda_25;      // Portfolio choice parameter
    Real lambda_40;      // Portfolio choice parameter
    Real lambda_42;      // Portfolio choice parameter    
    Real lambda_44;      // Portfolio choice parameter
    Real lambda_45;      // Portfolio choice parameter
    Real lambda_50;      // portfolio choice parameter of the foregn sector
    Real lambda_b;       // Bank dividends to GDP ratio
    Real lambda_c;       // Cash to consumption ratio
    Real mu;             // Average net import propensity 
    Real omega_0;        // Main wage expectations parameter
    Real omega_1;        // Parameter determining reduction of wage expectations in low employment region
    Real omega_2;        // Parameter determining increase of wage expectations in high unemployment region
    Real psi_D;          // Dividends to firm profits ratio
    Real psi_N;          // Target financing of invenstment by new equity
    Real psi_U;          // Target retained earnings to investment ratio
    Real r_m;            // Deposit interest rate set by CB equal to bills interest rate
    Real rho;            // Compulsory reserve ratio on bank deposits
    Real sigma_A;        // Lending and deposit rates spread adjustment coefficient
    Real sigma_N;        // Normal historic unit cost adjustment coefficient
    Real sigma_T;        // Target ratio of inventories to sales
    Real sigma_se;       // Normal historic unit cost adjustment coefficient  
    Real u_0;            // Normal stock of fixed capital / GDP ratio, normal capital utilisation
          
    //--------------------------------------------
    // State variables
    //--------------------------------------------
    Real _B;              // Government bills
    Real _LD;             // Labour demand reduced to simple labour
    Real _L_f;            // Loans to firms
    Real _L_hh;           // Loans to high-income households
    Real _L_hl;           // Loans to low-income households
    Real _N;              // Total population
    Real _OF;             // Own funds (bank capital)
    Real _V_FS;           // Foreign sector nominal wealth
    Real _V_Mh;           // High-income households liquid wealth (excluding equities)
    Real _V_Ml;           // Gross monetary assets (broad money) - low income households
    Real _W;              // Nominal wages
    Real _e;              // Quanitity of firm equities
    Real _g;              // Real government expenditures (government spending on goods and services)
    Real _in ;            // Real inventory
    Real _k ;             // Real capital stock
    Real _phi;            // Actual mark-up
    Real _pr ;            // Labour productivity
    Real _s_e;            // Expected real sales
    Real _v_he;           // Expected real wealth of high-income households
    Real _v_RES;          // Real value of residential buildings

    //--------------------------------------------
    // Non-state variables
    //--------------------------------------------
    Real B_FS;                                            // Bills held by foreign sector
    Real B_b;                                             // Bills held by banks
    Real B_cb;                                            // Bills held by the Central Bank
    Real B_h;                                             // Bills held by households
    Real C (start = 1e+13, fixed = false);                // Nominal consumption    
    Real CAR;                                             // Actual capital adequacy ratio
    Real C_h;                                             // Nominal consumption, high income households
    Real C_l (start = 5e+12, fixed = false);              // Nominal consumption, low income households
    Real CD (start = 1e+13, fixed = false);               // Nominal consumption of domestically manufactured goods and services
    Real ER;                                              // Employment rate
    Real FD_b;                                            // Bank dividends
    Real FD_f (start = 1e+12, fixed = false);             // Firm dividends    
    Real FU_b;                                            // Actual retained earnings of banks
    Real FU_bT;                                           // Target retained earnings of banks
    Real FU_f;                                            // Retained earnings
    Real FU_fT (start = 5.5e+11, fixed = false);          // Planned retained earnings
    Real F_b;                                             // Actual profits of banks    
    Real F_bT;                                            // Target profits of banks
    Real F_f (start = 3e+12, fixed = false);              // Realised net profits
    Real F_fT;                                            // Net profits target
    Real G;                                               // Nominal pure government expenditures    
    Real GD;                                              // Nominal government debt
    Real GL;                                              // Gross lending to households (mortgage origination volume)
    Real GL_h (start = 1.4e+11, fixed = false);           // Gross lending to high income households
    Real GL_l;                                            // Gross lending to low income households
    Real H;                                               // High powered money
    Real H_b;                                             // Bank reserves
    Real H_h;                                             // Amount of cash held by households
    Real H_hh (start = 2e+12, fixed = false);             // Cash held by high income households    
    Real H_hl;                                            // Cash held by low income households
    Real I (start = 3e+12, fixed = false);                // Nominal gross investment
    Real IM;                                              // Nominal net imports
    Real IN;                                              // Nominal inventories    
    Real I_f (start = 2e+12, fixed = false);              // Nominal gross corporate investment
    Real I_h;                                             // Nominal total real estate investment (construction costs)
    Real I_hh (start = 2e+11, fixed = false);             // Nominal real estate investment, high income households
    Real I_hl;                                            // Nominal real estate investment, low income households        
    Real K;                                               // Nominal capital stock
    Real LD_T;                                            // Employment target    
    Real LS;                                              // Labour supply    
    Real L_h;                                             // Loans to households
    Real M (start = 1e+13, fixed = false);                // Total money deposits
    Real M_FS;                                            // Money deposits owned by foreign sector
    Real NES;                                             // New equity sales    
    Real NL;                                              // Net lending to households
    Real NL_h;                                            // Net lending to high income households
    Real NL_l;                                            // Net lending to low income households
    Real NUC;                                             // Normal unit cost
    Real OF_T;                                            // Own funds (bank capital) target
    Real PE;                                              // Price to earnings ratio
    Real PSBR;                                            // Nominal government deficit    
    Real REP;                                             // Total household loans repayments
    Real REP_h;                                           // Loans repayment, high-income households
    Real REP_l;                                           // Loans repayment, low-income households                                                  
    Real S;                                               // Nominal sales
    Real T;                                               // Income taxes    
    Real T_f;                                             // Corporate taxes on profits
    Real T_h;                                             // Income taxes    
    Real T_hh;                                            // Income taxes, high income households
    Real T_hl;                                            // Income taxes, low income households
    Real UB;                                              // Unemployment benefits
    Real UC;                                              // Unit cost
    Real UR;                                              // Unemployment rate
    Real V;                                               // Nominal net wealth
    Real V_M;                                             // Gross monetary assets (broad money) held by households
    Real V_MlT (start = 5e+12, fixed = false);            // Gross monetary assets (broad money) target, low income households
    Real V_RE;                                            // Nominal value of real estate 
    Real V_RES;                                           // Nominal value of residential buildings
    Real V_REh;                                           // Nominal value of real estate owned by high income households    
    Real V_REl;                                           // Nominal value of real estate owned by low income households       
    Real V_fmah (start = 1e+13, fixed = false);           // Investible wealth, held only by high income households
    Real V_h (start = 1e+13, fixed = false);              // Nominal net wealth of high income households
    Real V_l;                                             // Nominal net wealth of low income households
    Real WB;                                              // Nominal wage bill
    Real WB_h;                                            // Wage bill, high income households
    Real WB_l;                                            // Wage bill, low income households
    Real Y;                                               // Nominal GDP, production approach
    Real YD_r (start = 1e+13, fixed = false);             // Nominal disposable income    
    Real YD_rh (start = 5e+12, fixed = false);            // Nominal disposable income, high income households    
    Real YD_rl (start = 5e+12, fixed = false);            // Nominal disposable income, low income households
    Real YP;                                              // Nominal personal income
    Real YP_h (start = 5e+12, fixed = false);             // Nominal household income, high income households
    Real YP_l;                                            // Nominal household income, low income households
    Real add_l;                                           // Lending mark-up over deposit rate target
    Real c (start = 1e+9, fixed = false);                 // Real consumption
    Real cd (start = 1e+9, fixed = false);                // Real consumption of domestically manufactured goods and services
    Real c_h (start = 6e+8, fixed = false);               // Real consumption, high income households
    Real c_l;                                             // Real consumption, low income households    
    Real gr_k;                                            // Real capital stock growth rate    
    Real gr_pr;                                            // Productivity growth
    Real i (start = 5e+8, fixed = false);                 // Real gross investment    
    Real i_f (start = 4e+8, fixed = false);               // Real gross corporate investment
    Real i_h;                                             // Total real real estate investment (construction costs)
    Real i_hh;                                            // Real real estate investment, high-income households
    Real i_hl;                                            // Real real estate investment, low-income households
    Real im;                                              // Real net imports
    Real in_T;                                            // Inventory target
    Real nl;                                              // Real personal lending to households
    Real nl_h (start = 2e+7, fixed = false);              // Real personal lending to high-income households    
    Real nl_l;                                            // Real personal lending to low-income households
    Real omega_r;                                         // Real wage aspirations rate 
    Real omega_t;                                         // Real wage aspirations target
    Real p;                                               // Normal cost pricing
    Real p_e (start = 3e+7, fixed = false);               // Price of equities    
    Real phi_T;                                           // Actual mark-up target
    Real pi (start = 0.03, fixed = false);                // Price inflation rate
    Real q;                                               // Tobin's q ratio
    Real r_K (start = 0.03, fixed = false);               // Firms dividend yield
    Real r_l (start = 0.05, fixed = false);               // Loan interest rate
    Real rr_l;                                            // Real loan interest rate
    Real s (start = 2e+9, fixed = false);                 // Real sales
    Real u;                                               // Capital utilisation
    Real v;                                               // Real net wealth
    Real v_RE;                                            // Real value of real estate
    Real v_REh;                                           // Real value of real estate owned by high income households
    Real v_REl;                                           // Real value of real estate owned by low income households
    Real v_h;                                             // Real net wealth high income households
    Real v_l;                                             // Real net wealth low income households
    Real y;                                               // Real output    
    Real yd_r;                                            // Real regular disposable income
    Real yd_rh;                                           // Real disposable income, high income households
    Real yd_rl;                                           // Real disposable income, low income households

    //--------------------------------------------
    // Probes
    //--------------------------------------------
    Real x_g__y;                                            // Government spending on goods and services to GDP
    Real x_WB__Y;                                           // Labour share (wage bill/GDP)
    Real x_F__Y;                                            // Profit rate
    Real x_T_f__Y;                                          // Share of corporate taxes in GDP
    Real x_T_hh__Y;                                         // Share of high-income household taxes in GDP
    Real x_T_h__Y;                                          // Share of household taxes in GDP
    Real x_T_hl__Y;                                         // Share of low-income household taxes in GDP
    Real x_YP_h__Y;                                         // Share of high-income household gross income in GDP
    Real x_YP_l__Y;                                         // Share of low-income household gross income in GDP
    Real x_YD_rh__Y;                                        // Share of high-income disposable household income in GDP
    Real x_YD_rl__Y;                                        // Share of low-income disposable household income in GDP    
    Real x_YD_rh__YD;                                       // Share of high-income disposable household income in total disposable income
    Real x_YD_rl__YD;                                       // Share of low-income disposable household income in total disposable income    
    Real x_GD__Y;                                           // Government debt / GDP
    Real x_NL__Y;                                           // Net household lending to GDP
    Real x_GL__Y;                                           // Mortgage origination to GDP
    Real x_YD__Y;                                           // Nominal disposable income to GDP
    Real x_L_h__Y;                                          // Household liabilities to GDP ratio
    Real x_L_f__Y;                                          // Firms debt to GDP ratio
    Real x_I_h__Y;                                          // Share of house construction in GDP
    Real x_I_f__Y;                                          // Share of private nonresidential fixed investment in GDP
    Real x_I__Y;                                            // Share of private investment in GDP
    Real x_V__Y;                                            // Wealth to GDP
    Real x_V_RE__Y;                                         // Value of real estate to GDP
    Real x_V_RES__Y;                                        // Value of residential buildings to GDP
    Real x_V_eq;                                            // Value of the equities
    Real x_V_eq__Y;                                         // Value of the equities to GDP
    Real x_py;                                              // Y = p * y
    Real x_yd_rhpp;                                         // Real personal income per capita in high income households
    Real x_yd_rlpp;                                         // Real personal income per capita in low income households    
    Real x_IM__Y;                                           // Trade deficit as a fraction of GDP
    Real x_V_FS__Y;                                         // Foreign debt as a fraction of GDP 
    Real x_B_FS__Y;                                         // Foreign holdings of government securities as a fraction of GDP
    Real x_PSBR__Y;                                         // Nominal budget deficit / GDP
    Real x_GINI;                                            // Gini coefficient for net disposable income
    
    // Probes used for model consistency checks
    Real x_Y_exp;                                           // Nominal GDP expenditure approach calculated from C, G, I
    Real x_Y_inc;                                           // Nominal GDP income approach calculated from WB, F_f, F_b
    Real x_A_B;                                             // Bank assets
    Real x_LE_B;                                            // Bank liabilities and equity
    Real x_M_s;                                             // Money supply
    Real x_M_d;                                             // Money demand
    Real x_LE_GB;                                           // Government securities + bank assets - bank capital
    
    // Other probes
    Real x_PSAVERT;                                         // Personal Saving Rate
    Real x_CREDIMP;                                         // "Credit Impulse"
    Real x_RPSG;                                            // "Private Demand Growth"
 
    // Probes for TFM
    Real tfm_Cdom;                                          // Domestic consumption
    Real tfm_FD;                                            // Total distributed profits
    Real tfm_rlLf;                                          // Interests on firms loans
    Real tfm_rlLhh;                                         // Interests on mortgages of high income households
    Real tfm_rlLhl;                                         // Interests on mortgages of low income households
    Real tfm_rlLfh;                                         // Interests on firm loans and mortgages
    Real tfm_rmMdom;                                        // Interests on domestic bank deposits
    Real tfm_rmM;                                           // Total interests on bank deposits
    Real tfm_rmMfs;                                         // Interests on bank deposits of foreign sector
    Real tfm_rmBh;                                          // Interests on bills held by households
    Real tfm_rmBb;                                          // Interests on bills held by banks
    Real tfm_rmBngs;                                        // Total interests on bills not held by central bank
    Real tfm_rmBfs;                                         // Interests on bills held by foreign sector
    Real tfm_der_Lf;                                        // Net lending to firms
    Real tfm_der_Lhh;                                       // Net lending to high income households
    Real tfm_der_Lhl;                                       // Net lending to low income households
    Real tfm_der_L;                                         // Total net lending
    Real tfm_der_Mdom;                                      // Net domestic saving in bank deposits
    Real tfm_der_M;                                         // Total net saving in bank deposits
    Real tfm_der_Mfs;                                       // Net saving in bank deposits of foreign sector
    Real tfm_der_Hhh;                                       // Net high income household sector saving in currency
    Real tfm_der_Hhl;                                       // Net low income household sector saving in currency
    Real tfm_der_Hb;                                        // Net increase in the reserve position of banks
    Real tfm_der_H;                                         // Total net saving in currency
    Real tfm_der_Bh;                                        // Net domestic saving in government securities
    Real tfm_der_Bb;                                        // Net acquisition of government securities by banks
    Real tfm_der_Bcb;                                       // Net acquisition of government securities by central bank
    Real tfm_der_B;                                         // Total net acquisition of government securities
    Real tfm_der_Bfs;                                       // Net acquisition of government securities by foreign sector
    Real tfm_der_e_pe;                                      // Net sales of equities
      
    Real sum_of_flows_Firms;
    Real sum_of_flows_HH_H;
    Real sum_of_flows_HH_L;
    Real sum_of_flows_Banks;
    Real sum_of_flows_CB;
    Real sum_of_flows_Gov;
    Real sum_of_flows_ForeignSector;

    //--------------------------------------------
    // Short-term equilibrium
    //--------------------------------------------    
    equation // References to the Thesis are in brackets ()
    
    //--------------------
    // Firms - aggregate demand, production and investment decisions
    //--------------------
    y = _s_e + gamma * (in_T - _in); // (11)  
    der(_s_e) = beta * (s - _s_e); // (12)
    in_T = sigma_T * _s_e; // (13)
    der(_in) = y - s; // (14)
    der(_k) = _k * log(1 + gr_k); // (15)
    gr_k = Ramp(((1 + gr_pr) * ( 1 + gr_N) - 1) + gamma_u * (u - u_0)); // (16)
    u = y / _k; // (17)
    rr_l = (1 + r_l) / (1 + pi) - 1; // (18)
    pi = der(p) / p; // (19)
    i_f = (gr_k + delta) * _k; // (20)
    i = i_f + i_h; // (21)
    s = cd + _g + i; // (22)
    S = s * p; // (23)
    IN = _in * UC; // (24)
    I_f = i_f * p; // (25)
    I = I_f + I_h; // (26)
    K = _k * p;  // (27)
    Y = S + der(_in) * UC;  // (28)
    
    //--------------------
    // The labour market
    //--------------------   
    omega_r = omega_0 * (1 - omega_1 * Ramp(ER_min - ER) + omega_2 * Ramp(ER - ER_max)); // (29)
    omega_t = omega_r * _pr; // (30)
    ER = _LD / LS; // (31)
    UR = Ramp(1 - ER); // (32)
    der(_N) = _N * log(1 + gr_N); // (33)
    LS = _N * LF_N; // (34)
    der(_W) = Omega_3 * (omega_t * p - _W); // (35)
    gr_pr =   if ER > ER_pr1 then gr_pr0 elseif ER > ER_pr0 then  gr_pr0 * (ER - ER_pr0) / (ER_pr1 - ER_pr0) else 0; // (36)
    der(_pr) = _pr * log(1 + gr_pr); // (37)
    LD_T = y / _pr; // (38)
    der(_LD) = eta_LD * Ramp(LD_T - _LD) - eta_LDr * Ramp(_LD - LD_T); // (39)
    WB = _LD * _W; // (40)
    WB_h = WB * HILD; // (41)
    WB_l = WB * (1 - HILD); // (42)
    UC = WB / y; // (43)
    NUC = _W / _pr; // (44)

    //--------------------
    // Prices, markups and profits
    //--------------------       
    p = (1 + _phi) * NUC; // (45)
    der(_phi) = epsilon_M * (phi_T - _phi); // (46)
    phi_T = (F_fT +  r_l * _L_f + T_f)/ (_s_e * UC); // (47)
    T_f = F_f * Theta_f; // (48)
    F_f = S - WB - r_l * _L_f - T_f; // (49)
    F_fT = FU_fT + FD_f; // (50)
    FU_fT = psi_U * I_f; // (51)
    FD_f = psi_D * F_f; // (52)
    FU_f = F_f - FD_f; // (53)
    der(_L_f) = I_f - FU_f - NES; // (54)
    der(_e) = NES / p_e; // (55)
    NES = psi_N * I_f; // (56)
    r_K = FD_f / (_e * p_e); // (57)
    PE = _e * p_e / F_f; // (58)
    q = (_e * p_e + _L_f) / (K + IN); // (59)
    
    //--------------------
    // Households - income, consumption and financial wealth
    //--------------------
    YP_h = WB_h + FD_f + FD_b + r_m * (M - M_FS) + r_m * B_h; // (60)
    YP_l = WB_l; // (61)
    YP = YP_l + YP_h; // (62)
    T_hl = Theta_hl * YP_l; // (63)
    T_hh = Theta_hh * YP_h; // (64)
    T_h = T_hl + T_hh; // (65)
    YD_rh = YP_h - T_hh - r_l * _L_hh; // (66)
    YD_rl = YP_l - T_hl - r_l * _L_hl + UB; // (67)
    UB = UR * UBR * _W * LS; // (68)
    YD_r = YD_rl + YD_rh; // (69)
    yd_rh = YD_rh / p; // (70)
    yd_rl = YD_rl / p; // (71)
    yd_r = yd_rl + yd_rh; // (72)
    der(_V_Mh) = YD_rh - C_h - I_hh + NL_h - NES; // (73)
    der(_V_Ml) = YD_rl - C_l - I_hl + NL_l; // (74)
    V_M = _V_Mh + _V_Ml; // (75)
    V_fmah = _V_Mh - H_hh + _e * p_e; // (76)
    V_MlT = lambda_c * C_l; // (77)
    V_h = _V_Mh + _e * p_e + _OF - _L_hh + V_REh; // (78)
    V_l = _V_Ml + V_REl - _L_hl; // (79)
    V = V_h + V_l; // (80)
    v_h = V_h / p; // (81)
    v_l = V_l / p; // (82)
    v = v_h + v_l; // (83)
    der(_v_he) = _v_he * log((1 + gr_N) * (1 + gr_pr)) + epsilon_vh * Ramp(v_h - _v_he) - epsilon_vhr * Ramp(_v_he - v_h); // (84)
    c_h = alpha_2 * _v_he; // (85)
    c_l = C_l / p; // (86)
    c = c_l + c_h; // (87)
    cd = (1 - mu) * c; // (88)
    C_h = c_h * p;  // (89)
    C_l = YD_rl + NL_l - I_hl - epsilon * (V_MlT - _V_Ml);  // (90)
    C = C_l + C_h; // (91)
    CD = (1 - mu) * C; // (92)
    H_hh = lambda_c * C_h; // (93)
    H_hl = _V_Ml; // (94)
    H_h = H_hh + H_hl; // (95)
    B_h = V_fmah * (lambda_20 + lambda_22 * r_m - lambda_24 * r_K - lambda_25 * YD_rh / V_h); // (96)
    p_e = V_fmah / _e * (lambda_40 - lambda_42 * r_m + lambda_44 * r_K - lambda_45 * YD_rh / V_h); // (97)
    M = _V_Mh - B_h - H_hh + M_FS; // (98)
    
    //--------------------
    // Households - mortgage lending and real estate assets
    //--------------------   
    GL = eta * YD_r; // (99)
    GL_h = HILE * GL; // (100)
    GL_l = GL - GL_h; // (101)
    REP_h = delta_rep * _L_hh; // (102)
    REP_l = delta_rep * _L_hl; // (103)
    REP = REP_h + REP_l; // (104)
    NL_h = GL_h - REP_h; // (105)
    NL_l = GL_l - REP_l; // (106)
    NL = NL_h + NL_l; // (107)
    der(_L_hh) = NL_h; // (108) 
    der(_L_hl) = NL_l; // (109)
    L_h = _L_hh + _L_hl; // (110)
    nl_h = NL_h / p; // (111)
    nl_l = NL_l / p; // (112)
    nl = nl_h + nl_l; // (113)
    I_hh = GL_h * IHMOV; // (114)
    I_hl = GL_l * IHMOV; // (115)
    I_h = I_hh + I_hl; // (116)                             
    i_hh = I_hh / p; // (117)              
    i_hl = I_hl / p; // (118)  
    i_h = i_hh + i_hl; // (119)
    V_REh = _L_hh * REMOR; // (120)
    V_REl = _L_hl * REMOR; // (121)
    V_RE = V_REh + V_REl; // (122)
    v_REh = V_REh / p; // (123)
    v_REl = V_REl / p; // (124)
    v_RE = V_RE / p; // (125)
    der(_v_RES) = i_h - _v_RES * delta_RES; // (126)
    V_RES = p * _v_RES; // (127)

    //-----------------------------------------
    // The public sector
    //-----------------------------------------
    T = T_hl + T_hh + T_f; // (128)
    G = p * _g; // (129)
    der(_g) = _g * log(1 + gr_g - epsilon_GYR * (_g/y - GYR)); // (130)
    PSBR = G + r_m * (B_h + B_b + B_FS) - T + UB; // (131)
    der(_B) = PSBR; // (132)
    GD = B_b + B_h + H + B_FS; // (133)
    H = H_b + H_h; // (134)
    B_cb = H; // (135)

    //-----------------------------------------
    // The foreign sector
    //-----------------------------------------
    im = c * mu; // (136)
    IM = C * mu; // (137)
    der(_V_FS) = IM + r_m * B_FS + r_m * M_FS; // (138)
    B_FS = lambda_50 * _V_FS; // (139)
    M_FS = (1 - lambda_50) * _V_FS; // (140)
        
    //-----------------------------------------
    // The banking sector
    //-----------------------------------------
    FU_b = F_b - FD_b; // (141)
    der(_OF) = FU_b; // (142)
    B_b = _B - B_h - B_cb - B_FS; // (143)
    F_b = r_l * (_L_f + L_h) + r_m * B_b - r_m * M; // (144)
    H_b = rho * M; // (145)
    r_l = r_m + add_l; // (146)
    OF_T = NCAR * (_L_f + L_h); // (147)
    FU_bT = Ramp(der(OF_T)); // (148)
    FD_b = r_K *_OF; // (149)
    F_bT = FD_b + FU_bT; // (150)
    add_l = (F_bT - r_m * B_b + r_m * (M - _L_f - L_h)) / (_L_f + L_h); // (151)
    CAR = _OF / (_L_f + L_h); // (152)
    
    //--------------------------------------------
    // Sanity checks 
    //--------------------------------------------
    x_Y_exp = CD + I + G; // (155)
    x_Y_inc = WB + F_b + F_f + _L_f * r_l; // (156)
    x_A_B = _L_f + L_h + B_b + H_b; // (158)
    x_LE_B = _OF + M; // (159)
    x_M_d = V_M  + M_FS - B_h - H_h; // (161)
    x_M_s = _L_f + L_h + B_b + H_b - _OF; // (162)
    x_LE_GB = _B + _L_f + L_h - _OF; // (165)
    
    assert(AlmostEqual(Y,x_Y_exp),
      "GDP calculated using the production (value added) and expenditure approach must be almost the same"); // (153)
    assert(AlmostEqual(Y,x_Y_inc),
      "GDP calculated using the production (value added) and income approach must be almost the same"); // (154)
    assert(AlmostEqual(x_A_B,x_LE_B),
      "Banks assets and liabilities + equity must be equal"); // (157)
    assert(AlmostEqual(x_M_d,x_M_s),
      "Money demand calculated from all households broad money stock must be almost the same as the money supply calculated from banks asset sheet"); // (160)
    assert(AlmostEqual(M,x_M_d),
      "Money demand calculated from high-income households broad money stock must be almost the same as the money demad calculated for all households"); // (163)
    assert(AlmostEqual(V_M + _V_FS,x_LE_GB),
      "Stock of broad money must be equal to the stock of government securities held by the private and foreign sectors + bank assets - bank capital"); // (164))
       
    //-----------------------------------------
    // Probes
    //-----------------------------------------
    x_g__y = _g / y;
    x_WB__Y = WB / Y;
    x_F__Y = 1 - x_WB__Y;
    x_T_f__Y =  T_f / Y;
    x_T_h__Y = T_h / Y;
    x_T_hh__Y =  T_hh / Y;
    x_T_hl__Y =  T_hl / Y;    
    x_YP_h__Y = YP_h / Y;
    x_YP_l__Y = YP_l / Y;
    x_YD_rh__Y = YD_rh / Y;
    x_YD_rl__Y = YD_rl / Y;    
    x_YD_rh__YD = YD_rh / YD_r;
    x_YD_rl__YD = YD_rl / YD_r;    
    x_GD__Y = GD / Y;
    x_NL__Y = NL / Y;
    x_GL__Y = GL / Y;
    x_YD__Y = YD_r / Y;    
    x_L_h__Y = L_h / Y;                              
    x_L_f__Y = _L_f / Y;                              
    x_I_h__Y = I_h / Y;
    x_I_f__Y = I_f / Y;
    x_I__Y = I / Y;
    x_V__Y = V / Y;
    x_V_RE__Y = V_RE / Y;
    x_V_RES__Y = V_RES / Y;
    x_V_eq = _e * p_e;
    x_V_eq__Y = _e * p_e / Y;
    x_py = p * y;     
    x_yd_rhpp = yd_rh / (_N * HIN);                                       
    x_yd_rlpp = yd_rh / (_N * (1 - HIN));      
    x_PSBR__Y = PSBR / Y;
    x_GINI = (1 - HIN) - x_YD_rl__YD;
    
    x_IM__Y = IM / Y;
    x_V_FS__Y = _V_FS / Y;
    x_B_FS__Y = B_FS / Y;
        
    x_PSAVERT = (YD_r - C) / YD_r; 
    x_CREDIMP = der(der(_L_f + L_h) / Y);
    x_RPSG = der(c + i) / ( c + i) - (1 + gr_N) * (1 + gr_pr) + 1;
    
    // Probes for TFM
    tfm_Cdom = C - IM;
    tfm_FD = FD_f + FD_b;
    tfm_rlLf = r_l * _L_f;
    tfm_rlLhh = r_l * _L_hh;
    tfm_rlLhl = r_l * _L_hl;
    tfm_rlLfh = r_l * (_L_f + _L_hh + _L_hl);
    tfm_rmMdom = r_m * (M - M_FS);
    tfm_rmM = r_m * M;
    tfm_rmMfs = r_m * M_FS;
    tfm_rmBh = r_m * B_h;
    tfm_rmBb = r_m * B_b;
    tfm_rmBngs = r_m * (_B-B_cb);
    tfm_rmBfs = r_m * B_FS;
    tfm_der_Lf = I_f - FU_f - NES;//der(_L_f);
    tfm_der_Lhh = NL_h;//der(_L_hh);
    tfm_der_Lhl = NL_l;//der(_L_hl); 
    tfm_der_L = tfm_der_Lf + tfm_der_Lhh + tfm_der_Lhl;
    tfm_der_Mdom = der(M-M_FS);
    tfm_der_M = der(M); 
    tfm_der_Mfs = der(M_FS);                                      
    tfm_der_Hhh = der(H_hh);
    tfm_der_Hhl = der(H_hl);
    tfm_der_Hb = der(H_b); 
    tfm_der_H = der(H);
    tfm_der_Bh = der(B_h);
    tfm_der_Bb = der(B_b); 
    tfm_der_Bcb = der(B_cb);
    tfm_der_B = PSBR;//der(_B);
    tfm_der_Bfs = der(B_FS);
    tfm_der_e_pe = NES;//der(_e) * p_e;   
   
    sum_of_flows_Firms = tfm_Cdom + I_h + G - T_f - WB - FD_f - tfm_rlLf + tfm_der_Lf  + tfm_der_e_pe;
    sum_of_flows_HH_H = -C_h - I_hh - T_hh + WB_h + tfm_FD - tfm_rlLhh + tfm_rmMdom + tfm_rmBh + tfm_der_Lhh - tfm_der_Mdom - tfm_der_Hhh - tfm_der_Bh - tfm_der_e_pe;
    sum_of_flows_HH_L = -C_l - I_hl - T_hl + WB_l + UB - tfm_rlLhl + tfm_der_Lhl - tfm_der_Hhl;
    sum_of_flows_Banks = -FD_b + tfm_rlLfh - tfm_rmM + tfm_rmBb - tfm_der_L  + tfm_der_M - tfm_der_Hb - tfm_der_Bb;
    sum_of_flows_CB = tfm_der_H - tfm_der_Bcb;
    sum_of_flows_Gov = -G + T - UB - tfm_rmBngs + tfm_der_B;
    sum_of_flows_ForeignSector = IM + r_m * M_FS + tfm_rmBfs - tfm_der_Mfs - tfm_der_Bfs;

    //--------------------------------------------
    // Validation of individual variables
    //--------------------------------------------
    assert(_B > 0, "Government bills must be positive");
    assert(_LD > 0, "Labour demand reduced to simple labour must be positive");
    assert(_L_f > 0, "Loans to firms must be positive");
    assert(_L_hh > 0, "Loans to high-income households must be positive");
    assert(_L_hl > 0, "Loans to low-income households must be positive");
    assert(_N > 0, "Total population must be positive");
    assert(_OF > 0, "Own funds (bank capital) must be positive");
    assert(_V_Mh > 0, "High-income households liquid wealth (excluding equities) must be positive");
    assert(_V_Ml > 0, "Gross monetary assets (broad money) - low income households must be positive");
    assert(_W > 0, "Nominal wages must be positive");
    assert(_e > 0, "Quanitity of firm equities must be positive");
    assert(_g > 0, "Real government expenditures must be positive");
    assert(_in > 0, "Real inventory must be positive");
    assert(_k > 0, "Real capital stock must be positive");
    assert(_phi > 0, "Actual mark-up must be positive");
    assert(_pr > 0, "Labour productivity must be positive");
    assert(_s_e > 0, "Expected real sales must be positive");
    assert(_v_he > 0, "Real value of high income expected wealth must be positive");
    assert(_v_RES > 0, "Real value of residential buildings must be positive");
    
    assert(add_l > 0, "Lending Mark-up over Deposit Rate target must be > 0");
    assert(B_b > 0, "Bills Held by Banks must be > 0");
    assert(B_cb > 0, "Bills Held by the Central Bank must be > 0");
    assert(B_h > 0, "Bills Held by Households must be > 0");
    assert(C > 0, "Nominal Consumption must be > 0");
    assert(c > 0, "Real Consumption must be > 0");
    assert(CAR > 0, "Actual Capital Adequacy Ratio must be > 0");
    assert(ER > 0, "Employment Rate must be > 0");
    assert(eta > 0, "New Loans to Personal Income Ratio must be > 0");
    assert(F_b > 0, "Actual Profits of Banks must be > 0");
    assert(F_bT > 0, "Target Profits of Banks must be > 0");
    assert(F_f > 0, "Realised net profits must be > 0");
    assert(F_fT > 0, "Net profits target must be > 0");
    assert(FD_b > 0, "Bank Dividends must be > 0");
    assert(FD_f > 0, "Firm dividends must be > 0");
    assert(FU_b /_OF >= -0.01, "Actual Retained Earnings of Banks / Own Funds must be >= -1%");
    assert(FU_bT >= 0, "Target Retained Earnings of Banks must be >= 0");
    assert(FU_f > 0, "Retained Earnings must be > 0");
    assert(FU_fT > 0, "Planned Retained Earnings must be > 0");
    assert(G > 0, "Nominal Pure Government Expenditures must be > 0");
    assert(GD > 0, "Nominal Government Debt must be > 0");
    assert(GL > 0, "Gross Lending to households (Mortgage Origination Volume) must be > 0");
    assert(GL_h > 0, "Gross Lending (Mortgage Origination Volume) to high-income households must be > 0");
    assert(GL_l > 0, "Gross Lending (Mortgage Origination Volume) to low-income households must be > 0");
    assert(gr_k >= -0.001, "Real Capital Stock Growth Rate must be >= 0");
    assert(gr_pr >= -0.001, "Productivity Growth Rate must be >= 0");
    assert(H_b > 0, "Bank Reserves must be > 0");
    assert(H_h > 0, "Amount of Cash Held by Households must be > 0");
    assert(H > 0, "High Powered Money must be > 0");
    assert(I_hh > 0, "Nominal real estate investment (construction costs), high-income households must be > 0");
    assert(I_hl > 0, "Nominal real estate investment (construction costs), low-income households must be > 0");
    assert(I_h > 0, "Nominal total real estate investment (construction costs) must be > 0");
    assert(i_hh > 0, "Real real estate investment (construction costs), high-income households must be > 0");
    assert(i_hl > 0, "Real real estate investment (construction costs), low-income households must be > 0");
    assert(i_h > 0, "Total real real estate investment (construction costs) must be > 0");
    assert(i > 0, "Real gross investment must be > 0");
    assert(i_f > 0, "Real gross corporate investment must be > 0");
    assert(I > 0, "Nominal gross investment must be > 0");
    assert(I_f > 0, "Nominal Gross corporate investment must be > 0");
    assert(in_T > 0, "Inventory Target must be > 0");
    assert(IN > 0, "Nominal Inventories must be > 0");
    assert(K > 0, "Nominal Capital Stock must be > 0");
    assert(L_h > 0, "Loans to households must be > 0");
    assert(LS > 0, "Labour supply must be > 0");
    assert(M > 0, "Money Deposits must be > 0");
    assert(NES > 0, "New equity sales must be > 0");
    // NO assert(NL > 0, "Net Lending to households must be > 0");
    // NO assert(NL_h > 0, "Net Lending to high-income households must be > 0");
    // NO assert(NL_l > 0, "Net Lending to low-income households must be > 0");
    // NO assert(nl > 0, "Real Personal Lending to households must be > 0");
    // NO assert(nl_h > 0, "Real Personal Lending to high-income households must be > 0");
    // NO assert(nl_l > 0, "Real Personal Lending to low-income households must be > 0");
    assert(NUC > 0, "Normal Unit Cost must be > 0");
    assert(OF_T > 0, "Own Funds (Bank Capital) Target must be > 0");
    assert(omega_t > 0, "Real Wage Aspirations must be > 0");
    assert(p_e > 0, "Price of Equities must be > 0");
    assert(p > 0, "Normal Cost Pricing must be > 0");
    assert(PE > 0, "Price to Earnings Ratio must be > 0");
    assert(phi_T > 0, "Actual Mark-up target must be > 0");
    assert(pi > -0.03, "Price Inflation Rate must be > -0.03");
    // NO assert(PSBR > 0, " Nominal Government Deficit must be > 0");
    assert(q > 0, "Tobin's q Ratio must be > 0");
    assert(r_K > 0, "Firms Dividend Yield must be > 0");
    assert(r_l > 0, "Loan Interest Rate must be > 0");
    assert(REP_h > 0, "Loans Repayment, high-income households must be > 0");
    assert(REP_l > 0, "Loans Repayment, low-income households must be > 0");
    assert(REP > 0, "Total household loans repayments must be > 0");
    assert(rr_l > -0.035, "Real Loan Interest Rate must be > -0.035");
    assert(s > 0, "Real Sales must be > 0");
    assert(S > 0, "Nominal Sales must be > 0");
    assert(T > 0, "Income Taxes must be > 0");
    assert(u > 0, "Capital Utilisation must be > 0");
    assert(UC > 0, "Unit Cost must be > 0");
    assert(WB > 0, "Nominal Wage Bill must be > 0");
    assert(Y > 0, "Nominal GDP - production approach must be > 0");
    assert(y > 0, "Real Output must be > 0");
    assert(YD_r > 0, "Nominal Disposable Income must be > 0");
    assert(yd_r > 0, "Real Regular Disposable Income must be > 0");
    assert(YP > 0, "Nominal Personal Income must be > 0");
    assert(r_m > 0, "Deposit Interest Rate set by CB must be > 0");
    assert(LD_T > 0, "Employment Target must be > 0");
    assert(WB_h > 0, "Wage bill - high income households must be > 0");
    assert(WB_l > 0, "Wage bill - low income households must be > 0");
    assert(YP_l > 0, "Nominal household income - low income households must be > 0");
    assert(YP_h > 0, "Nominal household income - high income households must be > 0");
    assert(T_h > 0, "Income taxes must be > 0");
    assert(T_hl > 0, "Income taxes - low income households must be > 0");
    assert(T_hh > 0, "Income taxes - high income households must be > 0");
    assert(T_f > 0, "Corporate taxes on profits must be > 0");
    assert(YD_rl > 0, "Nominal Disposable Income - low income households must be > 0");
    assert(YD_rh > 0, "Nominal Disposable Income - high income households must be > 0");
    assert(yd_rl > 0, "Real Disposable Income - low income households must be > 0");
    assert(yd_rh > 0, "Real Disposable Income - high income households must be > 0");
    assert(C_l > 0, "Nominal Consumption - low income households must be > 0");
    assert(C_h > 0, "Nominal Consumption - high income households must be > 0");
    assert(c_l > 0, "Real Consumption - low income households must be > 0");
    assert(c_h > 0, "Real Consumption - high income households must be > 0");
    assert(V_MlT > 0, "Gross monetary assets (broad money) target - low income households must be > 0");
    assert(V_M > 0, "Gross monetary assets (broad money) held by households must be > 0");
    assert(V_fmah > 0, "Investible wealth must be > 0");
    assert(V_RES > 0, "Residential buildings value must be > 0");
    assert(H_hh > 0, "Cash held by high income households must be > 0");
    assert(H_hl > 0, "Cash held by low income households must be > 0");
    assert(V_h > 0, "Nominal net wealth of high income households must be > 0");
    assert(V_l > 0, "Nominal net wealth of low income households must be > 0");
    assert(V > 0, "Nominal net wealth must be > 0");
    assert(V_REh > 0, "Nominal value of real estate owned by high income households must be > 0");
    assert(V_REl > 0, "Nominal net wealth must be > 0");
    assert(V_RE > 0, "Nominal net wealth must be > 0");
    assert(v_REh > 0, "Real value of real estate owned by high income households must be > 0");
    assert(v_REl > 0, "Real value of real estate owned by low income households must be > 0");
    assert(v_RE > 0, "Real net wealth must be > 0");
    assert(v_h > 0, "Real net wealth high income households must be > 0");
    assert(v_l > 0, "Real net wealth low income households must be > 0");
    assert(v > 0, "Real net wealth must be > 0");
    assert(UB >= 0, "Unemployment Benefits (source of household income) must be >= 0");
   
    //--------------------------------------------
    // parameters
    //--------------------------------------------
    beta = 12;
    delta = 0.10667;
    delta_RES = 0.02; 
    delta_rep = 0.15; 
    epsilon = 6;
    epsilon_M = 0.1;
    epsilon_vh = 0.5;
    epsilon_vhr = 1;
    eta_LD = 0.6;
    eta_LDr = 2;
    gamma = 6;
    gamma_u = 0.1;
    gr_N = 0.01;
    gr_pr0 = 0.02;
    IHMOV = 0.55;
    lambda_b = 0.0153;
    lambda_c = 0.05;
    NCAR = 0.1;
    ER_max = 0.96;   // 4%
    ER_min = 0.935;  // 6.5%
    omega_1 = 1.0;   // in deflation
    omega_2 = 2.0;   // in inflation
    HILE = 0.4;
    HIN = 0.2;
    Omega_3 = 0.5;   // time constant
    rho = 0.05;
    sigma_A = 6;
    sigma_N = 6;
    sigma_se = 6;
    sigma_T = 0.2;
    UBR = 0.14251;
    psi_U = 0.75;     
    psi_N = 0.04;            
    alpha_2 = 0.1;
    lambda_20 = 0.1;
    lambda_22 = 0.2;
    lambda_24 = 0.2;
    lambda_25 = 0.2; 
    lambda_42 = 0.4;
    lambda_44 = 0.4;
    lambda_45 = 0.2;     
    Theta_f = 0.05;        
    lambda_50 = 0.4;    

    //--------------------------------------------
    // initial values of state variables
    //--------------------------------------------
    initial equation     
    _B =     3.30735e+12;
    _LD =    1.14025488e+8;
    _L_f =   1.29836e+12;
    _L_hh =  6.65301e+11; 
    _L_hl =  9.97951e+11; 
    _N =     2.36e+08;
    _OF =    2.96162e+11;
    _V_FS =  2.95484e+12;  
    _V_Mh =  2.94351e+12;  
    _V_Ml =  7.44108e+10;  
    _W =     27303.23475;
    _e =     1e+09;
    _g =     1.84895139e+12;
    _in =    1.52435540e+12;
    _k =     9.10574893e+12;
    _phi =   0.265515;
    _pr =    66770.47013;  
    _s_e =   7.67541476e+12;
    _v_RES = 7.70241426e+12;
    _v_he =  1.46102931e+13;
 end BaseEconomy;

   
  //--------------------------------------------
  // The baseline foreign deficit scenario
  //--------------------------------------------
  class simulatedReferenceScenario
    extends BaseEconomy;    
    //-----------------------------------------
    // Normalised initial values of state variables harvested at the end of simulation
    // If parameters are changed, harvest these and use as initial values for a steady growth
    //-----------------------------------------      
    // Find long-term trend values and normalise them for population N and GDP Y 
    // population 1984 = 2.36e+8
    //        GDP 1984 = 4e+12
    // then normalise productivity to get the correct y (78000 in 1984) and the quantity of shares _e
    Real aux_N_ratio;
    Real aux_pr_ratio;
    Real aux_Y_ratio;
    
    Real init_B;
    Real init_LD;
    Real init_L_f;
    Real init_L_hh;
    Real init_L_hl;
    Real init_N;
    Real init_OF;
    Real init_V_Mh;
    Real init_V_Ml;
    Real init_V_FS;
    Real init_W;
    Real init_e;
    Real init_g;
    Real init_in;
    Real init_k;
    Real init_phi;
    Real init_pr;
    Real init_s_e;
    Real init_v_he;
    Real init_v_RES;
      
    equation  
    aux_N_ratio = 2.36e+8 / _N;
    aux_pr_ratio = 78000 / _pr;    
    aux_Y_ratio = 4e+12 / Y;
    
    init_B = _B * aux_Y_ratio;
    init_LD = _LD * aux_N_ratio;
    init_L_f = _L_f * aux_Y_ratio;
    init_L_hh = _L_hh * aux_Y_ratio;
    init_L_hl = _L_hl * aux_Y_ratio;
    init_N = _N * aux_N_ratio;
    init_OF = _OF * aux_Y_ratio;
    init_V_Mh = _V_Mh * aux_Y_ratio;
    init_V_Ml = _V_Ml * aux_Y_ratio;
    init_V_FS = _V_FS * aux_Y_ratio;
    init_W = _W * aux_Y_ratio / aux_N_ratio;
    init_e = 1e+9;
    init_g = _g * aux_N_ratio * aux_pr_ratio;
    init_in = _in * aux_N_ratio * aux_pr_ratio;
    init_k = _k * aux_N_ratio * aux_pr_ratio;
    init_phi = _phi;
    init_pr = 78000;
    init_s_e = _s_e * aux_N_ratio * aux_pr_ratio;
    init_v_he = _v_he * aux_N_ratio * aux_pr_ratio;
    init_v_RES = _v_RES * aux_N_ratio * aux_pr_ratio;
     
    //-----------------------------------------
    // Model parameters
    //-----------------------------------------      
    lambda_40 = 0.5;
    r_m = 0.04;
    gr_g = 0.0302;   
    psi_D = 0.30; 
    eta = 0.14; 
    epsilon_GYR = 1;
    omega_0 = 0.88;
    HILD = 0.40;
    REMOR = 3.3;   
    GYR = 0.23889;
    mu = 0.0350; 
    u_0 = 0.85;
    LF_N = 0.50854;
    Theta_hh = 0.35;
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
   end simulatedReferenceScenario; 
  simulatedReferenceScenario simulatedReference;

  //--------------------------------------------
  // Scenario FiscalStimulus
  //--------------------------------------------
  class simulatedFiscalStimulusScenario
    extends BaseEconomy;
    FilteredRampEdges fre_gr_g(t = {2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015}, u = {0.0302, 0.0723, 0.0302, -0.0105, 0.0302}); 
    equation  
    lambda_40 = 0.5;
    r_m = 0.04;
    gr_g = fre_gr_g.y; 
    psi_D = 0.30; 
    eta = 0.14; 
    epsilon_GYR = 0;
    omega_0 = 0.88;
    HILD = 0.4; 
    REMOR = 3.3;   
    GYR = 0.23888;
    mu = 0.0350;     
    u_0 = 0.85;
    LF_N = 0.50854;
    Theta_hh = 0.35;      
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedFiscalStimulusScenario; 
  simulatedFiscalStimulusScenario simulatedFiscalStimulus;

  //--------------------------------------------
  // Scenario FiscalExperiment
  //--------------------------------------------
  class simulatedFiscalExperimentScenario
    extends BaseEconomy;
    FilteredRampEdges fre_gr_g(t = {1985, 1986, 1987, 1988}, u = {0.0302, 0.0085, 0.0302}); 
    equation  
    lambda_40 = 0.5;
    r_m = 0.04;
    gr_g = fre_gr_g.y; 
    psi_D = 0.30; 
    eta = 0.14; 
    epsilon_GYR = 0;
    omega_0 = 0.88;
    HILD = 0.4; 
    REMOR = 3.3;   
    GYR = 0.23888;
    mu = 0.0350;     
    u_0 = 0.85;
    LF_N = 0.50854;
    Theta_hh = 0.35;      
    Theta_hl = 0.1475; 
    ER_pr1 = 0.90;
    ER_pr0 = 0.85;    
  end simulatedFiscalExperimentScenario; 
  simulatedFiscalExperimentScenario simulatedFiscalExperiment; 
 
  //--------------------------------------------
  // Scenario ProductivityExperiment
  //--------------------------------------------
  class simulatedProductivityExperimentScenario
    extends BaseEconomy;
    FilteredRampEdges fre_ER_pr1(t = {1985, 1986}, u = {0.90, 1.00}); 
    equation  
    lambda_40 = 0.5;
    r_m = 0.04;
    gr_g = 0.0302; 
    psi_D = 0.30; 
    eta = 0.14; 
    epsilon_GYR = 1;
    omega_0 = 0.88;
    HILD = 0.4; 
    REMOR = 3.3;   
    GYR = 0.23888;
    mu = 0.0350;     
    u_0 = 0.85;
    LF_N = 0.50854;
    Theta_hh = 0.35;      
    Theta_hl = 0.1475; 
    ER_pr1 = fre_ER_pr1.y;
    ER_pr0 = 0.3;    
  end simulatedProductivityExperimentScenario; 
  simulatedProductivityExperimentScenario simulatedProductivityExperiment; 
   
  //--------------------------------------------
  // Scenario TradeBalanceChanges
  //--------------------------------------------
  class simulatedTradeBalanceChangesScenario
    extends BaseEconomy;
    FilteredRampEdges fre_mu(t = {2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015}, u = {0.0350, 0.07, 0.0350, 0, 0.0350});
    equation  
    lambda_40 = 0.5;
    r_m = 0.04;
    gr_g = 0.0302; 
    psi_D = 0.30; 
    eta = 0.14; 
    epsilon_GYR = 0;
    omega_0 = 0.88;
    HILD = 0.4; 
    REMOR = 3.3;   
    GYR = 0.23888;
    mu = fre_mu.y;
    u_0 = 0.85;
    LF_N = 0.50854;
    Theta_hh = 0.35;      
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedTradeBalanceChangesScenario; 
  simulatedTradeBalanceChangesScenario simulatedTradeBalanceChanges;
  
  //--------------------------------------------
  // Scenario MonetaryStimulus
  //--------------------------------------------
  class simulatedMonetaryStimulusScenario
    extends BaseEconomy;
    FilteredRampEdges fre_r_m(t = {1991, 1992}, u = {0.04, 0.03});  
    equation  
    lambda_40 = 0.5;
    r_m = fre_r_m.y; 
    gr_g = 0.0302; 
    psi_D = 0.30; 
    eta = 0.14; 
    epsilon_GYR = 0; // no adjustment of fiscal position
    omega_0 = 0.88;
    HILD = 0.4; 
    REMOR = 3.3;   
    GYR = 0.23888;
    mu = 0.0350;      
    u_0 = 0.85;
    LF_N = 0.50854;
    Theta_hh = 0.35;  
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedMonetaryStimulusScenario; 
  simulatedMonetaryStimulusScenario simulatedMonetaryStimulus; 

  //--------------------------------------------
  // Scenario DistributionalChanges
  //--------------------------------------------
  class simulatedDistributionalChangesScenario
    extends BaseEconomy;
    FilteredRampEdges fre_HILD(t = {1985, 2005}, u = {0.4, 0.41}); 
    equation  
    lambda_40 = 0.5;
    r_m = 0.04;
    gr_g = 0.0302; 
    psi_D = 0.30; 
    eta = 0.14; 
    epsilon_GYR = 0;
    omega_0 = 0.88;
    HILD = fre_HILD.y; 
    REMOR = 3.3;   
    GYR = 0.23888;
    mu = 0.0350;      
    u_0 = 0.85;
    LF_N = 0.50854;
    Theta_hh = 0.35;       
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedDistributionalChangesScenario; 
  simulatedDistributionalChangesScenario simulatedDistributionalChanges; 
  
  //--------------------------------------------
  // Scenario StockmarketBubble
  //--------------------------------------------
  class simulatedStockmarketBubbleScenario
    extends BaseEconomy;
    FilteredRampEdges fre_lambda_40(t = {1995, 1999, 2000, 2002}, u = {0.50, 0.55, 0.50});
    FilteredRampEdges fre_u_0(t = {1995, 1999, 2000, 2002}, u = {0.85, 0.80, 0.85}); 
    equation    
    lambda_40 = fre_lambda_40.y;
    r_m = 0.04;
    gr_g = 0.0302;   
    psi_D = 0.30; 
    eta = 0.14; 
    epsilon_GYR = 1;
    omega_0 = 0.88;
    HILD = 0.4; 
    REMOR = 3.3;   
    GYR = 0.23888;
    mu = 0.0350;     
    u_0 = fre_u_0.y;
    LF_N = 0.50854;
    Theta_hh = 0.35;    
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedStockmarketBubbleScenario; 
  simulatedStockmarketBubbleScenario simulatedStockmarketBubble;
  
  //--------------------------------------------
  // Scenario HousingBubble
  //--------------------------------------------
  class simulatedHousingBubbleScenario
    extends BaseEconomy;
    FilteredRampEdges fre_eta(t = {1990, 1995, 1996, 1999, 2001, 2006}, u = {0.14, 0.18, 0.13, 0.14});
    equation
    lambda_40 = 0.5;
    r_m = 0.04;
    gr_g = 0.0302;   
    psi_D = 0.30; 
    eta = fre_eta.y;
    epsilon_GYR = 1;
    omega_0 = 0.88;
    HILD = 0.4; 
    REMOR = 3.3;
    GYR = 0.23888;
    mu = 0.0350;     
    u_0 = 0.85;
    LF_N = 0.50854;
    Theta_hh = 0.35;      
    Theta_hl = 0.1475; 
    ER_pr1 = 0.54; // switch off
    ER_pr0 = 0.50;    
  end simulatedHousingBubbleScenario;
  simulatedHousingBubbleScenario simulatedHousingBubble;
  
  //--------------------------------------------
  // Scenario HousingBubblePriceCrash
  //--------------------------------------------
   class simulatedHousingBubblePriceCrashScenario
    extends BaseEconomy;
    FilteredRampEdges fre_eta(t = {1990, 1995, 1996, 1999, 2001, 2006}, u = {0.14, 0.18, 0.13, 0.14});
    FilteredRampEdges fre_REMOR(t = {1997.5, 1999, 2002, 2005}, u = {3.3, 3.0, 3.3});
    equation
    lambda_40 = 0.5;
    r_m = 0.04;
    gr_g = 0.0302;   
    psi_D = 0.30; 
    eta = fre_eta.y;
    epsilon_GYR = 1;
    omega_0 = 0.88;
    HILD = 0.4; 
    REMOR = fre_REMOR.y;
    GYR = 0.23888;
    mu = 0.0350;     
    u_0 = 0.85;
    LF_N = 0.50854;
    Theta_hh = 0.35;      
    Theta_hl = 0.1475; 
    ER_pr1 = 0.54;  // switch off
    ER_pr0 = 0.50;    
  end simulatedHousingBubblePriceCrashScenario;
  simulatedHousingBubblePriceCrashScenario simulatedHousingBubblePriceCrash; 
  
  //--------------------------------------------
  // Historical Scenarios
  //--------------------------------------------
  partial class baseSimulatedHistorical
    extends BaseEconomy;
    // Trend changes
    FilteredRampEdges fre_psi_D(t = {1990, 2005}, u = {0.30, 0.36});
    FilteredRampEdges fre_omega_0(t = {1985, 2005, 2009, 2012, 2016, 2017}, u = {0.88, 0.85, 0.83, 0.84}); 
    FilteredRampEdges fre_HILD(t = {1985, 2005}, u = {0.4, 0.43}); 
    FilteredRampEdges fre_GYR(t = {1991, 1998, 2000, 2002, 2015, 2017}, u = {0.23888, 0.227, 0.2365, 0.235});
    FilteredRampEdges fre_mu(t = {1988, 1990, 1992, 2005, 2008, 2009, 2013, 2014}, u = {0.0350, 0.0, 0.09, 0.05, 0.04});
    FilteredInterpolate fi_LF_N(t = {1984, 1988, 2000, 2007, 2009, 2012, 2016, 2019, 2020}, u = {0.50854, 0.50, 0.52, 0.508, 0.50, 0.48, 0.47, 0.465, 0.46});
    FilteredRampEdges fre_Theta_hh(t = {1985, 1986, 1999, 2000, 2008, 2009, 2017, 2018}, u = {0.35, 0.36, 0.35, 0.33, 0.32});      
    // May not be used in some scenarios    
    // The Sharemarket Bubble
    FilteredRampEdges fre_lambda_40(t = {1995, 1999, 2000, 2001, 2005, 2007, 2007.5, 2008, 2008.5, 2010}, u = {0.50, 0.60, 0.50, 0.52, 0.46, 0.50});
    FilteredRampEdges fre_u_0(t = {1995, 1999, 2000, 2001, 2005, 2007, 2007.5, 2008}, u = {0.85, 0.62, 0.85, 0.77, 0.85});    
    // The Housing Bubble
    FilteredRampEdges fre_eta(t = {2000, 2005, 2007, 2009, 2011, 2016}, u = {0.14, 0.24, 0.11, 0.125});  
    FilteredRampEdges fre_REMOR(t = {2007, 2009.5, 2012, 2015}, u = {3.3, 2.25, 3.3});         
    // The Stimulus
    FilteredRampEdges fre_r_m(t = {1985, 1986, 2000, 2002, 2004, 2006, 2007, 2008.5, 2015, 2018}, u = {0.04, 0.05, 0.01, 0.05, 0.001, 0.02});    
    FilteredRampEdges fre_gr_g(t = {2001, 2001.5, 2002, 2002.5, 2003.5, 2004, 2004.5, 2005,  2007.5, 2008.5, 2009.5, 2010.5, 2013, 2014, 2015, 2016}, u = {0.0302, 0.06, 0.0302, 0.0, 0.0302, 0.09, 0.0302, -0.03, 0.0302}); 
       
    equation
    psi_D = fre_psi_D.y;
    omega_0 = fre_omega_0.y;
    HILD = fre_HILD.y;
    GYR = fre_GYR.y;
    mu = fre_mu.y;  
    LF_N = fi_LF_N.y;
    Theta_hh = fre_Theta_hh.y;  
   
    epsilon_GYR = 1;
    Theta_hl = 0.1475; 
    ER_pr1 = 0.935;
    ER_pr0 = 0.90;    
end baseSimulatedHistorical;
 
  //--------------------------------------------
  // Scenario HistoricalNoBubblesNoStimuli
  //--------------------------------------------
   class simulatedHistoricalNoBubblesNoStimuliScenario
    extends baseSimulatedHistorical;   
    equation
    lambda_40 = 0.5;
    eta = 0.14; 
    REMOR = 3.3;   
    u_0 = 0.85;
    r_m = 0.04;
    gr_g = 0.0302;
  end simulatedHistoricalNoBubblesNoStimuliScenario;
  simulatedHistoricalNoBubblesNoStimuliScenario simulatedHistoricalNoBubblesNoStimuli;
  
  //--------------------------------------------
  // Scenario HistoricalNoStimuli
  //--------------------------------------------
   class simulatedHistoricalNoStimuliScenario
    extends baseSimulatedHistorical;
   equation
    lambda_40 = fre_lambda_40.y;
    eta = fre_eta.y;
    REMOR = fre_REMOR.y;
    u_0 = fre_u_0.y;
    r_m = 0.04;
    gr_g = 0.0302;
  end simulatedHistoricalNoStimuliScenario;
  simulatedHistoricalNoStimuliScenario simulatedHistoricalNoStimuli;


  //--------------------------------------------
  // Scenario HistoricalNoFiscalStimulus
  //--------------------------------------------
   class simulatedHistoricalNoFiscalStimulusScenario
    extends baseSimulatedHistorical;
   equation
    lambda_40 = fre_lambda_40.y;
    eta = fre_eta.y;
    REMOR = fre_REMOR.y;
    u_0 = fre_u_0.y;
    r_m = fre_r_m.y;
    gr_g = 0.0302;
  end simulatedHistoricalNoFiscalStimulusScenario;
  simulatedHistoricalNoFiscalStimulusScenario simulatedHistoricalNoFiscalStimulus;

  //--------------------------------------------
  // Scenario HistoricalGFC
  //--------------------------------------------  
  class simulatedHistoricalGfcScenario
    extends baseSimulatedHistorical;         
    equation
    lambda_40 = fre_lambda_40.y;
    eta = fre_eta.y;
    REMOR = fre_REMOR.y;
    u_0 = fre_u_0.y;
    r_m = fre_r_m.y;
    gr_g = fre_gr_g.y;
  end simulatedHistoricalGfcScenario;
  simulatedHistoricalGfcScenario simulatedHistoricalGFC;
  
  
  //--------------------------------------------
  // probes
  //--------------------------------------------
  
  Real x_y_actualHistorical;  
  Real x_YD_hh__YD_actualRatio;   
  Real x_G__Y_actualHistorical;
  Real x_NETIM__Y_actualHistorical;
  Real x_LS_actualHistorical;
  Real x_LD_actualHistorical;
  Real x_D_Lh_actualHistorical;
  Real x_r_m_actualHistorical;
  Real x_UR_actualHistorical;
  Real x_PSAVERT_actualHistorical;
  
  Real x_Dy_simulatedFiscalStimulus_to_y_Reference; 
  Real x_Dg_simulatedFiscalStimulus_to_y_Reference; 
  Real x_Dy_simulatedFiscalExperiment_to_y_Reference; 
  Real x_Dg_simulatedFiscalExperiment_to_y_Reference; 
  Real x_Dy_simulatedTradeBalanceChanges_to_y_Reference;  
  Real x_y_simulatedFiscalStimulus_to_y_Reference;  
  
  Real x_Dyd_r_simulatedFiscalStimulus_to_y_Reference;  
  Real x_Dc_h_simulatedFiscalStimulus_to_y_Reference;  
  Real x_Dc_l_simulatedFiscalStimulus_to_y_Reference;  
  Real x_Dyd_r_simulatedFiscalExperiment_to_y_Reference;  
  Real x_Dc_h_simulatedFiscalExperiment_to_y_Reference;  
  Real x_Dc_l_simulatedFiscalExperiment_to_y_Reference; 
  
  Real x_Dy_simulatedMonetaryStimulus_to_y_Reference; 
  Real x_Dyd_r_simulatedMonetaryStimulus_to_y_Reference;  
  Real x_Dc_h_simulatedMonetaryStimulus_to_y_Reference;  
  Real x_Dc_l_simulatedMonetaryStimulus_to_y_Reference;    
  
  Real x_Dv_simulatedHousingBubble_to_v_Reference;
  Real x_Dv_he_simulatedHousingBubble_to_v_Reference;
  Real x_Dv_simulatedHousingBubblePriceCrash_to_v_Reference;
  Real x_Dv_he_simulatedHousingBubblePriceCrash_to_v_Reference;
  Real x_Dyd_r_simulatedHousingBubble_to_y_Reference;  
  Real x_Dc_h_simulatedHousingBubble_to_y_Reference;  
  Real x_Dc_l_simulatedHousingBubble_to_y_Reference;    
  Real x_Dyd_r_simulatedHousingBubblePriceCrash_to_y_Reference;  
  Real x_Dc_h_simulatedHousingBubblePriceCrash_to_y_Reference;  
  Real x_Dc_l_simulatedHousingBubblePriceCrash_to_y_Reference;    
  Real x_Di_f_simulatedHousingBubble_to_y_Reference;    
  Real x_Di_f_simulatedHousingBubblePriceCrash_to_y_Reference;    
  
  Real x_y_simulatedTradeBalanceChanges_to_y_Reference;
  Real x_y_simulatedMonetaryStimulus_to_y_Reference;
  Real x_y_simulatedDistributionalChanges_to_y_Reference;
  Real x_y_simulatedStockmarketBubble_to_y_Reference;
  Real x_y_simulatedHousingBubble_to_y_Reference;
  Real x_y_simulatedHousingBubblePriceCrash_to_y_Reference;
  Real x_y_simulatedHistoricalGFC_to_y_Reference;    
  Real x_yd_rh_simulatedDistributionalChanges_to_yd_rh_Reference;
  Real x_yd_rl_simulatedDistributionalChanges_to_yd_rl_Reference;
    
  Real x_Dr_l_simulatedMonetaryStimulus;
  Real x_Dphi_T_simulatedMonetaryStimulus_to_phi_T_Reference;
  Real x_Dphi_simulatedMonetaryStimulus_to_phi_Reference;
  Real x_Dp_simulatedMonetaryStimulus_to_p_Reference;
    
    
  // aliases for phase space graphs
  Real FiscalStimulus_ProfitShareOfGDP;
  Real FiscalStimulus_EmploymentRate;
  Real FiscalStimulus_LabourShareOfGDP;
  Real FiscalStimulus_RelativeGDP;    
  Real HousingBubble_ProfitShareOfGDP;
  Real HousingBubble_EmploymentRate;
  Real HousingBubble_LabourShareOfGDP;
  Real HousingBubble_RelativeGDP; 
  Real EmploymentRate;
  Real omega_r;
  
  equation
    x_YD_hh__YD_actualRatio = Modelica.Math.Vectors.interpolate(years, high_income_ratios, time); 
    x_y_actualHistorical = Modelica.Math.Vectors.interpolate(quarters, y_values*1000000000, time); 
    x_G__Y_actualHistorical = Modelica.Math.Vectors.interpolate(years, GCEA_GDPA, time);  
    x_NETIM__Y_actualHistorical =  Modelica.Math.Vectors.interpolate(years, NETFI_GDP, time); 
    x_LS_actualHistorical = Modelica.Math.Vectors.interpolate(years, CLF16OV, time);
    x_LD_actualHistorical = Modelica.Math.Vectors.interpolate(years, CE16OV, time);
    x_D_Lh_actualHistorical = Modelica.Math.Vectors.interpolate(years, D_HH_DEBT, time);
    x_r_m_actualHistorical = Modelica.Math.Vectors.interpolate(years,FUNDRATE, time);
    x_UR_actualHistorical = Modelica.Math.Vectors.interpolate(years,UNRATE, time);
    x_PSAVERT_actualHistorical = Modelica.Math.Vectors.interpolate(years,PSAVERT/100.0, time);

    x_Dy_simulatedFiscalStimulus_to_y_Reference = (simulatedFiscalStimulus.y - simulatedReference.y) / simulatedReference.y; 
    x_Dg_simulatedFiscalStimulus_to_y_Reference = (simulatedFiscalStimulus._g - simulatedReference._g) / simulatedReference.y;  
    x_Dy_simulatedFiscalExperiment_to_y_Reference = (simulatedFiscalExperiment.y - simulatedReference.y) / simulatedReference.y; 
    x_Dg_simulatedFiscalExperiment_to_y_Reference = (simulatedFiscalExperiment._g - simulatedReference._g) / simulatedReference.y;  
    x_Dy_simulatedTradeBalanceChanges_to_y_Reference = (simulatedTradeBalanceChanges.y - simulatedReference.y) / simulatedReference.y;       
    x_y_simulatedFiscalStimulus_to_y_Reference = simulatedFiscalStimulus.y / simulatedReference.y;
    
    x_Dyd_r_simulatedFiscalStimulus_to_y_Reference = (simulatedFiscalStimulus.yd_r - simulatedReference.yd_r) / simulatedReference.y;
    x_Dc_h_simulatedFiscalStimulus_to_y_Reference = (simulatedFiscalStimulus.c_h - simulatedReference.c_h) / simulatedReference.y;
    x_Dc_l_simulatedFiscalStimulus_to_y_Reference = (simulatedFiscalStimulus.c_l - simulatedReference.c_l) / simulatedReference.y;
    x_Dyd_r_simulatedFiscalExperiment_to_y_Reference = (simulatedFiscalExperiment.yd_r - simulatedReference.yd_r) / simulatedReference.y;
    x_Dc_h_simulatedFiscalExperiment_to_y_Reference = (simulatedFiscalExperiment.c_h - simulatedReference.c_h) / simulatedReference.y;
    x_Dc_l_simulatedFiscalExperiment_to_y_Reference = (simulatedFiscalExperiment.c_l - simulatedReference.c_l) / simulatedReference.y;
    
    x_Dy_simulatedMonetaryStimulus_to_y_Reference = (simulatedMonetaryStimulus.y - simulatedReference.y) / simulatedReference.y; 
    x_Dyd_r_simulatedMonetaryStimulus_to_y_Reference = (simulatedMonetaryStimulus.yd_r - simulatedReference.yd_r) / simulatedReference.y;
    x_Dc_h_simulatedMonetaryStimulus_to_y_Reference = (simulatedMonetaryStimulus.c_h - simulatedReference.c_h) / simulatedReference.y;  
    x_Dc_l_simulatedMonetaryStimulus_to_y_Reference = (simulatedMonetaryStimulus.c_l - simulatedReference.c_l) / simulatedReference.y;

    x_Dv_simulatedHousingBubble_to_v_Reference = (simulatedHousingBubble.v - simulatedReference.v) / simulatedReference.v;
    x_Dv_he_simulatedHousingBubble_to_v_Reference = (simulatedHousingBubble._v_he - simulatedReference._v_he) / simulatedReference.v;
    x_Dv_simulatedHousingBubblePriceCrash_to_v_Reference = (simulatedHousingBubblePriceCrash.v - simulatedReference.v) / simulatedReference.v;
    x_Dv_he_simulatedHousingBubblePriceCrash_to_v_Reference = (simulatedHousingBubblePriceCrash._v_he - simulatedReference._v_he) / simulatedReference.v;
    x_Dyd_r_simulatedHousingBubble_to_y_Reference = (simulatedHousingBubble.yd_r - simulatedReference.yd_r) / simulatedReference.y;  
    x_Dc_h_simulatedHousingBubble_to_y_Reference = (simulatedHousingBubble.c_h - simulatedReference.c_h) / simulatedReference.y;  
    x_Dc_l_simulatedHousingBubble_to_y_Reference = (simulatedHousingBubble.c_l - simulatedReference.c_l) / simulatedReference.y;    
    x_Dyd_r_simulatedHousingBubblePriceCrash_to_y_Reference = (simulatedHousingBubblePriceCrash.yd_r - simulatedReference.yd_r) / simulatedReference.y;  
    x_Dc_h_simulatedHousingBubblePriceCrash_to_y_Reference = (simulatedHousingBubblePriceCrash.c_h - simulatedReference.c_h) / simulatedReference.y;  
    x_Dc_l_simulatedHousingBubblePriceCrash_to_y_Reference = (simulatedHousingBubblePriceCrash.c_l - simulatedReference.c_l) / simulatedReference.y;        
    x_Di_f_simulatedHousingBubble_to_y_Reference = (simulatedHousingBubble.i_f - simulatedReference.i_f) / simulatedReference.y;
    x_Di_f_simulatedHousingBubblePriceCrash_to_y_Reference = (simulatedHousingBubblePriceCrash.i_f - simulatedReference.i_f) / simulatedReference.y;    
       
    x_y_simulatedTradeBalanceChanges_to_y_Reference = simulatedTradeBalanceChanges.y / simulatedReference.y;
    x_y_simulatedMonetaryStimulus_to_y_Reference = simulatedMonetaryStimulus.y / simulatedReference.y;   
    x_y_simulatedDistributionalChanges_to_y_Reference = simulatedDistributionalChanges.y / simulatedReference.y;    
    x_y_simulatedStockmarketBubble_to_y_Reference = simulatedStockmarketBubble.y / simulatedReference.y; 
    x_y_simulatedHousingBubble_to_y_Reference = simulatedHousingBubble.y / simulatedReference.y; 
    x_y_simulatedHousingBubblePriceCrash_to_y_Reference = simulatedHousingBubblePriceCrash.y / simulatedReference.y; 
    x_y_simulatedHistoricalGFC_to_y_Reference = simulatedHistoricalGFC.y / simulatedReference.y;    
    x_yd_rh_simulatedDistributionalChanges_to_yd_rh_Reference = simulatedDistributionalChanges.yd_rh/simulatedReference.yd_rh;        
    x_yd_rl_simulatedDistributionalChanges_to_yd_rl_Reference = simulatedDistributionalChanges.yd_rl/simulatedReference.yd_rl;     

    x_Dr_l_simulatedMonetaryStimulus = simulatedMonetaryStimulus.r_l - simulatedReference.r_l;  
    x_Dphi_T_simulatedMonetaryStimulus_to_phi_T_Reference = (simulatedMonetaryStimulus.phi_T - simulatedReference.phi_T) / simulatedReference.phi_T;  
    x_Dphi_simulatedMonetaryStimulus_to_phi_Reference = (simulatedMonetaryStimulus._phi - simulatedReference._phi) / simulatedReference._phi;  
    x_Dp_simulatedMonetaryStimulus_to_p_Reference = (simulatedMonetaryStimulus.p - simulatedReference.p)  / simulatedReference.p;  
          
    FiscalStimulus_ProfitShareOfGDP = simulatedFiscalStimulus.x_F__Y;
    FiscalStimulus_EmploymentRate = simulatedFiscalStimulus.ER;
    FiscalStimulus_LabourShareOfGDP = simulatedFiscalStimulus.x_WB__Y;
    FiscalStimulus_RelativeGDP = x_y_simulatedFiscalStimulus_to_y_Reference;    
    HousingBubble_ProfitShareOfGDP = simulatedHousingBubble.x_F__Y;
    HousingBubble_EmploymentRate = simulatedHousingBubble.ER;
    HousingBubble_LabourShareOfGDP = simulatedHousingBubble.x_WB__Y;
    HousingBubble_RelativeGDP = x_y_simulatedHousingBubble_to_y_Reference;    
    EmploymentRate = simulatedTradeBalanceChanges.ER;
    omega_r = simulatedTradeBalanceChanges.omega_r;
  annotation(
      experiment(StartTime = 1984, StopTime = 2019, Tolerance = 1e-6, Interval = 0.01),
    __OpenModelica_simulationFlags( lv = "LOG_STATS", s = "dassl", nls = "homotopy", ls = "totalpivot"));
end EconomicModels;
