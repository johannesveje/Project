within ClaRa.Basics.ControlVolumes.Fundamentals.Check;
model Test_SmoothedDeltaTmean_log
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

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

Real DT_wo = T_w - T_o.y;
Real DT_wi = T_w - (T_i.y+ramp.y);
Real T_w = 200;
Real T_i1=(T_i.y+ramp.y);

Real  DTU = max(DT_wi,DT_wo);
Real  DTL= min(DT_wi,DT_wo);

Real DT_mean;
  Modelica.Blocks.Sources.Trapezoid T_o(
    rising=1,
    falling=1,
    startTime=5,
    nperiod=1,
    offset=150,
    amplitude=+100,
    period=20,
    width=5)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Trapezoid
                               T_i(
    rising=1,
    startTime=5,
    falling=1,
    period=10,
    width=1,
    nperiod=1,
    offset=100,
    amplitude=0)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    startTime=7,
    height=200)
    annotation (Placement(transformation(extent={{-2,-18},{18,2}})));
equation

DT_mean=ClaRa.Basics.Functions.Stepsmoother(100,-100,DT_wi*DT_wo)* noEvent(if abs(DT_wo)<=1e-6 or abs(DT_wi)<=1e-6 then 0
        elseif
              (T_w<T_o.y and T_w>T_i1) or (T_w>T_o.y and T_w<T_i1) then 0 elseif abs(DT_wo-DT_wi)<=eps  then DT_wi
        else  (DTU-DTL)/log(DTU/DTL));
  annotation ();
end Test_SmoothedDeltaTmean_log;
