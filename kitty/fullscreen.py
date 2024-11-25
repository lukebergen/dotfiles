from kitty.boss import get_boss, get_os_window_size

def main(args):
    pass

def handle_result(args, answer, target_window_id, boss):
    w = boss.window_id_map.get(target_window_id)
    if w is not None:
        # boss.call_remote_control(w, ('set-spacing', "padding-top=30"))
        boss.toggle_fullscreen()
        #boss.call_remote_control(w, ("send-text", "TODO: fix the bezel problem"))

handle_result.no_ui = True
