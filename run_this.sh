#!/bin/bash

set -ev

echo $TRAVIS_MARIADB_VERSION

echo `mysql -V`
