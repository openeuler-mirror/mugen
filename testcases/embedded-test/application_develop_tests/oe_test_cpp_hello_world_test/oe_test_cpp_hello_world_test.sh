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
# @Desc      :   test build bin
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."

    test -f hello_world_cpp
    CHECK_RESULT $? 0 0 "no hello world cpp bin file build fail"
    chmod 777 ./hello_world_cpp
    ls -l ./hello_world_cpp | grep "\-rwxrwxrwx"
    CHECK_RESULT $? 0 0 "hello world cpp chmod fail"

    ./hello_world_cpp | grep "Hello world cpp"
    CHECK_RESULT $? 0 0 "hello world cpp out put fail"

    LOG_INFO "End to run test."
}

main "$@"
