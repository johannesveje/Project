within ClaRa.Components.Furnace.ChemicalReactions;
model CoalReactionZone
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

extends ClaRa.Components.Furnace.ChemicalReactions.PartialReactionZone;

equation
   n_flow_C = xi_coal_in[1] /Basics.Constants.M_C;
   n_flow_H = xi_coal_in[2] /Basics.Constants.M_H;
   n_flow_O = xi_coal_in[3]/Basics.Constants.M_O;
   n_flow_N = xi_coal_in[4]/Basics.Constants.M_N;// N not N2!!!!!!
   n_flow_S = xi_coal_in[5] /Basics.Constants.M_S;
   n_flow_Ash = xi_coal_in[6] /Basics.Constants.M_Ash;
   n_flow_H2O = (1-sum(xi_coal_in)) /Basics.Constants.M_H2O;

   0 =xi_coal_in[1]/Basics.Constants.M_C*xi_CO - n_flow_CO;
   0 =xi_coal_in[4]/Basics.Constants.M_N*xi_NOx - n_flow_NO;
   0 = xi_coal_in[1]/Basics.Constants.M_C
                                   - n_flow_CO2 - n_flow_CO;
   0 = xi_coal_in[2]/Basics.Constants.M_H
                                  /2 + (1-sum(xi_coal_in))/(Basics.Constants.M_H
                                                                         *2+Basics.Constants.M_O)
                                                                                           - n_flow_H2O_prod;
   0 = xi_coal_in[5]/Basics.Constants.M_S
                                   - n_flow_SO2;
   0 = xi_coal_in[4]/Basics.Constants.M_N
                                  /2- n_flow_N2 - n_flow_NO/2;

 for i in 1:(flueGas.nc-1) loop
     if i==1 then
                  prod_comp[1] =xi_coal_in[6]*(1 - xi_slag);
     else if i==2 then
                       prod_comp[2] = n_flow_CO * (Basics.Constants.M_C + Basics.Constants.M_O);
     else if i==3 then
                       prod_comp[3] = n_flow_CO2 * (Basics.Constants.M_C + 2*Basics.Constants.M_O);
     else if i==4 then
                       prod_comp[4] = n_flow_SO2 * (Basics.Constants.M_S + 2*Basics.Constants.M_O);
     else if i==5 then
                       prod_comp[5] = n_flow_N2*(2*Basics.Constants.M_N);
     else if i==6 then
                       prod_comp[6] = -(n_flow_CO/2 + n_flow_CO2 + n_flow_NO/2 + n_flow_H/4.0 + n_flow_S - n_flow_O/2) * Basics.Constants.M_O * 2.0;
     else if i==7 then
                       prod_comp[7] = n_flow_NO*(Basics.Constants.M_N + Basics.Constants.M_O);
     else if i==8 then
                       prod_comp[8] = n_flow_H2O_prod * (Basics.Constants.M_H * 2+Basics.Constants.M_O);
    else
      prod_comp[i] = 0;
     end if;
             end if;
                     end if;
                             end if;
                                     end if;
                                             end if;
                                                     end if;
                                                             end if;
end for;

end CoalReactionZone;
