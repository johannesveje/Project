within ClaRa.Visualisation;
model Scope "Dynamic graphical display of one variable"
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

  parameter Boolean showInterface=true "Select for input interface" annotation(Dialog(group="Input"));
  input Real inputVar=0 "Input variable (if showInterface=false)" annotation(Dialog(group="Input", enable=not showInterface));

  parameter Real y_min=0 "Choose or guess the minimal value of the y-axis" annotation(Dialog(group="Layout"));
  parameter Real y_max(min=y_min+Modelica.Constants.eps)=1 "Choose or guess the maximal value of the y-axis"
                                                      annotation(Dialog(group="Layout"));
  parameter String Unit="[-]" "Unit for plot variable" annotation(Dialog(group="Layout"));

protected
parameter Real y_start=(y_min+y_max)/2 "Initial display value";
public
  parameter Modelica.SIunits.Time Tau_stab=0.01 "Stabilizing time constant";
  parameter Modelica.SIunits.Time t_sample(min=Modelica.Constants.eps)=t_simulation/100 "Output intervall for plot, use carefully since causes events!"
                                                                    annotation(Dialog(group="Simulation Setup"));
  parameter Modelica.SIunits.Time t_simulation(min=Modelica.Constants.eps)=200 "Duration of simulation"
                             annotation(Dialog(group="Simulation Setup"));
  parameter ClaRa.Basics.Types.Color color={0,131,169} "Line color"         annotation (Hide=false, Dialog(group="Layout"));
protected
  Real x[scalarToVector.N];
  Real y[ size(x, 1)];
  Real f "Move factor for the cover-rectangle";
  final Real[size(x, 1), 2] points=transpose({x,y})  annotation(Hide=false);

  ClaRa.Visualisation.Fundamentals.ScalarToVector scalarToVector(simulationTime=t_simulation) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={50,50})));
  Modelica.Blocks.Interfaces.RealInput u(min=y_min, max=y_max) if showInterface "Input signal"
    annotation (Placement(transformation(extent={{-40,50},{0,90}}),
        iconTransformation(extent={{-42,78},{-30,90}})));

  parameter Modelica.SIunits.Time t_start(fixed=false);

  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    T=Tau_stab,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    annotation (Placement(transformation(extent={{8,46},{28,66}})));
initial equation

  t_start = time;

equation

  if not showInterface then
    firstOrder.u = inputVar;
  end if;

  x=linspace(1,100,(scalarToVector.N));
  for i in 1:size(y, 1) loop
  //for i in n:m loop
  y[i] = if scalarToVector.z[i] < y_min then     (1-(y_max -y_min)/(y_max - y_min))*100 else
          if  scalarToVector.z[i] > y_max then    (1-(y_max -y_max)/(y_max - y_min))*100 else
              (1-(y_max -scalarToVector.z[i])/(y_max - y_min))*100;
  end for;
  f=if time  <= t_start then 0 else if time  >= t_simulation+t_start then 100 else  (time-t_sample-t_start)*100/t_simulation;
  when y_max<=y_min then
  terminate("Parameter failure: y_max shall be larger then y_min.");
  end when;

// initial equation
//      y_start=firstOrder.u;

  connect(firstOrder.y, scalarToVector.u) annotation (Line(
      points={{29,56},{38,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.u, u) annotation (Line(
      points={{6,56},{-2,56},{-2,70},{-20,70}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-30,-10},
            {110,120}}),  graphics={
        Rectangle(
          extent={{-30,120},{110,-10}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
            extent={{2,94},{-18,100}},
            lineColor={27,36,42},
            textString="%maxY"),
        Text(
            extent={{-16,6},{2,0}},
            lineColor={27,36,42},
            textString="%minY"),
          Text(
            extent={{64,-2},{34,-10}},
            lineColor={27,36,42},
          textString="Time"),
        Text(
          extent={{-30,120},{110,110}},
          lineColor={27,36,42},
          textString="%Unit"),
                    Rectangle(
            extent={{0,100},{100,0}},
            lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid),
          Line(
            points=DynamicSelect({{0,0},{50,52},{70,40},{100,100}}, points),
            color=color,
            pattern=LinePattern.None, thickness=0.5),
          Rectangle(
            extent=DynamicSelect({{0,100},{100,0}}, {{f,100},{100,0}}),
            pattern=LinePattern.None,
            lineColor={27,36,42},
            fillColor=DynamicSelect({27,36,42}, {27,36,42}),
            fillPattern=FillPattern.Solid)}),
          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-30,-10},{110,120}},
        grid={2,2},
        initialScale=0.1),                 graphics));
end Scope;
