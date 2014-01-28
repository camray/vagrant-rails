#!/usr/bin/env bash

sudo apt-get update
yes | sudo apt-get install curl postgresql postgresql-client git libpq-dev nodejs
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm requirements
rvm install 2.0.0

rvm use 2.0.0 --default
gem install rails --no-rdoc --no-ri

echo 'export LANGUAGE="en_US.UTF-8"
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"' | sudo tee -a /etc/apt/sources.list
echo "
  update pg_database set datistemplate=false where datname='template1';
  drop database Template1;
  create database template1 with owner=postgres encoding='UTF-8'
    lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;
  update pg_database set datistemplate=true where datname='template1';
  " | sudo tee -a sql.sql

# REPLACE THIS WITH YOUR DB USERNAME AND PASSWORD
sudo -u postgres psql postgres -c "CREATE USER [USERNAME] WITH PASSWORD [PASSWORD] SUPERUSER" 
sudo -u postgres psql -f sql.sql
sudo rm sql.sql

cd /vagrant
bundle
# # I usually include a makefile that sets up the database
# make setup
# # you could replace with: 
# rake db:create
# rake db:migrate
# rake db:seed
rails s