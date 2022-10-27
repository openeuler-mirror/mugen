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
    ID=$(docker create --cpuset-cpus 1 alpine ls)
    docker inspect $ID | grep -i '"CpuSetCpus": "1"'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -i CpuSetCpus failed'
    ID=$(docker create --cpuset-mems 0 alpine ls)
    docker inspect $ID | grep -i '"CpuSetMems": "0"'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -i CpuSetMems failed'
    ID=$(docker create alpine ls)
    docker inspect $ID | grep -i alpine
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -i alpine failed'
    ID=$(docker create --device /dev/dm-0 alpine ls)
    docker inspect $ID | grep -i '"PathOnHost": "/dev/dm-0"'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -i PathOnHost failed'
    ID=$(docker create --device-read-bps=/dev/:1mb alpine ls)
    docker inspect $ID | grep -A 5 -i "BlkioDeviceReadBps"
    CHECK_RESULT $? 0 0 'check docker inspect $ID grep -A 5 -i BlkioDeviceReadBps failed'
    ID=$(docker create --device-read-iops=/dev/:1000 alpine ls)
    docker inspect $ID | grep -A 5 -i "BlkioDeviceReadIOps"
    CHECK_RESULT $? 0 0 'check docker inspect $ID grep -A 5 -i BlkioDeviceReadIOps failed'
    ID=$(docker create --device-write-bps=/dev/:1mb alpine ls)
    docker inspect $ID | grep -A 5 -i "BlkioDeviceWriteBps"
    CHECK_RESULT $? 0 0 'check docker inspect $ID grep -A 5 -i BlkioDeviceWriteBps failed'
    ID=$(docker create --device-write-iops=/dev/:1000 alpine ls)
    docker inspect $ID | grep -A 5 -i "BlkioDeviceWriteIOps"
    CHECK_RESULT $? 0 0 'check docker inspect $ID grep -A 5 -i BlkioDeviceWriteIOps failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
