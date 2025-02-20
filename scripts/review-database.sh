#!/bin/bash

# Review database contents
#
# First, switch to postgres user
# su - postgres

psql -c "\l "
psql -c "\dt "
psql -c "\dn+ "
