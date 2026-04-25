extends Node

var _lib = null
var _config_node = null

const VANILLA_RATE := 0.2777
const DAY_UNITS    := 2400.0

func _ready():
    if Engine.has_meta("RTVModLib"):
        var lib = Engine.get_meta("RTVModLib")
        if lib._is_ready:
            _on_lib_ready()
        else:
            lib.frameworks_ready.connect(_on_lib_ready)

func _on_lib_ready():
    _lib = Engine.get_meta("RTVModLib")
    _config_node = get_node_or_null("/root/RealWorldTimeConfig")
    _lib.hook("world-_process-pre", _on_world_process)
    print("RealWorldTime: Loaded")

func _on_world_process(_delta):
    if _config_node == null:
        return

    var world = _lib._caller

    if _config_node.pc_clock_enabled:
        var local := Time.get_datetime_dict_from_system(false)
        var hour:   float = float(local["hour"])
        var minute: float = float(local["minute"])

        world.time = (hour * 100.0) + minute

        var sim := get_node_or_null("/root/Simulation")
        if sim:
            sim.time = world.time
            sim.rate = 0.0

    elif _config_node.custom_rate_enabled:
        var sim := get_node_or_null("/root/Simulation")
        if sim:
            sim.rate = DAY_UNITS / (_config_node.real_mins_per_day * 60.0)

    else:
        var sim := get_node_or_null("/root/Simulation")
        if sim:
            sim.rate = VANILLA_RATE
