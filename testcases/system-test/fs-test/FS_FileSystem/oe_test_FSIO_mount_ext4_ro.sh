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
#@Date      	:   2020-12-09
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test mount ext4
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    cur_date=$(date +%Y%m%d%H%M%S)
    vggroup=$(CREATE_VG)
    lv="test_lv"$cur_date
    lvcreate -n $lv -L 2G $vggroup -y >/dev/null
    mkfs.ext4 /dev/$vggroup/$lv
    ext4_point="/mnt/test"$cur_date
    mkdir $ext4_point
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mount -t ext4 -o ro /dev/$vggroup/$lv $ext4_point
    CHECK_RESULT $? 0 0 "Mount ext4 by ro failed."
    touch $ext4_point/testFile 2>&1 | grep "Read-only file system"
    CHECK_RESULT $? 0 0 "Create file when ext4 is readonly unexpectly."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    REMOVE_FS $ext4_point
    export LANG=$cur_lang
    LOG_INFO "End to restore the test environment."
}

main "$@"

