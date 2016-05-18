# 实验七：同步互斥
<br/>
## 练习1: 理解内核级信号量的实现和基于内核级信号量的哲学家就餐问题
```c
typedef struct {
    int value;
    wait_queue_t wait_queue;
} semaphore_t;
```
用 value 表示当前信号量值，用 waitqueue 指向等待队列

```c
static __noinline void __up(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        wait_t *wait;
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
            sem->value ++;
        }
        else {
            assert(wait->proc->wait_state == wait_state);
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
        }
    }
    local_intr_restore(intr_flag);
}
```
释放资源时调用 up 函数，调用__up。 若等待队列为空，value将直接加一。 若不为空，则唤醒一个等待队列中的线程
```c
static __noinline uint32_t __down(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
        sem->value --;
        local_intr_restore(intr_flag);
        return 0;
    }
    wait_t __wait, *wait = &__wait;
    wait_current_set(&(sem->wait_queue), wait, wait_state);
    local_intr_restore(intr_flag);

    schedule();

    local_intr_save(intr_flag);
    wait_current_del(&(sem->wait_queue), wait);
    local_intr_restore(intr_flag);

    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}
```
请求资源时调用 down 函数，调用 __down。 若 value > 0，则直接获得资源，并把value减一。 否则把当前线程加入到等待队列中，调用 schedule 函数调度其它线程

## 练习2: 完成内核级条件变量和基于内核级条件变量的哲学家就餐问题

对于哲学家就餐问题。申请叉子，如果条件本人相邻的人都不在吃不满足，那么等待。 释放叉子时，先把自己设置为不在吃的状态，然后唤醒邻居。进入前获得管程的互斥锁，退出时释放互斥锁，或者从队列中选择唤醒等待管程的线程。

```c
typedef struct condvar{
    semaphore_t sem;        // the sem semaphore  is used to down the waiting proc, and the signaling proc should up the waiting proc
    int count;              // the number of waiters on condvar
    monitor_t * owner;      // the owner(monitor) of this condvar
} condvar_t;

typedef struct monitor{
    semaphore_t mutex;      // the mutex lock for going into the routines in monitor, should be initialized to 1
    semaphore_t next;       // the next semaphore is used to down the signaling proc itself, and the other OR wakeuped waiting proc should wake up the sleeped signaling proc.
    int next_count;         // the number of of sleeped signaling proc
    condvar_t *cv;          // the condvars in monitor
} monitor_t;
```
管程中mutex表示进入管程的信号量，next信号量表示等待使用管程的线程，nextcount表示等待使用管程的线程数，cv表示管理条件

调用cond_signal，此时该条件成立，唤醒等待该条件的线程。优先让等待条件的线程运行，并把当前线程放入等待队列，重新调度相应线程

调用cond_wait，此时需要等待，所以先让出管程的控制权，并唤醒等待管程的线程，或者释放管程锁。被唤醒之后直接退出，此时条件满足