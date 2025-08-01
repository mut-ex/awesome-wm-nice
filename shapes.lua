-- => Shapes
-- Provides utility functions for handling cairo shapes and geometry
-- ============================================================
--
local lgi = require("lgi")
local colors = require("modules.nice.colors")
local hex2rgb = colors.hex2rgb
local darken = colors.darken
local cairo = lgi.cairo
local math = math
local rad = math.rad
local floor = math.floor
local min = math.min

-- Returns a shape function for a rounded rectangle with independently configurable corner radii
local function rounded_rect(args)
    local r1 = args.tl or 0
    local r2 = args.bl or 0
    local r3 = args.br or 0
    local r4 = args.tr or 0
    return function(cr, width, height)
        cr:new_sub_path()
        cr:arc(width - r1, r1, r1, rad(-90), rad(0))
        cr:arc(width - r2, height - r2, r2, rad(0), rad(90))
        cr:arc(r3, height - r3, r3, rad(90), rad(180))
        cr:arc(r4, r4, r4, rad(180), rad(270))
        cr:close_path()
    end
end

-- Returns a circle of the specified size filled with the specified color
local function circle_filled(color, size, shape)
    color = color or "#fefefa"
    shape = shape or "circle"
    local surface = cairo.ImageSurface.create("ARGB32", size, size)
    local cr = cairo.Context.create(surface)
    if shape == "diamond" then
    	cr:move_to(size / 2, 0)
    	cr:line_to(size, size / 2)
    	cr:line_to(size / 2, size)
    	cr:line_to(0, size / 2)
	cr:close_path()
    elseif shape == "circle" then
   	cr:arc(size / 2, size / 2, size / 2, rad(0), rad(360)) 
    end
    cr:set_source_rgba(hex2rgb(color))
    cr.antialias = cairo.Antialias.BEST
    cr:fill()
    -- cr:arc(
    --     size / 2, size / 2, size / 2 - 0.5, rad(135), rad(270))
    -- cr:set_source_rgba(hex2rgb(darken(color, 25)))
    -- cr.line_width = 1
    -- cr:stroke()

    return surface
end

-- Returns a vertical gradient pattern going from cololr_1 -> color_2
local function duotone_gradient_vertical(color_1, color_2, height, offset_1,
                                         offset_2)
    local fill_pattern = cairo.Pattern.create_linear(0, 0, 0, height)
    local r, g, b, a
    r, g, b, a = hex2rgb(color_1)
    fill_pattern:add_color_stop_rgba(offset_1 or 0, r, g, b, a)
    r, g, b, a = hex2rgb(color_2)
    fill_pattern:add_color_stop_rgba(offset_2 or 1, r, g, b, a)
    return fill_pattern
end

-- Returns a horizontal gradient pattern going from cololr_1 -> color_2
local function duotone_gradient_horizontal(color, width)
    local fill_pattern = cairo.Pattern.create_linear(0, 0, width, 0)
    local r, g, b, a
    r, g, b, a = hex2rgb(color)
    fill_pattern:add_color_stop_rgba(0, r, g, b, a)
    r, g, b, a = hex2rgb(color)
    fill_pattern:add_color_stop_rgba(0.5, r, g, b, a)
    r, g, b, a = hex2rgb("#00000000")
    fill_pattern:add_color_stop_rgba(0.6, r, g, b, a)
    r, g, b, a = hex2rgb(color)
    fill_pattern:add_color_stop_rgba(0.7, r, g, b, a)
    r, g, b, a = hex2rgb(color)
    fill_pattern:add_color_stop_rgba(1, r, g, b, a)
    return fill_pattern
end

-- Flips the given surface around the specified axis
local function flip(surface, axis)
    local width = surface:get_width()
    local height = surface:get_height()
    local flipped = cairo.ImageSurface.create("ARGB32", width, height)
    local cr = cairo.Context.create(flipped)
    local source_pattern = cairo.Pattern.create_for_surface(surface)
    if axis == "horizontal" then
        source_pattern.matrix = cairo.Matrix {xx = -1, yy = 1, x0 = width}
    elseif axis == "vertical" then
        source_pattern.matrix = cairo.Matrix {xx = 1, yy = -1, y0 = height}
    elseif axis == "both" then
        source_pattern.matrix = cairo.Matrix {
            xx = -1,
            yy = -1,
            x0 = width,
            y0 = height,
        }
    end
    cr.source = source_pattern
    cr:rectangle(0, 0, width, height)
    cr:paint()

    return flipped
end

-- Draws the left corner of the titlebar
local function create_corner_top_left(args)
    local radius = args.radius
    local height = args.height
    local surface = cairo.ImageSurface.create("ARGB32", radius, height)
    local cr = cairo.Context.create(surface)
    -- Create the corner shape and fill it with a gradient
    local radius_offset = 1 -- To soften the corner
    cr:move_to(0, height)
    cr:line_to(0, radius - radius_offset)
    cr:arc(
        radius + radius_offset, radius + radius_offset, radius, rad(180),
        rad(270))
    cr:line_to(radius, height)
    cr:close_path()
    cr.source = args.background_source
    cr.antialias = cairo.Antialias.BEST
    cr:fill()

    return surface
end

-- Draws the middle of the titlebar
local function create_edge_top_middle(args)
    local client_color = args.color
    local height = args.height
    local width = args.width
    local surface = cairo.ImageSurface.create("ARGB32", width, height)
    local cr = cairo.Context.create(surface)
    -- Create the background shape and fill it with a gradient
    cr:rectangle(0, 0, width, height)
    cr.source = args.background_source
    cr:fill()

    return surface
end

local function create_edge_left(args)
    local height = args.height
    local width = 2
    -- height = height or 1080
    local surface = cairo.ImageSurface.create("ARGB32", width, height)
    local cr = cairo.Context.create(surface)
    cr:rectangle(0, 0, 2, args.height)
    cr:set_source_rgb(hex2rgb(args.client_color))
    cr:fill()
    -- Inner light stroke
    cr:new_sub_path()
    cr:move_to(args.stroke_offset_inner, 0) -- 1/5
    cr:line_to(args.stroke_offset_inner, height)
    cr.line_width = args.stroke_width_inner -- 1.5
    cr:set_source_rgb(hex2rgb(args.inner_stroke_color))
    cr:stroke()
    -- Outer dark stroke
    cr:new_sub_path()
    cr:move_to(args.stroke_offset_outer, 0)
    cr:line_to(args.stroke_offset_outer, height)
    cr.line_width = args.stroke_width_outer -- 1
    cr:set_source_rgb(hex2rgb(args.stroke_color_outer))
    cr:stroke()

    return surface
end

local function set_font(cr, font)
    cr:set_font_size(font.size)
    cr:select_font_face(
        font.font or "Inter", font.italic and 1 or 0, font.bold and 1 or 0)
end

local function text_label(args)
    local surface = cairo.ImageSurface.create("ARGB32", 1, 1)
    local cr = cairo.Context.create(surface)
    set_font(cr, args.font)
    local text = args.text
    local kern = args.font.kerning or 0
    local ext = cr:text_extents(text)
    surface = cairo.ImageSurface.create(
                  "ARGB32", ext.width + string.len(text) * kern, ext.height)
    cr = cairo.Context.create(surface)
    set_font(cr, args.font)
    cr:move_to(0, ext.height)
    cr:set_source_rgb(hex2rgb(args.color))
    -- cr:show_text(text)
    text:gsub(
        ".", function(c)
            -- do something with c
            cr:show_text(c)
            cr:rel_move_to(kern, 0)
        end)
    return surface
end

return {
    rounded_rect = rounded_rect,
    circle_filled = circle_filled,
    duotone_gradient_vertical = duotone_gradient_vertical,
    flip = flip,
    create_corner_top_left = create_corner_top_left,
    create_edge_top_middle = create_edge_top_middle,
    create_edge_left = create_edge_left,
    text_label = text_label,
}
