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


Writer.Block.Header = function(header)
  if header.level == 1 then
    return { [[\chap ]], Writer.Inlines(header.content), pandoc.layout.blankline }
  end
  if header.level == 2 then
    return { [[\sec ]], Writer.Inlines(header.content), pandoc.layout.blankline }
  end
  if header.level == 3 then
    return { [[\secc ]], Writer.Inlines(header.content), pandoc.layout.blankline }
  end
  if header.level == 4 then
    return { [[\seccc ]], Writer.Inlines(header.content), pandoc.layout.blankline }
  end
end

Writer.Block.BlockQuote = function(blockQuote)
  return { [[\begblock ]], Writer.Blocks(blockQuote.content), [[\endblock]] }
end

Writer.Block.CodeBlock = function(codeBlock)
  --print_r(codeBlock.classes)
  local ret = [[\begtt]]
  if #codeBlock.classes >= 1 then
    ret = ret .. [[\hisyntax{]] .. codeBlock.classes[1] .. [[}]]
  end
  return { ret, pandoc.layout.cr, codeBlock.text, [[\endtt]] }
end

Writer.Block.Plain = function(plain)
  return { Writer.Inlines(plain.content) }
end

Writer.Block.HorizontalRule = function(rule)
  return [[\hrule]]
end


Writer.Block.OrderedList = function(orderedList)
  local ret = {}
  ret[#ret + 1] = [[\begitems \style n]]
  ret[#ret + 1] = pandoc.layout.cr
  for _, v in ipairs(orderedList.content) do
    ret[#ret + 1] = [[* ]]
    ret[#ret + 1] = Writer.Blocks(v)
    ret[#ret + 1] = pandoc.layout.cr
  end
  ret[#ret + 1] = [[\enditems]]
  return ret
end

Writer.Block.BulletList = function(bulletList)
  local ret = {}
  ret[#ret + 1] = [[\begitems \style O]]
  ret[#ret + 1] = pandoc.layout.cr
  for _, v in ipairs(bulletList.content) do
    ret[#ret + 1] = [[* ]]
    ret[#ret + 1] = Writer.Blocks(v)
    ret[#ret + 1] = pandoc.layout.cr
  end
  ret[#ret + 1] = [[\enditems]]
  return ret
end

Writer.Block.Figure = function(figure)
  -- print_r(figure.content)
  --TODO CAPTION!!!
  return { Writer.Blocks(figure.content) }
end
