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
# @Date      :   2021/01/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
# ############################################

source "../common/common3.4.4.2_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(podman create --tmpfs /tmp:rw alpine ls)
    podman inspect $ID | grep "/tmp:rw"
    CHECK_RESULT $? 0 0 'check /tmp:rw failed'
    ID=$(podman create --userns host alpine ls)
    podman inspect $ID | grep 'UsernsMode'
    CHECK_RESULT $? 0 0 'check UsernsMode failed'
    ID=$(podman create --uts host alpine ls)
    podman inspect $ID | grep '"UTSMode": "host"'
    CHECK_RESULT $? 0 0 'check UTSMode host failed'
    podman create --name example alpine ls
    ID=$(podman create --volume /tmp:/tmp:z alpine ls)
    podman inspect $ID | grep -i '"destination": "/tmp"'
    CHECK_RESULT $? 0 0 'check destination failed'
    ID=$(podman create --workdir /tmp alpine ls)
    podman inspect $ID | grep '"WorkingDir": "/tmp"'
    CHECK_RESULT $? 0 0 'check WorkingDir failed'
    podman rmi -f $(podman images -q)
    CHECK_RESULT $? 0 0 'check podman rmi -f $(podman images -q) failed'
    podman images | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 1 0 'check podman images | grep "registry.access.redhat.com/ubi8-minimal" failed'
    podman pull registry.access.redhat.com/ubi8-minimal
    podman images | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 0 0 'check podman images | grep "registry.access.redhat.com/ubi8-minimal" failed'
    podman rmi --all
    CHECK_RESULT $? 0 0 'check podman rmi --all failed'
    podman images | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 1 0 'check podman images | grep "registry.access.redhat.com/ubi8-minimal" faileds'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
