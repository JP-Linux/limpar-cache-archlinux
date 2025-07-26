# Limpar Cache Arch Linux

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live-brightgreen)](https://jp-linux.github.io)

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)

Um script Bash para gerenciar e limpar o cache do pacman no Arch Linux, mantendo o espaço em disco sob controle.

## 📋 Visão Geral

Este script automatiza a limpeza do cache de pacotes do pacman, verificando regularmente o espaço utilizado e oferecendo opções de limpeza quando o tamanho excede um limite configurável (6GB por padrão).

## ✨ Funcionalidades

- **Monitoramento inteligente**: Verifica automaticamente o espaço usado pelo cache do pacman
- **Limpeza segura**: Mantém a última versão de cada pacote e remove apenas arquivos não necessários
- **Gestão de órfãos**: Remove pacotes órfãos automaticamente
- **Interface amigável**: Exibe informações claras do sistema e do cache
- **Limite configurável**: Altere facilmente o tamanho máximo permitido para o cache

## ⚙️ Pré-requisitos

- Sistema Arch Linux (ou derivados)
- Bash 4.0+
- Pacman
- Pacman-contrib (para o `paccache`)

## 🚀 Como Usar

1. Faça o script executável:
```bash
chmod +x limpar-cache-archlinux.sh
```

2. Execute diretamente:
```bash
./limpar-cache-archlinux.sh
```

3. Siga as instruções interativas:
   - O script mostrará informações do sistema e do cache
   - Se o cache exceder o limite, perguntará sobre a limpeza
   - Digite `s` para limpar ou `n` para cancelar

## ⚡ Configuração

Edite o valor de `LIMITE_MB` no script para alterar o tamanho máximo do cache (em MB):

```bash
# Altere este valor para seu limite desejado
LIMITE_MB=6144  # 6GB = 6000MB
```

## 🧠 Comportamento do Script

Quando executado:
1. Verifica se está sendo executado como root (e previne execução)
2. Coleta informações do disco e do cache
3. Exibe status formatado com cores
4. Se o cache exceder o limite:
   - Mantém a última versão de cada pacote (`paccache -rk1`)
   - Remove pacotes não instalados (`pacman -Sc`)
   - Remove pacotes órfãos (`pacman -Rns $(pacman -Qdtq)`)
5. Mostra resumo pós-limpeza

## 💾 Saída de Exemplo

```
==============================================
 Informações do Sistema
==============================================
 • Tamanho do sistema:    250G
 • Espaço usado:          120G
 • Espaço disponível:      130G
 • Porcentagem de uso:     48%

==============================================
 Cache do Pacman (pacotes antigos)
==============================================
 • Total de pacotes:      142
 • Espaço usado:          6.2GB (6348MB)
 • Limite configurado:    6144MB (6GB)

ATENÇÃO: Cache ocupando 6.2GB (6348MB) > 6144MB
Deseja executar a limpeza? [s/N]: s

Iniciando limpeza...
Verificando pacotes órfãos...
Removendo pacotes órfãos:...
...
Limpeza concluída!
Novo espaço usado: 1.1GB (1124MB)

Operação concluída às 14:25:36
```

## ⚠️ Notas Importantes

- Não execute como root/sudo
- Recomendado para uso periódico (manual ou via cron)
- Sempre mantém a última versão dos pacotes para prevenir problemas
- Faz verificações antes de remover pacotes órfãos

## 📄 Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE) - veja o arquivo LICENSE.md para detalhes.

---

**Manter seu sistema limpo nunca foi tão fácil!** 🧹
