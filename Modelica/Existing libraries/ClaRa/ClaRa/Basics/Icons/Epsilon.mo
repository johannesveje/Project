within ClaRa.Basics.Icons;
model Epsilon

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Bitmap(
          extent={{-100,100},{100,-100}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/figures/Components/Epsilon.png")}));

end Epsilon;
