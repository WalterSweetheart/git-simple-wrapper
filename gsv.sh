#!/bin/bash

if [ -n "$1" ]
then
    if [[ "$1" == "set" ]] && [[ "$3" == "to" ]]
    then
        eval "git config --global \"$2\" \"$4\""
        exit 0
    elif [[ "$1" == "show" ]]
    then
        if [[ "$2" == "settings" ]]
        then
            eval "git config --list"
            exit 0
        elif [[ "$2" == "history" ]]
        then
            eval "git log"
            exit 0
        elif [[ -n "$2" ]]
        then
            eval "git config \"$2\""
            exit 0
        fi
    elif [[ "$1" == "init" ]]
    then
        eval "git init"
        eval "git add *"
        eval "git commit -m \"0.0.0\" -m \"Initial commit\""
        exit 0
    elif [[ "$1" == "add" ]] && [[ -n "$3" ]]
    then
        VERSION="$(git log -1 --pretty=%B | head -n 1)"
        NEW_VERSION=${VERSION%.*}.$((${VERSION##*.}+1))
        if [[ "$2" == "feat"     ]] ||
           [[ "$2" == "fix"      ]] ||
           [[ "$2" == "docs"     ]] ||
           [[ "$2" == "style"    ]] ||
           [[ "$2" == "refactor" ]] ||
           [[ "$2" == "test"     ]] ||
           [[ "$2" == "chore"    ]]
        then
            eval "git add *"
            eval "git commit -m \"$NEW_VERSION\" -m \"$2: $3\""
            exit 0
        fi
    elif [[ "$1" == "next" ]] && [[ -n "$2" ]] && [[ -n "$3" ]]
    then
        VERSION="$(git log -1 --pretty=%B | head -n 1)"
        NEW_VERSION_MAJOR=${VERSION%%.*}
        NEW_VERSION_MINOR=${VERSION%.*}
        NEW_VERSION_MINOR=${NEW_VERSION_MINOR#*.}
        NEW_VERSION_SUB=${VERSION##*.}
        if [[ "$2" == "major" ]]
        then
            ((NEW_VERSION_MAJOR += 1))
            NEW_VERSION_MINOR=0
            NEW_VERSION_SUB=0
        elif [[ "$2" == "minor" ]]
        then
            ((NEW_VERSION_MINOR += 1))
            NEW_VERSION_SUB=0
        elif [[ "$2" == "sub" ]]
        then
            ((NEW_VERSION_SUB += 1))
        else
            echo "Error: unknown command" >&2
            exit 1
        fi
        eval "git add *"
        eval "git commit -m \"$NEW_VERSION_MAJOR.$NEW_VERSION_MINOR.$NEW_VERSION_SUB\" -m \"$3\" --allow-empty"
        exit 0
    fi
fi

echo "Usage: gsw [command]"                                                                             >&2
echo "           set <setting> to <value>  -- sets setting to value in git config globally"             >&2
echo "           show [what]"                                                                           >&2
echo "                settings  -- shows settings list"                                                 >&2
echo "                <setting>  -- shows setting"                                                      >&2
echo "           add [type]"                                                                            >&2
echo "               feat     <message>  -- adds sub feat commit"                                       >&2
echo "               fix      <message>  -- adds sub fix commit"                                        >&2
echo "               docs     <message>  -- adds sub docs commit"                                       >&2
echo "               fix      <message>  -- adds sub fix commit"                                        >&2
echo "               style    <message>  -- adds sub style commit"                                      >&2
echo "               refactor <message>  -- adds sub refactor commit"                                   >&2
echo "               test     <message>  -- adds sub test commit"                                       >&2
echo "               chore    <message>  -- adds sub chore commit"                                      >&2
echo "           next [type]"                                                                           >&2
echo "                major <message>  -- increases major version and makes commit with message"        >&2
echo "                minor <message>  -- increases minor version and makes commit with message"        >&2
echo "                sub   <message>  -- increases sub version and makes commit with message"          >&2
exit 1
