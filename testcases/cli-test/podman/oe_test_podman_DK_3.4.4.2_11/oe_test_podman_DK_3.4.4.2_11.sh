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
    ID=$(docker create --dns 255.255.255.0 alpine ls)
    docker inspect $ID | grep "255.255.255.0"
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep "255.255.255.0" failed'
    ID=$(docker create --dns-opt 8.8.8.8 alpine ls)
    docker inspect $ID | grep "8.8.8.8"
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep "8.8.8.8" failed'
    ID=$(docker create --dns-search domain alpine ls)
    docker inspect $ID | grep "domain"
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep "domain" failed'
    ID=$(docker create --name ctr --env ENV*****=b alpine printenv ENV*****)
    docker inspect $ID | grep "ENV****"
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep "ENV****" failed'
    echo "ENV*****=b" >./a
    ID=$(docker create --env-file ./a alpine ls)
    docker inspect $ID | grep "ENV"
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep "ENV" faield' 
    ID=$(docker create --expose 1 alpine ls)
    docker inspect $ID | grep "0"
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep "0" failed'
    ID=$(docker create --uidmap 0:30000:7000 --gidmap 0:30000:7000 fedora echo hello)
    docker inspect $ID | grep "gid"
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep "gid" failed'
    ID=$(docker create --group-add groups alpine ls)
    docker inspect $ID | grep -i group
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -i group failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
