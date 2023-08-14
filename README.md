# Introduction

A drop-in replacement for `:make` and `:grep` that does not block the UI by
leveraging neovim's job control API.

# Installation

This plugin does not add any keybindings or user commands for you. It only
provides the `grep()` and `make()` functions, which you can bind to user
commands as you wish.

The following is an installation example for `lazy.nvim`:


```lua
{
  'msaher/makegrep-job.nvim',
  config = function()
    local mg = require('makegrep-job')
    local opts = {nargs = '*', complete = 'file'}

    vim.api.nvim_create_user_command('Grep', function(data)
        mg.grep(data.args, {})
    end, opts)

    vim.api.nvim_create_user_command('Lgrep', function(data)
        mg.grep(data.args, {loclist = true})
    end, opts)

    vim.api.nvim_create_user_command('Make', function(data)
        mg.make(data.args, {})
    end, opts)

    vim.api.nvim_create_user_command('Lmake', function(data)
        mg.make(data.args, {loclist = true})
    end, opts)

  end
},
```
