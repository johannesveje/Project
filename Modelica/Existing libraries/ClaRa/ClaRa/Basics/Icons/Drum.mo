within ClaRa.Basics.Icons;
model Drum

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,
            -100},{300,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-300,-100},{300,100}}), graphics={Bitmap(
          extent={{-300,100},{300,-100}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/figures/Components/Drum.png")}));

end Drum;
