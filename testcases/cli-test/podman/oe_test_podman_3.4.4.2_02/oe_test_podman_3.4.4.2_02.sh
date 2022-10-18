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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    podman run --name postgres registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check podman run --name postgres registry.access.redhat.com/ubi8-minimal failed'
    podman pull registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check pull registry.access.redhat.com/ubi8-minimal failed'
    podman images --sort created | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 0 0 'check podman images --sort created failed'
    podman images | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 0 0 'check podman images | grep "registry.access.redhat.com/ubi8-minimal" failed'
    podman stop postgres
    CHECK_RESULT $? 0 0 'check podman stop postgres failed'
    podman commit postgres images1
    CHECK_RESULT $? 0 0 'check podman commit postgres images1 failed'
    podman images | grep images1
    CHECK_RESULT $? 0 0 'check podman images | grep images1 failed'
    podman commit --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh postgres images2
    CHECK_RESULT $? 0 0 'check podman commit --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh postgres images2 failed'
    podman images | grep images2
    CHECK_RESULT $? 0 0 'check podman images | grep images2 failed'
    podman commit -p postgres images3
    CHECK_RESULT $? 0 0 'check podman commit -p postgres images3 failed'
    podman images | grep images3
    CHECK_RESULT $? 0 0 'check podman images | grep images3 failed'
    podman commit -q postgres images4
    CHECK_RESULT $? 0 0 'check podman commit -q postgres images4 failed'
    podman images | grep images4
    CHECK_RESULT $? 0 0 'check podman images | grep images4 failed'
    podman commit -f docker -q --message "committing container to image" postgres images5
    CHECK_RESULT $? 0 0 'check podman commit -f docker -q --message faied'
    podman images | grep images5
    CHECK_RESULT $? 0 0 'check podman images | grep images5 failed'
    podman image ls --quiet | grep "$(podman images -aq)"
    CHECK_RESULT $? 0 0 'check podman image ls --quiet failed'
    podman image ls --sort size
    CHECK_RESULT $? 0 0 'check podman image ls --sort size failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
