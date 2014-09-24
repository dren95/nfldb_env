#!/bin/bash

# update ubuntu
sudo apt-get update
sudo apt-get upgrade

# install virtualenv for python, allows segregating dependencies for python projects
sudo apt-get install -y python-virtualenv

# install the python dev headers, needed for installing things from pip later on
sudo apt-get install -y python-dev

# install postgres, the database server used by nfldb
sudo apt-get install -y postgresql postgresql-contrib postgresql-server-dev-9.3

# install unzip because the nfldb database is a zip file
sudo apt-get install -y unzip

# install git because git
sudo apt-get install -y git

# perform nfldb database initialization tasks
# (from https://github.com/BurntSushi/nfldb/wiki/Installation-on-Ubuntu
#  and slightly modified for newer ubuntu version)
sudo mkdir /var/lib/postgresql/data
sudo chown -c -R postgres:postgres /var/lib/postgresql
sudo service postgresql restart
sudo sed -i.bak -e 's/local   all             all                                     peer/local   all             all                                     md5/' /etc/postgresql/9.3/main/pg_hba.conf
sudo service postgresql restart
sudo -u postgres createuser -E nfldb
sudo -u postgres psql -c "ALTER ROLE nfldb WITH ENCRYPTED PASSWORD 'touchdown';"
sudo -u postgres createdb -O nfldb nfldb
sudo -u postgres psql -c 'CREATE EXTENSION fuzzystrmatch;' nfldb

# At this point an nfldb user and an nfldb database are set up.
# To log into the db in the interactive shell, do 'psql -U nfldb nfldb' and
# use the password 'touchdown' that was set above.

# import the database, this takes a little while
# https://github.com/BurntSushi/nfldb/wiki/Installation#importing-the-nfldb-database
wget http://burntsushi.net/stuff/nfldb/nfldb.sql.zip
unzip nfldb.sql.zip
PGPASSWORD=touchdown psql -U nfldb nfldb < nfldb.sql

# install nfldb straight onto system instead of into a virtualenv since the
# point of this vm is to use nfldb
sudo pip2 install nfldb
# configure nfldb
mkdir -p /home/vagrant/.config/nfldb
cp /usr/local/share/nfldb/config.ini.sample /home/vagrant/.config/nfldb/config.ini
sed -i -e 's/YOUR PASSWORD/touchdown/' /home/vagrant/.config/nfldb/config.ini
# now that nfldb is installed, update to the latest data
sudo nfldb-update

# next install lots of tools for data analysis
# but first a bunch of system dependencies are needed
sudo apt-get install -y libjpeg-dev libpng-dev libfreetype6-dev libtiff-dev libwebp-dev liblcms2-dev libatlas-base-dev gfortran libzmq-dev

sudo pip2 install pillow
sudo pip2 install numpy
sudo pip2 install matplotlib
sudo pip2 install scipy
sudo pip2 install pandas
sudo pip2 install scikit-learn
sudo pip2 install pyzmq
sudo pip2 install tornado
sudo pip2 install jinja2
sudo pip2 install ipython

# configure ipython notebook to run as an external server
ipython profile create nbserver
sed -i -e "s/# c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '*'/" /home/vagrant/.ipython/profile_nbserver/ipython_notebook_config.py
sed -i -e "s/# c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/" /home/vagrant/.ipython/profile_nbserver/ipython_notebook_config.py

# ipython notebook can now be run with
# ipython notebook --profile=nbserver
# and it will be accessible at localhost:8888 in the host's browser
