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

source "../common/common_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker run --name postgres registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check docker run --name postgres registry.access.redhat.com/ubi8-minimal failed'
    docker pull registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check docker pull registry.access.redhat.com/ubi8-minimal failed'
    docker images --sort created | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 0 0 'check docker images --sort created failed'
    docker images | grep "registry.access.redhat.com/ubi8-minimal"
    CHECK_RESULT $? 0 0 'check docker images failed'
    docker stop postgres
    CHECK_RESULT $? 0 0 'check docker stop postgres failed'
    docker commit postgres images1
    CHECK_RESULT $? 0 0 'check docker commit postgres images1 failed'
    docker images | grep images1
    CHECK_RESULT $? 0 0 'check docker images | grep images1 failed'
    docker commit --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh postgres images2
    CHECK_RESULT $? 0 0 'check docker commit --change CMD=/bin/bash --change failed'
    docker images | grep images2
    CHECK_RESULT $? 0 0 'check docker images | grep images2 failed'
    docker commit -p postgres images3
    CHECK_RESULT $? 0 0 'check docker commit -p postgres images3 failed'
    docker images | grep images3
    CHECK_RESULT $? 0 0 'check docker images | grep images3 failed'
    docker commit -q postgres images4
    CHECK_RESULT $? 0 0 'check docker commit -q postgres images4 failed'
    docker images | grep images4
    CHECK_RESULT $? 0 0 'check docker images | grep images4 failed'
    docker commit -f docker -q --message "committing container to image" postgres images5
    CHECK_RESULT $? 0 0 'check ocker commit -f docker -q --message failed'
    docker images | grep images5
    CHECK_RESULT $? 0 0 'check docker images | grep images5 failed'
    docker image ls --quiet | grep "$(docker images -aq)"
    CHECK_RESULT $? 0 0 'check docker image ls --quiet failed'
    docker image ls --sort size
    CHECK_RESULT $? 0 0 'check docker image ls --sort size failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
