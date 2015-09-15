within ClaRa.Components.Furnace.Burner;
model Burner_L2_Static "Model for a burner section inside a combustion chamber"
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
        geo(flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical));      //(flueGasCombustion(p = outlet.flueGas.p, xi = xi_flueGas));
extends ClaRa.Basics.Icons.Burner;

//## P A R A M E T E R S #######################################################################################
inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));

//## V A R I A B L E   P A R T##################################################################################
public
Real lambdaComb_primary;
ClaRa.Basics.Units.MassFlowRate m_flow_oxygen_req_primary;
ClaRa.Basics.Units.MassFlowRate m_flow_air_req_primary;

protected
Modelica.SIunits.MolarFlowRate  n_flow_C_primary;
Modelica.SIunits.MolarFlowRate  n_flow_H_primary;
Modelica.SIunits.MolarFlowRate  n_flow_O_primary;
Modelica.SIunits.MolarFlowRate  n_flow_S_primary;
inner ClaRa.Basics.Units.MassFraction prod_comp[flueGas.nc - 1];
                                                           //Molar flow of produced components per coal mass burned
ClaRa.Basics.Units.MassFraction xi_flueGasMix[flueGas.nc - 1];
                                                         //Flue gas mixture composition
ClaRa.Basics.Units.EnthalpyMassSpecific h_flueGasMix;

//_____________________/ Connectors \______________________________
public
ClaRa.Basics.Interfaces.CoalDust_inlet coalDust_inlet(flueGas(Medium=flueGas),
      final coalType=coalType)
    annotation (Placement(transformation(extent={{-310,-10},{-290,10}}),
        iconTransformation(extent={{-310,-10},{-290,10}})));

//_____________________/ Media Objects \_________________________________
protected
  TILMedia.Gas_pT    primaryAir_inlet(p=coalDust_inlet.flueGas.p, T=inStream(coalDust_inlet.flueGas.T_outflow), xi=inStream(
        coalDust_inlet.flueGas.xi_outflow),
    gasType=flueGas)
    annotation (Placement(transformation(extent={{-290,-10},{-270,10}})));

  TILMedia.Gas_ph inlet_GasMix(p=inlet.flueGas.p,xi=xi_flueGasMix,gasType=flueGas,h(start = 1.0E4)=h_flueGasMix)
     annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

//___________________/ iCom record \\__________________
protected
  inner ClaRa.Basics.Records.IComGas_L2 iCom(
    m_flow_nom=m_flow_nom,
    T_bulk=flueGasOutlet.T,
    p_bulk=inlet.flueGas.p,
    fluidPointer_in=inlet_GasMix.gasPointer,
    fluidPointer_bulk=flueGasOutlet.gasPointer,
    fluidPointer_out=flueGasOutlet.gasPointer,
    mediumModel=flueGas,
    p_in=inlet.flueGas.p,
    T_in=inlet_GasMix.T,
    m_flow_in=inlet.flueGas.m_flow + coalDust_inlet.coal.m_flow,
    V_flow_in=V_flow_flueGas_in,
    xi_in=xi_flueGasMix,
    p_out=outlet.flueGas.p,
    T_out=flueGasOutlet.T,
    m_flow_out=outlet.flueGas.m_flow,
    V_flow_out=V_flow_flueGas_out,
    xi_out=xi_flueGas) annotation (Placement(transformation(extent={{244,-102},{268,-76}})));

equation
  mass = geo.volume * (flueGasOutlet.d + inlet_GasMix.d)/2;

  //____________/ Resulting Xi for entire coal mass in the volume \______________
  if (inlet.coal.m_flow + coalDust_inlet.coal.m_flow <= 0.0) then
     xi_coal_in = inStream(inlet.coal.xi_outflow);
   else
    (inlet.coal.m_flow + coalDust_inlet.coal.m_flow) * xi_coal_in = inStream(
      coalDust_inlet.coal.xi_outflow)                                                                        * coalDust_inlet.coal.m_flow + inStream(inlet.
      coal.xi_outflow)                                                                                                    * inlet.coal.m_flow;
  end if;
  //__________________________/ Resulting Xi for flue gas mix \____________________________
  inlet.flueGas.m_flow * inStream(inlet.flueGas.xi_outflow) +  coalDust_inlet.flueGas.m_flow * inStream(
    coalDust_inlet.flueGas.xi_outflow)                                                                                                    - (inlet.flueGas.m_flow+coalDust_inlet.flueGas.m_flow)*xi_flueGasMix = zeros(flueGas.nc-1);

  //________________/ Mass balance - flue gas \______________________________________
  0 =m_flow_coal_burned*(1 - xi_coal_in[6]*reactionZone.xi_slag) + inlet.flueGas.m_flow + coalDust_inlet.flueGas.m_flow + outlet.flueGas.m_flow;

  //______________ / Mass balance - Slag \____________________________________________________________________________
  0 =inlet.slag.m_flow + m_flow_coal_burned*xi_coal_in[6]*reactionZone.xi_slag + outlet.slag.m_flow;

  //______________/ Mass balance - Coal \____________________________
  0 =outlet.coal.m_flow + inlet.coal.m_flow + coalDust_inlet.coal.m_flow - m_flow_coal_burned;

  //__________/ molar flow rates of combustable components (educts) into the whole burner system (maybe not all of it is burned) \________
  n_flow_C = xi_coal_in[1]*(coalDust_inlet.coal.m_flow + inlet.coal.m_flow) /Basics.Constants.M_C;
  n_flow_H = xi_coal_in[2]*(coalDust_inlet.coal.m_flow + inlet.coal.m_flow) /Basics.Constants.M_H;
  n_flow_O = xi_coal_in[3]*(coalDust_inlet.coal.m_flow + inlet.coal.m_flow) /Basics.Constants.M_O;
  n_flow_N = xi_coal_in[4]*(coalDust_inlet.coal.m_flow + inlet.coal.m_flow) /Basics.Constants.M_N;
  n_flow_S = xi_coal_in[5]*(coalDust_inlet.coal.m_flow + inlet.coal.m_flow) /Basics.Constants.M_S;
  n_flow_Ash = xi_coal_in[6]*(coalDust_inlet.coal.m_flow + inlet.coal.m_flow) /Basics.Constants.M_Ash;
  n_flow_H2O = (1-sum(xi_coal_in))*(coalDust_inlet.coal.m_flow + inlet.coal.m_flow) /Basics.Constants.M_H2O;

  //_______________/ determination of lambda at burner\_________________________
  n_flow_C_primary =inStream(coalDust_inlet.coal.xi_outflow[1])*coalDust_inlet.coal.m_flow
    /Basics.Constants.M_C;
  n_flow_H_primary =inStream(coalDust_inlet.coal.xi_outflow[2])*coalDust_inlet.coal.m_flow
    /Basics.Constants.M_H;
  n_flow_O_primary =inStream(coalDust_inlet.coal.xi_outflow[3])*coalDust_inlet.coal.m_flow
    /Basics.Constants.M_O;
  n_flow_S_primary =inStream(coalDust_inlet.coal.xi_outflow[5])*coalDust_inlet.coal.m_flow
    /Basics.Constants.M_S;

  m_flow_oxygen_req_primary = (n_flow_C_primary + n_flow_H_primary/4.0 + n_flow_S_primary - n_flow_O_primary/2)*Basics.Constants.M_O
                                                                                            *2.0;
  m_flow_air_req_primary*max(1e-32,primaryAir_inlet.xi[6]) = m_flow_oxygen_req_primary;

  if noEvent(m_flow_oxygen_req_primary <= 0) then
      lambdaComb_primary  = 1.0e3;
  else
    lambdaComb_primary = (coalDust_inlet.flueGas.m_flow*primaryAir_inlet.xi[6]) /(max(1e-12,m_flow_oxygen_req_primary));
  end if;

  //_______________/ determination of lambda (overall volume, regarding unburnt coal and oxygen)\_________________________
  // theoretically required oxygen mass flow rate to burn all the coal
   m_flow_oxygen_req = (1-coal_diffusity)*(n_flow_C + n_flow_H/4.0 + n_flow_S - n_flow_O/2)*Basics.Constants.M_O
                                                                                            *2.0;
   m_flow_air_req*max(1e-32,primaryAir_inlet.xi[6]) = m_flow_oxygen_req;

    if noEvent(m_flow_oxygen_req <= 0) then
    lambdaComb = 1.0e3;
      else
    lambdaComb = (coalDust_inlet.flueGas.m_flow*primaryAir_inlet.xi[6] + inlet.flueGas.m_flow*inStream(inlet.flueGas.xi_outflow[6]))/(max(1e-12, m_flow_oxygen_req));
    end if;

  //calculation of actual coal and oxygen mass flow rates that are burned
  if noEvent(lambdaComb > 1) then
    m_flow_coal_burned = min(1, (1 - coal_diffusity))*(inlet.coal.m_flow + coalDust_inlet.coal.m_flow);
    m_flow_oxygen_burned = m_flow_oxygen_req;
  else
    m_flow_coal_burned = lambdaComb*min(1, (1 - coal_diffusity))*(inlet.coal.m_flow + coalDust_inlet.coal.m_flow);
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
  zeros(flueGas.nc-1) =inlet.flueGas.m_flow*flueGasInlet.xi + coalDust_inlet.flueGas.m_flow*primaryAir_inlet.xi + outlet.flueGas.m_flow*xi_flueGas + m_flow_coal_burned*prod_comp;

  //_____________/ Calculation of coal formation enthalpy with LHV for an ideal combustion\__________________
  m_flow_coal_id = 1.0;
  m_flow_flueGas_id =(m_flow_coal_id*(1 - xi_coal_in[6]*reactionZone.xi_slag));           //ideal flue gas mass flow
   xi_flueGas_id =1/m_flow_flueGas_id*prod_comp;   //products of an ideal combustion

   sum_comp = sum(xi_flueGas_id);
  Delta_h_f - LHV =m_flow_flueGas_id*((ideal_combustion.h_i)*cat(1,xi_flueGas_id,{1 - sum(xi_flueGas_id)})) + xi_coal_in[6]*reactionZone.xi_slag*outlet.slagType.cp*T_0;  //formation enthalpy of used coal

  //_______________/ Energy Balance flueGasCombustion \__________________________
  0 =Q_flow_wall + Q_flow_top + Q_flow_bottom + inlet.flueGas.m_flow*flueGasInlet.h + coalDust_inlet.flueGas.m_flow*primaryAir_inlet.h + inlet.coal.m_flow*(inlet.coalType.cp*(inStream(inlet.coal.T_outflow) - T_0) + Delta_h_f) + coalDust_inlet.coal.m_flow*(coalDust_inlet.coalType.cp*(inStream(coalDust_inlet.coal.T_outflow) - T_0) + Delta_h_f) + outlet.coal.m_flow*(outlet.coalType.cp*(outlet.coal.T_outflow - T_0) + Delta_h_f) + outlet.slag.m_flow*outlet.slagType.cp*(inStream(outlet.slag.T_outflow) - T_0) + inlet.slag.m_flow*inlet.slagType.cp*(inlet.slag.T_outflow - T_0) + outlet.flueGas.m_flow*h_flueGas_out;

  sum_xi = sum(flueGasOutlet.xi);

  //______________/Calculation of Properties for heat transfer corellation (small energy balance for inlet flue gas streams) \_________

  der(V_flow_flueGas_out) = 1/Tau*(outlet.flueGas.m_flow/flueGasOutlet.d - V_flow_flueGas_out);
  V_flow_flueGas_in = (inlet.flueGas.m_flow + coalDust_inlet.flueGas.m_flow)/inlet_GasMix.d;

  h_flueGasMix = (coalDust_inlet.flueGas.m_flow * primaryAir_inlet.h + inlet.flueGas.m_flow * flueGasInlet.h)/(inlet.flueGas.m_flow+coalDust_inlet.flueGas.m_flow);

  xi_coal_out = xi_coal_in; //no change of coal composition during combustion

  xi_coal = (inlet.coal.m_flow + coalDust_inlet.coal.m_flow)/(inlet.flueGas.m_flow + coalDust_inlet.flueGas.m_flow);// amount of coal per flue gas mass

  //___________/ T_outflows \__________________________________________
  outlet.coal.T_outflow = flueGasOutlet.T;
  outlet.flueGas.T_outflow = flueGasOutlet.T;
  inlet.slag.T_outflow =T_slag;           //inlet.slag is outflowing slag
  heat_bottom.T = iCom.T_out;
  //_____________/ Pressures \______________________________________________
  coalDust_inlet.coal.p = outlet.flueGas.p;
  coalDust_inlet.flueGas.p = outlet.flueGas.p;

 //____________/ (Dummy) values for inlet_outflows \_____________
  coalDust_inlet.coal.xi_outflow = xi_coal_out;
  coalDust_inlet.flueGas.xi_outflow =  xi_flueGas;

  coalDust_inlet.coal.T_outflow = inStream(coalDust_inlet.coal.T_outflow);
  coalDust_inlet.flueGas.T_outflow = inStream(coalDust_inlet.flueGas.T_outflow);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-100},
            {300,100}}),
                      graphics={
        Line(
          points={{-260,0},{-140,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Polygon(
          points={{-136,0},{-144,4},{-144,-4},{-136,0}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{4,0},{-4,4},{-4,-4},{4,0}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-120,-20},
          rotation=90),
        Line(
          points={{-120,-60},{-120,-20}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-300,-100},{300,100}}), graphics={
        Text(
          extent={{32,90},{240,56}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "T_out="+realString(T_outlet,1,integer(1)) +"K")),
        Text(
          extent={{32,-14},{240,-48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "alphaA="+realString(heattransfer.effAlphaA,1,integer(0))+"")),
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
          textString=DynamicSelect("", "Q="+realString(-Q_combustion/1e6,1,integer(0))+"MW"))}),
    Documentation(info="<html>
<p><b>Model description: </b>A stationary burner model for coal fired furnaces</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Stationary mass and energy balances are used</li>
<li>The formation enthalpy of the used coal is calculated with the given Lower heating value and and ideal combustion with the given elemental composition of the coal</li>
<li>Lower heating can be regarded with a fixed value or calculated according to the &QUOT;Verbandsformel&QUOT;</li>
<li>Different heat transfer correlations can be chosen </li>
<li>Amount of burnable coal mass is calculated with particle diffusity which depends on models used to determine the mean migration speed according to the volume flow rates of the flue gas</li>
<li>Excess air is calculated for burner (lambda primary) and overall volume (lambda) separately</li>
</ul></p>
</html>"));
end Burner_L2_Static;
