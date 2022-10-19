#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/22
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of grub2-mkconfig
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    grub2-mkconfig -o tmp_grub_cfg
    CHECK_RESULT $? 0 0 "Failed to execute grub2-mkconfig"
    grep "vmlinuz" tmp_grub_cfg >testlog1
    CHECK_RESULT $? 0 0 "Failed to find vmlinuz in tmp_grub_cfg"
    grep -r "vmlinuz" /boot | awk -F 'cfg:' '{print $NF}' | grep linux >testlog2
    CHECK_RESULT $? 0 0 "Failed to find vmlinuz in /boot"
    diff -Bw testlog1 testlog2
    CHECK_RESULT $? 0 0 "Files are different"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf testlog* tmp_grub_cfg
    LOG_INFO "End to restore the test environment."
}

main "$@"
