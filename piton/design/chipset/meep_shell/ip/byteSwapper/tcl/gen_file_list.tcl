# Be careful about the white lines after the backslash

set files [list \
  [file normalize "${g_root_dir}/src/endianess_swapper_top.sv"] \
  [file normalize "${g_root_dir}/src/nibbleSwapper.v"] \
]
add_files $files



