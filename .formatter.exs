# Used by "mix format"
locals_without_parens = []

[
  inputs: ["mix.exs", "{lib,test}/**/*.{ex,exs}"],
  import_deps: [:plug, :slash],
  locals_without_parens: locals_without_parens
]
