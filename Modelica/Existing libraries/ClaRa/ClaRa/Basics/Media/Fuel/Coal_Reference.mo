within ClaRa.Basics.Media.Fuel;
record Coal_Reference " {C,H,O,N,S,Ash,H2O}, reference coal"
 extends ClaRa.Basics.Media.Fuel.PartialFuel(
    final nc=7,
    cp=1278,
    LHV=25.1e6,
    final defaultComposition={0.661,0.0383,0.066,0.016,0.0057,0.135});
end Coal_Reference;
