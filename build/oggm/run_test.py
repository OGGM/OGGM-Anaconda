#!/usr/bin/env python

import pytest
import os
import oggm
import sys

import ssl
ssl._create_default_https_context = ssl._create_unverified_context

import matplotlib
matplotlib.use('agg')

initial_dir = os.getcwd()
oggm_file = os.path.abspath(oggm.__file__)
oggm_dir = os.path.dirname(oggm_file)

sys.exit(pytest.main([oggm_dir, '--mpl']))
