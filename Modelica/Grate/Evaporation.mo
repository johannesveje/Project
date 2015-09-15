within Grate;
model Evaporation
  // outer Grate.CombustionSystem system "System wide properties";

  package FlueGas = Grate.Fuels.FlueGas;
  package FuelData = Grate.Fuels.FuelData;
  constant Integer water_index=Grate.Utilities.findInVector("Water", FlueGas.substanceNames);

  parameter SI.MassFraction Xi_fuelInput[:];
  parameter SI.MassFraction Xi_fuelOutput[:];

  parameter SI.Length width=1 "Width of the bed";
  parameter SI.Length length=1 "Length of the evaporation section of the bed";
  parameter SI.Velocity v=0.1 "Velocity of the fuel in the bed";

  parameter Real A0(final unit="1/(s.K)") = 100;

  SI.MassFlow dmw_dt=der(mw)
    "Change of water content in fuel as function of time";
  SI.Mass mw(start=0);

  FlueGas.BaseProperties flueGas;

  Fuels.BasePackage.fuelInput fuelInput annotation (Placement(transformation(
        extent={{-25,-23},{25,23}},
        rotation=90,
        origin={-93,-1}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-90,0})));
  Modelica.Fluid.Interfaces.FluidPort_a flueGas_in(redeclare package Medium =
        FlueGas) annotation (Placement(transformation(extent={{-10,-100},{10,-80}}),
        iconTransformation(extent={{-10,-100},{10,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_b flueGas_out(redeclare package Medium =
        FlueGas) annotation (Placement(transformation(extent={{-40,80},{-20,100}}),
        iconTransformation(extent={{-40,80},{-20,100}})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts_a annotation (Placement(
        transformation(extent={{20,80},{40,100}}), iconTransformation(extent={{
            20,80},{40,100}})));
  Fuels.BasePackage.fuelOutput fuelOutput annotation (Placement(transformation(
          extent={{78,-12},{98,8}}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={90,0})));

equation
  for i in 1:FlueGas.components loop
    if i == water_index then
      Xi_fuelInput[i] = fuelInput.prox[FuelData.Index.Proximate.Moisture];
    else
      Xi_fuelInput[i] = 0;
      Xi_fuelOutput[i] = 0;
    end if;
  end for;

  // Medium properties
  flueGas.p = flueGas_in.p;
  flueGas.p = flueGas_out.p;

  // Source term water
  dmw_dt = -A0*(T - T_sat)*(fuelInput.m_flow*fuelInput.prox[FuelData.Index.Proximate.Moisture]
     - fuelOutput.m_flow);

  // Mass balances
  0 = fuelInput.m_flow + flueGas_in.m_flow + flueGas_out.m_flow + fuelOutput.m_flow;
  0 = flueGas_in.m_flow*flueGas_in.Xi_outflow[water_index] + flueGas_out.m_flow
    *flueGas_out.Xi_outflow[water_index];

  // Energy balance
  0 = fuelInput.m_flow*fuelInput.heating_value + flueGas_in.m_flow*actualStream(
    flueGas_in.h_outflow) + flueGas_out.m_flow*actualStream(flueGas_out.h_outflow)
     + fuelOutput.m_flow*fuelOutput.heating_value + heatPorts_a.Q_flow;
  // Pressure
  flueGas_in.p = flueGas_out.p;

  // Spicies balance
  zeros(6) = flueGas_in.m_flow*flueGas_in.Xi_outflow + flueGas_out.m_flow*
    flueGas_out.Xi_outflow + fuelInput.m_flow*Xi_fuelInput;
  annotation (preferredView="text",Icon(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid), Text(
          extent={{-76,76},{76,-76}},
          lineColor={85,255,255},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="Evaporation")}));
end Evaporation;
