#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export SOLR_USER="solr"

# the data folder, need chown after docker volume mount
chown -R solr /solr/example/cloud

# update log4j to use GELF if provided
/update-gelf-log4j.sh /tmp/log4j.properties /solr/example/resources/log4j.properties

if [ $# -gt 0 ]; then
    exec $@
else
    if [ "$(whoami)" = "root" ]; then
        su - "$SOLR_USER" <<-EOF
            # preserve PATH from root
            export PATH="$PATH"
            /solr-start.sh
EOF
    else
        /solr-start.sh
    fi
fi