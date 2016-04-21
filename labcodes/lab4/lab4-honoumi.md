# 实验四：内核线程管理
<br>

## 练习1：分配并初始化一个进程控制块
根据注释，对`proc_struct`中的所有成员变量进行初始化操作
* 请说明`proc_struct`中`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是什么？

 `context`指上下文信息，即各个寄存器的值。 而`tf`保存了中断进程的信息，用来在切换时恢复中断现场

## 练习2：为新创建的内核线程分配资源

* 请说明ucore是否做到给每个新fork的线程一个唯一的id？
  
	在`do_fork`中
	```
	proc->pid = get_pid();
	```
	`/kern/process/proc.c`中的`get_pid`函数
	```c
	// get_pid - alloc a unique pid for process
	static int
	get_pid(void) {
	    static_assert(MAX_PID > MAX_PROCESS);
	    struct proc_struct *proc;
	    list_entry_t *list = &proc_list, *le;
	    static int next_safe = MAX_PID, last_pid = MAX_PID;
	    if (++ last_pid >= MAX_PID) {
	        last_pid = 1;
	        goto inside;
	    }
	    if (last_pid >= next_safe) {
	    inside:
	        next_safe = MAX_PID;
	    repeat:
	        le = list;
	        while ((le = list_next(le)) != list) {
	            proc = le2proc(le, list_link);
	            if (proc->pid == last_pid) {
	                if (++ last_pid >= next_safe) {
	                    if (last_pid >= MAX_PID) {
	                        last_pid = 1;
	                    }
	                    next_safe = MAX_PID;
	                    goto repeat;
	                }
	            }
	            else if (proc->pid > last_pid && next_safe > proc->pid) {
	                next_safe = proc->pid;
	            }
	        }
	    }
	    return last_pid;
	}
	```
	可以看出ucore每个新fork的线程分配了一个唯一id

## 练习3：阅读代码，理解 proc_run 函数和它调用的函数如何完成进程切换的

* 在本实验的执行过程中，创建且运行了几个内核线程？

  在输出中
  ```
  this initproc, pid = 1, name = "init"
  ```
  加上最开始的`init_main`线程,运行了两个内核线程`init_main`和`idleproc`

* 语句`local_intr_save(intr_flag);....local_intr_restore(intr_flag);`在这里有何作用?

	```c
	static inline bool
	__intr_save(void) {
	    if (read_eflags() & FL_IF) {
	        intr_disable();
	        return 1;
	    }
	    return 0;
	}
	
	static inline void
	__intr_restore(bool flag) {
	    if (flag) {
	        intr_enable();
	    }
	}
	
	#define local_intr_save(x)      do { x = __intr_save(); } while (0)
	#define local_intr_restore(x)   __intr_restore(x);
	```
  为了防止程序执行到`....`中时被中断打断