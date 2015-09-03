within Tutorial;
model Pump
  outer Modelica.Fluid.System system "System wide properties";

  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                                             annotation (choicesAllMatching=true);

   Modelica.SIunits.Density rho;
  parameter Modelica.SIunits.Height z = 0;

  parameter Boolean fixed_diameter = true "Same inlet and outlet diameter"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Modelica.SIunits.Efficiency eta_pump = 1 "Pump efficiency";
  parameter Modelica.SIunits.Diameter diameter_a = 0.1 "Inlet diameter";
  parameter Modelica.SIunits.Diameter diameter_b = diameter_a "Outlet diameter"
  annotation(Dialog(enable = not fixed_diameter));

   Modelica.SIunits.Length head;
   Modelica.SIunits.Velocity velocity_a, velocity_b;
  parameter Modelica.SIunits.Area area_a = Modelica.Constants.pi*diameter_a*diameter_a/4;
  parameter Modelica.SIunits.Area area_b = Modelica.Constants.pi*diameter_b*diameter_b/4;
   Modelica.SIunits.AngularVelocity omega;
   Modelica.SIunits.Torque tau;

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium) annotation (Placement(
        transformation(extent={{-60,-10},{-40,10}}), iconTransformation(extent={
            {-60,-10},{-40,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium) annotation (Placement(
        transformation(extent={{40,-12},{60,8}}), iconTransformation(extent={{40,
            -12},{60,8}})));
//    Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation (
//        Placement(transformation(extent={{-10,48},{10,68}}), iconTransformation(
//            extent={{-10,48},{10,68}})));
  parameter SI.Power power = 3000;
protected
  final parameter Boolean allowFlowReversal = false;
  final parameter Real g = system.g;

equation
//   omega = der(shaft.phi);
   tau*omega*eta_pump = port_a.m_flow*head*g;
   port_a.m_flow + port_b.m_flow = 0;
   port_a.m_flow*inStream(port_a.h_outflow) + port_b.m_flow*port_b.h_outflow = 0;
    port_a.m_flow*port_a.h_outflow + port_b.m_flow*inStream(port_b.h_outflow) = 0;
   head = (port_b.p-port_a.p)/(rho*g) + (velocity_b*velocity_b - velocity_a*velocity_a)/(2*g) + z;
   rho = Medium.density_ph(port_a.p,port_a.h_outflow);
   power = tau*omega;
   // head = head_nominel*((n/n
   velocity_a = port_a.m_flow/(area_a*rho);
   velocity_b = port_b.m_flow/(area_b*rho);

   annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{-14,20},{-14,-20},{26,0},{-14,20}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,60},{10,38}},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}));
end Pump;
