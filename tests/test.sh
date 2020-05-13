#!/usr/bin/env bash

set -e
set -o pipefail
IFS=$'\n'

p=$(dirname "$0")

# yaml
echo Linting yaml files
yamllint -c "$p"/../.yamllint "$p"/../

# python
echo Linting python files
pycodestyle "$p"/../
# find "$p"/../ -type f -name '*.py' | while read -r file; do set -e && pylint "$file" --rcfile="$p"/../setup.cfg; done;

# ansible
for f in $(find "$p/../playbooks" -type f -not \( -iwholename '*.git*' -o -iwholename '*.tmp*'  \) | sort -u) ; do
    if file "$f" | grep -i --quiet "text" ; then
        if [[ "$f" = *.yaml || "$f" = *.yml ]]; then
            ansible-lint -v "$f"
            ansible-playbook "$f" --syntax-check
        fi
    fi
done

echo Success

exit 0
