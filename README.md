<div align="center">

# ZahidvimUI

</div>

<div align="center">

[![License](https://img.shields.io/badge/LICENSE-GNU%20GPLv3%20-8C9EFF?style=for-the-badge)](https://mit-license.org/)

</div>

Lightweight & performant UI plugin providing the following :
+ Statusline & Statuscolumn via [heirline.nvim](https://github.com/rebelot/heirline.nvim)
    + Integrates w/ LSP diagnostics, Git, etc..
    + Various on_click functionality for UI components.
+ Global icons provider

## ⚡️ Prerequisites
+ Neovim v0.9.0+
+ [heirline.nvim](https://github.com/rebelot/heirline.nvim)

### Optional dependencies
+ [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
+ [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
+ [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)

ZahidvimUI works best with a modern terminal with [Truecolor](https://github.com/termstandard/colors) support. Optionally, you can install [Neovide](https://github.com/neovide/neovide) if you'd like a gui.

## 📦 Installation
Install the plugin with your preferred package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
    "zahidislm/zahidvim-ui.nvim",
    dependencies = {
        "rebelot/heirline.nvim",

        -- Optional dependencies
        "lewis6991/gitsigns.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
}
```
## ⚙️ Configuration

### Setup

ZahidvimUI comes with the following defaults:

```lua
{
    ui = {
        icons = {
            enable_nerdfont = false,
            enable_devicons = false,
            override = nil, -- any custom icons passed here
            setup_listchars = true,
        },
    },

    statusline = {
        enabled = true,
        enable_autocmds = true,
    },

    statuscolumn = {
        enabled = true,
    },
}
```
## 🎨 Colors

The table below shows all the highlight groups defined for ZahidvimUI.

| Highlight Group          |
| ------------------------ |
| _HeirlineSlant_          |
| _HeirlineSlantInv_       |
| _HeirlineSlantError_     |
| _HeirlineSlantWarn_      |
| _HeirlineSlantRuler_     |
| _HeirlineSlantInvMacro_  |
| _HeirlineGroup_          |
| _HeirlineGitAdded_       |
| _HeirlineGitChanged_     |
| _HeirlineGitRemoved_     |
| _HeirlineDiagError_      |
| _HeirlineDiagWarn_       |
| _HeirlineDiagHint_       |
| _HeirlineDiagInfo_       |
| _HeirlineRuler_          |
| _HeirlineMacro_          |

## 🙏 Credits

+ [Oli](https://github.com/olimorris): 95% of the Heirline config was inspired by his [neovim dotfiles](https://github.com/olimorris/dotfiles/tree/main/.config/nvim).
+ [Folke Lemaitre](https://github.com/folke): His plugins were a great reference into structuring my own.
