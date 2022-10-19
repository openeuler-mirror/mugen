#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2020-12-11
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test mkfs on dd
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_date=$(date +%Y%m%d%H%M%S)
    loop1="/mnt/loop1_"$cur_date
    loop2="/mnt/loop2_"$cur_date
    loop3="/mnt/loop3_"$cur_date
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    dd if=/dev/zero of=$loop1 bs=1M count=10
    mkfs.ext3 $loop1
    CHECK_RESULT $? 0 0 "mkfs ext3 on virtual block failed."
    dd if=/dev/zero of=$loop2 bs=1M count=10
    mkfs.ext4 $loop2
    CHECK_RESULT $? 0 0 "mkfs ext4 on virtual block failed."
    dd if=/dev/zero of=$loop3 bs=1M count=4096
    mkfs.xfs $loop3
    CHECK_RESULT $? 0 0 "mkfs xfs on virtual block failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $loop1 $loop2 $loop3
    LOG_INFO "End to restore the test environment."
}

main "$@"

