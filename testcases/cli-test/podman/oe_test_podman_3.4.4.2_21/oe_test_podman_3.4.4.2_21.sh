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
# @Desc      :   podman-start-pause-unpause
# ############################################

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    podman rm --all
    podman rmi --all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    podman create --name postgres docker.io/library/nginx
    CHECK_RESULT $? 0 0 'check podman create --name postgres docker.io/library/nginx failed'
    podman create --name test1 docker.io/library/nginx
    CHECK_RESULT $? 0 0 'check podman create --name test1 docker.io/library/nginx failed'
    podman create --name new_name docker.io/library/nginx
    CHECK_RESULT $? 0 0 'check podman create --name new_name docker.io/library/nginx failed'
    podman ps -a | grep -E "postgres|test1|new_name"
    CHECK_RESULT $? 0 0 'check podman ps -all | grep -E "postgres|test1|new_name" failed'
    podman start postgres new_name test1
    podman ps -a | grep postgres | grep Up
    CHECK_RESULT $? 0 0 'check podman start postgres  failed'
    podman ps -a | grep new_name | grep Up
    CHECK_RESULT $? 0 0 'check podman start new_name  failed'
    podman ps -a | grep test1 | grep Up
    CHECK_RESULT $? 0 0 'check podman start test1 failed'
    podman stop -i -l
    podman start -i -l
    podman ps -a | grep new_name | grep Up
    CHECK_RESULT $? 0 0 'check podman start -i -l failed'
    podman pause test1 new_name
    CHECK_RESULT $? 0 0 'check podman pause test1 new_name failed'
    podman ps -a | grep test1 | grep paused
    CHECK_RESULT $? 0 0 'check podman ps -a | grep test1 failed'
    podman unpause test1 new_name
    CHECK_RESULT $? 0 0 'check podman unpause test1 new_name failed'
    podman ps -a | grep test1 | grep Up
    CHECK_RESULT $? 0 0 'check podman test1 status failed'
    podman stop postgres test1 new_name
    CHECK_RESULT $? 0 0 'check podman stop postgres test1 new_name failed'
    podman ps -a | grep test1 | grep Exited
    CHECK_RESULT $? 0 0 'check podman stop postgres test1 new_name failed'
    podman ps -a | grep postgres | grep Exited
    CHECK_RESULT $? 0 0 'check podman stop postgres test1 new_name failed'
    podman ps -a | grep new_name | grep Exited
    CHECK_RESULT $? 0 0 'check podman stop postgres test1 new_name failed'
    podman rm postgres test1 new_name
    CHECK_RESULT $? 0 0 'check podman stop postgres test1 new_name failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
