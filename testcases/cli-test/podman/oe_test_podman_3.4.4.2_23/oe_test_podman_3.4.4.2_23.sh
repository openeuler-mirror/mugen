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
# @Date      :   2022.10.11
# @License   :   Mulan PSL v2
# @Desc      :   podman-mount-unmount
# ############################################

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    podman rm --all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    podman pull docker.io/library/nginx
    CHECK_RESULT $? 0 0 'check podman pull docker.io/library/nginx failed'
    id=$(podman create --name postgres docker.io/library/nginx)
    test -z ${id}
    CHECK_RESULT $? 1 0 'check id=$(podman create --name postgres docker.io/library/nginx) failed'
    podman start postgres
    CHECK_RESULT $? 0 0 'check podman start postgres failed'
    podman top -l | grep "USER"
    CHECK_RESULT $? 0 0 'check podman top -l | grep "USER" failed'
    podman top postgres | grep "USER"
    CHECK_RESULT $? 0 0 'check podman top postgres | grep "USER" failed'
    podman mount --format json | grep "id"
    CHECK_RESULT $? 0 0 'check podman mount --format json | grep "id" failed'
    podman mount --notruncate | grep merged
    CHECK_RESULT $? 0 0 'check podman mount --notruncate | grep merged failed'
    podman stop postgres
    CHECK_RESULT $? 0 0 'check podman stop postgres failed'
    podman unmount -f postgres | grep postgres
    CHECK_RESULT $? 0 0 'check podman unmount -f postgres | grep postgres failed'
    podman mount postgres
    CHECK_RESULT $? 0 0 'check podman mount postgres failed'
    podman unmount --all
    CHECK_RESULT $? 0 0 'check podman unmount --all failed'
    podman rm postgres | grep ${id}
    CHECK_RESULT $? 0 0 'check podman rm postgres | grep ${id} failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
