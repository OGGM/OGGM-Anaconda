#!/usr/bin/env python

import os
os.environ["MPLBACKEND"] = 'agg'

import matplotlib
matplotlib.use('agg')

import pytest
import pytest_mpl.plugin
import oggm
import sys

import ssl
ssl._create_default_https_context = ssl._create_unverified_context

initial_dir = os.getcwd()
oggm_file = os.path.abspath(oggm.__file__)
oggm_dir = os.path.dirname(oggm_file)

sys.exit(pytest.main([oggm_dir, '--mpl'], plugins=[pytest_mpl.plugin]))
