within ClaRa.SubSystems.FlueGasCleaning.deNOx.Testers;
model test_deNOx_ideal 
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

  inner ModelProperties modelProperties(airModel=
        TILMedia.GasTypes.TILMedia_MoistAir())
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  ClaRa.SubSystems.FlueGasCleaning.deNOx.deNOx_ideal deNOx(separationRate=1)
    annotation (Placement(transformation(extent={{-12,40},{12,60}})));
  ClaRa.Components.BoundaryConditions.GasFlowSource_T idealGasFlowSource_XRG1(
    m_const=10,
    mInputIsActive=true,
    TInputIsActive=true,
    X_const={1/8.,1/8,1/8,1/8,1/8,1/8,1/8,0},
    medium=modelProperties.flueGasModel)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  ClaRa.Components.BoundaryConditions.GasSink_pT idealGasPressureSink_XRG1(medium=
        modelProperties.flueGasModel, p_const=100000)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,50})));
  Modelica.Blocks.Sources.Ramp massFlowRate1(
    duration=1,
    startTime=5,
    height=9e-3,
    offset=1e-3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,70})));
  Modelica.Blocks.Sources.Ramp Temperature1(
    duration=1,
    height=100,
    offset=273.15 + 20,
    startTime=1)        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,38})));
equation
  connect(massFlowRate1.y, idealGasFlowSource_XRG1.m)
                                            annotation (Line(
      points={{-59,70},{-50,70},{-50,56},{-40,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temperature1.y, idealGasFlowSource_XRG1.T)
                                             annotation (Line(
      points={{-59,38},{-50,38},{-50,50},{-40,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deNOx.flueGas_a, idealGasFlowSource_XRG1.gas_a)        annotation (
      Line(
      points={{-10,57},{-15,57},{-15,50},{-20,50}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(idealGasPressureSink_XRG1.gas_a, deNOx.flueGas_b)        annotation (
      Line(
      points={{20,50},{15,50},{15,43},{10,43}},
      color={84,58,36},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end test_deNOx_ideal;
