within ClaRa.Components.Furnace.Check;
model Test_CombustionChamber
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

  import ClaRa;
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;

  SimpleCombustionChamber combustionChamber(
    calculate_LHV=false,
    xi_NOx=0000,
    coalType=simCenter.fuelModel1,
    medium=simCenter.flueGasModel,
    slagType=simCenter.slagModel) annotation (Placement(transformation(extent={{18,-36},{38,-16}})));
  inner ClaRa.SimCenter simCenter(       redeclare ClaRa.Basics.Media.Fuel.Coal_v1
                                      fuelModel1,
    redeclare ClaRa.Basics.Media.Fuel.Slag_v1 slagModel,
    redeclare TILMedia.GasTypes.FlueGasTILMedia flueGasModel)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_pT slagSink(slagType=ClaRa.Basics.Media.Fuel.Slag_v1()) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,-66})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource(
    m_flow_const=15,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})
                     annotation (Placement(transformation(extent={{-42,-52},{-22,-32}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink(medium=simCenter.flueGasModel, p_const=100000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={28,10})));
  ClaRa.Components.BoundaryConditions.BoundaryCoal_Txim_flow coalFlowSource(m_flow_const=1) annotation (Placement(transformation(extent={{-42,-16},{-22,4}})));
  ClaRa.Components.Adapters.CoalGas_join             coalGas_join
    annotation (Placement(transformation(extent={{-8,-36},{12,-16}})));
equation
  connect(coalFlowSource.coal_a, coalGas_join.coal_inlet) annotation (Line(
      points={{-22,-6},{-16,-6},{-16,-20},{-8,-20}},
      color={27,36,42},
      pattern=LinePattern.None,
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource.gas_a, coalGas_join.flueGas_inlet) annotation (Line(
      points={{-22,-42},{-16,-42},{-16,-32},{-8,-32}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join.coalDust_outlet, combustionChamber.inlet) annotation (
      Line(
      points={{12,-26},{18,-26}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink.gas_a, combustionChamber.flueGas_outlet)
    annotation (Line(
      points={{28,0},{28,-16}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slagSink.slag_inlet, combustionChamber.slag_outlet) annotation (Line(
      points={{28.2,-56},{28.2,-45.9},{28,-45.9},{28,-35.8}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics={  Text(
          extent={{-96,100},{48,62}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> Tester for simple combustion chamber component

______________________________________________________________________________________________
"),                    Text(
          extent={{-98,104},{18,86}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- 2015-01-27 //LN")}));
end Test_CombustionChamber;
