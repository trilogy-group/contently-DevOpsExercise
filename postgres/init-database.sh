#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" "$POSTGRES_DB" <<-EOSQL
	CREATE TABLE accidents (accident_date DATE);
	INSERT INTO accidents VALUES ('1999-12-31');
	INSERT INTO accidents VALUES ('2007-07-04');
	INSERT INTO accidents VALUES ('2015-11-02');
	INSERT INTO accidents VALUES ('2017-01-01');
EOSQL