within ClaRa.Components.Adapters;
model CoalGas_join
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
  extends ClaRa.Basics.Icons.Adapter2_bw;
 //__________________________/ Media definintions \______________________________________________
  outer ClaRa.SimCenter simCenter;
  inner parameter ClaRa.Basics.Media.Fuel.PartialFuel coalType=simCenter.fuelModel1 "Coal elemental composition used for combustion"
                                                     annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));

  inner parameter TILMedia.GasTypes.BaseGas               flueGas = simCenter.flueGasModel "Medium to be used in tubes"
                                  annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));

  ClaRa.Basics.Interfaces.Coal_inlet coal_inlet(final coalType=coalType)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  ClaRa.Basics.Interfaces.GasPortIn flueGas_inlet(Medium=flueGas)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));

  Basics.Interfaces.CoalDust_outlet      coalDust_outlet(flueGas(Medium=flueGas),
      final coalType=coalType)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  coalDust_outlet.flueGas.m_flow = -flueGas_inlet.m_flow;
  coalDust_outlet.flueGas.T_outflow = inStream(flueGas_inlet.T_outflow);
  flueGas_inlet.T_outflow = inStream(coalDust_outlet.flueGas.T_outflow);
  coalDust_outlet.flueGas.xi_outflow = inStream(flueGas_inlet.xi_outflow);
  flueGas_inlet.xi_outflow = inStream(coalDust_outlet.flueGas.xi_outflow);
  coalDust_outlet.flueGas.p = flueGas_inlet.p;

  coalDust_outlet.coal.m_flow = -coal_inlet.m_flow;
  coalDust_outlet.coal.T_outflow = inStream(coal_inlet.T_outflow);
  coal_inlet.T_outflow = inStream(coalDust_outlet.coal.T_outflow);
  coalDust_outlet.coal.xi_outflow = inStream(coal_inlet.xi_outflow);
  coal_inlet.xi_outflow = inStream(coalDust_outlet.coal.xi_outflow);
  coalDust_outlet.coal.p = coal_inlet.p;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics),               Diagram(graphics));
end CoalGas_join;
