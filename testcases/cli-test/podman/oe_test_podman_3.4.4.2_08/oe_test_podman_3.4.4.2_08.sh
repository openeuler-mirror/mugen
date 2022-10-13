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
# @Desc      :   The usage of commands in podman package
# ############################################

source "../common/common3.4.4.2_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull registry.access.redhat.com/ubi8-minimal
    podman run --name postgres registry.access.redhat.com/ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    podman help | grep -E "podman|help"
    CHECK_RESULT $? 0 0 'check podman --help test failed'
    podman create alpine
    CHECK_RESULT $? 0 0 'check create alpine failed'
    podman ps -a | grep -i "Created"
    CHECK_RESULT $? 0 0 'check ps -a test failed'
    ID=$(podman create --annotation HELLO=WORLD alpine)
    podman inspect $ID | grep '"HELLO": "WORLD"'
    CHECK_RESULT $? 0 0 'check grep hello world failed'
    podman create --attach STDIN alpine ls
    CHECK_RESULT $? 0 0 'check podman create --attach STDIN alpine ls failed'
    podman ps -a | grep ls
    CHECK_RESULT $? 0 0 'check podman ps -a | grep ls failed'
    ID=$(podman create --blkio-weight 15 alpine ls)
    podman inspect $ID | grep '"BlkioWeight": 15'
    CHECK_RESULT $? 0 0 'check "BlkioWeight": 15 test failed'
    ID=$(podman create --blkio-weight-device /dev/:15 fedora ls)
    podman inspect $ID | grep '"weight": 15'
    CHECK_RESULT $? 0 0 'check "weight": 15 test failed'
    ID=$(podman create --cap-add net_admin alpine ls)
    podman inspect $ID | grep -A 1 "CapAdd" | grep "net_admin"
    CHECK_RESULT $? 0 0 'check net_admin test failed'
    ID=$(podman create --cap-drop net_admin alpine ls)
    podman inspect $ID | grep -A 1 "CapDrop" | grep "net_admin"
    CHECK_RESULT $? 0 0 'check CapDrop test failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
