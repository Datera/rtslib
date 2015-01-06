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

modname=ib_srpt
wwns=""

loaded=0
lsmod | grep '^'${modname}'\b' &>/dev/null && loaded=1
if [ ${loaded} == 0 ]; then
    echo "Module ${modname} not loaded." 1>&2
    exit 0
else
    echo "Module ${modname} is loaded." 1>&2
fi

ports="$(ls /sys/class/infiniband/*/ports/*/gids/0 2>/dev/null)"
if [ -z "${ports}" ]; then
    echo "No IB ports found." 1>&2
    exit 0
fi

for port in "${ports}"; do
    # Transform 'fe80:0000:0000:0000:0002:1903:000e:8acd' WWN notation to
    # '0xfe800000000000000002c903000e8acd'
    wwns="${wwns} $(cat port | sed -e s/fe80/0xfe80/ -e 's/\://g')"
done

echo "---" 1>&2
echo "${wwns}" | sed 's/^ //g' | tr " " "\n"
echo "---" 1>&2
