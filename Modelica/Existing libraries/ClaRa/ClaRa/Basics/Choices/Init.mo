within ClaRa.Basics.Choices;
type Init = enumeration(
    noInit "Free initialisation, use guess values",
    steadyState "Steady state in pressure and enthalpy",
    steadyPressure "Steady state in pressure",
    steadyEnthalpy "Steady state in specific enthalpy",
    steadyTemperature "Steady state in temperature",
    steadyDensity "Steady state density/mass",
    steadyDensityPressure "Steady density/mass and pressure") "The initialisation of a thermal control volume";
