within ClaRa.Basics.ControlVolumes.SolidVolumes;
model ThinWall_L2 "A thin wall involving one volume element in heat flow direction"
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

  extends ClaRa.Basics.Icons.WallThin;
 replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
                                                                                            annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  input Real CF_lambda=1 "Time-dependent correction factor for thermal conductivity" annotation(Dialog(group="Fundamental Definitions"));
  import SI = Modelica.SIunits;

 parameter ClaRa.Basics.Units.Area A_heat "Surface area"
                                 annotation(Dialog(group="Geometry"));

parameter ClaRa.Basics.Units.Length thickness_wall "Wall thickness"
                                  annotation(Dialog(group="Geometry"));

//  parameter Boolean calculate_mass=true
//     "True, if mass is calculated with nominal material density"
//                                                               annotation (Dialog(group="Geometry"));
public
  parameter ClaRa.Basics.Units.Mass mass "Fixed Mass"     annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Temperature T_start=293.15 "Start values of wall temperature"  annotation(Dialog(group="Initialisation"));

  parameter Integer stateLocation = 2 "Location of states" annotation(Dialog(group="Numerical Efficiency"), choices(choice=1 "Inner location of states",
                                    choice=2 "Central location of states",  choice=3 "Outer location of states"));

  ClaRa.Basics.Units.Temperature T(start=T_start,nominal=500);
  ClaRa.Basics.Units.InternalEnergy U(nominal = 4e6);

  ClaRa.Basics.Interfaces.HeatPort_a
                                   outerPhase "outer side of the cylinder"
                                 annotation (Placement(transformation(extent={{-10,40},
            {10,60}}),      iconTransformation(extent={{-10,40},{10,60}})));
   TILMedia.Solid solid(redeclare each replaceable model SolidType = Material, T=T)
     annotation (Placement(transformation(extent={{48,8},{68,28}})));
  ClaRa.Basics.Interfaces.HeatPort_b innerPhase "Inner side of the cylinder"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}}),
        iconTransformation(extent={{-10,-60},{10,-40}})));
equation

  U=T*mass*solid.cp;
  der(U) = (innerPhase.Q_flow+outerPhase.Q_flow);

    //The following equation is true only for steady state or when changes in boundary conditions are slow compared to the state derivatives
  if stateLocation == 1 then //states are located at inner phase
    outerPhase.T = outerPhase.Q_flow/(solid.lambda*CF_lambda * A_heat) * thickness_wall + T;
    innerPhase.T = T;
  elseif stateLocation == 2 then //states are located in center phase
    innerPhase.Q_flow = solid.lambda*CF_lambda/(thickness_wall * 0.5) * A_heat * (innerPhase.T-T);
    outerPhase.Q_flow = solid.lambda*CF_lambda/(thickness_wall * 0.5) * A_heat * (outerPhase.T-T);
  else // states are located at outer phase
    outerPhase.T = T;
    innerPhase.T = innerPhase.Q_flow/(solid.lambda*CF_lambda * A_heat) * thickness_wall + T;
  end if;

initial equation
 T=T_start;

  annotation (Documentation(info="<html>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -50},{100,50}}),
                   graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-50},{100,50}}),
         graphics));
end ThinWall_L2;
