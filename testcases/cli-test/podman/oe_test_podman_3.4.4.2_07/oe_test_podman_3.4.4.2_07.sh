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
    podman run --name postgres -dt -p 80:80/tcp docker.io/library/nginx
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    podman stop postgres
    podman wait --latest | grep [0-9]
    CHECK_RESULT $? 0 0 'check podman wait --latest | grep [0-9] failed'
    podman wait --interval 250 postgres | grep [0-9]
    CHECK_RESULT $? 0 0 'check podman wait --interval 250 postgres | grep [0-9] failed'
    podman start postgres
    podman kill -l
    CHECK_RESULT $? 0 0 'check podman kill -l failed'
    podman ps -a | grep "Exited"
    CHECK_RESULT $? 0 0 'check podman ps -a | grep "Exited" failed'
    podman start postgres
    podman kill -a
    CHECK_RESULT $? 0 0 'check podman kill -a failed'
    podman ps -a | grep "Exited"
    CHECK_RESULT $? 0 0 'check podman ps -a | grep "Exited" failed'
    podman start postgres
    podman kill -s KILL $(podman ps -q)
    CHECK_RESULT $? 0 0 'check podman kill -s KILL failed'
    podman ps -a | grep "Exited"
    CHECK_RESULT $? 0 0 'check podman ps -a | grep "Exited" failed'
    podman start postgres
    podman diff postgres | grep -E "C|A"
    CHECK_RESULT $? 0 0 'check podman diff postgres | grep -E "C|A" failed'
    podman diff --format json postgres | grep -E "changed|added"
    CHECK_RESULT $? 0 0 'check podman diff --format json postgres failed'
    podman version | grep "$(rpm -qa podman | awk -F "-" '{print $2}')"
    CHECK_RESULT $? 0 0 'check podman version failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
