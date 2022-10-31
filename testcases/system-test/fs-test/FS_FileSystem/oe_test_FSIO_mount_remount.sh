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
#@Desc      	:   Take the test mount many fs on one point, check the files
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
    point="/mnt/point"$cur_date
    mkdir $point
    mount /dev/$vggroup/$lv1 $point
    echo "test ext3" > $point/testext3
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mount /dev/$vggroup/$lv2 $point
    CHECK_RESULT $? 0 0 "Mount ext4 on $point failed."
    echo "test ext4" > $point/testext4
    df -T | grep $point | grep ext4
    CHECK_RESULT $? 0 0 "The fs type of $point is not ext4."
    mount /dev/$vggroup/$lv3 $point
    CHECK_RESULT $? 0 0 "Mount xfs on $point failed."
    echo "test xfs" > $point/testxfs
    df -T | grep $point | grep xfs
    CHECK_RESULT $? 0 0 "The fs type of $point is not xfs."
    test -f  $point/testxfs 
    CHECK_RESULT $? 0 0 "The testxfs doesn't exist."
    test -f  $point/testext4 
    CHECK_RESULT $? 1 0 "The testext4 exists unexpectly."
    test -f  $point/testext3
    CHECK_RESULT $? 1 0 "The testext3 exists unexpectly."
    umount $point
    df -T | grep $point | grep ext4
    CHECK_RESULT $? 0 0 "The fs type of $point is not ext4."
    test -f  $point/testext4 
    CHECK_RESULT $? 0 0 "The testext4 doesn't exist."
    test -f  $point/testxfs 
    CHECK_RESULT $? 1 0 "The testxfs exists unexpectly."
    test -f  $point/testext3
    CHECK_RESULT $? 1 0 "The testext3 exists unexpectly."
    umount $point
    df -T | grep $point | grep ext3
    CHECK_RESULT $? 0 0 "The fs type of $point is not ext3."
    test -f  $point/testext3
    CHECK_RESULT $? 0 0 "The testext3 doesn't exist."
    test -f  $point/testxfs 
    CHECK_RESULT $? 1 0 "The testxfs exists unexpectly."
    test -f  $point/testext4
    CHECK_RESULT $? 1 0 "The testext4 exists unexpectly."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    umount $point
    rm -rf $point
    LOG_INFO "End to restore the test environment."
}

main "$@"

