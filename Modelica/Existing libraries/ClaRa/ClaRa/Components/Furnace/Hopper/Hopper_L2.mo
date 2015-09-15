within ClaRa.Components.Furnace.Hopper;
model Hopper_L2 "Model for a hopper section of a combustion chamber"
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

  import ClaRa;
  extends ClaRa.Basics.Icons.Hopper;
  //inner parameter ClaRa.Basics.Units.Temperature SlagTemperature=900;
extends ClaRa.Components.Furnace.BaseClasses.HopperBase(geo(
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical));

inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));

Real sum_xi;
Real drhodt;

   ClaRa.Basics.Units.MassFraction xi_flueGas_in_del[flueGas.nc - 1];
                                                            //Flue gas mixture composition

   ClaRa.Basics.Units.MassFlowRate m_flow_in_del;
   ClaRa.Basics.Units.MassFlowRate m_flow_out_del;
   ClaRa.Basics.Units.Temperature T_bulk_del;
   ClaRa.Basics.Units.DensityMassSpecific rho_bulk_del;

  record Outline
  //  parameter Boolean showExpertSummary annotation(Dialog(hide));
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Volume
                                volume "Volume";
    input ClaRa.Basics.Units.Area
                              A_cross "Cross sectional area";
    input ClaRa.Basics.Units.Area
                              A_wall "Wall area";
    input ClaRa.Basics.Units.Length
                                height "Height of volume";
    input ClaRa.Basics.Units.Mass
                              mass "Mass inside volume";
    input ClaRa.Basics.Units.Temperature
                                     T_out "Outlet temperature";
    input ClaRa.Basics.Units.EnthalpyMassSpecific
                                              h_out "Flue gas enthalpy at outlet";
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

   Summary summary(
   outline(
    volume = geo.volume,
    A_cross = geo.width*geo.height,
    A_wall = geo.width*geo.length*2+geo.length*geo.height*2,
    height=geo.height,
    mass = mass,
    T_out = flueGasOutlet.T,
    h_out = flueGasOutlet.h),
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

//___________________/ Media Objects \_________
   TILMedia.Gas_ph bulk(
     p(start=p_start_flueGas_out) = outlet.flueGas.p,
     xi=xi_flueGas_del,
     gasType=flueGas,
     h=h_flueGas_out_del)
       annotation (Placement(transformation(extent={{-130,26},{-110,46}})));

//___________________/ iCom record \__________________
protected
  inner ClaRa.Basics.Records.IComGas_L2 iCom(
    m_flow_nom=m_flow_nom,
    T_bulk=flueGasOutlet.T,
    p_bulk=bulk.p,
    fluidPointer_in=flueGasInlet.gasPointer,
    fluidPointer_bulk=flueGasOutlet.gasPointer,
    fluidPointer_out=flueGasOutlet.gasPointer,
    mediumModel=flueGas,
    p_in=inlet.flueGas.p,
    T_in=T_bulk_del,
    m_flow_in=m_flow_in_del,
    V_flow_in=V_flow_flueGas_in,
    xi_in=xi_flueGas_del,
    p_out=outlet.flueGas.p,
    T_out=T_bulk_del,
    m_flow_out=m_flow_out_del,
    V_flow_out=V_flow_flueGas_out,
    xi_out=xi_flueGas_del) annotation (Placement(transformation(extent={{244,-102},{268,-76}})));

initial equation

h_flueGas_out = h_start;
xi_flueGas = xi_start_flueGas_out;

equation

   mass = geo.volume * bulk.d;

  //_______________/ Composition of coal and gas \_____________________
  xi_coal_in = inStream(inlet.coal.xi_outflow);
  xi_coal_out =  xi_coal_in;

  //________________/ Mass balance - flue gas \______________________________________
  inlet.flueGas.m_flow + outlet.flueGas.m_flow  =  drhodt*geo.volume;

  der(xi_flueGas) =  1/mass * (inlet.flueGas.m_flow*(flueGasInlet.xi - xi_flueGas) + outlet.flueGas.m_flow*(flueGasOutlet.xi - xi_flueGas));
  drhodt = bulk.drhodh_pxi * der(bulk.h) + sum({bulk.drhodxi_ph[i] * der(bulk.xi[i]) for i in 1:flueGas.nc-1});

  //______________ / Mass balance - Slag \____________________________________________________________________________
  0 = inlet.slag.m_flow  + outlet.slag.m_flow;

  //______________/ Mass balance - Coal \____________________________
  0 = outlet.coal.m_flow + inlet.coal.m_flow;

  //_______________/ Energy Balance for gas \__________________________
  der(h_flueGas_out) = (Q_flow_wall + Q_flow_top + Q_flow_bottom
                + inlet.flueGas.m_flow * (flueGasInlet.h - h_flueGas_out)
                + outlet.flueGas.m_flow * (flueGasOutlet.h - h_flueGas_out)
                + inlet.slag.m_flow * (inlet.slagType.cp * (SlagTemperature - 298.15) - h_flueGas_out)
                + outlet.slag.m_flow * (inlet.slagType.cp * (inStream(outlet.slag.T_outflow)  - 298.15) - h_flueGas_out)
                + inlet.coal.m_flow *(inlet.coalType.cp * (inStream(inlet.coal.T_outflow)  - 298.15) - h_flueGas_out)
                + outlet.coal.m_flow * (outlet.coalType.cp * (outlet.coal.T_outflow - 298.15) - h_flueGas_out))/mass;

  V_flow_flueGas_in = 0;
  V_flow_flueGas_out = 0;

  m_flow_in_del = inlet.flueGas.m_flow;
  m_flow_out_del = outlet.flueGas.m_flow;
  xi_flueGas_in_del = flueGasInlet.xi;
  T_bulk_del = bulk.T;
  rho_bulk_del = bulk.d;

  sum_xi = sum(flueGasOutlet.xi);

  xi_coal = 0; // amount of coal per flue gas mass

 //___________/ T_outflows \______________
  outlet.coal.T_outflow = bulk.T;
  outlet.flueGas.T_outflow = bulk.T;

  inlet.slag.T_outflow = SlagTemperature;
  heat_bottom.T = bulk.T;

  inlet.flueGas.xi_outflow  = xi_flueGas_del;
  outlet.flueGas.xi_outflow  = xi_flueGas_del;

  //___________/ Dummy T_outflows \__________________________________________
  inlet.coal.T_outflow = bulk.T;
  outlet.slag.T_outflow = inStream(outlet.slag.T_outflow); //outlet.slag is inflowing slag
  inlet.flueGas.T_outflow  = bulk.T;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,
            -100},{300,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-100},{300,100}}), graphics={
        Text(
          extent={{34,90},{242,56}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "T_out="+realString(T_outlet,1,integer(0)) +"K")),
        Text(
          extent={{34,44},{242,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "lambda="+realString(min(99,lambda),1,integer(1)))),
        Text(
          extent={{34,-54},{242,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "Q="+realString(-Q_combustion/1e6,1,integer(0))+"MW")),
        Text(
          extent={{32,-14},{240,-48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", "alphaA="+realString(heattransfer.effAlphaA,1,integer(0))+""))}),
    Documentation(info="<html>
<p><b>Model description: </b>A nonstationary model for the hopper furnace section</p>
<p><br/><b>Contact:</b> Lasse Nielsen, TLK-Thermo GmbH</p>
<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Nonstationary mass and energy balances are used</li>
<li>Different heat transfer correlations can be chosen</li>
</ul></p>
</html>"));
end Hopper_L2;
