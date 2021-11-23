import os

from eiffel_loop.eiffel import project

from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.ecf import FREEZE_BUILD

config = project.read_project_py ()

project.set_build_environment (config)

ecf = EIFFEL_CONFIG_FILE (config.ecf)

build = FREEZE_BUILD (ecf, config)

build.install_resources ()
