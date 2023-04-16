return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        --{
        --    "kyazdani42/nvim-web-devicons",
        --    opt = true
        --}
    },
    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'codedark',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {},
                always_divide_middle = true,
                globalstatus = false,
            },
            sections = {
                lualine_a = {
                    {
                        'mode',
                        icons_enabled = true
                    },
                },
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {
                    {
                        'filename',
                        file_status=true,
                        path=1,
                    }
                },
                lualine_x = {'hostname','encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            extensions = {}
        }
    end
}
