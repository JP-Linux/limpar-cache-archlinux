#!/usr/bin/env bash

# Configurações globais
PACMAN_CACHE_DIR="/var/cache/pacman/pkg/"
LIMITE_MB=6144  # 6GB = 6000MB

# Função robusta para obter informações do disco usando --output
get_info_disco() {
    df -h --output="$1" / | awk 'NR==2 {gsub(/^[[:space:]]+|[[:space:]]+$/, ""); print}'
}

# Carrega variáveis e calcula espaço em MB
carregar_variaveis() {
    # Informações do sistema
    tamanho_sistema=$(get_info_disco size)
    usado_sistema=$(get_info_disco used)
    espaco_disponivel=$(get_info_disco avail)
    porcentagem_uso=$(get_info_disco pcent)

    # Informações do cache
    quantidade_pkg=$(find "$PACMAN_CACHE_DIR" -maxdepth 1 -type f -printf '.' | wc -c)
    espaco_usado_mb=$(du -sm "$PACMAN_CACHE_DIR" | awk '{print $1}')

    # Formatando para exibição amigável
    if (( espaco_usado_mb >= 1024 )); then
        espaco_usado=$(awk "BEGIN {printf \"%.1fGB\", ${espaco_usado_mb}/1024}")
    else
        espaco_usado="${espaco_usado_mb}MB"
    fi
}

# Converte input para minúsculas
lower() {
    echo "${1,,}"
}

# Limpeza do cache com tratamento de erros
limpar_cache() {
    echo -e "\n\e[1mIniciando limpeza...\e[0m"

    # Manter apenas a última versão dos pacotes
    sudo paccache -rk1

    # Remover pacotes não instalados
    sudo pacman -Sc --noconfirm

    # Remover pacotes órfãos com verificação
    echo -e "\nVerificando pacotes órfãos..."
    local orfaos
    orfaos=$(pacman -Qdtq)

    if [[ -n "$orfaos" ]]; then
        echo "Removendo pacotes órfãos:"
        pacman -Qdt
        sudo pacman -Rns --noconfirm $(pacman -Qdtq)
    else
        echo "Nenhum pacote órfão encontrado."
    fi
}

# Verifica necessidade de limpeza
verif_necessidade_limpeza() {
    if (( espaco_usado_mb > LIMITE_MB )); then
        echo -e "\n\e[1;33mATENÇÃO:\e[0m Cache ocupando \e[1m${espaco_usado} (${espaco_usado_mb}MB)\e[0m > ${LIMITE_MB}MB"
        read -p "Deseja executar a limpeza? [s/N]: " -n 1 -r confirmacao
        echo

        confirmacao=$(lower "$confirmacao")
        [[ $confirmacao == [sy] ]] || return

        limpar_cache
        carregar_variaveis
        echo -e "\n\e[1;32mLimpeza concluída!\e[0m"
        echo -e "Novo espaço usado: \e[1m${espaco_usado} (${espaco_usado_mb}MB)\e[0m"
    else
        echo -e "\n\e[1;32mStatus OK:\e[0m Uso do cache dentro do limite (${espaco_usado_mb}MB)"
    fi
}

# Exibe informações formatadas
imprimir_info() {
    local barra="=============================================="
    local limite_gb=$((LIMITE_MB / 1024))

    echo -e "\n\e[1m${barra}"
    echo -e " Informações do Sistema"
    echo -e "${barra}\e[0m"
    printf " • Tamanho do sistema:    %s\n" "$tamanho_sistema"
    printf " • Espaço usado:          %s\n" "$usado_sistema"
    printf " • Espaço disponível:     %s\n" "$espaco_disponivel"
    printf " • Porcentagem de uso:    %s\n" "$porcentagem_uso"

    echo -e "\n\e[1m${barra}"
    echo -e " Cache do Pacman (pacotes antigos)"
    echo -e "${barra}\e[0m"
    printf " • Total de pacotes:      %d\n" "$quantidade_pkg"
    printf " • Espaço usado:          %s (%dMB)\n" "$espaco_usado" "$espaco_usado_mb"
    printf " • Limite configurado:    %dMB (%dGB)\n" "$LIMITE_MB" "$limite_gb"
}

# ----- Execução principal -----
# Verifica se é root
if (( EUID == 0 )); then
    echo "Erro: Não execute como root/sudo!" >&2
    exit 1
fi

carregar_variaveis
imprimir_info
verif_necessidade_limpeza

echo -e "\n\e[1mOperação concluída às $(date +%H:%M:%S)\e[0m"
