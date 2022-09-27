#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-07-05
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test edit umask
#####################################

source ../common_lib/fsio_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    ssh_cmd_node "umask | grep 0022"
    CHECK_RESULT $? 0 0 "Check default umask failed."
    ssh_cmd_node "umask 0077 && umask"
    CHECK_RESULT $? 0 0 "Change default umask failed."
    REMOTE_REBOOT 2
    REMOTE_REBOOT_WAIT 2
    ssh_cmd_node "umask | grep 0022"
    CHECK_RESULT $? 0 0 "Check default umask failed."
    LOG_INFO "End to run test."
}

main $@

