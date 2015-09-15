within ClaRa.Components.Furnace.BaseClasses;
partial model CombustionChamberBase
  import ClaRa;

    //## S U M M A R Y   D E F I N I T I O N ###################################################################
  record Outline
    //  parameter Boolean showExpertSummary annotation(Dialog(hide));
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Volume volume "Volume";
    input ClaRa.Basics.Units.Area A_cross "Free cross sectional area";
    input ClaRa.Basics.Units.Area A_wall "Wall area";
    input ClaRa.Basics.Units.Length height "Height of volume";
    input ClaRa.Basics.Units.Mass m "Mass inside volume";
    input ClaRa.Basics.Units.MassFlowRate m_flow_coal_burned "Burned coal mass flow rate";
    input ClaRa.Basics.Units.MassFlowRate m_flow_oxygen_burned "Burned oxygen mass flow rate";
    input ClaRa.Basics.Units.MassFlowRate m_flow_oxygen_req "Required O2 flow rate for stochiometric combustion";
    input ClaRa.Basics.Units.MassFlowRate m_flow_air_req "Required air flow rate for stochiometric combustion";
    input Real lambdaComb "Excess air";
    input Real NOx_fraction "NOx fraction at outlet";
    input Real CO_fraction "CO fraction at outlet";
    input ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Lower heating value";
    input ClaRa.Basics.Units.HeatFlowRate Q_combustion "Combustion Heat";
    input ClaRa.Basics.Units.Velocity w_migration "Particle migration speed";
    input ClaRa.Basics.Units.Time t_dwell_flueGas "Flue gas dwelltime";
    input ClaRa.Basics.Units.Time burning_time "Burning time";
    input Real coal_diffusity "Coal diffusity";
    input ClaRa.Basics.Units.Temperature T_out "Outlet temperature";
    input ClaRa.Basics.Units.EnthalpyMassSpecific h_out "Flue gas enthalpy at outlet";
  end Outline;

  record Coal
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate"
      annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
    input ClaRa.Basics.Units.HeatCapacityMassSpecific cp "Specific heat capacity"
                               annotation (Dialog);
  end Coal;

  record Slag
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate"
      annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
  end Slag;

  record Flow
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.FlangeGas flueGas;
    Coal coal;
    Slag slag;
  end Flow;

  record Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    Flow inlet;
    Flow outlet;
  end Summary;

//## P A R A M E T E R S #######################################################################################
   //__________________________/ Media definintions \______________________________________________
  outer ClaRa.SimCenter simCenter;
   parameter ClaRa.Basics.Media.Fuel.PartialFuel coalType=simCenter.fuelModel1 "Coal elemental composition used for combustion"
                                                     annotation(choices(choice=simCenter.coalModel "Coal model 1 as defined in simCenter"),
                                                       Dialog(group="Media Definitions"));
  parameter ClaRa.Basics.Media.Fuel.PartialSlag slagType=simCenter.slagModel "Slag properties"
                      annotation(choices(choice=simCenter.slagModel "Slag model 1 as defined in simCenter"),
                                                  Dialog(group="Media Definitions"));
  inner parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component"
                                        annotation(choicesAllMatching, Dialog(group="Media Definitions"));

  //__________________/ Parameter \_______________________________________________
  inner parameter ClaRa.Basics.Units.Temperature T_slag=900      annotation (Dialog(group="Slag parameters"));
  inner parameter Modelica.SIunits.MassFlowRate m_flow_nom= 10 "Nominal mass flow rates at inlet"
                                        annotation(Dialog(group="Nominal Values"));

  //_______________________/ Start values \_____________________________________________________________
   parameter ClaRa.Basics.Units.Pressure p_start_flueGas_out=1e5
                                                               annotation(Dialog(tab="Start and initialisation values"));
  parameter ClaRa.Basics.Units.Temperature T_start_flueGas_out=700
                                                                 annotation(Dialog(tab="Start and initialisation values"));
  parameter ClaRa.Basics.Units.MassFraction xi_start_flueGas_out[flueGas.nc - 1]=
     {0.01,0,0.1,0,0.74,0.13,0,0.02,0}                                                                         annotation(Dialog(tab="Start and initialisation values"));
//   parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_flueGas_in_start=1
//                                                                       annotation(Dialog(tab="Start and initialisation values"));
  parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_flueGas_out_start=-15
                                                                         annotation(Dialog(tab="Start and initialisation values"));

  parameter String LHV_calculationType="fixed" "Calculation type" annotation (
      Dialog(group="LHV calculation"), choices(
      choice="fixed" "Use fixed value for the LHV",
      choice="Verbandsformel" "Calculate the LHV from the Verbandsformel",
      choice="Standard formation enthalpy" "Calculate the LHV from the standard formation enthalpy"));

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific LHV_fixed=30e6 "LHV value for the coal"
                             annotation (Dialog(enable=(LHV_calculationType ==
          "fixed"), group="LHV calculation"));

  constant Real T_0=298.15;

//## V A R I A B L E   P A R T##################################################################################

protected
  inner ClaRa.Basics.Units.MassFraction xi_coal; // amount of coal per flue gas mass
  inner ClaRa.Basics.Units.Time Tau; //time constant for heat transfer temperature delay
  parameter Modelica.SIunits.SpecificEnthalpy h_start = TILMedia.GasFunctions.specificEnthalpy_pTxi(flueGas, p_start_flueGas_out, T_start_flueGas_out, xi_start_flueGas_out) annotation(Dialog(tab="Start Values"));

//________________/ FlueGas Composition \_____________________
public
 inner ClaRa.Basics.Units.MassFraction xi_flueGas[flueGas.nc - 1];
//________________/ Coal Composition \_____________________
  ClaRa.Basics.Units.MassFraction xi_coal_out[coalType.nc - 1];

//_____________/ Calculated quantities \_________________________________
  inner ClaRa.Basics.Units.Area A_cross=geo.A_front;
  inner ClaRa.Basics.Units.VolumeFlowRate V_flow_flueGas_in;
                                                        //(start=V_flow_flueGas_in_start);
  inner ClaRa.Basics.Units.VolumeFlowRate V_flow_flueGas_out;
                                                         //(start=V_flow_flueGas_out_start);//(start = -20);
  Modelica.SIunits.Mass mass;
  ClaRa.Basics.Units.HeatFlowRate Q_flow_top;
  ClaRa.Basics.Units.HeatFlowRate Q_flow_bottom;
  ClaRa.Basics.Units.HeatFlowRate Q_flow_wall;

  inner ClaRa.Basics.Units.MassFraction xi_coal_in[coalType.nc - 1];
  ClaRa.Basics.Units.EnthalpyMassSpecific h_flueGas_out;
  ClaRa.Basics.Units.EnthalpyMassSpecific h_flueGas_out_del;

  ClaRa.Basics.Units.MassFraction xi_flueGas_del[flueGas.nc - 1];

//___________________/ Molar flow rates of educts and products \_____________
//_________/Educts\__________________
protected
  Modelica.SIunits.MolarFlowRate n_flow_C;
  Modelica.SIunits.MolarFlowRate n_flow_H;
  Modelica.SIunits.MolarFlowRate n_flow_O;
  Modelica.SIunits.MolarFlowRate n_flow_N;
  Modelica.SIunits.MolarFlowRate n_flow_S;
  Modelica.SIunits.MolarFlowRate n_flow_Ash;
  Modelica.SIunits.MolarFlowRate n_flow_H2O;

  ClaRa.Basics.Units.MassFraction xi_flueGas_id[flueGas.nc - 1];
  Real sum_xi;
  Real sum_comp;
  Real m_flow_coal_id;
  Real m_flow_flueGas_id;
  //flue gas produced at ideal combustion
  Real Delta_h_f;

public
  ClaRa.Basics.Units.EnthalpyMassSpecific LHV;

  ClaRa.Basics.Units.Time t_dwell_flueGas=geo.height/particleMigration.w;
  // flow direction in z-direction
  Real coal_diffusity "Quantatity describes how much unburned coal leaves control volume together with the fluegas to neighbor cell";
  ClaRa.Basics.Units.MassFlowRate m_flow_oxygen_req(min=1e-15) "Required O2 flow rate for stochiometric combustion";
  ClaRa.Basics.Units.MassFlowRate m_flow_air_req "Required combustion air flow rate for stochiometric combustion determined in dependence of m_flow_oxygen_req and actual Xi of gasInlet";

  ClaRa.Basics.Units.MassFlowRate m_flow_coal_burned;
  ClaRa.Basics.Units.MassFlowRate m_flow_oxygen_burned;

  Real lambdaComb;//excess air

    //________________________/ Connectors \_______________________________________________________
  ClaRa.Basics.Interfaces.CoalSlagFlueGas_inlet inlet(
    flueGas(final Medium=flueGas),
    final coalType=coalType,
    final slagType=slagType)
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,-100})));
  ClaRa.Basics.Interfaces.CoalSlagFlueGas_outlet outlet(
    flueGas(final Medium=flueGas, m_flow(start=-1)),
    final coalType=coalType,
    final slagType=slagType)                                                                        annotation (Placement(transformation(extent={{-130,90},
            {-110,110}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,100})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat_wall
    annotation (Placement(transformation(extent={{290,-10},{310,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat_top
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat_bottom
     annotation (Placement(transformation(extent={{10,-90},{30,-110}})));

   //_____________________/ Media Objects \_________________________________
protected
    TILMedia.Gas_pT     flueGasInlet(p=inlet.flueGas.p, T= inStream(inlet.flueGas.T_outflow), xi=inStream(inlet.flueGas.xi_outflow),
      gasType=flueGas)
      annotation (Placement(transformation(extent={{-130,-88},{-110,-68}})));
public
inner TILMedia.Gas_ph        flueGasOutlet(p(start = p_start_flueGas_out)=outlet.flueGas.p,xi=xi_flueGas_del,
      gasType=flueGas, h=h_flueGas_out_del)
      annotation (Placement(transformation(extent={{-130,74},{-110,94}})));

  TILMedia.Gas_pT ideal_combustion(
    p=outlet.flueGas.p,
    gasType=flueGas,
    T=298.15)
    annotation (Placement(transformation(extent={{-100,-12},{-80,8}})));
//________________________/ replaceable models for heat transfer, pressure loss and geometry \_________________________

public
  replaceable model Geometry =
  ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry(
                                                                      flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical) "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Geometry"), choicesAllMatching=true);

    replaceable model HeatTransfer_Wall =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas "1st: choose geometry definition | 2nd: edit corresponding record"
                                                                       annotation (Dialog(group="Heat transfer correlations"), choicesAllMatching=true);

  replaceable model HeatTransfer_Top =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas "1st: choose geometry definition | 2nd: edit corresponding record"
                                                                       annotation (Dialog(group="Heat transfer correlations"), choicesAllMatching=true);

  replaceable model RadiationTimeConstant =
      ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass
    constrainedby ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.PartialThermalCapacity
                                                                                            annotation (Dialog(group="Heat transfer correlations"), choicesAllMatching=true);

//________________________/ replaceable modells for burning time and migration speed \_________________________

  replaceable model Burning_time =
      ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime
    constrainedby ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.PartialBurningTime "Model for the buring time"
                                annotation (Dialog(group="Combustion"),
      choicesAllMatching=true);

  replaceable model ParticleMigration =
      ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed
    constrainedby ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.PartialMigrationSpeed "Model for the particle migration speed"
                                             annotation (Dialog(group=
          "Combustion"), choicesAllMatching=true);

  replaceable model ReactionZone =
      ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone
    constrainedby ClaRa.Components.Furnace.ChemicalReactions.PartialReactionZone "Model to regard chemical reactions"
                                         annotation (Dialog(group=
          "Chemical Reaction"), choicesAllMatching=true);

  inner Geometry geo annotation(Placement(transformation(extent={{-250,50},{-230,
            70}})));

  inner HeatTransfer_Wall heattransfer_wall(heatSurfaceAlloc=1)  annotation(Placement(transformation(extent={{232,-10},
            {252,10}})));

  inner HeatTransfer_Top heattransfer_top annotation(Placement(transformation(extent={{94,50},
            {74,70}})));

  inner RadiationTimeConstant radiationTimeConstant  annotation (Placement(transformation(extent={{32,50},
            {52,70}})));

  ReactionZone reactionZone
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Burning_time burning_time
    annotation (Placement(transformation(extent={{-54,28},{-34,48}})));
  ParticleMigration particleMigration
    annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));

  Basics.Interfaces.EyeOut eyeOut annotation (Placement(transformation(extent={{-280,78},
            {-308,102}}),         iconTransformation(extent={{-290,70},{-310,90}})));
protected
           Basics.Interfaces.EyeIn eye_int
                                annotation (Placement(transformation(extent={{-254,84},
            {-266,96}}),      iconTransformation(extent={{240,-64},{232,-56}})));

public
  Summary summary(
    outline(
      volume=geo.volume,
      A_cross=geo.A_front,
      A_wall=if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then 2*(geo.width + geo.length)*geo.height else 2*(geo.width + geo.height)*geo.length,
      height=geo.height,
      m=mass,
      m_flow_coal_burned=m_flow_coal_burned,
      m_flow_oxygen_burned=m_flow_oxygen_burned,
      m_flow_oxygen_req=m_flow_oxygen_req,
      m_flow_air_req=m_flow_air_req,
      lambdaComb=lambdaComb,
      NOx_fraction=reactionZone.xi_NOx,
      CO_fraction=reactionZone.xi_CO,
      LHV=LHV,
      Q_combustion=m_flow_coal_burned*LHV,
      w_migration=particleMigration.w,
      t_dwell_flueGas=t_dwell_flueGas,
      burning_time=burning_time.t,
      coal_diffusity=coal_diffusity,
      T_out=flueGasOutlet.T,
      h_out=flueGasOutlet.h),
    inlet(
      flueGas(
        m_flow=inlet.flueGas.m_flow,
        T=actualStream(inlet.flueGas.T_outflow),
        p=inlet.flueGas.p,
        h=flueGasInlet.h,
        H_flow=flueGasInlet.h*inlet.flueGas.m_flow),
      coal(
        m_flow=inlet.coal.m_flow,
        T=actualStream(inlet.coal.T_outflow),
        p=inlet.coal.p,
        cp=inlet.coalType.cp),
      slag(
        m_flow=inlet.slag.m_flow,
        T=actualStream(inlet.slag.T_outflow),
        p=inlet.slag.p)),
    outlet(
      flueGas(
        m_flow=-outlet.flueGas.m_flow,
        T=actualStream(outlet.flueGas.T_outflow),
        p=outlet.flueGas.p,
        h=h_flueGas_out,
        H_flow=-h_flueGas_out*outlet.flueGas.m_flow),
      coal(
        m_flow=-outlet.coal.m_flow,
        T=actualStream(outlet.coal.T_outflow),
        p=outlet.coal.p,
        cp=outlet.coalType.cp),
      slag(
        m_flow=outlet.slag.m_flow,
        T=actualStream(outlet.slag.T_outflow),
        p=outlet.slag.p))) annotation (Placement(transformation(extent={{274,-102},{300,-76}})));

initial equation

  h_flueGas_out_del = h_start;
  xi_flueGas_del = xi_start_flueGas_out;
  coal_diffusity = 0;

equation

  Tau = 0.001; //time constant for delays

  der(h_flueGas_out_del) = 1/Tau*(h_flueGas_out-h_flueGas_out_del);
  der(xi_flueGas_del) = 1/Tau*(xi_flueGas - xi_flueGas_del);

  if noEvent(t_dwell_flueGas < burning_time.t) then
    der(coal_diffusity) = 1/Tau * ((1.0 - t_dwell_flueGas/burning_time.t) - coal_diffusity);
  else
    der(coal_diffusity) = 1/Tau * (0-coal_diffusity);
  end if;

// if noEvent(t_dwell_flueGas < burning_time.t) then
//   coal_diffusity =(1.0 - t_dwell_flueGas/burning_time.t);
// else
//   coal_diffusity = (0);
// end if;

   //____________/ Xi_outflow of Coal and FlueGas \__________________
    //dummy values for inlets since flow reversal is not allowed
  outlet.coal.xi_outflow = xi_coal_out;
  inlet.coal.xi_outflow = xi_coal_out;

  inlet.flueGas.xi_outflow = xi_flueGas;
  outlet.flueGas.xi_outflow = xi_flueGas;

  //___________/ Dummy T_outflows \__________________________________________
  inlet.coal.T_outflow = outlet.flueGas.T_outflow;
  outlet.slag.T_outflow = inStream(outlet.slag.T_outflow); //outlet.slag is inflowing slag
  inlet.flueGas.T_outflow  = outlet.flueGas.T_outflow;

  //_____________/ Pressure \______________________________________________
  inlet.flueGas.p = outlet.flueGas.p;
  inlet.coal.p = outlet.coal.p;
  inlet.slag.p = outlet.slag.p;

  //____________/ Heat port temperatures and Q_flows \____________________________
   Q_flow_wall = heat_wall.Q_flow;
   Q_flow_top = heat_top.Q_flow;
   Q_flow_bottom = heat_bottom.Q_flow;

  //______________Eye port variable definition________________________
  eye_int.m_flow = -outlet.flueGas.m_flow;
  eye_int.T = flueGasOutlet.T-273.15;
  eye_int.s = flueGasOutlet.s/1e3;
  eye_int.p = flueGasOutlet.p/1e5;
  eye_int.h = flueGasOutlet.h/1e3;

 //_____________/ Connections \______________________________________________
  connect(heat_top, radiationTimeConstant.heat_in) annotation (Line(
      points={{20,100},{20,60},{32,60}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(radiationTimeConstant.heat_out, heattransfer_top.heat) annotation (
      Line(
      points={{52,60},{74,60}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heattransfer_wall.heat, heat_wall) annotation (Line(
      points={{252,0},{300,0}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye_int,eyeOut)
                         annotation (Line(
      points={{-260,90},{-294,90}},
      color={190,190,190},
      smooth=Smooth.None));
 annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-300,-100},
            {300,100}}),
                   graphics),               Diagram(coordinateSystem(
          preserveAspectRatio=false,extent={{-300,-100},{300,100}}),
                                                    graphics),
    Documentation(info="<html>
<p><b>Model description: </b>Base class for burner and furnace sections</p>
<p><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
</html>"));
end CombustionChamberBase;
