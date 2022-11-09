#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   kouhuiying
# @Contact   :   kouhuiying@uniontech.com
# @Date      :   2022/11/08
# @License   :   Mulan PSL v2
# @Desc      :   Test netstat command function
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL net-tools
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    netstat --help | grep "usage: netstat"
    CHECK_RESULT $?
    netstat -V | grep "net-tools" | grep [0-9]
    CHECK_RESULT $?
    netstat -a
    CHECK_RESULT $? 0 0 "Show all sockets fail"
    netstat -apu | grep "Active Internet connections"
    CHECK_RESULT $? 0 0 "Show udp sockets fail"
    netstat -apt | grep "Active Internet connections"
    CHECK_RESULT $? 0 0 "Show tcp sockets fail"
    netstat -i | grep "Kernel Interface table"
    CHECK_RESULT $? 0 0 "Display a table of all network interfaces fail"
    netstat -g | grep "IPv6/IPv4 Group Memberships"
    CHECK_RESULT $? 0 0 "Display multicast group membership information fail"
    netstat -s
    CHECK_RESULT $? 0 0 "Display summary statistics for each protocol fail"
    netstat -l
    CHECK_RESULT $? 0 0 "Show only listening sockets fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
