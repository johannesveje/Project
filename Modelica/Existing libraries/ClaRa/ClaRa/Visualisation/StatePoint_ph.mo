within ClaRa.Visualisation;
model StatePoint_ph "Pressure and Enthalpy for ph-Diagram visualisation"
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

  outer SimCenter simCenter;

  ClaRa.Basics.Interfaces.FluidPortIn port(Medium=medium)
    annotation (Placement(transformation(extent={{-110,-114},{-90,-94}}),
        iconTransformation(extent={{-110,-110},{-90,-90}})));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                                                                                              annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Integer stateViewerIndex=0 "Index for StateViewer" annotation(Dialog(group="StateViewer Index"));
  Real p;
  Real h;
equation
  h=inStream(port.h_outflow);
  p=port.p;
  port.m_flow=0;
  port.h_outflow=0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}},
        initialScale=0.04),    graphics={
        Text(
          extent={{-90,80},{250,10}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          horizontalAlignment=TextAlignment.Left,
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("p", realString(p/1e5,1,integer(1)) + " bar")),
        Text(
          extent={{-90,-10},{250,-80}},
          lineColor=DynamicSelect({164,167,170},{0,131,169}),
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("h", realString(h/1e3,1,integer(1)) + " kJ/kg")),
        Line(
          points={{-100,100},{-100,-100}},
          color=DynamicSelect({164,167,170},{0,131,169}),
          smooth=Smooth.None,
          thickness=0.5)}),                                                                           Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}},
        initialScale=0.04),  graphics));
end StatePoint_ph;
