# ~/.config/nushell/config.nu
# Configuración principal de Nushell

# ===== ALIASES =====
# Migración de tus aliases de bash (adaptados para nushell)
alias ll = ls -l      # ls largo (nushell nativo)
alias la = ls -a      # ls con archivos ocultos (nushell nativo)  
alias l = ls          # ls simple (nushell nativo)
alias g = git
alias v = nvim
alias c = clear
alias FUCKING = sudo
alias gh = cd ~
alias home = cd ~

# Para mantener compatibilidad con comandos externos cuando sea necesario
alias gnu-ls = ^ls --color=auto    # usar ls externo con ^
alias gnu-grep = ^grep --color=auto # usar grep externo con ^

# Aliases adicionales útiles para nushell
alias cat = bat  # mejor visualización con bat
alias find = fd  # fd es más rápido que find

# ===== CONFIGURACIÓN DEL PROMPT =====
# Prompt personalizado similar a tu PS1 de bash
$env.PROMPT_COMMAND = {|| 
    let user = (whoami)
    let hostname = ($env.HOSTNAME? | default "archlinux")
    $"[($user)@($hostname)]$ "
}


$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "::: "

# ===== CONFIGURACIÓN DE COMPLETADO =====
$env.config = {
    show_banner: false
    footer_mode: 25
    float_precision: 2
    use_ansi_coloring: true
    edit_mode: emacs
    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc9_9: false
        osc133: true
        osc633: true
        reset_application_mode: true
    }
    buffer_editor: "vim"
    
    # Configuración de completado (equivalente a tu bash-completion)
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"  # fuzzy matching como fzf
        external: {
            enable: true
            max_results: 100
            completer: null
        }
    }
    
    # Configuración de historial
    history: {
        max_size: 10000
        sync_on_enter: true
        file_format: "plaintext"
    }
    
    # Configuración de colores
    color_config: {
        separator: white
        leading_trailing_space_bg: { attr: n }
        header: green_bold
        empty: blue
        bool: white
        int: white
        filesize: white
        duration: white
        date: white
        range: white
        float: white
        string: white
        nothing: white
        binary: white
        cellpath: white
        row_index: green_bold
        record: white
        list: white
        block: white
        hints: dark_gray
    }
    
    # Keybindings personalizados
    keybindings: [
        # Ctrl+R para buscar en historial (como en bash con fzf)
        {
            name: fuzzy_history
            modifier: control
            keycode: char_r
            mode: [emacs, vi_normal, vi_insert]
            event: {
                send: ExecuteHostCommand
                cmd: "commandline edit --replace (history | get command | reverse | uniq | str join (char newline) | fzf --layout=reverse --height=40% | str trim)"
            }
        }
        # Ctrl+T para buscar archivos (equivalente a fzf Ctrl+T)
        {
            name: fuzzy_file
            modifier: control  
            keycode: char_t
            mode: [emacs, vi_normal, vi_insert]
            event: {
                send: ExecuteHostCommand
                cmd: "commandline edit --insert (fd --type f --hidden --follow --exclude .git | fzf --layout=reverse --height=40%)"
            }
        }
        # Alt+C para cambiar directorio (equivalente a fzf Alt+C)
        {
            name: fuzzy_cd
            modifier: alt
            keycode: char_c  
            mode: [emacs, vi_normal, vi_insert]
            event: {
                send: ExecuteHostCommand
                cmd: "let dir = (fd --type d --hidden --follow --exclude .git | fzf --layout=reverse --height=40%); if not ($dir | is-empty) { cd $dir }"
            }
        }
    ]
}

# ===== FUNCIONES PERSONALIZADAS =====
# Función para búsqueda fuzzy mejorada (reemplaza parte de fzf-tab)
def fzf-search [pattern?: string] {
    if ($pattern | is-empty) {
        ls | get name | str join (char newline) | fzf
    } else {
        ls | where name =~ $pattern | get name | str join (char newline) | fzf  
    }
}

# Función para git con fzf (útil para branches, etc)
def git-branch-fzf [] {
    git branch -a | lines | str trim | str replace '* ' '' | str replace 'remotes/origin/' '' | uniq | fzf | str trim
}

# ===== HOOKS =====
# Hook para zoxide (equivalente a eval "$(zoxide init bash)")
$env.config = ($env.config | upsert hooks {
    pre_prompt: [{ ||
        # Actualizar zoxide con el directorio actual
        null
    }]
    pre_execution: [{ ||
        null  
    }]
    env_change: {
        PWD: [{|before, after|
            # Registrar cambio de directorio en zoxide
            zoxide add $after
        }]
    }
})

# ===== CONFIGURACIÓN ESPECÍFICA PARA KITTY =====
# Configuración para mejor integración con Kitty terminal
if "TERM" in $env and ($env.TERM | str contains "kitty") {
    # Habilitar características específicas de Kitty
    $env.TERM_PROGRAM = "kitty"
}

fastfetch
source ~/.cache/oh-my-posh.nu