import pykka
import urwid

from mopidy import core


class CursesFrontend(pykka.ThreadingActor, core.CoreListener):
    def __init__(self, config, core):
        super(CursesFrontend, self).__init__()
        self.core = core

    # Front-end implementation
