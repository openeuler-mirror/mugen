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
    docker help | grep -E "docker|help"
    CHECK_RESULT $? 0 0 'check docker help | grep -E "docker|help" failed'
    docker create alpine
    CHECK_RESULT $? 0 0 'check docker create alpine failed'
    docker ps -a | grep -i "Created"
    CHECK_RESULT $? 0 0 'check docker ps -a | grep -i "Created" failed'
    ID=$(docker create --annotation HELLO=WORLD alpine)
    test -z ${ID}
    CHECK_RESULT $? 0 0 'check ID failed'
    docker inspect $ID | grep '"HELLO": "WORLD"'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep failed'
    docker create --attach STDIN alpine ls
    CHECK_RESULT $? 0 0 'check docker create --attach STDIN alpine ls failed'
    docker ps -a | grep ls
    CHECK_RESULT $? 0 0 'check docker ps -a | grep ls faield'
    ID=$(docker create --blkio-weight 15 alpine ls)
    docker inspect $ID | grep '"BlkioWeight": 15'
    CHECK_RESULT $? 0 0 'check docker inspect BlkioWeight failed'
    ID=$(docker create --blkio-weight-device /dev/:15 fedora ls)
    docker inspect $ID | grep '"weight": 15'
    CHECK_RESULT $? 0 0 'check docker inspect weight failed'
    ID=$(docker create --cap-add net_admin alpine ls)
    test -z ${ID}
    CHECK_RESULT $? 0 0 'check test -z ${ID} failed'
    docker inspect $ID | grep -A 1 "CapAdd" | grep "net_admin"
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -A 1 "CapAdd" | grep "net_admin" failed'
    ID=$(docker create --cap-drop net_admin alpine ls)
    test -z ${id}
    CHECK_RESULT $? 0 0 'check test -z ${ID}-2 failed'
    docker inspect $ID | grep -A 1 "CapDrop" | grep "net_admin"
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -A 1 "CapDrop" | grep "net_admin" failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
