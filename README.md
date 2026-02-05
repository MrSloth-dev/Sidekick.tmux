# sidekick.tmux

Toggle AI coding assistants in tmux splits with session persistence.

Inspired by [sidekick.nvim](https://github.com/folke/sidekick.nvim) but outside of neovim.

## Features

- Toggle assistants on/off with a keybind
- Sessions persist when hidden (sent to background tmux session)
- fzf picker shows installed assistants

## Supported Assistants

claude, codex, aider, amazon_q, copilot, crush, cursor, gemini, grok, opencode, qwen

## Requirements

- tmux
- fzf
- At least one AI CLI installed

## Installation

### Manual

```bash
git clone https://github.com/yourusername/sidekick.tmux ~/.tmux/plugins/sidekick.tmux
```

Add keybindings to `~/.tmux.conf`:

```bash
bind-key -n F3 run-shell "~/.tmux/plugins/sidekick.tmux/scripts/assistants.sh"
```

### Tmux Plugin Manager

Add this to your `.tmux.conf` 
If you prefer, you can use the [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) instead of copying the snippet. When using TPM, add the following lines to your `.tmux.conf` (or `.tmux.conf.local` if you use oh-my-tmux):

``` bash
set -g @plugin 'MrSloth-dev/Sidekick.tmux'
```
## Usage

The default key is `F3`, in the future there will be configurable keybindings


## Roadmap

- [ ] Fix detection for non-claude assistants
- [ ] Support multiple instances of the same assistant
- [ ] Display project root directory in picker
- [ ] TPM integration with configurable keybindings

## License

MIT
