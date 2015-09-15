within ClaRa.Basics.Functions;
function Factorial "Calculate the factorial"
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

input Integer Num "Integer Input";
output Integer factorial_Num "Factorial of Num" annotation (Dialog(group="Output"));
protected
  Integer Rv;

algorithm
  if Num <=1 then
    factorial_Num:=1;
  else
    factorial_Num:=1;
    for Rv in 1:Num loop
      factorial_Num:=factorial_Num*Rv;
    end for;
  end if;

end Factorial;
