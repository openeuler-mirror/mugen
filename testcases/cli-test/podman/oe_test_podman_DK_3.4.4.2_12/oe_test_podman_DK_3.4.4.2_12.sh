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
# @Desc      :   The usage of commands in docker package
# ############################################

source "../common/common_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(docker create -t -i --name myctr alpine ls)
    docker inspect $ID | grep '"Name": "myctr"'
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep Name myctr failed'
    ID=$(docker create --hostname localhost alpine ls)
    docker inspect $ID | grep '"Hostname": "localhost"'
    CHECK_RESULT $? 0 0 'check Hostname": "localhost failed'
    ID=$(docker create --image-volume bind alpine ls)
    docker inspect $ID | grep -i bind
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -i bind failed'
    ID=$(docker create --ip ${NODE1_IPV4} alpine ls)
    docker inspect $ID | grep -i ip
    CHECK_RESULT $? 0 0 'check docker inspect $ID | grep -i ip failed'
    ID=$(docker create --ipc host alpine ls)
    docker inspect $ID | grep '"IpcMode": "host"'
    CHECK_RESULT $? 0 0 'check IpcMode": "host failed'
    ID=$(docker create --kernel-memory 1g alpine ls)
    docker inspect $ID | grep '"KernelMemory": 1073741824'
    CHECK_RESULT $? 0 0 'check KernelMemory": 1073741824 failed'
    ID=$(docker create --label com.example.key=value alpine ls)
    docker inspect $ID | grep '"com.example.key": "value"'
    CHECK_RESULT $? 0 0 'check com.example.key": "value failed'
    echo "com.example.key=value" >./a
    ID=$(docker create --label-file ./a alpine ls)
    docker inspect $ID | grep '"com.example.key": "value"'
    CHECK_RESULT $? 0 0 'check com.example.key": "value failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
