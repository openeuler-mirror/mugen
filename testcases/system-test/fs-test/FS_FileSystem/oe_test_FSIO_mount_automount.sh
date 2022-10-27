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
#@Date      	:   2021-07-05
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test umount fs when file is opened
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    test_disk="/dev/"$(TEST_DISK 2)
    ssh_cmd_node "cp /etc/fstab /etc/fstab.bak"
    ssh_cmd_node "fdisk $test_disk << diskEof
n
p
1

+100M
n
p
2

+100M
n
p
3

+100M
w
diskEof"
    ssh_cmd_node "mkfs.ext3 ${test_disk}1"
    ssh_cmd_node "mkfs.ext4 ${test_disk}2"
    ssh_cmd_node "mkfs.xfs ${test_disk}3"
    ssh_cmd_node "mkdir /mnt/test_ext3 /mnt/test_ext4 /mnt/test_xfs"
    ssh_cmd_node "mount ${test_disk}1 /mnt/test_ext3"
    ssh_cmd_node "mount ${test_disk}2 /mnt/test_ext4"
    ssh_cmd_node "mount ${test_disk}3 /mnt/test_xfs"
    LOG_INFO "Finish to prepare the database config."
}


function run_test() {
    LOG_INFO "Start to run test."
    ssh_cmd_node "df -iT | grep '$test_disk*'"
    CHECK_RESULT $? 0 0 "Check fs is mounted failed."
    ssh_cmd_node "echo '${test_disk}1 /mnt/test_ext3 ext3 defaults 0 0' >> /etc/fstab"
    ssh_cmd_node "echo '${test_disk}2 /mnt/test_ext4 ext4 defaults 0 0' >> /etc/fstab"
    ssh_cmd_node "echo '${test_disk}3 /mnt/test_xfs xfs defaults 0 0' >> /etc/fstab"
    REMOTE_REBOOT 2
    REMOTE_REBOOT_WAIT 2
    ssh_cmd_node "df -iT | grep '${test_disk}*'"
    CHECK_RESULT $? 0 0 "Check fs is mounted failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ssh_cmd_node "umount ${test_disk}1 ${test_disk}2 ${test_disk}3"
    ssh_cmd_node "mv -f /etc/fstab.bak /etc/fstab"
    ssh_cmd_node "umount /mnt/test_ext3 /mnt/test_ext4 /mnt/test_xfs"
    ssh_cmd_node "rm -rf /mnt/test_ext3 /mnt/test_ext4 /mnt/test_xfs"
    ssh_cmd_node "fdisk $test_disk << diskEof
d

d

d

w
diskEof"
    REMOTE_REBOOT 2
    REMOTE_REBOOT_WAIT 2
    LOG_INFO "End to restore the test environment."
}

main "$@"

