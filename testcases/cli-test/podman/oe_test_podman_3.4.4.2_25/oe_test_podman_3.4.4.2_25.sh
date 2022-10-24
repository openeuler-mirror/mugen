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
# @Contact   :   duanxuemin@foxmail.com
# @Date      :   2022.10.11
# @License   :   Mulan PSL v2
# @Desc      :   podman save inspect
# ############################################

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    podman rm --all
    podman rmi --all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    podman create --name postgres docker.io/library/nginx
    CHECK_RESULT $? 0 0 'check podman create --name postgres docker.io/library/nginx failed'
    podman save -q -o alpine.tar docker.io/library/nginx
    CHECK_RESULT $? 0 0 'check podman save -q -o alpine.tar docker.io/library/nginx failed'
    test -f ./alpine.tar
    CHECK_RESULT $? 0 0 'check test -f ./alpine.tar failed'
    podman inspect -f json postgres | grep "ID"
    CHECK_RESULT $? 0 0 'check podman inspect -f json postgres | grep "ID" failed'
    podman inspect postgres --format "{{.ImageName}}" | grep "docker.io/library/nginx"
    CHECK_RESULT $? 0 0 'check podman inspect postgres --format failed'
    podman inspect postgres --type all --format "{{.Name}}" | grep postgres
    CHECK_RESULT $? 0 0 'check podman inspect postgres --type all --format failed'
    podman inspect postgres --type container --format "{{.Name}}" | grep postgres
    CHECK_RESULT $? 0 0 'check podman inspect postgres --type container --format failed'
    podman stop postgres
    CHECK_RESULT $? 0 0 'check podman stop postgres failed'
    podman rm postgres
    CHECK_RESULT $? 0 0 'check podman stop postgres failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ./alpine.tar
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
