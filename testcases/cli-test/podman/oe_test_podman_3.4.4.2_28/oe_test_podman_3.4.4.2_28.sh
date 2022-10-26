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
# @Desc      :   Backup / restore database
# ############################################

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    podman rm -all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    podman pod create --infra=false
    CHECK_RESULT $? 0 0 'check podman pod create --infra=false failed'
    name=$(podman pod ls | sed -n 2p | awk {'print$2'})
    test -z ${name}
    CHECK_RESULT $? 1 0 'check name failed'
    podman pod ls | grep ${name}
    CHECK_RESULT $? 0 0 'check podman pod ls | grep ${name} failed'
    podman pod ps | grep ${name}
    CHECK_RESULT $? 0 0 'check podman pod ps | grep ${name} failed'
    podman pod list | grep ${name}
    CHECK_RESULT $? 0 0 'check podman pod list | grep ${name} failed'
    podman pod pause ${name}
    CHECK_RESULT $? 0 0 'check podman pod pause ${name} failed'
    podman pod unpause ${name}
    CHECK_RESULT $? 0 0 'check podman pod unpause ${name} failed'
    podman pod inspect ${name}
    CHECK_RESULT $? 0 0 'check podman pod inspect ${name} failed'
    nohup openvpn podman pod stats ${name} >/dev/null 2>&1 &
    local_pid=$(echo $!)
    CHECK_RESULT $? 0 0 'check local_pid failed'
    podman pod stop ${name}
    CHECK_RESULT $? 0 0 'check podman pod stop ${name} failed'
    podman pod rm ${name}
    CHECK_RESULT $? 0 0 'check podman pod rm ${name} failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    kill -9 $local_pid
    LOG_INFO "Finish environment cleanup."
}

main $@
