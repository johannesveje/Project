within ClaRa.Basics.Functions;
function GenerateGrid "Generate grid discretization from scale functions"
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

  extends Modelica.Icons.Function;

  input Real SizeFunc[:] "array determining number and kind of different stretchings to be applied";
  input Real L "length in discretization direction";
  input Integer N "number of cells in grid";

  output Real dx[N] "resulting grid";

protected
  Integer NumDis "number of regions into which the grid shall be subdivided";
  Integer NSub[N]=zeros(N);
  //number of cells in each subdivision
  Integer offset "Offset for discretization interval used in computation of dx[N] by going through the subdivisions";
  //auxiliary variables......
  Integer NextElem;
  Real remainder;
  Real normalConst;

algorithm
  assert(L > 0, "Length of discretisation interval must be greater than zero!");

  NumDis := size(SizeFunc, 1);
  //get number of subdivisions.

  // /*----------get all size functions via a string---------------*/
  // //for now we use  Modelica.Utilities.Examples.expression here as string parser.
  // //Maybe we need to write our own in the mid term perspective?
  //   NumElem:=1;
  //   while NumElem<=NumDis loop
  //     (SizeFunc[NumElem],NextElem):=Modelica.Utilities.Examples.expression(SizeFuncString,startIndex=NextElem+1);
  //     NumElem:=NumElem+1;
  //   end while;

  /*-if too many subdivisions are used the scaling of each sub-interval becomes meaningless!------*/
  // assert(NumDis <= div(N, 2), "Number of subdivisions of grid exceeds N/2.
  // This makes any choice of stretching ineffective. Either lower the number of subdivisions of the grid or increase the number of grid cells!");

  /*----------compute the number of cells in each subdivision---------------*/
  remainder := 0;
  if NumDis == 1 then
    NSub[NumDis] := N;
  else
    for i in 1:NumDis - 1 loop
      remainder := remainder + rem(N, NumDis)/NumDis;
      if remainder > 0.5 then
        NSub[i] := div(N, NumDis) + 1;
        remainder := remainder - 1;
      else
        NSub[i] := div(N, NumDis);
      end if;
    end for;
    NSub[NumDis] := N;
    for i in 1:NumDis - 1 loop
      NSub[NumDis] := NSub[NumDis] - NSub[i];
    end for;
    //again the following gives problems during compilation..: -sum({NSub[i] for i in 1:NumDis-1});
    //need to check the algorithm further, in principle this could be integrated into one loop statement.
    //For now I leave it in this state, this ensures that no overcounting occurs due to rounding of numbers.
  end if;

  /*----------compute the length of the cells in each subdivision and write to dx[N]!---------------*/
  offset := 0;
  for i in 1:NumDis loop
    //go through every subdivision of the grid
    normalConst := 0;

    for k in 1:NSub[i] loop
      // somehow the usual normalConst:=sum({k^SizeFunc[i] for k in 1:NSub[i]}); gives an compiler error!
      normalConst := normalConst + k^abs(SizeFunc[i]);
    end for;

    if SizeFunc[i] >= 0 then

      for j in 1:NSub[i] loop
        dx[offset + j] := L/NumDis*(j^SizeFunc[i])/normalConst;
      end for;
    else
      for j in 1:NSub[i] loop
        dx[offset + j] := L/NumDis*(NSub[i] + 1 - j)^(-SizeFunc[i])/normalConst;
      end for;
    end if;
    offset := offset + NSub[i];
  end for;
  /*--enable the lines below for debugging purposes!-------------------------------------------------*/
  //   dx[1]:=NSub[1];
  //   dx[2]:=NSub[2];
  //   dx[3]:=NumDis;
  //   dx:=NSub;

  annotation (Documentation(info="<html>
<p><h4>This function computes the discretization of a given interval I of length L into N cells.  </h4></p>
<p> The input SizeFunc[:] consists of a vector of signed reals, e.g 
 {i_1,i_2,....,i_K}. The number K of reals corresponds to a subdivision of I into K subintervals I_K of length L/K.
 Accordingly every subinterval I_K contains (up to rounding) N/K cells. For each I_K the number i_K prescribes a distribution of cells. 
 Here i_K=0 corresponds to equidistant cell spacing, i_K &gt; 0 to increasing cell width from beginning to the end of I_K, i_K &lt; 
 0 to decreasing cell width from beginning to the end of I_K. The modulus |i_K| determines the stretching rate.  </p>
</html>", revisions="<html>
<p><ul>
<li><b>v0.1 </b>2011-08-12: Initial implementation. Johannes Brunnemann, XRG Simulation GmbH</li>
</ul></p>
</html>"));
end GenerateGrid;
