within ClaRa.Basics.ControlVolumes.SolidVolumes;
model ThinWall_L4 "A thin cylindric wall with axial discretisation"
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

  extends ClaRa.Basics.Icons.WallThinLarge;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
 replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
                                                                                            annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  input Real CF_lambda=1 "Time-dependent correction factor for thermal conductivity" annotation(Dialog(group="Fundamental Definitions"));

  import SI = ClaRa.Basics.Units;
public
  parameter Integer N_ax = 3 "Number of axial elements" annotation(Dialog(group="Discretisation"));
  parameter Modelica.SIunits.Length Delta_x[N_ax]=ClaRa.Basics.Functions.GenerateGrid(        {0}, length, N_ax) "Discretisation scheme"
                             annotation(Dialog(group="Discretisation"));
  parameter Units.Length
                      diameter_o "Outer diameter" annotation(Dialog(group="Geometry"));
  parameter Units.Length
                      diameter_i "Inner diameter" annotation(Dialog(group="Geometry"));
  parameter Units.Length
                      length "Length of cylinder" annotation(Dialog(group="Geometry"));
  parameter Integer N_tubes= 1 "Number of tubes in parallel" annotation(Dialog(group="Geometry"));
  parameter Units.Temperature
                           T_start[N_ax]=ones(N_ax)*293.15 "Start values of wall temperature"
                                                                                    annotation(Dialog(group="Initialisation"));
  parameter ClaRa.Basics.Choices.Init initChoice=ClaRa.Basics.Choices.Init.noInit "Initialisation option"
                               annotation(Dialog(group="Initialisation"));
 parameter Integer stateLocation = 2 "Location of states" annotation(Dialog(group="Numerical Efficiency"), choices(choice=1 "Inner location of states",
                                    choice=2 "Central location of states",  choice=3 "Outer location of states"));
 parameter String suppressChattering="True" "Enable to suppress possible chattering"
     annotation (Dialog(group=
           "Numerical Efficiency"),
       choices(choice="False" "False (faster if no chattering occurs)",
       choice="True" "True (faster if chattering occurs)"));
 final parameter Units.Mass mass_nominal=sum(solid.d .* (Modelica.Constants.pi/4*(diameter_o^2-diameter_i^2)*Delta_x*N_tubes));
protected
  final parameter Units.HeatFlowRate
                                  Q_flow_nom=1;
  constant Real Q_flow_eps=1e-9;

public
  Units.Temperature
                 T[N_ax](start=T_start, each nominal=500);
 Units.Mass mass;
protected
  Units.HeatFlowRate
                  Delta_Q_flow[N_ax](each  nominal= 1e5);
  Units.InternalEnergy
                    U[N_ax](each nominal = 4e6);

public
  ClaRa.Basics.Interfaces.HeatPort_a
                                   outerPhase[N_ax] "outer side of the cylinder"
                                 annotation (Placement(transformation(extent={{-10,40},
            {10,60}}),      iconTransformation(extent={{-10,40},{10,60}})));
   TILMedia.Solid solid[N_ax](T=T, redeclare each replaceable model SolidType = Material)
     annotation (Placement(transformation(extent={{48,8},{68,28}})));
  ClaRa.Basics.Interfaces.HeatPort_b innerPhase[N_ax] "Inner sider of the cylinder"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}}),
        iconTransformation(extent={{-10,-60},{10,-40}})));
equation
  assert(diameter_o> diameter_i, "The outer diameter has to be greater then the inner diameter!");
mass = sum(solid.d .* (Modelica.Constants.pi/4*(diameter_o^2-diameter_i^2)*Delta_x*N_tubes));
  for i in 1:N_ax loop
    U[i]=T[i]*solid[i].d*(Modelica.Constants.pi/4*(diameter_o^2-diameter_i^2)*Delta_x[i]*N_tubes)*solid[i].cp;
    if suppressChattering == "True" then
    der(U[i]) = Delta_Q_flow[i]*Q_flow_nom;
    Delta_Q_flow[i]=noEvent(if abs(innerPhase[i].Q_flow+outerPhase[i].Q_flow) > Q_flow_eps then (innerPhase[i].Q_flow+outerPhase[i].Q_flow) else 0)/Q_flow_nom;
    else
    der(U[i]) = Delta_Q_flow[i];
    Delta_Q_flow[i]=innerPhase[i].Q_flow+outerPhase[i].Q_flow;
    end if;

  //The following equation is true only for steady state or when changes in boundary conditions are slow compared to the state derivatives
  if stateLocation==1 then //states are located at inner phase
    outerPhase[i].T=outerPhase[i].Q_flow.*log(diameter_o/diameter_i)/(2*Delta_x[i]*N_tubes*solid[i].lambda*CF_lambda*Modelica.Constants.pi)+T[i];
    innerPhase[i].T=T[i];
  elseif stateLocation==2 then //states are located in center phase
    innerPhase[i].Q_flow = solid[i].lambda*CF_lambda  * (2*Modelica.Constants.pi *Delta_x[i]*N_tubes)/log((diameter_o+diameter_i)/(2*diameter_i))* (innerPhase[i].T-T[i]);
    outerPhase[i].Q_flow = solid[i].lambda*CF_lambda  * (2*Modelica.Constants.pi *Delta_x[i]*N_tubes)/log((2*diameter_o)/(diameter_o+diameter_i))* (outerPhase[i].T-T[i]);
  else // states are located at outer phase
    outerPhase[i].T=T[i];
    innerPhase[i].T=innerPhase[i].Q_flow.*log(diameter_o/diameter_i)/(2*Delta_x[i]*N_tubes*solid[i].lambda*CF_lambda*Modelica.Constants.pi)+T[i];
  end if;

  end for;

initial equation
  if initChoice == ClaRa.Basics.Choices.Init.steadyTemperature then
    der(T)=zeros(N_ax);
  elseif
    initChoice == ClaRa.Basics.Choices.Init.noInit then
    T=T_start;
  end if;

  annotation (Documentation(info="<html>
<p><h4>This hollow cylinder uses a combination of arithmetic and logarithmic averaging for the definition of the heat transfer surfaces</h4></p>
<p>This refined averaging leads to better grrement with the analytical solution, especially when considering thick-walled components and a small number of nodes</p>
</html>", revisions="<html>
<p><ul>
<li><b>v0.1 </b>2011-07-14: Initial implementation. Friedrich Gottelt, Johannes Brunnemann, XRG Simulation GmbH</li>
</ul></p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-140,
            -50},{140,50}}),
                   graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-140,-50},{140,50}}),
         graphics));
end ThinWall_L4;
