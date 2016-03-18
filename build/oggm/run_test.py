#!/usr/bin/env python

import nose
import os
import oggm
import sys

import matplotlib
matplotlib.use('Agg')

initial_dir = os.getcwd()
oggm_file = os.path.abspath(oggm.__file__)
oggm_dir = os.path.dirname(oggm_file)
os.chdir(oggm_dir)

nose_argv = sys.argv
nose_argv += ['--detailed-errors', '--exe']

nose.main(argv=nose_argv)


