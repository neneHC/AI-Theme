# AI Theme — CoverFlow Moderno para Attract-Mode Plus

Layout em Squirrel (`layout.nut`) inspirado em interfaces modernas de consoles/launchers, com carrossel CoverFlow 3D dinâmico, reflexo no piso, barra superior de sistemas com pílula animada, fundo reativo com blur GLSL e barra inferior de legendas de controle.

## Instalação

1. Copie a pasta `AI Theme` para o diretório de layouts do Attract-Mode Plus:
   - **Linux:** `~/.attract/layouts/AI Theme/`
   - **Windows:** `<pasta_do_attractplus>\layouts\AI Theme\`
2. Abra o **Attract-Mode Plus**, acesse **Configurações → Telas (Displays)** e selecione **AI Theme** na opção **Layout** do seu display.

## Configuração de Artwork

Para o melhor resultado visual, configure os seguintes caminhos de artwork no seu emulador dentro do Attract-Mode Plus:

- **`boxart`** *(obrigatório/recomendado)*: Utilizado nas capas do carrossel CoverFlow 3D e nos reflexos. Caso um jogo não possua `boxart`, será exibida a capa padrão `assets/fallback_box.png`.
- **`fanart`** *(opcional/recomendado)*: Utilizado no plano de fundo dinâmico com desfoque (`shaders/blur.frag`). Caso não exista `fanart` para o jogo selecionado, o layout faz fallback automático para `boxart`, `flyer` ou `snap`.

## Opções do Layout

No menu de **Opções de Layout** dentro do Attract-Mode Plus:

- **Estilo dos Botões (`button_style`)**:
  - `PlayStation` *(padrão)*: Ícones circulares clássicos (`✕`, `◯`, `□`, `△`, `Share`, `Options`).
  - `Xbox`: Ícones circulares coloridos (`A`, `B`, `X`, `Y`, `View`, `Menu`).
- **Desfoque do Fundo (`blur_background`)**:
  - `Sim` *(padrão)*: Ativa o desfoque suave GLSL no fundo dinâmico.
  - `Não`: Desativa o desfoque e exibe a arte de fundo em resolução original e nitidez máxima.
- **Cor das Barras (`topbar_theme`)**:
  - `Rubi Console` *(padrão)*: Barra superior e rodapé em tom vermelho rubi/crimson vibrante.
  - `Cinza Escuro`: Barra superior e rodapé em tom grafite escuro minimalista.
  - `Azul Safira`: Barra superior e rodapé em tom azul escuro profundo.
  - `Verde Esmeralda`: Barra superior e rodapé em tom verde esmeralda elegante.

## Controles de Navegação de Displays (Menu Superior)

O menu superior funciona como um carrossel contínuo, mantendo o sistema ativo sempre centralizado na pílula branca. A alternância entre sistemas pode ser feita por:

- **Teclado:** `Q` (Sistema Anterior) / `W` (Próximo Sistema)
- **Joystick / Gamepad:** `L1` (Sistema Anterior) / `R1` ou `R2` (Próximo Sistema)
- **Sinais padrão:** `prev_display` e `next_display`

## Estrutura de Arquivos

```text
AI Theme/
├── layout.nut              # Código principal do layout em Squirrel
├── shaders/
│   ├── blur.frag           # Shader GLSL para desfoque do fundo
│   └── rounded_rect.frag   # Shader GLSL para pílula da barra superior e cantos
├── assets/
│   ├── fonts/              # font.ttf (Regular) e font_bold.ttf (Bold)
│   ├── buttons/
│   │   ├── xbox/           # a.png, b.png, x.png, y.png, select.png, start.png, lr.png
│   │   └── ps/             # a.png, b.png, x.png, y.png, select.png, start.png, lr.png
│   ├── pill_white.png      # 9-slice da pílula branca do menu superior
│   ├── topbar_capsule.png  # 9-slice das barras em cápsula (superior e rodapé)
│   └── fallback_box.png    # Capa padrão quando o jogo não possui artwork
└── README.md
```
