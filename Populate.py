#!/usr/bin/env python2
# -*- coding: utf-8 -*-
import logging
import maria
import os
import yaml

logging.basicConfig(level=logging.CRITICAL)

configfile = maaria.paths.config('profile.yml')

if os.path.exists(configfile):
    with open(configfile, "r") as f:
        config = yaml.safe_load(f)
else:
    config = {}

maria.populate.run(config)
