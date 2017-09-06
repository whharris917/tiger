[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 50
  ny = 50
  nz = 50
  xmax = 200
  ymax = 200
  zmax = 200
[]

[MeshModifiers]
  [./new_nodeset]
    type = AddExtraNodeset
    new_boundary = 100
    coord = '0 0 0'
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
  [./Tz_AEH]
    scaling = 1.0e4
    initial_condition = 373
  [../]
[]

[AuxVariables]
  [./phase_aux_variable]
    block = 0
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
  [./heat_z]
    type = CoefConduction
    variable = Tz_AEH
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
  [./heat_rhs_z]
    type = HomogenizationHeatConduction
    variable = Tz_AEH
    component = 2
    diffusion_coefficient_name = conductivity
  [../]
[]

[BCs]
  [./Periodic]
    [./PeriodicAll]
      variable = 'Tx_AEH Ty_AEH Tz_AEH'
      auto_direction = 'x y z'
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
  [./fix_z]
    type = DirichletBC
    variable = Tz_AEH
    boundary = 100
    value = 373
  [../]
[]

[Materials]
  [./HafniumAluminum]
    type = HfAlMaterial
    block = 0
    interface_cond = 0.0001
    RGB_aux_variable = phase_aux_variable
    temperature = Tx_AEH
    output_properties = conductivity
    outputs = New3DHomogenizedKExodus_2
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
    temp_z = Tz_AEH
    diffusion_coefficient_name = conductivity
  [../]
  [./k_y_AEH]
    type = HomogenizedThermalConductivity
    variable = Ty_AEH
    scale_factor = 1e6
    component = 1
    temp_y = Ty_AEH
    temp_x = Tx_AEH
    temp_z = Tz_AEH
    diffusion_coefficient_name = conductivity
  [../]
  [./k_z_AEH]
    type = HomogenizedThermalConductivity
    variable = Tz_AEH
    scale_factor = 1e6
    component = 2
    temp_y = Ty_AEH
    temp_x = Tx_AEH
    temp_z = Tz_AEH
    diffusion_coefficient_name = conductivity
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    off_diag_row = 'Tx_AEH Tz_AEH Ty_AEH'
    off_diag_column = 'Tz_AEH Ty_AEH Tx_AEH'
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
  initial_steps = 1
  cycles_per_step = 0
  marker = marker
  initial_marker = marker
  [./Indicators]
    [./indicator]
      type = GradientJumpIndicator
      variable = phase_aux_variable
      block = 0
    [../]
  [../]
  [./Markers]
    [./marker]
      type = ErrorFractionMarker
      indicator = indicator
      block = 0
      refine = 0.9
    [../]
  [../]
[]

[Outputs]
  exodus = true
  execute_on = timestep_end
  [./New3DHomogenizedKExodus]
    output_material_properties = true
    file_base = New3DHomogenizedKExodus
    type = Exodus
    show_material_properties = conductivity
  [../]
[]

[ICs]
  [./phase_IC]
    radius = 15
    outvalue = 1
    variable = phase_aux_variable
    invalue = 3
    type = MultiSmoothCircleIC
    int_width = 0.5
    numbub = 100
    bubspac = 5
    radius_variation = 0.5
    radius_variation_type = uniform
    block = 0
  [../]
[]

