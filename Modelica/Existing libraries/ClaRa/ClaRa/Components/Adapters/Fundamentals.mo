within ClaRa.Components.Adapters;
package Fundamentals
  connector FlangeA "A-type flange connector for water/steam flows"

  //_____________________________________________________________________________________
  //  This connector definition was taken from Francesco Casella's library ThermoPower
  //  http://sourceforge.net/projects/thermopower/
  //_____________________________________________________________________________________

    replaceable package Medium = Modelica.Media.Water.WaterIF97_ph constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
    Medium.AbsolutePressure p "Pressure";
    flow Medium.MassFlowRate w "Mass flowrate";
    output Medium.SpecificEnthalpy hAB "Specific enthalpy of fluid going out";
    input Medium.SpecificEnthalpy hBA "Specific enthalpy of entering fluid";
    annotation (Documentation(info="<HTML>
<p> Must always be connected to a single type-B connector <tt>FlangeB</tt>.
</HTML>",
        revisions="<html>
<ul>
<li><i>16 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Medium model added.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
</html>"),   Icon(graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}));
  end FlangeA;
  extends ClaRa.Basics.Icons.PackageIcons.Components50;
  connector FlangeB "B-type flange connector for water/steam flows"

  //_____________________________________________________________________________________
  //  This definition was taken from Francesco Casella's library ThermoPower
  //  http://sourceforge.net/projects/thermopower/
  //_____________________________________________________________________________________

    replaceable package Medium = Modelica.Media.Water.WaterIF97_ph constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
    Medium.AbsolutePressure p "Pressure";
    flow Medium.MassFlowRate w "Mass flowrate";
    input Medium.SpecificEnthalpy hAB "Specific enthalpy of fluid going out";
    output Medium.SpecificEnthalpy hBA "Specific enthalpy of entering fluid";
    annotation (Documentation(info="<HTML>
<p> Must always be connected to a single type-B connector <tt>FlangeB</tt>.
</HTML>",
        revisions="<html>
<ul>
<li><i>16 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Medium model added.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
</html>"),   Icon(graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid), Ellipse(
            extent={{-60,60},{60,-60}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end FlangeB;

  model SourceP "Pressure source for water/steam flows"

  //_____________________________________________________________________________________
  //  This definition was taken from Francesco Casella's library ThermoPower
  //  http://sourceforge.net/projects/thermopower/
  //_____________________________________________________________________________________

    import Modelica.SIunits.*;

    type HydraulicResistance = Real (final quantity="HydraulicResistance", final unit=
               "Pa/(kg/s)");
    replaceable package Medium = Modelica.Media.Water.WaterIF97_ph constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";

    parameter Pressure p0=1.01325e5 "Nominal pressure";
    parameter HydraulicResistance R=0 "Hydraulic resistance";
    parameter SpecificEnthalpy h=1e5 "Nominal specific enthalpy";
    Pressure p "Actual pressure";
    FlangeB flange(redeclare package Medium=Medium)
                   annotation (extent=[80, -20; 120, 20]);
    Modelica.Blocks.Interfaces.RealInput in_p0
      annotation (extent=[-60, 72; -20, 112], rotation=-90);
    Modelica.Blocks.Interfaces.RealInput in_h
      annotation (extent=[20, 70; 60, 110], rotation=-90);
  equation
    if R == 0 then
      flange.p = p;
    else
      flange.p = p + flange.w*R;
    end if;

    p = in_p0;
    if cardinality(in_p0)==0 then
      in_p0 = p0 "Pressure set by parameter";
    end if;

    flange.hBA =in_h;
    if cardinality(in_h)==0 then
      in_h = h "Enthalpy set by parameter";
    end if;
    annotation (
      Diagram,
      Icon(Text(extent=[-106, 90; -52, 50], string="p0"), Text(extent=[66, 90;
               98, 52], string="h"),
        graphics={Ellipse(
            extent={{-80,80},{80,-80}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{20,34},{-28,-26}},
            lineColor={255,255,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textString="P")}),
      Documentation(info="<HTML>
<p><b>Modelling options</b></p>
<p>If <tt>R</tt> is set to zero, the pressure source is ideal; otherwise, the outlet pressure decreases proportionally to the outgoing flowrate.</p>
<p>If the <tt>in_p0</tt> connector is wired, then the source pressure is given by the corresponding signal, otherwise it is fixed to <tt>p0</tt>.</p>
<p>If the <tt>in_h</tt> connector is wired, then the source pressure is given by the corresponding signal, otherwise it is fixed to <tt>h</tt>.</p>
</HTML>",
        revisions="<html>
<ul>
<li><i>16 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Medium model and standard medium definition added.</li>
<li><i>18 Jun 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Removed <tt>p0_fix</tt> and <tt>hfix</tt>; the connection of external signals is now detected automatically.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
  end SourceP;

  model SinkP "Pressure source for water/steam flows"

  //_____________________________________________________________________________________
  //  This definition was taken from Francesco Casella's library ThermoPower
  //  http://sourceforge.net/projects/thermopower/
  //_____________________________________________________________________________________
    import Modelica.SIunits.*;

    type HydraulicResistance = Real (final quantity="HydraulicResistance", final unit=
               "Pa/(kg/s)");
    replaceable package Medium = Modelica.Media.Water.WaterIF97_ph constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";

    parameter Pressure p0=1.01325e5 "Nominal pressure";
    parameter HydraulicResistance R=0 "Hydraulic resistance" annotation(Evaluate=true);
    parameter SpecificEnthalpy h=1e5 "Nominal specific enthalpy";
    Pressure p;
    FlangeA flange(redeclare package Medium=Medium)
                   annotation (extent=[-120, -20; -80, 20]);
    Modelica.Blocks.Interfaces.RealInput in_p0
      annotation (extent=[-60, 68; -20, 108], rotation=-90);
    Modelica.Blocks.Interfaces.RealInput in_h
      annotation (extent=[20, 68; 60, 108], rotation=-90);
  equation
    if R == 0 then
      flange.p = p;
    else
      flange.p = p + flange.w*R;
    end if;

    p = in_p0;
    if cardinality(in_p0)==0 then
      in_p0 = p0 "Pressure set by parameter";
    end if;

    flange.hAB =in_h;
    if cardinality(in_h)==0 then
      in_h = h "Enthalpy set by parameter";
    end if;

    annotation (
      Diagram,
      Icon(Text(extent=[-106, 90; -52, 50], string="p0"), Text(extent=[66, 90;
               98, 52], string="h"),
        graphics={Ellipse(
            extent={{-80,80},{80,-80}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{20,34},{-28,-26}},
            lineColor={255,255,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textString="P")}),
      Documentation(info="<HTML>
<p><b>Modelling options</b></p>
<p>If <tt>R</tt> is set to zero, the pressure source is ideal; otherwise, the outlet pressure decreases proportionally to the outgoing flowrate.</p>
<p>If the <tt>in_p0</tt> connector is wired, then the source pressure is given by the corresponding signal, otherwise it is fixed to <tt>p0</tt>.</p>
<p>If the <tt>in_h</tt> connector is wired, then the source pressure is given by the corresponding signal, otherwise it is fixed to <tt>h</tt>.</p>
</HTML>",
        revisions="<html>
<ul>
<li><i>16 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Medium model and standard medium definition added.</li>
<li><i>18 Jun 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Removed <tt>p0_fix</tt> and <tt>hfix</tt>; the connection of external signals is now detected automatically.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
  end SinkP;

  model SensT "ThermoPower's temperature sensor"

  //_____________________________________________________________________________________
  //  This definition was taken from Francesco Casella's library ThermoPower
  //  http://sourceforge.net/projects/thermopower/
  //_____________________________________________________________________________________

    replaceable package Medium = Modelica.Media.Water.WaterIF97_ph constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
    Medium.BaseProperties fluid;
    FlangeA inlet(redeclare package Medium = Medium)
                                    annotation (extent=[-80, -60; -40, -20]);
    FlangeB outlet(redeclare package Medium = Medium)
                                     annotation (extent=[40, -60; 80, -20]);
    Modelica.Blocks.Interfaces.RealOutput T
      annotation (extent=[60, 40; 100, 80]);
  equation
    inlet.w + outlet.w = 0 "Mass balance";
    inlet.p = outlet.p "No pressure drop";
    // Set fluid properties
    fluid.p=inlet.p;
    fluid.h = if inlet.w >= 0 then inlet.hBA else inlet.hAB;
    T = fluid.T;

    // Boundary conditions
    inlet.hAB = outlet.hAB;
    inlet.hBA = outlet.hBA;

    annotation (
      Diagram,
      Icon(Text(
          extent=[-40, 84; 38, 34],
          style(color=0, fillPattern=1),
          string="T"), graphics={
          Rectangle(
            extent={{-40,-20},{40,-60}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{-40,100},{40,20}}, lineColor={0,0,0}),
          Line(
            points={{0,20},{0,-20}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{60,60},{40,60}},
            color={0,0,0},
            smooth=Smooth.None),
          Text(
            extent={{-40,86},{40,32}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="T")}),
      Documentation(info="<HTML>
<p>This component can be inserted in a hydraulic circuit to measure the temperature of the fluid flowing through it.
<p>Flow reversal is supported.
</HTML>",
        revisions="<html>
<ul>
<li><i>16 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Standard medium definition added.</li>
<li><i>1 Jul 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Adapted to Modelica.Media.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
  end SensT;

end Fundamentals;
