Vagrant box for Nave site development
========================================

A Vagrant box based on Ubuntu trusty64, with the dependencies for developing Nave sites preinstalled.

Usage
-----

This box is available on Vagrant cloud (aka Atlas) so can be used by just setting your base box to ``delving/nave``.

To create a new Vagrantfile that uses this box, run the following:

```
vagrant init delving/nave
```

What's inside
-------------

 - Python 2.7.9 with virtualenv and pip
 - Python 3.4.3 with pip (use bundled pyvenv for virtual environments)
 - PostgreSQL 9.3.6
 - Redis 2.8.4
 - Elasticsearch 1.4.4
 - Rabbitmq-server 3.2.4-1
 - Apache Fuseki 2.0.0
 - Vim, Git, GCC (with C++ support)
 - Development headers for Python (2 and 3), PostgreSQL and some image libraries (libjpeg, zlib, etc)
 - Prebuilt wheels for Pillow 2.8.1, psycopg2 2.6 and libsass 0.7.0 for both python versions (and pip configured to use them)


Build instructions
------------------

Install 'virtualbox' and 'vagrant' on your local machine.

(Mac OS X users with brew installed can run: `brew tap caskroom/cask ; brew install brew-cask ; brew cask install virtualbox vagrant` )

To generate the .box file:

    ./build.sh

To install locally:

    vagrant box add nave-base-v1.0.0 nave-base-v1.0.0.box


Deploying your build to Atlas (http://atlas.hashicorp.com)
----------------------------------------------------------

Install packer: either download or install with 'brew cask update; brew cask install packer'



