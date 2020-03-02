import logging
import os

from mopidy import config, exceptions, ext


__version__ = "0.1"

logger = logging.getLogger(__name__)


class Extension(ext.Extension):

    dist_name = "Mopidy-Curses"
    ext_name = "Curses"
    version = __version__

    def get_default_config(self):
        conf_file = os.path.join(os.path.dirname(__file__), "ext.conf")
        return config.read(conf_file)

    def get_config_schema(self):
        schema = super(Extension, self).get_config_schema()
        return schema

    def get_command(self):
        pass

    def validate_environment(self):
        pass

    def setup(self, registry):
        from .frontend import CursesFrontend

        registry.add("frontend", CursesFrontend)
