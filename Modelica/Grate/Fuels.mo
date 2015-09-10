within Grate;
package Fuels
  extends Modelica.Icons.VariantsPackage;

  package BasePackage

    expandable connector fuelInput
      extends Modelica.Icons.SignalBus;

      SI.MassFlowRate m_flow annotation ();
      SI.SpecificEnergy heating_value annotation ();
      SI.Density rho annotation ();
      SI.Temperature T;
      SI.MassFraction prox[3] annotation ();
      SI.MassFraction ulti[5] annotation ();
      SI.MassFraction spicies[1] annotation ();

      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}})));
    end fuelInput;

    expandable connector fuelOutput
      extends Modelica.Icons.SignalBus;

      SI.MassFlowRate m_flow annotation ();
      SI.SpecificEnergy heating_value annotation ();
      SI.Density rho annotation ();
      SI.Temperature T;
      SI.MassFraction prox[3] annotation ();
      SI.MassFraction ulti[5] annotation ();
      SI.MassFraction spicies[1] annotation ();

      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}})));
    end fuelOutput;
  end BasePackage;

  model FuelSource

    parameter SI.MassFlowRate m_flow=1 "Mass flow of the fuel";
    parameter SI.SpecificEnergy heating_value(displayUnit="MJ/kg") = 15e6
      "Heating Value of the fuel at temperature T" annotation (Evaluate=true);
    parameter SI.Density rho=1 "Density of the fuel";
    parameter SI.Temperature T(displayUnit="degC") = 298.15
      "Temperature of the fuel";
    parameter SI.MassFraction prox_moi=1 "Mass fraction of Moisture"
      annotation (Dialog(group="Proximate Analysis (As recieved)"));
    parameter SI.MassFraction prox_com=1 "Mass fraction of Combustibles"
      annotation (Dialog(group="Proximate Analysis (As recieved)"));
    parameter SI.MassFraction prox_ash=1 "Mass fraction of Ash"
      annotation (Dialog(group="Proximate Analysis (As recieved)"));

    parameter Boolean use_ultimate=true "Use ultimate analasis data"
      annotation (
      Dialog(group="Ultimate Analysis (dry)"),
      Evaluate=true,
      HideResult=true,
      choices(checkBox=true));
    parameter SI.MassFraction ulti_C=1 "Mass fraction of Carbon (C)"
      annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
    parameter SI.MassFraction ulti_H=1 "Mass fraction of Hydrogen (H)"
      annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
    parameter SI.MassFraction ulti_O=1 "Mass fraction of Oxygen (O)"
      annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
    parameter SI.MassFraction ulti_N=1 "Mass fraction of Nitrogen (N)"
      annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
    parameter SI.MassFraction ulti_S=1 "Mass fraction of Sulfur (S)"
      annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));

    parameter Boolean use_spicies=false "Use spicies analasis data" annotation
      (
      Dialog(group="Spicies Analysis (As recieved)"),
      Evaluate=true,
      HideResult=true,
      choices(checkBox=true));
    parameter SI.MassFraction spicies_CO2=1 "Mass fraction of CO2" annotation (
        Dialog(group="Spicies Analysis (As recieved)", enable=use_spicies));

  protected
    parameter SI.MassFraction prox[3]={prox_moi,prox_com,prox_ash};
    parameter SI.MassFraction ulti[5]={ulti_C,ulti_H,ulti_O,ulti_N,ulti_S};
    parameter SI.MassFraction spicies[1]={spicies_CO2};
    parameter String prox_names[:]={"Moisture","Combustibles","Ash"};
    parameter String ulti_names[:]={"Carbon","Hydrogen","Oxygen","Nitrogen",
        "Sulfur"};
    parameter String spicies_names[:]={"CO2"};

  public
    output BasePackage.fuelOutput fuelOutput1 annotation (Placement(
          transformation(
          extent={{-11,-10},{11,10}},
          rotation=90,
          origin={97,0}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={90,0})));

  equation
    fuelOutput1.m_flow = m_flow;
    fuelOutput1.heating_value = heating_value;
    fuelOutput1.rho = rho;
    fuelOutput1.T = T;
    fuelOutput1.prox = prox/sum(prox);
    fuelOutput1.ulti = ulti/sum(ulti);
    fuelOutput1.spicies = spicies/sum(spicies);

    annotation (preferredView="text", Icon(coordinateSystem(preserveAspectRatio
            =false, extent={{-100,-100},{100,100}}), graphics={Rectangle(
              extent={{-80,80},{80,-80}},
              lineColor={28,108,200},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),Text(
              extent={{-78,78},{78,-78}},
              lineColor={128,255,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="Fuel")}));
  end FuelSource;
end Fuels;
