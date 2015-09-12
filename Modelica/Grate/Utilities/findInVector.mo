within Grate.Utilities;
function findInVector
  extends Modelica.Icons.Function;
  input String string1;
  input String string2[:];
  input Boolean caseSensitive=true
    "= false, if lower and upper case are ignored for the comparison";
  output Integer index
    "Returns the index of string1 in vector of strings, string2.";

algorithm
  for i in 1:size(string2, 1) loop
    if Modelica.Utilities.Strings.isEqual(string1, string2[i]) then
      index := 1;
    end if;
  end for;

end findInVector;
