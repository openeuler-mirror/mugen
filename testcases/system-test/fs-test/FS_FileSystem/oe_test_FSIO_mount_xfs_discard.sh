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
#@Date      	:   2020-12-10
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test mount xfs
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_date=$(date +%Y%m%d%H%M%S)
    vggroup=$(CREATE_VG)
    lv="test_lv"$cur_date
    lvcreate -n $lv -L 2G $vggroup -y >/dev/null 
    mkfs.xfs /dev/$vggroup/$lv  
    xfs_point="/mnt/test"$cur_date
    mkdir $xfs_point
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mount -t xfs -o discard /dev/$vggroup/$lv $xfs_point
    CHECK_RESULT $? 0 0 "Mount xfs by ro failed."
    echo "test" > $xfs_point/testfile
    grep "test" $xfs_point/testfile
    CHECK_RESULT $? 0 0 "Mount xfs by delalloc failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    REMOVE_FS $xfs_point
    LOG_INFO "End to restore the test environment."
}

main "$@"

