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
# @Author    :   saarloos
# @Contact   :   9090-90-90-9090@163.com
# @Date      :   2022-10-21
# @License   :   Mulan PSL v2
# @Desc      :   test build ko
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."

    test -f ./kernel_hello_world.ko
    CHECK_RESULT $? 0 0 "no kernel hello world ko file build fail"
    chmod 777 ./kernel_hello_world.ko
    ls -l ./kernel_hello_world.ko | grep "\-rwxrwxrwx"
    CHECK_RESULT $? 0 0 "kernel hello world ko chmod fail"

    insmod ./kernel_hello_world.ko
    CHECK_RESULT $? 0 0 "insdmod kernel hello world fail"
    sleep 1

    lsmod | grep kernel_hello_world
    CHECK_RESULT $? 0 0 "find kernel hello world fail"

    dmesg | grep "Hello world, openEuler Embedded!"
    CHECK_RESULT $? 0 0 "check kernel hello world install message fail"

    rmmod kernel_hello_world.ko
    CHECK_RESULT $? 0 0 "rmmod kernel hello world fail"
    sleep 1

    lsmod | grep kernel_hello_world
    CHECK_RESULT $? 1 0 "find remod kernel hello world"

    dmesg | grep "Byebye!, openEuler Embedded!"
    CHECK_RESULT $? 0 0 "check kernel hello world remove message fail"

    LOG_INFO "End to run test."
}

main "$@"
