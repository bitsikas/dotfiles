lua << EOF
require('neorg').setup {
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          notes = "~/work/notes",
        },
        default_workspace = "notes",
      }
    }
    }
  }
EOF
