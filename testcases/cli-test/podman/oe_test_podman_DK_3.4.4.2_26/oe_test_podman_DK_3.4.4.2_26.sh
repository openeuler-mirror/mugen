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
# @Desc      :   docker build
# ############################################

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL cpp
    deploy_env
    docker rm --all
    docker rmi --all
    cp ../common/* .
    echo '"auths": {}' >myauths.json
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    id=$(docker build . | sed -n '$p')
    test -z ${id}
    CHECK_RESULT $? 1 0 'check id failed'
    cat ./Dockerfile | docker build -f - . | grep ${id}
    CHECK_RESULT $? 0 0 'check cat ./Dockerfile | docker build -f - . | grep ${id} failed'
    docker build --runtime-flag debug . | grep ${id}
    CHECK_RESULT $? 0 0 'check docker build --runtime-flag debug . | grep ${id} failed'
    docker build --authfile myauths.json --cert-dir $HOME/auth --tls-verify=true --creds=username:password -t hjfd -f ./Dockerfile.simple . | grep ${id}
    CHECK_RESULT $? 0 0 'check docker build --authfile ./authdir/myauths.json --cert-dir failed'
    docker build --memory 40m --cpu-period 10000 --cpu-quota 50000 --ulimit nofile=1024:1028 -t imagenam . | grep ${id}
    CHECK_RESULT $? 0 0 'check docker build --memory 40m --cpu-period 10000 --cpu-quota 50000 --ulimit failed'
    docker build -f Dockerfile.simple -f Containerfile.notsosimple . | grep ${id}
    CHECK_RESULT $? 0 0 'check docker build -f Dockerfile.simple -f Containerfile.notsosimple . failed'
    docker build -f Dockerfile.in ${HOME} | grep ${id}
    CHECK_RESULT $? 0 0 'check docker build -f Dockerfile.in ${HOME} | grep ${id} failed'
    docker build --no-cache --rm=false -t newimages1 . | grep "Successfully tagged localhost/newimages1:latest"
    CHECK_RESULT $? 0 0 'check docker build --no-cache --rm=false -t newimages1 . failed'
    docker build --layers --force-rm -t testname . | grep ${id}
    CHECK_RESULT $? 0 0 'check docker build --layers --force-rm -t testname . failed'
    docker build --no-cache -t imageert . | grep "Successfully tagged localhost/imageert:latest"
    CHECK_RESULT $? 0 0 'check docker build --no-cache -t imageert . failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf $(ls | grep -vE '.sh') common*
    clear_env
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup."
}

main $@
