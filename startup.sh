#!/bin/sh

export MYSQL_RUN_DIR=/run/mysqld
export MYSQL_DATA_DIR=/var/lib/mysql

_message(){
    local level template color
    level=$1
    shift
    template=$1
    shift
    case level in
        INFO)
        color="\033[01;32m"
        ;;
        ERROR)
        color="\033[01;34m"
        ;;
    esac
    printf "\033[01;32m[%s] $template\033[00m\n" $level $@
}

debug_message(){
    _message "INFO" "$@"
}

error_message(){
    _message "ERROR" "$@"
}

if [ -d $MYSQL_DATA_DIR/mysql ]
then
    debug_message "MySQL directory already present, skipping creation"
else
    debug_message "MySQL data directory not found, creating initial DBs"
    . /init.sh
fi

exec /usr/bin/mysqld --user=root --console
