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
  // Actual historical data
  // U.S. Bureau of Economic Analysis, Real Gross Domestic Product [GDPC1],
  // retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/GDPC1, May 22, 2019.		   
  Real y_values[:] = {6947.042e+9, 6794.878e+9, 6892.144e+9, 7483.371e+9,
                      7824.247e+9, 8148.603e+9, 8369.93e+9, 8725.006e+9,
                      9101.508e+9, 9358.289e+9, 9269.367e+9, 9534.346e+9,
                      9850.973e+9, 10188.954e+9, 10543.644e+9, 10817.896e+9,
                      11284.587e+9, 11832.486e+9, 12403.293e+9, 12924.179e+9,
                      13222.69e+9, 13397.002e+9, 13634.253e+9, 14221.147e+9,
                      14771.602e+9, 15267.026e+9, 15493.328e+9, 15671.383e+9,
                      15155.94e+9, 15415.145e+9, 15712.754e+9, 16129.418e+9,
                      16382.964e+9, 16621.696e+9, 17254.744e+9, 17523.374e+9,
                      17863.023e+9, 18323.963e+9, 18912.326e+9};

  // Semega, J. L., Fontenot, K. R., & Kollar, M. A. (2017). Income and poverty in the United States: 2016. U.S. Census Bureau, Current Population Reports, (P60-259). Table 2 A
  // retrieved from https://www2.census.gov/programs-surveys/demo/tables/p60/263/tableA2.xls
  // data extended to cover 2018 and 2019 by repeating the sample from 2017
  Real high_income_ratios[:] = {0.450, 0.451,	0.452, 0.456, 0.461,	0.462, 0.463, 0.468,	
                                0.466, 0.465,	0.469, 0.489, 0.491,	0.487, 0.490, 0.494,	
                                0.492, 0.494,	0.498, 0.501, 0.497,	0.498, 0.501, 0.504,	
                                0.505, 0.497,	0.500, 0.503, 0.503,	0.511, 0.510, 0.510,	
                                0.514, 0.512, 0.511, 0.515, 0.515, 0.515, 0.515};
  
  
  partial class BaseEconomy
    //--------------------------------------------
    // Auxiliary
    //--------------------------------------------
    function Ramp
      input Real u;
      output Real y;
    algorithm
      y := if u > 0 then u else 0; //[1]
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
    Real beta_b;         // Expected bank own funds adjustment coefficient
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
    Real YP_h (start = 5e+12, fixed = false);                                            // Nominal household income, high income households
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
 
    //--------------------------------------------
    // Short-term equilibrium
    //--------------------------------------------
    equation
    //--------------------
    // Firms - aggregate demand, production and investment decisions
    //--------------------
    y = _s_e + gamma * (in_T - _in); // [2]  
    der(_s_e) = beta * (s - _s_e); // [3] 
    in_T = sigma_T * _s_e; // [4]
    der(_in) = y - s; // [5]
    der(_k) = _k * log(1 + gr_k); // [6]
    gr_k = ((1 + gr_pr) * ( 1 + gr_N) - 1) + gamma_u * (u - u_0); // [7]
    u = y / _k; // [8]
    rr_l = (1 + r_l) / (1 + pi) - 1; // [9]
    pi = der(p) / p; // [10]   
    i_f = (gr_k + delta) * _k; // [11]
    i = i_f + i_h; // [12]
    s = cd + _g + i; // [13]
    S = s * p; // [14]
    IN = _in * UC; // [15]
    I_f = i_f * p; // [16]
    I = I_f + I_h; // [17]
    K = _k * p;  // [18]
    Y = S + der(_in) * UC;  // [19]
    
    //--------------------
    // The labour market
    //--------------------   
    omega_r = omega_0 * (1 - omega_1 * Ramp(ER_min - ER) + omega_2 * Ramp(ER - ER_max)); // [20]
    omega_t = omega_r * _pr; // [21]
    ER = 1 - (1 - _LD / LS); // [22]
    UR = Ramp(1 - ER); //[23]
    der(_N) = _N * log(1 + gr_N); // [24]
    LS = _N * LF_N; // [25]
    der(_W) = Omega_3 * (omega_t * p - _W); // [26]
    gr_pr =   if ER > ER_pr1 then gr_pr0 elseif ER > ER_pr0 then  gr_pr0 * (ER - ER_pr0) / (ER_pr1 - ER_pr0) else 0; // [27] 
    der(_pr) = _pr * log(1 + gr_pr); // [28]
    LD_T = y / _pr; // [29]
    der(_LD) = eta_LD * Ramp(LD_T - _LD) - eta_LDr * Ramp(_LD - LD_T); // [30]
    WB = _LD * _W; // [31]
    WB_h = WB * HILD; // [32]
    WB_l = WB * (1 - HILD); // [33]
    UC = WB / y; // [34]
    NUC = _W / _pr; // [35]

    //--------------------
    // Prices, markups and profits
    //--------------------       
    p = (1 + _phi) * NUC; // [36]
    der(_phi) = epsilon_M * (phi_T - _phi); // [37]  
    phi_T = (F_fT +  r_l * _L_f + T_f)/ (_s_e * UC); // [38]
    T_f = F_f * Theta_f; // [39]
    F_f = S - WB - r_l * _L_f - T_f; // [40]
    F_fT = FU_fT + FD_f; // [41]
    FU_fT = psi_U * I_f; // [42]
    FD_f = psi_D * F_f; // [43]
    FU_f = F_f - FD_f; // [44]
    der(_L_f) = I_f - FU_f - NES; // [45]
    der(_e) = NES / p_e; // [46]
    NES = psi_N * I_f; // [47]
    r_K = FD_f / (_e * p_e); // [48]
    PE = _e * p_e / F_f; // [49]
    q = (_e * p_e + _L_f) / (K + IN); // [50]
    
    //--------------------
    // Households - income, consumption and financial wealth
    //--------------------
    YP_h = WB_h + FD_f + FD_b + r_m * (M - M_FS) + r_m * B_h; // [51]
    YP_l = WB_l; // [52]
    YP = YP_l + YP_h; // [53]
    T_hl = Theta_hl * YP_l; // [54]
    T_hh = Theta_hh * YP_h; // [55]
    T_h = T_hl + T_hh; // [56]
    YD_rh = YP_h - T_hh - r_l * _L_hh; // [57]
    YD_rl = YP_l - T_hl - r_l * _L_hl + UB; // [58]
    UB = UR * UBR * WB_l; // [59]    
    YD_r = YD_rl + YD_rh; // [60] 
    yd_rh = YD_rh / p; // [61]
    yd_rl = YD_rl / p; // [62]
    yd_r = yd_rl + yd_rh; // [63]
    der(_V_Mh) = YD_rh - C_h - I_hh + NL_h - NES; // [64]
    der(_V_Ml) = YD_rl - C_l - I_hl + NL_l; // [65]
    V_M = _V_Mh + _V_Ml; // [66]
    V_fmah = _V_Mh - H_hh + _e * p_e; // [67]
    V_MlT = lambda_c * C_l; // [68]
    V_h = _V_Mh + _e * p_e + _OF - _L_hh + V_REh; // [69]
    V_l = _V_Ml + V_REl - _L_hl; // [70]
    V = V_h + V_l; // [71] 
    v_h = V_h / p; // [72]
    v_l = V_l / p; // [73]
    v = v_h + v_l; // [74]
    der(_v_he) = _v_he * log((1 + gr_N) * (1 + gr_pr)) + epsilon_vh * Ramp(v_h - _v_he) - epsilon_vhr * Ramp(_v_he - v_h); // [75]
    c_h = alpha_2 * _v_he; // [76]
    c_l = C_l / p; // [77]
    c = c_l + c_h; // [78]
    cd = (1 - mu) * c; // [79]
    C_h = c_h * p;  // [80]
    C_l = YD_rl + NL_l - I_hl - epsilon * (V_MlT - _V_Ml);  // [81]
    C = C_l + C_h; // [82]
    CD = (1 - mu) * C; // [83]
    H_hh = lambda_c * C_h; // [84]
    H_hl = _V_Ml; // [85]
    H_h = H_hh + H_hl; // [86]
    B_h = V_fmah * (lambda_20 + lambda_22 * r_m - lambda_24 * r_K - lambda_25 * YD_rh / V_h); // [87]
    p_e = V_fmah / _e * (lambda_40 - lambda_42 * r_m + lambda_44 * r_K - lambda_45 * YD_rh / V_h); // [88] 
    M = _V_Mh - B_h - H_hh + M_FS; // [89]
    
    //--------------------
    // Households - mortgage lending and real estate assets
    //--------------------   
    GL = eta * YD_r; // [90]
    GL_h = HILE * GL; // [91]
    GL_l = GL - GL_h; // [92]
    REP_h = delta_rep * _L_hh; // [93]
    REP_l = delta_rep * _L_hl; // [94]
    REP = REP_h + REP_l; // [95]
    NL_h = GL_h - REP_h; // [96]
    NL_l = GL_l - REP_l; // [97]
    NL = NL_h + NL_l; // [98]
    der(_L_hh) = NL_h; // [99] 
    der(_L_hl) = NL_l; // [100]
    L_h = _L_hh + _L_hl; // [101]
    nl_h = NL_h / p; // [102]
    nl_l = NL_l / p; // [103]
    nl = nl_h + nl_l; // [104]
    I_hh = GL_h * IHMOV; // [105]
    I_hl = GL_l * IHMOV; // [106]
    I_h = I_hh + I_hl; // [107]                               
    i_hh = I_hh / p; // [108]              
    i_hl = I_hl / p; // [109]  
    i_h = i_hh + i_hl; // [110]
    V_REh = _L_hh * REMOR; // [111]
    V_REl = _L_hl * REMOR; // [112]
    V_RE = V_REh + V_REl; // [113]
    v_REh = V_REh / p; // [114]
    v_REl = V_REl / p; // [115]
    v_RE = V_RE / p; // [116]
    der(_v_RES) = i_h - _v_RES * delta_RES; // [117]
    V_RES = p * _v_RES; // [118]

    //-----------------------------------------
    // The public sector
    //-----------------------------------------
    T = T_hl + T_hh + T_f; // [119]
    G = p * _g; // [120]
    der(_g) = _g * log(1 + gr_g - epsilon_GYR * (_g/y - GYR)); // [121]
    PSBR = G + r_m * (B_h + B_b + B_FS) - T + UB; // [122]
    der(_B) = PSBR; // [123]
    GD = B_b + B_h + H + B_FS; // [124]
    H = H_b + H_h; // [125]
    B_cb = H; // [126]

    //-----------------------------------------
    // The foreign sector
    //-----------------------------------------
    im = c * mu; // [127]
    IM = C * mu; // [128]
    der(_V_FS) = IM + r_m * B_FS + r_m * M_FS; // [129]
    B_FS = lambda_50 * _V_FS; // [130]
    M_FS = (1 - lambda_50) * _V_FS; // [131]
        
    //-----------------------------------------
    // The banking sector
    //-----------------------------------------
    FU_b = F_b - FD_b; // [132]
    der(_OF) = FU_b; // [131]
    B_b = _B - B_h - B_cb - B_FS; // [133]
    F_b = r_l * (_L_f + L_h) + r_m * B_b - r_m * M; // [135]
    H_b = rho * M; // [136]
    r_l = r_m + add_l; // [137]
    OF_T = NCAR * (_L_f + L_h); // [138]
    FU_bT = Ramp(der(OF_T)); // [139]
    FD_b = r_K *_OF; // [140]
    F_bT = FD_b + FU_bT; // [141]
    add_l = (F_bT - r_m * B_b + r_m * (M - _L_f - L_h)) / (_L_f + L_h); // [142]
    CAR = _OF / (_L_f + L_h); // [143]
    
    //--------------------------------------------
    // Sanity checks 
    //--------------------------------------------
    x_Y_exp = CD + I + G; // [146]
    x_Y_inc = WB + F_b + F_f + _L_f * r_l; // [147]      
    x_A_B = _L_f + L_h + B_b + H_b; // [149] 
    x_LE_B = _OF + M; // [150] 
    x_M_d = V_M  + M_FS - B_h - H_h; // [152]
    x_M_s = _L_f + L_h + B_b + H_b - _OF; // [153] 
    x_LE_GB = _B + _L_f + L_h - _OF; // [156] 
    
    assert(AlmostEqual(Y,x_Y_exp),
      "GDP calculated using the production (value added) and expenditure approach must be almost the same"); // [144]
    assert(AlmostEqual(Y,x_Y_inc),
      "GDP calculated using the production (value added) and income approach must be almost the same"); // [145]
    assert(AlmostEqual(x_A_B,x_LE_B),
      "Banks assets and liabilities + equity must be equal"); // [148]
    assert(AlmostEqual(x_M_d,x_M_s),
      "Money demand calculated from all households broad money stock must be almost the same as the money supply calculated from banks asset sheet"); // [151]
    assert(AlmostEqual(M,x_M_d),
      "Money demand calculated from high-income households broad money stock must be almost the same as the money demad calculated for all households"); // [154]
    assert(AlmostEqual(V_M + _V_FS,x_LE_GB),
      "Stock of broad money must be equal to the stock of government securities held by the private and foreign sectors + bank assets - bank capital"); // [155]
       
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
    assert(gr_k > 0, "Real Capital Stock Growth Rate must be > 0");
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
    assert(pi > -0.02, "Price Inflation Rate must be > -0.02");
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
    beta_b = 12;
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
    omega_1 = 1.0;   // deflation
    omega_2 = 2.0;   // inflation
    HILE = 0.4;
    HIN = 0.2;
    Omega_3 = 0.5;   // time constant
    rho = 0.05;
    sigma_A = 6;
    sigma_N = 6;
    sigma_se = 6;
    sigma_T = 0.2;
    UBR = 0.25;
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
    _LD =    1.05384e+08;
    _L_f =   1.29836e+12;
    _L_hh =  6.65301e+11; 
    _L_hl =  9.97951e+11; 
    _N =     2.36e+08;
    _OF =    2.96162e+11;
    _V_FS =  2.95484e+12;  
    _V_Mh =  2.94351e+12;  
    _V_Ml =  7.44108e+10;  
    _W =     29542.1;	    
    _e =     1e+09;	    
    _g =     1.99622e+12/1.079649798;
    _in =    1.64577e+12/1.079649798;
    _k =     9.83102e+12/1.079649798;
    _phi =   0.265515;
    _pr =    78000/1.079649798;  
    _s_e =   8.28676e+12/1.079649798;
    _v_RES = 8.31591e+12/1.079649798;  
    _v_he =  1.5774e+13/1.079649798;       
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
    LF_N = 0.47;
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
    LF_N = 0.47;
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
    FilteredRampEdges fre_gr_g(t = {1985, 1986, 1987, 1988}, u = {0.0302, 0.01, 0.0302}); 
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
    LF_N = 0.47;
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
    LF_N = 0.47;
    Theta_hh = 0.35;      
    Theta_hl = 0.1475; 
    ER_pr1 = fre_ER_pr1.y;
    ER_pr0 = 0.2;    
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
    LF_N = 0.47;
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
    FilteredRampEdges fre_r_m(t = {2001, 2002}, u = {0.04, 0.03});  
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
    LF_N = 0.47;
    Theta_hh = 0.35;  
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedMonetaryStimulusScenario; 
  simulatedMonetaryStimulusScenario simulatedMonetaryStimulus; 

  //--------------------------------------------
  // Scenario FiscalWithdrawal
  //--------------------------------------------
  class simulatedFiscalWithdrawalScenario
    extends BaseEconomy;
    FilteredRampEdges fre_gr_g(t = {1985, 1986, 1987, 1988}, u = {0.0302, 0.02587, 0.0302}); 
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
    LF_N = 0.47;
    Theta_hh = 0.35;      
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedFiscalWithdrawalScenario; 
  simulatedFiscalWithdrawalScenario simulatedFiscalWithdrawal; 

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
    LF_N = 0.47;
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
    LF_N = 0.47;
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
    FilteredRampEdges fre_eta(t = {2000, 2005, 2006, 2009, 2011, 2016}, u = {0.14, 0.18, 0.13, 0.14});
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
    LF_N = 0.47;
    Theta_hh = 0.35;      
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedHousingBubbleScenario;
  simulatedHousingBubbleScenario simulatedHousingBubble;
  
  //--------------------------------------------
  // Scenario HousingBubblePriceCrash
  //--------------------------------------------
   class simulatedHousingBubblePriceCrashScenario
    extends BaseEconomy;
    FilteredRampEdges fre_eta(t = {2000, 2005, 2006, 2009, 2011, 2016}, u = {0.14, 0.18, 0.13, 0.14});
    FilteredRampEdges fre_REMOR(t = {2007.5, 2009, 2012, 2015}, u = {3.3, 3.0, 3.3});
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
    LF_N = 0.47;
    Theta_hh = 0.35;      
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedHousingBubblePriceCrashScenario;
  simulatedHousingBubblePriceCrashScenario simulatedHousingBubblePriceCrash;
  
  //--------------------------------------------
  // Scenario HistoricalNoBubblesNoStimulus
  //--------------------------------------------
   class simulatedHistoricalNoBubblesNoStimulusScenario
    extends BaseEconomy;
    // Trend changes
    FilteredRampEdges fre_psi_D(t = {1985, 2005}, u = {0.30, 0.36});
    FilteredRampEdges fre_omega_0(t = {1985, 2005, 2009, 2012}, u = {0.88, 0.85, 0.83}); 
    FilteredRampEdges fre_HILD(t = {1985, 2005}, u = {0.4, 0.43}); 
    FilteredRampEdges fre_GYR(t = {1991, 1998, 2015, 2017}, u = {0.23888, 0.234, 0.228});
    FilteredRampEdges fre_mu(t = {1988, 1989, 1990, 2004, 2005, 2009}, u = {0.0350, 0.01, 0.09, 0.045});
    FilteredInterpolate fi_LF_N(t = {1980, 1989, 2007, 2009, 2012, 2015, 2019, 2020}, u = {0.47, 0.47, 0.465, 0.46, 0.45, 0.44, 0.435, 0.435});
    FilteredRampEdges fre_Theta_hh(t = {2008, 2009, 2017, 2018}, u = {0.35, 0.33, 0.30});  
    
    equation
    lambda_40 = 0.5;
    psi_D = fre_psi_D.y;
    eta = 0.14; 
    omega_0 = fre_omega_0.y;
    HILD = fre_HILD.y;
    REMOR = 3.3;   
    epsilon_GYR = 1;
    GYR = fre_GYR.y;
    mu = fre_mu.y;
    u_0 = 0.85;
    LF_N = fi_LF_N.y;
    r_m = 0.04;
    gr_g = 0.0302;
    Theta_hh = fre_Theta_hh.y;  
    Theta_hl = 0.1475; 
    ER_pr1 = 0.915;
    ER_pr0 = 0.80;    
  end simulatedHistoricalNoBubblesNoStimulusScenario;
  simulatedHistoricalNoBubblesNoStimulusScenario simulatedHistoricalNoBubblesNoStimulus;
 
  //--------------------------------------------
  // Scenario HistoricalNoFiscalStimulus
  //--------------------------------------------
   class simulatedHistoricalNoStimulusScenario
    extends BaseEconomy;
    // Trend changes
    FilteredRampEdges fre_psi_D(t = {1985, 2005}, u = {0.30, 0.36});
    FilteredRampEdges fre_omega_0(t = {1985, 2005, 2009, 2012}, u = {0.88, 0.85, 0.83}); 
    FilteredRampEdges fre_HILD(t = {1985, 2005}, u = {0.4, 0.43}); 
    FilteredRampEdges fre_GYR(t = {1991, 1998, 2015, 2017}, u = {0.23888, 0.234, 0.228});
    FilteredRampEdges fre_mu(t = {1988, 1989, 1990, 2004, 2005, 2009}, u = {0.0350, 0.01, 0.09, 0.045});
    FilteredInterpolate fi_LF_N(t = {1980, 1989, 2007, 2009, 2012, 2015, 2019, 2020}, u = {0.47, 0.47, 0.465, 0.46, 0.45, 0.44, 0.435, 0.435});
    FilteredRampEdges fre_Theta_hh(t = {2008, 2009, 2017, 2018}, u = {0.35, 0.33, 0.30});  
    // The Dotcom Bubble
    FilteredRampEdges fre_lambda_40(t = {1995, 1999, 2000, 2002}, u = {0.50, 0.60, 0.50});
    FilteredRampEdges fre_u_0(t = {1995, 1999, 2000, 2002, 2005, 2008, 2009, 2010}, u = {0.85, 0.74, 0.85, 0.78, 0.85});    
    // The Housing Bubble
    FilteredRampEdges fre_eta(t = {2000, 2005, 2007, 2009, 2011, 2016}, u = {0.14, 0.25, 0.11, 0.14});  
    FilteredRampEdges fre_REMOR(t = {2007.5, 2009, 2012, 2015}, u = {3.3, 2.25, 3.3});         
    // The Stimulus
    FilteredRampEdges fre_r_m(t = {2001, 2002, 2004, 2007, 2008, 2009, 2015, 2018}, u = {0.04, 0.02, 0.06, 0.01, 0.02});  

   equation
    lambda_40 = fre_lambda_40.y;
    psi_D = fre_psi_D.y;
    eta = fre_eta.y;
    omega_0 = fre_omega_0.y;
    HILD = fre_HILD.y;
    REMOR = fre_REMOR.y;
    epsilon_GYR = 1;
    GYR = fre_GYR.y;
    mu = fre_mu.y;
    u_0 = fre_u_0.y;
    LF_N = fi_LF_N.y;
    r_m = fre_r_m.y;
    gr_g = 0.0302;
    Theta_hh = fre_Theta_hh.y;  
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.82;    
  end simulatedHistoricalNoStimulusScenario;
  simulatedHistoricalNoStimulusScenario simulatedHistoricalNoStimulus;

  //--------------------------------------------
  // Scenario Historical
  //--------------------------------------------  
  class simulatedHistoricalScenario
    extends BaseEconomy;
    // Trend changes
    FilteredRampEdges fre_psi_D(t = {1985, 2005}, u = {0.30, 0.36});
    FilteredRampEdges fre_omega_0(t = {1985, 2005, 2009, 2012}, u = {0.88, 0.85, 0.83}); 
    FilteredRampEdges fre_HILD(t = {1985, 2005}, u = {0.4, 0.43}); 
    FilteredRampEdges fre_GYR(t = {1991, 1998, 2015, 2017}, u = {0.23888, 0.234, 0.228});
    FilteredRampEdges fre_mu(t = {1988, 1989, 1990, 2004, 2005, 2009}, u = {0.0350, 0.01, 0.09, 0.045});
    FilteredInterpolate fi_LF_N(t = {1980, 1989, 2007, 2009, 2012, 2015, 2019, 2020}, u = {0.47, 0.47, 0.465, 0.46, 0.45, 0.44, 0.435, 0.435});
    FilteredRampEdges fre_Theta_hh(t = {2008, 2009, 2017, 2018}, u = {0.35, 0.33, 0.30});  
    // The Dotcom Bubble
    FilteredRampEdges fre_lambda_40(t = {1995, 1999, 2000, 2002}, u = {0.50, 0.60, 0.50});
    FilteredRampEdges fre_u_0(t = {1995, 1999, 2000, 2002, 2005, 2008, 2009, 2010}, u = {0.85, 0.74, 0.85, 0.78, 0.85});    
    // The Housing Bubble
    FilteredRampEdges fre_eta(t = {2000, 2005, 2007, 2009, 2011, 2016}, u = {0.14, 0.25, 0.11, 0.14});  
    FilteredRampEdges fre_REMOR(t = {2007.5, 2009, 2012, 2015}, u = {3.3, 2.25, 3.3});         
    // The Stimulus
    FilteredRampEdges fre_r_m(t = {2001, 2002, 2004, 2007, 2008, 2009, 2015, 2018}, u = {0.04, 0.02, 0.06, 0.01, 0.02});  
    FilteredRampEdges fre_gr_g(t = {2008, 2009, 2010, 2011, 2013, 2014, 2015, 2016}, u = {0.0302, 0.11, 0.0302, -0.03, 0.0302}); 
         
    equation
    lambda_40 = fre_lambda_40.y;
    psi_D = fre_psi_D.y;
    eta = fre_eta.y;
    omega_0 = fre_omega_0.y;
    HILD = fre_HILD.y;
    REMOR = fre_REMOR.y;
    epsilon_GYR = 1;
    GYR = fre_GYR.y;
    mu = fre_mu.y;
    u_0 = fre_u_0.y; 
    LF_N = fi_LF_N.y;
    r_m = fre_r_m.y;
    gr_g = fre_gr_g.y;
    Theta_hh = fre_Theta_hh.y;  
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedHistoricalScenario;
  simulatedHistoricalScenario simulatedHistorical;
  
  //--------------------------------------------
  // To simulate growth in the long run, disable other scenarios
  // Scenario Historical + Fiscal Expansion
  //--------------------------------------------
  class simulatedFiscalExpansionScenario
    extends BaseEconomy;
    // Trend changes
    FilteredRampEdges fre_psi_D(t = {1985, 2005}, u = {0.30, 0.36});
    FilteredRampEdges fre_omega_0(t = {1985, 2005, 2009, 2012}, u = {0.88, 0.85, 0.83}); 
    FilteredRampEdges fre_HILD(t = {1985, 2005}, u = {0.4, 0.43}); 
    FilteredRampEdges fre_mu(t = {1988, 1989, 1990, 2004, 2005, 2009}, u = {0.0350, 0.01, 0.09, 0.045});
    FilteredInterpolate fi_LF_N(t = {1980, 1989, 2007, 2009, 2012, 2015, 2019, 2020}, u = {0.47, 0.47, 0.465, 0.46, 0.45, 0.44, 0.435, 0.435});
    FilteredRampEdges fre_Theta_hh(t = {2008, 2009, 2017, 2018}, u = {0.35, 0.33, 0.30});  
    // The Dotcom Bubble
    FilteredRampEdges fre_lambda_40(t = {1995, 1999, 2000, 2002}, u = {0.50, 0.60, 0.50});
    FilteredRampEdges fre_u_0(t = {1995, 1999, 2000, 2002, 2005, 2008, 2009, 2010}, u = {0.85, 0.74, 0.85, 0.78, 0.85});    
    // The Housing Bubble
    FilteredRampEdges fre_eta(t = {2000, 2005, 2007, 2009, 2011, 2016}, u = {0.14, 0.25, 0.11, 0.14});  
    FilteredRampEdges fre_REMOR(t = {2007.5, 2009, 2012, 2015}, u = {3.3, 2.25, 3.3});         
    // The Stimulus
    FilteredRampEdges fre_r_m(t = {2001, 2002, 2004, 2007, 2008, 2009, 2015, 2018}, u = {0.04, 0.02, 0.06, 0.01, 0.02});  
    FilteredRampEdges fre_gr_g(t = {2008, 2009, 2010, 2011, 2013, 2014, 2015, 2016, 2017, 2017.5, 2018, 2018.5}, u = {0.0302, 0.11, 0.0302, -0.03, 0.0302, 0.10, 0.0302}); 
    FilteredRampEdges fre_GYR(t = {1991, 1998, 2017, 2018}, u = {0.23888, 0.234, 0.24});    
          
    equation
    lambda_40 = fre_lambda_40.y;
    psi_D = fre_psi_D.y;
    eta = fre_eta.y;
    omega_0 = fre_omega_0.y;
    HILD = fre_HILD.y;
    REMOR = fre_REMOR.y;
    epsilon_GYR = 1;
    GYR = fre_GYR.y;
    mu = fre_mu.y;
    u_0 = fre_u_0.y; 
    LF_N = fi_LF_N.y;
    r_m = fre_r_m.y;
    gr_g = fre_gr_g.y;
    Theta_hh = fre_Theta_hh.y;  
    Theta_hl = 0.1475; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
end simulatedFiscalExpansionScenario;
  simulatedFiscalExpansionScenario simulatedFiscalExpansion;
 
  //--------------------------------------------
  // To simulate growth in the long run, disable other scenarios
  // Scenario Historical + Income Redistribution
  //--------------------------------------------
  class simulatedIncomeRedistributionScenario
    extends BaseEconomy;
    // Trend changes
    FilteredRampEdges fre_psi_D(t = {1985, 2005}, u = {0.30, 0.36});
    FilteredRampEdges fre_omega_0(t = {1985, 2005, 2009, 2012}, u = {0.88, 0.85, 0.83}); 
    FilteredRampEdges fre_HILD(t = {1985, 2005}, u = {0.4, 0.43}); 
    FilteredRampEdges fre_GYR(t = {1991, 1998, 2015, 2017}, u = {0.23888, 0.234, 0.228});
    FilteredRampEdges fre_mu(t = {1988, 1989, 1990, 2004, 2005, 2009}, u = {0.0350, 0.01, 0.09, 0.045});
    FilteredInterpolate fi_LF_N(t = {1980, 1989, 2007, 2009, 2012, 2015, 2019, 2020}, u = {0.47, 0.47, 0.465, 0.46, 0.45, 0.44, 0.435, 0.435});
    // The Dotcom Bubble
    FilteredRampEdges fre_lambda_40(t = {1995, 1999, 2000, 2002}, u = {0.50, 0.60, 0.50});
    FilteredRampEdges fre_u_0(t = {1995, 1999, 2000, 2002, 2005, 2008, 2009, 2010}, u = {0.85, 0.74, 0.85, 0.78, 0.85});    
    // The Housing Bubble
    FilteredRampEdges fre_eta(t = {2000, 2005, 2007, 2009, 2011, 2016}, u = {0.14, 0.25, 0.11, 0.14});  
    FilteredRampEdges fre_REMOR(t = {2007.5, 2009, 2012, 2015}, u = {3.3, 2.25, 3.3});         
    // The Stimulus
    FilteredRampEdges fre_r_m(t = {2001, 2002, 2004, 2007, 2008, 2009, 2015, 2018}, u = {0.04, 0.02, 0.06, 0.01, 0.02});  
    FilteredRampEdges fre_gr_g(t = {2008, 2009, 2010, 2011, 2013, 2014, 2015, 2016}, u = {0.0302, 0.11, 0.0302, -0.03, 0.0302});     
    // The Income Redistribution    
    FilteredRampEdges fre_Theta_hh(t = {2008, 2009, 2017, 2018}, u = {0.35, 0.33, 0.35});      
    FilteredRampEdges fre_Theta_hl(t = {2017, 2018}, u = {0.1475, 0.08});      
    
         
    equation
    lambda_40 = fre_lambda_40.y;
    psi_D = fre_psi_D.y;
    eta = fre_eta.y;
    omega_0 = fre_omega_0.y;
    HILD = fre_HILD.y;
    REMOR = fre_REMOR.y;
    epsilon_GYR = 1;
    GYR = fre_GYR.y;
    mu = fre_mu.y;
    u_0 = fre_u_0.y; 
    LF_N = fi_LF_N.y;
    r_m = fre_r_m.y;
    gr_g = fre_gr_g.y;
    Theta_hh = fre_Theta_hh.y;  
    Theta_hl = fre_Theta_hl.y; 
    ER_pr1 = 0.94;
    ER_pr0 = 0.90;    
  end simulatedIncomeRedistributionScenario;
  simulatedIncomeRedistributionScenario simulatedIncomeRedistribution;
  
  //--------------------------------------------
  // probes
  //--------------------------------------------
  
  Real x_y_actualHistorical;  
  Real x_YP_hh__YP_actualRatio;   
  Real x_Dy_simulatedFiscalStimulus_to_y_Reference; 
  Real x_Dg_simulatedFiscalStimulus_to_y_Reference; 
  Real x_Dy_simulatedFiscalWithdrawal_to_y_Reference; 
  Real x_Dg_simulatedFiscalWithdrawal_to_y_Reference; 
  Real x_Dy_simulatedTradeBalanceChanges_to_y_Reference;  
  Real x_y_simulatedFiscalStimulus_to_y_Reference;  
  Real x_y_simulatedTradeBalanceChanges_to_y_Reference;
  Real x_y_simulatedMonetaryStimulus_to_y_Reference;
  Real x_y_simulatedFiscalWithdrawal_to_y_Reference;
  Real x_y_simulatedDistributionalChanges_to_y_Reference;
  Real x_y_simulatedStockmarketBubble_to_y_Reference;
  Real x_y_simulatedHousingBubble_to_y_Reference;
  Real x_y_simulatedHousingBubblePriceCrash_to_y_Reference;
  Real x_y_simulatedHistorical_to_y_Reference;
  Real x_yd_rh_simulatedDistributionalChanges_to_yd_rh_Reference;
  Real x_yd_rl_simulatedDistributionalChanges_to_yd_rl_Reference;

  equation
    x_YP_hh__YP_actualRatio = Modelica.Math.Vectors.interpolate(years, high_income_ratios, time); 
    x_y_actualHistorical = Modelica.Math.Vectors.interpolate(years,y_values, time); 
    x_Dy_simulatedFiscalStimulus_to_y_Reference = (simulatedFiscalStimulus.y - simulatedReference.y) / simulatedReference.y; 
    x_Dg_simulatedFiscalStimulus_to_y_Reference = (simulatedFiscalStimulus._g - simulatedReference._g) / simulatedReference.y;  
    x_Dy_simulatedFiscalWithdrawal_to_y_Reference = (simulatedFiscalWithdrawal.y - simulatedReference.y) / simulatedReference.y; 
    x_Dg_simulatedFiscalWithdrawal_to_y_Reference = (simulatedFiscalWithdrawal._g - simulatedReference._g) / simulatedReference.y;  
    x_Dy_simulatedTradeBalanceChanges_to_y_Reference = (simulatedTradeBalanceChanges.y - simulatedReference.y) / simulatedReference.y;
    x_y_simulatedFiscalStimulus_to_y_Reference = simulatedFiscalStimulus.y / simulatedReference.y;
    x_y_simulatedTradeBalanceChanges_to_y_Reference = simulatedTradeBalanceChanges.y / simulatedReference.y;
    x_y_simulatedMonetaryStimulus_to_y_Reference = simulatedMonetaryStimulus.y / simulatedReference.y;   
    x_y_simulatedFiscalWithdrawal_to_y_Reference = simulatedFiscalWithdrawal.y / simulatedReference.y;            
    x_y_simulatedDistributionalChanges_to_y_Reference = simulatedDistributionalChanges.y / simulatedReference.y;    
    x_y_simulatedStockmarketBubble_to_y_Reference = simulatedStockmarketBubble.y / simulatedReference.y; 
    x_y_simulatedHousingBubble_to_y_Reference = simulatedHousingBubble.y / simulatedReference.y; 
    x_y_simulatedHousingBubblePriceCrash_to_y_Reference = simulatedHousingBubblePriceCrash.y / simulatedReference.y; 
    x_y_simulatedHistorical_to_y_Reference = simulatedHistorical.y / simulatedReference.y;
    x_yd_rh_simulatedDistributionalChanges_to_yd_rh_Reference = simulatedDistributionalChanges.yd_rh/simulatedReference.yd_rh;        
    x_yd_rl_simulatedDistributionalChanges_to_yd_rl_Reference = simulatedDistributionalChanges.yd_rl/simulatedReference.yd_rl;        
  annotation(
      experiment(StartTime = 1984, StopTime = 2019, Tolerance = 1e-6, Interval = 0.01),
    __OpenModelica_simulationFlags( lv = "LOG_STATS", s = "dassl", nls = "homotopy", ls = "totalpivot"));
end EconomicModels;
