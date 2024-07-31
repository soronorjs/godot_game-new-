extends CanvasLayer

var file_paths = {}

func _ready():
	scan_directory("res://your_game_folder")
	changeLevel("test_scene")

func scan_directory(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				scan_directory(path.path_join(file_name))
			else:
				var file_path = path.path_join(file_name)
				var file_name_without_extension = file_name.get_basename()
				file_paths[file_name_without_extension] = file_path
			file_name = dir.get_next()
		dir.list_dir_end()

func get_file_path(file_name):
	return file_paths.get(file_name, "")
	
func changeLevel(level_name):
	$AnimationPlayer.play("transOut")
	get_tree().change_scene_to_file(get_file_path(level_name))
