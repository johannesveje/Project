within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Icons;
model HEX_CrossCounterFlow_Icon
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

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-102}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{100,-102}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),        Polygon(
          points={{-100,-52},{40,-52},{40,-72},{100,-42},{40,-12},{40,-32},{-80,
              -32},{-80,28},{80,28},{80,108},{-100,108},{-100,88},{60,88},{60,
              48},{-100,48},{-100,-52}},
          smooth=Smooth.None,
          fillColor={153,205,221},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={0,-28},
          rotation=0,
          lineColor={0,0,0}),                   Polygon(
          points={{-100,20},{40,20},{40,40},{100,0},{40,-40},{40,-20},{-100,-20},
              {-100,20}},
          smooth=Smooth.None,
          fillColor={51,156,186},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-20,0},
          rotation=90)}));
end HEX_CrossCounterFlow_Icon;
