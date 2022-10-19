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
    echo '"auth":{}' > authdir/yauths.json 
    deploy_env
    podman pull registry.access.redhat.com/ubi8-minimal
    podman run --name postgres -p 256:456 registry.access.redhat.com/ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    podman ps --all | grep "0.0.0.0:256"
    CHECK_RESULT $? 0 0 'check podman ps --all | grep "0.0.0.0:256" failed'
    podman port --latest
    CHECK_RESULT $? 0 0 'check podman port --latest failed'
    expect <<EOF
        set time 30
        log_file testlog
        spawn podman login a74l47xi.mirror.aliyuncs.com 
        expect {
            "Username*" { send "umohnani\r"; exp_continue }
            "Password:" { send "\r" }
        }
        expect eof
EOF
    grep -i "Login Succeeded" testlog
    CHECK_RESULT $? 0 0 'check grep -i "Login Succeeded" testlog failed'
    rm -rf testlog
    podman logout a74l47xi.mirror.aliyuncs.com
    CHECK_RESULT $? 0 0 'check podman logout a74l47xi.mirror.aliyuncs.com failed'
    expect <<EOF
        set time 30
        log_file testlog
        spawn podman login --authfile authdir/myauths.json a74l47xi.mirror.aliyuncs.com
        expect {
            "Username*" { send "umohnani\r"; exp_continue }
            "Password:" { send "\r" }
        }
        expect eof
EOF
    grep -i "Login Succeeded" testlog
    CHECK_RESULT $? 0 0 'check grep -i "Login Succeeded" testlog failed'
    rm -rf testlog
    podman logout --authfile authdir/myauths.json a74l47xi.mirror.aliyuncs.com
    CHECK_RESULT $?
    expect <<EOF
        set time 30
        log_file testlog
        spawn podman login -u umohnani a74l47xi.mirror.aliyuncs.com
        expect {
            "Password:" { send "\r" }
        }
        expect eof
EOF
    grep -i "Username" testlog
    CHECK_RESULT $? 1
    rm -rf testlog
    expect <<EOF
        set time 30
        log_file testlog
        spawn podman login --tls-verify=false a74l47xi.mirror.aliyuncs.com
        expect {
            "Username*" { send "umohnani\r"; exp_continue }
            "Password:" { send "\r" }
        }
        expect eof
EOF
    grep -i "umohnani" testlog
    CHECK_RESULT $? 0 0 'check grep -i "umohnani" testlog failed'
    podman logout --all | grep "Remove"
    CHECK_RESULT $? 0 0 'check podman logout --all | grep "Remove" failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "End to restore the test environment."
}

main "$@"
