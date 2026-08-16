extends CanvasLayer

@onready var dim_rect: ColorRect = $ColorRect

func _ready() -> void:
	dim_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	dim_rect.process_mode = Node.PROCESS_MODE_ALWAYS
	dim_rect.color.a = 0.0
	dim_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

## Call this to trigger the dim -> light back up transition
func flash_dim(duration: float = 1.0, dim_alpha: float = 0.8) -> void:
	var half := duration / 2.0

	var tween := create_tween()
	tween.tween_property(dim_rect, "color:a", dim_alpha, half)
	tween.tween_property(dim_rect, "color:a", 0.0, half)
