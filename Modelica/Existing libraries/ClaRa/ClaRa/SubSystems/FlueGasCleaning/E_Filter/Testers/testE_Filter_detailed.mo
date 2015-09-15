within ClaRa.SubSystems.FlueGasCleaning.E_Filter.Testers;
model testE_Filter_detailed 
//___________________________________________________________________________//
// Component of the ClaRa library, version: 0.1 alpha                        //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  ClaRa.Components.BoundaryConditions.GasFlowSource_T idealGasFlowSource_XRG(
    m_const=10,
    mInputIsActive=true,
    TInputIsActive=true,
    X_const={1/8.,1/8,1/8,1/8,1/8,1/8,1/8,1/8},
    medium=modelProperties.flueGasModel)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  ClaRa.Components.BoundaryConditions.GasSink_pT idealGasPressureSink_XRG(medium=
        modelProperties.flueGasModel, p_const=100000)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,0})));
  inner ModelProperties modelProperties(airModel=
        TILMedia.GasTypes.TILMedia_MoistAir())
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.Ramp massFlowRate(
    height=9,
    duration=1,
    offset=1,
    startTime=5e7)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,20})));
  Modelica.Blocks.Sources.Ramp Temperature(
    duration=1,
    startTime=1e7,
    height=50,
    offset=273.15 + 150)
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-12})));
  Modelica.Blocks.Sources.Ramp U_applied(
    duration=10,
    startTime=1,
    offset=0,
    height=25e3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-22,30})));
  E_Filter_detailed e_Filter_detailed(d_plate=0.2, d_particle=50e-6)
    annotation (Placement(transformation(extent={{-12,-10},{12,10}})));
equation
  connect(massFlowRate.y, idealGasFlowSource_XRG.m)
                                            annotation (Line(
      points={{-59,20},{-50,20},{-50,6},{-40,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temperature.y, idealGasFlowSource_XRG.T)
                                             annotation (Line(
      points={{-59,-12},{-50,-12},{-50,0},{-40,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealGasFlowSource_XRG.gas_a, e_Filter_detailed.flueGas_a)
    annotation (Line(
      points={{-20,0},{-10,0}},
      color={118,163,176},
      smooth=Smooth.None));
  connect(e_Filter_detailed.flueGas_b, idealGasPressureSink_XRG.gas_a)
    annotation (Line(
      points={{10,0},{15,0},{15,1.22465e-015},{20,1.22465e-015}},
      color={118,163,176},
      smooth=Smooth.None));
  connect(U_applied.y, e_Filter_detailed.U_applied) annotation (Line(
      points={{-11,30},{0,30},{0,11.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -50},{100,50}}),
                      graphics),
    experiment(StopTime=12),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-50},{100,50}})));
end testE_Filter_detailed;
