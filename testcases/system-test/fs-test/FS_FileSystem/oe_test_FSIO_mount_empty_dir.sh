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
#@Desc      	:   Take the test mount fs on empty directory
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_date=$(date +%Y%m%d%H%M%S)
    vggroup=$(CREATE_VG)
    lv1="test_lv1"$cur_date
    lv2="test_lv2"$cur_date
    lv3="test_lv3"$cur_date
    lvcreate -n $lv1 -L 2G $vggroup -y >/dev/null 
    lvcreate -n $lv2 -L 2G $vggroup -y >/dev/null
    lvcreate -n $lv3 -L 2G $vggroup -y >/dev/null
    mkfs.ext3 /dev/$vggroup/$lv1
    mkfs.ext4 /dev/$vggroup/$lv2
    mkfs.xfs /dev/$vggroup/$lv3
    ext3_point="/mnt/point1"$cur_date
    ext4_point="/mnt/point2"$cur_date
    xfs_point="/mnt/point3"$cur_date
    mkdir $ext3_point $ext4_point $xfs_point
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mount /dev/$vggroup/$lv1 $ext3_point
    CHECK_RESULT $? 0 0 "mount ext3 on empty directory failed."
    mount /dev/$vggroup/$lv2 $ext4_point
    CHECK_RESULT $? 0 0 "mount ext4 on empty directory failed."
    mount /dev/$vggroup/$lv3 $xfs_point
    CHECK_RESULT $? 0 0 "mount xfs on empty directory failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    REMOVE_FS $ext3_point
    REMOVE_FS $ext4_point
    REMOVE_FS $xfs_point
    LOG_INFO "End to restore the test environment."
}

main "$@"

