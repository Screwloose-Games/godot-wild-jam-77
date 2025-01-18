extends Node3D

## Things to do when footstepping
@onready var water_splash_maker: WaterSplashMaker = $"../WaterSplashMaker"

func do_footstep():
    water_splash_maker.try_making_water_splash()
