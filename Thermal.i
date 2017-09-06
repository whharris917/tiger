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

[Variables]
  [./T]
    block = 0
  [../]
[]

[AuxVariables]
  [./RGB_aux_variable]
    order = CONSTANT
    family = MONOMIAL
    block = 0
  [../]
  [./adapt_aux_variable]
    block = 0
  [../]
[]

[Functions]
  [./image_function]
    type = ImageFunction
    component = 0
    file_suffix = png
    file_base = Images/Image
    origin = '0 0 0'
    dimensions = '200 200 200'
  [../]
[]

[Kernels]
  active = 'CoefConductionT'
  [./CoefConductionT]
    type = CoefConduction
    variable = T
    block = 0
  [../]
  [./QSource]
    type = QSource
    variable = T
    block = 0
  [../]
[]

[BCs]
  [./Periodic]
    [./PeriodicTopBottom]
      variable = T
      auto_direction = 'y z'
    [../]
  [../]
  [./left]
    type = DirichletBC
    variable = T
    boundary = left
    value = 373
  [../]
  [./right]
    type = NeumannBC
    variable = T
    boundary = right
    value = -0.00003
  [../]
[]

[Materials]
  [./HafniumAluminum]
    type = HfAlMaterial
    block = 0
    temperature = T
    RGB_aux_variable = RGB_aux_variable
    interface_cond = 0
  [../]
[]

[Postprocessors]
  [./SideAverageT]
    type = SideAverageValue
    variable = T
    boundary = right
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    off_diag_row = T
    off_diag_column = T
    full = true
  [../]
[]

[Executioner]
  type = Steady
  l_max_its = 100
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 31'
  l_tol = 1e-9
[]

[Adaptivity]
  cycles_per_step = 0
  initial_steps = 0
  marker = marker
  initial_marker = marker
  [./Indicators]
    [./indicator]
      type = GradientJumpIndicator
      variable = adapt_aux_variable
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
  [./MaterialExodus]
    output_material_properties = true
    file_base = ThermalExodus
    type = Exodus
  [../]
[]

[ICs]
  [./ConstantIC_T]
    variable = T
    type = ConstantIC
    value = 373
    block = 0
  [../]
  [./ImageFunctionIC_RGB]
    function = image_function
    variable = RGB_aux_variable
    type = FunctionIC
    block = 0
  [../]
  [./ImageFunctionIC_adapt]
    function = image_function
    variable = adapt_aux_variable
    type = FunctionIC
    block = 0
  [../]
[]

