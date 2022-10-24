#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   saarloos
#@Contact   	:   9090-90-90-9090@163.com
#@Date      	:   2020-08-12 11:03:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run less testsuite
#####################################

source ../comm_lib.sh

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/lesstest

    chmod -R 777 ./*

    allFileList=$(find ./* -name "*.c" | sort)

    for oneFile in ${allFileList[*]}; do
        echo "Run: ./lesstest -s ./lt_screen -t ${oneFile} less"
        ./lesstest -s ./lt_screen -t ${oneFile} less
        CHECK_RESULT $? 0 0 "run lesstest for ${oneFile} fail"
    done

    popd

    LOG_INFO "End to run test."
}

main "$@"
