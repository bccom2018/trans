#!/bin/bash

FAILED=0

echo -ne "mdspell "
mdspell --version
echo -ne "mdl "
mdl --version

# This performs spell checking and style checking over markdown files in a content
# directory. 
check_content() {

    CHANGED_FILES=$(git diff -r --no-commit-id --name-only HEAD..master)

    echo ${CHANGED_FILES[@]}

    exit 0

    for month in $(ls 2019)
    do  
        if [[ ${month} -ge "05" ]]; then
           mdspell en --ignore-acronyms --ignore-numbers --no-suggestions --report "2019/${month}/*/*.md"
        fi
    done
    
    if [[ "$?" != "0" ]]
    then
        FAILED=1
    fi

    for month in $(ls 2019)
    do  
        if [[ ${month} -ge "05" ]]; then
            mdl --ignore-front-matter --style mdl_style.rb "2019/${month}"
        fi
    done
   
    if [[ "$?" != "0" ]]
    then
        FAILED=1
    fi
}

check_content . --en-us

if [[ ${FAILED} -eq 1 ]]
then
    echo "LINTING FAILED"
    exit 1
fi
