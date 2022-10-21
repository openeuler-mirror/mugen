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
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   Modify persistent named properties
# ############################################
source ../common/storage_disk_lib.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    check_free_disk
    echo -e "n\np\n1\n\n\nw\n" | fdisk /dev/${local_disk}
    mkfs.ext2 -F "/dev/${local_disk}1"
    echo -e "n\np\n1\n\n\nt\n82\nw\n" | fdisk /dev/${local_disk2}
    mkswap "/dev/${local_disk2}1"
    echo -e "n\np\n1\n\n\nw\n" | fdisk /dev/${local_disk3}
    mkfs.xfs -f "/dev/${local_disk3}1"
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    lsblk --fs "/dev/${local_disk}1" | grep "${local_disk}1"
    CHECK_RESULT $? 0 0 "Failed to view file system type"
    tune2fs -U 2222d19b-8674-41ab-9856-ac3d15d1195e -L new-label "/dev/${local_disk}1"
    CHECK_RESULT $? 0 0 "Failed to modify the label and uuid of the file system"
    lsblk --fs "/dev/${local_disk}1" | awk '{if (NR>1){print $5}}' | grep "2222d19b-8674-41ab-9856-ac3d15d1195e"
    CHECK_RESULT $? 0 0 "Failed to view the uuid of the file system"
    lsblk --fs "/dev/${local_disk}1" | awk '{if (NR>1){print $4}}' | sed -n '$p' | grep "new-label"
    CHECK_RESULT $? 0 0 "Failed to view the label of the file system"
    lsblk --fs "/dev/${local_disk2}1" | grep ${local_disk2}1
    CHECK_RESULT $? 0 0 "Failed to view file system type"
    swaplabel --uuid 11114983-9331-4a61-8123-96ac6a817c41 --label new-label "/dev/${local_disk2}1"
    CHECK_RESULT $? 0 0 "Failed to modify the label and uuid of the file system"
    lsblk --fs "/dev/${local_disk2}1" | awk '{if (NR>1){print $4}}' | grep "new-label"
    CHECK_RESULT $? 0 0 "Failed to view the label of the file system"
    lsblk --fs "/dev/${local_disk2}1" | awk '{if (NR>1){print $5}}' | grep "11114983-9331-4a61-8123-96ac6a817c41"
    CHECK_RESULT $? 0 0 "Failed to view the uuid of the file system"
    lsblk --fs "/dev/${local_disk3}1" 
    CHECK_RESULT $? 0 0 "Failed to view file system type"
    xfs_admin -U 8888016f-f432-45d9-933b-66f243174bed -L new-label "/dev/${local_disk3}1"
    CHECK_RESULT $? 0 0 "Failed to modify the label and uuid of the file system"
    lsblk --fs "/dev/${local_disk3}1" | awk '{if (NR>1){print $3}}' | grep "new-label"
    CHECK_RESULT $? 0 0 "Failed to view the label of the file system"
    lsblk --fs "/dev/${local_disk3}1" | awk '{if (NR>1){print $4}}' | grep "8888016f-f432-45d9-933b-66f243174bed"
    CHECK_RESULT $? 0 0 "Failed to view the uuid of the file system"
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    echo -e "d\n\nd\n\nd\n\np\nw\n" | fdisk "/dev/${local_disk}"
    echo -e "d\n\nd\n\nd\n\np\nw\n" | fdisk "/dev/${local_disk2}"
    echo -e "d\n\nd\n\nd\n\np\nw\n" | fdisk "/dev/${local_disk3}"
    LOG_INFO "Finish environment cleanup."
}
main $@
