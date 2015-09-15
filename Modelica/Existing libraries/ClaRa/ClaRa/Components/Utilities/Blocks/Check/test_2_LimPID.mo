within ClaRa.Components.Utilities.Blocks.Check;
model test_2_LimPID
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  LimPID PID(
    y_min=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_ref=1e5,
    u_ref=10,
    y_max=0.2*1e6,
    sign=-1,
    k=0.001,
    Tau_i=100,
    Ni=0.001) annotation (Placement(transformation(extent={{-64,2},{-44,22}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pump(eta_hyd=1, eta_mech=1) annotation (Placement(transformation(extent={{-20,-48},{0,-28}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG(p_const=100000) annotation (Placement(transformation(extent={{-80,-48},{-60,-28}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG1(variable_p=true, p_const=1000000) annotation (Placement(transformation(extent={{34,-48},{14,-28}})));
  Modelica.Blocks.Sources.TimeTable
                               ramp2(
    offset=1.1e5,
    startTime=0,
    table=[0,0; 25,0; 26,2e5; 350,2e5; 380,0; 400,0])
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={86,-32})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.RealExpression actual_m_flow(y=pump.inlet.m_flow)
    annotation (Placement(transformation(extent={{-96,-24},{-76,-4}})));
  Modelica.Blocks.Sources.RealExpression setPoint_m_flow(y=1000)
    annotation (Placement(transformation(extent={{-96,14},{-76,34}})));
  Modelica.Blocks.Sources.BooleanExpression activate_controller(y=time > 5)
    annotation (Placement(transformation(extent={{-96,-8},{-76,12}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=1, initType=Modelica.Blocks.Types.Init.SteadyState)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={56,-34})));
equation
  connect(pressureSink_XRG.steam_a, pump.inlet)          annotation (Line(
      points={{-60,-38},{-20,-38}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump.outlet, pressureSink_XRG1.steam_a)   annotation (Line(
      points={{0,-38},{14,-38}},
      color={191,56,33},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID.y, pump.P_drive) annotation (Line(
      points={{-43.1,12},{-10,12},{-10,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.u, ramp2.y) annotation (Line(
      points={{68,-34},{72,-34},{72,-32},{75,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, pressureSink_XRG1.p) annotation (Line(
      points={{45,-34},{40,-34},{40,-32},{34,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(actual_m_flow.y, PID.u_s) annotation (Line(
      points={{-75,-14},{-66,-14},{-66,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setPoint_m_flow.y, PID.u_m) annotation (Line(
      points={{-75,24},{-70,24},{-70,-8},{-54,-8},{-54,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                            graphics={
                                  Text(
          extent={{-90,96},{108,56}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:

______________________________________________________________________________________________
"),                    Text(
          extent={{-130,100},{70,80}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- YYYY-MM-DD //XX"),Text(
          extent={{-90,56},{74,42}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
",        fontSize=8),Text(
          extent={{-90,70},{110,52}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  

______________________________________________________________________________________________
")}),                                  Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}})),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput);
end test_2_LimPID;
