return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {"nvim-tree/nvim-web-devicons"},
	cmd = "NvimTreeToggle",
	-- as:"nvim-tree",
	--config = true,
	config = function()
		require("nvim-tree").setup({
		    auto_reload_on_write = true,
		    sort_by = "case_sensitive",
		    view = {
			adaptive_size = true,
			width = 30,
			-- height = 30,
			side = "right",
			mappings = {
			    list = {
				{ key = "u", action = "dir_up", mode = "n" },
				{ key = "t", action = "tabnew", mode = "n" }
			    },
			},
		    },
		    renderer = {
			group_empty = true,
		    },
		    filters = {
			dotfiles = false,
		    },
		})
	end
}
