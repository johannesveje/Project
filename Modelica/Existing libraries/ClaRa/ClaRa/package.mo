within ;
package ClaRa "Simulation of Clausius-Rankine Cycles"
  import SI = ClaRa.Basics.Units;


annotation (preferedView="info",version="1.0.0",
                           uses(
    TILMedia(version="1.0.0 ClaRa"),
    FluidDissipation(version="1.1.7"),
      Modelica(version="3.2.1")),
                                 Icon(coordinateSystem(preserveAspectRatio=
          false, extent={{-100,-100},{100,100}}),
                                      graphics={Bitmap(
        extent={{-100,100},{100,-100}},
        imageSource=
            "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",
        fileName="modelica://ClaRa/figures/ClaRa-Logo.png")}),
  conversion(from(version="0.0", script="modelica://ClaRa/Scripts/ConvertFRom00.mos"),
    from(version="0.1 alpha", script="modelica://ClaRa/Scripts/ConvertFRom01.mos"),
    from(version="0.2 alpha", script="modelica://ClaRa/Scripts/ConvertFRom02.mos"),
    from(version="0.2.1 alpha", script="modelica://ClaRa/Scripts/ConvertFRom021.mos")),
  Documentation(info="<html>
<p><img src=\"modelica://ClaRa/figures/ClaRaLibraryInfo.png\"/></p>
</html>"));
end ClaRa;
