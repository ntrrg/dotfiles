vim.opt.history = 100
vim.opt.backup = false
vim.opt.autoread = true
vim.opt.encoding = 'utf-8'
vim.opt.fileformats = { 'unix', 'dos', 'mac' }
vim.opt.sessionoptions = vim.opt.sessionoptions:get()
vim.opt.sessionoptions:remove({ 'options', 'folds' })

--------------------------------------------------------------------------------
-- UI

vim.opt.colorcolumn = '81'
vim.opt.number = false
vim.opt.relativenumber = true
vim.opt.signcolumn = 'number'
vim.opt.ruler = true
vim.opt.laststatus = 2
vim.opt.mouse = 'a'
vim.opt.modeline = false
vim.opt.wildmenu = true
vim.opt.showcmd = true
vim.opt.updatetime = 500
--vim.opt.completeopt = { 'menu', 'popup' }
--vim.opt.completepopup = { align = 'menu', highlight = 'Pmenu' }
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.background = 'dark'
vim.api.nvim_set_hl(0, 'Normal', {})

-- Statusline

vim.api.nvim_set_hl(0, 'stNormal', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'stBuffNumber', { link = 'Number' })
vim.api.nvim_set_hl(0, 'stBuffName', { link = 'Title' })
vim.api.nvim_set_hl(0, 'stBuffPos', { link = 'Number' })
vim.api.nvim_set_hl(0, 'stBuffProps', { link = 'Function' })

local function render_statusline()
  local parts = {}

  table.insert(parts, '%#stNormal# ⬓')

  table.insert(parts, ' %#stBuffNumber#')
  local number = vim.api.nvim_get_current_buf()
  table.insert(parts, '[' .. number .. ']')
  table.insert(parts, '%#stNormal#')

  table.insert(parts, ' %#stBuffName#')
  local path = vim.api.nvim_buf_get_name(number)
  local name = vim.fn.fnamemodify(path, ':t')
  table.insert(parts, name)
  if vim.bo.modified then table.insert(parts, ' [+]') end
  table.insert(parts, '%#stNormal#')

  table.insert(parts, '%=')

  table.insert(parts, ' %#stBuffPos#')
  local col = vim.fn.col('.')
  table.insert(parts, vim.fn.line('.') .. ':' .. vim.fn.col('.'))
  local virtcol = vim.fn.virtcol('.')
  if virtcol ~= col then table.insert(parts, '-' .. virtcol) end
  local percent = vim.fn.line('w0') / vim.fn.line('$') * 100
  percent = math.floor(percent)
  table.insert(parts, ' ' .. percent .. '%%')
  table.insert(parts, '%#stNormal#')

  table.insert(parts, '%<')

  table.insert(parts, ' %#stBuffProps#')
  table.insert(parts, '| ' .. vim.bo.fileformat .. ' ')
  table.insert(parts, '| ' .. vim.bo.fileencoding .. ' ')
  local tabstyle = vim.bo.expandtab and 'S' or 'T'
  table.insert(parts, '| ' .. tabstyle .. ':' .. vim.bo.shiftwidth .. ' ')
  table.insert(parts, '| ' .. vim.bo.filetype .. ' ')
  table.insert(parts, '|%#stNormal# ')

  return table.concat(parts)
end

local statusline_group = vim.api.nvim_create_augroup('CustomStatusline', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'CursorHold', 'TextChanged' }, {
  group = statusline_group,

  callback = function()
    local window = vim.api.nvim_get_current_win()

    if vim.api.nvim_win_is_valid(window) then
      vim.opt_local.statusline = render_statusline()
    end
  end,
})

vim.opt.statusline = render_statusline()

--------------------------------------------------------------------------------
-- File formatting and editing

vim.opt.syntax = 'enable'
vim.g.netrw_sort_sequence = '[\\/],*,\\.[ao]$,.obj$,\\.info$,\\.swp$,\\.bak$,\\~$'
vim.opt.listchars = 'precedes:…,tab:-›,space:·,trail:·,extends:…,eol:¶'
vim.opt.wrap = false
vim.opt.autoindent = true
vim.opt.filetype = 'indent'
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.fixendofline = false

-- Type detection

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'go.mod',
  callback = function() vim.bo.filetype = 'gomod' end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'go.sum',
  callback = function() vim.bo.filetype = 'gosum' end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.astro',
  callback = function() vim.bo.filetype = 'astro' end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { 'Containerfile', '*.Containerfile' },
  callback = function() vim.bo.filetype = 'dockerfile' end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.gohtml',
  callback = function() vim.bo.filetype = 'gohtml' end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.gotmpl', '*.gotxt', '*.tmpl' },
  callback = function() vim.bo.filetype = 'gotmpl' end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.mdx', '*.slide' },
  callback = function() vim.bo.filetype = 'markdown' end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.svelte', '*.vue' },
  callback = function() vim.bo.filetype = 'html' end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.trigger',
  callback = function() vim.bo.filetype = 'sh' end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.zig', '*.zon' },
  callback = function() vim.bo.filetype = 'zig' end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.zir',
  callback = function() vim.bo.filetype = 'zir' end
})

-- Type settings

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp' },
  callback = function() vim.bo.expandtab = false end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'gomod', 'gosum' },
  callback = function() vim.bo.expandtab = false end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'make',
  callback = function() vim.bo.expandtab = false end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',

  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',

  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rst',

  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function() vim.bo.expandtab = false end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'zig', 'zir', 'zon' },

  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end
})

--------------------------------------------------------------------------------
-- Searching

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.magic = true

--------------------------------------------------------------------------------
-- Diagnostics

vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  virtual_lines = true,
  severity_sort = true,
  update_in_insert = false,
})

--------------------------------------------------------------------------------
-- Commands

local function remove_qf_item()
  local i = vim.fn.line('.')
  local qf = vim.fn.getqflist()

  table.remove(qf, i)
  vim.fn.setqflist(qf, 'r')
  vim.cmd(i + 1 .. 'cfirst')
  vim.cmd('copen')
end

vim.api.nvim_create_user_command('RemoveQFItem', remove_qf_item, {})

--------------------------------------------------------------------------------
-- Keys

vim.g.mapleader = ' '
vim.opt.backspace = { 'indent', 'eol', 'start' }

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',

  callback = function(event)
    vim.keymap.set('n', 'dd', ':RemoveQFItem<CR>', { buffer = true })
  end,
})

--------------------------------------------------------------------------------
-- LSP

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local buffer = args.buf

    vim.keymap.set('n', '<leader>ci', vim.lsp.buf.incoming_calls, {
      buffer = buffer,
      desc = 'List call sites',
    })

    vim.keymap.set('n', '<leader>co', vim.lsp.buf.outgoing_calls, {
      buffer = buffer,
      desc = 'List function calls',
    })

    vim.keymap.set('n', '<leader>D', vim.lsp.buf.definition, {
      buffer = buffer,
      desc = 'Go to definition',
    })

    vim.keymap.set('n', '<leader>f',
      function() vim.lsp.buf.format({ async = true }) end,
      { buffer = buffer, desc = 'Format buffer' }
    )

    vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, {
      buffer = buffer,
      desc = 'List implementations',
    })

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
      buffer = buffer,
      desc = 'Symbol information',
    })

    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {
      buffer = buffer,
      desc = 'Rename symbol',
    })

    vim.keymap.set('n', '<leader>R', vim.lsp.buf.references, {
      buffer = buffer,
      desc = 'List references',
    })

    vim.keymap.set('n', '<leader>s',
      function() vim.lsp.buf.document_symbol({ loclist = false }) end,
      { buffer = buffer, desc = 'List symbols in the current file' }
    )

    vim.keymap.set('n', '<leader>S', vim.lsp.buf.workspace_symbol, {
      buffer = buffer,
      desc = 'List symbols in the workspace',
    })

    vim.keymap.set('n', '<leader>T', vim.lsp.buf.type_definition, {
      buffer = buffer,
      desc = 'Go to type definition',
    })

    vim.keymap.set('n', '<leader>!', vim.lsp.buf.workspace_diagnostics, {
      buffer = buffer,
      desc = 'List workspace diagnostics',
    })

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      pattern = '*',
      callback = function() vim.lsp.buf.document_highlight() end
    })

    vim.api.nvim_create_autocmd('CursorMoved', {
      pattern = '*',
      callback = function() vim.lsp.buf.clear_references() end
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*',
      callback = function() vim.lsp.buf.format({ async = false }) end
    })
  end,
})

local lsp_servers = {
  gopls = { cmd = { 'gopls' }, filetypes = { 'go' } },
  pylsp = { cmd = { 'pylsp' }, filetypes = { 'python' } },
  zls = { cmd = { 'zls' }, filetypes = { 'zig' } },
}

for name, config in pairs(lsp_servers) do
  if vim.fn.executable(config.cmd[1]) == 1 then
    vim.lsp.config(name, config)
  end
end

vim.lsp.enable({ 'zls' })
