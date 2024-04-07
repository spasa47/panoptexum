Writer = pandoc.scaffolding.Writer


Writer.Inline.Str = function(str)
  return str.text
end


Writer.Inline.SoftBreak = function(_, opts)
  return pandoc.layout.space
end

Writer.Inline.LineBreak = pandoc.layout.space

Writer.Block.Para = function(para)
  return { Writer.Inlines(para.content), pandoc.layout.cr }
end

Writer.Block.RawBlock = function(rawBlock)
  return { rawBlock.text }
end

Writer.Inline.Code = function(code)
  return { [[\code{]], code.text, [[}]] }
end

