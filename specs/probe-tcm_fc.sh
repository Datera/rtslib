#!/bin/bash
#
# This file is part of LIO(tm).
#
# Copyright (c) 2012-2014 by Datera, Inc.
# More information on www.datera.io.
#
# Original author: Jerome Martin <jxm@netiant.com>
#
# Datera and LIO are trademarks of Datera, Inc., which may be registered in some
# jurisdictions.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

set -e

modname=tcm_fc
wwns=""

loaded=0
lsmod | grep '^'${modname}'\b' &>/dev/null && loaded=1
if [ ${loaded} == 0 ]; then
    echo "Module ${modname} not loaded." 1>&2
    exit 0
else
    echo "Module ${modname} is loaded." 1>&2
fi

fc_hosts_dir=/sys/class/fc_host
fc_hosts=$(ls ${fc_hosts_dir})
if [ -z "${fc_hosts}" ]; then
    echo "No FCoE hosts found." 1>&2
    exit 0
fi

for host in ${fc_hosts}; do
    port_name="$(cat ${fc_hosts_dir}/${host}/port_name)"
    symbolic_name="$(cat ${fc_hosts_dir}/${host}/symbolic_name)"
    if echo "${symbolic_name}" | grep "^fcoe " &> /dev/null; then
        port_wwn="$(echo $port_name | sed -e s/0x// -e 's/../&:/g' -e s/:$//)"
        echo "Found ${symbolic_name} port ${port_wwn}" 1>&2
        wwns="${wwns} ${port_wwn}"
    else
        echo "Found alien port ${port_name}" 1>&2
    fi
done

if [ -z "${wwns}" ]; then
    echo "No FCoE hosts found." 1>&2
    exit 0
fi

echo "---" 1>&2
echo "${wwns}" | sed 's/^ //g' | tr " " "\n"
echo "---" 1>&2
