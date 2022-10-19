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
#@Date      	:   2020-11-28
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test remove directory
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    cur_date=$(date +%Y%m%d%H%M%S)
    mkdir /tmp/emptydir$cur_date /tmp/testdir$cur_date /tmp/accessdir$cur_date
    echo "test" > /tmp/testdir$cur_date/testfile
    chattr +i /tmp/accessdir$cur_date
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    echo y | rm -r /tmp/emptydir$cur_date
    test -f /etc/emptydir$cur_date
    CHECK_RESULT $? 1 0 "The empty directory was not removed."
    rm -rf /tmp/testdir$cur_date
    test -f /etc/testdir$cur_date
    CHECK_RESULT $? 1 0 "The directory which has file was not removed."
    rm -rf /sys 2>&1 | grep -q "Operation not permited"
    CHECK_RESULT $? 1 0 "The /sys was removed."
    rm -rf /proc 2>&1 | grep -q "Operation not permited"
    CHECK_RESULT $? 1 0 "The /proc was removed."
    rm -rf /tmp/accessdir$cur_date 2>&1 | grep -q "Operation not permited"
    CHECK_RESULT $? 1 0 "The /proc was removed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    chattr -i /tmp/accessdir$cur_date
    rm -rf /tmp/accessdir$cur_date
    export LANG=$cur_lang
    LOG_INFO "End to restore the test environment."
}

main $@
