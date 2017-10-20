#!/bin/bash

if [ "`basename $0`" != "startup.sh" ]
then
    printf "\033[01;31m%s\033[00m\n" "Error: Init script cannot be run standalone, must be invoked by startup.sh script."
    exit 1
fi

mysql_install_db --user=root > /dev/null

if [ "$MYSQL_ROOT_PASSWORD" = "" ]
then
    MYSQL_ROOT_PASSWORD=admin123
    debug_message "MySQL root password: [%s]" "$MYSQL_ROOT_PASSWORD"
fi

MYSQL_DATABASE=${MYSQL_DATABASE:-""}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

[ ! -d "$MYSQL_RUN_DIR" ] && mkdir -p $MYSQL_RUN_DIR

batch=`mktemp`
if [ ! -f "$batch" ]
then
    error_message "Could not create temporary file [%s]" "$batch"
    return 1
fi

cat << EOF > $batch
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
EOF

if [ "$MYSQL_DATABASE" != "" ]
then
    debug_message "Creating database: [%s]" "$MYSQL_DATABASE"
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $batch

    if [ "$MYSQL_USER" != "" ]
    then
        debug_message "Creating user [%s] with password [%s]" "$MYSQL_USER" "$MYSQL_PASSWORD"
        echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $batch
    fi
fi

/usr/bin/mysqld --user=root --bootstrap --verbose=0 < $batch

rm -f $batch
