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
    podman save --compress --format oci-dir -o alp-dir registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check podman save --compress --format oci-dir -o alp-dir registry.access.redhat.com/ubi8-minimal failed'
    test -d alp-dir
    CHECK_RESULT $? 0 0 'check test -d alp-dir failed'
    podman save -q -o alpine.tar registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $? 0 0 'check podman save -q -o alpine.tar registry.access.redhat.com/ubi8-minimal failed'
    test -f alpine.tar
    CHECK_RESULT $? 0 0 'check test -f alpine.tar failed'
    podman info | grep -E "host|insecure registries|registries|store"
    CHECK_RESULT $? 0 0 'check podman info | grep -E "host|insecure registries|registries|store" failed'
    podman info --debug | grep "host"
    CHECK_RESULT $? 0 0 'check podman info --debug | grep "host" failed'
    podman info --format json | grep "\"host\":"
    CHECK_RESULT $? 0 0 'check podman info --format json failed'
    podman history --format=json $(podman images -q) | grep "$(podman images -q)"
    CHECK_RESULT $? 0 0 'check podman history --format=json $(podman images -q) failed'
    podman history --human $(podman images -q) | grep "B"
    CHECK_RESULT $? 0 0 'check podman --human test failed'
    podman history --no-trunc $(podman images -q) | grep "$(ls /var/lib/containers/storage/overlay-images/)"
    CHECK_RESULT $? 0 0 'check podman --no-trunc test failed'
    podman history -q $(podman images -q) | grep "nop"
    CHECK_RESULT $? 0 1 'check podman histroy -q test failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
