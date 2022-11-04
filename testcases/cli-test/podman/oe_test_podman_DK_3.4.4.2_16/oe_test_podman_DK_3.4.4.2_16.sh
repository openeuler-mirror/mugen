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
# @Desc      :   The usage of commands in docker package
# ############################################

source "../common/common3.4.4.2_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(docker create --tmpfs /tmp:rw alpine ls)
    docker inspect $ID | grep "/tmp:rw"
    CHECK_RESULT $? 0 0 'check /tmp:rw failed'
    ID=$(docker create --userns host alpine ls)
    docker inspect $ID | grep 'UsernsMode'
    CHECK_RESULT $? 0 0 'check UsernsMode failed'
    ID=$(docker create --uts host alpine ls)
    docker inspect $ID | grep '"UTSMode": "host"'
    CHECK_RESULT $? 0 0 'check UTSMode host failed'
    ID=$(docker create --name example alpine ls)
    docker inspect ${ID} | grep '"Name": "example"'
    CHECK_RESULT $? 0 0 'check Name - example failed'
    ID=$(docker create --volume /tmp:/tmp:z alpine ls)
    docker inspect $ID | grep -i '"destination": "/tmp"'
    CHECK_RESULT $? 0 0 'check destination failed'
    ID=$(docker create --workdir /tmp alpine ls)
    docker inspect $ID | grep '"WorkingDir": "/tmp"'
    CHECK_RESULT $? 0 0 'check WorkingDir failed'
    docker rmi -f $(docker images -q)
    CHECK_RESULT $? 0 0 'check docker rmi -f $(docker images -q) failed'
    docker images | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 1 0 'check docker images | grep "registry.access.redhat.com/ubi8-minimal" failed'
    docker pull registry.access.redhat.com/ubi8-minimal
    docker images | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 0 0 'check docker images | grep "registry.access.redhat.com/ubi8-minimal" failed'
    docker rmi --all
    CHECK_RESULT $? 0 0 'check docker rmi --all failed'
    docker images | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 1 0 'check docker images | grep "registry.access.redhat.com/ubi8-minimal" faileds'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
