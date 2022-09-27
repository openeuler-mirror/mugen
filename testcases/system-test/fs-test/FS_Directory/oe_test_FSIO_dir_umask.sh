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
#@Date      	:   2020-11-23
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test umask
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    umask | grep 0022
    CHECK_RESULT $? 0 0 "The default umask is error."
    umask 0037
    CHECK_RESULT $? 0 0 "Change umask failed."
    umask | grep 0037
    CHECK_RESULT $? 0 0 "The change umask of is error."
    umask --help | grep "umask"
    CHECK_RESULT $? 0 0 "Check help failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    umask 0022
    LOG_INFO "End to restore the test environment."
}

main $@

