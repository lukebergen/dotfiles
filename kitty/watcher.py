#from typing import Any, Dict
#
#from kitty.window import Window
#
#def on_focus_change(boss: Boss, window: Window, data: Dict[str, Any])-> None:
#    # data["focused"] will be True or False
#    boss.call_remote_control(window, ('send-text', f'--match=id:{window.id}', str(data)))
#    if data['focused']:
#        boss.call_remote_control(window, ('set-background-opacity', 0.9))
#    else:
#        boss.call_remote_control(window, ('set-background-opacity', 0.4))
#
#kitty.watchers.register(on_focus_change)
