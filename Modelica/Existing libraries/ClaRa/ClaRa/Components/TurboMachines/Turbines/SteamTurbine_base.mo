within ClaRa.Components.TurboMachines.Turbines;
partial model SteamTurbine_base "Base class for steam turbines"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.0.0                            //
//                                                                           //
// Licensed by the DYNCAP research team under Modelica License 2.            //
// Copyright © 2013-2015, DYNCAP research team.                              //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  extends ClaRa.Basics.Icons.SimpleTurbine;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                                         annotation(choicesAllMatching=true, Dialog(group="Fundamental Definitions"));

  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium)
    annotation (Placement(transformation(extent={{-70,50},{-50,70}}),
        iconTransformation(extent={{-70,50},{-50,70}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium)
    annotation (Placement(transformation(extent={{30,-110},{50,-90}}),
        iconTransformation(extent={{30,-110},{50,-90}})));

  outer SimCenter simCenter;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-60,-100},
            {40,100}}),
                   graphics),    Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-100},{40,100}}), graphics));

end SteamTurbine_base;
