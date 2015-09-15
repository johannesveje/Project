within ClaRa.Components.Adapters;
model CoalSlagFlueGas_split
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
  extends ClaRa.Basics.Icons.Adapter3_fw;
//__________________________/ Media definintions \______________________________________________
  outer ClaRa.SimCenter simCenter;
  inner parameter ClaRa.Basics.Media.Fuel.PartialFuel coalType=simCenter.fuelModel1 "Coal elemental composition used for combustion"
                                                     annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));
   inner parameter ClaRa.Basics.Media.Fuel.PartialSlag slagType=simCenter.slagModel "Slag properties"
                      annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));
  inner parameter TILMedia.GasTypes.BaseGas               flueGas = simCenter.flueGasModel "Medium to be used in tubes"
                                  annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));

  ClaRa.Basics.Interfaces.Coal_outlet coal_inlet(coalType=coalType)
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  ClaRa.Basics.Interfaces.GasPortOut flueGas_inlet(Medium=flueGas)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Basics.Interfaces.Slag_inlet      slag_outlet(slagType=slagType)
                                               annotation (Placement(transformation(extent={{90,-10},
            {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  Basics.Interfaces.CoalSlagFlueGas_inlet      coalSlagFlueGas_outlet(
    flueGas(Medium=flueGas),
    final coalType=coalType,
    final slagType=slagType)                                                                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-98,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,0})));

equation
  coalSlagFlueGas_outlet.flueGas.m_flow = -flueGas_inlet.m_flow;
  coalSlagFlueGas_outlet.flueGas.T_outflow = inStream(flueGas_inlet.T_outflow);
  flueGas_inlet.T_outflow = inStream(coalSlagFlueGas_outlet.flueGas.T_outflow);
  coalSlagFlueGas_outlet.flueGas.xi_outflow = inStream(flueGas_inlet.xi_outflow);
  flueGas_inlet.xi_outflow = inStream(coalSlagFlueGas_outlet.flueGas.xi_outflow);
  coalSlagFlueGas_outlet.flueGas.p = flueGas_inlet.p;

  coalSlagFlueGas_outlet.coal.m_flow = -coal_inlet.m_flow;
  coalSlagFlueGas_outlet.coal.T_outflow = inStream(coal_inlet.T_outflow);
  coal_inlet.T_outflow = inStream(coalSlagFlueGas_outlet.coal.T_outflow);
  coalSlagFlueGas_outlet.coal.xi_outflow = inStream(coal_inlet.xi_outflow);
  coal_inlet.xi_outflow = inStream(coalSlagFlueGas_outlet.coal.xi_outflow);
  coalSlagFlueGas_outlet.coal.p = coal_inlet.p;

  coalSlagFlueGas_outlet.slag.m_flow = -slag_outlet.m_flow;
  coalSlagFlueGas_outlet.slag.T_outflow = inStream(slag_outlet.T_outflow);
  slag_outlet.T_outflow = inStream(coalSlagFlueGas_outlet.slag.T_outflow);
  coalSlagFlueGas_outlet.slag.p = slag_outlet.p;

  annotation (Icon(graphics),
                           Diagram(graphics));
end CoalSlagFlueGas_split;
