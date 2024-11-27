from typing import Any, Dict
from kitty.boss import Boss
from kitty.window import Window

def on_focus_change(boss: Boss, window: Window, data: Dict[str, Any]) -> None:
    # If --match actually worked as advertised, this should work great...
    #boss.call_remote_control(window, ('set-background-opacity', '0.7'))
    #boss.call_remote_control(window, ('set-background-opacity', '--match=state:focused', '0.9'))
    boss.call_remote_control(window, ('set-colors', '--all', 'background=#111'))
    boss.call_remote_control(window, ('set-colors', '--match=state:focused', 'background=#000'))
