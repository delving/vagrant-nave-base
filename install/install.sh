#!/bin/bash

# Update APT database
apt-get update -y

# Useful tools
apt-get install -y vim git curl gettext build-essential

# Dependencies for PIL
apt-get install -y libjpeg-dev libtiff-dev zlib1g-dev libfreetype6-dev liblcms2-dev

# Redis
apt-get install -y redis-server

# PostgreSQL
apt-get install -y postgresql libpq-dev

# RabbitMQ

apt-get install -y rabbitmq-server

# Java for Elasticsearch
apt-get install -y openjdk-7-jre-headless

# Dependencies for Python
apt-get install -y libssl-dev libncurses-dev liblzma-dev libgdbm-dev libsqlite3-dev libbz2-dev tk-dev libreadline6-dev


# Python 2.7
curl https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz | tar xvz
cd Python-2.7.9
./configure
make
make install
cd ..
rm -rf Python-2.7.9

python2 -m ensurepip

pip2.7 install virtualenv wheel
su - vagrant -c "pip2.7 wheel psycopg2==2.6"
su - vagrant -c "pip2.7 wheel libsass==0.7.0"
su - vagrant -c "pip2.7 wheel libsass==0.8.2"
su - vagrant -c "pip2.7 wheel Pillow==2.8.1"


# Python 3.4
curl https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz | tar xvz
cd Python-3.4.3
./configure
make
make install
cd ..
rm -rf Python-3.4.3

pip3.4 install wheel
su - vagrant -c "pip3.4 wheel psycopg2==2.6"
su - vagrant -c "pip3.4 wheel libsass==0.7.0"
su - vagrant -c "pip3.4 wheel libsass==0.8.2"
su - vagrant -c "pip3.4 wheel Pillow==2.8.1"


# Tell PIP where to find wheel files
echo "export PIP_FIND_LINKS=/home/vagrant/wheelhouse" >> /home/vagrant/.bashrc


# Create vagrant pgsql superuser
su - postgres -c "createuser -s vagrant"


# Install Fabric and Sphinx
pip2.7 install Fabric==1.10.1 Sphinx==1.2.3


# Elasticsearch
echo "Downloading ElasticSearch..."
wget -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.deb
dpkg -i elasticsearch-1.4.4.deb
update-rc.d elasticsearch defaults 95 10
service elasticsearch start
rm elasticsearch-1.4.4.deb


# Fuseki
echo "Downloading Apacha Fuseki2..."
wget -q http://www.interior-dsgn.com/apache/jena/binaries/apache-jena-fuseki-2.0.0.tar.gz
tar xvzf apache-jena-fuseki-2.0.0.tar.gz
mv apache-jena-fuseki-2.0.0 /opt/fuseki
cp /opt/fuseki/fuseki /etc/init.d/
rm -rf apache-jena-fuseki-2.0.0.tar.gz
mkdir /opt/fuseki/run
echo "FUSEKI_HOME=/opt/fuseki/" >> /etc/default/fuseki
echo "FUSEKI_BASE=/opt/fuseki/run/" >> /etc/default/fuseki
update-rc.d fuseki defaults 95 10
service fuseki start
# fuseki configuration
#cat > /opt/fuseki/run/configuration/nave.ttl << EOL
#@prefix :      <http://base/#> .
#@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
#@prefix fuseki: <http://jena.apache.org/fuseki#> .
#@prefix tdb:   <http://jena.hpl.hp.com/2008/tdb#> .
#@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
#@prefix ja:    <http://jena.hpl.hp.com/2005/11/Assembler#> .
#
#[ ja:loadClass  "com.hp.hpl.jena.tdb.TDB" ] .
#
#tdb:DatasetTDB  rdfs:subClassOf  ja:RDFDataset .
#
#tdb:GraphTDB  rdfs:subClassOf  ja:Model .
#
#:service_tdb_all  a                   fuseki:Service ;
#        rdfs:label                    "TDB nave" ;
#        fuseki:dataset                :tdb_dataset_readwrite ;
#        fuseki:name                   "nave" ;
#        fuseki:serviceQuery           "query" , "sparql" ;
#        fuseki:serviceReadGraphStore  "get" ;
#        fuseki:serviceReadWriteGraphStore
#                "data" ;
#        fuseki:serviceUpdate          "update" ;
#        fuseki:serviceUpload          "upload" .
#
#:tdb_dataset_readwrite
#        a             tdb:DatasetTDB ;
#        ja:context    [ ja:cxtName   "arq:queryTimeout" ;
#                        ja:cxtValue  "3000"
#                      ] ;
#        tdb:location  "/opt/fuseki/run/databases/nave";
#        tdb:unionDefaultGraph true ;
#	.
#EOL
#
#cat > /opt/fuseki/run/configuration/nave_acceptance.ttl << EOL
#@prefix :      <http://base/#> .
#@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
#@prefix fuseki: <http://jena.apache.org/fuseki#> .
#@prefix tdb:   <http://jena.hpl.hp.com/2008/tdb#> .
#@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
#@prefix ja:    <http://jena.hpl.hp.com/2005/11/Assembler#> .
#
#[ ja:loadClass  "com.hp.hpl.jena.tdb.TDB" ] .
#
#tdb:DatasetTDB  rdfs:subClassOf  ja:RDFDataset .
#
#tdb:GraphTDB  rdfs:subClassOf  ja:Model .
#
#:service_tdb_all  a                   fuseki:Service ;
#        rdfs:label                    "TDB nave-acceptance" ;
#        fuseki:dataset                :tdb_dataset_readwrite ;
#        fuseki:name                   "nave-acceptance" ;
#        fuseki:serviceQuery           "query" , "sparql" ;
#        fuseki:serviceReadGraphStore  "get" ;
#        fuseki:serviceReadWriteGraphStore
#                "data" ;
#        fuseki:serviceUpdate          "update" ;
#        fuseki:serviceUpload          "upload" .
#
#:tdb_dataset_readwrite
#        a             tdb:DatasetTDB ;
#        ja:context    [ ja:cxtName   "arq:queryTimeout" ;
#                        ja:cxtValue  "3000"
#                      ] ;
#        tdb:location  "/opt/fuseki/run/databases/nave-acceptance";
#        tdb:unionDefaultGraph true ;
#	.
#EOL
#
#cat > /opt/fuseki/run/configuration/test.ttl << EOL
#@prefix :      <http://base/#> .
#@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
#@prefix fuseki: <http://jena.apache.org/fuseki#> .
#@prefix tdb:   <http://jena.hpl.hp.com/2008/tdb#> .
#@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
#@prefix ja:    <http://jena.hpl.hp.com/2005/11/Assembler#> .
#
#[ ja:loadClass  "com.hp.hpl.jena.tdb.TDB" ] .
#
#tdb:DatasetTDB  rdfs:subClassOf  ja:RDFDataset .
#
#tdb:GraphTDB  rdfs:subClassOf  ja:Model .
#
#:service_tdb_all  a                   fuseki:Service ;
#        rdfs:label                    "TDB test" ;
#        fuseki:dataset                :tdb_dataset_readwrite ;
#        fuseki:name                   "test" ;
#        fuseki:serviceQuery           "query" , "sparql" ;
#        fuseki:serviceReadGraphStore  "get" ;
#        fuseki:serviceReadWriteGraphStore
#                "data" ;
#        fuseki:serviceUpdate          "update" ;
#        fuseki:serviceUpload          "upload" .
#
#:tdb_dataset_readwrite
#        a             tdb:DatasetTDB ;
#        ja:context    [ ja:cxtName   "arq:queryTimeout" ;
#                        ja:cxtValue  "3000"
#                      ] ;
#        tdb:location  "/opt/fuseki/run/databases/test";
#        tdb:unionDefaultGraph true ;
#	.
#EOL

service fuseki restart


# Remove some large packages that we don't need
apt-get remove -y juju juju-core
apt-get remove -y libllvm3.4
apt-get autoremove -y

# Cleanup
apt-get clean

echo "Zeroing free space to improve compression..."
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
