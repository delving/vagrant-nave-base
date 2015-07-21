#!/bin/bash

# to build nave-base-v1.0.0.box:
vagrant destroy
vagrant up
vagrant halt
rm -f nave-base-v1.0.0.box
vagrant package --output nave-base-v1.0.0.box

# to install locally:
# vagrant box add nave-base-v1.0.0 nave-base-v1.0.0.box
