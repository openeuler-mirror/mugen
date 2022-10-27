#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   Resize ext3 file system
# ############################################
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    check_free_disk
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    echo -e "n\np\n1\n\n+60M\np\nw\n" | fdisk /dev/${local_disk}
    old_lang=$LANG
    export LANG=en_US.utf-8
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    mkfs.ext3 -F "/dev/${local_disk1}"
    CHECK_RESULT $?
    e2fsck -y "/dev/${local_disk1}"
    CHECK_RESULT $?
    systemsize=$(resize2fs -P "/dev/${local_disk1}" 2>&1 | sed -n 'p' | awk -F ": " '{if (NR>1) print $NF}')
    CHECK_RESULT $?
    resize2fs "/dev/${local_disk1}" $[${systemsize}+10]
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    echo -e "d\np\nw\n" | fdisk "/dev/${local_disk}"
    export LANG=${old_lang}
    LOG_INFO "Finish environment cleanup."
}

main "$@"
