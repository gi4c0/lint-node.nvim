# node-lint.nvim
A very simple plugin for getting errors from `typescript`/`eslint` projects and places results in Telescope.
So basically it just takes a user's command (e.g. `npm run lint`), runs it in the background, parses the output and displays with the Telescope.

## Installation
*Packer:*
```lua
use {
    'gi4c0/lint-node.nvim',
    requires = {
        {'nvim-telescope/telescope.nvim'}
    }
}
```

## Configuration
```lua
    require("lint-node").setup({
        command = "npm run lint", -- or any other command
        key = "<leader>eL",
        debug = false
    })
```

* *command* - a terminal command that will be executed to find errors
* *key* - a key binding for opening Telescope and start the process
* *debug* - a flag to print logs for debugging purposes

Example of `package.json` with `eslint` npm script
```json

{
    "name": "your_project_name",
    "version": "1.0.0",
    "description": "",
    "main": "index.js",
    "scripts": {
        "build": "tsc",
        "eslint": "eslint --format json src/.",
        "lint": "npm run build; npm run lint"
    },
    "keywords": [],
    "author": "",
    "license": "ISC",
    "devDependencies": {
        "@types/node": "^20.2.5",
        "@typescript-eslint/eslint-plugin": "^5.59.7",
        "@typescript-eslint/parser": "^5.59.7",
        "eslint": "^8.41.0",
        "typescript": "^5.1.3"
    }
}
```

## Prerequisites
1. Obviously you need a [Telescope](https://github.com/nvim-telescope/telescope.nvim) (will be automatically installed if you copied the "installation" code).
2. In order for plugin to parse the eslint output you need to put `--format json` in the command. For example `eslint --format json src/.`

## Trouble shouting
If you encountered any problems please enable `debug` mode with flag `debug = true`, reproduce the issue, copy logs from `:messages<CR>` and create an issue with your logs and description of the error/problem.
