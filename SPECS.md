# Especificação de Projeto: Tema CoverFlow Moderno para Attract-Mode Plus

## 1. Objetivo
Desenvolver um layout completo e funcional (`layout.nut`) em linguagem **Squirrel** para o frontend **Attract-Mode Plus (AttractPlus)**, inspirado em interfaces modernas de consoles/launchers (estilo CoverFlow 3D dinâmico com barra superior de sistemas, fundo reativo com blur, reflexo no piso e barra inferior de legendas de controle).

---

## 2. Arquitetura Visual e Layout (Resolução Base: 1920x1080)

Utilizar coordenadas responsivas baseadas em `fe.layout.width` e `fe.layout.height` para garantir compatibilidade com resoluções 16:9 (1080p, 720p, 4K) e 16:10 (Steam Deck 1280x800).

### 2.1. Plano de Fundo (Background & Ambiente)
* **Fundo Dinâmico:** Utilizar a fanart (`fanart`) ou boxart (`boxart` / `flyer`) do jogo selecionado em tela cheia, com efeito de **Blur (desfoque)** suave (usando shaders GLSL nativos do AttractPlus ou `fe.add_surface` em baixa resolução esticada) e escurecimento (`alpha` ou overlay gradiente escuro) para destacar as capas e textos.
* **Piso Reflexivo:** Um gradiente escuro na metade inferior da tela simulando um piso reflexivo onde as caixas dos jogos projetam um reflexo invertido sutil (`alpha = 40` a `60`, com gradiente de fade-out vertical).

### 2.2. Barra Superior — Seletor de Sistemas (Displays Menu)
* **Posição:** Topo da tela (`y = 3%` da altura), centralizado horizontalmente.
* **Comportamento Dinâmico (Auto-ajuste):**
  * Ler a lista de displays configurados no AttractPlus (`fe.displays`).
  * Calcular dinamicamente a largura total dos itens de texto com base na quantidade de sistemas disponíveis (filtrando displays ocultos/menus se aplicável) para que todos os nomes caibam confortavelmente ou façam scroll suave centralizado se excederem `90%` da largura da tela.
  * Ajustar automaticamente o espaçamento (`padding`) e o tamanho da fonte conforme o número de sistemas.
* **Estilo Visual:**
  * **Sistema Inativo:** Texto limpo, sem fundo, cor cinza-claro (`RGB: 180, 180, 180`), `alpha = 180`.
  * **Sistema Ativo (Selecionado):** Texto dentro de uma pílula branca arredondada (`pill shape` com bordas arredondadas via shader ou textura 9-slice), fundo branco sólido (`RGB: 255, 255, 255`) e texto em cor escura (`RGB: 20, 20, 25`) em negrito.
* **Interação:** Permitir alternar entre os sistemas (ex: via teclas/botões configurados para `prev_display` / `next_display` ou gatilhos LB/RB) atualizando a pílula ativa com animação suave (`tween`).

### 2.3. Área Central — Carrossel CoverFlow 3D de Capas
* **Módulo Recomendado:** Utilizar o módulo `conveyor` do AttractPlus (`fe.load_module("conveyor")`) ou implementar um sistema customizado baseado em `fe.add_artwork("boxart")` (com fallback para `"flyer"` ou `"snap"`) com interpolação suave (`animate` / `tick`).
* **Lógica Espacial e Perspectiva (Fiel à Referência):**
  * **Item Central (Selecionado - Índice 0):**
    * Totalmente de frente para o usuário (`skew_y = 0`, `pinch_y = 0`, rotação 0°).
    * Maior escala (`1.0x`), centralizado em `x = 50%`, `y = 46%`.
    * Destaque máximo (`brightness = 255`, `z-order` mais alto).
    * **Reflexo:** Cópia invertida verticalmente (`height = -altura_original * 0.45`) posicionada logo abaixo da base da capa com baixa opacidade.
  * **Itens à Esquerda (Índices -1, -2, -3...):**
    * Angulados em perspectiva voltados para a direita (abrindo para o centro), utilizando manipulação de vértices (`subimg` / `skew_y` / `pinch_y` ou shader de perspectiva 3D).
    * Escala reduzida (`~0.75x`), posicionados à esquerda do centro com sobreposição parcial estilo estante/prateleira (`overlap`), onde o item `-1` fica mais próximo e parcialmente visível de frente/ângulo e os demais (`-2`, `-3`) mostram mais a lombada/ângulo fechado.
    * **Reflexo:** Cada capa lateral também deve possuir seu reflexo correspondente no piso.
  * **Itens à Direita (Índices +1, +2, +3...):**
    * Espelhamento exato do lado esquerdo, porém angulados em perspectiva voltados para a esquerda (abrindo para o centro).
    * Escala reduzida (`~0.75x`), empilhados progressivamente para a direita (`+1` mais aberto, `+2`, `+3`, `+4` mais fechados em perspectiva de estante).
  * **Transição Dinâmica:** Ao navegar (`next_game` / `prev_game`), as capas devem interpolar suavemente posição, escala, perspectiva (`skew`/`pinch`) e `z-order`, virando de frente ao chegar ao centro e inclinando-se para o lado oposto ao sair do centro.

### 2.4. Metadados do Jogo Selecionado (Abaixo da Capa Central)
* **Título do Jogo (`[Title]`):** Centralizado abaixo da capa principal (`y = 77%`), fonte sans-serif moderna, branca, negrito, tamanho grande (`~36px` em 1080p), com sombra projetada suave.
* **Subtítulo / Informação Extra (`[Category]` ou `[Manufacturer]` / `[Year]`):** Logo abaixo do título (`y = 82%`), fonte menor (`~18px`), cor cinza-claro (`RGB: 200, 200, 200`), em caixa alta.

### 2.5. Rodapé — Barra de Legendas de Botões (Footer)
* **Posição:** Base da tela (`y = 92%` a `97%`), ocupando `100%` da largura com uma faixa escura translúcida (`RGBA: 15, 15, 20, 210`) e uma linha divisória superior sutil (`1px`, `RGBA: 255, 255, 255, 30`).
* **Itens e Mapeamento Obrigatório (Distribuídos horizontalmente e centralizados):**
  1. **Botão A:** `Iniciar`
  2. **Botão B:** `Sair`
  3. **Botão X:** `Pesquisar`
  4. **Botão Y:** `Info`
  5. **Botão Select:** `Configurações`
  6. **Botão Start:** `Mídias`
* **Alternância de Ícones (Xbox vs. PlayStation):**
  * Criar uma opção configurável no menu de opções do layout (`UserConfig`):
    ```squirrel
    class UserConfig {
        </ label="Estilo dos Botões", help="Escolha o padrão visual dos ícones no rodapé", options="Xbox,PlayStation", order=1 />
        button_style = "Xbox";
    }
    ```
  * **Modo Xbox:** Ícones circulares com letras/cores características (`A` verde/branco, `B` vermelho/branco, `X` azul/branco, `Y` amarelo/branco, `Select/View` ícones de janelas, `Start/Menu` ícone de três linhas).
  * **Modo PlayStation:** Ícones circulares com símbolos clássicos (`Cruz / X` azul, `Círculo / O` vermelho, `Quadrado` rosa, `Triângulo` verde, `Select/Share`, `Start/Options`).
  * *Nota:* Desenhar os ícones vetorialmente via código/canvas ou gerar sprites limpos em alta resolução na pasta `assets/buttons/xbox/` e `assets/buttons/ps/` para garantir nitidez absoluta em qualquer resolução.

---

## 3. Estrutura de Arquivos Esperada

```text
/tema-coverflow/
├── layout.nut              # Código principal do layout em Squirrel
├── shaders/
│   ├── blur.frag           # Shader GLSL para desfoque do fundo
│   └── rounded_rect.frag   # Shader GLSL para pílula da barra superior e cantos
├── assets/
│   ├── buttons/
│   │   ├── xbox/           # a.png, b.png, x.png, y.png, select.png, start.png
│   │   └── ps/             # a.png (cross), b.png (circle), x.png (square), y.png (triangle), select.png, start.png
│   └── fallback_box.png    # Capa padrão caso o jogo não possua artwork
└── README.md               # Instruções de instalação e configuração de artwork