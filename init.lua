if vim.loader then
    vim.loader.enable()
end

_G.dd = function (...)
    require("config.debug")
end

-- Startup settings
require('config.config')

-- Lazy setup and plugins
require('config.lazy')

-- Theme modifications
require('config.theme')

-- Mapping of keys
require('config.bindings')

vim.cmd('colorscheme dracula')

vim.env.LANG = 'en_US.UTF-8'