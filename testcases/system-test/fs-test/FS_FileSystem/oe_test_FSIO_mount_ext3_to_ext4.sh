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
    testPoint="/mnt/test"$cur_date
    mkdir $testPoint
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mount -t ext3 /dev/$vggroup/$lv $testPoint
    echo "test ext3 fs" > $testPoint/testFile
    umount $testPoint
    tune2fs -O extents,uninit_bg,dir_index /dev/$vggroup/$lv
    CHECK_RESULT $? 0 0 "Umount ext3 failed."
    fsck -pf /dev/$vggroup/$lv
    mount -t ext4 /dev/$vggroup/$lv $testPoint
    CHECK_RESULT $? 0 0 "mount ext4 failed."
    grep "test" $testPoint/testFile
    CHECK_RESULT $? 0 0 "Transfer ext3 to ext4 failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    REMOVE_FS $testPoint
    LOG_INFO "End to restore the test environment."
}

main "$@"

