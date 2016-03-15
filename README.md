OGGM Anaconda
=============

This repository contains files and scripts to help managing and setting up an Anaconda environment for OGGM.



Building
--------

The build scripts download and build all python modules that are needed to run OGGM.

They are intended to work on Linux, OSX(build.sh) and Windows(build.cmd).
It is required to run them from inside of an Anaconda environment.

To automaticaly update the build recipes to the latest commit from git master, an update.sh script is supplied.


Setting up an environment
-------------------------

Replace linux-64.txt with the one matching your system:

```
curl -k -o env.txt "https://raw.githubusercontent.com/TimoRoth/OGGM-Anaconda/master/environments/linux-64.txt"
conda create --name oggm_env --file env.txt
```

This should give you an environment called oggm_env in which OGGM is ready for use.


Alternatively it's possible to install oggm manually, getting the latest versions of all involved packages:

```
conda create --name oggm_env python=3.5
conda install -c ioos -c oggm oggm
```
