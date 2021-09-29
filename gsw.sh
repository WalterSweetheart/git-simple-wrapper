#!/bin/bash

if [ -n "$1" ]
then
    if [ "$1" = "set" ] && [ "$3" = "to" ]
    then
        eval "git config --global \"$2\" \"$4\""
        exit 0
    elif [ "$1" = "show" ]
    then
        if [ "$2" = "history" ]
        then
            eval "git log"
            exit 0
        elif [ "$2" = "settings" ]
        then
            eval "git config --list"
            exit 0
        elif [ -n "$2" ]
        then
            eval "git config \"$2\""
            exit 0
        fi
    elif [ "$1" = "create" ] && [ "$2" = "repo" ]
    then
        if [ "$3" = "locally" ]
        then
            eval "git init"
            eval "git add -A"
            eval "git commit -m \"0.0.0\" -m \"break: initial commit\""
            exit 0
        elif [ "$3" = "at" ] && [ -n "$4" ]
        then
            eval "git init"
            eval "git add -A"
            eval "git commit -m \"0.0.0\" -m \"break: initnal commit\""
            eval "git remote add origin $4"
            eval "git push --set-upstream origin main --force"
            exit 0
        elif [ "$3" = "from" ] && [ -n "$4" ]
        then
            eval "rm -rf * .*"
            eval "git clone $4 ."
            exit 0
        fi
    elif [ "$1" = "connect" ] && [ "$2" = "to" ] && [ -n "$3" ]
    then
        eval "git remote remove origin"
        eval "git remote add origin $3"
        eval "git push --set-upstream origin main --force"
    elif [ "$1" = "add" ] &&
         ( [ "$2" = "break" ] ||
           [ "$2" = "feat"  ] ||
           [ "$2" = "fix"   ] ) &&
         [ -n "$3" ]
    then
        VERSION=$( git log -1 --pretty=%B | head -n 1 )
        VERSION_MAJOR=${VERSION%%.*}
        VERSION_MINOR=${VERSION%.*}
        VERSION_MINOR=${VERSION_MINOR#*.}
        VERSION_SUB=${VERSION##*.}
        if [ "$2" = "break" ]
        then
            VERSION_MAJOR=$(( $VERSION_MAJOR + 1 ))
            VERSION_MINOR=0
            VERSION_SUB=0
        elif [ "$2" = "feat" ]
        then
            VERSION_MINOR=$(( $VERSION_MINOR + 1 ))
            VERSION_SUB=0
        elif [ "$2" = "fix" ]
        then
            VERSION_SUB=$(( $VERSION_SUB + 1 ))
        fi
        VERSION="$VERSION_MAJOR.$VERSION_MINOR.$VERSION_SUB"
        eval "git add -A"
        eval "git commit -m \"$VERSION\" -m \"$2: $3\""
        eval "git push"
        exit 0
    fi
fi

echo "GSW -- git simple wrapper by WalterSweetheart"                                                                >&2
echo "Usage: gsw"                                                                                                   >&2
echo "           set <setting> to <value>  -- sets setting to value in git config"                                  >&2
echo "           show"                                                                                              >&2
echo "                history    -- shows git log"                                                                  >&2
echo "                settings   -- shows setting list"                                                             >&2
echo "                <setting>  -- shows setting value"                                                            >&2
echo "           create repo"                                                                                       >&2
echo "                       locally  -- creates new git repo and initial commit"                                   >&2
echo "                       at <link>  -- creates new repo, initial commit, connects to repo and pushes with force">&2
echo "                       from <link>  -- erases all files and clones repo"                                      >&2
echo "           connect to <link>  -- connect to repo and pushes with force"                                       >&2
echo "           add"                                                                                               >&2
echo "               break <message>  -- makes major break commit and pushes it"                                    >&2
echo "               feat  <message>  -- makes minor feat commit and pushes it"                                     >&2
echo "               fix   <message>  -- makes sub fix commit and pushes it"                                        >&2
exit 1
