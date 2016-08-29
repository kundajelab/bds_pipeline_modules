#!/bin/bash

## conda environment name

ENV_NAME=bds_pipeline_default
ENV_NAME_PY3=bds_pipeline_default_py3

conda env remove --name ${ENV_NAME} -y
conda env remove --name ${ENV_NAME_PY3} -y
