local function table_size(table)
  local ret = 0
  for _, _ in pairs(table) do
    ret = ret + 1
  end
  return ret
end

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

local alignments_to_table = {
  ["AlignLeft"] = "l",
  ["AlignRight"] = "r",
  ["AlignCenter"] = "c",
  ["AlignDefault"] = "l"
}

local function process_row(row)
  local ret = {}
  local cnt = table_size(row.cells)
  for i, v in ipairs(row.cells) do
    ret[#ret + 1] = Writer.Blocks(v.content)
    if i ~= cnt then
      ret[#ret + 1] = [[ & ]]
    end
  end
  --TODO colspan rowspan alignment
  return ret
end
local function process_header_row(row)
  local ret = {}

  local cnt = table_size(row.cells)
  for i, v in ipairs(row.cells) do
    ret[#ret + 1] = Writer.Blocks(v.content)
    if i ~= cnt then
      ret[#ret + 1] = [[ & ]]
    end
  end
  --TODO colspan rowspan alignment
  return ret
end

local function flatten(item, result)
  local result = result or {}   --  create empty table, if none given during initialization
  if type(item) == 'table' then
    for k, v in pairs(item) do
      flatten(v, result)
    end
  else
    result[#result + 1] = item
  end
  return result
end

Writer.Block.Table = function(table)
  --TODO CAPTION!!!
  local ret = {}
  ret[#ret + 1] = [[\table{]]

  for _, v in pairs(table.colspecs) do
    ret[#ret + 1] = alignments_to_table[v[1]]
  end

  ret[#ret + 1] = [[}{]]

  local head_size = table_size(table.head.rows)
  for i, v in ipairs(table.head.rows) do
    ret[#ret + 1] = process_header_row(v)
    if i ~= head_size then
      ret[#ret + 1] = [[ \cr]]
    else
      ret[#ret + 1] = [[ \crli\tskip2pt]]
    end
    ret[#ret + 1] = pandoc.layout.cr
  end

  local bodies_size = table_size(table.bodies)
  for i, v in ipairs(table.bodies) do
    for ii, vv in ipairs(v.body) do
      ret[#ret + 1] = process_row(vv)
      ret[#ret + 1] = [[ \cr]]
      ret[#ret + 1] = pandoc.layout.cr
    end
  end


  ret[#ret + 1] = [[}]]
  return flatten(ret)
end

Writer.Inline.Image = function(image)
  return { [[\picw=\hsize\inspic{]], image.src, [[}]] }
end


Writer.Inline.RawInline = function(str)
  return str.text
end

Writer.Inline.Link = function(link)
  return { [[\ulink]], "[", link.target, "]", [[{]], Writer.Inlines(link.content), [[}]] }
end

