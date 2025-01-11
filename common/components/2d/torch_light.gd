@tool

extends PointLight2D

@export var flicker_speed: float = 1.0
@export var min_energy: float = 0.8
@export var max_energy: float = 1.2
@export var offset_distance: float = 4.0
@export var base_energy: float = 0.2
@export var energy_fluctuation_base: float = 0.1

var timer: float = 0.0

func _process(delta):
        timer += delta
        # Adjust the energy property to simulate flickering
        self.energy = base_energy + energy_fluctuation_base * sin(timer * 10.0) + 0.1 * randf()
