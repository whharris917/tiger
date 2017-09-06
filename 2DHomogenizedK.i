[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  nz = 0
  xmax = 186.93
  ymax = 186.93
  zmax = 0
[]

[MeshModifiers]
  [./new_nodeset]
    type = AddExtraNodeset
    new_boundary = 100
    coord = '0 0'
  [../]
[]

[Variables]
  [./Tx_AEH]
    scaling = 1.0e4
    initial_condition = 373
  [../]
  [./Ty_AEH]
    scaling = 1.0e4
    initial_condition = 373
  [../]
[]

[AuxVariables]
  [./adapt_aux_variable]
    block = 0
  [../]
  [./RGB_aux_variable]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  [./ImageFunc]
    type = ImageFunction
    origin = '0 0 0'
    component = 2
    dimensions = '186.93 186.93 0'
    file = WithVoid10.png
  [../]
[]

[Kernels]
  [./heat_x]
    type = CoefConduction
    variable = Tx_AEH
  [../]
  [./heat_y]
    type = CoefConduction
    variable = Ty_AEH
  [../]
  [./heat_rhs_x]
    type = HomogenizationHeatConduction
    variable = Tx_AEH
    component = 0
    diffusion_coefficient_name = conductivity
  [../]
  [./heat_rhs_y]
    type = HomogenizationHeatConduction
    variable = Ty_AEH
    component = 1
    diffusion_coefficient_name = conductivity
  [../]
[]

[BCs]
  [./Periodic]
    [./PeriodicAll]
      variable = 'Tx_AEH Ty_AEH'
      auto_direction = 'x y'
    [../]
  [../]
  [./fix_x]
    type = DirichletBC
    variable = Tx_AEH
    boundary = 100
    value = 373
  [../]
  [./fix_y]
    type = DirichletBC
    variable = Ty_AEH
    boundary = 100
    value = 373
  [../]
[]

[Materials]
  [./HafniumAluminum]
    type = HfAlMaterial
    block = 0
    interface_cond = 0.0001
    RGB_aux_variable = RGB_aux_variable
    temperature = Tx_AEH
    output_properties = conductivity
    outputs = 2DHomogenizedKExodus
  [../]
[]

[Postprocessors]
  [./k_x_AEH]
    type = HomogenizedThermalConductivity
    variable = Tx_AEH
    scale_factor = 1e6
    component = 0
    temp_y = Ty_AEH
    temp_x = Tx_AEH
    diffusion_coefficient_name = conductivity
  [../]
  [./k_y_AEH]
    type = HomogenizedThermalConductivity
    variable = Ty_AEH
    scale_factor = 1e6
    component = 1
    temp_y = Ty_AEH
    temp_x = Tx_AEH
    diffusion_coefficient_name = conductivity
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    off_diag_row = 'Ty_AEH Tx_AEH'
    off_diag_column = 'Tx_AEH Ty_AEH'
  [../]
[]

[Problem]
  type = FEProblem
  solve = false
[]

[Executioner]
  type = Steady
  l_max_its = 30
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart  -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre boomeramg 31 0.7'
  l_tol = 1e-9
[]

[Adaptivity]
  initial_steps = 0
  cycles_per_step = 0
  marker = Marker
  initial_marker = Marker
  [./Indicators]
    [./Indicator]
      type = GradientJumpIndicator
      variable = adapt_aux_variable
    [../]
  [../]
  [./Markers]
    [./Marker]
      type = ErrorFractionMarker
      indicator = Indicator
      refine = 0.9
    [../]
  [../]
[]

[Outputs]
  exodus = true
  execute_on = timestep_end
  [./2DHomogenizedKExodus]
    output_material_properties = true
    file_base = New3DHomogenizedKExodus
    type = Exodus
    show_material_properties = conductivity
  [../]
[]

[ICs]
  [./adapt_aux_variable_IC]
    function = ImageFunc
    variable = adapt_aux_variable
    type = FunctionIC
  [../]
  [./RGB_aux_variable_IC]
    function = ImageFunc
    variable = RGB_aux_variable
    type = FunctionIC
  [../]
[]

