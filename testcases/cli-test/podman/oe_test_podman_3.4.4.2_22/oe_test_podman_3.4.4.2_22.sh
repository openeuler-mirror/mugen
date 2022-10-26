#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@foxmail.com
# @Date      :   2022.10.20
# @License   :   Mulan PSL v2
# @Desc      :   podman-search
# ############################################

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    podman rm --all
    cp ../common/test.json .
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    podman search --limit 5 term | wc -l | grep 6
    CHECK_RESULT $? 0 0 'check podman search --limit 5 term | wc -l | grep 6 failed'
    podman search --no-trunc term | grep "docker.io"
    CHECK_RESULT $? 0 0 'check podman search --no-trunc term | grep "docker.io" failed'
    podman search --authfile test.json term | grep -i "DESCRIPTION"
    CHECK_RESULT $? 0 0 'check podman search --authfile test.json term | grep -i "DESCRIPTION" failed'
    podman search json --format json | grep "json"
    CHECK_RESULT $? 0 0 'check podman search json --format json | grep "json" failed'
    podman search --tls-verify true | grep -i "docker.io"
    CHECK_RESULT $? 0 0 'check podman search --tls-verify true | grep -i "docker.io" failed'
    podman pull docker.io/library/nginx
    CHECK_RESULT $? 0 0 'check podman pull docker.io/library/nginx failed'
    id=$(podman create --name postgres docker.io/library/nginx | sed -n '$p')
    test -z ${id}
    CHECK_RESULT $? 1 0 'check id failed'
    podman start postgres | grep postgres
    CHECK_RESULT $? 0 0 'check podman start postgres | grep postgres failed'
    podman ps -a | grep postgres | grep Up
    CHECK_RESULT $? 0 0 'check podman ps -a | grep postgres failed'
    podman stats -a --no-stream
    CHECK_RESULT $? 0 0 'check podman stats -a --no-stream failed'
    podman stats --no-stream ${id} | grep postgres
    CHECK_RESULT $? 0 0 'check podman stats --no-stream ${id} | grep postgres failed'
    podman stats --no-stream --format=json ${id} | grep postgres
    CHECK_RESULT $? 0 0 'check podman stats --no-stream --format=json ${id} | grep postgres failed'
    podman stats --no-stream --format "table {{.ID}} {{.Name}} {{.MemUsage}}" | grep postgres
    CHECK_RESULT $? 0 0 'check podman stats --no-stream --format failed'
    podman stop postgres
    CHECK_RESULT $? 0 0 'check odman stop postgres | grep postgres failed'
    podman ps -a | grep postgres | grep Exited
    podman rm ${id}
    CHECK_RESULT $? 0 0 'check podman rm ${id} failed'
    podman search --limit 3 fedora 2>&1 | grep "docker.io/library/fedora"
    CHECK_RESULT $? 0 0 'check podman search --limit 3 fedora 2>&1 | grep "docker.io/library/fedora" failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf test.json
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
