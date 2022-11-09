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
#@Date      	:   2020-12-07
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test create ext3
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_date=$(date +%Y%m%d%H%M%S)
    vggroup=$(CREATE_VG)
    lv="test_lv"$cur_date
    lvcreate -n $lv -L 2G $vggroup -y >/dev/null   
    mkfs.ext3 /dev/$vggroup/$lv
    ext3_mount="/mnt/ext3_mount"$cur_date
    mkdir $ext3_mount
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mount -t ext3 /dev/$vggroup/$lv $ext3_mount
    CHECK_RESULT $? 0 0 "mount ext3 failed."
    df -h | grep $ext3_mount
    CHECK_RESULT $? 0 0 "Check mount infos failed."
    umount $ext3_mount
    CHECK_RESULT $? 0 0 "umount ext3 failed."
    uuid=$(blkid | grep /dev/mapper/$vggroup-$lv | awk '{print $2}' | cut -d '"' -f 2)
    mount UUID=$uuid $ext3_mount
    df -h | grep $ext3_mount
    CHECK_RESULT $? 0 0 "Check mount infos failed."
    umount $ext3_mount
    CHECK_RESULT $? 0 0 "umount ext3 failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $ext3_mount
    LOG_INFO "End to restore the test environment."
}

main "$@"
