//
//  UIApplication+Memory.m
//  Coffee
//
//  Created by xiongan on 16/8/10.
//  Copyright © 2016年 承道科技. All rights reserved.
//

#import "UIApplication+Memory.h"
#include <mach/mach.h>
#include <arpa/inet.h>

@implementation UIApplication (Memory)
- (double)memoryUsed {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS ) {
        return NSNotFound;
    }
//    NSLog(@"常驻内存大小：%ld 虚拟内存大小:%ld",taskInfo.resident_size /1024 /1024,taskInfo.virtual_size / 1024 / 1024);
    return taskInfo.resident_size /1024 / 1024;

}
- (double)availableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount =HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    double free_count = ((vm_page_size *vmStats.free_count) /1024.0) / 1024.0;
//    NSLog(@"还剩下多少：%f 已使用 %lu",free_count,vmStats.active_count * vm_page_size/1024/1024);
    return free_count;
}

@end
