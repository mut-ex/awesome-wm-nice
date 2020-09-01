# :thumbsup:nice
nice is an easy to use, highly configurable extension for **[Awesome WM](https://awesomewm.org/)** that adds beautiful window decorations (and extra functionality!) to clients. It...

* ...adds a **subtle 3D look**, and soft, **rounded anti-aliased, corners** to windows
* ...picks the window **decoration color based on the client content for a seamless look** , and **adjusts the window title text color** accordingly
* ...**auto-generates titlebar buttons** (and their states) for you based on the colors your pick *or* you can let it pick the colors for you!
* ...allows you to **customize** which **titlebar buttons** to include, their order, and their layout
* ...adds the **ability to maximize/unmaximize** floating windows by **double clicking the titlebar**, and of course, **moving them by clicking and holding**
* ...adds the ability to **"roll up"** and **"roll down"** the client window like a **window shade**! Scroll up over the titlebar to **instantly hide the window contents but keep the title bar** right where it is. And then either scroll down or click the titlebar to make the window contents visible again!

![Preview](https://raw.githubusercontent.com/mut-ex/awesome-wm-nice/master/preview.png)

## Getting Started

### Prerequisites 

* You need to be using **[Awesome WM](https://awesomewm.org/)** as your window manager, and should already have a working basic configuration file. I have developed and tested nice only on **awesome v4.3 git version**

* I **highly** suggest using a compositor such as **[picom](https://github.com/yshui/picom)**. My recommended shadow settings are given below

  ```
  shadow = true;
  shadow-radius = 40;
  shadow-opacity = .55;
  shadow-offset-x = -40;
  shadow-offset-y = -20;
  shadow-exclude = [
    "_NET_WM_WINDOW_TYPE:a = '_NET_WM_WINDOW_TYPE_NOTIFICATION'",
    "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'",
    "_GTK_FRAME_EXTENTS@:c"
  ];
  ```

* For GTK apps, I suggest adding the following line to **~/.config/gtk-3.0/settings.ini** under the **[Settings]** section

 ```
  gtk-decoration-layout=menu:
 ```

  

### Installation

The easiest and quickest way to get started is by cloning this repository to your awesome configuration directory

```shell
$ cd ~/.config/awesome
$ git clone https://github.com/mut-ex/awesome-wm-nice.git nice
```



## Usage

First of all, make sure that you do not already have code in place that requests for the default titlebars. Something like this

```lua
client.connect_signal("request::titlebars", function(c) ... end)
```

To use nice, you first need to load the module. You can do so by placing the following line right after `beautiful.init(...)`

```lua
local nice = require("nice")
nice()
```

If you are fine using the default configuration, you are all done! However if you like, you can override the defaults you wish to change by passing your own configuration. There are a lot of parameters you can change!  The commented out lines in the code block before represent the default values

```lua
local nice = require("nice")
nice = {
  --[[
    For parameters that take a table, you only need to pass the
    values you intend to change.
    
    For example:
    
    titlebar_items = {
      left = {"close"}
    }

    tooltip_messages = {
      close = "Destroy this client!"
    }
  ]]

  -- * == Titlebar specific == *
  -- titlebar_color = "#1E1E24"
  -- titlebar_height = 38
  -- titlebar_radius = 9
  -- titlebar_margin_left = 0
  -- titlebar_margin_right = 0
  -- titlebar_font = "Sans 10"
    
  -- titlebar_items = {
  --     left = {"close", "minimize", "maximize"},
  --     middle = {"title"},
  --     right = {"sticky", "ontop", "floating"},
  -- }
    
  -- context_menu_theme = {
  --     bg_normal = "#5e6472",
  --     fg_normal = "#fefefa",
  --     bg_focus = "#aed9e0",
  --     fg_focus = "#242424",
  --     border_color = "#00000000",
  --     border_width = 0,
  --     height = 35,
  --     width = 250,
  --     font =  "Sans 10",
  -- }
  -- window_shade_enabled = false
    
  -- * == Button specific == *
  -- button_margin_horizontal = 5
  -- button_margin_top = 2
  -- button_size = 16
  -- close_color = "#ee4266"
  -- minimize_color = "#ffb400"
  -- maximize_color = "#4CBB17"
  -- floating_color = "#f6a2ed"
  -- ontop_color = "#f6a2ed"
  -- sticky_color = "#f6a2ed"
    
  -- tooltips_enabled = true
  
  -- tooltip_messages = {
  --     close = "close",
  --     minimize = "minimize",
  --     floating_active = "enable tiling mode",
  --     floating_inactive = "enable floating mode",
  --     maximize_active = "unmaximize",
  --     maximize_inactive = "maximize",
  --     ontop_active = "don't keep above other windows",
  --     ontop_inactive = "keep above other windows",
  --     sticky_active = "disable sticky mode",
  --     sticky_inactive = "enable sticky mode",
  -- }
}
```



## Using

nice will automatically detect and change the window decoration color to match the client. However...

* If nice doesn't pick the right color or you want to specify it yourself, right-click the titlebar and select 'Manually Pick Color'
* If the client theme changes (for example if you change your terminal emulator colors), to update the window decoration colors, right-click on the titlebar and select 'Redo Window Decorations'
* Scroll-up with your mouse over the titlebar to "roll-up" the window shade. Scroll-down over the titlebar, or left-click to "roll-down" the window shade
* nice saves its color rules in the color_rules file within the module directory. If you wish you can manually edit it, or delete the file if you want to start again.



## Issues

If you face any bugs or issues (or have a feature request), please feel free to open an issue on here



## License

[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)
