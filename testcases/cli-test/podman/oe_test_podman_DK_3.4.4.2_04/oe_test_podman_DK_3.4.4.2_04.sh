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
# @Contact   :   duanxuemin25812@163.com
# @Date      :   2022/10/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
# ############################################

source "../common/common_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    docker pull registry.access.redhat.com/ubi8-minimal
    docker run --name postgres registry.access.redhat.com/ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker ps --filter name=postgres
    CHECK_RESULT $? 0 0 'check docker ps --filter name=postgres failed'
    docker ps -q
    CHECK_RESULT $? 0 0 'check docker ps -q failed'
    docker ps -s | grep SIZE
    CHECK_RESULT $? 0 0 'check docker ps -s | grep SIZE failed'
    docker run --name postgres2 registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check docker run --name postgres2 registry.access.redhat.com/ubi8-minimal failed'
    docker ps -a --sort names | awk '{print $NF}' | grep "postgres2"
    CHECK_RESULT $? 0 0 'check docker ps -a --sort names | grep "postgres2" failed'
    docker ps -a | grep "postgres"
    CHECK_RESULT $? 0 0 'check docker ps -a | grep "postgres" failed'
    docker ps -a --sort names | awk '{print $NF}' | grep "postgres"
    CHECK_RESULT $? 0 0 'check docker ps -a --sort names failed'
    docker stop postgres
    docker ps -a | grep postgres2 | grep Exited
    CHECK_RESULT $? 0 0 'check docker stop postgres2 failed'
    docker rm postgres2
    docker ps -a | grep postgres2
    CHECK_RESULT $? 1 0 'check docker rm postgres2 failed'
    docker ps -aq | grep "$(ls /run/crun/ | cut -b 1-12)"
    CHECK_RESULT $? 0 0 'check docker ps -aq | grep "$(ls /run/crun/ | cut -b 1-12)" failed'
    docker ps --no-trunc | grep "$(ls /run/crun/)"
    CHECK_RESULT $? 0 0 'check docker ps --no-trunc | grep "$(ls /run/crun/)" failed'
    docker ps --pod | grep "POD"
    CHECK_RESULT $? 0 0 'check docker ps --pod | grep "POD" failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
