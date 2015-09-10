within Grate;
package Fuels
  extends Modelica.Icons.VariantsPackage;
  partial package PartialFuel
    extends Modelica.Icons.MaterialPropertiesPackage;

    // Constants to be set in Fuel
      constant String fuelName="unusablePartialFuel" "Name of the fuel";
    constant String substanceNames[:]={fuelName}
      "Names of the mixture substances. Set substanceNames={fuelName} if only one substance.";
  end PartialFuel;

  package Types "Types to be used in fuel models"
    extends Modelica.Icons.Package;
    type Density = SI.Density (
        min=0,
        max=1.e5,
        nominal=1,
        start=1) "Type for density with medium specific attributes";
    type MassFraction = Real (
        quantity="MassFraction",
        final unit="kg/kg",
        min=0,
        max=1,
        nominal=0.1) "Type for mass fraction with medium specific attributes";
    type MoleFraction = Real (
        quantity="MoleFraction",
        final unit="mol/mol",
        min=0,
        max=1,
        nominal=0.1) "Type for mole fraction with medium specific attributes";
    type MolarMass = SI.MolarMass (
        min=0.001,
        max=0.25,
        nominal=0.032) "Type for molar mass with medium specific attributes";
    type Temperature = SI.Temperature (
        min=1,
        max=1.e4,
        nominal=300,
        start=300) "Type for temperature with medium specific attributes";

  end Types;

  package BasePackage

    model FuelSource

      parameter SI.MassFlowRate m_flow "Mass flow of the fuel";
      parameter SI.SpecificEnergy LHV "Lower Heating Value of the fuel";
      parameter SI.Density rho "Density of the fuel";
      parameter SI.MassFraction prox_moi "Mass fraction of Moisture"
        annotation (Dialog(group="Proximate Analysis (As recieved)"));
      parameter SI.MassFraction prox_com "Mass fraction of Combustibles"
        annotation (Dialog(group="Proximate Analysis (As recieved)"));
      parameter SI.MassFraction prox_ash "Mass fraction of Ash"
        annotation (Dialog(group="Proximate Analysis (As recieved)"));

      parameter Boolean use_ultimate=true "Use ultimate analasis data" annotation (
        Dialog(group="Ultimate Analysis (dry)"),
        Evaluate=true,
        HideResult=true,
        choices(checkBox=true));
      parameter SI.MassFraction ulti_C "Mass fraction of Carbon (C)"
        annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
      parameter SI.MassFraction ulti_H "Mass fraction of Hydrogen (H)"
        annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
      parameter SI.MassFraction ulti_O "Mass fraction of Oxygen (O)"
        annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
      parameter SI.MassFraction ulti_N "Mass fraction of Nitrogen (N)"
        annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));
      parameter SI.MassFraction ulti_S "Mass fraction of Sulfur (S)"
        annotation (Dialog(group="Ultimate Analysis (dry)", enable=use_ultimate));

      parameter Boolean use_spicies=false "Use spicies analasis data" annotation (
        Dialog(group="Spicies Analysis (As recieved)"),
        Evaluate=true,
        HideResult=true,
        choices(checkBox=true));
      parameter SI.MassFraction spicies_CO2 "Mass fraction of CO2" annotation (
          Dialog(group="Spicies Analysis (As recieved)", enable=use_spicies));

      Modelica.Blocks.Interfaces.RealOutput y[4]={m_flow,prox[1],prox[2],prox[3]}
        annotation (Placement(transformation(extent={{100,-24},{148,24}}),
            iconTransformation(extent={{100,-10},{120,10}})));
      annotation (
        preferredView="text",
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={28,108,200},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid), Text(
              extent={{-98,98},{98,-98}},
              lineColor={0,140,72},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="Fuel")}),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={28,108,200},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid), Text(
              extent={{-98,98},{98,-98}},
              lineColor={0,255,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="Fuel")}));

    protected
      parameter SI.MassFraction prox[3]={prox_moi,prox_com,prox_ash};
      parameter SI.MassFraction ulti[5]={ulti_C,ulti_H,ulti_O,ulti_N,ulti_S};
      parameter SI.MassFraction spicies[1]={spicies_CO2};
      parameter String prox_names[3]={"Moisture","Combustibles","Ash"};
      parameter String ulti_names[5]={"Carbon","Hydrogen","Oxygen","Nitrogen","Sulfur"};
      parameter String spicies_names[:]={"CO2"};

    equation
    //   for i in 1:3 loop
    //     assert(prox[i] >= -1.e-5 and prox[i] <= 1 + 1.e-5, "Mass fraction of " + prox_names[i] + " is not in the range 0..1");
    //   end for;
    //     for i in 1:5 loop
    //     assert(ulti[i] >= -1.e-5 and ulti[i] <= 1 + 1.e-5, "Mass fraction of " + ulti_names[i] + " is not in the range 0..1");
    //     end for;
    //       for i in 1:1 loop
    //     assert(spicies[i] >= -1.e-5 and spicies[i] <= 1 + 1.e-5, "Mass fraction of " + spicies_names[i] + " is not in the range 0..1");
    //   end for;
    assert(sum(prox)==1, "Proximate analysis mass fractions do not add up to 1");
    assert(sum(ulti)==1, "Ultimate analysis mass fractions do not add up to 1");
    assert(sum(spicies)==1, "Spicies analysis mass fractions do not add up to 1");

    end FuelSource;

    expandable connector fuelInput
      extends Modelica.Icons.SignalBus;
       constant Real nXi=Modelica.Media.IdealGases.Common.FluidData.C3H7OH.molarMass;
    SI.MassFlowRate m_flow annotation ();
    Real k annotation ();
    Real j annotation ();
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}})));
    end fuelInput;
  end BasePackage;
end Fuels;
