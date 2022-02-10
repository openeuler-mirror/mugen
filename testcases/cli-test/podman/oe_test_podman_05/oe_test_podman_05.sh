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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2021/01/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
# ############################################

source "../common/common_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull postgres:alpine
    podman run --name postgres -e POSTGRES_PASSWORD=secret -d postgres:alpine
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    podman save --compress --format oci-dir -o alp-dir postgres:alpine
    CHECK_RESULT $?
    test -d alp-dir
    CHECK_RESULT $?
    podman save -q -o alpine.tar postgres:alpine
    CHECK_RESULT $?
    test -f alpine.tar
    CHECK_RESULT $?
    podman info | grep -E "host|insecure registries|registries|store"
    CHECK_RESULT $?
    podman info --debug | grep "debug"
    CHECK_RESULT $?
    podman info --format json | grep "\"host\":"
    CHECK_RESULT $?
    podman history --format=json $(podman images -q) | grep "#(nop)"
    CHECK_RESULT $?
    podman history --human $(podman images -q) | grep "B"
    CHECK_RESULT $?
    podman history --no-trunc $(podman images -q) | grep "$(ls /var/lib/containers/storage/overlay-images/)"
    CHECK_RESULT $?
    podman history -q $(podman images -q) | grep "nop"
    CHECK_RESULT $? 1
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
