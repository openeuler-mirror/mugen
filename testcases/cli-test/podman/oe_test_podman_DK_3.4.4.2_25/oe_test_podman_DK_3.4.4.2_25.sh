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
# @Desc      :   docker save inspect
# ############################################

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    docker rm --all
    docker rmi --all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    docker create --name postgres docker.io/library/nginx
    CHECK_RESULT $? 0 0 'check docker create --name postgres docker.io/library/nginx failed'
    docker save -q -o alpine.tar docker.io/library/nginx
    CHECK_RESULT $? 0 0 'check docker save -q -o alpine.tar docker.io/library/nginx failed'
    test -f ./alpine.tar
    CHECK_RESULT $? 0 0 'check test -f ./alpine.tar failed'
    docker inspect -f json postgres | grep "ID"
    CHECK_RESULT $? 0 0 'check docker inspect -f json postgres | grep "ID" failed'
    docker inspect postgres --format "{{.ImageName}}" | grep "docker.io/library/nginx"
    CHECK_RESULT $? 0 0 'check docker inspect postgres --format failed'
    docker inspect postgres --type all --format "{{.Name}}" | grep postgres
    CHECK_RESULT $? 0 0 'check docker inspect postgres --type all --format failed'
    docker inspect postgres --type container --format "{{.Name}}" | grep postgres
    CHECK_RESULT $? 0 0 'check docker inspect postgres --type container --format failed'
    docker stop postgres
    CHECK_RESULT $? 0 0 'check docker stop postgres failed'
    docker rm postgres
    CHECK_RESULT $? 0 0 'check docker stop postgres failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ./alpine.tar
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
