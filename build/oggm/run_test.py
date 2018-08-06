#!/usr/bin/env python

import os
os.environ["MPLBACKEND"] = 'agg'

import matplotlib
matplotlib.use('agg')

import pytest
import oggm
import sys

import ssl
ssl._create_default_https_context = ssl._create_unverified_context

if os.name == 'nt':
    sys.exit(0)

initial_dir = os.getcwd()
oggm_file = os.path.abspath(oggm.__file__)
oggm_dir = os.path.dirname(oggm_file)

sys.exit(pytest.main([oggm_dir, '--mpl', '-k', 'not test_modelsection_withtrib']))
