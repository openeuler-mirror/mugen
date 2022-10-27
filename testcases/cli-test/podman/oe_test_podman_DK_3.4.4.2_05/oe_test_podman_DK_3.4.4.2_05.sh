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
    docker save --compress --format oci-dir -o alp-dir registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check docker save --compress --format oci-dir -o alp-dir registry.access.redhat.com failed'
    test -d alp-dir
    CHECK_RESULT $? 0 0 'check test -d alp-dir failed'
    docker save -q -o alpine.tar registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check docker save -q -o alpine.tar registry.access.redhat.com/ubi8-minimal failed'
    test -f alpine.tar
    CHECK_RESULT $? 0 0 'check test -f alpine.tar failed'
    docker info | grep -E "host|insecure registries|registries|store"
    CHECK_RESULT $? 0 0 'check docker info | grep -E "host|insecure registries|registries|store" failed'
    docker info --debug | grep "host"
    CHECK_RESULT $? 0 0 'check docker info --debug | grep "host" failed'
    docker info --format json | grep "\"host\":"
    CHECK_RESULT $? 0 0 'check docker info --format json failed'
    docker history --format=json $(docker images -q) | grep "$(docker images -q)"
    CHECK_RESULT $? 0 0 'check docker history --format=json $(docker images -q) failed'
    docker history --human $(docker images -q) | grep "B"
    CHECK_RESULT $? 0 0 'check docker history --human failed'
    docker history --no-trunc $(docker images -q) | grep "$(ls /var/lib/containers/storage/overlay-images/)"
    CHECK_RESULT $? 0 0 'check docker history --no-trunc failed'
    docker history -q $(docker images -q) | grep "nop"
    CHECK_RESULT $? 1 0 'check docker history -q $(docker images -q) failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
