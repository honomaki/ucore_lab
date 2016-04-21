# 实验三：虚拟内存管理  
<br>
## 练习1：给未被映射的地址映射上物理页

* 请描述页目录项（Pag Director Entry）和页表（Page Table Entry）中组成部分对ucore实现页替换算法的潜在用处

  `PTE_P` 表示页是否存在；`PTE_A` 表示页是否被访问，可以用于clock算法；`PTE_D` 表示该页是否被写过

* 如果ucore的缺页服务例程在执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

  硬件需要保存现场，然后产生中断，调用相应的中断例程处理页访问异常。

## 练习2：补充完成基于FIFO的页面替换算法

* 实现过程
  swap_fifo.c中map_swappable将换入的页面放到队列尾部，即该列表最前端；swap_fifo.c中swap_out_vistim函数弹出队列头部，即将列表最前端的前一个节点从列表中移出；vmm.c中的do_pgfault根据页访问异常的地址查找页表项然后从外存中替换到内存中。

* 如果要在ucore上实现"extended clock页替换算法"请给你的设计方案，现有的swap_manager框架是否足以支持在ucore中实现此算法？如果是，请给你的设计方案。如果不是，请给出你的新的扩展和基此扩展的设计方案。并需要回答如下问题
  可以实现该算法。使用页表项中的`PTE_A`，`PTE_D`，把现在fifo实现里的swapout进行修改，遍历队列，找到第一个标记为00的页，然后替换掉。