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
#@Date      	:   2020-11-23
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test modify name
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    point_list=($(CREATE_FS "ext3 ext4 xfs"))
    ext3_point=${point_list[1]}
    ext4_point=${point_list[2]}
    xfs_point=${point_list[3]}
    mkdir $ext3_point/test1 $ext3_point/test2
    echo "test2" >> $ext3_point/test2/testfile.txt
    mkdir $ext4_point/test1 $ext4_point/test2
    echo "test2" >> $ext4_point/test2/testfile.txt
    mkdir $xfs_point/test1 $xfs_point/test2
    echo "test2" >> $xfs_point/test2/testfile.txt
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mv $ext3_point/test1 $ext3_point/test1_mod
    CHECK_RESULT $? 0 0 "mv file in ext3 failed."
    mv $ext3_point/test2 $ext3_point/test2_mod
    test -f $ext3_point/test2_mod
    CHECK_RESULT $? 0 0 "Check file in ext3 failed."
    mv $ext4_point/test1 $ext4_point/test1_mod
    CHECK_RESULT $? 0 0 "mv file in ext4 failed."
    mv $ext4_point/test2 $ext4_point/test2_mod
    test -f $ext4_point/test2_mod
    CHECK_RESULT $? 0 0 "Check file in ext4 failed."
    mv $xfs_point/test1 $xfs_point/test1_mod
    CHECK_RESULT $? 0 0 "mv file in xfs failed."
    mv $xfs_point/test2 $xfs_point/test2_mod
    test -f $xfs_point/test2_mod
    CHECK_RESULT $? 0 0 "Check file in xfs failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    LOG_INFO "End to restore the test environment."
}

main "$@"

