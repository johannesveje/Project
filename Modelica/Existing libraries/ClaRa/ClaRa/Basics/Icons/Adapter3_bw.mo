within ClaRa.Basics.Icons;
model Adapter3_bw

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={Bitmap(
          extent={{-100,100},{100,-100}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/figures/Components/Adapter3_backward.png")}));

end Adapter3_bw;
