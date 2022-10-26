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
#@Date      	:   2020-12-08
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test mount ext3
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_date=$(date +%Y%m%d%H%M%S)
    vggroup=$(CREATE_VG)
    lv="test_lv"$cur_date
    lvcreate -n $lv -L 2G $vggroup -y >/dev/null   
    mkfs.ext3 /dev/$vggroup/$lv
    ext3_point="/mnt/test"$cur_date
    mkdir $ext3_point
    data=('journal' 'ordered' 'writeback')
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for var in ${data[@]}; do
        mount -t ext3 -o data=$var /dev/$vggroup/$lv $ext3_point
        echo "test" > $ext3_point/testfile
        grep "test" $ext3_point/testfile
        CHECK_RESULT $? 0 0 "Mount ext3 by data=$var failed."
        umount -f /dev/$vggroup/$lv
        rm -rf $ext3_point/*
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $ext3_point 
    LOG_INFO "End to restore the test environment."
}

main "$@"

