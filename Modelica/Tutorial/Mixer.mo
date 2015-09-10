within Tutorial;


model Mixer
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

  parameter SI.Volume volume=1 "Mixer volume";

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
        Medium) annotation (Placement(transformation(extent={{-90,30},{-70,50}}),
        iconTransformation(extent={{-90,30},{-70,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{74,30},{94,50}}),
        iconTransformation(extent={{74,30},{94,50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_c(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-82,-22},{-62,-2}}),
        iconTransformation(extent={{-82,-22},{-62,-2}})));
protected
  parameter Boolean allowFlowReversal=false;
equation
  // Medium properties //
  medium.p = port_b.p;
  medium.p = port_a.p;
  medium.p = port_c.p;
  medium.h = port_b.h_outflow;
  medium.h = port_a.h_outflow;
  medium.h = port_c.h_outflow;
  medium.Xi = port_a.Xi_outflow;
  medium.Xi = port_b.Xi_outflow;
  medium.Xi = port_c.Xi_outflow;

  // Equations //
  port_a.m_flow + port_b.m_flow + port_c.m_flow = 0;

  //     port_a.m_flow*inStream(port_a.h_outflow) + port_b.m_flow*port_b.h_outflow = dU_dt;
  port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*actualStream(
    port_b.h_outflow) + port_c.m_flow*actualStream(port_c.h_outflow) = 0;
  //  port_a.m_flow*port_a.h_outflow + port_b.m_flow*inStream(port_b.h_outflow) = dU_dt;
  port_a.m_flow*actualStream(port_a.Xi_outflow) = -port_b.m_flow*actualStream(
    port_b.Xi_outflow);

  m = volume*medium.d;
  U = m*medium.h - volume*medium.p;
initial equation
  if massDynamics == Dynamics.SteadyStateInitial then
    0 = der(medium.p);
  end if;
  if energyDynamics == Dynamics.SteadyStateInitial then
    0 = der(medium.h);
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
  annotation (
    preferredView="text",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-20,72},{20,-72}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255},
          origin={2,38},
          rotation=90),
        Polygon(
          points={{-72,4},{-56,-16},{-2,26},{-22,42},{-72,4}},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255},
          pattern=LinePattern.None),
        Line(
          points={{-50,-42},{50,-42},{52,-42}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{52,-42},{40,-26},{52,-42},{38,-58}},
          color={0,0,0},
          thickness=1)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end Mixer;
