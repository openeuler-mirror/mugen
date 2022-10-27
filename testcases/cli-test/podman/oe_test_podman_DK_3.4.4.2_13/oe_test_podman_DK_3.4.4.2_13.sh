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
    touch /tmp/host
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(docker create --log-driver=k8s-file alpine ls)
    docker inspect $ID | grep -i driver
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -i driver failed'
    ID=$(docker create --log-opt max-size=10mb alpine ls)
    docker inspect $ID | grep -i log
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -i log failed'
    ID=$(docker create --memory 5MB alpine ls)
    docker inspect $ID | grep '"Memory": 5242880'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep Memory failed'
    ID=$(docker create --memory-reservation 5g alpine ls)
    docker inspect $ID | grep '"MemoryReservation": 5368709120'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep Memory failed'
    ID=$(docker create --memory 2g --memory-swap 4g alpine ls)
    docker inspect $ID | grep '"MemorySwap": 4294967296'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep MemorySwap failed'
    ID=$(docker create --memory-swappiness 4 alpine ls)
    docker inspect $ID | grep '"MemorySwappiness": 4'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep MemorySwappiness failed'
    ID=$(docker create --mount type=bind,source=/tmp/host,destination=/tmp/container alpine ls)
    docker inspect $ID | grep '/tmp/host'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep /tmp/host failed'
    ID=$(docker create --name example alpine ls)
    docker inspect $ID | grep '"Name": "example"'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep Name example failed'
    ID=$(docker create --net bridge alpine ls)
    docker inspect $ID | grep '"NetworkMode": "bridge"'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep Nameexample failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh") /tmp/host
    LOG_INFO "End to restore the test environment."
}

main "$@"
