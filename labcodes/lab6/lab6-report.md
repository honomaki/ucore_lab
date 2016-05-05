# 实验六: 调度器
<br/>
## 练习1: 使用 Round Robin 调度算法
*	请理解并分析sched_calss中各个函数指针的用法，并接合Round Robin 调度算法描ucore的调度执行过程
	
	```c
	struct sched_class {
	    // the name of sched_class
	    const char *name;
	    // Init the run queue
	    void (*init)(struct run_queue *rq);
	    // put the proc into runqueue, and this function must be called with rq_lock
	    void (*enqueue)(struct run_queue *rq, struct proc_struct *proc);
	    // get the proc out runqueue, and this function must be called with rq_lock
	    void (*dequeue)(struct run_queue *rq, struct proc_struct *proc);
	    // choose the next runnable task
	    struct proc_struct *(*pick_next)(struct run_queue *rq);
	    // dealer of the time-tick
	    void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc);
	    /* for SMP support in the future
	     *  load_balance
	     *     void (*load_balance)(struct rq* rq);
	     *  get some proc from this rq, used in load_balance,
	     *  return value is the num of gotten proc
	     *  int (*get_proc)(struct rq* rq, struct proc* procs_moved[]);
	     */
	};
	```
	init用来初始化运行队列，enqueue用来向队列中加入一个进程，dequeue用来从队列中取出一个进程，pick_next 用来从队列中拿出下一个进程用来执行，proc_tick用来在时钟中断时维护队列
	ucore将目前进程放入队列中，然后选出一个合适的进程出队并运行。round robin算法使用一个进程队列，当进程时间片用完时，ucore进行调度，把目前进程取出来放到队尾，再取出队列头部作为下一个执行的进程。


*	请在实验报告中简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计
	维护n个队列，并且增加变量记录该进程当前所在的队列以及被调度的次数。enqueue时将该进程放入相对应队列，并把调度次数加一；dequeue时从该队列取出，并根据调度次数修改进程对应队列。

## 练习2: 实现 Stride Scheduling 调度算法

初始化时队列置为null，进程计数器为零。dequeue时用堆的删除，计数器减一。enqueue时用merge合并，更新time_slice和进程计数器。 pick时拿出队列头部，并把stride加上BIG_STRIDE/priority