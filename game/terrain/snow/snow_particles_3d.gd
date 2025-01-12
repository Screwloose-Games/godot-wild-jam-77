extends GPUParticles3D

func _ready() -> void:
  if OSUtils.is_web():
    emitting = false
