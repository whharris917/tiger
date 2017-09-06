[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 55
  ny = 55
  nz = 55
  xmax = 150
  ymax = 150
  zmax = 150
[]

[MeshModifiers]
  [./AddExtraNodeset]
    type = AddExtraNodeset
    new_boundary = CenterNode
    coord = '0 0 0'
  [../]
[]

[Variables]
  [./T]
    block = 0
  [../]
  [./Chi_X]
    block = 0
  [../]
  [./Chi_Y]
    block = 0
  [../]
  [./Chi_Z]
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
    origin = '0 0 0'
    component = 0
    file_suffix = png
    file_base = Image
    dimensions = '150 150 150'
  [../]
[]

[Kernels]
  [./CoefConductionChi_X]
    type = CoefConduction
    variable = Chi_X
    block = 0
  [../]
  [./CoefConductionChi_Y]
    type = CoefConduction
    variable = Chi_Y
    block = 0
  [../]
  [./HomogenizationChi_X]
    type = HeatCondHomogenizationKernel
    variable = Chi_X
    component = 0
    block = 0
  [../]
  [./HomogenizationChi_Y]
    type = HeatCondHomogenizationKernel
    variable = Chi_Y
    component = 1
    block = 0
  [../]
  [./CoefConductionT]
    type = CoefConduction
    variable = T
    block = 0
  [../]
  [./CoefConductionChi_Z]
    type = CoefConduction
    variable = Chi_Z
    block = 0
  [../]
  [./HomogenizationChi_Z]
    type = HeatCondHomogenizationKernel
    variable = Chi_Z
    component = 2
    block = 0
  [../]
[]

[BCs]
  [./Periodic]
    [./PeriodicBCs]
      variable = 'Chi_X Chi_Y Chi_Z'
      auto_direction = 'x y z'
    [../]
  [../]
  [./FixChi_X]
    type = PresetBC
    variable = Chi_X
    boundary = CenterNode
    value = 373
  [../]
  [./FixChi_Y]
    type = PresetBC
    variable = Chi_Y
    boundary = CenterNode
    value = 373
  [../]
  [./FixChi_Z]
    type = PresetBC
    variable = Chi_Z
    boundary = CenterNode
    value = 373
  [../]
[]

[Materials]
  [./HafniumAluminum]
    type = HfAlMaterial
    block = 0
    temperature = T
    RGB_aux_variable = RGB_aux_variable
  [../]
[]

[Postprocessors]
  [./k_xx]
    type = HomogenizedThermalConductivity
    variable = Chi_X
    component = 0
    temp_y = Chi_Y
    temp_x = Chi_X
    temp_z = Chi_Z
    diffusion_coefficient_name = conductivity
  [../]
  [./k_yy]
    type = HomogenizedThermalConductivity
    variable = Chi_Y
    component = 1
    temp_y = Chi_Y
    temp_x = Chi_X
    temp_z = Chi_Z
    diffusion_coefficient_name = conductivity
  [../]
  [./k_zz]
    type = HomogenizedThermalConductivity
    variable = Chi_Z
    component = 2
    temp_y = Chi_Y
    temp_x = Chi_X
    temp_z = Chi_Z
    diffusion_coefficient_name = conductivity
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    off_diag_row = 'Chi_X Chi_Y'
    off_diag_column = 'Chi_Y Chi_X'
  [../]
[]

[Problem]
  type = FEProblem
[]

[Executioner]
  type = Steady
  l_max_its = 15
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 31'
  l_tol = 1e-9
[]

[Adaptivity]
  cycles_per_step = 0
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
    file_base = 3DHomogenizedKMaterialExodus
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

