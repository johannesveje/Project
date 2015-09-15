within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2gas_L3_1ph_BU "Example 1 at page Ca 15 in VDI Waermeatlas, 9th edition "
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

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;

  BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource_T(
    m_flow_const=1,
    variable_m_flow=false,
    T_const=120 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={46,-4})));
  BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT(T_const=303.15, p_const=10e5) annotation (Placement(transformation(extent={{-62,-14},{-42,6}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink(xi_const={0.001,0.001,0.001,0.001,0.79,0.2,0.004,0.001}, p_const=1e5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={46,-84})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource(
    xi_const={0.001,0.001,0.001,0.001,0.79,0.2,0.004,0.001},
    variable_m_flow=false,
    variable_T=false,
    T_const(displayUnit="degC") = 293.15,
    m_flow_const=2*TILMedia.GasFunctions.density_pTxi(
        TILMedia.GasTypes.TILMedia_DryAir(),
        1e5,
        273.15 + 20)) annotation (Placement(transformation(extent={{-44,-94},{-24,-74}})));
  inner SimCenter simCenter(
    flueGasModel=TILMedia.GasTypes.FlueGas(),
    useHomotopy=false,
    redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater fluid1) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  HEXvle2gas_L3_1ph_BU gasAndCoolant_L3_1(
    length=1,
    height=1,
    width=1,
    m_nom1=2,
    h_nom1=24000,
    diameter_i=12e-3,
    diameter_o=16e-3,
    m_nom2=1,
    h_nom2=1200e3,
    xi_shell_start={0.001,0.001,0.001,0.001,0.79,0.2,0.004,0.001},
    N_passes=6,
    verticalTubes=false,
    T_w_i_start=353,
    T_w_a_start=333,
    showExpertSummary=true,
    mass_struc=100,
    N_tubes=120,
    CF_geo=2.65,
    tubes(heatSurfaceAlloc=1),
    p_nom1=100000,
    p_start_shell=1000000,
    redeclare model HeatTransferTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2,
    p_nom2=1000000,
    redeclare model HeatTransfer_Shell =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (                      alpha_nom=48.7, PL_alpha=[0,1; 1,1]),
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    initTypeShell=ClaRa.Basics.Choices.Init.noInit,
    initTypeTubes=ClaRa.Basics.Choices.Init.noInit,
    initWall=ClaRa.Basics.Choices.Init.steadyState,
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2)
                                                                                            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={10,-48})));

equation
  connect(gasAndCoolant_L3_1.In1, fluelGasFlowSource.gas_a) annotation (Line(
      points={{10,-57.8},{10,-84},{-24,-84}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(gasAndCoolant_L3_1.Out1, flueGasPressureSink.gas_a) annotation (Line(
      points={{10,-38},{10,-28},{36,-28},{36,-84}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(gasAndCoolant_L3_1.In2, massFlowSource_T.steam_a) annotation (Line(
      points={{20,-42},{28,-42},{28,-4},{36,-4}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_pT.steam_a, gasAndCoolant_L3_1.Out2) annotation (Line(
      points={{-42,-4},{-18,-4},{-18,-54},{20,-54}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics={                               Text(
          extent={{-100,90},{90,30}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="
_________________________________________________________________________________________________________          
PURPOSE:
Compare model with VDI Waermeatlas, Ca15 Example 1
_________________________________________________________________________________________________________  
NOTE: 
> The fin geometry is modeled by tuning a correction value for the geometry, namely CF_geo such that the simulation fits
   the product of area of heat transfer and heat transfer coeffictient (US).
_________________________________________________________________________________________________________  
LOOK AT:
> The outlet temperatures of gas and water flow.
> Outlet temperature of water according to literature: T_h2o_out = 78 °C
> Outlet temperature of air according to literature: T_air_out =94 °C.
> The simulation meets these data quite well.
_________________________________________________________________________________________________________    
")}),
    Icon(graphics),
    experiment(
      StopTime=1000,
      Tolerance=1e-006,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end Test_HEXvle2gas_L3_1ph_BU;
