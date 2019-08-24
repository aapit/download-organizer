#!/bin/sh
# @author David Spreekmeester <@aapit>
# ______________________________________________________________________________

str_replace() {
    # Replaces all occurrences of a substring and outputs result
    # $1 search
    # $2 replace
    # $3 subject
    echo $(echo "$3" | sed -e "s/$1/$2/g")
}
cprintf() {
    # Prints colorized string, without newline
    # $1 string
    # $2 color (int), like 32
    printf "\e[${2}m"
    printf "$1"
    printf "\e[39m"
}
cecho() {
    # Echoes colorized string, followed by newline
    # $1 string
    # $2 color (int), like 32
    cprintf "$1\n" $2
}
rprintf() {
    # Repeatedly prints a string, without newline
    # $1 string
    # $2 number of repeats (default 80)
    repeats=$2
    [ -z "${repeats}" ] && repeats="80"
    printf -- "${1}%.0s" $(seq ${repeats})
}
hr() {
    # Echoes a horizontal rules
    # $1 optional color code, like 32
    cecho $(rprintf '_') $([ -z "$1" ] && echo 34 || echo $1)
}
colorc() {
    # Prints color code (int) for given color name (string)
    # $1 color name, like 'green'
    # Example:
    #   cecho 'foobar' $(colorc green)
    case $1 in
        default)    printf '39';;
        red)        printf '31';;
        green)      printf '32';;
        yellow)     printf '33';;
        blue)       printf '34';;
        magenta)    printf '35';;
        cyan)       printf '36';;
        lightgray)  printf '37';;
        darkgrey)   printf '90';;
        white)      printf '97';;
    esac
}
self_dir() {
    # Returns the path to the directory the current running script resides in.
    # e.g. /home/user/bin
    SCRIPT=$(readlink -f "$0")
    echo $(dirname "$SCRIPT")
}
self_file() {
    # Returns the path to current running script.
    # e.g. /home/user/bin/foo.sh
    echo $(readlink -f "$0")
}
