#!/bin/bash
su postgres <<'EOF'
CMD=$(ls -1 /usr/lib/postgresql/*/bin/postgres | sort -r | head -n 1)

cd /etc/postgresql/9.5/main

# Handoff to PostgreSQL
exec /usr/bin/env -i "${CMD}" --config-file=postgresql.conf &

# Wait for PostgreSQL to start
until psql -U postgres -c "SELECT 1" > /dev/null 2>&1; do
    sleep 1
done

createuser -s pgeadmin
createdb exercisesrw99

EOF

sudo /etc/init.d/tomcat7 start
sudo /etc/init.d/nginx start

cd /pgexercises/scripts
./processdocs.pl ../ 1 > /dev/null 2>&1

sleep infinity