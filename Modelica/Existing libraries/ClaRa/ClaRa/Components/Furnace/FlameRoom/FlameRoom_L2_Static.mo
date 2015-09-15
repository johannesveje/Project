within ClaRa.Components.Furnace.FlameRoom;
model FlameRoom_L2_Static "Model for a flame room section inside a combustion chamber"
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
extends ClaRa.Components.Furnace.BaseClasses.CombustionChamberBase(
        geo(flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical));

extends ClaRa.Basics.Icons.FlameRoom;
//## P A R A M E T E R S #######################################################################################
inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));

//## V A R I A B L E   P A R T##################################################################################
inner ClaRa.Basics.Units.MassFraction
                                  prod_comp[flueGas.nc-1]; //Molar flow of produced components per coal mass burned

//___________________/ iCom record \\__________________
protected
  inner ClaRa.Basics.Records.IComGas_L2 iCom(
    m_flow_nom=m_flow_nom,
    T_bulk=flueGasOutlet.T,
    p_bulk=inlet.flueGas.p,
    fluidPointer_in=flueGasInlet.gasPointer,
    fluidPointer_bulk=flueGasOutlet.gasPointer,
    fluidPointer_out=flueGasOutlet.gasPointer,
    mediumModel=flueGas,
    p_in=inlet.flueGas.p,
    T_in=inStream(inlet.flueGas.T_outflow),
    m_flow_in=inlet.flueGas.m_flow,
    V_flow_in=V_flow_flueGas_in,
    xi_in=inStream(inlet.flueGas.xi_outflow),
    p_out=outlet.flueGas.p,
    T_out=flueGasOutlet.T,
    m_flow_out=outlet.flueGas.m_flow,
    V_flow_out=V_flow_flueGas_out,
    xi_out=xi_flueGas) annotation (Placement(transformation(extent={{244,-102},{268,-76}})));

equation
   mass = geo.volume * (flueGasOutlet.d + flueGasInlet.d)/2;

   //____________/ Resulting Xi for entire coal mass in the volume \______________
   xi_coal_in = inStream(inlet.coal.xi_outflow);

   //________________/ Mass balance - flue gas \______________________________________
   0 =m_flow_coal_burned*(1 - xi_coal_in[6]*reactionZone.xi_slag) + inlet.flueGas.m_flow + outlet.flueGas.m_flow;

   //______________ / Mass balance - Slag \____________________________________________________________________________
   0 =inlet.slag.m_flow + m_flow_coal_burned*xi_coal_in[6]*reactionZone.xi_slag + outlet.slag.m_flow;

   //______________/ Mass balance - Coal \____________________________
   0 =outlet.coal.m_flow + inlet.coal.m_flow - m_flow_coal_burned;

   //__________/ molar flow rates of combustable components (educts) into the whole burner system (maybe not all of it is burned) \________
   n_flow_C = xi_coal_in[1]*inlet.coal.m_flow /ClaRa.Basics.Constants.M_C;
   n_flow_H = xi_coal_in[2]*inlet.coal.m_flow /ClaRa.Basics.Constants.M_H;
   n_flow_O = xi_coal_in[3]*inlet.coal.m_flow /ClaRa.Basics.Constants.M_O;
   n_flow_N = xi_coal_in[4]*inlet.coal.m_flow /ClaRa.Basics.Constants.M_N;
   n_flow_S = xi_coal_in[5]*inlet.coal.m_flow /ClaRa.Basics.Constants.M_S;
   n_flow_Ash = xi_coal_in[6]*inlet.coal.m_flow /ClaRa.Basics.Constants.M_Ash;
   n_flow_H2O = (1-sum(xi_coal_in))*inlet.coal.m_flow /ClaRa.Basics.Constants.M_H2O;

   //_______________/ determination of lambda \_________________________
   // theoretically required oxygen mass flow rate to burn all the coal
   m_flow_oxygen_req = (1-coal_diffusity)*(n_flow_C + n_flow_H/4.0 + n_flow_S - n_flow_O/2)*ClaRa.Basics.Constants.M_O
                                                                                            *2.0;
   m_flow_air_req*max(1e-32,flueGasInlet.xi[6]) = m_flow_oxygen_req;

   if noEvent(m_flow_oxygen_req <= 0) then
    lambdaComb = 1.0e3;
   else
    lambdaComb = (inlet.flueGas.m_flow*flueGasInlet.xi[6])/max(1e-12, m_flow_oxygen_req);
   end if;

   //calculation of actual coal and oxygen mass flow rates that are burned
  if noEvent(lambdaComb > 1) then
    m_flow_coal_burned = (1 - coal_diffusity)*inlet.coal.m_flow;
    m_flow_oxygen_burned = m_flow_oxygen_req;
   else
    m_flow_coal_burned = lambdaComb*(1 - coal_diffusity)*inlet.coal.m_flow;
    m_flow_oxygen_burned = lambdaComb*m_flow_oxygen_req;
   end if;

   //_____________/ Calculation of the LHV \______________________________________
   if LHV_calculationType == "fixed" then
    LHV = LHV_fixed;
   elseif LHV_calculationType == "Verbandsformel" then
    LHV =(33907*xi_coal_in[1] + 142324*(xi_coal_in[2] - xi_coal_in[3]/8.) + 10465*xi_coal_in[5] - 2512*((1 - sum(xi_coal_in)) + 9*xi_coal_in[2]))*m_flow_coal_burned;
   else
    LHV = LHV_fixed;
   end if;

   //______________________________/ mass balance of flue gas components \__________________________
   zeros(flueGas.nc-1) =inlet.flueGas.m_flow*flueGasInlet.xi + outlet.flueGas.m_flow*xi_flueGas + m_flow_coal_burned*prod_comp;

   //_____________/ Calculation of coal formation enthalpy with LHV for an ideal combustion\__________________
  m_flow_coal_id = 1.0;
  m_flow_flueGas_id =(m_flow_coal_id*(1 - xi_coal_in[6]*reactionZone.xi_slag));           //ideal flue gas mass flow
  xi_flueGas_id =1/m_flow_flueGas_id*prod_comp;   //products of an ideal combustion

  sum_comp = sum(xi_flueGas_id);
  Delta_h_f - LHV =m_flow_flueGas_id*((ideal_combustion.h_i)*cat(1,xi_flueGas_id,{1 - sum(xi_flueGas_id)})) + xi_coal_in[6]*reactionZone.xi_slag*outlet.slagType.cp*T_0; //formation enthalpy of used coal

   //_______________/ Energy Balance flueGasCombustion \__________________________

  0 =Q_flow_wall + Q_flow_top + Q_flow_bottom + inlet.flueGas.m_flow*flueGasInlet.h + inlet.coal.m_flow*(inlet.coalType.cp*(inStream(inlet.coal.T_outflow) - T_0) + Delta_h_f) + outlet.coal.m_flow*(outlet.coalType.cp*(outlet.coal.T_outflow - T_0) + Delta_h_f) + outlet.slag.m_flow*outlet.slagType.cp*(inStream(outlet.slag.T_outflow) - T_0) + inlet.slag.m_flow*inlet.slagType.cp*(inlet.slag.T_outflow - T_0) + outlet.flueGas.m_flow*h_flueGas_out;

  //______________/Properties for heat transfer corellation\_________

  der(V_flow_flueGas_out) = 1/Tau*(outlet.flueGas.m_flow/flueGasOutlet.d - V_flow_flueGas_out);
  V_flow_flueGas_in = inlet.flueGas.m_flow/flueGasInlet.d;

  sum_xi = sum(flueGasOutlet.xi);

  xi_coal_out = xi_coal_in; //no change of coal composition during combustion

  xi_coal = (inlet.coal.m_flow)/(inlet.flueGas.m_flow); // amount of coal per flue gas mass

   //___________/ T_outflows \__________________________________________
  outlet.coal.T_outflow = flueGasOutlet.T;
  outlet.flueGas.T_outflow = flueGasOutlet.T;
  inlet.slag.T_outflow =T_slag;
  heat_bottom.T = iCom.T_out;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-100},
            {300,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-100},{300,100}}), graphics={
        Text(
          extent={{34,90},{242,56}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "T_out="+realString(T_outlet,1,integer(0)) +"K")),
        Text(
          extent={{34,44},{242,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "lambda="+realString(min(99,lambda),1,integer(1)))),
        Text(
          extent={{34,-54},{242,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "Q="+realString(-Q_combustion/1e6,1,integer(0))+"MW")),
        Text(
          extent={{32,-14},{240,-48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "alphaA="+realString(heattransfer.effAlphaA,1,integer(0))+""))}),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b>Model description: </b>A stationary flame room model for coal fired furnaces</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Stationary mass and energy balances are used</li>
<li>The formation enthalpy of the used coal is calculated with the given Lower heating value and and ideal combustion with the given elemental composition of the coal</li>
<li>Lower heating can be regarded with a fixed value or calculated according to the &QUOT;Verbandsformel&QUOT;</li>
<li>Different heat transfer correlations can be chosen</li>
<li>Capable to burn unburnt coal from lower burner sections</li>
<li>Amount of burnable coal mass is calculated with particle diffusity which depends on models used to determine the mean migration speed according to the volume flow rates of the flue gas</li>
</ul></p>
</html>"));
end FlameRoom_L2_Static;
