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
#@Desc      	:   Take the test cp/mv directory on different fs
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    point_list=($(CREATE_FS "ext3 ext4 xfs"))
    ext3_point=${point_list[1]}
    ext4_point=${point_list[2]}
    xfs_point=${point_list[3]}
    mkdir $ext3_point/testdir
    echo "test ext3" > $ext3_point/testdir/testfile
    mkdir $ext4_point/testdir
    echo "test ext4" > $ext4_point/testdir/testfile
    mkdir $xfs_point/testdir
    echo "test xfs" > $xfs_point/testdir/testfile
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    cp -r $ext3_point/testdir $ext4_point/testdir
    grep -q "test ext3" $ext4_point/testdir/testdir/testfile
    CHECK_RESULT $? 0 0 "The directory copied from ext3 to ext4 failed."
    mv $ext3_point/testdir $ext4_point/testdir2
    grep -q "test ext3" $ext4_point/testdir2/testfile
    CHECK_RESULT $? 0 0 "The directory moved from ext3 to ext4 failed."
    cp -r $ext4_point/testdir $xfs_point/testdir
    grep -q "test ext4" $xfs_point/testdir/testdir/testfile
    CHECK_RESULT $? 0 0 "The directory copied from ext4 to xfs failed."
    mv $ext4_point/testdir $xfs_point/testdir2
    grep -q "test ext3" $xfs_point/testdir2/testdir/testfile
    CHECK_RESULT $? 0 0 "The directory moved from ext4 to xfs failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    LOG_INFO "End to restore the test environment."
}

main $@
