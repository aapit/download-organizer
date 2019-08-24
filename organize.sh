#!/bin/bash
# @author David Spreekmeester <@aapit>
# ______________________________________________________________________________

DIR=$(dirname $(readlink -f "$0"))
. $DIR/utils.lib.sh

# ______________________________________________________________________________

isComment() {
    local firstChar="$(echo ${1} | head -c 1)"
    [ "${firstChar}" = "#" ] && echo true
}
addTrailingSlash() {
    local lastChar="$(echo ${1} | tail -c 1)"
    [ "${lastChar}" = "/" ] && echo $1 || echo $1/
}
findFilesByPattern() {
    # $1 pattern
    # $2 scanPath
    local scanPath=$(addTrailingSlash $2)
    find $scanPath -maxdepth 1 -iname $1 -exec echo {} \;
}
findAndMove () {
    local pattern="$1"
    local scanPath="$2"
    local target="$3"

    [ -d "$target" ] && [ ! -w "$target" ] \
        && echo "$target dir is not writable." && exit

    foundFiles=$(findFilesByPattern $pattern $scanPath)
    for f in $foundFiles; do
        local expandedTarget="$(expandConfigVars $target $f)"
        mv "$f" "$expandedTarget" \
            && printf "\n\t🧹 Moved \n\t  " \
            && cprintf $(basename $f) 34 \
            && printf " to \n\t  " \
            && cprintf "$(basename $expandedTarget)\n" 36
    done
}

expandConfigVars() {
    # $1 Target path to expand
    # $2 The filename that was found
    local basename=$(basename $2)
    echo $(str_replace '%FILENAME%' ${basename} $1)
}

loopScans() {
    while read -r scanLine; do
        [ -z "$scanLine" ] && continue
        [ $(isComment $scanLine) ] && hr && cecho "$scanLine" 35 && continue

        local fc="$(echo $scanLine | head -c 2)"

        local scanParams=($scanLine)
        eval scanPath=${scanParams[1]}
        eval targetPath=${scanParams[2]}
        findAndMove ${scanParams[0]} $scanPath $targetPath
    done < ${DIR}/scans.config
}

# ______________________________________________________________________________

loopScans
