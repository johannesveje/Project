within ClaRa.Components.Sensors;
model GasComponentSensor "Ideal one port gas component sensor"
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

extends ClaRa.Components.Sensors.GasSensorBase;
  outer ClaRa.SimCenter simCenter;

  Modelica.Blocks.Interfaces.RealOutput fraction "fraction (volume or mass) in port"
    annotation (Placement(transformation(extent={{44,60},{64,80}},  rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));

parameter Integer compositionDefinedBy "output gives mass or volume fraction"  annotation(choices(choice = 1 "mass", choice = 2 "volume"));
    parameter Integer component "component" annotation(choices(choice = 1 "Ash", choice = 2 "CO", choice = 3 "CO2", choice = 4 "SO2", choice = 5 "N2", choice = 6 "O2", choice = 7 "NO", choice = 8 "H2O", choice = 9 "NH3", choice = 10 "Argon"));

Real inFraction "fraction of component";
 Integer N;
  TILMedia.Gas_pT gas(p = inlet.p, T = actualStream(inlet.T_outflow), xi = actualStream(inlet.xi_outflow), gasType= simCenter.flueGasModel)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  N = 10;
  if component == N then
        if compositionDefinedBy == 1 then
          inFraction =  1.0 - sum(gas.xi);
        else
          inFraction =  1.0 - sum(gas.x);
        end if;
  elseif
    component > N then
    inFraction =  1.0;
    assert(false, "Wrong component chosen");
  elseif component == 0 then
    inFraction = 1.0;
    assert(false, "Wrong Component chosen");
  else
    if compositionDefinedBy == 1 then
      inFraction =  gas.xi[component];
    else
      inFraction =  gas.x[component];
    end if;
  end if;

fraction = inFraction;
  annotation (Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-100,60},{100,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if p > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" xi ", realString(inFraction, 1,1))),
        Polygon(
          points={{-20,40},{-20,40},{-62,40},{-86,0},{-62,-40},{-20,-40},{20,-40},{62,-40},{86,0},{62,40},{20,40},{-20,40}},
          lineColor={27,36,42},
          smooth=Smooth.Bezier,
          lineThickness=0.5),
        Text(
          extent={{-100,40},{100,0}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="QIT"),
        Line(
          points={{80,0},{100,0}},
          color={27,36,42},
          smooth=Smooth.None),
        Text(
          extent={{-100,0},{100,-40}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{0,-40},{0,-100}},
          color={27,36,42},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-98,-100},{96,-100}},
          color={118,106,98},
          smooth=Smooth.None,
          thickness=0.5)}));
end GasComponentSensor;
