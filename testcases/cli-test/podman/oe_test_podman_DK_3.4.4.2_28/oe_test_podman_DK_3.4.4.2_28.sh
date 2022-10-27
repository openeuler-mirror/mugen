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
    docker rm -all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    docker pod create --infra=false
    CHECK_RESULT $? 0 0 'check docker pod create --infra=false failed'
    name=$(docker pod ls | sed -n 2p | awk {'print$2'})
    test -z ${name}
    CHECK_RESULT $? 1 0 'check name failed'
    docker pod ls | grep ${name}
    CHECK_RESULT $? 0 0 'check docker pod ls | grep ${name} failed'
    docker pod ps | grep ${name}
    CHECK_RESULT $? 0 0 'check docker pod ps | grep ${name} failed'
    docker pod list | grep ${name}
    CHECK_RESULT $? 0 0 'check docker pod list | grep ${name} failed'
    docker pod pause ${name}
    CHECK_RESULT $? 0 0 'check docker pod pause ${name} failed'
    docker pod unpause ${name}
    CHECK_RESULT $? 0 0 'check docker pod unpause ${name} failed'
    docker pod inspect ${name}
    CHECK_RESULT $? 0 0 'check docker pod inspect ${name} failed'
    nohup openvpn docker pod stats ${name} >/dev/null 2>&1 &
    local_pid=$(echo $!)
    CHECK_RESULT $? 0 0 'check local_pid failed'
    docker pod stop ${name}
    CHECK_RESULT $? 0 0 'check docker pod stop ${name} failed'
    docker pod rm ${name}
    CHECK_RESULT $? 0 0 'check docker pod rm ${name} failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    kill -9 $local_pid
    LOG_INFO "Finish environment cleanup."
}

main $@
