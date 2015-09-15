within ClaRa.Basics.Functions.ClaRaDelay;
class ExternalTable
  extends ExternalObject;
  function constructor
    output ExternalTable table;
    external "C" table=  initXRGDelay() annotation (Library={"Delay-V1","ModelicaExternalC"});
  end constructor;

  function destructor "Release storage of table"
    input ExternalTable table;
    external "C" deleteXRGDelay(table) annotation (Library={"Delay-V1","ModelicaExternalC"});
  end destructor;
end ExternalTable;
