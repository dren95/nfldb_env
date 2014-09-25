nfldb_env
=========

This project provides a vagrant environment with a configured installation of [nfldb](https://github.com/BurntSushi/nfldb) and a good bit of the python scientific stack. Python tools provided are:
* nfldb
* pillow
* numpy
* matplotlib
* scipy
* pandas
* scikit-learn
* pyzmq
* tornado
* jinja2
* ipython

What is Vagrant?
----------------

Vagrant is a tool for managing virtual machines. It allows a virtual machine to be created, typically a barebones install, which is then provisioned, or set up, to run required software. These preconfigured machines are referred to as a box in Vagrant parlance. Vagrant boxes can either be custom made or downloaded from the Vagrant cloud. This project is built upon an ubuntu 14.04 box from the vagrant cloud, ubuntu/trusty64.

A box is set up according to instructions found in the Vagrantfile. The Vagrantfile for this project runs a setup script to install and configure the desired software.

Installation
------------

First, get the latest version of Virtualbox from [https://www.virtualbox.org/](https://www.virtualbox.org/).

Next, get vagrant from [http://www.vagrantup.com](http://www.vagrantup.com).

If you're on linux you're good to go from here and you can skip to "Running the VM"

### Windows

If you're on windows you'll want some *nix like environment for git and ssh. I use git-bash, which provides both. You can get it here [http://git-scm.com/download/win](http://git-scm.com/download/win).

Running the VM
--------------

Start the VM with:
```bash
cd vagrant_ubuntu1404
vagrant up
```

It should take a little while to provision (20-30 min) after which it will be set up. The provision process is one time only.

To get into the VM run:
```bash
vagrant ssh
```
from the directory containing the Vagrantfile.

To stop the vm exit the ssh session and run:
```bash
vagrant halt
```

Running ipython notebook
------------------------

IPython notebook is configured to be accessible to the host machine on port 8888. To start IPython notebook run the following command inside the vm:
```bash
ipython notebook --profile=nbserver
```

To change which port ipython notebook uses on the host machine, edit the port forward rule in the Vagrantfile.

Configuring Vagrant To Share a Folder
-------------------------------------

Vagrant allows you to configure it to share a folder between the host OS and guest. You can create a user-level Vagrant file in $HOME/.vagrant.d/Vagrantfile (C:\Users\[USERNAME]\.vagrant.d\Vagrantfile) to specify this rule. I use it to share my projects directory to all of my VMs. Here are the contents of my user level Vagrantfile:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "/home/dren/projects", "/projects"
end
```
