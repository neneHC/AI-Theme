///////////////////////////////////////////////////////////
//
// AI Theme - CoverFlow Moderno para Attract-Mode Plus
// Base Resolution: 1920x1080 (Responsive 16:9 & 16:10)
//
///////////////////////////////////////////////////////////

class UserConfig {
    </ label="Estilo dos Botões", help="Escolha o padrão visual dos ícones no rodapé", options="PlayStation,Xbox", order=1 />
    button_style = "PlayStation";

    </ label="Desfoque do Fundo", help="Ativar ou desativar o efeito de blur no plano de fundo", options="Sim,Não", order=2 />
    blur_background = "Sim";

    </ label="Cor das Barras (Superior e Rodapé)", help="Escolha o estilo de cor das barras superior e inferior", options="Rubi Console,Cinza Escuro,Azul Safira,Verde Esmeralda", order=3 />
    topbar_theme = "Rubi Console";
}

fe.load_module("conveyor");

// Responsive layout sizing matched to actual screen resolution
fe.layout.width = ScreenWidth;
fe.layout.height = ScreenHeight;

local flw = fe.layout.width;
local flh = fe.layout.height;
local scale = flh / 1080.0;
local my_config = fe.get_config();

local FONT_REGULAR = "assets/fonts/font.ttf";
local FONT_BOLD = "assets/fonts/font_bold.ttf";

// Theme color configuration (applied to top bar, game counter badge, and footer)
local theme_r = 180;
local theme_g = 32;
local theme_b = 74;
local theme_a = 250;

local theme_choice = ("topbar_theme" in my_config) ? my_config["topbar_theme"] : "Rubi Console";
if (theme_choice == "Cinza Escuro") {
    theme_r = 50;
    theme_g = 54;
    theme_b = 68;
    theme_a = 250;
} else if (theme_choice == "Azul Safira") {
    theme_r = 28;
    theme_g = 78;
    theme_b = 175;
    theme_a = 250;
} else if (theme_choice == "Verde Esmeralda") {
    theme_r = 24;
    theme_g = 135;
    theme_b = 92;
    theme_a = 250;
} else {
    // Rubi Console (default)
    theme_r = 180;
    theme_g = 32;
    theme_b = 74;
    theme_a = 250;
}

// Blur background config check
local blur_enabled = true;
if ("blur_background" in my_config) {
    local val = my_config["blur_background"].tolower();
    if (val == "nao" || val == "não" || val == "no" || val == "desativado" || val == "false" || val == "0") {
        blur_enabled = false;
    }
}

// =========================================================
// 1. PLANO DE FUNDO DINÂMICO & PISO REFLEXIVO
// =========================================================

// Base dark backdrop
local bg_base = fe.add_rectangle(0, 0, flw, flh);
bg_base.set_rgb(10, 10, 14);
bg_base.zorder = 0;

// High-res crisp background (used when blur is disabled)
local bg_full_fanart = fe.add_artwork("fanart", 0, 0, flw, flh);
bg_full_fanart.preserve_aspect_ratio = false;
bg_full_fanart.zorder = 1;

local bg_full_boxart = fe.add_artwork("boxart", 0, 0, flw, flh);
bg_full_boxart.preserve_aspect_ratio = false;
bg_full_boxart.zorder = 1;

local bg_full_flyer = fe.add_artwork("flyer", 0, 0, flw, flh);
bg_full_flyer.preserve_aspect_ratio = false;
bg_full_flyer.zorder = 1;

local bg_full_snap = fe.add_artwork("snap", 0, 0, flw, flh);
bg_full_snap.preserve_aspect_ratio = false;
bg_full_snap.zorder = 1;

// Low-res surface for smooth GPU ambient blur (used when blur is enabled)
local bg_surf = fe.add_surface(320, 180);
bg_surf.set_pos(0, 0, flw, flh);
bg_surf.zorder = 1;

local bg_fanart = bg_surf.add_artwork("fanart", 0, 0, 320, 180);
bg_fanart.preserve_aspect_ratio = false;

local bg_boxart = bg_surf.add_artwork("boxart", 0, 0, 320, 180);
bg_boxart.preserve_aspect_ratio = false;

local bg_flyer = bg_surf.add_artwork("flyer", 0, 0, 320, 180);
bg_flyer.preserve_aspect_ratio = false;

local bg_snap = bg_surf.add_artwork("snap", 0, 0, 320, 180);
bg_snap.preserve_aspect_ratio = false;

local blur_shader = null;
if (blur_enabled) {
    blur_shader = fe.add_shader(Shader.Fragment, "shaders/blur.frag");
    blur_shader.set_param("texel_offset", 0.008, 0.008);
    bg_surf.shader = blur_shader;
} else {
    bg_surf.visible = false;
}

local function update_background_source() {
    if (blur_enabled) {
        bg_surf.visible = true;
        bg_full_fanart.visible = false;
        bg_full_boxart.visible = false;
        bg_full_flyer.visible = false;
        bg_full_snap.visible = false;

        bg_fanart.visible = false;
        bg_boxart.visible = false;
        bg_flyer.visible = false;
        bg_snap.visible = false;

        if (bg_fanart.file_name != "") {
            bg_fanart.visible = true;
        } else if (bg_boxart.file_name != "") {
            bg_boxart.visible = true;
        } else if (bg_flyer.file_name != "") {
            bg_flyer.visible = true;
        } else if (bg_snap.file_name != "") {
            bg_snap.visible = true;
        }
    } else {
        bg_surf.visible = false;
        bg_fanart.visible = false;
        bg_boxart.visible = false;
        bg_flyer.visible = false;
        bg_snap.visible = false;

        bg_full_fanart.visible = false;
        bg_full_boxart.visible = false;
        bg_full_flyer.visible = false;
        bg_full_snap.visible = false;

        if (bg_full_fanart.file_name != "") {
            bg_full_fanart.visible = true;
        } else if (bg_full_boxart.file_name != "") {
            bg_full_boxart.visible = true;
        } else if (bg_full_flyer.file_name != "") {
            bg_full_flyer.visible = true;
        } else if (bg_full_snap.file_name != "") {
            bg_full_snap.visible = true;
        }
    }
}
update_background_source();

// Ambient darkening overlay so covers and typography stand out
local bg_dim = fe.add_rectangle(0, 0, flw, flh);
bg_dim.set_rgb(10, 10, 14);
bg_dim.alpha = blur_enabled ? 140 : 130;
bg_dim.zorder = 2;

// Reflective floor gradient overlay
local floor_y = flh * 0.56;
local floor_h = flh - floor_y;
local floor_grad = fe.add_surface(1, 128);
floor_grad.set_pos(0, floor_y, flw, floor_h);
floor_grad.zorder = 16;

for (local i = 0; i < 128; i++) {
    local t = i.tofloat() / 127.0;
    local a = (t * t * (3.0 - 2.0 * t)) * 242.0;
    local band = floor_grad.add_rectangle(0, i, 1, 1);
    band.set_rgb(10, 10, 14);
    band.alpha = a.tointeger();
}

// =========================================================
// 2. BARRA SUPERIOR — CARROSSEL SELETOR DE SISTEMAS
// =========================================================

local top_bar_y = flh * 0.026;
local bar_w = flw * 0.92;
local bar_h = (44.0 * scale).tointeger();
if (bar_h < 38) bar_h = 38;
local pill_h = (34.0 * scale).tointeger();
if (pill_h < 30) pill_h = 30;
local bar_x = (flw - bar_w) * 0.5;

// Collect visible displays
local visible_displays = [];
foreach (idx, d in fe.displays) {
    local show_d = true;
    if ("in_menu" in d) {
        show_d = d.in_menu;
    }
    if (show_d) {
        visible_displays.push({ index = idx, name = d.name });
    }
}
if (visible_displays.len() == 0) {
    foreach (idx, d in fe.displays) {
        visible_displays.push({ index = idx, name = d.name });
    }
}

local n_disp = visible_displays.len();
local disp_font_sz = (20.0 * scale).tointeger();
if (disp_font_sz < 17) disp_font_sz = 17;

// Generous width calculation with ample padding so the pill covers the whole label
local char_w = disp_font_sz * 0.72;
local h_pad = 48.0 * scale;
if (h_pad < 36.0) h_pad = 36.0;

local disp_items = [];
local max_label_w = 0.0;

foreach (i, item in visible_displays) {
    local w_est = (item.name.len() * char_w) + h_pad;
    if (w_est < 112.0 * scale) w_est = 112.0 * scale;
    if (w_est < 95.0) w_est = 95.0;
    if (w_est > max_label_w) max_label_w = w_est;
    disp_items.push({
        disp_index = item.index,
        name = item.name,
        w = w_est,
        text_obj = null
    });
}

// Carousel item spacing (distance between system centers)
local slot_spacing = max_label_w + (22.0 * scale);
if (slot_spacing < 145.0 * scale) slot_spacing = 145.0 * scale;
if (slot_spacing < 125.0) slot_spacing = 125.0;

// Boost top bar brightness slightly so it never looks darker than the footer/badges
local top_r = (theme_r * 1.15).tointeger();
if (top_r > 255) top_r = 255;
local top_g = (theme_g * 1.15).tointeger();
if (top_g > 255) top_g = 255;
local top_b = (theme_b * 1.15).tointeger();
if (top_b > 255) top_b = 255;

// Top bar 9-slice capsule background (visible, elegant, matches reference photo)
local top_bg = fe.add_image("assets/topbar_capsule.png", bar_x, top_bar_y, bar_w, bar_h);
top_bg.set_border(32, 31, 32, 31);
top_bg.zorder = 60;
top_bg.set_rgb(top_r, top_g, top_b);
top_bg.alpha = 255;

// Clipped viewport surface for the carousel items + active pill
local top_view_surf = fe.add_surface(bar_w.tointeger(), bar_h);
top_view_surf.set_pos(bar_x, top_bar_y, bar_w.tointeger(), bar_h);
top_view_surf.zorder = 61;

// Active white pill inside top_view_surf (true 9-slice with anti-aliased rounded circular ends)
local pill_img = top_view_surf.add_image("assets/pill_white.png", 0, (bar_h - pill_h) * 0.5, 120, pill_h);
pill_img.set_border(32, 31, 32, 31);
pill_img.zorder = 61;
pill_img.set_rgb(255, 255, 255);
pill_img.alpha = 255;

// Create text objects for each display
foreach (i, item in disp_items) {
    local t = top_view_surf.add_text(item.name, 0, (bar_h - pill_h) * 0.5, item.w, pill_h);
    t.font = FONT_REGULAR;
    t.charsize = disp_font_sz;
    t.align = Align.Centre;
    t.set_rgb(255, 255, 255);
    t.alpha = 215;
    t.zorder = 62;
    item.text_obj = t;
}

// Carousel animation coordinates
local active_disp_pos = 0;
local carousel_curr_pos = 0.0;
local carousel_target_pos = 0.0;
local pill_curr_w = 120.0;
local pill_targ_w = 120.0;

local function get_active_pos_from_fe() {
    local curr_idx = fe.list.display_index;
    foreach (i, item in disp_items) {
        if (item.disp_index == curr_idx) {
            return i;
        }
    }
    local curr_name = fe.list.name;
    foreach (i, item in disp_items) {
        if (item.name == curr_name) {
            return i;
        }
    }
    return 0;
}

local function apply_carousel_positions() {
    local center_screen_x = bar_w * 0.5;
    local half_bar = bar_w * 0.5;

    // Position the active white pill at the center
    pill_img.x = center_screen_x - (pill_curr_w * 0.5);
    pill_img.width = pill_curr_w;

    // Position each system label relative to the animated carousel_curr_pos
    foreach (i, item in disp_items) {
        local diff = (i.tofloat() - carousel_curr_pos);

        // Circular wrap around n_disp
        if (n_disp > 1) {
            while (diff > (n_disp.tofloat() * 0.5)) diff -= n_disp.tofloat();
            while (diff < -(n_disp.tofloat() * 0.5)) diff += n_disp.tofloat();
        }

        local item_cx = center_screen_x + (diff * slot_spacing);
        local item_x = item_cx - (item.w * 0.5);
        item.text_obj.x = item_x;
        item.text_obj.width = item.w;

        local dist_from_center = fabs(diff * slot_spacing);

        // Hide items outside viewport
        if (dist_from_center > (half_bar + (item.w * 0.5))) {
            item.text_obj.visible = false;
        } else {
            item.text_obj.visible = true;

            // Proximity to center: inside pill (center) vs outside
            local is_active = (fabs(diff) < 0.45);
            if (is_active) {
                // Active item inside white pill
                item.text_obj.font = FONT_BOLD;
                item.text_obj.set_rgb(20, 20, 25);
                item.text_obj.alpha = 255;
            } else {
                // Inactive items on the bar
                item.text_obj.font = FONT_REGULAR;
                item.text_obj.set_rgb(255, 255, 255);
                local edge_fade = 1.0 - (dist_from_center / half_bar);
                if (edge_fade < 0.25) edge_fade = 0.25;
                item.text_obj.alpha = (edge_fade * 215.0).tointeger();
            }
        }
    }
}

local function sync_top_bar(immediate) {
    active_disp_pos = get_active_pos_from_fe();
    pill_targ_w = disp_items[active_disp_pos].w;

    local has_from = false;
    local from_p = 0;
    try {
        if ("from_disp_pos" in fe.layout.nv) {
            from_p = fe.layout.nv.from_disp_pos;
            delete fe.layout.nv.from_disp_pos;
            has_from = true;
        }
    } catch (e) {}

    if (has_from && from_p >= 0 && from_p < n_disp) {
        // Start smoothly at the previous position and tween to the new active display
        carousel_curr_pos = from_p.tofloat();
        pill_curr_w = disp_items[from_p].w;

        local delta = (active_disp_pos.tofloat() - carousel_curr_pos);
        if (n_disp > 1) {
            while (delta > (n_disp.tofloat() * 0.5)) delta -= n_disp.tofloat();
            while (delta < -(n_disp.tofloat() * 0.5)) delta += n_disp.tofloat();
        }
        carousel_target_pos = carousel_curr_pos + delta;
    } else if (immediate) {
        carousel_curr_pos = active_disp_pos.tofloat();
        carousel_target_pos = carousel_curr_pos;
        pill_curr_w = pill_targ_w;
    } else {
        local delta = (active_disp_pos.tofloat() - carousel_target_pos);
        if (n_disp > 1) {
            while (delta > (n_disp.tofloat() * 0.5)) delta -= n_disp.tofloat();
            while (delta < -(n_disp.tofloat() * 0.5)) delta += n_disp.tofloat();
        }
        carousel_target_pos += delta;
    }
    apply_carousel_positions();
}

sync_top_bar(false);

// Switching functions for carousel navigation
function next_system() {
    if (n_disp <= 1) return;
    local curr_pos = get_active_pos_from_fe();
    local next_pos = (curr_pos + 1) % n_disp;
    try {
        fe.layout.nv.from_disp_pos <- curr_pos;
    } catch (e) {}
    active_disp_pos = next_pos;
    fe.set_display(visible_displays[next_pos].index);
}

function prev_system() {
    if (n_disp <= 1) return;
    local curr_pos = get_active_pos_from_fe();
    local prev_pos = (curr_pos - 1 + n_disp) % n_disp;
    try {
        fe.layout.nv.from_disp_pos <- curr_pos;
    } catch (e) {}
    active_disp_pos = prev_pos;
    fe.set_display(visible_displays[prev_pos].index);
}

// =========================================================
// 3. ÁREA CENTRAL — CARROSSEL COVERFLOW 3D DE CAPAS
// =========================================================

local NUM_SLOTS = 11; // -5 .. 0 .. +5
local CENTER_IDX = 5;
local CENTER_PROGRESS = CENTER_IDX.tofloat() / NUM_SLOTS.tofloat();

local base_w = flh * 0.34;
local base_h = flh * 0.48;
local center_x = flw * 0.5;
local center_y = flh * 0.455;

local function ease_out_quad(t) {
    return 1.0 - (1.0 - t) * (1.0 - t);
}

class CoverFlowSlot extends ConveyorSlot {
    art = null;
    fallback = null;
    refl = null;
    refl_fallback = null;

    constructor() {
        // Reflections (zorder 3..15, behind floor_grad at 16)
        refl_fallback = fe.add_image("assets/fallback_box.png", 0, 0, base_w, base_h * 0.45);
        refl_fallback.subimg_y = refl_fallback.texture_height;
        refl_fallback.subimg_height = -refl_fallback.texture_height;
        refl_fallback.rotation_origin = Align.Centre;
        refl_fallback.alpha = 52;
        refl_fallback.zorder = 3;

        refl = fe.add_artwork("boxart", 0, 0, base_w, base_h * 0.45);
        refl.preserve_aspect_ratio = false;
        refl.rotation_origin = Align.Centre;
        refl.alpha = 52;
        refl.zorder = 4;

        // Main cover & fallback (zorder 20..55, above floor_grad)
        fallback = fe.add_image("assets/fallback_box.png", 0, 0, base_w, base_h);
        fallback.rotation_origin = Align.Centre;
        fallback.zorder = 20;

        art = fe.add_artwork("boxart", 0, 0, base_w, base_h);
        art.preserve_aspect_ratio = false;
        art.rotation_origin = Align.Centre;
        art.zorder = 21;

        base.constructor(art);
    }

    function set_index_offset(io) {
        art.index_offset = io;
        refl.index_offset = io;
    }

    function reset_index_offset() {
        try {
            art.rawset_index_offset(m_base_io);
            refl.rawset_index_offset(m_base_io);
        } catch (e) {
            set_index_offset(m_base_io);
        }
    }

    function swap(other) {
        try {
            art.swap(other.art);
            refl.swap(other.refl);
        } catch (e) {
            // Fallback handled by index_offset refresh
        }
    }

    function on_progress(progress, var) {
        local d = (progress - CENTER_PROGRESS) * NUM_SLOTS;
        local ad = fabs(d);

        // Hide off-screen wrap-around slots
        if (ad > 4.8) {
            art.visible = false;
            fallback.visible = false;
            refl.visible = false;
            refl_fallback.visible = false;
            return;
        }

        local has_art = (art.file_name != "");
        art.visible = has_art;
        fallback.visible = !has_art;
        refl.visible = has_art;
        refl_fallback.visible = !has_art;

        // Horizontal offset: breathing room around center, bookshelf stack further out
        local abs_x = 0.0;
        if (ad <= 1.0) {
            abs_x = ease_out_quad(ad) * (base_w * 0.88);
        } else {
            abs_x = (base_w * 0.88) + (ad - 1.0) * (base_w * 0.28);
        }
        local sx = (d >= 0.0) ? (center_x + abs_x) : (center_x - abs_x);

        // Scale in 3D: center is 1.0x, side items scale down slightly
        local sc = 1.0;
        if (ad <= 1.0) {
            sc = 1.0 - ease_out_quad(ad) * 0.20;
        } else {
            sc = 0.80 - (ad - 1.0) * 0.022;
            if (sc < 0.66) sc = 0.66;
        }

        local cw = base_w * sc;
        local ch = base_h * sc;
        local cx = sx - cw * 0.5;
        local cy = center_y - ch * 0.5;

        // 3D rotation around Y-axis (native AttractPlus 3D transform)
        local rot_y_mag = 0.0;
        if (ad <= 1.0) {
            rot_y_mag = ease_out_quad(ad) * 58.0;
        } else {
            rot_y_mag = 58.0 + (ad - 1.0) * 2.2;
            if (rot_y_mag > 68.0) rot_y_mag = 68.0;
        }
        local rot_y = (d >= 0.0) ? -rot_y_mag : rot_y_mag;

        // Z-order: center on top, side items stacked behind
        local z_cover = 55 - (ad * 5.0).tointeger();
        if (z_cover < 20) z_cover = 20;

        // Brightness & alpha fade at far edges
        local bright = 255 - (ad * 16.0).tointeger();
        if (bright < 165) bright = 165;

        local slot_alpha = 255;
        if (ad > 3.8) {
            slot_alpha = ((4.8 - ad) / 1.0 * 255.0).tointeger();
            if (slot_alpha < 0) slot_alpha = 0;
        }

        // Apply transforms only to active object
        if (has_art) {
            art.set_pos(cx, cy, cw, ch);
            art.rotation_y = rot_y;
            art.zorder = z_cover;
            art.set_rgb(bright, bright, bright);
            art.alpha = slot_alpha;
        } else {
            fallback.set_pos(cx, cy, cw, ch);
            fallback.rotation_y = rot_y;
            fallback.zorder = z_cover;
            fallback.set_rgb(bright, bright, bright);
            fallback.alpha = slot_alpha;
        }

        // Reflection geometry aligned to cover bottom edge
        local rh = ch * 0.45;
        local ry = cy + ch + 2.0 * scale;
        local r_alpha = (52.0 * (slot_alpha / 255.0)).tointeger();
        local z_refl = 14 - (ad * 2.0).tointeger();
        if (z_refl < 3) z_refl = 3;

        if (has_art) {
            if (refl.texture_height > 0 && refl.subimg_height >= 0) {
                refl.subimg_y = refl.texture_height;
                refl.subimg_height = -refl.texture_height;
            }
            refl.set_pos(cx, ry, cw, rh);
            refl.rotation_y = rot_y;
            refl.zorder = z_refl;
            refl.set_rgb(bright, bright, bright);
            refl.alpha = r_alpha;
        } else {
            refl_fallback.set_pos(cx, ry, cw, rh);
            refl_fallback.rotation_y = rot_y;
            refl_fallback.zorder = z_refl;
            refl_fallback.set_rgb(bright, bright, bright);
            refl_fallback.alpha = r_alpha;
        }
    }
}

local conveyor = Conveyor();
conveyor.transition_ms = 110;
local slots = [];
for (local i = 0; i < NUM_SLOTS; i++) {
    slots.push(CoverFlowSlot());
}
conveyor.set_slots(slots, CENTER_IDX);

// =========================================================
// 4. METADADOS DO JOGO SELECIONADO & CONTADOR DE JOGOS
// =========================================================

local title_y = flh * 0.765;
local title_h = 48.0 * scale;
local title_sz = (36.0 * scale).tointeger();

local title_shadow = fe.add_text("[Title]", flw * 0.1 + 2.0 * scale, title_y + 2.0 * scale, flw * 0.8, title_h);
title_shadow.font = FONT_BOLD;
title_shadow.charsize = title_sz;
title_shadow.align = Align.Centre;
title_shadow.set_rgb(0, 0, 0);
title_shadow.alpha = 170;
title_shadow.zorder = 60;

local title_text = fe.add_text("[Title]", flw * 0.1, title_y, flw * 0.8, title_h);
title_text.font = FONT_BOLD;
title_text.charsize = title_sz;
title_text.align = Align.Centre;
title_text.set_rgb(255, 255, 255);
title_text.zorder = 61;

local sub_y = flh * 0.816;
local sub_h = 26.0 * scale;
local sub_sz = (17.0 * scale).tointeger();

local sub_text = fe.add_text("", flw * 0.1, sub_y, flw * 0.8, sub_h);
sub_text.font = FONT_REGULAR;
sub_text.charsize = sub_sz;
sub_text.align = Align.Centre;
sub_text.set_rgb(200, 200, 200);
sub_text.zorder = 61;

// Badge / Pílula do total de jogos do sistema e posição atual
local count_y = flh * 0.855;
local count_h = (26.0 * scale).tointeger();
if (count_h < 22) count_h = 22;
local count_sz = (14.0 * scale).tointeger();
if (count_sz < 12) count_sz = 12;

local function format_num(n) {
    local s = n.tostring();
    local res = "";
    local len = s.len();
    for (local i = 0; i < len; i++) {
        if (i > 0 && (len - i) % 3 == 0) res += ".";
        res += s[i].tochar();
    }
    return res;
}

local count_bg = fe.add_image("assets/topbar_capsule.png", 0, count_y, 160, count_h);
count_bg.set_border(32, 31, 32, 31);
count_bg.set_rgb(theme_r, theme_g, theme_b);
count_bg.alpha = (theme_a * 0.92).tointeger();
count_bg.zorder = 61;

local count_text = fe.add_text("", 0, count_y, 160, count_h);
count_text.font = FONT_BOLD;
count_text.charsize = count_sz;
count_text.align = Align.Centre;
count_text.set_rgb(235, 238, 245);
count_text.alpha = 245;
count_text.zorder = 62;

local function update_metadata() {
    local cat = fe.game_info(Info.Category);
    local mfg = fe.game_info(Info.Manufacturer);
    local yr  = fe.game_info(Info.Year);
    local sub = "";
    if (cat != "") {
        sub = cat;
    } else if (mfg != "" && yr != "") {
        sub = mfg + "  •  " + yr;
    } else if (mfg != "") {
        sub = mfg;
    } else if (yr != "") {
        sub = yr;
    }
    sub_text.msg = sub.toupper();

    local total_games = fe.list.size;
    local curr_game = fe.list.index + 1;
    local count_str = "";
    if (total_games <= 0) {
        count_str = "0 JOGOS";
    } else if (total_games == 1) {
        count_str = "1 JOGO";
    } else {
        count_str = format_num(curr_game) + " DE " + format_num(total_games) + " JOGOS";
    }
    count_text.msg = count_str;

    local char_w = count_sz * 0.65;
    local count_w = (count_str.len() * char_w) + (36.0 * scale);
    if (count_w < 110.0 * scale) count_w = 110.0 * scale;
    local count_x = (flw - count_w) * 0.5;

    count_bg.set_pos(count_x, count_y, count_w, count_h);
    count_text.set_pos(count_x, count_y, count_w, count_h);

    if ("refresh_video_playback" in this) {
        refresh_video_playback();
    }
}

// =========================================================
// 5. MODAL DE VÍDEO DO JOGO SELECIONADO (TECLA V / START)
// =========================================================

local video_active = false;

// Dark background backdrop covering full screen
local video_dim = fe.add_rectangle(0, 0, flw, flh);
video_dim.set_rgb(5, 5, 8);
video_dim.alpha = 230;
video_dim.zorder = 100;
video_dim.visible = false;

// 16:9 Video container sizing
local vh = (flh * 0.70).tointeger();
local vw = (vh * 16.0 / 9.0).tointeger();
if (vw > flw * 0.82) {
    vw = (flw * 0.82).tointeger();
    vh = (vw * 9.0 / 16.0).tointeger();
}
local vx = (flw - vw) * 0.5;
local vy = (flh - vh) * 0.46;

// Capsule frame border around the video
local video_frame_bg = fe.add_image("assets/topbar_capsule.png", vx - 8.0 * scale, vy - 8.0 * scale, vw + 16.0 * scale, vh + 16.0 * scale);
video_frame_bg.set_border(32, 31, 32, 31);
video_frame_bg.set_rgb(top_r, top_g, top_b);
video_frame_bg.zorder = 101;
video_frame_bg.visible = false;

// Inner screen background
local video_inner_bg = fe.add_rectangle(vx, vy, vw, vh);
video_inner_bg.set_rgb(10, 10, 14);
video_inner_bg.zorder = 102;
video_inner_bg.visible = false;

// Video player artwork objects (snap or video)
local video_snap = fe.add_artwork("snap", vx, vy, vw, vh);
video_snap.preserve_aspect_ratio = true;
video_snap.zorder = 103;
video_snap.visible = false;

local video_art = fe.add_artwork("video", vx, vy, vw, vh);
video_art.preserve_aspect_ratio = true;
video_art.zorder = 104;
video_art.visible = false;

// Fallback message when game has no video
local video_notice = fe.add_text("NENHUM VÍDEO DISPONÍVEL", vx, vy + (vh - 32.0 * scale) * 0.5, vw, 32.0 * scale);
video_notice.font = FONT_BOLD;
video_notice.charsize = (20.0 * scale).tointeger();
video_notice.align = Align.Centre;
video_notice.set_rgb(200, 205, 220);
video_notice.zorder = 105;
video_notice.visible = false;

// Game title on top of video modal
local video_title = fe.add_text("", vx, vy - 44.0 * scale, vw, 36.0 * scale);
video_title.font = FONT_BOLD;
video_title.charsize = (22.0 * scale).tointeger();
video_title.align = Align.Centre;
video_title.set_rgb(255, 255, 255);
video_title.zorder = 106;
video_title.visible = false;

// Hint at bottom of modal
local video_hint = fe.add_text("PRESSIONE  [ B ]  OU  [ START ]  OU  [ V ]  PARA FECHAR", vx, vy + vh + 16.0 * scale, vw, 26.0 * scale);
video_hint.font = FONT_BOLD;
video_hint.charsize = (14.0 * scale).tointeger();
video_hint.align = Align.Centre;
video_hint.set_rgb(190, 195, 210);
video_hint.zorder = 106;
video_hint.visible = false;

function refresh_video_playback() {
    if (!video_active) return;
    video_title.msg = fe.game_info(Info.Title);
    local has_vid = false;
    if (video_snap.file_name != "") {
        video_snap.visible = true;
        video_art.visible = false;
        has_vid = true;
    } else if (video_art.file_name != "") {
        video_snap.visible = false;
        video_art.visible = true;
        has_vid = true;
    } else {
        video_snap.visible = false;
        video_art.visible = false;
    }
    video_notice.visible = !has_vid;
}

function set_video_visible(show) {
    video_active = show;
    video_dim.visible = show;
    video_frame_bg.visible = show;
    video_inner_bg.visible = show;
    video_title.visible = show;
    video_hint.visible = show;
    if (show) {
        refresh_video_playback();
    } else {
        video_snap.visible = false;
        video_art.visible = false;
        video_notice.visible = false;
    }
}

function toggle_video() {
    set_video_visible(!video_active);
}

update_metadata();

// =========================================================
// 5. RODAPÉ — BARRA DE LEGENDAS DE BOTÕES (FOOTER)
// =========================================================

local footer_w = flw * 0.92;
local footer_h = (46.0 * scale).tointeger();
if (footer_h < 40) footer_h = 40;
local footer_x = (flw - footer_w) * 0.5;
local footer_y = flh - footer_h - (flh * 0.024);

// Capsule background matching top bar design
local footer_bg = fe.add_image("assets/topbar_capsule.png", footer_x, footer_y, footer_w, footer_h);
footer_bg.set_border(32, 31, 32, 31);
footer_bg.zorder = 70;
footer_bg.set_rgb(theme_r, theme_g, theme_b);
footer_bg.alpha = theme_a;

local btn_style_dir = (my_config["button_style"] == "Xbox") ? "xbox" : "ps";
local btn_base_path = "assets/buttons/" + btn_style_dir + "/";

local footer_items = [
    { icon = "a.png",      w_mult = 1.0, label = "Iniciar" },
    { icon = "b.png",      w_mult = 1.0, label = "Sair" },
    { icon = "x.png",      w_mult = 1.0, label = "Pesquisar" },
    { icon = "y.png",      w_mult = 1.0, label = "Info" },
    { icon = "select.png", w_mult = 1.0, label = "Opções" },
    { icon = "start.png",  w_mult = 1.0, label = "Vídeo" },
    { icon = "lr.png",     w_mult = 2.0, label = "Sistemas" }
];

local icon_sz = (28.0 * scale).tointeger();
if (icon_sz < 24) icon_sz = 24;
local lbl_sz = (18.0 * scale).tointeger();
if (lbl_sz < 15) lbl_sz = 15;
local icon_gap = 10.0 * scale;
if (icon_gap < 8.0) icon_gap = 8.0;
local item_gap = 26.0 * scale;
if (item_gap < 16.0) item_gap = 16.0;
local lbl_char_w = lbl_sz * 0.76;

local total_footer_w = 0.0;
local footer_widths = [];
foreach (i, fitem in footer_items) {
    local iw = (icon_sz * fitem.w_mult).tointeger();
    local lw = fitem.label.len() * lbl_char_w + 20.0 * scale;
    local full_item_w = iw + icon_gap + lw;
    footer_widths.push({ iw = iw, lw = lw, full_item_w = full_item_w });
    total_footer_w += full_item_w;
    if (i < footer_items.len() - 1) total_footer_w += item_gap;
}

local fx = footer_x + (footer_w - total_footer_w) * 0.5;
local fy_center = footer_y + footer_h * 0.5;

foreach (i, fitem in footer_items) {
    local winfo = footer_widths[i];
    local ico = fe.add_image(btn_base_path + fitem.icon, fx, fy_center - icon_sz * 0.5, winfo.iw, icon_sz);
    ico.smooth = true;
    ico.mipmap = true;
    ico.zorder = 72;

    local lbl = fe.add_text(fitem.label, fx + winfo.iw + icon_gap, fy_center - lbl_sz * 0.65, winfo.lw + 24.0 * scale, lbl_sz * 1.3);
    lbl.word_wrap = false;
    lbl.font = FONT_BOLD;
    lbl.charsize = lbl_sz;
    lbl.align = Align.Left;
    lbl.set_rgb(235, 238, 245);
    lbl.alpha = 240;
    lbl.zorder = 72;

    fx += winfo.full_item_w + item_gap;
}

// =========================================================
// 6. SINAIS DE NAVEGAÇÃO DE DISPLAYS E JOGOS
// =========================================================

fe.add_signal_handler("on_theme_signal");
function on_theme_signal(sig) {
    if (sig == "custom2") {
        toggle_video();
        return true;
    } else if (sig == "layout_options") {
        if (video_active) set_video_visible(false);
        return false;
    } else if (sig == "back") {
        if (video_active) {
            set_video_visible(false);
            return true;
        }
        return false;
    } else if (sig == "left") {
        fe.signal("prev_game");
        return true;
    } else if (sig == "right") {
        fe.signal("next_game");
        return true;
    } else if (sig == "up") {
        fe.signal("prev_game");
        return true;
    } else if (sig == "down") {
        fe.signal("next_game");
        return true;
    } else if (sig == "prev_display") {
        if (video_active) set_video_visible(false);
        prev_system();
        return true;
    } else if (sig == "next_display") {
        if (video_active) set_video_visible(false);
        next_system();
        return true;
    }
    return false;
}

// =========================================================
// 7. TRANSIÇÕES & ANIMAÇÃO CONTÍNUA DO CARROSSEL
// =========================================================

fe.add_transition_callback("on_theme_transition");
function on_theme_transition(ttype, var, ttime) {
    if (ttype == Transition.FromOldSelection || ttype == Transition.ToNewList || ttype == Transition.StartLayout) {
        update_background_source();
        update_metadata();
    }
    if (ttype == Transition.ToNewList) {
        sync_top_bar(false);
        foreach (slot in slots) {
            slot.on_progress(slot.get_base_progress(), 0);
        }
    } else if (ttype == Transition.StartLayout) {
        foreach (slot in slots) {
            slot.on_progress(slot.get_base_progress(), 0);
        }
    }
    return false;
}

local last_tick = 0;
fe.add_ticks_callback("on_theme_tick");
function on_theme_tick(ttime) {
    local dt = (last_tick == 0) ? 16.0 : (ttime - last_tick).tofloat();
    if (dt > 50.0) dt = 50.0;
    last_tick = ttime;

    // Smooth carousel tween interpolation
    local lerp = 1.0 - pow(0.0008, dt / 1000.0);
    local changed = false;

    if (fabs(carousel_curr_pos - carousel_target_pos) > 0.002) {
        carousel_curr_pos += (carousel_target_pos - carousel_curr_pos) * lerp;
        changed = true;
    } else if (carousel_curr_pos != carousel_target_pos) {
        carousel_curr_pos = carousel_target_pos;
        changed = true;
    }

    if (fabs(pill_curr_w - pill_targ_w) > 0.25) {
        pill_curr_w += (pill_targ_w - pill_curr_w) * lerp;
        changed = true;
    } else if (pill_curr_w != pill_targ_w) {
        pill_curr_w = pill_targ_w;
        changed = true;
    }

    if (changed) {
        apply_carousel_positions();
    }
}
