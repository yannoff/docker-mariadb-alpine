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

if [ ! -d $MYSQL_DATA_DIR/mysql ]
then
    commandHelp="docker run --rm -d"
    for e in `env | awk -F "=" '/^MYSQL/ { printf " -e %s=%s", $1, $2; }'`
    do
        commandHelp="$commandHelp $e"
    done 
    commandHelp="$commandHelp -v \"\$(pwd)\":/var/lib/mysql yannoff/mariadb-light-init"
    debug_message "MySQL data directory not found, you must create initial DB first using init image: "
    debug_message $commandHelp
    exit 0
fi

exec /usr/bin/mysqld --user=root --console
