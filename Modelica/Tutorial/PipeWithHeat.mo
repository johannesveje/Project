within Tutorial;
model PipeWithHeat
  outer Modelica.Fluid.System system "System wide properties";
  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
      choicesAllMatching=true);
  Medium.BaseProperties medium(
    preferredMediumStates=true,
    h(start=h_start),
    p(start=p_start),
    X(start=X_start));
  parameter Dynamics massDynamics=system.massDynamics;
  parameter Dynamics energyDynamics=system.energyDynamics;
  parameter SI.Length length=100 "Pipe Length";
  parameter SI.Diameter diameter=0.1 "Pipe diameter";
  parameter SI.Volume volume=length*Constants.pi*
      Modelica.Fluid.Utilities.regSquare(diameter)/4;
  //   parameter Real k = 0.5 / 10;
  //   SI.PressureDifference dp;
  SI.Mass m;
  SI.InternalEnergy U;
  SI.MassFlowRate dm_dt=if massDynamics == Dynamics.SteadyState then 0 else der(
      m);
  SI.EnergyFlowRate dU_dt=if energyDynamics == Dynamics.SteadyState then 0
       else der(U);
  //Initialization
  parameter Medium.AbsolutePressure p_start=system.p_start
    "Start value of pressure at port a"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean use_T_start=true "Use T_start if true, otherwise h_start"
    annotation (Evaluate=true, Dialog(tab="Initialization"));
  parameter Medium.Temperature T_start=if use_T_start then system.T_start else
      Medium.temperature_phX(
      p_start,
      h_start,
      X_start) "Start value of temperature" annotation (Evaluate=true, Dialog(
        tab="Initialization", enable=use_T_start));
  parameter Medium.SpecificEnthalpy h_start=if use_T_start then
      Medium.specificEnthalpy_pTX(
      p_start,
      T_start,
      X_start) else Medium.h_default "Start value of specific enthalpy"
    annotation (Evaluate=true, Dialog(tab="Initialization", enable=not
          use_T_start));
  parameter Medium.MassFraction X_start[Medium.nX]=Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](quantity=Medium.extraPropertiesNames)
     = fill(0, Medium.nC) "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-92,-10},{-72,10}}),
        iconTransformation(extent={{-92,-10},{-72,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{72,-10},{92,10}}),
        iconTransformation(extent={{72,-10},{92,10}})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts_a annotation (Placement(
        transformation(extent={{-66,-8},{-46,12}}), iconTransformation(
        extent={{-21,-5},{21,5}},
        rotation=0,
        origin={-1,25})));
equation
  // Medium properties //
  medium.p = port_b.p;
  medium.h = port_b.h_outflow;
  medium.h = port_a.h_outflow;
  medium.Xi = port_a.Xi_outflow;
  medium.Xi = port_b.Xi_outflow;
  medium.T = heatPorts_a.T;
  // Equations //
  port_a.m_flow + port_b.m_flow = dm_dt;
  port_a.p - port_b.p = 0;
  //     port_a.m_flow*inStream(port_a.h_outflow) + port_b.m_flow*port_b.h_outflow = dU_dt;
  port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*actualStream(
    port_b.h_outflow) + heatPorts_a.Q_flow = dU_dt;
  // port_a.m_flow*port_a.h_outflow + port_b.m_flow*inStream(port_b.h_outflow) = dU_dt;
  port_a.m_flow*actualStream(port_a.Xi_outflow) = -port_b.m_flow*actualStream(
    port_b.Xi_outflow);
  //   dp = k * port_a.m_flow;
  m = volume*medium.d;
  U = m*medium.h - volume*medium.p;
initial equation
  if massDynamics == Dynamics.SteadyStateInitial then
    0 = der(m);
  end if;
  if energyDynamics == Dynamics.SteadyStateInitial then
    0 = der(U);
  end if;
  if massDynamics == Dynamics.FixedInitial then
    medium.p = p_start;
  end if;
  if energyDynamics == Dynamics.FixedInitial then
    if use_T_start then
      medium.T = T_start;
    else
      medium.h = h_start;
    end if;
  end if;
  annotation (preferredView="text", Icon(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-20,72},{20,-72}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255},
          origin={0,0},
          rotation=-90)}));
end PipeWithHeat;
