local function flatten(item, result)
  local result = result or {} --  create empty table, if none given during initialization
  if type(item) == 'table' then
    for k, v in pairs(item) do
      flatten(v, result)
    end
  else
    result[#result + 1] = item
  end
  return result
end

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

Writer.Inline.LineBreak = pandoc.layout.cr

Writer.Block.Para = function(para)
  return { Writer.Inlines(para.content), pandoc.layout.cr }
end

Writer.Block.RawBlock = function(rawBlock)
  return { rawBlock.text }
end

Writer.Inline.Code = function(code)
  return { [[\code{]], code.text, [[}]] }
end

local header_levels = {
  [1] = [[\chap ]],
  [2] = [[\sec ]],
  [3] = [[\secc ]],
  [4] = [[\seccc ]],
}

Writer.Block.Header = function(header)
  local ret
  if header.level <= #header_levels then
    ret = header_levels[header.level]
  else
    ret = {[[\secl]], header.level}
  end
  return flatten({
    ret,
    pandoc.layout.space,
    Writer.Inlines(header.content),
    pandoc.layout.blankline
  })
end

Writer.Block.BlockQuote = function(blockQuote)
  return { [[\begblock ]], Writer.Blocks(blockQuote.content), [[\endblock]] }
end

Writer.Block.CodeBlock = function(codeBlock)
  --print_r(codeBlock.classes)
  --local hmm = pandoc.utils.highlight(codeBlock)
  local ret = [[\begtt]]
  if #codeBlock.classes >= 1 then
    ret = ret .. [[\hisyntax{]] .. codeBlock.classes[1] .. [[}]]
  end
  return { ret, pandoc.layout.cr, codeBlock.text, pandoc.layout.cr, [[\endtt]] }
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


Writer.Inline.Space = pandoc.layout.space


local function group(str)
  return { [[{]], str, [[}]] }
end

Writer.Inline.Emph = function(str)
  return group([[\em ]] + Writer.Inlines(str.content))
end

Writer.Inline.Strong = function(str)
  return group([[\bf ]] + Writer.Inlines(str.content))
end

Writer.Inline.Strikeout = function(str)
  return { [[\cancel - {]], Writer.Inlines(str.content), [[}]] }
end


Writer.Inline.Underline = function(str)
  return { [[\underbar{]], Writer.Inlines(str.content), [[}]] }
end

Writer.Inline.Superscript = function(str)
  return { [[$^{]], Writer.Inlines(str.content), [[}$]] }
end

Writer.Inline.Subscript = function(str)
  return { [[$_{]], Writer.Inlines(str.content), [[}$]] }
end

Writer.Inline.SmallCaps = function(str)
  return group([[\caps ]] + Writer.Inlines(str.content))
end

Writer.Inline.Quoted = function(quoted)
  if quoted.quotetype == "DoubleQuote" then
    return { [[``]], Writer.Inlines(quoted.content), [['']] }
  else
    return { [[`]], Writer.Inlines(quoted.content), [[']] }
  end
end

Writer.Inline.Math = function(math)
  if math.mathtype == "InlineMath" then
    return { [[$]], math.text, [[$]] }
  else
    return { [[$$]], math.text, [[$$]] }
  end
end

Writer.Inline.Span = function(span)
  return { Writer.Inlines(span.content) }
end

Writer.Block.LineBlock = function(lineBlock)
  local ret = {}
  for i, v in ipairs(lineBlock.content) do
    ret[#ret + 1] = Writer.Inlines(v)
    if i ~= #lineBlock.content then
      ret[#ret + 1] = [[\hfil\break]]
      ret[#ret + 1] = pandoc.layout.cr
    end
  end
  ret[#ret + 1] = pandoc.layout.cr
  return ret
end

Writer.Block.DefinitionList = function(defList)
  local ret = {}
  for _, item in ipairs(defList.content) do
    local term = item[1]
    local defs = item[2]
    ret[#ret + 1] = [[{\bf ]]
    ret[#ret + 1] = Writer.Inlines(term)
    ret[#ret + 1] = [[}]]
    ret[#ret + 1] = pandoc.layout.cr
    for _, def in ipairs(defs) do
      ret[#ret + 1] = Writer.Blocks(def)
    end
    ret[#ret + 1] = pandoc.layout.blankline
  end
  return ret
end

Writer.Block.Div = function(div)
  return { Writer.Blocks(div.content) }
end

Writer.Inline.Note = function(note)
  local ret = {}
  ret[#ret + 1] = [[\fnote{]]
  local nOfContent = #ret
  for i, v in ipairs(note.content) do
    ret[#ret + 1] = Writer.Inlines(v.content)
    if i ~= nOfContent then
      ret[#ret + 1] = pandoc.layout.blankline
    end
  end
  -- return {[[\fnote{]], Writer.Blocks(note.content), [[}]]}
  ret[#ret + 1] = [[}]]
  return ret
end
