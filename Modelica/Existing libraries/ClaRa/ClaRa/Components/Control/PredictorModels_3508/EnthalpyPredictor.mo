within ClaRa.Components.Control.PredictorModels_3508;
model EnthalpyPredictor "Prediction of evaporator outlet enthalpy using characteristic lines and transfer functions"
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

  extends Modelica.Blocks.Interfaces.SISO;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="01");

  parameter Real CL_hEvap_pD_[:,:] = [0.34, 2806e3; 0.55, 2708e3; 0.75, 2559e3; 1, 2200e3] "Characteristic line evap outlet enthalpy over pressure"
                                                             annotation(Dialog(group="Part Load Definition"));
  parameter Modelica.SIunits.Time Tau_evap=40 "Time constant for energy storage in evaporator"
                                                    annotation(Dialog(group="Time Response Definition"));
  Modelica.Blocks.Tables.CombiTable1D convert2enthalpy(columns={2}, table=
        CL_hEvap_pD_)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=Tau_evap)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T=Tau_evap)
    annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T=Tau_evap)
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T=Tau_evap)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(u, convert2enthalpy.u[1]) annotation (Line(
      points={{-120,0},{-82,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convert2enthalpy.y[1], firstOrder.u) annotation (Line(
      points={{-59,0},{-42,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, firstOrder1.u) annotation (Line(
      points={{-19,0},{-8,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder1.y, firstOrder2.u) annotation (Line(
      points={{15,0},{24,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder2.y, firstOrder3.u) annotation (Line(
      points={{47,0},{58,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder3.y, y) annotation (Line(
      points={{81,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(graphics={Text(
          extent={{-100,28},{100,-28}},
          lineColor={0,0,255},
          textString="h_evap")}), Diagram(graphics));
end EnthalpyPredictor;
