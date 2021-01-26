project('rayd-base', 'c', 'd',
  default_options: ['c_std=c99', 'default_library=static'],
)

cc = meson.get_compiler('c')
dc = meson.get_compiler('d')
is_debug = get_option('debug')
is_gdc = dc.get_id() == 'gcc'

d_args = []
d_debug = []
link_args = []
dependencies = []

if is_debug
  d_debug += 1
  if not is_gdc
    add_global_arguments('-gc', language: 'd')
  endif
else
  add_global_arguments( '-DNDEBUG', language: 'c')
  if not is_gdc
    add_global_arguments('--release', '--betterC', language: 'd')
  endif
endif

if is_gdc
  add_global_arguments('-fdiagnostics-color', language: 'd')
  link_language = 'd'
else
  add_global_arguments('--enable-color', language: 'd')
  link_language = meson.get_external_property('link_language', 'd')
endif

if host_machine.system() == 'emscripten'
  add_global_arguments('--mtriple=wasm32', '--output-bc', language: 'd')
  if is_debug
    link_args += [
      '-g4',
      '-s', 'ASSERTIONS=2',
    ]
  endif
  link_args += [
    '-s', 'ENVIRONMENT=web',
  ]
endif

gargula = subproject('gargula')

dependencies += [
  gargula.get_variable('gargula_dep'),
]

sources = files(
  'source/app.d',
  'source/constants.d',
  'source/menu.d',
  'source/shapes.d',
  'source/touch_input.d',
)

resources = files(
  'source/barra.png',
  'source/bola.png',
)

inc_dir = include_directories(
  'source',
  'lib/druntime/src',
)

foreach resource : resources
  res_target = configure_file(input: resource, output: '@PLAINNAME@', copy: true)
  if host_machine.system() == 'emscripten'
    # embed files in web build, or else textures cannot be opened
    link_args += ['--preload-file', '@0@'.format(res_target)]
  endif
endforeach

executable('rayd-base',
  sources,
  d_args: d_args,
  d_debug: d_debug,
  link_args: link_args,
  include_directories: inc_dir,
  dependencies: dependencies,
  link_language: link_language,
  name_suffix: meson.get_external_property('name_suffix', []),
)
