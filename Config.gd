extends Node

var McmHelpers = preload("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")
var config = ConfigFile.new()

const FILE_PATH := "user://MCM/RealWorldTime"
const MOD_ID    := "RealWorldTime"

var pc_clock_enabled:    bool  = true
var custom_rate_enabled: bool  = false
var real_mins_per_day:   float = 144.0

func _ready() -> void:
    config.set_value("Bool", "pc_clock_enabled", {
        "name" = "PC Clock Sync",
        "tooltip" = "When on, in-game time mirrors your real PC clock. 9am real = 9am in game.",
        "default" = true,
        "value" = true,
        "category" = "Time Mode",
        "menu_pos" = 1
    })

    config.set_value("Bool", "custom_rate_enabled", {
        "name" = "Custom Day Rate",
        "tooltip" = "When on, time passes at your chosen speed.",
        "default" = false,
        "value" = false,
        "category" = "Time Mode",
        "menu_pos" = 2
    })

    config.set_value("Float", "real_mins_per_day", {
        "name" = "Real Minutes Per Game Day",
        "tooltip" = "How many real-life minutes = one full in-game day.\nVanilla = 144 mins (~2.4 hrs).\nExample: 60 = 1 real hour per day, 10 = very fast days.\nOnly active when Custom Day Rate is on.",
        "default" = 144.0,
        "value" = 144.0,
        "minRange" = 1.0,
        "maxRange" = 1440.0,
        "step" = 1.0,
        "category" = "Custom Rate",
        "menu_pos" = 1
    })

    if McmHelpers != null:
        if not FileAccess.file_exists(FILE_PATH + "/config.ini"):
            DirAccess.open("user://").make_dir_recursive(FILE_PATH)
            config.save(FILE_PATH + "/config.ini")
        else:
            McmHelpers.CheckConfigurationHasUpdated(MOD_ID, config, FILE_PATH + "/config.ini")
            config.load(FILE_PATH + "/config.ini")

        _on_config_updated(config)

        McmHelpers.RegisterConfiguration(
            MOD_ID,
            "Real World Time",
            FILE_PATH,
            "Sync in-game time to your real clock or set a custom day length",
            { "config.ini" = _on_config_updated },
            self
        )
    else:
        _on_config_updated(config)

func _on_config_updated(cfg: ConfigFile):
    pc_clock_enabled    = cfg.get_value("Bool",  "pc_clock_enabled",    {"value" = true} )["value"]
    custom_rate_enabled = cfg.get_value("Bool",  "custom_rate_enabled", {"value" = false})["value"]
    real_mins_per_day   = cfg.get_value("Float", "real_mins_per_day",   {"value" = 144.0})["value"]
