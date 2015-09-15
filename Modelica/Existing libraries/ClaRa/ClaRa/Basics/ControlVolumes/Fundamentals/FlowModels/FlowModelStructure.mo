within ClaRa.Basics.ControlVolumes.Fundamentals.FlowModels;
type FlowModelStructure = enumeration(
    inlet_innerPipe_outlet "inlet.p------inner pipe------outlet.p || no friction pressure loss inlet->first cell / no friction pressure loss last cell->outlet",
    inlet_dp_innerPipe_dp_outlet "inlet.p-dp--inner pipe--dp-outlet.p || friction pressure loss inlet->first cell / friction pressure loss last cell->outlet",
    inlet_innerPipe_dp_outlet "inlet.p------inner pipe--dp-outlet.p || no friction pressure loss inlet->first cell / friction pressure loss last cell->outlet",
    inlet_dp_innerPipe_outlet "inlet.p-dp--inner pipe------outlet.p || friction pressure loss inlet->first cell / no friction pressure loss last cell->outlet") "Structure of flow model";
