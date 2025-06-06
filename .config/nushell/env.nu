# ~/.config/nushell/env.nu
# Variables de entorno para Nushell

# ===== CONFIGURACIÓN DE FZF =====
# Migración de tu configuración de fzf
$env.FZF_DEFAULT_OPTS = "--layout=reverse --height=40% --border --margin=1 --padding=1"
$env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git"
$env.FZF_CTRL_T_COMMAND = $env.FZF_DEFAULT_COMMAND
$env.FZF_ALT_C_COMMAND = "fd --type d --hidden --follow --exclude .git"

# Configuración de colores para fzf (tema que combine con tu Kitty)
$env.FZF_DEFAULT_OPTS = $"($env.FZF_DEFAULT_OPTS) --color=bg:#24273A,bg+:#363A4F,spinner:#F4DBD6,hl:#96CDFB --color=fg:#CAD3F5,header:#96CDFB,info:#C6A0F6,pointer:#F4DBD6 --color=marker:#F4DBD6,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#96CDFB"

# ===== VARIABLES DE PATH =====  
# Configuración del PATH (agrega rutas que puedas necesitar)
$env.PATH = ($env.PATH | split row (char esep) | append [
    "/usr/local/bin"
    "~/.local/bin"
    "~/.cargo/bin"
    "~/.npm/bin"
] | uniq)

# ===== VARIABLES DE EDITOR =====
$env.EDITOR = "nvim"
$env.VISUAL = "nvim" 

# ===== CONFIGURACIÓN DE ZOXIDE =====
# Inicialización de zoxide para nushell
# INSTRUCCIONES: Ejecuta esto manualmente una vez:
# zoxide init nushell | save --force ~/.config/nushell/zoxide.nu

# Luego descomenta la siguiente línea:
source ~/.config/nushell/zoxide.nu

# Mientras tanto, inicializar zoxide directamente:
$env.config = ($env.config | default {} | upsert hooks {
    env_change: {
        PWD: [{|before, after|
            if (which zoxide | length) > 0 {
                ^zoxide add $after
            }
        }]
    }
})

# Alias para usar zoxide como cd
def --env z [path?: string] {
    if ($path | is-empty) {
        ^zoxide query --interactive | cd $in
    } else {
        ^zoxide query $path | cd $in
    }
}

# ===== CONFIGURACIÓN ESPECÍFICA DE ARCH LINUX =====
# Variables específicas para Arch Linux
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local" "share")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")

# ===== CONFIGURACIÓN DE COLORES =====
# Habilitar colores para varios comandos
$env.GREP_OPTIONS = "--color=auto"
$env.LESS = "-R"
$env.LESSOPEN = "| /usr/bin/highlight -O ansi %s 2>/dev/null"

# ===== CONFIGURACIÓN DE RUST/CARGO (útil para nushell) =====
$env.CARGO_HOME = "~/.cargo"
$env.RUSTUP_HOME = "~/.rustup"

# ===== CONFIGURACIÓN PARA CARAPACE =====
# Inicialización de carapace para completado avanzado
# Comentado hasta que instales carapace-bin desde AUR
# $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
# mkdir ~/.cache/carapace
# carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
# source ~/.cache/carapace/init.nu
