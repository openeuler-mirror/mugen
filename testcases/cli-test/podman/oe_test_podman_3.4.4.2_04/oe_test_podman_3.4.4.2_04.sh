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
# @Contact   :   duanxuemin@163.com
# @Date      :   2022/10/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
# ############################################

source "../common/common3.4.4.2_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull registry.access.redhat.com/ubi8-minimal
    podman run --name postgres registry.access.redhat.com/ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    podman ps --filter name=postgres
    CHECK_RESULT $? 0 0 'check podman ps --filter name=postgres failed'
    podman ps -q
    CHECK_RESULT $? 0 0 'check podman ps -q failed'
    podman ps -s | grep SIZE
    CHECK_RESULT $? 0 0 'check podman ps -s | grep SIZE failed'
    podman run --name postgres2 registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check podman run --name postgres2 registry.access.redhat.com/ubi8-minimal failed'
    podman ps -a --sort names | awk '{print $NF}' | grep "postgres2"
    CHECK_RESULT $? 0 0 'check podman ps -a --sort names failed'
    podman ps -a | grep "postgres"
    CHECK_RESULT $? 0 0 'check podman ps -a | grep "postgres" failed'
    podman ps -a --sort names | awk '{print $NF}' | grep "postgres"
    CHECK_RESULT $? 0 0 'check podman ps -a --sort names | awk '{print $NF}' | grep "postgres" failed'
    podman stop postgres2
    CHECK_RESULT $? 0 0 'check stop postgres2 failed'
    podman rm postgres2
    CHECK_RESULT $? 0 0 'check rm postgres2 failed'
    podman ps -aq | grep "$(ls /run/crun/ | cut -b 1-12)"
    CHECK_RESULT $? 0 0 'check podman ps -aq | grep "$(ls /run/crun/ | cut -b 1-12)" failed'
    podman ps --no-trunc | grep "$(ls /run/crun/)"
    CHECK_RESULT $? 0 0 'check podman ps --no-trunc failed'
    podman ps --pod | grep "POD"
    CHECK_RESULT $? 0 0 'check podman ps --pod | grep "POD" failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
