Writer = pandoc.scaffolding.Writer


Writer.Inline.Str = function(str)
  return str.text
end

