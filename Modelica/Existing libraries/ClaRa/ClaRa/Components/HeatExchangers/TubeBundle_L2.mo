within ClaRa.Components.HeatExchangers;
model TubeBundle_L2 "A flexible 0D tube bundle model"
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

  extends ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2(redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
      redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        diameter=diameter,
        length=length,
        N_tubes=N_tubes,
        z_in={z_in},
        z_out={z_out},
        N_passes=N_passes));
  extends ClaRa.Basics.Icons.HEX03;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut=if not heatFlowIsLoss then -heat.Q_flow else 0,
    powerAux=0) if                                                                                                     contributeToCycleSummary;
  outer ClaRa.simCenter   simCenter;

  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // parameter dialog~~~~~~~~~~~~~~~~~
  parameter Modelica.SIunits.Length length=1 "|Geometry|Length of the volume in flow direction";
  parameter Modelica.SIunits.Length diameter=0.1 "|Geometry|Diameter of the single tube";
  parameter Integer N_tubes=1 "|Geometry|Number of prallel tubes";
  parameter Integer N_passes=1 "|Geometry|Number of passes of the internal tubes";
  parameter ClaRa.Basics.Choices.GeometryOrientation orientation=ClaRa.Basics.Choices.GeometryOrientation.vertical "|Geometry|Orientation of the component";
  parameter Modelica.SIunits.Length z_in=length/2 "|Geometry|Inlet position from bottom"
                                           annotation (Dialog(enable=
          orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical));
  parameter Modelica.SIunits.Length z_out=length/2 "|Geometry|Outlet position from bottom"
                                            annotation (Dialog(enable=
          orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical));

  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation" annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss = true "True if heat flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));
  ClaRa.Basics.Interfaces.EyeOut eye if showData
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));

protected
  ClaRa.Basics.Interfaces.EyeIn eye_int
    annotation (Placement(transformation(extent={{45,-81},{47,-79}})));
equation
  eye_int.p = outlet.p/1e5;
  eye_int.h = fluidOut.h/1e3;
  eye_int.m_flow = -outlet.m_flow;
  eye_int.T = fluidOut.T - 273.15;
  eye_int.s = fluidOut.s/1e3;
  connect(eye, eye_int) annotation (Line(
      points={{100,-80},{46,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Placement(transformation(extent={{-8,-10},{12,10}})),
    Icon(graphics),
    Diagram(graphics));
end TubeBundle_L2;
