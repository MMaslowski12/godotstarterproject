@tool
extends EditorPlugin

const MENU_LABEL := "Nuke UIDs (clear .godot/.import)"

func _enter_tree() -> void:
	add_tool_menu_item(MENU_LABEL, Callable(self, "_on_nuke"))
	print("[NukeUIDs] Loaded")

func _exit_tree() -> void:
	remove_tool_menu_item(MENU_LABEL)

func _on_nuke() -> void:
	var ok1 := _rm_rf(ProjectSettings.globalize_path("res://.godot"))
	var ok2 := _rm_rf(ProjectSettings.globalize_path("res://.import"))
	get_editor_interface().get_resource_filesystem().scan()
	if ok1 and ok2:
		print("[NukeUIDs] Deleted .godot and .import. Reimport queued.")
	else:
		print("[NukeUIDs] Warning: failed to delete one or both folders.")

func _rm_rf(path: String) -> bool:
	var da := DirAccess.open(path)
	if da:
		da.list_dir_begin()
		while true:
			var name := da.get_next()
			if name == "":
				break
			if name == "." or name == "..":
				continue
			var sub := path.path_join(name)
			if da.current_is_dir():
				if not _rm_rf(sub):
					da.list_dir_end()
					return false
			else:
				if DirAccess.remove_absolute(sub) != OK:
					da.list_dir_end()
					return false
		da.list_dir_end()
		return DirAccess.remove_absolute(path) == OK
	return true
