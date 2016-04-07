
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 00 12 00 	lgdtl  0x120018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 00 12 c0       	mov    $0xc0120000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba b0 1b 12 c0       	mov    $0xc0121bb0,%edx
c0100035:	b8 68 0a 12 c0       	mov    $0xc0120a68,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 68 0a 12 c0 	movl   $0xc0120a68,(%esp)
c0100051:	e8 2a 8a 00 00       	call   c0108a80 <memset>

    cons_init();                // init the console
c0100056:	e8 87 15 00 00       	call   c01015e2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 20 8c 10 c0 	movl   $0xc0108c20,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 3c 8c 10 c0 	movl   $0xc0108c3c,(%esp)
c0100070:	e8 d6 02 00 00       	call   c010034b <cprintf>

    print_kerninfo();
c0100075:	e8 05 08 00 00       	call   c010087f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 95 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 c8 4c 00 00       	call   c0104d4c <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 37 1f 00 00       	call   c0101fc0 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 89 20 00 00       	call   c0102117 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 36 74 00 00       	call   c01074c9 <vmm_init>

    ide_init();                 // init ide devices
c0100093:	e8 7b 16 00 00       	call   c0101713 <ide_init>
    swap_init();                // init swap
c0100098:	e8 6b 60 00 00       	call   c0106108 <swap_init>

    clock_init();               // init clock interrupt
c010009d:	e8 f6 0c 00 00       	call   c0100d98 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a2:	e8 87 1e 00 00       	call   c0101f2e <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a7:	eb fe                	jmp    c01000a7 <kern_init+0x7d>

c01000a9 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a9:	55                   	push   %ebp
c01000aa:	89 e5                	mov    %esp,%ebp
c01000ac:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b6:	00 
c01000b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000be:	00 
c01000bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c6:	e8 ff 0b 00 00       	call   c0100cca <mon_backtrace>
}
c01000cb:	c9                   	leave  
c01000cc:	c3                   	ret    

c01000cd <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cd:	55                   	push   %ebp
c01000ce:	89 e5                	mov    %esp,%ebp
c01000d0:	53                   	push   %ebx
c01000d1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d4:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000da:	8d 55 08             	lea    0x8(%ebp),%edx
c01000dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000ec:	89 04 24             	mov    %eax,(%esp)
c01000ef:	e8 b5 ff ff ff       	call   c01000a9 <grade_backtrace2>
}
c01000f4:	83 c4 14             	add    $0x14,%esp
c01000f7:	5b                   	pop    %ebx
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 bb ff ff ff       	call   c01000cd <grade_backtrace1>
}
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c3 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c0100137:	c9                   	leave  
c0100138:	c3                   	ret    

c0100139 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100139:	55                   	push   %ebp
c010013a:	89 e5                	mov    %esp,%ebp
c010013c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100142:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100145:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100148:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014f:	0f b7 c0             	movzwl %ax,%eax
c0100152:	83 e0 03             	and    $0x3,%eax
c0100155:	89 c2                	mov    %eax,%edx
c0100157:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010015c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100160:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100164:	c7 04 24 41 8c 10 c0 	movl   $0xc0108c41,(%esp)
c010016b:	e8 db 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100170:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100174:	0f b7 d0             	movzwl %ax,%edx
c0100177:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010017c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100180:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100184:	c7 04 24 4f 8c 10 c0 	movl   $0xc0108c4f,(%esp)
c010018b:	e8 bb 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100190:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100194:	0f b7 d0             	movzwl %ax,%edx
c0100197:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010019c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a4:	c7 04 24 5d 8c 10 c0 	movl   $0xc0108c5d,(%esp)
c01001ab:	e8 9b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b4:	0f b7 d0             	movzwl %ax,%edx
c01001b7:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 6b 8c 10 c0 	movl   $0xc0108c6b,(%esp)
c01001cb:	e8 7b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	0f b7 d0             	movzwl %ax,%edx
c01001d7:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001dc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e4:	c7 04 24 79 8c 10 c0 	movl   $0xc0108c79,(%esp)
c01001eb:	e8 5b 01 00 00       	call   c010034b <cprintf>
    round ++;
c01001f0:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001f5:	83 c0 01             	add    $0x1,%eax
c01001f8:	a3 80 0a 12 c0       	mov    %eax,0xc0120a80
}
c01001fd:	c9                   	leave  
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100207:	5d                   	pop    %ebp
c0100208:	c3                   	ret    

c0100209 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100209:	55                   	push   %ebp
c010020a:	89 e5                	mov    %esp,%ebp
c010020c:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020f:	e8 25 ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100214:	c7 04 24 88 8c 10 c0 	movl   $0xc0108c88,(%esp)
c010021b:	e8 2b 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_user();
c0100220:	e8 da ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100225:	e8 0f ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022a:	c7 04 24 a8 8c 10 c0 	movl   $0xc0108ca8,(%esp)
c0100231:	e8 15 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_kernel();
c0100236:	e8 c9 ff ff ff       	call   c0100204 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023b:	e8 f9 fe ff ff       	call   c0100139 <lab1_print_cur_status>
}
c0100240:	c9                   	leave  
c0100241:	c3                   	ret    

c0100242 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100242:	55                   	push   %ebp
c0100243:	89 e5                	mov    %esp,%ebp
c0100245:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010024c:	74 13                	je     c0100261 <readline+0x1f>
        cprintf("%s", prompt);
c010024e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100251:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100255:	c7 04 24 c7 8c 10 c0 	movl   $0xc0108cc7,(%esp)
c010025c:	e8 ea 00 00 00       	call   c010034b <cprintf>
    }
    int i = 0, c;
c0100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100268:	e8 66 01 00 00       	call   c01003d3 <getchar>
c010026d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100274:	79 07                	jns    c010027d <readline+0x3b>
            return NULL;
c0100276:	b8 00 00 00 00       	mov    $0x0,%eax
c010027b:	eb 79                	jmp    c01002f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100281:	7e 28                	jle    c01002ab <readline+0x69>
c0100283:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028a:	7f 1f                	jg     c01002ab <readline+0x69>
            cputchar(c);
c010028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028f:	89 04 24             	mov    %eax,(%esp)
c0100292:	e8 da 00 00 00       	call   c0100371 <cputchar>
            buf[i ++] = c;
c0100297:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029a:	8d 50 01             	lea    0x1(%eax),%edx
c010029d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a3:	88 90 a0 0a 12 c0    	mov    %dl,-0x3fedf560(%eax)
c01002a9:	eb 46                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002af:	75 17                	jne    c01002c8 <readline+0x86>
c01002b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b5:	7e 11                	jle    c01002c8 <readline+0x86>
            cputchar(c);
c01002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ba:	89 04 24             	mov    %eax,(%esp)
c01002bd:	e8 af 00 00 00       	call   c0100371 <cputchar>
            i --;
c01002c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c6:	eb 29                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002cc:	74 06                	je     c01002d4 <readline+0x92>
c01002ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d2:	75 1d                	jne    c01002f1 <readline+0xaf>
            cputchar(c);
c01002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d7:	89 04 24             	mov    %eax,(%esp)
c01002da:	e8 92 00 00 00       	call   c0100371 <cputchar>
            buf[i] = '\0';
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e2:	05 a0 0a 12 c0       	add    $0xc0120aa0,%eax
c01002e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ea:	b8 a0 0a 12 c0       	mov    $0xc0120aa0,%eax
c01002ef:	eb 05                	jmp    c01002f6 <readline+0xb4>
        }
    }
c01002f1:	e9 72 ff ff ff       	jmp    c0100268 <readline+0x26>
}
c01002f6:	c9                   	leave  
c01002f7:	c3                   	ret    

c01002f8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f8:	55                   	push   %ebp
c01002f9:	89 e5                	mov    %esp,%ebp
c01002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	89 04 24             	mov    %eax,(%esp)
c0100304:	e8 05 13 00 00       	call   c010160e <cons_putc>
    (*cnt) ++;
c0100309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030c:	8b 00                	mov    (%eax),%eax
c010030e:	8d 50 01             	lea    0x1(%eax),%edx
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	89 10                	mov    %edx,(%eax)
}
c0100316:	c9                   	leave  
c0100317:	c3                   	ret    

c0100318 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100318:	55                   	push   %ebp
c0100319:	89 e5                	mov    %esp,%ebp
c010031b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100328:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010032c:	8b 45 08             	mov    0x8(%ebp),%eax
c010032f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100333:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033a:	c7 04 24 f8 02 10 c0 	movl   $0xc01002f8,(%esp)
c0100341:	e8 7b 7e 00 00       	call   c01081c1 <vprintfmt>
    return cnt;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100351:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100361:	89 04 24             	mov    %eax,(%esp)
c0100364:	e8 af ff ff ff       	call   c0100318 <vcprintf>
c0100369:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036f:	c9                   	leave  
c0100370:	c3                   	ret    

c0100371 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100377:	8b 45 08             	mov    0x8(%ebp),%eax
c010037a:	89 04 24             	mov    %eax,(%esp)
c010037d:	e8 8c 12 00 00       	call   c010160e <cons_putc>
}
c0100382:	c9                   	leave  
c0100383:	c3                   	ret    

c0100384 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100384:	55                   	push   %ebp
c0100385:	89 e5                	mov    %esp,%ebp
c0100387:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100391:	eb 13                	jmp    c01003a6 <cputs+0x22>
        cputch(c, &cnt);
c0100393:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100397:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010039a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039e:	89 04 24             	mov    %eax,(%esp)
c01003a1:	e8 52 ff ff ff       	call   c01002f8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a9:	8d 50 01             	lea    0x1(%eax),%edx
c01003ac:	89 55 08             	mov    %edx,0x8(%ebp)
c01003af:	0f b6 00             	movzbl (%eax),%eax
c01003b2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b9:	75 d8                	jne    c0100393 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c9:	e8 2a ff ff ff       	call   c01002f8 <cputch>
    return cnt;
c01003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d1:	c9                   	leave  
c01003d2:	c3                   	ret    

c01003d3 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d3:	55                   	push   %ebp
c01003d4:	89 e5                	mov    %esp,%ebp
c01003d6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d9:	e8 6c 12 00 00       	call   c010164a <cons_getc>
c01003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e5:	74 f2                	je     c01003d9 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003ea:	c9                   	leave  
c01003eb:	c3                   	ret    

c01003ec <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ec:	55                   	push   %ebp
c01003ed:	89 e5                	mov    %esp,%ebp
c01003ef:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f5:	8b 00                	mov    (%eax),%eax
c01003f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100409:	e9 d2 00 00 00       	jmp    c01004e0 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100411:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100414:	01 d0                	add    %edx,%eax
c0100416:	89 c2                	mov    %eax,%edx
c0100418:	c1 ea 1f             	shr    $0x1f,%edx
c010041b:	01 d0                	add    %edx,%eax
c010041d:	d1 f8                	sar    %eax
c010041f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100422:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100425:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100428:	eb 04                	jmp    c010042e <stab_binsearch+0x42>
            m --;
c010042a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100431:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100434:	7c 1f                	jl     c0100455 <stab_binsearch+0x69>
c0100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100439:	89 d0                	mov    %edx,%eax
c010043b:	01 c0                	add    %eax,%eax
c010043d:	01 d0                	add    %edx,%eax
c010043f:	c1 e0 02             	shl    $0x2,%eax
c0100442:	89 c2                	mov    %eax,%edx
c0100444:	8b 45 08             	mov    0x8(%ebp),%eax
c0100447:	01 d0                	add    %edx,%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d5                	jne    c010042a <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 78                	jmp    c01004e0 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	89 c2                	mov    %eax,%edx
c010047d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100480:	01 d0                	add    %edx,%eax
c0100482:	8b 40 08             	mov    0x8(%eax),%eax
c0100485:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100488:	73 13                	jae    c010049d <stab_binsearch+0xb1>
            *region_left = m;
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100490:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100495:	83 c0 01             	add    $0x1,%eax
c0100498:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049b:	eb 43                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a0:	89 d0                	mov    %edx,%eax
c01004a2:	01 c0                	add    %eax,%eax
c01004a4:	01 d0                	add    %edx,%eax
c01004a6:	c1 e0 02             	shl    $0x2,%eax
c01004a9:	89 c2                	mov    %eax,%edx
c01004ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ae:	01 d0                	add    %edx,%eax
c01004b0:	8b 40 08             	mov    0x8(%eax),%eax
c01004b3:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b6:	76 16                	jbe    c01004ce <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004be:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c6:	83 e8 01             	sub    $0x1,%eax
c01004c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cc:	eb 12                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d4:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dc:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e6:	0f 8e 22 ff ff ff    	jle    c010040e <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f0:	75 0f                	jne    c0100501 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fd:	89 10                	mov    %edx,(%eax)
c01004ff:	eb 3f                	jmp    c0100540 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100501:	8b 45 10             	mov    0x10(%ebp),%eax
c0100504:	8b 00                	mov    (%eax),%eax
c0100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100509:	eb 04                	jmp    c010050f <stab_binsearch+0x123>
c010050b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100512:	8b 00                	mov    (%eax),%eax
c0100514:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100517:	7d 1f                	jge    c0100538 <stab_binsearch+0x14c>
c0100519:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051c:	89 d0                	mov    %edx,%eax
c010051e:	01 c0                	add    %eax,%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	c1 e0 02             	shl    $0x2,%eax
c0100525:	89 c2                	mov    %eax,%edx
c0100527:	8b 45 08             	mov    0x8(%ebp),%eax
c010052a:	01 d0                	add    %edx,%eax
c010052c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100530:	0f b6 c0             	movzbl %al,%eax
c0100533:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100536:	75 d3                	jne    c010050b <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053e:	89 10                	mov    %edx,(%eax)
    }
}
c0100540:	c9                   	leave  
c0100541:	c3                   	ret    

c0100542 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100542:	55                   	push   %ebp
c0100543:	89 e5                	mov    %esp,%ebp
c0100545:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054b:	c7 00 cc 8c 10 c0    	movl   $0xc0108ccc,(%eax)
    info->eip_line = 0;
c0100551:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055e:	c7 40 08 cc 8c 10 c0 	movl   $0xc0108ccc,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100568:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	8b 55 08             	mov    0x8(%ebp),%edx
c0100575:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100578:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100582:	c7 45 f4 88 ab 10 c0 	movl   $0xc010ab88,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100589:	c7 45 f0 30 99 11 c0 	movl   $0xc0119930,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100590:	c7 45 ec 31 99 11 c0 	movl   $0xc0119931,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100597:	c7 45 e8 bf d1 11 c0 	movl   $0xc011d1bf,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a4:	76 0d                	jbe    c01005b3 <debuginfo_eip+0x71>
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	83 e8 01             	sub    $0x1,%eax
c01005ac:	0f b6 00             	movzbl (%eax),%eax
c01005af:	84 c0                	test   %al,%al
c01005b1:	74 0a                	je     c01005bd <debuginfo_eip+0x7b>
        return -1;
c01005b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b8:	e9 c0 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ca:	29 c2                	sub    %eax,%edx
c01005cc:	89 d0                	mov    %edx,%eax
c01005ce:	c1 f8 02             	sar    $0x2,%eax
c01005d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d7:	83 e8 01             	sub    $0x1,%eax
c01005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005eb:	00 
c01005ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fd:	89 04 24             	mov    %eax,(%esp)
c0100600:	e8 e7 fd ff ff       	call   c01003ec <stab_binsearch>
    if (lfile == 0)
c0100605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100608:	85 c0                	test   %eax,%eax
c010060a:	75 0a                	jne    c0100616 <debuginfo_eip+0xd4>
        return -1;
c010060c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100611:	e9 67 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100619:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100622:	8b 45 08             	mov    0x8(%ebp),%eax
c0100625:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100629:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100630:	00 
c0100631:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100634:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100638:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	89 04 24             	mov    %eax,(%esp)
c0100645:	e8 a2 fd ff ff       	call   c01003ec <stab_binsearch>

    if (lfun <= rfun) {
c010064a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100650:	39 c2                	cmp    %eax,%edx
c0100652:	7f 7c                	jg     c01006d0 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100657:	89 c2                	mov    %eax,%edx
c0100659:	89 d0                	mov    %edx,%eax
c010065b:	01 c0                	add    %eax,%eax
c010065d:	01 d0                	add    %edx,%eax
c010065f:	c1 e0 02             	shl    $0x2,%eax
c0100662:	89 c2                	mov    %eax,%edx
c0100664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	8b 10                	mov    (%eax),%edx
c010066b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	29 c1                	sub    %eax,%ecx
c0100673:	89 c8                	mov    %ecx,%eax
c0100675:	39 c2                	cmp    %eax,%edx
c0100677:	73 22                	jae    c010069b <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100679:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067c:	89 c2                	mov    %eax,%edx
c010067e:	89 d0                	mov    %edx,%eax
c0100680:	01 c0                	add    %eax,%eax
c0100682:	01 d0                	add    %edx,%eax
c0100684:	c1 e0 02             	shl    $0x2,%eax
c0100687:	89 c2                	mov    %eax,%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	01 d0                	add    %edx,%eax
c010068e:	8b 10                	mov    (%eax),%edx
c0100690:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100693:	01 c2                	add    %eax,%edx
c0100695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100698:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069e:	89 c2                	mov    %eax,%edx
c01006a0:	89 d0                	mov    %edx,%eax
c01006a2:	01 c0                	add    %eax,%eax
c01006a4:	01 d0                	add    %edx,%eax
c01006a6:	c1 e0 02             	shl    $0x2,%eax
c01006a9:	89 c2                	mov    %eax,%edx
c01006ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ae:	01 d0                	add    %edx,%eax
c01006b0:	8b 50 08             	mov    0x8(%eax),%edx
c01006b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bc:	8b 40 10             	mov    0x10(%eax),%eax
c01006bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ce:	eb 15                	jmp    c01006e5 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e8:	8b 40 08             	mov    0x8(%eax),%eax
c01006eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f2:	00 
c01006f3:	89 04 24             	mov    %eax,(%esp)
c01006f6:	e8 f9 81 00 00       	call   c01088f4 <strfind>
c01006fb:	89 c2                	mov    %eax,%edx
c01006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100700:	8b 40 08             	mov    0x8(%eax),%eax
c0100703:	29 c2                	sub    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070b:	8b 45 08             	mov    0x8(%ebp),%eax
c010070e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100712:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100719:	00 
c010071a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100721:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100724:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072b:	89 04 24             	mov    %eax,(%esp)
c010072e:	e8 b9 fc ff ff       	call   c01003ec <stab_binsearch>
    if (lline <= rline) {
c0100733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100736:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100739:	39 c2                	cmp    %eax,%edx
c010073b:	7f 24                	jg     c0100761 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	89 d0                	mov    %edx,%eax
c0100744:	01 c0                	add    %eax,%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	c1 e0 02             	shl    $0x2,%eax
c010074b:	89 c2                	mov    %eax,%edx
c010074d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100750:	01 d0                	add    %edx,%eax
c0100752:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100756:	0f b7 d0             	movzwl %ax,%edx
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075f:	eb 13                	jmp    c0100774 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100766:	e9 12 01 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076e:	83 e8 01             	sub    $0x1,%eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b3                	jne    c010076b <debuginfo_eip+0x229>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 97                	je     c010076b <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 46                	jl     c0100824 <debuginfo_eip+0x2e2>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fb:	29 c1                	sub    %eax,%ecx
c01007fd:	89 c8                	mov    %ecx,%eax
c01007ff:	39 c2                	cmp    %eax,%edx
c0100801:	73 21                	jae    c0100824 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	89 d0                	mov    %edx,%eax
c010080a:	01 c0                	add    %eax,%eax
c010080c:	01 d0                	add    %edx,%eax
c010080e:	c1 e0 02             	shl    $0x2,%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	8b 10                	mov    (%eax),%edx
c010081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081d:	01 c2                	add    %eax,%edx
c010081f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100822:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100824:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100827:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082a:	39 c2                	cmp    %eax,%edx
c010082c:	7d 4a                	jge    c0100878 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100831:	83 c0 01             	add    $0x1,%eax
c0100834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100837:	eb 18                	jmp    c0100851 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083c:	8b 40 14             	mov    0x14(%eax),%eax
c010083f:	8d 50 01             	lea    0x1(%eax),%edx
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084b:	83 c0 01             	add    $0x1,%eax
c010084e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100854:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100857:	39 c2                	cmp    %eax,%edx
c0100859:	7d 1d                	jge    c0100878 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	89 d0                	mov    %edx,%eax
c0100862:	01 c0                	add    %eax,%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	c1 e0 02             	shl    $0x2,%eax
c0100869:	89 c2                	mov    %eax,%edx
c010086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086e:	01 d0                	add    %edx,%eax
c0100870:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100874:	3c a0                	cmp    $0xa0,%al
c0100876:	74 c1                	je     c0100839 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100878:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087d:	c9                   	leave  
c010087e:	c3                   	ret    

c010087f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087f:	55                   	push   %ebp
c0100880:	89 e5                	mov    %esp,%ebp
c0100882:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100885:	c7 04 24 d6 8c 10 c0 	movl   $0xc0108cd6,(%esp)
c010088c:	e8 ba fa ff ff       	call   c010034b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100891:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100898:	c0 
c0100899:	c7 04 24 ef 8c 10 c0 	movl   $0xc0108cef,(%esp)
c01008a0:	e8 a6 fa ff ff       	call   c010034b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a5:	c7 44 24 04 09 8c 10 	movl   $0xc0108c09,0x4(%esp)
c01008ac:	c0 
c01008ad:	c7 04 24 07 8d 10 c0 	movl   $0xc0108d07,(%esp)
c01008b4:	e8 92 fa ff ff       	call   c010034b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b9:	c7 44 24 04 68 0a 12 	movl   $0xc0120a68,0x4(%esp)
c01008c0:	c0 
c01008c1:	c7 04 24 1f 8d 10 c0 	movl   $0xc0108d1f,(%esp)
c01008c8:	e8 7e fa ff ff       	call   c010034b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008cd:	c7 44 24 04 b0 1b 12 	movl   $0xc0121bb0,0x4(%esp)
c01008d4:	c0 
c01008d5:	c7 04 24 37 8d 10 c0 	movl   $0xc0108d37,(%esp)
c01008dc:	e8 6a fa ff ff       	call   c010034b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e1:	b8 b0 1b 12 c0       	mov    $0xc0121bb0,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f1:	29 c2                	sub    %eax,%edx
c01008f3:	89 d0                	mov    %edx,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 50 8d 10 c0 	movl   $0xc0108d50,(%esp)
c010090e:	e8 38 fa ff ff       	call   c010034b <cprintf>
}
c0100913:	c9                   	leave  
c0100914:	c3                   	ret    

c0100915 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100915:	55                   	push   %ebp
c0100916:	89 e5                	mov    %esp,%ebp
c0100918:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100921:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 04 24             	mov    %eax,(%esp)
c010092b:	e8 12 fc ff ff       	call   c0100542 <debuginfo_eip>
c0100930:	85 c0                	test   %eax,%eax
c0100932:	74 15                	je     c0100949 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100934:	8b 45 08             	mov    0x8(%ebp),%eax
c0100937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093b:	c7 04 24 7a 8d 10 c0 	movl   $0xc0108d7a,(%esp)
c0100942:	e8 04 fa ff ff       	call   c010034b <cprintf>
c0100947:	eb 6d                	jmp    c01009b6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100950:	eb 1c                	jmp    c010096e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100958:	01 d0                	add    %edx,%eax
c010095a:	0f b6 00             	movzbl (%eax),%eax
c010095d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100963:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100966:	01 ca                	add    %ecx,%edx
c0100968:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100971:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100974:	7f dc                	jg     c0100952 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100976:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097f:	01 d0                	add    %edx,%eax
c0100981:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100984:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100987:	8b 55 08             	mov    0x8(%ebp),%edx
c010098a:	89 d1                	mov    %edx,%ecx
c010098c:	29 c1                	sub    %eax,%ecx
c010098e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100991:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100994:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100998:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009aa:	c7 04 24 96 8d 10 c0 	movl   $0xc0108d96,(%esp)
c01009b1:	e8 95 f9 ff ff       	call   c010034b <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b6:	c9                   	leave  
c01009b7:	c3                   	ret    

c01009b8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b8:	55                   	push   %ebp
c01009b9:	89 e5                	mov    %esp,%ebp
c01009bb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009be:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c7:	c9                   	leave  
c01009c8:	c3                   	ret    

c01009c9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c9:	55                   	push   %ebp
c01009ca:	89 e5                	mov    %esp,%ebp
c01009cc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cf:	89 e8                	mov    %ebp,%eax
c01009d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
	*    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
	*    (3.5) popup a calling stackframe
	*           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
	*                   the calling funciton's ebp = ss:[ebp]
	*/
	uint32_t ebp = read_ebp();
c01009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009da:	e8 d9 ff ff ff       	call   c01009b8 <read_eip>
c01009df:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int i = 0, j = 0;
c01009e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	while (i < STACKFRAME_DEPTH && ebp) {
c01009f0:	e9 88 00 00 00       	jmp    c0100a7d <print_stackframe+0xb4>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a03:	c7 04 24 a8 8d 10 c0 	movl   $0xc0108da8,(%esp)
c0100a0a:	e8 3c f9 ff ff       	call   c010034b <cprintf>
		uint32_t* arguments = (uint32_t)ebp + 2;
c0100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a12:	83 c0 02             	add    $0x2,%eax
c0100a15:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		j = 0;
c0100a18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		while (j < 4) {
c0100a1f:	eb 25                	jmp    c0100a46 <print_stackframe+0x7d>
			cprintf("0x%08x ", arguments[j]);
c0100a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a2e:	01 d0                	add    %edx,%eax
c0100a30:	8b 00                	mov    (%eax),%eax
c0100a32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a36:	c7 04 24 c4 8d 10 c0 	movl   $0xc0108dc4,(%esp)
c0100a3d:	e8 09 f9 ff ff       	call   c010034b <cprintf>
			j++;
c0100a42:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
	while (i < STACKFRAME_DEPTH && ebp) {
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t* arguments = (uint32_t)ebp + 2;

		j = 0;
		while (j < 4) {
c0100a46:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4a:	7e d5                	jle    c0100a21 <print_stackframe+0x58>
			cprintf("0x%08x ", arguments[j]);
			j++;
		}

		cprintf("\n");
c0100a4c:	c7 04 24 cc 8d 10 c0 	movl   $0xc0108dcc,(%esp)
c0100a53:	e8 f3 f8 ff ff       	call   c010034b <cprintf>
		print_debuginfo(eip - 1);
c0100a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5b:	83 e8 01             	sub    $0x1,%eax
c0100a5e:	89 04 24             	mov    %eax,(%esp)
c0100a61:	e8 af fe ff ff       	call   c0100915 <print_debuginfo>
		eip = *(uint32_t*)(ebp + 4);
c0100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a69:	83 c0 04             	add    $0x4,%eax
c0100a6c:	8b 00                	mov    (%eax),%eax
c0100a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *(uint32_t*)ebp;
c0100a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a74:	8b 00                	mov    (%eax),%eax
c0100a76:	89 45 f4             	mov    %eax,-0xc(%ebp)

		i++;
c0100a79:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
	*/
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();

	int i = 0, j = 0;
	while (i < STACKFRAME_DEPTH && ebp) {
c0100a7d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a81:	7f 0a                	jg     c0100a8d <print_stackframe+0xc4>
c0100a83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a87:	0f 85 68 ff ff ff    	jne    c01009f5 <print_stackframe+0x2c>
		eip = *(uint32_t*)(ebp + 4);
		ebp = *(uint32_t*)ebp;

		i++;
	}
}
c0100a8d:	c9                   	leave  
c0100a8e:	c3                   	ret    

c0100a8f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a8f:	55                   	push   %ebp
c0100a90:	89 e5                	mov    %esp,%ebp
c0100a92:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9c:	eb 0c                	jmp    c0100aaa <parse+0x1b>
            *buf ++ = '\0';
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa4:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa7:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aad:	0f b6 00             	movzbl (%eax),%eax
c0100ab0:	84 c0                	test   %al,%al
c0100ab2:	74 1d                	je     c0100ad1 <parse+0x42>
c0100ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab7:	0f b6 00             	movzbl (%eax),%eax
c0100aba:	0f be c0             	movsbl %al,%eax
c0100abd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac1:	c7 04 24 50 8e 10 c0 	movl   $0xc0108e50,(%esp)
c0100ac8:	e8 f4 7d 00 00       	call   c01088c1 <strchr>
c0100acd:	85 c0                	test   %eax,%eax
c0100acf:	75 cd                	jne    c0100a9e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad4:	0f b6 00             	movzbl (%eax),%eax
c0100ad7:	84 c0                	test   %al,%al
c0100ad9:	75 02                	jne    c0100add <parse+0x4e>
            break;
c0100adb:	eb 67                	jmp    c0100b44 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100add:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae1:	75 14                	jne    c0100af7 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aea:	00 
c0100aeb:	c7 04 24 55 8e 10 c0 	movl   $0xc0108e55,(%esp)
c0100af2:	e8 54 f8 ff ff       	call   c010034b <cprintf>
        }
        argv[argc ++] = buf;
c0100af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afa:	8d 50 01             	lea    0x1(%eax),%edx
c0100afd:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0a:	01 c2                	add    %eax,%edx
c0100b0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b11:	eb 04                	jmp    c0100b17 <parse+0x88>
            buf ++;
c0100b13:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1a:	0f b6 00             	movzbl (%eax),%eax
c0100b1d:	84 c0                	test   %al,%al
c0100b1f:	74 1d                	je     c0100b3e <parse+0xaf>
c0100b21:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b24:	0f b6 00             	movzbl (%eax),%eax
c0100b27:	0f be c0             	movsbl %al,%eax
c0100b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2e:	c7 04 24 50 8e 10 c0 	movl   $0xc0108e50,(%esp)
c0100b35:	e8 87 7d 00 00       	call   c01088c1 <strchr>
c0100b3a:	85 c0                	test   %eax,%eax
c0100b3c:	74 d5                	je     c0100b13 <parse+0x84>
            buf ++;
        }
    }
c0100b3e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b3f:	e9 66 ff ff ff       	jmp    c0100aaa <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b47:	c9                   	leave  
c0100b48:	c3                   	ret    

c0100b49 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b49:	55                   	push   %ebp
c0100b4a:	89 e5                	mov    %esp,%ebp
c0100b4c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b4f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b59:	89 04 24             	mov    %eax,(%esp)
c0100b5c:	e8 2e ff ff ff       	call   c0100a8f <parse>
c0100b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b68:	75 0a                	jne    c0100b74 <runcmd+0x2b>
        return 0;
c0100b6a:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b6f:	e9 85 00 00 00       	jmp    c0100bf9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b7b:	eb 5c                	jmp    c0100bd9 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b7d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b83:	89 d0                	mov    %edx,%eax
c0100b85:	01 c0                	add    %eax,%eax
c0100b87:	01 d0                	add    %edx,%eax
c0100b89:	c1 e0 02             	shl    $0x2,%eax
c0100b8c:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100b91:	8b 00                	mov    (%eax),%eax
c0100b93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b97:	89 04 24             	mov    %eax,(%esp)
c0100b9a:	e8 83 7c 00 00       	call   c0108822 <strcmp>
c0100b9f:	85 c0                	test   %eax,%eax
c0100ba1:	75 32                	jne    c0100bd5 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba6:	89 d0                	mov    %edx,%eax
c0100ba8:	01 c0                	add    %eax,%eax
c0100baa:	01 d0                	add    %edx,%eax
c0100bac:	c1 e0 02             	shl    $0x2,%eax
c0100baf:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100bb4:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bba:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc4:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc7:	83 c2 04             	add    $0x4,%edx
c0100bca:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bce:	89 0c 24             	mov    %ecx,(%esp)
c0100bd1:	ff d0                	call   *%eax
c0100bd3:	eb 24                	jmp    c0100bf9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdc:	83 f8 02             	cmp    $0x2,%eax
c0100bdf:	76 9c                	jbe    c0100b7d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be8:	c7 04 24 73 8e 10 c0 	movl   $0xc0108e73,(%esp)
c0100bef:	e8 57 f7 ff ff       	call   c010034b <cprintf>
    return 0;
c0100bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf9:	c9                   	leave  
c0100bfa:	c3                   	ret    

c0100bfb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bfb:	55                   	push   %ebp
c0100bfc:	89 e5                	mov    %esp,%ebp
c0100bfe:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c01:	c7 04 24 8c 8e 10 c0 	movl   $0xc0108e8c,(%esp)
c0100c08:	e8 3e f7 ff ff       	call   c010034b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c0d:	c7 04 24 b4 8e 10 c0 	movl   $0xc0108eb4,(%esp)
c0100c14:	e8 32 f7 ff ff       	call   c010034b <cprintf>

    if (tf != NULL) {
c0100c19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c1d:	74 0b                	je     c0100c2a <kmonitor+0x2f>
        print_trapframe(tf);
c0100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c22:	89 04 24             	mov    %eax,(%esp)
c0100c25:	e8 a1 16 00 00       	call   c01022cb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2a:	c7 04 24 d9 8e 10 c0 	movl   $0xc0108ed9,(%esp)
c0100c31:	e8 0c f6 ff ff       	call   c0100242 <readline>
c0100c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c3d:	74 18                	je     c0100c57 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c49:	89 04 24             	mov    %eax,(%esp)
c0100c4c:	e8 f8 fe ff ff       	call   c0100b49 <runcmd>
c0100c51:	85 c0                	test   %eax,%eax
c0100c53:	79 02                	jns    c0100c57 <kmonitor+0x5c>
                break;
c0100c55:	eb 02                	jmp    c0100c59 <kmonitor+0x5e>
            }
        }
    }
c0100c57:	eb d1                	jmp    c0100c2a <kmonitor+0x2f>
}
c0100c59:	c9                   	leave  
c0100c5a:	c3                   	ret    

c0100c5b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c5b:	55                   	push   %ebp
c0100c5c:	89 e5                	mov    %esp,%ebp
c0100c5e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c68:	eb 3f                	jmp    c0100ca9 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6d:	89 d0                	mov    %edx,%eax
c0100c6f:	01 c0                	add    %eax,%eax
c0100c71:	01 d0                	add    %edx,%eax
c0100c73:	c1 e0 02             	shl    $0x2,%eax
c0100c76:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100c7b:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c81:	89 d0                	mov    %edx,%eax
c0100c83:	01 c0                	add    %eax,%eax
c0100c85:	01 d0                	add    %edx,%eax
c0100c87:	c1 e0 02             	shl    $0x2,%eax
c0100c8a:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100c8f:	8b 00                	mov    (%eax),%eax
c0100c91:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c99:	c7 04 24 dd 8e 10 c0 	movl   $0xc0108edd,(%esp)
c0100ca0:	e8 a6 f6 ff ff       	call   c010034b <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cac:	83 f8 02             	cmp    $0x2,%eax
c0100caf:	76 b9                	jbe    c0100c6a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb6:	c9                   	leave  
c0100cb7:	c3                   	ret    

c0100cb8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb8:	55                   	push   %ebp
c0100cb9:	89 e5                	mov    %esp,%ebp
c0100cbb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cbe:	e8 bc fb ff ff       	call   c010087f <print_kerninfo>
    return 0;
c0100cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc8:	c9                   	leave  
c0100cc9:	c3                   	ret    

c0100cca <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cca:	55                   	push   %ebp
c0100ccb:	89 e5                	mov    %esp,%ebp
c0100ccd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd0:	e8 f4 fc ff ff       	call   c01009c9 <print_stackframe>
    return 0;
c0100cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cda:	c9                   	leave  
c0100cdb:	c3                   	ret    

c0100cdc <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cdc:	55                   	push   %ebp
c0100cdd:	89 e5                	mov    %esp,%ebp
c0100cdf:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce2:	a1 a0 0e 12 c0       	mov    0xc0120ea0,%eax
c0100ce7:	85 c0                	test   %eax,%eax
c0100ce9:	74 02                	je     c0100ced <__panic+0x11>
        goto panic_dead;
c0100ceb:	eb 48                	jmp    c0100d35 <__panic+0x59>
    }
    is_panic = 1;
c0100ced:	c7 05 a0 0e 12 c0 01 	movl   $0x1,0xc0120ea0
c0100cf4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf7:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d00:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d04:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0b:	c7 04 24 e6 8e 10 c0 	movl   $0xc0108ee6,(%esp)
c0100d12:	e8 34 f6 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d21:	89 04 24             	mov    %eax,(%esp)
c0100d24:	e8 ef f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d29:	c7 04 24 02 8f 10 c0 	movl   $0xc0108f02,(%esp)
c0100d30:	e8 16 f6 ff ff       	call   c010034b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d35:	e8 fa 11 00 00       	call   c0101f34 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d41:	e8 b5 fe ff ff       	call   c0100bfb <kmonitor>
    }
c0100d46:	eb f2                	jmp    c0100d3a <__panic+0x5e>

c0100d48 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d48:	55                   	push   %ebp
c0100d49:	89 e5                	mov    %esp,%ebp
c0100d4b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d4e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d54:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d57:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d62:	c7 04 24 04 8f 10 c0 	movl   $0xc0108f04,(%esp)
c0100d69:	e8 dd f5 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d75:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d78:	89 04 24             	mov    %eax,(%esp)
c0100d7b:	e8 98 f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d80:	c7 04 24 02 8f 10 c0 	movl   $0xc0108f02,(%esp)
c0100d87:	e8 bf f5 ff ff       	call   c010034b <cprintf>
    va_end(ap);
}
c0100d8c:	c9                   	leave  
c0100d8d:	c3                   	ret    

c0100d8e <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d8e:	55                   	push   %ebp
c0100d8f:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d91:	a1 a0 0e 12 c0       	mov    0xc0120ea0,%eax
}
c0100d96:	5d                   	pop    %ebp
c0100d97:	c3                   	ret    

c0100d98 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d98:	55                   	push   %ebp
c0100d99:	89 e5                	mov    %esp,%ebp
c0100d9b:	83 ec 28             	sub    $0x28,%esp
c0100d9e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da4:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dac:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db0:	ee                   	out    %al,(%dx)
c0100db1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dbb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dbf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dc3:	ee                   	out    %al,(%dx)
c0100dc4:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dca:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dce:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd6:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd7:	c7 05 bc 1a 12 c0 00 	movl   $0x0,0xc0121abc
c0100dde:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de1:	c7 04 24 22 8f 10 c0 	movl   $0xc0108f22,(%esp)
c0100de8:	e8 5e f5 ff ff       	call   c010034b <cprintf>
    pic_enable(IRQ_TIMER);
c0100ded:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df4:	e8 99 11 00 00       	call   c0101f92 <pic_enable>
}
c0100df9:	c9                   	leave  
c0100dfa:	c3                   	ret    

c0100dfb <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dfb:	55                   	push   %ebp
c0100dfc:	89 e5                	mov    %esp,%ebp
c0100dfe:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e01:	9c                   	pushf  
c0100e02:	58                   	pop    %eax
c0100e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e09:	25 00 02 00 00       	and    $0x200,%eax
c0100e0e:	85 c0                	test   %eax,%eax
c0100e10:	74 0c                	je     c0100e1e <__intr_save+0x23>
        intr_disable();
c0100e12:	e8 1d 11 00 00       	call   c0101f34 <intr_disable>
        return 1;
c0100e17:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e1c:	eb 05                	jmp    c0100e23 <__intr_save+0x28>
    }
    return 0;
c0100e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e23:	c9                   	leave  
c0100e24:	c3                   	ret    

c0100e25 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e25:	55                   	push   %ebp
c0100e26:	89 e5                	mov    %esp,%ebp
c0100e28:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e2f:	74 05                	je     c0100e36 <__intr_restore+0x11>
        intr_enable();
c0100e31:	e8 f8 10 00 00       	call   c0101f2e <intr_enable>
    }
}
c0100e36:	c9                   	leave  
c0100e37:	c3                   	ret    

c0100e38 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e38:	55                   	push   %ebp
c0100e39:	89 e5                	mov    %esp,%ebp
c0100e3b:	83 ec 10             	sub    $0x10,%esp
c0100e3e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e44:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e48:	89 c2                	mov    %eax,%edx
c0100e4a:	ec                   	in     (%dx),%al
c0100e4b:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e4e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e54:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e58:	89 c2                	mov    %eax,%edx
c0100e5a:	ec                   	in     (%dx),%al
c0100e5b:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e5e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e64:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e68:	89 c2                	mov    %eax,%edx
c0100e6a:	ec                   	in     (%dx),%al
c0100e6b:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e74:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e78:	89 c2                	mov    %eax,%edx
c0100e7a:	ec                   	in     (%dx),%al
c0100e7b:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7e:	c9                   	leave  
c0100e7f:	c3                   	ret    

c0100e80 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e80:	55                   	push   %ebp
c0100e81:	89 e5                	mov    %esp,%ebp
c0100e83:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e86:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e90:	0f b7 00             	movzwl (%eax),%eax
c0100e93:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea2:	0f b7 00             	movzwl (%eax),%eax
c0100ea5:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea9:	74 12                	je     c0100ebd <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eab:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb2:	66 c7 05 c6 0e 12 c0 	movw   $0x3b4,0xc0120ec6
c0100eb9:	b4 03 
c0100ebb:	eb 13                	jmp    c0100ed0 <cga_init+0x50>
    } else {
        *cp = was;
c0100ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec7:	66 c7 05 c6 0e 12 c0 	movw   $0x3d4,0xc0120ec6
c0100ece:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed0:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100ed7:	0f b7 c0             	movzwl %ax,%eax
c0100eda:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ede:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eea:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eeb:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100ef2:	83 c0 01             	add    $0x1,%eax
c0100ef5:	0f b7 c0             	movzwl %ax,%eax
c0100ef8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efc:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f00:	89 c2                	mov    %eax,%edx
c0100f02:	ec                   	in     (%dx),%al
c0100f03:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f06:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0a:	0f b6 c0             	movzbl %al,%eax
c0100f0d:	c1 e0 08             	shl    $0x8,%eax
c0100f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f13:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f1a:	0f b7 c0             	movzwl %ax,%eax
c0100f1d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f21:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f25:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f29:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f2d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2e:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f35:	83 c0 01             	add    $0x1,%eax
c0100f38:	0f b7 c0             	movzwl %ax,%eax
c0100f3b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f43:	89 c2                	mov    %eax,%edx
c0100f45:	ec                   	in     (%dx),%al
c0100f46:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f49:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f4d:	0f b6 c0             	movzbl %al,%eax
c0100f50:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f53:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f56:	a3 c0 0e 12 c0       	mov    %eax,0xc0120ec0
    crt_pos = pos;
c0100f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5e:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
}
c0100f64:	c9                   	leave  
c0100f65:	c3                   	ret    

c0100f66 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f66:	55                   	push   %ebp
c0100f67:	89 e5                	mov    %esp,%ebp
c0100f69:	83 ec 48             	sub    $0x48,%esp
c0100f6c:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f72:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f76:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f7a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7e:	ee                   	out    %al,(%dx)
c0100f7f:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f85:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f89:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f8d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f91:	ee                   	out    %al,(%dx)
c0100f92:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f98:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f9c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa4:	ee                   	out    %al,(%dx)
c0100fa5:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fab:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100faf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fb3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb7:	ee                   	out    %al,(%dx)
c0100fb8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fbe:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fca:	ee                   	out    %al,(%dx)
c0100fcb:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd1:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fdd:	ee                   	out    %al,(%dx)
c0100fde:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe4:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fec:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff0:	ee                   	out    %al,(%dx)
c0100ff1:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff7:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ffb:	89 c2                	mov    %eax,%edx
c0100ffd:	ec                   	in     (%dx),%al
c0100ffe:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101001:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101005:	3c ff                	cmp    $0xff,%al
c0101007:	0f 95 c0             	setne  %al
c010100a:	0f b6 c0             	movzbl %al,%eax
c010100d:	a3 c8 0e 12 c0       	mov    %eax,0xc0120ec8
c0101012:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101018:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010101c:	89 c2                	mov    %eax,%edx
c010101e:	ec                   	in     (%dx),%al
c010101f:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101022:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101028:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010102c:	89 c2                	mov    %eax,%edx
c010102e:	ec                   	in     (%dx),%al
c010102f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101032:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c0101037:	85 c0                	test   %eax,%eax
c0101039:	74 0c                	je     c0101047 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010103b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101042:	e8 4b 0f 00 00       	call   c0101f92 <pic_enable>
    }
}
c0101047:	c9                   	leave  
c0101048:	c3                   	ret    

c0101049 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101049:	55                   	push   %ebp
c010104a:	89 e5                	mov    %esp,%ebp
c010104c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101056:	eb 09                	jmp    c0101061 <lpt_putc_sub+0x18>
        delay();
c0101058:	e8 db fd ff ff       	call   c0100e38 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101061:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101067:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010106b:	89 c2                	mov    %eax,%edx
c010106d:	ec                   	in     (%dx),%al
c010106e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101071:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101075:	84 c0                	test   %al,%al
c0101077:	78 09                	js     c0101082 <lpt_putc_sub+0x39>
c0101079:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101080:	7e d6                	jle    c0101058 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101082:	8b 45 08             	mov    0x8(%ebp),%eax
c0101085:	0f b6 c0             	movzbl %al,%eax
c0101088:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010108e:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101091:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101095:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101099:	ee                   	out    %al,(%dx)
c010109a:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010ac:	ee                   	out    %al,(%dx)
c01010ad:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010b3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010bb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010bf:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c0:	c9                   	leave  
c01010c1:	c3                   	ret    

c01010c2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c2:	55                   	push   %ebp
c01010c3:	89 e5                	mov    %esp,%ebp
c01010c5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010cc:	74 0d                	je     c01010db <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d1:	89 04 24             	mov    %eax,(%esp)
c01010d4:	e8 70 ff ff ff       	call   c0101049 <lpt_putc_sub>
c01010d9:	eb 24                	jmp    c01010ff <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010db:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e2:	e8 62 ff ff ff       	call   c0101049 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ee:	e8 56 ff ff ff       	call   c0101049 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010fa:	e8 4a ff ff ff       	call   c0101049 <lpt_putc_sub>
    }
}
c01010ff:	c9                   	leave  
c0101100:	c3                   	ret    

c0101101 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101101:	55                   	push   %ebp
c0101102:	89 e5                	mov    %esp,%ebp
c0101104:	53                   	push   %ebx
c0101105:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101108:	8b 45 08             	mov    0x8(%ebp),%eax
c010110b:	b0 00                	mov    $0x0,%al
c010110d:	85 c0                	test   %eax,%eax
c010110f:	75 07                	jne    c0101118 <cga_putc+0x17>
        c |= 0x0700;
c0101111:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101118:	8b 45 08             	mov    0x8(%ebp),%eax
c010111b:	0f b6 c0             	movzbl %al,%eax
c010111e:	83 f8 0a             	cmp    $0xa,%eax
c0101121:	74 4c                	je     c010116f <cga_putc+0x6e>
c0101123:	83 f8 0d             	cmp    $0xd,%eax
c0101126:	74 57                	je     c010117f <cga_putc+0x7e>
c0101128:	83 f8 08             	cmp    $0x8,%eax
c010112b:	0f 85 88 00 00 00    	jne    c01011b9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101131:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101138:	66 85 c0             	test   %ax,%ax
c010113b:	74 30                	je     c010116d <cga_putc+0x6c>
            crt_pos --;
c010113d:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101144:	83 e8 01             	sub    $0x1,%eax
c0101147:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010114d:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101152:	0f b7 15 c4 0e 12 c0 	movzwl 0xc0120ec4,%edx
c0101159:	0f b7 d2             	movzwl %dx,%edx
c010115c:	01 d2                	add    %edx,%edx
c010115e:	01 c2                	add    %eax,%edx
c0101160:	8b 45 08             	mov    0x8(%ebp),%eax
c0101163:	b0 00                	mov    $0x0,%al
c0101165:	83 c8 20             	or     $0x20,%eax
c0101168:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010116b:	eb 72                	jmp    c01011df <cga_putc+0xde>
c010116d:	eb 70                	jmp    c01011df <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010116f:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101176:	83 c0 50             	add    $0x50,%eax
c0101179:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010117f:	0f b7 1d c4 0e 12 c0 	movzwl 0xc0120ec4,%ebx
c0101186:	0f b7 0d c4 0e 12 c0 	movzwl 0xc0120ec4,%ecx
c010118d:	0f b7 c1             	movzwl %cx,%eax
c0101190:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101196:	c1 e8 10             	shr    $0x10,%eax
c0101199:	89 c2                	mov    %eax,%edx
c010119b:	66 c1 ea 06          	shr    $0x6,%dx
c010119f:	89 d0                	mov    %edx,%eax
c01011a1:	c1 e0 02             	shl    $0x2,%eax
c01011a4:	01 d0                	add    %edx,%eax
c01011a6:	c1 e0 04             	shl    $0x4,%eax
c01011a9:	29 c1                	sub    %eax,%ecx
c01011ab:	89 ca                	mov    %ecx,%edx
c01011ad:	89 d8                	mov    %ebx,%eax
c01011af:	29 d0                	sub    %edx,%eax
c01011b1:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
        break;
c01011b7:	eb 26                	jmp    c01011df <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b9:	8b 0d c0 0e 12 c0    	mov    0xc0120ec0,%ecx
c01011bf:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01011c6:	8d 50 01             	lea    0x1(%eax),%edx
c01011c9:	66 89 15 c4 0e 12 c0 	mov    %dx,0xc0120ec4
c01011d0:	0f b7 c0             	movzwl %ax,%eax
c01011d3:	01 c0                	add    %eax,%eax
c01011d5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01011db:	66 89 02             	mov    %ax,(%edx)
        break;
c01011de:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011df:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01011e6:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011ea:	76 5b                	jbe    c0101247 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ec:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c01011f1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f7:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c01011fc:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101203:	00 
c0101204:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101208:	89 04 24             	mov    %eax,(%esp)
c010120b:	e8 af 78 00 00       	call   c0108abf <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101210:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101217:	eb 15                	jmp    c010122e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101219:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c010121e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101221:	01 d2                	add    %edx,%edx
c0101223:	01 d0                	add    %edx,%eax
c0101225:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101235:	7e e2                	jle    c0101219 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101237:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c010123e:	83 e8 50             	sub    $0x50,%eax
c0101241:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101247:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c010124e:	0f b7 c0             	movzwl %ax,%eax
c0101251:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101255:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101259:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010125d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101261:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101262:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101269:	66 c1 e8 08          	shr    $0x8,%ax
c010126d:	0f b6 c0             	movzbl %al,%eax
c0101270:	0f b7 15 c6 0e 12 c0 	movzwl 0xc0120ec6,%edx
c0101277:	83 c2 01             	add    $0x1,%edx
c010127a:	0f b7 d2             	movzwl %dx,%edx
c010127d:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101281:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101284:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101288:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010128c:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010128d:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0101294:	0f b7 c0             	movzwl %ax,%eax
c0101297:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010129b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010129f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a8:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01012af:	0f b6 c0             	movzbl %al,%eax
c01012b2:	0f b7 15 c6 0e 12 c0 	movzwl 0xc0120ec6,%edx
c01012b9:	83 c2 01             	add    $0x1,%edx
c01012bc:	0f b7 d2             	movzwl %dx,%edx
c01012bf:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012c3:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012ca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012ce:	ee                   	out    %al,(%dx)
}
c01012cf:	83 c4 34             	add    $0x34,%esp
c01012d2:	5b                   	pop    %ebx
c01012d3:	5d                   	pop    %ebp
c01012d4:	c3                   	ret    

c01012d5 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d5:	55                   	push   %ebp
c01012d6:	89 e5                	mov    %esp,%ebp
c01012d8:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e2:	eb 09                	jmp    c01012ed <serial_putc_sub+0x18>
        delay();
c01012e4:	e8 4f fb ff ff       	call   c0100e38 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ed:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f7:	89 c2                	mov    %eax,%edx
c01012f9:	ec                   	in     (%dx),%al
c01012fa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	83 e0 20             	and    $0x20,%eax
c0101307:	85 c0                	test   %eax,%eax
c0101309:	75 09                	jne    c0101314 <serial_putc_sub+0x3f>
c010130b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101312:	7e d0                	jle    c01012e4 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101314:	8b 45 08             	mov    0x8(%ebp),%eax
c0101317:	0f b6 c0             	movzbl %al,%eax
c010131a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101320:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101323:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101327:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010132b:	ee                   	out    %al,(%dx)
}
c010132c:	c9                   	leave  
c010132d:	c3                   	ret    

c010132e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010132e:	55                   	push   %ebp
c010132f:	89 e5                	mov    %esp,%ebp
c0101331:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101334:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101338:	74 0d                	je     c0101347 <serial_putc+0x19>
        serial_putc_sub(c);
c010133a:	8b 45 08             	mov    0x8(%ebp),%eax
c010133d:	89 04 24             	mov    %eax,(%esp)
c0101340:	e8 90 ff ff ff       	call   c01012d5 <serial_putc_sub>
c0101345:	eb 24                	jmp    c010136b <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101347:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134e:	e8 82 ff ff ff       	call   c01012d5 <serial_putc_sub>
        serial_putc_sub(' ');
c0101353:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010135a:	e8 76 ff ff ff       	call   c01012d5 <serial_putc_sub>
        serial_putc_sub('\b');
c010135f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101366:	e8 6a ff ff ff       	call   c01012d5 <serial_putc_sub>
    }
}
c010136b:	c9                   	leave  
c010136c:	c3                   	ret    

c010136d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010136d:	55                   	push   %ebp
c010136e:	89 e5                	mov    %esp,%ebp
c0101370:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101373:	eb 33                	jmp    c01013a8 <cons_intr+0x3b>
        if (c != 0) {
c0101375:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101379:	74 2d                	je     c01013a8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010137b:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c0101380:	8d 50 01             	lea    0x1(%eax),%edx
c0101383:	89 15 e4 10 12 c0    	mov    %edx,0xc01210e4
c0101389:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010138c:	88 90 e0 0e 12 c0    	mov    %dl,-0x3fedf120(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101392:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c0101397:	3d 00 02 00 00       	cmp    $0x200,%eax
c010139c:	75 0a                	jne    c01013a8 <cons_intr+0x3b>
                cons.wpos = 0;
c010139e:	c7 05 e4 10 12 c0 00 	movl   $0x0,0xc01210e4
c01013a5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ab:	ff d0                	call   *%eax
c01013ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b4:	75 bf                	jne    c0101375 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013b6:	c9                   	leave  
c01013b7:	c3                   	ret    

c01013b8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b8:	55                   	push   %ebp
c01013b9:	89 e5                	mov    %esp,%ebp
c01013bb:	83 ec 10             	sub    $0x10,%esp
c01013be:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c8:	89 c2                	mov    %eax,%edx
c01013ca:	ec                   	in     (%dx),%al
c01013cb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ce:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d2:	0f b6 c0             	movzbl %al,%eax
c01013d5:	83 e0 01             	and    $0x1,%eax
c01013d8:	85 c0                	test   %eax,%eax
c01013da:	75 07                	jne    c01013e3 <serial_proc_data+0x2b>
        return -1;
c01013dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e1:	eb 2a                	jmp    c010140d <serial_proc_data+0x55>
c01013e3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013ed:	89 c2                	mov    %eax,%edx
c01013ef:	ec                   	in     (%dx),%al
c01013f0:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013f3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f7:	0f b6 c0             	movzbl %al,%eax
c01013fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013fd:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101401:	75 07                	jne    c010140a <serial_proc_data+0x52>
        c = '\b';
c0101403:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010140a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010140d:	c9                   	leave  
c010140e:	c3                   	ret    

c010140f <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010140f:	55                   	push   %ebp
c0101410:	89 e5                	mov    %esp,%ebp
c0101412:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101415:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c010141a:	85 c0                	test   %eax,%eax
c010141c:	74 0c                	je     c010142a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010141e:	c7 04 24 b8 13 10 c0 	movl   $0xc01013b8,(%esp)
c0101425:	e8 43 ff ff ff       	call   c010136d <cons_intr>
    }
}
c010142a:	c9                   	leave  
c010142b:	c3                   	ret    

c010142c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010142c:	55                   	push   %ebp
c010142d:	89 e5                	mov    %esp,%ebp
c010142f:	83 ec 38             	sub    $0x38,%esp
c0101432:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101438:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010143c:	89 c2                	mov    %eax,%edx
c010143e:	ec                   	in     (%dx),%al
c010143f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101442:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101446:	0f b6 c0             	movzbl %al,%eax
c0101449:	83 e0 01             	and    $0x1,%eax
c010144c:	85 c0                	test   %eax,%eax
c010144e:	75 0a                	jne    c010145a <kbd_proc_data+0x2e>
        return -1;
c0101450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101455:	e9 59 01 00 00       	jmp    c01015b3 <kbd_proc_data+0x187>
c010145a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101460:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101464:	89 c2                	mov    %eax,%edx
c0101466:	ec                   	in     (%dx),%al
c0101467:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010146a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010146e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101471:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101475:	75 17                	jne    c010148e <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101477:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c010147c:	83 c8 40             	or     $0x40,%eax
c010147f:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
        return 0;
c0101484:	b8 00 00 00 00       	mov    $0x0,%eax
c0101489:	e9 25 01 00 00       	jmp    c01015b3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010148e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101492:	84 c0                	test   %al,%al
c0101494:	79 47                	jns    c01014dd <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101496:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c010149b:	83 e0 40             	and    $0x40,%eax
c010149e:	85 c0                	test   %eax,%eax
c01014a0:	75 09                	jne    c01014ab <kbd_proc_data+0x7f>
c01014a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a6:	83 e0 7f             	and    $0x7f,%eax
c01014a9:	eb 04                	jmp    c01014af <kbd_proc_data+0x83>
c01014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014af:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b6:	0f b6 80 60 00 12 c0 	movzbl -0x3fedffa0(%eax),%eax
c01014bd:	83 c8 40             	or     $0x40,%eax
c01014c0:	0f b6 c0             	movzbl %al,%eax
c01014c3:	f7 d0                	not    %eax
c01014c5:	89 c2                	mov    %eax,%edx
c01014c7:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014cc:	21 d0                	and    %edx,%eax
c01014ce:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
        return 0;
c01014d3:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d8:	e9 d6 00 00 00       	jmp    c01015b3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014dd:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014e2:	83 e0 40             	and    $0x40,%eax
c01014e5:	85 c0                	test   %eax,%eax
c01014e7:	74 11                	je     c01014fa <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ed:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014f2:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f5:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
    }

    shift |= shiftcode[data];
c01014fa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fe:	0f b6 80 60 00 12 c0 	movzbl -0x3fedffa0(%eax),%eax
c0101505:	0f b6 d0             	movzbl %al,%edx
c0101508:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c010150d:	09 d0                	or     %edx,%eax
c010150f:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
    shift ^= togglecode[data];
c0101514:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101518:	0f b6 80 60 01 12 c0 	movzbl -0x3fedfea0(%eax),%eax
c010151f:	0f b6 d0             	movzbl %al,%edx
c0101522:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101527:	31 d0                	xor    %edx,%eax
c0101529:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8

    c = charcode[shift & (CTL | SHIFT)][data];
c010152e:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101533:	83 e0 03             	and    $0x3,%eax
c0101536:	8b 14 85 60 05 12 c0 	mov    -0x3fedfaa0(,%eax,4),%edx
c010153d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101541:	01 d0                	add    %edx,%eax
c0101543:	0f b6 00             	movzbl (%eax),%eax
c0101546:	0f b6 c0             	movzbl %al,%eax
c0101549:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010154c:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101551:	83 e0 08             	and    $0x8,%eax
c0101554:	85 c0                	test   %eax,%eax
c0101556:	74 22                	je     c010157a <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101558:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010155c:	7e 0c                	jle    c010156a <kbd_proc_data+0x13e>
c010155e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101562:	7f 06                	jg     c010156a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101564:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101568:	eb 10                	jmp    c010157a <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010156a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010156e:	7e 0a                	jle    c010157a <kbd_proc_data+0x14e>
c0101570:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101574:	7f 04                	jg     c010157a <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101576:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157a:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c010157f:	f7 d0                	not    %eax
c0101581:	83 e0 06             	and    $0x6,%eax
c0101584:	85 c0                	test   %eax,%eax
c0101586:	75 28                	jne    c01015b0 <kbd_proc_data+0x184>
c0101588:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010158f:	75 1f                	jne    c01015b0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101591:	c7 04 24 3d 8f 10 c0 	movl   $0xc0108f3d,(%esp)
c0101598:	e8 ae ed ff ff       	call   c010034b <cprintf>
c010159d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015ab:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015af:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015b3:	c9                   	leave  
c01015b4:	c3                   	ret    

c01015b5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b5:	55                   	push   %ebp
c01015b6:	89 e5                	mov    %esp,%ebp
c01015b8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015bb:	c7 04 24 2c 14 10 c0 	movl   $0xc010142c,(%esp)
c01015c2:	e8 a6 fd ff ff       	call   c010136d <cons_intr>
}
c01015c7:	c9                   	leave  
c01015c8:	c3                   	ret    

c01015c9 <kbd_init>:

static void
kbd_init(void) {
c01015c9:	55                   	push   %ebp
c01015ca:	89 e5                	mov    %esp,%ebp
c01015cc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015cf:	e8 e1 ff ff ff       	call   c01015b5 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015db:	e8 b2 09 00 00       	call   c0101f92 <pic_enable>
}
c01015e0:	c9                   	leave  
c01015e1:	c3                   	ret    

c01015e2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e2:	55                   	push   %ebp
c01015e3:	89 e5                	mov    %esp,%ebp
c01015e5:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e8:	e8 93 f8 ff ff       	call   c0100e80 <cga_init>
    serial_init();
c01015ed:	e8 74 f9 ff ff       	call   c0100f66 <serial_init>
    kbd_init();
c01015f2:	e8 d2 ff ff ff       	call   c01015c9 <kbd_init>
    if (!serial_exists) {
c01015f7:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c01015fc:	85 c0                	test   %eax,%eax
c01015fe:	75 0c                	jne    c010160c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101600:	c7 04 24 49 8f 10 c0 	movl   $0xc0108f49,(%esp)
c0101607:	e8 3f ed ff ff       	call   c010034b <cprintf>
    }
}
c010160c:	c9                   	leave  
c010160d:	c3                   	ret    

c010160e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010160e:	55                   	push   %ebp
c010160f:	89 e5                	mov    %esp,%ebp
c0101611:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101614:	e8 e2 f7 ff ff       	call   c0100dfb <__intr_save>
c0101619:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 9b fa ff ff       	call   c01010c2 <lpt_putc>
        cga_putc(c);
c0101627:	8b 45 08             	mov    0x8(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 cf fa ff ff       	call   c0101101 <cga_putc>
        serial_putc(c);
c0101632:	8b 45 08             	mov    0x8(%ebp),%eax
c0101635:	89 04 24             	mov    %eax,(%esp)
c0101638:	e8 f1 fc ff ff       	call   c010132e <serial_putc>
    }
    local_intr_restore(intr_flag);
c010163d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101640:	89 04 24             	mov    %eax,(%esp)
c0101643:	e8 dd f7 ff ff       	call   c0100e25 <__intr_restore>
}
c0101648:	c9                   	leave  
c0101649:	c3                   	ret    

c010164a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164a:	55                   	push   %ebp
c010164b:	89 e5                	mov    %esp,%ebp
c010164d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101650:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101657:	e8 9f f7 ff ff       	call   c0100dfb <__intr_save>
c010165c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010165f:	e8 ab fd ff ff       	call   c010140f <serial_intr>
        kbd_intr();
c0101664:	e8 4c ff ff ff       	call   c01015b5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101669:	8b 15 e0 10 12 c0    	mov    0xc01210e0,%edx
c010166f:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c0101674:	39 c2                	cmp    %eax,%edx
c0101676:	74 31                	je     c01016a9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101678:	a1 e0 10 12 c0       	mov    0xc01210e0,%eax
c010167d:	8d 50 01             	lea    0x1(%eax),%edx
c0101680:	89 15 e0 10 12 c0    	mov    %edx,0xc01210e0
c0101686:	0f b6 80 e0 0e 12 c0 	movzbl -0x3fedf120(%eax),%eax
c010168d:	0f b6 c0             	movzbl %al,%eax
c0101690:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101693:	a1 e0 10 12 c0       	mov    0xc01210e0,%eax
c0101698:	3d 00 02 00 00       	cmp    $0x200,%eax
c010169d:	75 0a                	jne    c01016a9 <cons_getc+0x5f>
                cons.rpos = 0;
c010169f:	c7 05 e0 10 12 c0 00 	movl   $0x0,0xc01210e0
c01016a6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016ac:	89 04 24             	mov    %eax,(%esp)
c01016af:	e8 71 f7 ff ff       	call   c0100e25 <__intr_restore>
    return c;
c01016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b7:	c9                   	leave  
c01016b8:	c3                   	ret    

c01016b9 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016b9:	55                   	push   %ebp
c01016ba:	89 e5                	mov    %esp,%ebp
c01016bc:	83 ec 14             	sub    $0x14,%esp
c01016bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016c6:	90                   	nop
c01016c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cb:	83 c0 07             	add    $0x7,%eax
c01016ce:	0f b7 c0             	movzwl %ax,%eax
c01016d1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016d5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016d9:	89 c2                	mov    %eax,%edx
c01016db:	ec                   	in     (%dx),%al
c01016dc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016df:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016e3:	0f b6 c0             	movzbl %al,%eax
c01016e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ec:	25 80 00 00 00       	and    $0x80,%eax
c01016f1:	85 c0                	test   %eax,%eax
c01016f3:	75 d2                	jne    c01016c7 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016f9:	74 11                	je     c010170c <ide_wait_ready+0x53>
c01016fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016fe:	83 e0 21             	and    $0x21,%eax
c0101701:	85 c0                	test   %eax,%eax
c0101703:	74 07                	je     c010170c <ide_wait_ready+0x53>
        return -1;
c0101705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010170a:	eb 05                	jmp    c0101711 <ide_wait_ready+0x58>
    }
    return 0;
c010170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101711:	c9                   	leave  
c0101712:	c3                   	ret    

c0101713 <ide_init>:

void
ide_init(void) {
c0101713:	55                   	push   %ebp
c0101714:	89 e5                	mov    %esp,%ebp
c0101716:	57                   	push   %edi
c0101717:	53                   	push   %ebx
c0101718:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010171e:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101724:	e9 d6 02 00 00       	jmp    c01019ff <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101729:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010172d:	c1 e0 03             	shl    $0x3,%eax
c0101730:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101737:	29 c2                	sub    %eax,%edx
c0101739:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c010173f:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101742:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101746:	66 d1 e8             	shr    %ax
c0101749:	0f b7 c0             	movzwl %ax,%eax
c010174c:	0f b7 04 85 68 8f 10 	movzwl -0x3fef7098(,%eax,4),%eax
c0101753:	c0 
c0101754:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101758:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010175c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101763:	00 
c0101764:	89 04 24             	mov    %eax,(%esp)
c0101767:	e8 4d ff ff ff       	call   c01016b9 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010176c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101770:	83 e0 01             	and    $0x1,%eax
c0101773:	c1 e0 04             	shl    $0x4,%eax
c0101776:	83 c8 e0             	or     $0xffffffe0,%eax
c0101779:	0f b6 c0             	movzbl %al,%eax
c010177c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101780:	83 c2 06             	add    $0x6,%edx
c0101783:	0f b7 d2             	movzwl %dx,%edx
c0101786:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c010178a:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010178d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101791:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101795:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101796:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010179a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017a1:	00 
c01017a2:	89 04 24             	mov    %eax,(%esp)
c01017a5:	e8 0f ff ff ff       	call   c01016b9 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017aa:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017ae:	83 c0 07             	add    $0x7,%eax
c01017b1:	0f b7 c0             	movzwl %ax,%eax
c01017b4:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b8:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017bc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017c0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017c4:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017c5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017d0:	00 
c01017d1:	89 04 24             	mov    %eax,(%esp)
c01017d4:	e8 e0 fe ff ff       	call   c01016b9 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017d9:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017dd:	83 c0 07             	add    $0x7,%eax
c01017e0:	0f b7 c0             	movzwl %ax,%eax
c01017e3:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e7:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017eb:	89 c2                	mov    %eax,%edx
c01017ed:	ec                   	in     (%dx),%al
c01017ee:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017f1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017f5:	84 c0                	test   %al,%al
c01017f7:	0f 84 f7 01 00 00    	je     c01019f4 <ide_init+0x2e1>
c01017fd:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101801:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101808:	00 
c0101809:	89 04 24             	mov    %eax,(%esp)
c010180c:	e8 a8 fe ff ff       	call   c01016b9 <ide_wait_ready>
c0101811:	85 c0                	test   %eax,%eax
c0101813:	0f 85 db 01 00 00    	jne    c01019f4 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101819:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010181d:	c1 e0 03             	shl    $0x3,%eax
c0101820:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101827:	29 c2                	sub    %eax,%edx
c0101829:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c010182f:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101832:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101836:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101839:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010183f:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101842:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101849:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010184c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010184f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101852:	89 cb                	mov    %ecx,%ebx
c0101854:	89 df                	mov    %ebx,%edi
c0101856:	89 c1                	mov    %eax,%ecx
c0101858:	fc                   	cld    
c0101859:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010185b:	89 c8                	mov    %ecx,%eax
c010185d:	89 fb                	mov    %edi,%ebx
c010185f:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101862:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101865:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010186b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c010186e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101871:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101877:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010187a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010187d:	25 00 00 00 04       	and    $0x4000000,%eax
c0101882:	85 c0                	test   %eax,%eax
c0101884:	74 0e                	je     c0101894 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101889:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c010188f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101892:	eb 09                	jmp    c010189d <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101897:	8b 40 78             	mov    0x78(%eax),%eax
c010189a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c010189d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018a1:	c1 e0 03             	shl    $0x3,%eax
c01018a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018ab:	29 c2                	sub    %eax,%edx
c01018ad:	81 c2 00 11 12 c0    	add    $0xc0121100,%edx
c01018b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018b6:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018b9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018bd:	c1 e0 03             	shl    $0x3,%eax
c01018c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c7:	29 c2                	sub    %eax,%edx
c01018c9:	81 c2 00 11 12 c0    	add    $0xc0121100,%edx
c01018cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018d2:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d8:	83 c0 62             	add    $0x62,%eax
c01018db:	0f b7 00             	movzwl (%eax),%eax
c01018de:	0f b7 c0             	movzwl %ax,%eax
c01018e1:	25 00 02 00 00       	and    $0x200,%eax
c01018e6:	85 c0                	test   %eax,%eax
c01018e8:	75 24                	jne    c010190e <ide_init+0x1fb>
c01018ea:	c7 44 24 0c 70 8f 10 	movl   $0xc0108f70,0xc(%esp)
c01018f1:	c0 
c01018f2:	c7 44 24 08 b3 8f 10 	movl   $0xc0108fb3,0x8(%esp)
c01018f9:	c0 
c01018fa:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101901:	00 
c0101902:	c7 04 24 c8 8f 10 c0 	movl   $0xc0108fc8,(%esp)
c0101909:	e8 ce f3 ff ff       	call   c0100cdc <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c010190e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101912:	c1 e0 03             	shl    $0x3,%eax
c0101915:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010191c:	29 c2                	sub    %eax,%edx
c010191e:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101924:	83 c0 0c             	add    $0xc,%eax
c0101927:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010192a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010192d:	83 c0 36             	add    $0x36,%eax
c0101930:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101933:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010193a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101941:	eb 34                	jmp    c0101977 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101943:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101946:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101949:	01 c2                	add    %eax,%edx
c010194b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010194e:	8d 48 01             	lea    0x1(%eax),%ecx
c0101951:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101954:	01 c8                	add    %ecx,%eax
c0101956:	0f b6 00             	movzbl (%eax),%eax
c0101959:	88 02                	mov    %al,(%edx)
c010195b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195e:	8d 50 01             	lea    0x1(%eax),%edx
c0101961:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101964:	01 c2                	add    %eax,%edx
c0101966:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101969:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010196c:	01 c8                	add    %ecx,%eax
c010196e:	0f b6 00             	movzbl (%eax),%eax
c0101971:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101973:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101977:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010197d:	72 c4                	jb     c0101943 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c010197f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101982:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101985:	01 d0                	add    %edx,%eax
c0101987:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010198a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010198d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101990:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101993:	85 c0                	test   %eax,%eax
c0101995:	74 0f                	je     c01019a6 <ide_init+0x293>
c0101997:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010199a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010199d:	01 d0                	add    %edx,%eax
c010199f:	0f b6 00             	movzbl (%eax),%eax
c01019a2:	3c 20                	cmp    $0x20,%al
c01019a4:	74 d9                	je     c010197f <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019a6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019aa:	c1 e0 03             	shl    $0x3,%eax
c01019ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019b4:	29 c2                	sub    %eax,%edx
c01019b6:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01019bc:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019bf:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019c3:	c1 e0 03             	shl    $0x3,%eax
c01019c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019cd:	29 c2                	sub    %eax,%edx
c01019cf:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01019d5:	8b 50 08             	mov    0x8(%eax),%edx
c01019d8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019dc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e8:	c7 04 24 da 8f 10 c0 	movl   $0xc0108fda,(%esp)
c01019ef:	e8 57 e9 ff ff       	call   c010034b <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019f4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f8:	83 c0 01             	add    $0x1,%eax
c01019fb:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01019ff:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a04:	0f 86 1f fd ff ff    	jbe    c0101729 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a0a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a11:	e8 7c 05 00 00       	call   c0101f92 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a16:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a1d:	e8 70 05 00 00       	call   c0101f92 <pic_enable>
}
c0101a22:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a28:	5b                   	pop    %ebx
c0101a29:	5f                   	pop    %edi
c0101a2a:	5d                   	pop    %ebp
c0101a2b:	c3                   	ret    

c0101a2c <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a2c:	55                   	push   %ebp
c0101a2d:	89 e5                	mov    %esp,%ebp
c0101a2f:	83 ec 04             	sub    $0x4,%esp
c0101a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a35:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a39:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a3e:	77 24                	ja     c0101a64 <ide_device_valid+0x38>
c0101a40:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a44:	c1 e0 03             	shl    $0x3,%eax
c0101a47:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a4e:	29 c2                	sub    %eax,%edx
c0101a50:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101a56:	0f b6 00             	movzbl (%eax),%eax
c0101a59:	84 c0                	test   %al,%al
c0101a5b:	74 07                	je     c0101a64 <ide_device_valid+0x38>
c0101a5d:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a62:	eb 05                	jmp    c0101a69 <ide_device_valid+0x3d>
c0101a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a69:	c9                   	leave  
c0101a6a:	c3                   	ret    

c0101a6b <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a6b:	55                   	push   %ebp
c0101a6c:	89 e5                	mov    %esp,%ebp
c0101a6e:	83 ec 08             	sub    $0x8,%esp
c0101a71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a78:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a7c:	89 04 24             	mov    %eax,(%esp)
c0101a7f:	e8 a8 ff ff ff       	call   c0101a2c <ide_device_valid>
c0101a84:	85 c0                	test   %eax,%eax
c0101a86:	74 1b                	je     c0101aa3 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a88:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a8c:	c1 e0 03             	shl    $0x3,%eax
c0101a8f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a96:	29 c2                	sub    %eax,%edx
c0101a98:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101a9e:	8b 40 08             	mov    0x8(%eax),%eax
c0101aa1:	eb 05                	jmp    c0101aa8 <ide_device_size+0x3d>
    }
    return 0;
c0101aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa8:	c9                   	leave  
c0101aa9:	c3                   	ret    

c0101aaa <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aaa:	55                   	push   %ebp
c0101aab:	89 e5                	mov    %esp,%ebp
c0101aad:	57                   	push   %edi
c0101aae:	53                   	push   %ebx
c0101aaf:	83 ec 50             	sub    $0x50,%esp
c0101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab5:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101ab9:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ac0:	77 24                	ja     c0101ae6 <ide_read_secs+0x3c>
c0101ac2:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac7:	77 1d                	ja     c0101ae6 <ide_read_secs+0x3c>
c0101ac9:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101acd:	c1 e0 03             	shl    $0x3,%eax
c0101ad0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad7:	29 c2                	sub    %eax,%edx
c0101ad9:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101adf:	0f b6 00             	movzbl (%eax),%eax
c0101ae2:	84 c0                	test   %al,%al
c0101ae4:	75 24                	jne    c0101b0a <ide_read_secs+0x60>
c0101ae6:	c7 44 24 0c f8 8f 10 	movl   $0xc0108ff8,0xc(%esp)
c0101aed:	c0 
c0101aee:	c7 44 24 08 b3 8f 10 	movl   $0xc0108fb3,0x8(%esp)
c0101af5:	c0 
c0101af6:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101afd:	00 
c0101afe:	c7 04 24 c8 8f 10 c0 	movl   $0xc0108fc8,(%esp)
c0101b05:	e8 d2 f1 ff ff       	call   c0100cdc <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b0a:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b11:	77 0f                	ja     c0101b22 <ide_read_secs+0x78>
c0101b13:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b16:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b19:	01 d0                	add    %edx,%eax
c0101b1b:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b20:	76 24                	jbe    c0101b46 <ide_read_secs+0x9c>
c0101b22:	c7 44 24 0c 20 90 10 	movl   $0xc0109020,0xc(%esp)
c0101b29:	c0 
c0101b2a:	c7 44 24 08 b3 8f 10 	movl   $0xc0108fb3,0x8(%esp)
c0101b31:	c0 
c0101b32:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b39:	00 
c0101b3a:	c7 04 24 c8 8f 10 c0 	movl   $0xc0108fc8,(%esp)
c0101b41:	e8 96 f1 ff ff       	call   c0100cdc <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b46:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b4a:	66 d1 e8             	shr    %ax
c0101b4d:	0f b7 c0             	movzwl %ax,%eax
c0101b50:	0f b7 04 85 68 8f 10 	movzwl -0x3fef7098(,%eax,4),%eax
c0101b57:	c0 
c0101b58:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b5c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b60:	66 d1 e8             	shr    %ax
c0101b63:	0f b7 c0             	movzwl %ax,%eax
c0101b66:	0f b7 04 85 6a 8f 10 	movzwl -0x3fef7096(,%eax,4),%eax
c0101b6d:	c0 
c0101b6e:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b72:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b7d:	00 
c0101b7e:	89 04 24             	mov    %eax,(%esp)
c0101b81:	e8 33 fb ff ff       	call   c01016b9 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b86:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b8a:	83 c0 02             	add    $0x2,%eax
c0101b8d:	0f b7 c0             	movzwl %ax,%eax
c0101b90:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b94:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b98:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b9c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ba0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ba1:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ba4:	0f b6 c0             	movzbl %al,%eax
c0101ba7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bab:	83 c2 02             	add    $0x2,%edx
c0101bae:	0f b7 d2             	movzwl %dx,%edx
c0101bb1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bb5:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bbc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bc0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bc4:	0f b6 c0             	movzbl %al,%eax
c0101bc7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bcb:	83 c2 03             	add    $0x3,%edx
c0101bce:	0f b7 d2             	movzwl %dx,%edx
c0101bd1:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bd5:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bdc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101be0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101be1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101be4:	c1 e8 08             	shr    $0x8,%eax
c0101be7:	0f b6 c0             	movzbl %al,%eax
c0101bea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bee:	83 c2 04             	add    $0x4,%edx
c0101bf1:	0f b7 d2             	movzwl %dx,%edx
c0101bf4:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf8:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bfb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101bff:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c03:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c07:	c1 e8 10             	shr    $0x10,%eax
c0101c0a:	0f b6 c0             	movzbl %al,%eax
c0101c0d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c11:	83 c2 05             	add    $0x5,%edx
c0101c14:	0f b7 d2             	movzwl %dx,%edx
c0101c17:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c1b:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c1e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c22:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c26:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c27:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c2b:	83 e0 01             	and    $0x1,%eax
c0101c2e:	c1 e0 04             	shl    $0x4,%eax
c0101c31:	89 c2                	mov    %eax,%edx
c0101c33:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c36:	c1 e8 18             	shr    $0x18,%eax
c0101c39:	83 e0 0f             	and    $0xf,%eax
c0101c3c:	09 d0                	or     %edx,%eax
c0101c3e:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c41:	0f b6 c0             	movzbl %al,%eax
c0101c44:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c48:	83 c2 06             	add    $0x6,%edx
c0101c4b:	0f b7 d2             	movzwl %dx,%edx
c0101c4e:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c52:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c55:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c59:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c5d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c62:	83 c0 07             	add    $0x7,%eax
c0101c65:	0f b7 c0             	movzwl %ax,%eax
c0101c68:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c6c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c70:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c74:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c78:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c80:	eb 5a                	jmp    c0101cdc <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c82:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c86:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c8d:	00 
c0101c8e:	89 04 24             	mov    %eax,(%esp)
c0101c91:	e8 23 fa ff ff       	call   c01016b9 <ide_wait_ready>
c0101c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c9d:	74 02                	je     c0101ca1 <ide_read_secs+0x1f7>
            goto out;
c0101c9f:	eb 41                	jmp    c0101ce2 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101ca1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ca5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca8:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cab:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101cae:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cb5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb8:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cbb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cbe:	89 cb                	mov    %ecx,%ebx
c0101cc0:	89 df                	mov    %ebx,%edi
c0101cc2:	89 c1                	mov    %eax,%ecx
c0101cc4:	fc                   	cld    
c0101cc5:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc7:	89 c8                	mov    %ecx,%eax
c0101cc9:	89 fb                	mov    %edi,%ebx
c0101ccb:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101cce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cd1:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cd5:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cdc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101ce0:	75 a0                	jne    c0101c82 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101ce5:	83 c4 50             	add    $0x50,%esp
c0101ce8:	5b                   	pop    %ebx
c0101ce9:	5f                   	pop    %edi
c0101cea:	5d                   	pop    %ebp
c0101ceb:	c3                   	ret    

c0101cec <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101cec:	55                   	push   %ebp
c0101ced:	89 e5                	mov    %esp,%ebp
c0101cef:	56                   	push   %esi
c0101cf0:	53                   	push   %ebx
c0101cf1:	83 ec 50             	sub    $0x50,%esp
c0101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf7:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cfb:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d02:	77 24                	ja     c0101d28 <ide_write_secs+0x3c>
c0101d04:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d09:	77 1d                	ja     c0101d28 <ide_write_secs+0x3c>
c0101d0b:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d0f:	c1 e0 03             	shl    $0x3,%eax
c0101d12:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d19:	29 c2                	sub    %eax,%edx
c0101d1b:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101d21:	0f b6 00             	movzbl (%eax),%eax
c0101d24:	84 c0                	test   %al,%al
c0101d26:	75 24                	jne    c0101d4c <ide_write_secs+0x60>
c0101d28:	c7 44 24 0c f8 8f 10 	movl   $0xc0108ff8,0xc(%esp)
c0101d2f:	c0 
c0101d30:	c7 44 24 08 b3 8f 10 	movl   $0xc0108fb3,0x8(%esp)
c0101d37:	c0 
c0101d38:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d3f:	00 
c0101d40:	c7 04 24 c8 8f 10 c0 	movl   $0xc0108fc8,(%esp)
c0101d47:	e8 90 ef ff ff       	call   c0100cdc <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d4c:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d53:	77 0f                	ja     c0101d64 <ide_write_secs+0x78>
c0101d55:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d58:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d5b:	01 d0                	add    %edx,%eax
c0101d5d:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d62:	76 24                	jbe    c0101d88 <ide_write_secs+0x9c>
c0101d64:	c7 44 24 0c 20 90 10 	movl   $0xc0109020,0xc(%esp)
c0101d6b:	c0 
c0101d6c:	c7 44 24 08 b3 8f 10 	movl   $0xc0108fb3,0x8(%esp)
c0101d73:	c0 
c0101d74:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d7b:	00 
c0101d7c:	c7 04 24 c8 8f 10 c0 	movl   $0xc0108fc8,(%esp)
c0101d83:	e8 54 ef ff ff       	call   c0100cdc <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d88:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d8c:	66 d1 e8             	shr    %ax
c0101d8f:	0f b7 c0             	movzwl %ax,%eax
c0101d92:	0f b7 04 85 68 8f 10 	movzwl -0x3fef7098(,%eax,4),%eax
c0101d99:	c0 
c0101d9a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d9e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da2:	66 d1 e8             	shr    %ax
c0101da5:	0f b7 c0             	movzwl %ax,%eax
c0101da8:	0f b7 04 85 6a 8f 10 	movzwl -0x3fef7096(,%eax,4),%eax
c0101daf:	c0 
c0101db0:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101db4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dbf:	00 
c0101dc0:	89 04 24             	mov    %eax,(%esp)
c0101dc3:	e8 f1 f8 ff ff       	call   c01016b9 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dcc:	83 c0 02             	add    $0x2,%eax
c0101dcf:	0f b7 c0             	movzwl %ax,%eax
c0101dd2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dd6:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dda:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101dde:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101de2:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101de3:	8b 45 14             	mov    0x14(%ebp),%eax
c0101de6:	0f b6 c0             	movzbl %al,%eax
c0101de9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ded:	83 c2 02             	add    $0x2,%edx
c0101df0:	0f b7 d2             	movzwl %dx,%edx
c0101df3:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df7:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101dfa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101dfe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e02:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e03:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e06:	0f b6 c0             	movzbl %al,%eax
c0101e09:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e0d:	83 c2 03             	add    $0x3,%edx
c0101e10:	0f b7 d2             	movzwl %dx,%edx
c0101e13:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e17:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e1a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e1e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e22:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e26:	c1 e8 08             	shr    $0x8,%eax
c0101e29:	0f b6 c0             	movzbl %al,%eax
c0101e2c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e30:	83 c2 04             	add    $0x4,%edx
c0101e33:	0f b7 d2             	movzwl %dx,%edx
c0101e36:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e3a:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e3d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e41:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e45:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e49:	c1 e8 10             	shr    $0x10,%eax
c0101e4c:	0f b6 c0             	movzbl %al,%eax
c0101e4f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e53:	83 c2 05             	add    $0x5,%edx
c0101e56:	0f b7 d2             	movzwl %dx,%edx
c0101e59:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e5d:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e60:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e64:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e68:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e69:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e6d:	83 e0 01             	and    $0x1,%eax
c0101e70:	c1 e0 04             	shl    $0x4,%eax
c0101e73:	89 c2                	mov    %eax,%edx
c0101e75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e78:	c1 e8 18             	shr    $0x18,%eax
c0101e7b:	83 e0 0f             	and    $0xf,%eax
c0101e7e:	09 d0                	or     %edx,%eax
c0101e80:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e83:	0f b6 c0             	movzbl %al,%eax
c0101e86:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e8a:	83 c2 06             	add    $0x6,%edx
c0101e8d:	0f b7 d2             	movzwl %dx,%edx
c0101e90:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e94:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e97:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e9b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e9f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101ea0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ea4:	83 c0 07             	add    $0x7,%eax
c0101ea7:	0f b7 c0             	movzwl %ax,%eax
c0101eaa:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101eae:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eb2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eb6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101eba:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ebb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ec2:	eb 5a                	jmp    c0101f1e <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ec4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ecf:	00 
c0101ed0:	89 04 24             	mov    %eax,(%esp)
c0101ed3:	e8 e1 f7 ff ff       	call   c01016b9 <ide_wait_ready>
c0101ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101edf:	74 02                	je     c0101ee3 <ide_write_secs+0x1f7>
            goto out;
c0101ee1:	eb 41                	jmp    c0101f24 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ee3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101eea:	8b 45 10             	mov    0x10(%ebp),%eax
c0101eed:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ef0:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101efa:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101efd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f00:	89 cb                	mov    %ecx,%ebx
c0101f02:	89 de                	mov    %ebx,%esi
c0101f04:	89 c1                	mov    %eax,%ecx
c0101f06:	fc                   	cld    
c0101f07:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f09:	89 c8                	mov    %ecx,%eax
c0101f0b:	89 f3                	mov    %esi,%ebx
c0101f0d:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f10:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f13:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f17:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f1e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f22:	75 a0                	jne    c0101ec4 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f27:	83 c4 50             	add    $0x50,%esp
c0101f2a:	5b                   	pop    %ebx
c0101f2b:	5e                   	pop    %esi
c0101f2c:	5d                   	pop    %ebp
c0101f2d:	c3                   	ret    

c0101f2e <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f2e:	55                   	push   %ebp
c0101f2f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f31:	fb                   	sti    
    sti();
}
c0101f32:	5d                   	pop    %ebp
c0101f33:	c3                   	ret    

c0101f34 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f34:	55                   	push   %ebp
c0101f35:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f37:	fa                   	cli    
    cli();
}
c0101f38:	5d                   	pop    %ebp
c0101f39:	c3                   	ret    

c0101f3a <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f3a:	55                   	push   %ebp
c0101f3b:	89 e5                	mov    %esp,%ebp
c0101f3d:	83 ec 14             	sub    $0x14,%esp
c0101f40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f43:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f47:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f4b:	66 a3 70 05 12 c0    	mov    %ax,0xc0120570
    if (did_init) {
c0101f51:	a1 e0 11 12 c0       	mov    0xc01211e0,%eax
c0101f56:	85 c0                	test   %eax,%eax
c0101f58:	74 36                	je     c0101f90 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f5a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f5e:	0f b6 c0             	movzbl %al,%eax
c0101f61:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f67:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f6a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f6e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f72:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f73:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f77:	66 c1 e8 08          	shr    $0x8,%ax
c0101f7b:	0f b6 c0             	movzbl %al,%eax
c0101f7e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f84:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f87:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f8b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f8f:	ee                   	out    %al,(%dx)
    }
}
c0101f90:	c9                   	leave  
c0101f91:	c3                   	ret    

c0101f92 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f92:	55                   	push   %ebp
c0101f93:	89 e5                	mov    %esp,%ebp
c0101f95:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9b:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fa0:	89 c1                	mov    %eax,%ecx
c0101fa2:	d3 e2                	shl    %cl,%edx
c0101fa4:	89 d0                	mov    %edx,%eax
c0101fa6:	f7 d0                	not    %eax
c0101fa8:	89 c2                	mov    %eax,%edx
c0101faa:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c0101fb1:	21 d0                	and    %edx,%eax
c0101fb3:	0f b7 c0             	movzwl %ax,%eax
c0101fb6:	89 04 24             	mov    %eax,(%esp)
c0101fb9:	e8 7c ff ff ff       	call   c0101f3a <pic_setmask>
}
c0101fbe:	c9                   	leave  
c0101fbf:	c3                   	ret    

c0101fc0 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fc0:	55                   	push   %ebp
c0101fc1:	89 e5                	mov    %esp,%ebp
c0101fc3:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fc6:	c7 05 e0 11 12 c0 01 	movl   $0x1,0xc01211e0
c0101fcd:	00 00 00 
c0101fd0:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fd6:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fda:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fde:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fe2:	ee                   	out    %al,(%dx)
c0101fe3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fe9:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fed:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ff1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ff5:	ee                   	out    %al,(%dx)
c0101ff6:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ffc:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0102000:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102004:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102008:	ee                   	out    %al,(%dx)
c0102009:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010200f:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102013:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102017:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010201b:	ee                   	out    %al,(%dx)
c010201c:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102022:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102026:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010202a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010202e:	ee                   	out    %al,(%dx)
c010202f:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102035:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102039:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010203d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102041:	ee                   	out    %al,(%dx)
c0102042:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102048:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010204c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102050:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102054:	ee                   	out    %al,(%dx)
c0102055:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010205b:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c010205f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102063:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102067:	ee                   	out    %al,(%dx)
c0102068:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010206e:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102072:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102076:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010207a:	ee                   	out    %al,(%dx)
c010207b:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102081:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102085:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102089:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010208d:	ee                   	out    %al,(%dx)
c010208e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102094:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102098:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010209c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020a0:	ee                   	out    %al,(%dx)
c01020a1:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a7:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020ab:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020af:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020b3:	ee                   	out    %al,(%dx)
c01020b4:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020ba:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020be:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020c2:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020c6:	ee                   	out    %al,(%dx)
c01020c7:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020cd:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020d1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020d5:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020d9:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020da:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c01020e1:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020e5:	74 12                	je     c01020f9 <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e7:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c01020ee:	0f b7 c0             	movzwl %ax,%eax
c01020f1:	89 04 24             	mov    %eax,(%esp)
c01020f4:	e8 41 fe ff ff       	call   c0101f3a <pic_setmask>
    }
}
c01020f9:	c9                   	leave  
c01020fa:	c3                   	ret    

c01020fb <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020fb:	55                   	push   %ebp
c01020fc:	89 e5                	mov    %esp,%ebp
c01020fe:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102101:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102108:	00 
c0102109:	c7 04 24 60 90 10 c0 	movl   $0xc0109060,(%esp)
c0102110:	e8 36 e2 ff ff       	call   c010034b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0102115:	c9                   	leave  
c0102116:	c3                   	ret    

c0102117 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102117:	55                   	push   %ebp
c0102118:	89 e5                	mov    %esp,%ebp
c010211a:	83 ec 10             	sub    $0x10,%esp
	*     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
	*     Notice: the argument of lidt is idt_pd. try to find it!
	*/

	extern uintptr_t __vectors[];
	int i = 0;
c010211d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < 256) {
c0102124:	e9 c3 00 00 00       	jmp    c01021ec <idt_init+0xd5>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102129:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010212c:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c0102133:	89 c2                	mov    %eax,%edx
c0102135:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102138:	66 89 14 c5 00 12 12 	mov    %dx,-0x3fedee00(,%eax,8)
c010213f:	c0 
c0102140:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102143:	66 c7 04 c5 02 12 12 	movw   $0x8,-0x3fededfe(,%eax,8)
c010214a:	c0 08 00 
c010214d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102150:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c0102157:	c0 
c0102158:	83 e2 e0             	and    $0xffffffe0,%edx
c010215b:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c0102162:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102165:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c010216c:	c0 
c010216d:	83 e2 1f             	and    $0x1f,%edx
c0102170:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c0102177:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217a:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c0102181:	c0 
c0102182:	83 e2 f0             	and    $0xfffffff0,%edx
c0102185:	83 ca 0e             	or     $0xe,%edx
c0102188:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c010218f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102192:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c0102199:	c0 
c010219a:	83 e2 ef             	and    $0xffffffef,%edx
c010219d:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a7:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021ae:	c0 
c01021af:	83 e2 9f             	and    $0xffffff9f,%edx
c01021b2:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021bc:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021c3:	c0 
c01021c4:	83 ca 80             	or     $0xffffff80,%edx
c01021c7:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d1:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c01021d8:	c1 e8 10             	shr    $0x10,%eax
c01021db:	89 c2                	mov    %eax,%edx
c01021dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e0:	66 89 14 c5 06 12 12 	mov    %dx,-0x3fededfa(,%eax,8)
c01021e7:	c0 
		i++;
c01021e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	*     Notice: the argument of lidt is idt_pd. try to find it!
	*/

	extern uintptr_t __vectors[];
	int i = 0;
	while (i < 256) {
c01021ec:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01021f3:	0f 8e 30 ff ff ff    	jle    c0102129 <idt_init+0x12>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		i++;
	}
	SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
c01021f9:	a1 00 08 12 c0       	mov    0xc0120800,%eax
c01021fe:	66 a3 00 16 12 c0    	mov    %ax,0xc0121600
c0102204:	66 c7 05 02 16 12 c0 	movw   $0x8,0xc0121602
c010220b:	08 00 
c010220d:	0f b6 05 04 16 12 c0 	movzbl 0xc0121604,%eax
c0102214:	83 e0 e0             	and    $0xffffffe0,%eax
c0102217:	a2 04 16 12 c0       	mov    %al,0xc0121604
c010221c:	0f b6 05 04 16 12 c0 	movzbl 0xc0121604,%eax
c0102223:	83 e0 1f             	and    $0x1f,%eax
c0102226:	a2 04 16 12 c0       	mov    %al,0xc0121604
c010222b:	0f b6 05 05 16 12 c0 	movzbl 0xc0121605,%eax
c0102232:	83 c8 0f             	or     $0xf,%eax
c0102235:	a2 05 16 12 c0       	mov    %al,0xc0121605
c010223a:	0f b6 05 05 16 12 c0 	movzbl 0xc0121605,%eax
c0102241:	83 e0 ef             	and    $0xffffffef,%eax
c0102244:	a2 05 16 12 c0       	mov    %al,0xc0121605
c0102249:	0f b6 05 05 16 12 c0 	movzbl 0xc0121605,%eax
c0102250:	83 c8 60             	or     $0x60,%eax
c0102253:	a2 05 16 12 c0       	mov    %al,0xc0121605
c0102258:	0f b6 05 05 16 12 c0 	movzbl 0xc0121605,%eax
c010225f:	83 c8 80             	or     $0xffffff80,%eax
c0102262:	a2 05 16 12 c0       	mov    %al,0xc0121605
c0102267:	a1 00 08 12 c0       	mov    0xc0120800,%eax
c010226c:	c1 e8 10             	shr    $0x10,%eax
c010226f:	66 a3 06 16 12 c0    	mov    %ax,0xc0121606
c0102275:	c7 45 f8 80 05 12 c0 	movl   $0xc0120580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010227c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010227f:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c0102282:	c9                   	leave  
c0102283:	c3                   	ret    

c0102284 <trapname>:

static const char *
trapname(int trapno) {
c0102284:	55                   	push   %ebp
c0102285:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102287:	8b 45 08             	mov    0x8(%ebp),%eax
c010228a:	83 f8 13             	cmp    $0x13,%eax
c010228d:	77 0c                	ja     c010229b <trapname+0x17>
        return excnames[trapno];
c010228f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102292:	8b 04 85 40 94 10 c0 	mov    -0x3fef6bc0(,%eax,4),%eax
c0102299:	eb 18                	jmp    c01022b3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010229b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010229f:	7e 0d                	jle    c01022ae <trapname+0x2a>
c01022a1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022a5:	7f 07                	jg     c01022ae <trapname+0x2a>
        return "Hardware Interrupt";
c01022a7:	b8 6a 90 10 c0       	mov    $0xc010906a,%eax
c01022ac:	eb 05                	jmp    c01022b3 <trapname+0x2f>
    }
    return "(unknown trap)";
c01022ae:	b8 7d 90 10 c0       	mov    $0xc010907d,%eax
}
c01022b3:	5d                   	pop    %ebp
c01022b4:	c3                   	ret    

c01022b5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022b5:	55                   	push   %ebp
c01022b6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022bb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022bf:	66 83 f8 08          	cmp    $0x8,%ax
c01022c3:	0f 94 c0             	sete   %al
c01022c6:	0f b6 c0             	movzbl %al,%eax
}
c01022c9:	5d                   	pop    %ebp
c01022ca:	c3                   	ret    

c01022cb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01022cb:	55                   	push   %ebp
c01022cc:	89 e5                	mov    %esp,%ebp
c01022ce:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01022d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022d8:	c7 04 24 be 90 10 c0 	movl   $0xc01090be,(%esp)
c01022df:	e8 67 e0 ff ff       	call   c010034b <cprintf>
    print_regs(&tf->tf_regs);
c01022e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e7:	89 04 24             	mov    %eax,(%esp)
c01022ea:	e8 a1 01 00 00       	call   c0102490 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01022ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f2:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022f6:	0f b7 c0             	movzwl %ax,%eax
c01022f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022fd:	c7 04 24 cf 90 10 c0 	movl   $0xc01090cf,(%esp)
c0102304:	e8 42 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102309:	8b 45 08             	mov    0x8(%ebp),%eax
c010230c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102310:	0f b7 c0             	movzwl %ax,%eax
c0102313:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102317:	c7 04 24 e2 90 10 c0 	movl   $0xc01090e2,(%esp)
c010231e:	e8 28 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102323:	8b 45 08             	mov    0x8(%ebp),%eax
c0102326:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010232a:	0f b7 c0             	movzwl %ax,%eax
c010232d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102331:	c7 04 24 f5 90 10 c0 	movl   $0xc01090f5,(%esp)
c0102338:	e8 0e e0 ff ff       	call   c010034b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010233d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102340:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102344:	0f b7 c0             	movzwl %ax,%eax
c0102347:	89 44 24 04          	mov    %eax,0x4(%esp)
c010234b:	c7 04 24 08 91 10 c0 	movl   $0xc0109108,(%esp)
c0102352:	e8 f4 df ff ff       	call   c010034b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102357:	8b 45 08             	mov    0x8(%ebp),%eax
c010235a:	8b 40 30             	mov    0x30(%eax),%eax
c010235d:	89 04 24             	mov    %eax,(%esp)
c0102360:	e8 1f ff ff ff       	call   c0102284 <trapname>
c0102365:	8b 55 08             	mov    0x8(%ebp),%edx
c0102368:	8b 52 30             	mov    0x30(%edx),%edx
c010236b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010236f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102373:	c7 04 24 1b 91 10 c0 	movl   $0xc010911b,(%esp)
c010237a:	e8 cc df ff ff       	call   c010034b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010237f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102382:	8b 40 34             	mov    0x34(%eax),%eax
c0102385:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102389:	c7 04 24 2d 91 10 c0 	movl   $0xc010912d,(%esp)
c0102390:	e8 b6 df ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102395:	8b 45 08             	mov    0x8(%ebp),%eax
c0102398:	8b 40 38             	mov    0x38(%eax),%eax
c010239b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010239f:	c7 04 24 3c 91 10 c0 	movl   $0xc010913c,(%esp)
c01023a6:	e8 a0 df ff ff       	call   c010034b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ae:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023b2:	0f b7 c0             	movzwl %ax,%eax
c01023b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023b9:	c7 04 24 4b 91 10 c0 	movl   $0xc010914b,(%esp)
c01023c0:	e8 86 df ff ff       	call   c010034b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c8:	8b 40 40             	mov    0x40(%eax),%eax
c01023cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023cf:	c7 04 24 5e 91 10 c0 	movl   $0xc010915e,(%esp)
c01023d6:	e8 70 df ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01023e9:	eb 3e                	jmp    c0102429 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01023eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ee:	8b 50 40             	mov    0x40(%eax),%edx
c01023f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023f4:	21 d0                	and    %edx,%eax
c01023f6:	85 c0                	test   %eax,%eax
c01023f8:	74 28                	je     c0102422 <print_trapframe+0x157>
c01023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023fd:	8b 04 85 a0 05 12 c0 	mov    -0x3fedfa60(,%eax,4),%eax
c0102404:	85 c0                	test   %eax,%eax
c0102406:	74 1a                	je     c0102422 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0102408:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010240b:	8b 04 85 a0 05 12 c0 	mov    -0x3fedfa60(,%eax,4),%eax
c0102412:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102416:	c7 04 24 6d 91 10 c0 	movl   $0xc010916d,(%esp)
c010241d:	e8 29 df ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102422:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102426:	d1 65 f0             	shll   -0x10(%ebp)
c0102429:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010242c:	83 f8 17             	cmp    $0x17,%eax
c010242f:	76 ba                	jbe    c01023eb <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102431:	8b 45 08             	mov    0x8(%ebp),%eax
c0102434:	8b 40 40             	mov    0x40(%eax),%eax
c0102437:	25 00 30 00 00       	and    $0x3000,%eax
c010243c:	c1 e8 0c             	shr    $0xc,%eax
c010243f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102443:	c7 04 24 71 91 10 c0 	movl   $0xc0109171,(%esp)
c010244a:	e8 fc de ff ff       	call   c010034b <cprintf>

    if (!trap_in_kernel(tf)) {
c010244f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102452:	89 04 24             	mov    %eax,(%esp)
c0102455:	e8 5b fe ff ff       	call   c01022b5 <trap_in_kernel>
c010245a:	85 c0                	test   %eax,%eax
c010245c:	75 30                	jne    c010248e <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010245e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102461:	8b 40 44             	mov    0x44(%eax),%eax
c0102464:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102468:	c7 04 24 7a 91 10 c0 	movl   $0xc010917a,(%esp)
c010246f:	e8 d7 de ff ff       	call   c010034b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102474:	8b 45 08             	mov    0x8(%ebp),%eax
c0102477:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c010247b:	0f b7 c0             	movzwl %ax,%eax
c010247e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102482:	c7 04 24 89 91 10 c0 	movl   $0xc0109189,(%esp)
c0102489:	e8 bd de ff ff       	call   c010034b <cprintf>
    }
}
c010248e:	c9                   	leave  
c010248f:	c3                   	ret    

c0102490 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102490:	55                   	push   %ebp
c0102491:	89 e5                	mov    %esp,%ebp
c0102493:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102496:	8b 45 08             	mov    0x8(%ebp),%eax
c0102499:	8b 00                	mov    (%eax),%eax
c010249b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010249f:	c7 04 24 9c 91 10 c0 	movl   $0xc010919c,(%esp)
c01024a6:	e8 a0 de ff ff       	call   c010034b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ae:	8b 40 04             	mov    0x4(%eax),%eax
c01024b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b5:	c7 04 24 ab 91 10 c0 	movl   $0xc01091ab,(%esp)
c01024bc:	e8 8a de ff ff       	call   c010034b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c4:	8b 40 08             	mov    0x8(%eax),%eax
c01024c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024cb:	c7 04 24 ba 91 10 c0 	movl   $0xc01091ba,(%esp)
c01024d2:	e8 74 de ff ff       	call   c010034b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024da:	8b 40 0c             	mov    0xc(%eax),%eax
c01024dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024e1:	c7 04 24 c9 91 10 c0 	movl   $0xc01091c9,(%esp)
c01024e8:	e8 5e de ff ff       	call   c010034b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f0:	8b 40 10             	mov    0x10(%eax),%eax
c01024f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024f7:	c7 04 24 d8 91 10 c0 	movl   $0xc01091d8,(%esp)
c01024fe:	e8 48 de ff ff       	call   c010034b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102503:	8b 45 08             	mov    0x8(%ebp),%eax
c0102506:	8b 40 14             	mov    0x14(%eax),%eax
c0102509:	89 44 24 04          	mov    %eax,0x4(%esp)
c010250d:	c7 04 24 e7 91 10 c0 	movl   $0xc01091e7,(%esp)
c0102514:	e8 32 de ff ff       	call   c010034b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102519:	8b 45 08             	mov    0x8(%ebp),%eax
c010251c:	8b 40 18             	mov    0x18(%eax),%eax
c010251f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102523:	c7 04 24 f6 91 10 c0 	movl   $0xc01091f6,(%esp)
c010252a:	e8 1c de ff ff       	call   c010034b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010252f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102532:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102535:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102539:	c7 04 24 05 92 10 c0 	movl   $0xc0109205,(%esp)
c0102540:	e8 06 de ff ff       	call   c010034b <cprintf>
}
c0102545:	c9                   	leave  
c0102546:	c3                   	ret    

c0102547 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102547:	55                   	push   %ebp
c0102548:	89 e5                	mov    %esp,%ebp
c010254a:	53                   	push   %ebx
c010254b:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010254e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102551:	8b 40 34             	mov    0x34(%eax),%eax
c0102554:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102557:	85 c0                	test   %eax,%eax
c0102559:	74 07                	je     c0102562 <print_pgfault+0x1b>
c010255b:	b9 14 92 10 c0       	mov    $0xc0109214,%ecx
c0102560:	eb 05                	jmp    c0102567 <print_pgfault+0x20>
c0102562:	b9 25 92 10 c0       	mov    $0xc0109225,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102567:	8b 45 08             	mov    0x8(%ebp),%eax
c010256a:	8b 40 34             	mov    0x34(%eax),%eax
c010256d:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102570:	85 c0                	test   %eax,%eax
c0102572:	74 07                	je     c010257b <print_pgfault+0x34>
c0102574:	ba 57 00 00 00       	mov    $0x57,%edx
c0102579:	eb 05                	jmp    c0102580 <print_pgfault+0x39>
c010257b:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102580:	8b 45 08             	mov    0x8(%ebp),%eax
c0102583:	8b 40 34             	mov    0x34(%eax),%eax
c0102586:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102589:	85 c0                	test   %eax,%eax
c010258b:	74 07                	je     c0102594 <print_pgfault+0x4d>
c010258d:	b8 55 00 00 00       	mov    $0x55,%eax
c0102592:	eb 05                	jmp    c0102599 <print_pgfault+0x52>
c0102594:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102599:	0f 20 d3             	mov    %cr2,%ebx
c010259c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010259f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c01025a2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01025a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01025aa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01025ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01025b2:	c7 04 24 34 92 10 c0 	movl   $0xc0109234,(%esp)
c01025b9:	e8 8d dd ff ff       	call   c010034b <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025be:	83 c4 34             	add    $0x34,%esp
c01025c1:	5b                   	pop    %ebx
c01025c2:	5d                   	pop    %ebp
c01025c3:	c3                   	ret    

c01025c4 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025c4:	55                   	push   %ebp
c01025c5:	89 e5                	mov    %esp,%ebp
c01025c7:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01025cd:	89 04 24             	mov    %eax,(%esp)
c01025d0:	e8 72 ff ff ff       	call   c0102547 <print_pgfault>
    if (check_mm_struct != NULL) {
c01025d5:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01025da:	85 c0                	test   %eax,%eax
c01025dc:	74 28                	je     c0102606 <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025de:	0f 20 d0             	mov    %cr2,%eax
c01025e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01025e7:	89 c1                	mov    %eax,%ecx
c01025e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ec:	8b 50 34             	mov    0x34(%eax),%edx
c01025ef:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01025f4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01025f8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01025fc:	89 04 24             	mov    %eax,(%esp)
c01025ff:	e8 32 56 00 00       	call   c0107c36 <do_pgfault>
c0102604:	eb 1c                	jmp    c0102622 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c0102606:	c7 44 24 08 57 92 10 	movl   $0xc0109257,0x8(%esp)
c010260d:	c0 
c010260e:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0102615:	00 
c0102616:	c7 04 24 6e 92 10 c0 	movl   $0xc010926e,(%esp)
c010261d:	e8 ba e6 ff ff       	call   c0100cdc <__panic>
}
c0102622:	c9                   	leave  
c0102623:	c3                   	ret    

c0102624 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102624:	55                   	push   %ebp
c0102625:	89 e5                	mov    %esp,%ebp
c0102627:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c010262a:	8b 45 08             	mov    0x8(%ebp),%eax
c010262d:	8b 40 30             	mov    0x30(%eax),%eax
c0102630:	83 f8 24             	cmp    $0x24,%eax
c0102633:	0f 84 c1 00 00 00    	je     c01026fa <trap_dispatch+0xd6>
c0102639:	83 f8 24             	cmp    $0x24,%eax
c010263c:	77 18                	ja     c0102656 <trap_dispatch+0x32>
c010263e:	83 f8 20             	cmp    $0x20,%eax
c0102641:	74 7d                	je     c01026c0 <trap_dispatch+0x9c>
c0102643:	83 f8 21             	cmp    $0x21,%eax
c0102646:	0f 84 d4 00 00 00    	je     c0102720 <trap_dispatch+0xfc>
c010264c:	83 f8 0e             	cmp    $0xe,%eax
c010264f:	74 28                	je     c0102679 <trap_dispatch+0x55>
c0102651:	e9 0c 01 00 00       	jmp    c0102762 <trap_dispatch+0x13e>
c0102656:	83 f8 2e             	cmp    $0x2e,%eax
c0102659:	0f 82 03 01 00 00    	jb     c0102762 <trap_dispatch+0x13e>
c010265f:	83 f8 2f             	cmp    $0x2f,%eax
c0102662:	0f 86 32 01 00 00    	jbe    c010279a <trap_dispatch+0x176>
c0102668:	83 e8 78             	sub    $0x78,%eax
c010266b:	83 f8 01             	cmp    $0x1,%eax
c010266e:	0f 87 ee 00 00 00    	ja     c0102762 <trap_dispatch+0x13e>
c0102674:	e9 cd 00 00 00       	jmp    c0102746 <trap_dispatch+0x122>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102679:	8b 45 08             	mov    0x8(%ebp),%eax
c010267c:	89 04 24             	mov    %eax,(%esp)
c010267f:	e8 40 ff ff ff       	call   c01025c4 <pgfault_handler>
c0102684:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102687:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010268b:	74 2e                	je     c01026bb <trap_dispatch+0x97>
            print_trapframe(tf);
c010268d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102690:	89 04 24             	mov    %eax,(%esp)
c0102693:	e8 33 fc ff ff       	call   c01022cb <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102698:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010269b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010269f:	c7 44 24 08 7f 92 10 	movl   $0xc010927f,0x8(%esp)
c01026a6:	c0 
c01026a7:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c01026ae:	00 
c01026af:	c7 04 24 6e 92 10 c0 	movl   $0xc010926e,(%esp)
c01026b6:	e8 21 e6 ff ff       	call   c0100cdc <__panic>
        }
        break;
c01026bb:	e9 db 00 00 00       	jmp    c010279b <trap_dispatch+0x177>
		/* handle the timer interrupt */
		/* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
		* (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
		* (3) Too Simple? Yes, I think so!
		*/
		ticks = (ticks + 1) % TICK_NUM;
c01026c0:	a1 bc 1a 12 c0       	mov    0xc0121abc,%eax
c01026c5:	8d 48 01             	lea    0x1(%eax),%ecx
c01026c8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01026cd:	89 c8                	mov    %ecx,%eax
c01026cf:	f7 e2                	mul    %edx
c01026d1:	89 d0                	mov    %edx,%eax
c01026d3:	c1 e8 05             	shr    $0x5,%eax
c01026d6:	6b c0 64             	imul   $0x64,%eax,%eax
c01026d9:	29 c1                	sub    %eax,%ecx
c01026db:	89 c8                	mov    %ecx,%eax
c01026dd:	a3 bc 1a 12 c0       	mov    %eax,0xc0121abc
		if (ticks == 0)
c01026e2:	a1 bc 1a 12 c0       	mov    0xc0121abc,%eax
c01026e7:	85 c0                	test   %eax,%eax
c01026e9:	75 0a                	jne    c01026f5 <trap_dispatch+0xd1>
			print_ticks();
c01026eb:	e8 0b fa ff ff       	call   c01020fb <print_ticks>
		break;
c01026f0:	e9 a6 00 00 00       	jmp    c010279b <trap_dispatch+0x177>
c01026f5:	e9 a1 00 00 00       	jmp    c010279b <trap_dispatch+0x177>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01026fa:	e8 4b ef ff ff       	call   c010164a <cons_getc>
c01026ff:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102702:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102706:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c010270a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010270e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102712:	c7 04 24 9a 92 10 c0 	movl   $0xc010929a,(%esp)
c0102719:	e8 2d dc ff ff       	call   c010034b <cprintf>
        break;
c010271e:	eb 7b                	jmp    c010279b <trap_dispatch+0x177>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102720:	e8 25 ef ff ff       	call   c010164a <cons_getc>
c0102725:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102728:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010272c:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102730:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102734:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102738:	c7 04 24 ac 92 10 c0 	movl   $0xc01092ac,(%esp)
c010273f:	e8 07 dc ff ff       	call   c010034b <cprintf>
        break;
c0102744:	eb 55                	jmp    c010279b <trap_dispatch+0x177>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102746:	c7 44 24 08 bb 92 10 	movl   $0xc01092bb,0x8(%esp)
c010274d:	c0 
c010274e:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0102755:	00 
c0102756:	c7 04 24 6e 92 10 c0 	movl   $0xc010926e,(%esp)
c010275d:	e8 7a e5 ff ff       	call   c0100cdc <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102762:	8b 45 08             	mov    0x8(%ebp),%eax
c0102765:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102769:	0f b7 c0             	movzwl %ax,%eax
c010276c:	83 e0 03             	and    $0x3,%eax
c010276f:	85 c0                	test   %eax,%eax
c0102771:	75 28                	jne    c010279b <trap_dispatch+0x177>
            print_trapframe(tf);
c0102773:	8b 45 08             	mov    0x8(%ebp),%eax
c0102776:	89 04 24             	mov    %eax,(%esp)
c0102779:	e8 4d fb ff ff       	call   c01022cb <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010277e:	c7 44 24 08 cb 92 10 	movl   $0xc01092cb,0x8(%esp)
c0102785:	c0 
c0102786:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c010278d:	00 
c010278e:	c7 04 24 6e 92 10 c0 	movl   $0xc010926e,(%esp)
c0102795:	e8 42 e5 ff ff       	call   c0100cdc <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c010279a:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c010279b:	c9                   	leave  
c010279c:	c3                   	ret    

c010279d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010279d:	55                   	push   %ebp
c010279e:	89 e5                	mov    %esp,%ebp
c01027a0:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01027a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01027a6:	89 04 24             	mov    %eax,(%esp)
c01027a9:	e8 76 fe ff ff       	call   c0102624 <trap_dispatch>
}
c01027ae:	c9                   	leave  
c01027af:	c3                   	ret    

c01027b0 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01027b0:	1e                   	push   %ds
    pushl %es
c01027b1:	06                   	push   %es
    pushl %fs
c01027b2:	0f a0                	push   %fs
    pushl %gs
c01027b4:	0f a8                	push   %gs
    pushal
c01027b6:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01027b7:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01027bc:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01027be:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01027c0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01027c1:	e8 d7 ff ff ff       	call   c010279d <trap>

    # pop the pushed stack pointer
    popl %esp
c01027c6:	5c                   	pop    %esp

c01027c7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01027c7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01027c8:	0f a9                	pop    %gs
    popl %fs
c01027ca:	0f a1                	pop    %fs
    popl %es
c01027cc:	07                   	pop    %es
    popl %ds
c01027cd:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01027ce:	83 c4 08             	add    $0x8,%esp
    iret
c01027d1:	cf                   	iret   

c01027d2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01027d2:	6a 00                	push   $0x0
  pushl $0
c01027d4:	6a 00                	push   $0x0
  jmp __alltraps
c01027d6:	e9 d5 ff ff ff       	jmp    c01027b0 <__alltraps>

c01027db <vector1>:
.globl vector1
vector1:
  pushl $0
c01027db:	6a 00                	push   $0x0
  pushl $1
c01027dd:	6a 01                	push   $0x1
  jmp __alltraps
c01027df:	e9 cc ff ff ff       	jmp    c01027b0 <__alltraps>

c01027e4 <vector2>:
.globl vector2
vector2:
  pushl $0
c01027e4:	6a 00                	push   $0x0
  pushl $2
c01027e6:	6a 02                	push   $0x2
  jmp __alltraps
c01027e8:	e9 c3 ff ff ff       	jmp    c01027b0 <__alltraps>

c01027ed <vector3>:
.globl vector3
vector3:
  pushl $0
c01027ed:	6a 00                	push   $0x0
  pushl $3
c01027ef:	6a 03                	push   $0x3
  jmp __alltraps
c01027f1:	e9 ba ff ff ff       	jmp    c01027b0 <__alltraps>

c01027f6 <vector4>:
.globl vector4
vector4:
  pushl $0
c01027f6:	6a 00                	push   $0x0
  pushl $4
c01027f8:	6a 04                	push   $0x4
  jmp __alltraps
c01027fa:	e9 b1 ff ff ff       	jmp    c01027b0 <__alltraps>

c01027ff <vector5>:
.globl vector5
vector5:
  pushl $0
c01027ff:	6a 00                	push   $0x0
  pushl $5
c0102801:	6a 05                	push   $0x5
  jmp __alltraps
c0102803:	e9 a8 ff ff ff       	jmp    c01027b0 <__alltraps>

c0102808 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102808:	6a 00                	push   $0x0
  pushl $6
c010280a:	6a 06                	push   $0x6
  jmp __alltraps
c010280c:	e9 9f ff ff ff       	jmp    c01027b0 <__alltraps>

c0102811 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102811:	6a 00                	push   $0x0
  pushl $7
c0102813:	6a 07                	push   $0x7
  jmp __alltraps
c0102815:	e9 96 ff ff ff       	jmp    c01027b0 <__alltraps>

c010281a <vector8>:
.globl vector8
vector8:
  pushl $8
c010281a:	6a 08                	push   $0x8
  jmp __alltraps
c010281c:	e9 8f ff ff ff       	jmp    c01027b0 <__alltraps>

c0102821 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102821:	6a 09                	push   $0x9
  jmp __alltraps
c0102823:	e9 88 ff ff ff       	jmp    c01027b0 <__alltraps>

c0102828 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102828:	6a 0a                	push   $0xa
  jmp __alltraps
c010282a:	e9 81 ff ff ff       	jmp    c01027b0 <__alltraps>

c010282f <vector11>:
.globl vector11
vector11:
  pushl $11
c010282f:	6a 0b                	push   $0xb
  jmp __alltraps
c0102831:	e9 7a ff ff ff       	jmp    c01027b0 <__alltraps>

c0102836 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102836:	6a 0c                	push   $0xc
  jmp __alltraps
c0102838:	e9 73 ff ff ff       	jmp    c01027b0 <__alltraps>

c010283d <vector13>:
.globl vector13
vector13:
  pushl $13
c010283d:	6a 0d                	push   $0xd
  jmp __alltraps
c010283f:	e9 6c ff ff ff       	jmp    c01027b0 <__alltraps>

c0102844 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102844:	6a 0e                	push   $0xe
  jmp __alltraps
c0102846:	e9 65 ff ff ff       	jmp    c01027b0 <__alltraps>

c010284b <vector15>:
.globl vector15
vector15:
  pushl $0
c010284b:	6a 00                	push   $0x0
  pushl $15
c010284d:	6a 0f                	push   $0xf
  jmp __alltraps
c010284f:	e9 5c ff ff ff       	jmp    c01027b0 <__alltraps>

c0102854 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $16
c0102856:	6a 10                	push   $0x10
  jmp __alltraps
c0102858:	e9 53 ff ff ff       	jmp    c01027b0 <__alltraps>

c010285d <vector17>:
.globl vector17
vector17:
  pushl $17
c010285d:	6a 11                	push   $0x11
  jmp __alltraps
c010285f:	e9 4c ff ff ff       	jmp    c01027b0 <__alltraps>

c0102864 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $18
c0102866:	6a 12                	push   $0x12
  jmp __alltraps
c0102868:	e9 43 ff ff ff       	jmp    c01027b0 <__alltraps>

c010286d <vector19>:
.globl vector19
vector19:
  pushl $0
c010286d:	6a 00                	push   $0x0
  pushl $19
c010286f:	6a 13                	push   $0x13
  jmp __alltraps
c0102871:	e9 3a ff ff ff       	jmp    c01027b0 <__alltraps>

c0102876 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102876:	6a 00                	push   $0x0
  pushl $20
c0102878:	6a 14                	push   $0x14
  jmp __alltraps
c010287a:	e9 31 ff ff ff       	jmp    c01027b0 <__alltraps>

c010287f <vector21>:
.globl vector21
vector21:
  pushl $0
c010287f:	6a 00                	push   $0x0
  pushl $21
c0102881:	6a 15                	push   $0x15
  jmp __alltraps
c0102883:	e9 28 ff ff ff       	jmp    c01027b0 <__alltraps>

c0102888 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102888:	6a 00                	push   $0x0
  pushl $22
c010288a:	6a 16                	push   $0x16
  jmp __alltraps
c010288c:	e9 1f ff ff ff       	jmp    c01027b0 <__alltraps>

c0102891 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102891:	6a 00                	push   $0x0
  pushl $23
c0102893:	6a 17                	push   $0x17
  jmp __alltraps
c0102895:	e9 16 ff ff ff       	jmp    c01027b0 <__alltraps>

c010289a <vector24>:
.globl vector24
vector24:
  pushl $0
c010289a:	6a 00                	push   $0x0
  pushl $24
c010289c:	6a 18                	push   $0x18
  jmp __alltraps
c010289e:	e9 0d ff ff ff       	jmp    c01027b0 <__alltraps>

c01028a3 <vector25>:
.globl vector25
vector25:
  pushl $0
c01028a3:	6a 00                	push   $0x0
  pushl $25
c01028a5:	6a 19                	push   $0x19
  jmp __alltraps
c01028a7:	e9 04 ff ff ff       	jmp    c01027b0 <__alltraps>

c01028ac <vector26>:
.globl vector26
vector26:
  pushl $0
c01028ac:	6a 00                	push   $0x0
  pushl $26
c01028ae:	6a 1a                	push   $0x1a
  jmp __alltraps
c01028b0:	e9 fb fe ff ff       	jmp    c01027b0 <__alltraps>

c01028b5 <vector27>:
.globl vector27
vector27:
  pushl $0
c01028b5:	6a 00                	push   $0x0
  pushl $27
c01028b7:	6a 1b                	push   $0x1b
  jmp __alltraps
c01028b9:	e9 f2 fe ff ff       	jmp    c01027b0 <__alltraps>

c01028be <vector28>:
.globl vector28
vector28:
  pushl $0
c01028be:	6a 00                	push   $0x0
  pushl $28
c01028c0:	6a 1c                	push   $0x1c
  jmp __alltraps
c01028c2:	e9 e9 fe ff ff       	jmp    c01027b0 <__alltraps>

c01028c7 <vector29>:
.globl vector29
vector29:
  pushl $0
c01028c7:	6a 00                	push   $0x0
  pushl $29
c01028c9:	6a 1d                	push   $0x1d
  jmp __alltraps
c01028cb:	e9 e0 fe ff ff       	jmp    c01027b0 <__alltraps>

c01028d0 <vector30>:
.globl vector30
vector30:
  pushl $0
c01028d0:	6a 00                	push   $0x0
  pushl $30
c01028d2:	6a 1e                	push   $0x1e
  jmp __alltraps
c01028d4:	e9 d7 fe ff ff       	jmp    c01027b0 <__alltraps>

c01028d9 <vector31>:
.globl vector31
vector31:
  pushl $0
c01028d9:	6a 00                	push   $0x0
  pushl $31
c01028db:	6a 1f                	push   $0x1f
  jmp __alltraps
c01028dd:	e9 ce fe ff ff       	jmp    c01027b0 <__alltraps>

c01028e2 <vector32>:
.globl vector32
vector32:
  pushl $0
c01028e2:	6a 00                	push   $0x0
  pushl $32
c01028e4:	6a 20                	push   $0x20
  jmp __alltraps
c01028e6:	e9 c5 fe ff ff       	jmp    c01027b0 <__alltraps>

c01028eb <vector33>:
.globl vector33
vector33:
  pushl $0
c01028eb:	6a 00                	push   $0x0
  pushl $33
c01028ed:	6a 21                	push   $0x21
  jmp __alltraps
c01028ef:	e9 bc fe ff ff       	jmp    c01027b0 <__alltraps>

c01028f4 <vector34>:
.globl vector34
vector34:
  pushl $0
c01028f4:	6a 00                	push   $0x0
  pushl $34
c01028f6:	6a 22                	push   $0x22
  jmp __alltraps
c01028f8:	e9 b3 fe ff ff       	jmp    c01027b0 <__alltraps>

c01028fd <vector35>:
.globl vector35
vector35:
  pushl $0
c01028fd:	6a 00                	push   $0x0
  pushl $35
c01028ff:	6a 23                	push   $0x23
  jmp __alltraps
c0102901:	e9 aa fe ff ff       	jmp    c01027b0 <__alltraps>

c0102906 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102906:	6a 00                	push   $0x0
  pushl $36
c0102908:	6a 24                	push   $0x24
  jmp __alltraps
c010290a:	e9 a1 fe ff ff       	jmp    c01027b0 <__alltraps>

c010290f <vector37>:
.globl vector37
vector37:
  pushl $0
c010290f:	6a 00                	push   $0x0
  pushl $37
c0102911:	6a 25                	push   $0x25
  jmp __alltraps
c0102913:	e9 98 fe ff ff       	jmp    c01027b0 <__alltraps>

c0102918 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102918:	6a 00                	push   $0x0
  pushl $38
c010291a:	6a 26                	push   $0x26
  jmp __alltraps
c010291c:	e9 8f fe ff ff       	jmp    c01027b0 <__alltraps>

c0102921 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102921:	6a 00                	push   $0x0
  pushl $39
c0102923:	6a 27                	push   $0x27
  jmp __alltraps
c0102925:	e9 86 fe ff ff       	jmp    c01027b0 <__alltraps>

c010292a <vector40>:
.globl vector40
vector40:
  pushl $0
c010292a:	6a 00                	push   $0x0
  pushl $40
c010292c:	6a 28                	push   $0x28
  jmp __alltraps
c010292e:	e9 7d fe ff ff       	jmp    c01027b0 <__alltraps>

c0102933 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102933:	6a 00                	push   $0x0
  pushl $41
c0102935:	6a 29                	push   $0x29
  jmp __alltraps
c0102937:	e9 74 fe ff ff       	jmp    c01027b0 <__alltraps>

c010293c <vector42>:
.globl vector42
vector42:
  pushl $0
c010293c:	6a 00                	push   $0x0
  pushl $42
c010293e:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102940:	e9 6b fe ff ff       	jmp    c01027b0 <__alltraps>

c0102945 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102945:	6a 00                	push   $0x0
  pushl $43
c0102947:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102949:	e9 62 fe ff ff       	jmp    c01027b0 <__alltraps>

c010294e <vector44>:
.globl vector44
vector44:
  pushl $0
c010294e:	6a 00                	push   $0x0
  pushl $44
c0102950:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102952:	e9 59 fe ff ff       	jmp    c01027b0 <__alltraps>

c0102957 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102957:	6a 00                	push   $0x0
  pushl $45
c0102959:	6a 2d                	push   $0x2d
  jmp __alltraps
c010295b:	e9 50 fe ff ff       	jmp    c01027b0 <__alltraps>

c0102960 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102960:	6a 00                	push   $0x0
  pushl $46
c0102962:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102964:	e9 47 fe ff ff       	jmp    c01027b0 <__alltraps>

c0102969 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102969:	6a 00                	push   $0x0
  pushl $47
c010296b:	6a 2f                	push   $0x2f
  jmp __alltraps
c010296d:	e9 3e fe ff ff       	jmp    c01027b0 <__alltraps>

c0102972 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102972:	6a 00                	push   $0x0
  pushl $48
c0102974:	6a 30                	push   $0x30
  jmp __alltraps
c0102976:	e9 35 fe ff ff       	jmp    c01027b0 <__alltraps>

c010297b <vector49>:
.globl vector49
vector49:
  pushl $0
c010297b:	6a 00                	push   $0x0
  pushl $49
c010297d:	6a 31                	push   $0x31
  jmp __alltraps
c010297f:	e9 2c fe ff ff       	jmp    c01027b0 <__alltraps>

c0102984 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102984:	6a 00                	push   $0x0
  pushl $50
c0102986:	6a 32                	push   $0x32
  jmp __alltraps
c0102988:	e9 23 fe ff ff       	jmp    c01027b0 <__alltraps>

c010298d <vector51>:
.globl vector51
vector51:
  pushl $0
c010298d:	6a 00                	push   $0x0
  pushl $51
c010298f:	6a 33                	push   $0x33
  jmp __alltraps
c0102991:	e9 1a fe ff ff       	jmp    c01027b0 <__alltraps>

c0102996 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102996:	6a 00                	push   $0x0
  pushl $52
c0102998:	6a 34                	push   $0x34
  jmp __alltraps
c010299a:	e9 11 fe ff ff       	jmp    c01027b0 <__alltraps>

c010299f <vector53>:
.globl vector53
vector53:
  pushl $0
c010299f:	6a 00                	push   $0x0
  pushl $53
c01029a1:	6a 35                	push   $0x35
  jmp __alltraps
c01029a3:	e9 08 fe ff ff       	jmp    c01027b0 <__alltraps>

c01029a8 <vector54>:
.globl vector54
vector54:
  pushl $0
c01029a8:	6a 00                	push   $0x0
  pushl $54
c01029aa:	6a 36                	push   $0x36
  jmp __alltraps
c01029ac:	e9 ff fd ff ff       	jmp    c01027b0 <__alltraps>

c01029b1 <vector55>:
.globl vector55
vector55:
  pushl $0
c01029b1:	6a 00                	push   $0x0
  pushl $55
c01029b3:	6a 37                	push   $0x37
  jmp __alltraps
c01029b5:	e9 f6 fd ff ff       	jmp    c01027b0 <__alltraps>

c01029ba <vector56>:
.globl vector56
vector56:
  pushl $0
c01029ba:	6a 00                	push   $0x0
  pushl $56
c01029bc:	6a 38                	push   $0x38
  jmp __alltraps
c01029be:	e9 ed fd ff ff       	jmp    c01027b0 <__alltraps>

c01029c3 <vector57>:
.globl vector57
vector57:
  pushl $0
c01029c3:	6a 00                	push   $0x0
  pushl $57
c01029c5:	6a 39                	push   $0x39
  jmp __alltraps
c01029c7:	e9 e4 fd ff ff       	jmp    c01027b0 <__alltraps>

c01029cc <vector58>:
.globl vector58
vector58:
  pushl $0
c01029cc:	6a 00                	push   $0x0
  pushl $58
c01029ce:	6a 3a                	push   $0x3a
  jmp __alltraps
c01029d0:	e9 db fd ff ff       	jmp    c01027b0 <__alltraps>

c01029d5 <vector59>:
.globl vector59
vector59:
  pushl $0
c01029d5:	6a 00                	push   $0x0
  pushl $59
c01029d7:	6a 3b                	push   $0x3b
  jmp __alltraps
c01029d9:	e9 d2 fd ff ff       	jmp    c01027b0 <__alltraps>

c01029de <vector60>:
.globl vector60
vector60:
  pushl $0
c01029de:	6a 00                	push   $0x0
  pushl $60
c01029e0:	6a 3c                	push   $0x3c
  jmp __alltraps
c01029e2:	e9 c9 fd ff ff       	jmp    c01027b0 <__alltraps>

c01029e7 <vector61>:
.globl vector61
vector61:
  pushl $0
c01029e7:	6a 00                	push   $0x0
  pushl $61
c01029e9:	6a 3d                	push   $0x3d
  jmp __alltraps
c01029eb:	e9 c0 fd ff ff       	jmp    c01027b0 <__alltraps>

c01029f0 <vector62>:
.globl vector62
vector62:
  pushl $0
c01029f0:	6a 00                	push   $0x0
  pushl $62
c01029f2:	6a 3e                	push   $0x3e
  jmp __alltraps
c01029f4:	e9 b7 fd ff ff       	jmp    c01027b0 <__alltraps>

c01029f9 <vector63>:
.globl vector63
vector63:
  pushl $0
c01029f9:	6a 00                	push   $0x0
  pushl $63
c01029fb:	6a 3f                	push   $0x3f
  jmp __alltraps
c01029fd:	e9 ae fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a02 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a02:	6a 00                	push   $0x0
  pushl $64
c0102a04:	6a 40                	push   $0x40
  jmp __alltraps
c0102a06:	e9 a5 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a0b <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a0b:	6a 00                	push   $0x0
  pushl $65
c0102a0d:	6a 41                	push   $0x41
  jmp __alltraps
c0102a0f:	e9 9c fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a14 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a14:	6a 00                	push   $0x0
  pushl $66
c0102a16:	6a 42                	push   $0x42
  jmp __alltraps
c0102a18:	e9 93 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a1d <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a1d:	6a 00                	push   $0x0
  pushl $67
c0102a1f:	6a 43                	push   $0x43
  jmp __alltraps
c0102a21:	e9 8a fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a26 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a26:	6a 00                	push   $0x0
  pushl $68
c0102a28:	6a 44                	push   $0x44
  jmp __alltraps
c0102a2a:	e9 81 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a2f <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a2f:	6a 00                	push   $0x0
  pushl $69
c0102a31:	6a 45                	push   $0x45
  jmp __alltraps
c0102a33:	e9 78 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a38 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a38:	6a 00                	push   $0x0
  pushl $70
c0102a3a:	6a 46                	push   $0x46
  jmp __alltraps
c0102a3c:	e9 6f fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a41 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a41:	6a 00                	push   $0x0
  pushl $71
c0102a43:	6a 47                	push   $0x47
  jmp __alltraps
c0102a45:	e9 66 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a4a <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a4a:	6a 00                	push   $0x0
  pushl $72
c0102a4c:	6a 48                	push   $0x48
  jmp __alltraps
c0102a4e:	e9 5d fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a53 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a53:	6a 00                	push   $0x0
  pushl $73
c0102a55:	6a 49                	push   $0x49
  jmp __alltraps
c0102a57:	e9 54 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a5c <vector74>:
.globl vector74
vector74:
  pushl $0
c0102a5c:	6a 00                	push   $0x0
  pushl $74
c0102a5e:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a60:	e9 4b fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a65 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a65:	6a 00                	push   $0x0
  pushl $75
c0102a67:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a69:	e9 42 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a6e <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a6e:	6a 00                	push   $0x0
  pushl $76
c0102a70:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a72:	e9 39 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a77 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a77:	6a 00                	push   $0x0
  pushl $77
c0102a79:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a7b:	e9 30 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a80 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a80:	6a 00                	push   $0x0
  pushl $78
c0102a82:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a84:	e9 27 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a89 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a89:	6a 00                	push   $0x0
  pushl $79
c0102a8b:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a8d:	e9 1e fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a92 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a92:	6a 00                	push   $0x0
  pushl $80
c0102a94:	6a 50                	push   $0x50
  jmp __alltraps
c0102a96:	e9 15 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102a9b <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a9b:	6a 00                	push   $0x0
  pushl $81
c0102a9d:	6a 51                	push   $0x51
  jmp __alltraps
c0102a9f:	e9 0c fd ff ff       	jmp    c01027b0 <__alltraps>

c0102aa4 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102aa4:	6a 00                	push   $0x0
  pushl $82
c0102aa6:	6a 52                	push   $0x52
  jmp __alltraps
c0102aa8:	e9 03 fd ff ff       	jmp    c01027b0 <__alltraps>

c0102aad <vector83>:
.globl vector83
vector83:
  pushl $0
c0102aad:	6a 00                	push   $0x0
  pushl $83
c0102aaf:	6a 53                	push   $0x53
  jmp __alltraps
c0102ab1:	e9 fa fc ff ff       	jmp    c01027b0 <__alltraps>

c0102ab6 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102ab6:	6a 00                	push   $0x0
  pushl $84
c0102ab8:	6a 54                	push   $0x54
  jmp __alltraps
c0102aba:	e9 f1 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102abf <vector85>:
.globl vector85
vector85:
  pushl $0
c0102abf:	6a 00                	push   $0x0
  pushl $85
c0102ac1:	6a 55                	push   $0x55
  jmp __alltraps
c0102ac3:	e9 e8 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102ac8 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102ac8:	6a 00                	push   $0x0
  pushl $86
c0102aca:	6a 56                	push   $0x56
  jmp __alltraps
c0102acc:	e9 df fc ff ff       	jmp    c01027b0 <__alltraps>

c0102ad1 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102ad1:	6a 00                	push   $0x0
  pushl $87
c0102ad3:	6a 57                	push   $0x57
  jmp __alltraps
c0102ad5:	e9 d6 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102ada <vector88>:
.globl vector88
vector88:
  pushl $0
c0102ada:	6a 00                	push   $0x0
  pushl $88
c0102adc:	6a 58                	push   $0x58
  jmp __alltraps
c0102ade:	e9 cd fc ff ff       	jmp    c01027b0 <__alltraps>

c0102ae3 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102ae3:	6a 00                	push   $0x0
  pushl $89
c0102ae5:	6a 59                	push   $0x59
  jmp __alltraps
c0102ae7:	e9 c4 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102aec <vector90>:
.globl vector90
vector90:
  pushl $0
c0102aec:	6a 00                	push   $0x0
  pushl $90
c0102aee:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102af0:	e9 bb fc ff ff       	jmp    c01027b0 <__alltraps>

c0102af5 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102af5:	6a 00                	push   $0x0
  pushl $91
c0102af7:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102af9:	e9 b2 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102afe <vector92>:
.globl vector92
vector92:
  pushl $0
c0102afe:	6a 00                	push   $0x0
  pushl $92
c0102b00:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b02:	e9 a9 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b07 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b07:	6a 00                	push   $0x0
  pushl $93
c0102b09:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b0b:	e9 a0 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b10 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b10:	6a 00                	push   $0x0
  pushl $94
c0102b12:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b14:	e9 97 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b19 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b19:	6a 00                	push   $0x0
  pushl $95
c0102b1b:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b1d:	e9 8e fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b22 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b22:	6a 00                	push   $0x0
  pushl $96
c0102b24:	6a 60                	push   $0x60
  jmp __alltraps
c0102b26:	e9 85 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b2b <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b2b:	6a 00                	push   $0x0
  pushl $97
c0102b2d:	6a 61                	push   $0x61
  jmp __alltraps
c0102b2f:	e9 7c fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b34 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b34:	6a 00                	push   $0x0
  pushl $98
c0102b36:	6a 62                	push   $0x62
  jmp __alltraps
c0102b38:	e9 73 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b3d <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b3d:	6a 00                	push   $0x0
  pushl $99
c0102b3f:	6a 63                	push   $0x63
  jmp __alltraps
c0102b41:	e9 6a fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b46 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b46:	6a 00                	push   $0x0
  pushl $100
c0102b48:	6a 64                	push   $0x64
  jmp __alltraps
c0102b4a:	e9 61 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b4f <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b4f:	6a 00                	push   $0x0
  pushl $101
c0102b51:	6a 65                	push   $0x65
  jmp __alltraps
c0102b53:	e9 58 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b58 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102b58:	6a 00                	push   $0x0
  pushl $102
c0102b5a:	6a 66                	push   $0x66
  jmp __alltraps
c0102b5c:	e9 4f fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b61 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b61:	6a 00                	push   $0x0
  pushl $103
c0102b63:	6a 67                	push   $0x67
  jmp __alltraps
c0102b65:	e9 46 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b6a <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b6a:	6a 00                	push   $0x0
  pushl $104
c0102b6c:	6a 68                	push   $0x68
  jmp __alltraps
c0102b6e:	e9 3d fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b73 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b73:	6a 00                	push   $0x0
  pushl $105
c0102b75:	6a 69                	push   $0x69
  jmp __alltraps
c0102b77:	e9 34 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b7c <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b7c:	6a 00                	push   $0x0
  pushl $106
c0102b7e:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b80:	e9 2b fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b85 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b85:	6a 00                	push   $0x0
  pushl $107
c0102b87:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b89:	e9 22 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b8e <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b8e:	6a 00                	push   $0x0
  pushl $108
c0102b90:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b92:	e9 19 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102b97 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b97:	6a 00                	push   $0x0
  pushl $109
c0102b99:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b9b:	e9 10 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102ba0 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102ba0:	6a 00                	push   $0x0
  pushl $110
c0102ba2:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102ba4:	e9 07 fc ff ff       	jmp    c01027b0 <__alltraps>

c0102ba9 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102ba9:	6a 00                	push   $0x0
  pushl $111
c0102bab:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102bad:	e9 fe fb ff ff       	jmp    c01027b0 <__alltraps>

c0102bb2 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102bb2:	6a 00                	push   $0x0
  pushl $112
c0102bb4:	6a 70                	push   $0x70
  jmp __alltraps
c0102bb6:	e9 f5 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102bbb <vector113>:
.globl vector113
vector113:
  pushl $0
c0102bbb:	6a 00                	push   $0x0
  pushl $113
c0102bbd:	6a 71                	push   $0x71
  jmp __alltraps
c0102bbf:	e9 ec fb ff ff       	jmp    c01027b0 <__alltraps>

c0102bc4 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102bc4:	6a 00                	push   $0x0
  pushl $114
c0102bc6:	6a 72                	push   $0x72
  jmp __alltraps
c0102bc8:	e9 e3 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102bcd <vector115>:
.globl vector115
vector115:
  pushl $0
c0102bcd:	6a 00                	push   $0x0
  pushl $115
c0102bcf:	6a 73                	push   $0x73
  jmp __alltraps
c0102bd1:	e9 da fb ff ff       	jmp    c01027b0 <__alltraps>

c0102bd6 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102bd6:	6a 00                	push   $0x0
  pushl $116
c0102bd8:	6a 74                	push   $0x74
  jmp __alltraps
c0102bda:	e9 d1 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102bdf <vector117>:
.globl vector117
vector117:
  pushl $0
c0102bdf:	6a 00                	push   $0x0
  pushl $117
c0102be1:	6a 75                	push   $0x75
  jmp __alltraps
c0102be3:	e9 c8 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102be8 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102be8:	6a 00                	push   $0x0
  pushl $118
c0102bea:	6a 76                	push   $0x76
  jmp __alltraps
c0102bec:	e9 bf fb ff ff       	jmp    c01027b0 <__alltraps>

c0102bf1 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102bf1:	6a 00                	push   $0x0
  pushl $119
c0102bf3:	6a 77                	push   $0x77
  jmp __alltraps
c0102bf5:	e9 b6 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102bfa <vector120>:
.globl vector120
vector120:
  pushl $0
c0102bfa:	6a 00                	push   $0x0
  pushl $120
c0102bfc:	6a 78                	push   $0x78
  jmp __alltraps
c0102bfe:	e9 ad fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c03 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c03:	6a 00                	push   $0x0
  pushl $121
c0102c05:	6a 79                	push   $0x79
  jmp __alltraps
c0102c07:	e9 a4 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c0c <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c0c:	6a 00                	push   $0x0
  pushl $122
c0102c0e:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c10:	e9 9b fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c15 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c15:	6a 00                	push   $0x0
  pushl $123
c0102c17:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c19:	e9 92 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c1e <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c1e:	6a 00                	push   $0x0
  pushl $124
c0102c20:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c22:	e9 89 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c27 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c27:	6a 00                	push   $0x0
  pushl $125
c0102c29:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c2b:	e9 80 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c30 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c30:	6a 00                	push   $0x0
  pushl $126
c0102c32:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c34:	e9 77 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c39 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c39:	6a 00                	push   $0x0
  pushl $127
c0102c3b:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c3d:	e9 6e fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c42 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c42:	6a 00                	push   $0x0
  pushl $128
c0102c44:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c49:	e9 62 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c4e <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c4e:	6a 00                	push   $0x0
  pushl $129
c0102c50:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c55:	e9 56 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c5a <vector130>:
.globl vector130
vector130:
  pushl $0
c0102c5a:	6a 00                	push   $0x0
  pushl $130
c0102c5c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c61:	e9 4a fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c66 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c66:	6a 00                	push   $0x0
  pushl $131
c0102c68:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c6d:	e9 3e fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c72 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c72:	6a 00                	push   $0x0
  pushl $132
c0102c74:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c79:	e9 32 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c7e <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c7e:	6a 00                	push   $0x0
  pushl $133
c0102c80:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c85:	e9 26 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c8a <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c8a:	6a 00                	push   $0x0
  pushl $134
c0102c8c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c91:	e9 1a fb ff ff       	jmp    c01027b0 <__alltraps>

c0102c96 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c96:	6a 00                	push   $0x0
  pushl $135
c0102c98:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c9d:	e9 0e fb ff ff       	jmp    c01027b0 <__alltraps>

c0102ca2 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102ca2:	6a 00                	push   $0x0
  pushl $136
c0102ca4:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102ca9:	e9 02 fb ff ff       	jmp    c01027b0 <__alltraps>

c0102cae <vector137>:
.globl vector137
vector137:
  pushl $0
c0102cae:	6a 00                	push   $0x0
  pushl $137
c0102cb0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102cb5:	e9 f6 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102cba <vector138>:
.globl vector138
vector138:
  pushl $0
c0102cba:	6a 00                	push   $0x0
  pushl $138
c0102cbc:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102cc1:	e9 ea fa ff ff       	jmp    c01027b0 <__alltraps>

c0102cc6 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102cc6:	6a 00                	push   $0x0
  pushl $139
c0102cc8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102ccd:	e9 de fa ff ff       	jmp    c01027b0 <__alltraps>

c0102cd2 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102cd2:	6a 00                	push   $0x0
  pushl $140
c0102cd4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102cd9:	e9 d2 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102cde <vector141>:
.globl vector141
vector141:
  pushl $0
c0102cde:	6a 00                	push   $0x0
  pushl $141
c0102ce0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102ce5:	e9 c6 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102cea <vector142>:
.globl vector142
vector142:
  pushl $0
c0102cea:	6a 00                	push   $0x0
  pushl $142
c0102cec:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102cf1:	e9 ba fa ff ff       	jmp    c01027b0 <__alltraps>

c0102cf6 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102cf6:	6a 00                	push   $0x0
  pushl $143
c0102cf8:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102cfd:	e9 ae fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d02 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d02:	6a 00                	push   $0x0
  pushl $144
c0102d04:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d09:	e9 a2 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d0e <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d0e:	6a 00                	push   $0x0
  pushl $145
c0102d10:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d15:	e9 96 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d1a <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d1a:	6a 00                	push   $0x0
  pushl $146
c0102d1c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d21:	e9 8a fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d26 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d26:	6a 00                	push   $0x0
  pushl $147
c0102d28:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d2d:	e9 7e fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d32 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d32:	6a 00                	push   $0x0
  pushl $148
c0102d34:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d39:	e9 72 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d3e <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d3e:	6a 00                	push   $0x0
  pushl $149
c0102d40:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d45:	e9 66 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d4a <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d4a:	6a 00                	push   $0x0
  pushl $150
c0102d4c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d51:	e9 5a fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d56 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d56:	6a 00                	push   $0x0
  pushl $151
c0102d58:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102d5d:	e9 4e fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d62 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d62:	6a 00                	push   $0x0
  pushl $152
c0102d64:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d69:	e9 42 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d6e <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d6e:	6a 00                	push   $0x0
  pushl $153
c0102d70:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d75:	e9 36 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d7a <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d7a:	6a 00                	push   $0x0
  pushl $154
c0102d7c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d81:	e9 2a fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d86 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d86:	6a 00                	push   $0x0
  pushl $155
c0102d88:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d8d:	e9 1e fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d92 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d92:	6a 00                	push   $0x0
  pushl $156
c0102d94:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d99:	e9 12 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102d9e <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d9e:	6a 00                	push   $0x0
  pushl $157
c0102da0:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102da5:	e9 06 fa ff ff       	jmp    c01027b0 <__alltraps>

c0102daa <vector158>:
.globl vector158
vector158:
  pushl $0
c0102daa:	6a 00                	push   $0x0
  pushl $158
c0102dac:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102db1:	e9 fa f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102db6 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102db6:	6a 00                	push   $0x0
  pushl $159
c0102db8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102dbd:	e9 ee f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102dc2 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102dc2:	6a 00                	push   $0x0
  pushl $160
c0102dc4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102dc9:	e9 e2 f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102dce <vector161>:
.globl vector161
vector161:
  pushl $0
c0102dce:	6a 00                	push   $0x0
  pushl $161
c0102dd0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102dd5:	e9 d6 f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102dda <vector162>:
.globl vector162
vector162:
  pushl $0
c0102dda:	6a 00                	push   $0x0
  pushl $162
c0102ddc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102de1:	e9 ca f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102de6 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102de6:	6a 00                	push   $0x0
  pushl $163
c0102de8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102ded:	e9 be f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102df2 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102df2:	6a 00                	push   $0x0
  pushl $164
c0102df4:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102df9:	e9 b2 f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102dfe <vector165>:
.globl vector165
vector165:
  pushl $0
c0102dfe:	6a 00                	push   $0x0
  pushl $165
c0102e00:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e05:	e9 a6 f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e0a <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e0a:	6a 00                	push   $0x0
  pushl $166
c0102e0c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e11:	e9 9a f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e16 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e16:	6a 00                	push   $0x0
  pushl $167
c0102e18:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e1d:	e9 8e f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e22 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e22:	6a 00                	push   $0x0
  pushl $168
c0102e24:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e29:	e9 82 f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e2e <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e2e:	6a 00                	push   $0x0
  pushl $169
c0102e30:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e35:	e9 76 f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e3a <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e3a:	6a 00                	push   $0x0
  pushl $170
c0102e3c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e41:	e9 6a f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e46 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e46:	6a 00                	push   $0x0
  pushl $171
c0102e48:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e4d:	e9 5e f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e52 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e52:	6a 00                	push   $0x0
  pushl $172
c0102e54:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102e59:	e9 52 f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e5e <vector173>:
.globl vector173
vector173:
  pushl $0
c0102e5e:	6a 00                	push   $0x0
  pushl $173
c0102e60:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e65:	e9 46 f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e6a <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e6a:	6a 00                	push   $0x0
  pushl $174
c0102e6c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e71:	e9 3a f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e76 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e76:	6a 00                	push   $0x0
  pushl $175
c0102e78:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e7d:	e9 2e f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e82 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e82:	6a 00                	push   $0x0
  pushl $176
c0102e84:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e89:	e9 22 f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e8e <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e8e:	6a 00                	push   $0x0
  pushl $177
c0102e90:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e95:	e9 16 f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102e9a <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e9a:	6a 00                	push   $0x0
  pushl $178
c0102e9c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102ea1:	e9 0a f9 ff ff       	jmp    c01027b0 <__alltraps>

c0102ea6 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102ea6:	6a 00                	push   $0x0
  pushl $179
c0102ea8:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102ead:	e9 fe f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102eb2 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102eb2:	6a 00                	push   $0x0
  pushl $180
c0102eb4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102eb9:	e9 f2 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102ebe <vector181>:
.globl vector181
vector181:
  pushl $0
c0102ebe:	6a 00                	push   $0x0
  pushl $181
c0102ec0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102ec5:	e9 e6 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102eca <vector182>:
.globl vector182
vector182:
  pushl $0
c0102eca:	6a 00                	push   $0x0
  pushl $182
c0102ecc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102ed1:	e9 da f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102ed6 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102ed6:	6a 00                	push   $0x0
  pushl $183
c0102ed8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102edd:	e9 ce f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102ee2 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102ee2:	6a 00                	push   $0x0
  pushl $184
c0102ee4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102ee9:	e9 c2 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102eee <vector185>:
.globl vector185
vector185:
  pushl $0
c0102eee:	6a 00                	push   $0x0
  pushl $185
c0102ef0:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102ef5:	e9 b6 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102efa <vector186>:
.globl vector186
vector186:
  pushl $0
c0102efa:	6a 00                	push   $0x0
  pushl $186
c0102efc:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102f01:	e9 aa f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f06 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f06:	6a 00                	push   $0x0
  pushl $187
c0102f08:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f0d:	e9 9e f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f12 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f12:	6a 00                	push   $0x0
  pushl $188
c0102f14:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f19:	e9 92 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f1e <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f1e:	6a 00                	push   $0x0
  pushl $189
c0102f20:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f25:	e9 86 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f2a <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f2a:	6a 00                	push   $0x0
  pushl $190
c0102f2c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f31:	e9 7a f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f36 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f36:	6a 00                	push   $0x0
  pushl $191
c0102f38:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f3d:	e9 6e f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f42 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f42:	6a 00                	push   $0x0
  pushl $192
c0102f44:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f49:	e9 62 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f4e <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f4e:	6a 00                	push   $0x0
  pushl $193
c0102f50:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f55:	e9 56 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f5a <vector194>:
.globl vector194
vector194:
  pushl $0
c0102f5a:	6a 00                	push   $0x0
  pushl $194
c0102f5c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f61:	e9 4a f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f66 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f66:	6a 00                	push   $0x0
  pushl $195
c0102f68:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f6d:	e9 3e f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f72 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f72:	6a 00                	push   $0x0
  pushl $196
c0102f74:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f79:	e9 32 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f7e <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f7e:	6a 00                	push   $0x0
  pushl $197
c0102f80:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f85:	e9 26 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f8a <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f8a:	6a 00                	push   $0x0
  pushl $198
c0102f8c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f91:	e9 1a f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102f96 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f96:	6a 00                	push   $0x0
  pushl $199
c0102f98:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f9d:	e9 0e f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102fa2 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102fa2:	6a 00                	push   $0x0
  pushl $200
c0102fa4:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102fa9:	e9 02 f8 ff ff       	jmp    c01027b0 <__alltraps>

c0102fae <vector201>:
.globl vector201
vector201:
  pushl $0
c0102fae:	6a 00                	push   $0x0
  pushl $201
c0102fb0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102fb5:	e9 f6 f7 ff ff       	jmp    c01027b0 <__alltraps>

c0102fba <vector202>:
.globl vector202
vector202:
  pushl $0
c0102fba:	6a 00                	push   $0x0
  pushl $202
c0102fbc:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102fc1:	e9 ea f7 ff ff       	jmp    c01027b0 <__alltraps>

c0102fc6 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102fc6:	6a 00                	push   $0x0
  pushl $203
c0102fc8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102fcd:	e9 de f7 ff ff       	jmp    c01027b0 <__alltraps>

c0102fd2 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102fd2:	6a 00                	push   $0x0
  pushl $204
c0102fd4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102fd9:	e9 d2 f7 ff ff       	jmp    c01027b0 <__alltraps>

c0102fde <vector205>:
.globl vector205
vector205:
  pushl $0
c0102fde:	6a 00                	push   $0x0
  pushl $205
c0102fe0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102fe5:	e9 c6 f7 ff ff       	jmp    c01027b0 <__alltraps>

c0102fea <vector206>:
.globl vector206
vector206:
  pushl $0
c0102fea:	6a 00                	push   $0x0
  pushl $206
c0102fec:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102ff1:	e9 ba f7 ff ff       	jmp    c01027b0 <__alltraps>

c0102ff6 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102ff6:	6a 00                	push   $0x0
  pushl $207
c0102ff8:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102ffd:	e9 ae f7 ff ff       	jmp    c01027b0 <__alltraps>

c0103002 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103002:	6a 00                	push   $0x0
  pushl $208
c0103004:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103009:	e9 a2 f7 ff ff       	jmp    c01027b0 <__alltraps>

c010300e <vector209>:
.globl vector209
vector209:
  pushl $0
c010300e:	6a 00                	push   $0x0
  pushl $209
c0103010:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103015:	e9 96 f7 ff ff       	jmp    c01027b0 <__alltraps>

c010301a <vector210>:
.globl vector210
vector210:
  pushl $0
c010301a:	6a 00                	push   $0x0
  pushl $210
c010301c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0103021:	e9 8a f7 ff ff       	jmp    c01027b0 <__alltraps>

c0103026 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103026:	6a 00                	push   $0x0
  pushl $211
c0103028:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010302d:	e9 7e f7 ff ff       	jmp    c01027b0 <__alltraps>

c0103032 <vector212>:
.globl vector212
vector212:
  pushl $0
c0103032:	6a 00                	push   $0x0
  pushl $212
c0103034:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103039:	e9 72 f7 ff ff       	jmp    c01027b0 <__alltraps>

c010303e <vector213>:
.globl vector213
vector213:
  pushl $0
c010303e:	6a 00                	push   $0x0
  pushl $213
c0103040:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103045:	e9 66 f7 ff ff       	jmp    c01027b0 <__alltraps>

c010304a <vector214>:
.globl vector214
vector214:
  pushl $0
c010304a:	6a 00                	push   $0x0
  pushl $214
c010304c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103051:	e9 5a f7 ff ff       	jmp    c01027b0 <__alltraps>

c0103056 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103056:	6a 00                	push   $0x0
  pushl $215
c0103058:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010305d:	e9 4e f7 ff ff       	jmp    c01027b0 <__alltraps>

c0103062 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103062:	6a 00                	push   $0x0
  pushl $216
c0103064:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103069:	e9 42 f7 ff ff       	jmp    c01027b0 <__alltraps>

c010306e <vector217>:
.globl vector217
vector217:
  pushl $0
c010306e:	6a 00                	push   $0x0
  pushl $217
c0103070:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103075:	e9 36 f7 ff ff       	jmp    c01027b0 <__alltraps>

c010307a <vector218>:
.globl vector218
vector218:
  pushl $0
c010307a:	6a 00                	push   $0x0
  pushl $218
c010307c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103081:	e9 2a f7 ff ff       	jmp    c01027b0 <__alltraps>

c0103086 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103086:	6a 00                	push   $0x0
  pushl $219
c0103088:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010308d:	e9 1e f7 ff ff       	jmp    c01027b0 <__alltraps>

c0103092 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103092:	6a 00                	push   $0x0
  pushl $220
c0103094:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103099:	e9 12 f7 ff ff       	jmp    c01027b0 <__alltraps>

c010309e <vector221>:
.globl vector221
vector221:
  pushl $0
c010309e:	6a 00                	push   $0x0
  pushl $221
c01030a0:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01030a5:	e9 06 f7 ff ff       	jmp    c01027b0 <__alltraps>

c01030aa <vector222>:
.globl vector222
vector222:
  pushl $0
c01030aa:	6a 00                	push   $0x0
  pushl $222
c01030ac:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01030b1:	e9 fa f6 ff ff       	jmp    c01027b0 <__alltraps>

c01030b6 <vector223>:
.globl vector223
vector223:
  pushl $0
c01030b6:	6a 00                	push   $0x0
  pushl $223
c01030b8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01030bd:	e9 ee f6 ff ff       	jmp    c01027b0 <__alltraps>

c01030c2 <vector224>:
.globl vector224
vector224:
  pushl $0
c01030c2:	6a 00                	push   $0x0
  pushl $224
c01030c4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01030c9:	e9 e2 f6 ff ff       	jmp    c01027b0 <__alltraps>

c01030ce <vector225>:
.globl vector225
vector225:
  pushl $0
c01030ce:	6a 00                	push   $0x0
  pushl $225
c01030d0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01030d5:	e9 d6 f6 ff ff       	jmp    c01027b0 <__alltraps>

c01030da <vector226>:
.globl vector226
vector226:
  pushl $0
c01030da:	6a 00                	push   $0x0
  pushl $226
c01030dc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01030e1:	e9 ca f6 ff ff       	jmp    c01027b0 <__alltraps>

c01030e6 <vector227>:
.globl vector227
vector227:
  pushl $0
c01030e6:	6a 00                	push   $0x0
  pushl $227
c01030e8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01030ed:	e9 be f6 ff ff       	jmp    c01027b0 <__alltraps>

c01030f2 <vector228>:
.globl vector228
vector228:
  pushl $0
c01030f2:	6a 00                	push   $0x0
  pushl $228
c01030f4:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01030f9:	e9 b2 f6 ff ff       	jmp    c01027b0 <__alltraps>

c01030fe <vector229>:
.globl vector229
vector229:
  pushl $0
c01030fe:	6a 00                	push   $0x0
  pushl $229
c0103100:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103105:	e9 a6 f6 ff ff       	jmp    c01027b0 <__alltraps>

c010310a <vector230>:
.globl vector230
vector230:
  pushl $0
c010310a:	6a 00                	push   $0x0
  pushl $230
c010310c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103111:	e9 9a f6 ff ff       	jmp    c01027b0 <__alltraps>

c0103116 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103116:	6a 00                	push   $0x0
  pushl $231
c0103118:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010311d:	e9 8e f6 ff ff       	jmp    c01027b0 <__alltraps>

c0103122 <vector232>:
.globl vector232
vector232:
  pushl $0
c0103122:	6a 00                	push   $0x0
  pushl $232
c0103124:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103129:	e9 82 f6 ff ff       	jmp    c01027b0 <__alltraps>

c010312e <vector233>:
.globl vector233
vector233:
  pushl $0
c010312e:	6a 00                	push   $0x0
  pushl $233
c0103130:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103135:	e9 76 f6 ff ff       	jmp    c01027b0 <__alltraps>

c010313a <vector234>:
.globl vector234
vector234:
  pushl $0
c010313a:	6a 00                	push   $0x0
  pushl $234
c010313c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103141:	e9 6a f6 ff ff       	jmp    c01027b0 <__alltraps>

c0103146 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103146:	6a 00                	push   $0x0
  pushl $235
c0103148:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010314d:	e9 5e f6 ff ff       	jmp    c01027b0 <__alltraps>

c0103152 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103152:	6a 00                	push   $0x0
  pushl $236
c0103154:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103159:	e9 52 f6 ff ff       	jmp    c01027b0 <__alltraps>

c010315e <vector237>:
.globl vector237
vector237:
  pushl $0
c010315e:	6a 00                	push   $0x0
  pushl $237
c0103160:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103165:	e9 46 f6 ff ff       	jmp    c01027b0 <__alltraps>

c010316a <vector238>:
.globl vector238
vector238:
  pushl $0
c010316a:	6a 00                	push   $0x0
  pushl $238
c010316c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103171:	e9 3a f6 ff ff       	jmp    c01027b0 <__alltraps>

c0103176 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103176:	6a 00                	push   $0x0
  pushl $239
c0103178:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010317d:	e9 2e f6 ff ff       	jmp    c01027b0 <__alltraps>

c0103182 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103182:	6a 00                	push   $0x0
  pushl $240
c0103184:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103189:	e9 22 f6 ff ff       	jmp    c01027b0 <__alltraps>

c010318e <vector241>:
.globl vector241
vector241:
  pushl $0
c010318e:	6a 00                	push   $0x0
  pushl $241
c0103190:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103195:	e9 16 f6 ff ff       	jmp    c01027b0 <__alltraps>

c010319a <vector242>:
.globl vector242
vector242:
  pushl $0
c010319a:	6a 00                	push   $0x0
  pushl $242
c010319c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01031a1:	e9 0a f6 ff ff       	jmp    c01027b0 <__alltraps>

c01031a6 <vector243>:
.globl vector243
vector243:
  pushl $0
c01031a6:	6a 00                	push   $0x0
  pushl $243
c01031a8:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01031ad:	e9 fe f5 ff ff       	jmp    c01027b0 <__alltraps>

c01031b2 <vector244>:
.globl vector244
vector244:
  pushl $0
c01031b2:	6a 00                	push   $0x0
  pushl $244
c01031b4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01031b9:	e9 f2 f5 ff ff       	jmp    c01027b0 <__alltraps>

c01031be <vector245>:
.globl vector245
vector245:
  pushl $0
c01031be:	6a 00                	push   $0x0
  pushl $245
c01031c0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01031c5:	e9 e6 f5 ff ff       	jmp    c01027b0 <__alltraps>

c01031ca <vector246>:
.globl vector246
vector246:
  pushl $0
c01031ca:	6a 00                	push   $0x0
  pushl $246
c01031cc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01031d1:	e9 da f5 ff ff       	jmp    c01027b0 <__alltraps>

c01031d6 <vector247>:
.globl vector247
vector247:
  pushl $0
c01031d6:	6a 00                	push   $0x0
  pushl $247
c01031d8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01031dd:	e9 ce f5 ff ff       	jmp    c01027b0 <__alltraps>

c01031e2 <vector248>:
.globl vector248
vector248:
  pushl $0
c01031e2:	6a 00                	push   $0x0
  pushl $248
c01031e4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01031e9:	e9 c2 f5 ff ff       	jmp    c01027b0 <__alltraps>

c01031ee <vector249>:
.globl vector249
vector249:
  pushl $0
c01031ee:	6a 00                	push   $0x0
  pushl $249
c01031f0:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01031f5:	e9 b6 f5 ff ff       	jmp    c01027b0 <__alltraps>

c01031fa <vector250>:
.globl vector250
vector250:
  pushl $0
c01031fa:	6a 00                	push   $0x0
  pushl $250
c01031fc:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103201:	e9 aa f5 ff ff       	jmp    c01027b0 <__alltraps>

c0103206 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103206:	6a 00                	push   $0x0
  pushl $251
c0103208:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010320d:	e9 9e f5 ff ff       	jmp    c01027b0 <__alltraps>

c0103212 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103212:	6a 00                	push   $0x0
  pushl $252
c0103214:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103219:	e9 92 f5 ff ff       	jmp    c01027b0 <__alltraps>

c010321e <vector253>:
.globl vector253
vector253:
  pushl $0
c010321e:	6a 00                	push   $0x0
  pushl $253
c0103220:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103225:	e9 86 f5 ff ff       	jmp    c01027b0 <__alltraps>

c010322a <vector254>:
.globl vector254
vector254:
  pushl $0
c010322a:	6a 00                	push   $0x0
  pushl $254
c010322c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0103231:	e9 7a f5 ff ff       	jmp    c01027b0 <__alltraps>

c0103236 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103236:	6a 00                	push   $0x0
  pushl $255
c0103238:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010323d:	e9 6e f5 ff ff       	jmp    c01027b0 <__alltraps>

c0103242 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103242:	55                   	push   %ebp
c0103243:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103245:	8b 55 08             	mov    0x8(%ebp),%edx
c0103248:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c010324d:	29 c2                	sub    %eax,%edx
c010324f:	89 d0                	mov    %edx,%eax
c0103251:	c1 f8 05             	sar    $0x5,%eax
}
c0103254:	5d                   	pop    %ebp
c0103255:	c3                   	ret    

c0103256 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103256:	55                   	push   %ebp
c0103257:	89 e5                	mov    %esp,%ebp
c0103259:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010325c:	8b 45 08             	mov    0x8(%ebp),%eax
c010325f:	89 04 24             	mov    %eax,(%esp)
c0103262:	e8 db ff ff ff       	call   c0103242 <page2ppn>
c0103267:	c1 e0 0c             	shl    $0xc,%eax
}
c010326a:	c9                   	leave  
c010326b:	c3                   	ret    

c010326c <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010326c:	55                   	push   %ebp
c010326d:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010326f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103272:	8b 00                	mov    (%eax),%eax
}
c0103274:	5d                   	pop    %ebp
c0103275:	c3                   	ret    

c0103276 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103276:	55                   	push   %ebp
c0103277:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103279:	8b 45 08             	mov    0x8(%ebp),%eax
c010327c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010327f:	89 10                	mov    %edx,(%eax)
}
c0103281:	5d                   	pop    %ebp
c0103282:	c3                   	ret    

c0103283 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103283:	55                   	push   %ebp
c0103284:	89 e5                	mov    %esp,%ebp
c0103286:	83 ec 10             	sub    $0x10,%esp
c0103289:	c7 45 fc c0 1a 12 c0 	movl   $0xc0121ac0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103290:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103293:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103296:	89 50 04             	mov    %edx,0x4(%eax)
c0103299:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010329c:	8b 50 04             	mov    0x4(%eax),%edx
c010329f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032a2:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01032a4:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c01032ab:	00 00 00 
}
c01032ae:	c9                   	leave  
c01032af:	c3                   	ret    

c01032b0 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01032b0:	55                   	push   %ebp
c01032b1:	89 e5                	mov    %esp,%ebp
c01032b3:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01032b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01032ba:	75 24                	jne    c01032e0 <default_init_memmap+0x30>
c01032bc:	c7 44 24 0c 90 94 10 	movl   $0xc0109490,0xc(%esp)
c01032c3:	c0 
c01032c4:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01032cb:	c0 
c01032cc:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01032d3:	00 
c01032d4:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01032db:	e8 fc d9 ff ff       	call   c0100cdc <__panic>
    struct Page *p = base;
c01032e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01032e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01032e6:	eb 7d                	jmp    c0103365 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032eb:	83 c0 04             	add    $0x4,%eax
c01032ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01032f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01032fe:	0f a3 10             	bt     %edx,(%eax)
c0103301:	19 c0                	sbb    %eax,%eax
c0103303:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103306:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010330a:	0f 95 c0             	setne  %al
c010330d:	0f b6 c0             	movzbl %al,%eax
c0103310:	85 c0                	test   %eax,%eax
c0103312:	75 24                	jne    c0103338 <default_init_memmap+0x88>
c0103314:	c7 44 24 0c c1 94 10 	movl   $0xc01094c1,0xc(%esp)
c010331b:	c0 
c010331c:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103323:	c0 
c0103324:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c010332b:	00 
c010332c:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103333:	e8 a4 d9 ff ff       	call   c0100cdc <__panic>
        p->flags = p->property = 0;
c0103338:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010333b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0103342:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103345:	8b 50 08             	mov    0x8(%eax),%edx
c0103348:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010334b:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010334e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103355:	00 
c0103356:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103359:	89 04 24             	mov    %eax,(%esp)
c010335c:	e8 15 ff ff ff       	call   c0103276 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103361:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103365:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103368:	c1 e0 05             	shl    $0x5,%eax
c010336b:	89 c2                	mov    %eax,%edx
c010336d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103370:	01 d0                	add    %edx,%eax
c0103372:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103375:	0f 85 6d ff ff ff    	jne    c01032e8 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c010337b:	8b 45 08             	mov    0x8(%ebp),%eax
c010337e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103381:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103384:	8b 45 08             	mov    0x8(%ebp),%eax
c0103387:	83 c0 04             	add    $0x4,%eax
c010338a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103391:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103394:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103397:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010339a:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c010339d:	8b 15 c8 1a 12 c0    	mov    0xc0121ac8,%edx
c01033a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033a6:	01 d0                	add    %edx,%eax
c01033a8:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
    list_add(&free_list, &(base->page_link));
c01033ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01033b0:	83 c0 0c             	add    $0xc,%eax
c01033b3:	c7 45 dc c0 1a 12 c0 	movl   $0xc0121ac0,-0x24(%ebp)
c01033ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01033bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01033c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01033c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01033c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033cc:	8b 40 04             	mov    0x4(%eax),%eax
c01033cf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033d2:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01033d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033d8:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01033db:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01033de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033e1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01033e4:	89 10                	mov    %edx,(%eax)
c01033e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033e9:	8b 10                	mov    (%eax),%edx
c01033eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01033ee:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01033f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033f4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01033f7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01033fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033fd:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103400:	89 10                	mov    %edx,(%eax)
}
c0103402:	c9                   	leave  
c0103403:	c3                   	ret    

c0103404 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103404:	55                   	push   %ebp
c0103405:	89 e5                	mov    %esp,%ebp
c0103407:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010340a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010340e:	75 24                	jne    c0103434 <default_alloc_pages+0x30>
c0103410:	c7 44 24 0c 90 94 10 	movl   $0xc0109490,0xc(%esp)
c0103417:	c0 
c0103418:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c010341f:	c0 
c0103420:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0103427:	00 
c0103428:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c010342f:	e8 a8 d8 ff ff       	call   c0100cdc <__panic>
    if (n > nr_free) {
c0103434:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103439:	3b 45 08             	cmp    0x8(%ebp),%eax
c010343c:	73 0a                	jae    c0103448 <default_alloc_pages+0x44>
        return NULL;
c010343e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103443:	e9 3b 01 00 00       	jmp    c0103583 <default_alloc_pages+0x17f>
    }
    struct Page* page = NULL;
c0103448:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t* le = &free_list;
c010344f:	c7 45 f0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103456:	eb 1c                	jmp    c0103474 <default_alloc_pages+0x70>
        struct Page* p = le2page(le, page_link);
c0103458:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010345b:	83 e8 0c             	sub    $0xc,%eax
c010345e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0103461:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103464:	8b 40 08             	mov    0x8(%eax),%eax
c0103467:	3b 45 08             	cmp    0x8(%ebp),%eax
c010346a:	72 08                	jb     c0103474 <default_alloc_pages+0x70>
            page = p;
c010346c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010346f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0103472:	eb 18                	jmp    c010348c <default_alloc_pages+0x88>
c0103474:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103477:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010347a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010347d:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page* page = NULL;
    list_entry_t* le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103480:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103483:	81 7d f0 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x10(%ebp)
c010348a:	75 cc                	jne    c0103458 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL)	{
c010348c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103490:	0f 84 ea 00 00 00    	je     c0103580 <default_alloc_pages+0x17c>
    	if (page->property > n)	{
c0103496:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103499:	8b 40 08             	mov    0x8(%eax),%eax
c010349c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010349f:	0f 86 81 00 00 00    	jbe    c0103526 <default_alloc_pages+0x122>
            struct Page* p = page + n;
c01034a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01034a8:	c1 e0 05             	shl    $0x5,%eax
c01034ab:	89 c2                	mov    %eax,%edx
c01034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034b0:	01 d0                	add    %edx,%eax
c01034b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c01034b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034b8:	8b 40 08             	mov    0x8(%eax),%eax
c01034bb:	2b 45 08             	sub    0x8(%ebp),%eax
c01034be:	89 c2                	mov    %eax,%edx
c01034c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034c3:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c01034c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034c9:	83 c0 04             	add    $0x4,%eax
c01034cc:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01034d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01034d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01034dc:	0f ab 10             	bts    %edx,(%eax)
            list_add_before(le, &(p->page_link));
c01034df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034e2:	8d 50 0c             	lea    0xc(%eax),%edx
c01034e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01034eb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01034ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034f1:	8b 00                	mov    (%eax),%eax
c01034f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01034f6:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01034f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01034fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034ff:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103502:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103505:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103508:	89 10                	mov    %edx,(%eax)
c010350a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010350d:	8b 10                	mov    (%eax),%edx
c010350f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103512:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103515:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103518:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010351b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010351e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103521:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103524:	89 10                	mov    %edx,(%eax)
    	}
    	list_del(&(page->page_link));
c0103526:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103529:	83 c0 0c             	add    $0xc,%eax
c010352c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010352f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103532:	8b 40 04             	mov    0x4(%eax),%eax
c0103535:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103538:	8b 12                	mov    (%edx),%edx
c010353a:	89 55 c0             	mov    %edx,-0x40(%ebp)
c010353d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103540:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103543:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103546:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103549:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010354c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010354f:	89 10                	mov    %edx,(%eax)
    	page->property= n;
c0103551:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103554:	8b 55 08             	mov    0x8(%ebp),%edx
c0103557:	89 50 08             	mov    %edx,0x8(%eax)
        nr_free -= n;
c010355a:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c010355f:	2b 45 08             	sub    0x8(%ebp),%eax
c0103562:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
        ClearPageProperty(page);
c0103567:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010356a:	83 c0 04             	add    $0x4,%eax
c010356d:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0103574:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103577:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010357a:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010357d:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0103580:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103583:	c9                   	leave  
c0103584:	c3                   	ret    

c0103585 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103585:	55                   	push   %ebp
c0103586:	89 e5                	mov    %esp,%ebp
c0103588:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c010358e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103592:	75 24                	jne    c01035b8 <default_free_pages+0x33>
c0103594:	c7 44 24 0c 90 94 10 	movl   $0xc0109490,0xc(%esp)
c010359b:	c0 
c010359c:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01035a3:	c0 
c01035a4:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
c01035ab:	00 
c01035ac:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01035b3:	e8 24 d7 ff ff       	call   c0100cdc <__panic>
    struct Page* p = base;
c01035b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01035bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01035be:	e9 9d 00 00 00       	jmp    c0103660 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c01035c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c6:	83 c0 04             	add    $0x4,%eax
c01035c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01035d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01035d9:	0f a3 10             	bt     %edx,(%eax)
c01035dc:	19 c0                	sbb    %eax,%eax
c01035de:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c01035e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01035e5:	0f 95 c0             	setne  %al
c01035e8:	0f b6 c0             	movzbl %al,%eax
c01035eb:	85 c0                	test   %eax,%eax
c01035ed:	75 2c                	jne    c010361b <default_free_pages+0x96>
c01035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f2:	83 c0 04             	add    $0x4,%eax
c01035f5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c01035fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103602:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103605:	0f a3 10             	bt     %edx,(%eax)
c0103608:	19 c0                	sbb    %eax,%eax
c010360a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c010360d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103611:	0f 95 c0             	setne  %al
c0103614:	0f b6 c0             	movzbl %al,%eax
c0103617:	85 c0                	test   %eax,%eax
c0103619:	74 24                	je     c010363f <default_free_pages+0xba>
c010361b:	c7 44 24 0c d4 94 10 	movl   $0xc01094d4,0xc(%esp)
c0103622:	c0 
c0103623:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c010362a:	c0 
c010362b:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c0103632:	00 
c0103633:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c010363a:	e8 9d d6 ff ff       	call   c0100cdc <__panic>
        p->flags = 0;
c010363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103642:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0103649:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103650:	00 
c0103651:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103654:	89 04 24             	mov    %eax,(%esp)
c0103657:	e8 1a fc ff ff       	call   c0103276 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page* p = base;
    for (; p != base + n; p ++) {
c010365c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103660:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103663:	c1 e0 05             	shl    $0x5,%eax
c0103666:	89 c2                	mov    %eax,%edx
c0103668:	8b 45 08             	mov    0x8(%ebp),%eax
c010366b:	01 d0                	add    %edx,%eax
c010366d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103670:	0f 85 4d ff ff ff    	jne    c01035c3 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property= n;
c0103676:	8b 45 08             	mov    0x8(%ebp),%eax
c0103679:	8b 55 0c             	mov    0xc(%ebp),%edx
c010367c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010367f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103682:	83 c0 04             	add    $0x4,%eax
c0103685:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010368c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010368f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103692:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103695:	0f ab 10             	bts    %edx,(%eax)
c0103698:	c7 45 c8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010369f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01036a2:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t* le = list_next(&free_list);
c01036a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list)	{
c01036a8:	eb 22                	jmp    c01036cc <default_free_pages+0x147>
    	p = le2page(le, page_link);
c01036aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036ad:	83 e8 0c             	sub    $0xc,%eax
c01036b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if (p > base)
c01036b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036b6:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036b9:	76 02                	jbe    c01036bd <default_free_pages+0x138>
    		break ;
c01036bb:	eb 18                	jmp    c01036d5 <default_free_pages+0x150>
c01036bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036c0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01036c3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01036c6:	8b 40 04             	mov    0x4(%eax),%eax
    	le = list_next(le);
c01036c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        set_page_ref(p, 0);
    }
    base->property= n;
    SetPageProperty(base);
    list_entry_t* le = list_next(&free_list);
    while (le != &free_list)	{
c01036cc:	81 7d f0 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x10(%ebp)
c01036d3:	75 d5                	jne    c01036aa <default_free_pages+0x125>
    	if (p > base)
    		break ;
    	le = list_next(le);
    }

    p = le2page(le, page_link);
c01036d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036d8:	83 e8 0c             	sub    $0xc,%eax
c01036db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	list_add_before(le, &(base->page_link));
c01036de:	8b 45 08             	mov    0x8(%ebp),%eax
c01036e1:	8d 50 0c             	lea    0xc(%eax),%edx
c01036e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01036ea:	89 55 bc             	mov    %edx,-0x44(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01036ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01036f0:	8b 00                	mov    (%eax),%eax
c01036f2:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01036f5:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01036f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01036fb:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01036fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103701:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103704:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103707:	89 10                	mov    %edx,(%eax)
c0103709:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010370c:	8b 10                	mov    (%eax),%edx
c010370e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103711:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103714:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103717:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010371a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010371d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103720:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103723:	89 10                	mov    %edx,(%eax)
	le = list_prev(&(base->page_link));
c0103725:	8b 45 08             	mov    0x8(%ebp),%eax
c0103728:	83 c0 0c             	add    $0xc,%eax
c010372b:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010372e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103731:	8b 00                	mov    (%eax),%eax
c0103733:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct Page* pp = le2page(le, page_link);
c0103736:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103739:	83 e8 0c             	sub    $0xc,%eax
c010373c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (base + base->property == p) {
c010373f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103742:	8b 40 08             	mov    0x8(%eax),%eax
c0103745:	c1 e0 05             	shl    $0x5,%eax
c0103748:	89 c2                	mov    %eax,%edx
c010374a:	8b 45 08             	mov    0x8(%ebp),%eax
c010374d:	01 d0                	add    %edx,%eax
c010374f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103752:	75 58                	jne    c01037ac <default_free_pages+0x227>
		base->property += p->property;
c0103754:	8b 45 08             	mov    0x8(%ebp),%eax
c0103757:	8b 50 08             	mov    0x8(%eax),%edx
c010375a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010375d:	8b 40 08             	mov    0x8(%eax),%eax
c0103760:	01 c2                	add    %eax,%edx
c0103762:	8b 45 08             	mov    0x8(%ebp),%eax
c0103765:	89 50 08             	mov    %edx,0x8(%eax)
		ClearPageProperty(p);
c0103768:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010376b:	83 c0 04             	add    $0x4,%eax
c010376e:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
c0103775:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103778:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010377b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010377e:	0f b3 10             	btr    %edx,(%eax)
		list_del(&(p->page_link));
c0103781:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103784:	83 c0 0c             	add    $0xc,%eax
c0103787:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010378a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010378d:	8b 40 04             	mov    0x4(%eax),%eax
c0103790:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103793:	8b 12                	mov    (%edx),%edx
c0103795:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0103798:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010379b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010379e:	8b 55 98             	mov    -0x68(%ebp),%edx
c01037a1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01037a4:	8b 45 98             	mov    -0x68(%ebp),%eax
c01037a7:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01037aa:	89 10                	mov    %edx,(%eax)
	}
	if (pp + pp->property == base) {
c01037ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037af:	8b 40 08             	mov    0x8(%eax),%eax
c01037b2:	c1 e0 05             	shl    $0x5,%eax
c01037b5:	89 c2                	mov    %eax,%edx
c01037b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ba:	01 d0                	add    %edx,%eax
c01037bc:	3b 45 08             	cmp    0x8(%ebp),%eax
c01037bf:	75 58                	jne    c0103819 <default_free_pages+0x294>
		pp->property += base->property;
c01037c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037c4:	8b 50 08             	mov    0x8(%eax),%edx
c01037c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01037ca:	8b 40 08             	mov    0x8(%eax),%eax
c01037cd:	01 c2                	add    %eax,%edx
c01037cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037d2:	89 50 08             	mov    %edx,0x8(%eax)
		ClearPageProperty(base);
c01037d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01037d8:	83 c0 04             	add    $0x4,%eax
c01037db:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01037e2:	89 45 90             	mov    %eax,-0x70(%ebp)
c01037e5:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037e8:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01037eb:	0f b3 10             	btr    %edx,(%eax)
		list_del(&(base->page_link));
c01037ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01037f1:	83 c0 0c             	add    $0xc,%eax
c01037f4:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01037f7:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01037fa:	8b 40 04             	mov    0x4(%eax),%eax
c01037fd:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103800:	8b 12                	mov    (%edx),%edx
c0103802:	89 55 88             	mov    %edx,-0x78(%ebp)
c0103805:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103808:	8b 45 88             	mov    -0x78(%ebp),%eax
c010380b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010380e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103811:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103814:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103817:	89 10                	mov    %edx,(%eax)
	}

	nr_free += n;
c0103819:	8b 15 c8 1a 12 c0    	mov    0xc0121ac8,%edx
c010381f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103822:	01 d0                	add    %edx,%eax
c0103824:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
}
c0103829:	c9                   	leave  
c010382a:	c3                   	ret    

c010382b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010382b:	55                   	push   %ebp
c010382c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010382e:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
}
c0103833:	5d                   	pop    %ebp
c0103834:	c3                   	ret    

c0103835 <basic_check>:

static void
basic_check(void) {
c0103835:	55                   	push   %ebp
c0103836:	89 e5                	mov    %esp,%ebp
c0103838:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010383b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103842:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103845:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103848:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010384b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010384e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103855:	e8 bf 0e 00 00       	call   c0104719 <alloc_pages>
c010385a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010385d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103861:	75 24                	jne    c0103887 <basic_check+0x52>
c0103863:	c7 44 24 0c f9 94 10 	movl   $0xc01094f9,0xc(%esp)
c010386a:	c0 
c010386b:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103872:	c0 
c0103873:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c010387a:	00 
c010387b:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103882:	e8 55 d4 ff ff       	call   c0100cdc <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103887:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010388e:	e8 86 0e 00 00       	call   c0104719 <alloc_pages>
c0103893:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103896:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010389a:	75 24                	jne    c01038c0 <basic_check+0x8b>
c010389c:	c7 44 24 0c 15 95 10 	movl   $0xc0109515,0xc(%esp)
c01038a3:	c0 
c01038a4:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01038ab:	c0 
c01038ac:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c01038b3:	00 
c01038b4:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01038bb:	e8 1c d4 ff ff       	call   c0100cdc <__panic>
    assert((p2 = alloc_page()) != NULL);
c01038c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038c7:	e8 4d 0e 00 00       	call   c0104719 <alloc_pages>
c01038cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01038cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01038d3:	75 24                	jne    c01038f9 <basic_check+0xc4>
c01038d5:	c7 44 24 0c 31 95 10 	movl   $0xc0109531,0xc(%esp)
c01038dc:	c0 
c01038dd:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01038e4:	c0 
c01038e5:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c01038ec:	00 
c01038ed:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01038f4:	e8 e3 d3 ff ff       	call   c0100cdc <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01038f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01038ff:	74 10                	je     c0103911 <basic_check+0xdc>
c0103901:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103904:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103907:	74 08                	je     c0103911 <basic_check+0xdc>
c0103909:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010390c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010390f:	75 24                	jne    c0103935 <basic_check+0x100>
c0103911:	c7 44 24 0c 50 95 10 	movl   $0xc0109550,0xc(%esp)
c0103918:	c0 
c0103919:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103920:	c0 
c0103921:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c0103928:	00 
c0103929:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103930:	e8 a7 d3 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103935:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103938:	89 04 24             	mov    %eax,(%esp)
c010393b:	e8 2c f9 ff ff       	call   c010326c <page_ref>
c0103940:	85 c0                	test   %eax,%eax
c0103942:	75 1e                	jne    c0103962 <basic_check+0x12d>
c0103944:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103947:	89 04 24             	mov    %eax,(%esp)
c010394a:	e8 1d f9 ff ff       	call   c010326c <page_ref>
c010394f:	85 c0                	test   %eax,%eax
c0103951:	75 0f                	jne    c0103962 <basic_check+0x12d>
c0103953:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103956:	89 04 24             	mov    %eax,(%esp)
c0103959:	e8 0e f9 ff ff       	call   c010326c <page_ref>
c010395e:	85 c0                	test   %eax,%eax
c0103960:	74 24                	je     c0103986 <basic_check+0x151>
c0103962:	c7 44 24 0c 74 95 10 	movl   $0xc0109574,0xc(%esp)
c0103969:	c0 
c010396a:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103971:	c0 
c0103972:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0103979:	00 
c010397a:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103981:	e8 56 d3 ff ff       	call   c0100cdc <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103986:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103989:	89 04 24             	mov    %eax,(%esp)
c010398c:	e8 c5 f8 ff ff       	call   c0103256 <page2pa>
c0103991:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103997:	c1 e2 0c             	shl    $0xc,%edx
c010399a:	39 d0                	cmp    %edx,%eax
c010399c:	72 24                	jb     c01039c2 <basic_check+0x18d>
c010399e:	c7 44 24 0c b0 95 10 	movl   $0xc01095b0,0xc(%esp)
c01039a5:	c0 
c01039a6:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01039ad:	c0 
c01039ae:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c01039b5:	00 
c01039b6:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01039bd:	e8 1a d3 ff ff       	call   c0100cdc <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01039c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039c5:	89 04 24             	mov    %eax,(%esp)
c01039c8:	e8 89 f8 ff ff       	call   c0103256 <page2pa>
c01039cd:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c01039d3:	c1 e2 0c             	shl    $0xc,%edx
c01039d6:	39 d0                	cmp    %edx,%eax
c01039d8:	72 24                	jb     c01039fe <basic_check+0x1c9>
c01039da:	c7 44 24 0c cd 95 10 	movl   $0xc01095cd,0xc(%esp)
c01039e1:	c0 
c01039e2:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01039e9:	c0 
c01039ea:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c01039f1:	00 
c01039f2:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01039f9:	e8 de d2 ff ff       	call   c0100cdc <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01039fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a01:	89 04 24             	mov    %eax,(%esp)
c0103a04:	e8 4d f8 ff ff       	call   c0103256 <page2pa>
c0103a09:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103a0f:	c1 e2 0c             	shl    $0xc,%edx
c0103a12:	39 d0                	cmp    %edx,%eax
c0103a14:	72 24                	jb     c0103a3a <basic_check+0x205>
c0103a16:	c7 44 24 0c ea 95 10 	movl   $0xc01095ea,0xc(%esp)
c0103a1d:	c0 
c0103a1e:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103a25:	c0 
c0103a26:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0103a2d:	00 
c0103a2e:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103a35:	e8 a2 d2 ff ff       	call   c0100cdc <__panic>

    list_entry_t free_list_store = free_list;
c0103a3a:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0103a3f:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0103a45:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103a48:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103a4b:	c7 45 e0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a55:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a58:	89 50 04             	mov    %edx,0x4(%eax)
c0103a5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a5e:	8b 50 04             	mov    0x4(%eax),%edx
c0103a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a64:	89 10                	mov    %edx,(%eax)
c0103a66:	c7 45 dc c0 1a 12 c0 	movl   $0xc0121ac0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103a6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a70:	8b 40 04             	mov    0x4(%eax),%eax
c0103a73:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103a76:	0f 94 c0             	sete   %al
c0103a79:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103a7c:	85 c0                	test   %eax,%eax
c0103a7e:	75 24                	jne    c0103aa4 <basic_check+0x26f>
c0103a80:	c7 44 24 0c 07 96 10 	movl   $0xc0109607,0xc(%esp)
c0103a87:	c0 
c0103a88:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103a8f:	c0 
c0103a90:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0103a97:	00 
c0103a98:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103a9f:	e8 38 d2 ff ff       	call   c0100cdc <__panic>

    unsigned int nr_free_store = nr_free;
c0103aa4:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103aa9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103aac:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0103ab3:	00 00 00 

    assert(alloc_page() == NULL);
c0103ab6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103abd:	e8 57 0c 00 00       	call   c0104719 <alloc_pages>
c0103ac2:	85 c0                	test   %eax,%eax
c0103ac4:	74 24                	je     c0103aea <basic_check+0x2b5>
c0103ac6:	c7 44 24 0c 1e 96 10 	movl   $0xc010961e,0xc(%esp)
c0103acd:	c0 
c0103ace:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103ad5:	c0 
c0103ad6:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103add:	00 
c0103ade:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103ae5:	e8 f2 d1 ff ff       	call   c0100cdc <__panic>

    free_page(p0);
c0103aea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103af1:	00 
c0103af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103af5:	89 04 24             	mov    %eax,(%esp)
c0103af8:	e8 87 0c 00 00       	call   c0104784 <free_pages>
    free_page(p1);
c0103afd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b04:	00 
c0103b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b08:	89 04 24             	mov    %eax,(%esp)
c0103b0b:	e8 74 0c 00 00       	call   c0104784 <free_pages>
    free_page(p2);
c0103b10:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b17:	00 
c0103b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b1b:	89 04 24             	mov    %eax,(%esp)
c0103b1e:	e8 61 0c 00 00       	call   c0104784 <free_pages>
    assert(nr_free == 3);
c0103b23:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103b28:	83 f8 03             	cmp    $0x3,%eax
c0103b2b:	74 24                	je     c0103b51 <basic_check+0x31c>
c0103b2d:	c7 44 24 0c 33 96 10 	movl   $0xc0109633,0xc(%esp)
c0103b34:	c0 
c0103b35:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103b3c:	c0 
c0103b3d:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0103b44:	00 
c0103b45:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103b4c:	e8 8b d1 ff ff       	call   c0100cdc <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103b51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b58:	e8 bc 0b 00 00       	call   c0104719 <alloc_pages>
c0103b5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103b64:	75 24                	jne    c0103b8a <basic_check+0x355>
c0103b66:	c7 44 24 0c f9 94 10 	movl   $0xc01094f9,0xc(%esp)
c0103b6d:	c0 
c0103b6e:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103b75:	c0 
c0103b76:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103b7d:	00 
c0103b7e:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103b85:	e8 52 d1 ff ff       	call   c0100cdc <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103b8a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b91:	e8 83 0b 00 00       	call   c0104719 <alloc_pages>
c0103b96:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b9d:	75 24                	jne    c0103bc3 <basic_check+0x38e>
c0103b9f:	c7 44 24 0c 15 95 10 	movl   $0xc0109515,0xc(%esp)
c0103ba6:	c0 
c0103ba7:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103bae:	c0 
c0103baf:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103bb6:	00 
c0103bb7:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103bbe:	e8 19 d1 ff ff       	call   c0100cdc <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103bc3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bca:	e8 4a 0b 00 00       	call   c0104719 <alloc_pages>
c0103bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103bd6:	75 24                	jne    c0103bfc <basic_check+0x3c7>
c0103bd8:	c7 44 24 0c 31 95 10 	movl   $0xc0109531,0xc(%esp)
c0103bdf:	c0 
c0103be0:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103be7:	c0 
c0103be8:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103bef:	00 
c0103bf0:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103bf7:	e8 e0 d0 ff ff       	call   c0100cdc <__panic>

    assert(alloc_page() == NULL);
c0103bfc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c03:	e8 11 0b 00 00       	call   c0104719 <alloc_pages>
c0103c08:	85 c0                	test   %eax,%eax
c0103c0a:	74 24                	je     c0103c30 <basic_check+0x3fb>
c0103c0c:	c7 44 24 0c 1e 96 10 	movl   $0xc010961e,0xc(%esp)
c0103c13:	c0 
c0103c14:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103c1b:	c0 
c0103c1c:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0103c23:	00 
c0103c24:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103c2b:	e8 ac d0 ff ff       	call   c0100cdc <__panic>

    free_page(p0);
c0103c30:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c37:	00 
c0103c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c3b:	89 04 24             	mov    %eax,(%esp)
c0103c3e:	e8 41 0b 00 00       	call   c0104784 <free_pages>
c0103c43:	c7 45 d8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x28(%ebp)
c0103c4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c4d:	8b 40 04             	mov    0x4(%eax),%eax
c0103c50:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103c53:	0f 94 c0             	sete   %al
c0103c56:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103c59:	85 c0                	test   %eax,%eax
c0103c5b:	74 24                	je     c0103c81 <basic_check+0x44c>
c0103c5d:	c7 44 24 0c 40 96 10 	movl   $0xc0109640,0xc(%esp)
c0103c64:	c0 
c0103c65:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103c6c:	c0 
c0103c6d:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103c74:	00 
c0103c75:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103c7c:	e8 5b d0 ff ff       	call   c0100cdc <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103c81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c88:	e8 8c 0a 00 00       	call   c0104719 <alloc_pages>
c0103c8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c93:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103c96:	74 24                	je     c0103cbc <basic_check+0x487>
c0103c98:	c7 44 24 0c 58 96 10 	movl   $0xc0109658,0xc(%esp)
c0103c9f:	c0 
c0103ca0:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103ca7:	c0 
c0103ca8:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0103caf:	00 
c0103cb0:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103cb7:	e8 20 d0 ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c0103cbc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cc3:	e8 51 0a 00 00       	call   c0104719 <alloc_pages>
c0103cc8:	85 c0                	test   %eax,%eax
c0103cca:	74 24                	je     c0103cf0 <basic_check+0x4bb>
c0103ccc:	c7 44 24 0c 1e 96 10 	movl   $0xc010961e,0xc(%esp)
c0103cd3:	c0 
c0103cd4:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103cdb:	c0 
c0103cdc:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103ce3:	00 
c0103ce4:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103ceb:	e8 ec cf ff ff       	call   c0100cdc <__panic>

    assert(nr_free == 0);
c0103cf0:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103cf5:	85 c0                	test   %eax,%eax
c0103cf7:	74 24                	je     c0103d1d <basic_check+0x4e8>
c0103cf9:	c7 44 24 0c 71 96 10 	movl   $0xc0109671,0xc(%esp)
c0103d00:	c0 
c0103d01:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103d08:	c0 
c0103d09:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0103d10:	00 
c0103d11:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103d18:	e8 bf cf ff ff       	call   c0100cdc <__panic>
    free_list = free_list_store;
c0103d1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d20:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d23:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0103d28:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4
    nr_free = nr_free_store;
c0103d2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d31:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8

    free_page(p);
c0103d36:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d3d:	00 
c0103d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d41:	89 04 24             	mov    %eax,(%esp)
c0103d44:	e8 3b 0a 00 00       	call   c0104784 <free_pages>
    free_page(p1);
c0103d49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d50:	00 
c0103d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d54:	89 04 24             	mov    %eax,(%esp)
c0103d57:	e8 28 0a 00 00       	call   c0104784 <free_pages>
    free_page(p2);
c0103d5c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d63:	00 
c0103d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d67:	89 04 24             	mov    %eax,(%esp)
c0103d6a:	e8 15 0a 00 00       	call   c0104784 <free_pages>
}
c0103d6f:	c9                   	leave  
c0103d70:	c3                   	ret    

c0103d71 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103d71:	55                   	push   %ebp
c0103d72:	89 e5                	mov    %esp,%ebp
c0103d74:	53                   	push   %ebx
c0103d75:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103d7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103d82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103d89:	c7 45 ec c0 1a 12 c0 	movl   $0xc0121ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103d90:	eb 6b                	jmp    c0103dfd <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d95:	83 e8 0c             	sub    $0xc,%eax
c0103d98:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103d9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d9e:	83 c0 04             	add    $0x4,%eax
c0103da1:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103da8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103dab:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103dae:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103db1:	0f a3 10             	bt     %edx,(%eax)
c0103db4:	19 c0                	sbb    %eax,%eax
c0103db6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103db9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103dbd:	0f 95 c0             	setne  %al
c0103dc0:	0f b6 c0             	movzbl %al,%eax
c0103dc3:	85 c0                	test   %eax,%eax
c0103dc5:	75 24                	jne    c0103deb <default_check+0x7a>
c0103dc7:	c7 44 24 0c 7e 96 10 	movl   $0xc010967e,0xc(%esp)
c0103dce:	c0 
c0103dcf:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103dd6:	c0 
c0103dd7:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103dde:	00 
c0103ddf:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103de6:	e8 f1 ce ff ff       	call   c0100cdc <__panic>
        count ++, total += p->property;
c0103deb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103def:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103df2:	8b 50 08             	mov    0x8(%eax),%edx
c0103df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103df8:	01 d0                	add    %edx,%eax
c0103dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e00:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103e03:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e06:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103e09:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103e0c:	81 7d ec c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x14(%ebp)
c0103e13:	0f 85 79 ff ff ff    	jne    c0103d92 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103e19:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103e1c:	e8 95 09 00 00       	call   c01047b6 <nr_free_pages>
c0103e21:	39 c3                	cmp    %eax,%ebx
c0103e23:	74 24                	je     c0103e49 <default_check+0xd8>
c0103e25:	c7 44 24 0c 8e 96 10 	movl   $0xc010968e,0xc(%esp)
c0103e2c:	c0 
c0103e2d:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103e34:	c0 
c0103e35:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0103e3c:	00 
c0103e3d:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103e44:	e8 93 ce ff ff       	call   c0100cdc <__panic>

    basic_check();
c0103e49:	e8 e7 f9 ff ff       	call   c0103835 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103e4e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103e55:	e8 bf 08 00 00       	call   c0104719 <alloc_pages>
c0103e5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103e5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e61:	75 24                	jne    c0103e87 <default_check+0x116>
c0103e63:	c7 44 24 0c a7 96 10 	movl   $0xc01096a7,0xc(%esp)
c0103e6a:	c0 
c0103e6b:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103e72:	c0 
c0103e73:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0103e7a:	00 
c0103e7b:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103e82:	e8 55 ce ff ff       	call   c0100cdc <__panic>
    assert(!PageProperty(p0));
c0103e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e8a:	83 c0 04             	add    $0x4,%eax
c0103e8d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103e94:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e97:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103e9a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103e9d:	0f a3 10             	bt     %edx,(%eax)
c0103ea0:	19 c0                	sbb    %eax,%eax
c0103ea2:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103ea5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103ea9:	0f 95 c0             	setne  %al
c0103eac:	0f b6 c0             	movzbl %al,%eax
c0103eaf:	85 c0                	test   %eax,%eax
c0103eb1:	74 24                	je     c0103ed7 <default_check+0x166>
c0103eb3:	c7 44 24 0c b2 96 10 	movl   $0xc01096b2,0xc(%esp)
c0103eba:	c0 
c0103ebb:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103ec2:	c0 
c0103ec3:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0103eca:	00 
c0103ecb:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103ed2:	e8 05 ce ff ff       	call   c0100cdc <__panic>

    list_entry_t free_list_store = free_list;
c0103ed7:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0103edc:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0103ee2:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103ee5:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103ee8:	c7 45 b4 c0 1a 12 c0 	movl   $0xc0121ac0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103eef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103ef2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ef5:	89 50 04             	mov    %edx,0x4(%eax)
c0103ef8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103efb:	8b 50 04             	mov    0x4(%eax),%edx
c0103efe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f01:	89 10                	mov    %edx,(%eax)
c0103f03:	c7 45 b0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103f0a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f0d:	8b 40 04             	mov    0x4(%eax),%eax
c0103f10:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103f13:	0f 94 c0             	sete   %al
c0103f16:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103f19:	85 c0                	test   %eax,%eax
c0103f1b:	75 24                	jne    c0103f41 <default_check+0x1d0>
c0103f1d:	c7 44 24 0c 07 96 10 	movl   $0xc0109607,0xc(%esp)
c0103f24:	c0 
c0103f25:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103f2c:	c0 
c0103f2d:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103f34:	00 
c0103f35:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103f3c:	e8 9b cd ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c0103f41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f48:	e8 cc 07 00 00       	call   c0104719 <alloc_pages>
c0103f4d:	85 c0                	test   %eax,%eax
c0103f4f:	74 24                	je     c0103f75 <default_check+0x204>
c0103f51:	c7 44 24 0c 1e 96 10 	movl   $0xc010961e,0xc(%esp)
c0103f58:	c0 
c0103f59:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103f60:	c0 
c0103f61:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103f68:	00 
c0103f69:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103f70:	e8 67 cd ff ff       	call   c0100cdc <__panic>

    unsigned int nr_free_store = nr_free;
c0103f75:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103f7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103f7d:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0103f84:	00 00 00 

    free_pages(p0 + 2, 3);
c0103f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f8a:	83 c0 40             	add    $0x40,%eax
c0103f8d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103f94:	00 
c0103f95:	89 04 24             	mov    %eax,(%esp)
c0103f98:	e8 e7 07 00 00       	call   c0104784 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103f9d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103fa4:	e8 70 07 00 00       	call   c0104719 <alloc_pages>
c0103fa9:	85 c0                	test   %eax,%eax
c0103fab:	74 24                	je     c0103fd1 <default_check+0x260>
c0103fad:	c7 44 24 0c c4 96 10 	movl   $0xc01096c4,0xc(%esp)
c0103fb4:	c0 
c0103fb5:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0103fbc:	c0 
c0103fbd:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103fc4:	00 
c0103fc5:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0103fcc:	e8 0b cd ff ff       	call   c0100cdc <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fd4:	83 c0 40             	add    $0x40,%eax
c0103fd7:	83 c0 04             	add    $0x4,%eax
c0103fda:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103fe1:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103fe4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fe7:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103fea:	0f a3 10             	bt     %edx,(%eax)
c0103fed:	19 c0                	sbb    %eax,%eax
c0103fef:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103ff2:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103ff6:	0f 95 c0             	setne  %al
c0103ff9:	0f b6 c0             	movzbl %al,%eax
c0103ffc:	85 c0                	test   %eax,%eax
c0103ffe:	74 0e                	je     c010400e <default_check+0x29d>
c0104000:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104003:	83 c0 40             	add    $0x40,%eax
c0104006:	8b 40 08             	mov    0x8(%eax),%eax
c0104009:	83 f8 03             	cmp    $0x3,%eax
c010400c:	74 24                	je     c0104032 <default_check+0x2c1>
c010400e:	c7 44 24 0c dc 96 10 	movl   $0xc01096dc,0xc(%esp)
c0104015:	c0 
c0104016:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c010401d:	c0 
c010401e:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0104025:	00 
c0104026:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c010402d:	e8 aa cc ff ff       	call   c0100cdc <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104032:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0104039:	e8 db 06 00 00       	call   c0104719 <alloc_pages>
c010403e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104041:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104045:	75 24                	jne    c010406b <default_check+0x2fa>
c0104047:	c7 44 24 0c 08 97 10 	movl   $0xc0109708,0xc(%esp)
c010404e:	c0 
c010404f:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0104056:	c0 
c0104057:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c010405e:	00 
c010405f:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0104066:	e8 71 cc ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c010406b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104072:	e8 a2 06 00 00       	call   c0104719 <alloc_pages>
c0104077:	85 c0                	test   %eax,%eax
c0104079:	74 24                	je     c010409f <default_check+0x32e>
c010407b:	c7 44 24 0c 1e 96 10 	movl   $0xc010961e,0xc(%esp)
c0104082:	c0 
c0104083:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c010408a:	c0 
c010408b:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0104092:	00 
c0104093:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c010409a:	e8 3d cc ff ff       	call   c0100cdc <__panic>
    assert(p0 + 2 == p1);
c010409f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040a2:	83 c0 40             	add    $0x40,%eax
c01040a5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01040a8:	74 24                	je     c01040ce <default_check+0x35d>
c01040aa:	c7 44 24 0c 26 97 10 	movl   $0xc0109726,0xc(%esp)
c01040b1:	c0 
c01040b2:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01040b9:	c0 
c01040ba:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01040c1:	00 
c01040c2:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01040c9:	e8 0e cc ff ff       	call   c0100cdc <__panic>

    p2 = p0 + 1;
c01040ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040d1:	83 c0 20             	add    $0x20,%eax
c01040d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01040d7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040de:	00 
c01040df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040e2:	89 04 24             	mov    %eax,(%esp)
c01040e5:	e8 9a 06 00 00       	call   c0104784 <free_pages>
    free_pages(p1, 3);
c01040ea:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01040f1:	00 
c01040f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040f5:	89 04 24             	mov    %eax,(%esp)
c01040f8:	e8 87 06 00 00       	call   c0104784 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01040fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104100:	83 c0 04             	add    $0x4,%eax
c0104103:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010410a:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010410d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104110:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104113:	0f a3 10             	bt     %edx,(%eax)
c0104116:	19 c0                	sbb    %eax,%eax
c0104118:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010411b:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010411f:	0f 95 c0             	setne  %al
c0104122:	0f b6 c0             	movzbl %al,%eax
c0104125:	85 c0                	test   %eax,%eax
c0104127:	74 0b                	je     c0104134 <default_check+0x3c3>
c0104129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010412c:	8b 40 08             	mov    0x8(%eax),%eax
c010412f:	83 f8 01             	cmp    $0x1,%eax
c0104132:	74 24                	je     c0104158 <default_check+0x3e7>
c0104134:	c7 44 24 0c 34 97 10 	movl   $0xc0109734,0xc(%esp)
c010413b:	c0 
c010413c:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0104143:	c0 
c0104144:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c010414b:	00 
c010414c:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0104153:	e8 84 cb ff ff       	call   c0100cdc <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104158:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010415b:	83 c0 04             	add    $0x4,%eax
c010415e:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104165:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104168:	8b 45 90             	mov    -0x70(%ebp),%eax
c010416b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010416e:	0f a3 10             	bt     %edx,(%eax)
c0104171:	19 c0                	sbb    %eax,%eax
c0104173:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104176:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010417a:	0f 95 c0             	setne  %al
c010417d:	0f b6 c0             	movzbl %al,%eax
c0104180:	85 c0                	test   %eax,%eax
c0104182:	74 0b                	je     c010418f <default_check+0x41e>
c0104184:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104187:	8b 40 08             	mov    0x8(%eax),%eax
c010418a:	83 f8 03             	cmp    $0x3,%eax
c010418d:	74 24                	je     c01041b3 <default_check+0x442>
c010418f:	c7 44 24 0c 5c 97 10 	movl   $0xc010975c,0xc(%esp)
c0104196:	c0 
c0104197:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c010419e:	c0 
c010419f:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c01041a6:	00 
c01041a7:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01041ae:	e8 29 cb ff ff       	call   c0100cdc <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01041b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041ba:	e8 5a 05 00 00       	call   c0104719 <alloc_pages>
c01041bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041c5:	83 e8 20             	sub    $0x20,%eax
c01041c8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01041cb:	74 24                	je     c01041f1 <default_check+0x480>
c01041cd:	c7 44 24 0c 82 97 10 	movl   $0xc0109782,0xc(%esp)
c01041d4:	c0 
c01041d5:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01041dc:	c0 
c01041dd:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c01041e4:	00 
c01041e5:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01041ec:	e8 eb ca ff ff       	call   c0100cdc <__panic>
    free_page(p0);
c01041f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041f8:	00 
c01041f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041fc:	89 04 24             	mov    %eax,(%esp)
c01041ff:	e8 80 05 00 00       	call   c0104784 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104204:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010420b:	e8 09 05 00 00       	call   c0104719 <alloc_pages>
c0104210:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104213:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104216:	83 c0 20             	add    $0x20,%eax
c0104219:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010421c:	74 24                	je     c0104242 <default_check+0x4d1>
c010421e:	c7 44 24 0c a0 97 10 	movl   $0xc01097a0,0xc(%esp)
c0104225:	c0 
c0104226:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c010422d:	c0 
c010422e:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104235:	00 
c0104236:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c010423d:	e8 9a ca ff ff       	call   c0100cdc <__panic>

    free_pages(p0, 2);
c0104242:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104249:	00 
c010424a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010424d:	89 04 24             	mov    %eax,(%esp)
c0104250:	e8 2f 05 00 00       	call   c0104784 <free_pages>
    free_page(p2);
c0104255:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010425c:	00 
c010425d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104260:	89 04 24             	mov    %eax,(%esp)
c0104263:	e8 1c 05 00 00       	call   c0104784 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104268:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010426f:	e8 a5 04 00 00       	call   c0104719 <alloc_pages>
c0104274:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104277:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010427b:	75 24                	jne    c01042a1 <default_check+0x530>
c010427d:	c7 44 24 0c c0 97 10 	movl   $0xc01097c0,0xc(%esp)
c0104284:	c0 
c0104285:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c010428c:	c0 
c010428d:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0104294:	00 
c0104295:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c010429c:	e8 3b ca ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c01042a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042a8:	e8 6c 04 00 00       	call   c0104719 <alloc_pages>
c01042ad:	85 c0                	test   %eax,%eax
c01042af:	74 24                	je     c01042d5 <default_check+0x564>
c01042b1:	c7 44 24 0c 1e 96 10 	movl   $0xc010961e,0xc(%esp)
c01042b8:	c0 
c01042b9:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01042c0:	c0 
c01042c1:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c01042c8:	00 
c01042c9:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01042d0:	e8 07 ca ff ff       	call   c0100cdc <__panic>

    assert(nr_free == 0);
c01042d5:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01042da:	85 c0                	test   %eax,%eax
c01042dc:	74 24                	je     c0104302 <default_check+0x591>
c01042de:	c7 44 24 0c 71 96 10 	movl   $0xc0109671,0xc(%esp)
c01042e5:	c0 
c01042e6:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01042ed:	c0 
c01042ee:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01042f5:	00 
c01042f6:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01042fd:	e8 da c9 ff ff       	call   c0100cdc <__panic>
    nr_free = nr_free_store;
c0104302:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104305:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8

    free_list = free_list_store;
c010430a:	8b 45 80             	mov    -0x80(%ebp),%eax
c010430d:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104310:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0104315:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4
    free_pages(p0, 5);
c010431b:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104322:	00 
c0104323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104326:	89 04 24             	mov    %eax,(%esp)
c0104329:	e8 56 04 00 00       	call   c0104784 <free_pages>

    le = &free_list;
c010432e:	c7 45 ec c0 1a 12 c0 	movl   $0xc0121ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104335:	eb 1d                	jmp    c0104354 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104337:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010433a:	83 e8 0c             	sub    $0xc,%eax
c010433d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104340:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104344:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104347:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010434a:	8b 40 08             	mov    0x8(%eax),%eax
c010434d:	29 c2                	sub    %eax,%edx
c010434f:	89 d0                	mov    %edx,%eax
c0104351:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104354:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104357:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010435a:	8b 45 88             	mov    -0x78(%ebp),%eax
c010435d:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104360:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104363:	81 7d ec c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x14(%ebp)
c010436a:	75 cb                	jne    c0104337 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010436c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104370:	74 24                	je     c0104396 <default_check+0x625>
c0104372:	c7 44 24 0c de 97 10 	movl   $0xc01097de,0xc(%esp)
c0104379:	c0 
c010437a:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c0104381:	c0 
c0104382:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0104389:	00 
c010438a:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c0104391:	e8 46 c9 ff ff       	call   c0100cdc <__panic>
    assert(total == 0);
c0104396:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010439a:	74 24                	je     c01043c0 <default_check+0x64f>
c010439c:	c7 44 24 0c e9 97 10 	movl   $0xc01097e9,0xc(%esp)
c01043a3:	c0 
c01043a4:	c7 44 24 08 96 94 10 	movl   $0xc0109496,0x8(%esp)
c01043ab:	c0 
c01043ac:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01043b3:	00 
c01043b4:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c01043bb:	e8 1c c9 ff ff       	call   c0100cdc <__panic>
}
c01043c0:	81 c4 94 00 00 00    	add    $0x94,%esp
c01043c6:	5b                   	pop    %ebx
c01043c7:	5d                   	pop    %ebp
c01043c8:	c3                   	ret    

c01043c9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01043c9:	55                   	push   %ebp
c01043ca:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01043cc:	8b 55 08             	mov    0x8(%ebp),%edx
c01043cf:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01043d4:	29 c2                	sub    %eax,%edx
c01043d6:	89 d0                	mov    %edx,%eax
c01043d8:	c1 f8 05             	sar    $0x5,%eax
}
c01043db:	5d                   	pop    %ebp
c01043dc:	c3                   	ret    

c01043dd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01043dd:	55                   	push   %ebp
c01043de:	89 e5                	mov    %esp,%ebp
c01043e0:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01043e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01043e6:	89 04 24             	mov    %eax,(%esp)
c01043e9:	e8 db ff ff ff       	call   c01043c9 <page2ppn>
c01043ee:	c1 e0 0c             	shl    $0xc,%eax
}
c01043f1:	c9                   	leave  
c01043f2:	c3                   	ret    

c01043f3 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01043f3:	55                   	push   %ebp
c01043f4:	89 e5                	mov    %esp,%ebp
c01043f6:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01043f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01043fc:	c1 e8 0c             	shr    $0xc,%eax
c01043ff:	89 c2                	mov    %eax,%edx
c0104401:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104406:	39 c2                	cmp    %eax,%edx
c0104408:	72 1c                	jb     c0104426 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010440a:	c7 44 24 08 24 98 10 	movl   $0xc0109824,0x8(%esp)
c0104411:	c0 
c0104412:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0104419:	00 
c010441a:	c7 04 24 43 98 10 c0 	movl   $0xc0109843,(%esp)
c0104421:	e8 b6 c8 ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c0104426:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c010442b:	8b 55 08             	mov    0x8(%ebp),%edx
c010442e:	c1 ea 0c             	shr    $0xc,%edx
c0104431:	c1 e2 05             	shl    $0x5,%edx
c0104434:	01 d0                	add    %edx,%eax
}
c0104436:	c9                   	leave  
c0104437:	c3                   	ret    

c0104438 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104438:	55                   	push   %ebp
c0104439:	89 e5                	mov    %esp,%ebp
c010443b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010443e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104441:	89 04 24             	mov    %eax,(%esp)
c0104444:	e8 94 ff ff ff       	call   c01043dd <page2pa>
c0104449:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010444c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010444f:	c1 e8 0c             	shr    $0xc,%eax
c0104452:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104455:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010445a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010445d:	72 23                	jb     c0104482 <page2kva+0x4a>
c010445f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104462:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104466:	c7 44 24 08 54 98 10 	movl   $0xc0109854,0x8(%esp)
c010446d:	c0 
c010446e:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0104475:	00 
c0104476:	c7 04 24 43 98 10 c0 	movl   $0xc0109843,(%esp)
c010447d:	e8 5a c8 ff ff       	call   c0100cdc <__panic>
c0104482:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104485:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010448a:	c9                   	leave  
c010448b:	c3                   	ret    

c010448c <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010448c:	55                   	push   %ebp
c010448d:	89 e5                	mov    %esp,%ebp
c010448f:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104492:	8b 45 08             	mov    0x8(%ebp),%eax
c0104495:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104498:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010449f:	77 23                	ja     c01044c4 <kva2page+0x38>
c01044a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044a8:	c7 44 24 08 78 98 10 	movl   $0xc0109878,0x8(%esp)
c01044af:	c0 
c01044b0:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01044b7:	00 
c01044b8:	c7 04 24 43 98 10 c0 	movl   $0xc0109843,(%esp)
c01044bf:	e8 18 c8 ff ff       	call   c0100cdc <__panic>
c01044c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044c7:	05 00 00 00 40       	add    $0x40000000,%eax
c01044cc:	89 04 24             	mov    %eax,(%esp)
c01044cf:	e8 1f ff ff ff       	call   c01043f3 <pa2page>
}
c01044d4:	c9                   	leave  
c01044d5:	c3                   	ret    

c01044d6 <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c01044d6:	55                   	push   %ebp
c01044d7:	89 e5                	mov    %esp,%ebp
c01044d9:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01044dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01044df:	83 e0 01             	and    $0x1,%eax
c01044e2:	85 c0                	test   %eax,%eax
c01044e4:	75 1c                	jne    c0104502 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01044e6:	c7 44 24 08 9c 98 10 	movl   $0xc010989c,0x8(%esp)
c01044ed:	c0 
c01044ee:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01044f5:	00 
c01044f6:	c7 04 24 43 98 10 c0 	movl   $0xc0109843,(%esp)
c01044fd:	e8 da c7 ff ff       	call   c0100cdc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104502:	8b 45 08             	mov    0x8(%ebp),%eax
c0104505:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010450a:	89 04 24             	mov    %eax,(%esp)
c010450d:	e8 e1 fe ff ff       	call   c01043f3 <pa2page>
}
c0104512:	c9                   	leave  
c0104513:	c3                   	ret    

c0104514 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104514:	55                   	push   %ebp
c0104515:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104517:	8b 45 08             	mov    0x8(%ebp),%eax
c010451a:	8b 00                	mov    (%eax),%eax
}
c010451c:	5d                   	pop    %ebp
c010451d:	c3                   	ret    

c010451e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010451e:	55                   	push   %ebp
c010451f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104521:	8b 45 08             	mov    0x8(%ebp),%eax
c0104524:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104527:	89 10                	mov    %edx,(%eax)
}
c0104529:	5d                   	pop    %ebp
c010452a:	c3                   	ret    

c010452b <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010452b:	55                   	push   %ebp
c010452c:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010452e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104531:	8b 00                	mov    (%eax),%eax
c0104533:	8d 50 01             	lea    0x1(%eax),%edx
c0104536:	8b 45 08             	mov    0x8(%ebp),%eax
c0104539:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010453b:	8b 45 08             	mov    0x8(%ebp),%eax
c010453e:	8b 00                	mov    (%eax),%eax
}
c0104540:	5d                   	pop    %ebp
c0104541:	c3                   	ret    

c0104542 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104542:	55                   	push   %ebp
c0104543:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104545:	8b 45 08             	mov    0x8(%ebp),%eax
c0104548:	8b 00                	mov    (%eax),%eax
c010454a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010454d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104550:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104552:	8b 45 08             	mov    0x8(%ebp),%eax
c0104555:	8b 00                	mov    (%eax),%eax
}
c0104557:	5d                   	pop    %ebp
c0104558:	c3                   	ret    

c0104559 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104559:	55                   	push   %ebp
c010455a:	89 e5                	mov    %esp,%ebp
c010455c:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010455f:	9c                   	pushf  
c0104560:	58                   	pop    %eax
c0104561:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104564:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104567:	25 00 02 00 00       	and    $0x200,%eax
c010456c:	85 c0                	test   %eax,%eax
c010456e:	74 0c                	je     c010457c <__intr_save+0x23>
        intr_disable();
c0104570:	e8 bf d9 ff ff       	call   c0101f34 <intr_disable>
        return 1;
c0104575:	b8 01 00 00 00       	mov    $0x1,%eax
c010457a:	eb 05                	jmp    c0104581 <__intr_save+0x28>
    }
    return 0;
c010457c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104581:	c9                   	leave  
c0104582:	c3                   	ret    

c0104583 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104583:	55                   	push   %ebp
c0104584:	89 e5                	mov    %esp,%ebp
c0104586:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104589:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010458d:	74 05                	je     c0104594 <__intr_restore+0x11>
        intr_enable();
c010458f:	e8 9a d9 ff ff       	call   c0101f2e <intr_enable>
    }
}
c0104594:	c9                   	leave  
c0104595:	c3                   	ret    

c0104596 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104596:	55                   	push   %ebp
c0104597:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104599:	8b 45 08             	mov    0x8(%ebp),%eax
c010459c:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c010459f:	b8 23 00 00 00       	mov    $0x23,%eax
c01045a4:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01045a6:	b8 23 00 00 00       	mov    $0x23,%eax
c01045ab:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01045ad:	b8 10 00 00 00       	mov    $0x10,%eax
c01045b2:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01045b4:	b8 10 00 00 00       	mov    $0x10,%eax
c01045b9:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01045bb:	b8 10 00 00 00       	mov    $0x10,%eax
c01045c0:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01045c2:	ea c9 45 10 c0 08 00 	ljmp   $0x8,$0xc01045c9
}
c01045c9:	5d                   	pop    %ebp
c01045ca:	c3                   	ret    

c01045cb <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01045cb:	55                   	push   %ebp
c01045cc:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01045ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d1:	a3 44 1a 12 c0       	mov    %eax,0xc0121a44
}
c01045d6:	5d                   	pop    %ebp
c01045d7:	c3                   	ret    

c01045d8 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c01045d8:	55                   	push   %ebp
c01045d9:	89 e5                	mov    %esp,%ebp
c01045db:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01045de:	b8 00 00 12 c0       	mov    $0xc0120000,%eax
c01045e3:	89 04 24             	mov    %eax,(%esp)
c01045e6:	e8 e0 ff ff ff       	call   c01045cb <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c01045eb:	66 c7 05 48 1a 12 c0 	movw   $0x10,0xc0121a48
c01045f2:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c01045f4:	66 c7 05 28 0a 12 c0 	movw   $0x68,0xc0120a28
c01045fb:	68 00 
c01045fd:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c0104602:	66 a3 2a 0a 12 c0    	mov    %ax,0xc0120a2a
c0104608:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c010460d:	c1 e8 10             	shr    $0x10,%eax
c0104610:	a2 2c 0a 12 c0       	mov    %al,0xc0120a2c
c0104615:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c010461c:	83 e0 f0             	and    $0xfffffff0,%eax
c010461f:	83 c8 09             	or     $0x9,%eax
c0104622:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104627:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c010462e:	83 e0 ef             	and    $0xffffffef,%eax
c0104631:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104636:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c010463d:	83 e0 9f             	and    $0xffffff9f,%eax
c0104640:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104645:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c010464c:	83 c8 80             	or     $0xffffff80,%eax
c010464f:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104654:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010465b:	83 e0 f0             	and    $0xfffffff0,%eax
c010465e:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104663:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010466a:	83 e0 ef             	and    $0xffffffef,%eax
c010466d:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104672:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0104679:	83 e0 df             	and    $0xffffffdf,%eax
c010467c:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104681:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0104688:	83 c8 40             	or     $0x40,%eax
c010468b:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104690:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0104697:	83 e0 7f             	and    $0x7f,%eax
c010469a:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c010469f:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c01046a4:	c1 e8 18             	shr    $0x18,%eax
c01046a7:	a2 2f 0a 12 c0       	mov    %al,0xc0120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c01046ac:	c7 04 24 30 0a 12 c0 	movl   $0xc0120a30,(%esp)
c01046b3:	e8 de fe ff ff       	call   c0104596 <lgdt>
c01046b8:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01046be:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01046c2:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01046c5:	c9                   	leave  
c01046c6:	c3                   	ret    

c01046c7 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01046c7:	55                   	push   %ebp
c01046c8:	89 e5                	mov    %esp,%ebp
c01046ca:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c01046cd:	c7 05 cc 1a 12 c0 08 	movl   $0xc0109808,0xc0121acc
c01046d4:	98 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01046d7:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01046dc:	8b 00                	mov    (%eax),%eax
c01046de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046e2:	c7 04 24 c8 98 10 c0 	movl   $0xc01098c8,(%esp)
c01046e9:	e8 5d bc ff ff       	call   c010034b <cprintf>
    pmm_manager->init();
c01046ee:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01046f3:	8b 40 04             	mov    0x4(%eax),%eax
c01046f6:	ff d0                	call   *%eax
}
c01046f8:	c9                   	leave  
c01046f9:	c3                   	ret    

c01046fa <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c01046fa:	55                   	push   %ebp
c01046fb:	89 e5                	mov    %esp,%ebp
c01046fd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104700:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104705:	8b 40 08             	mov    0x8(%eax),%eax
c0104708:	8b 55 0c             	mov    0xc(%ebp),%edx
c010470b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010470f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104712:	89 14 24             	mov    %edx,(%esp)
c0104715:	ff d0                	call   *%eax
}
c0104717:	c9                   	leave  
c0104718:	c3                   	ret    

c0104719 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104719:	55                   	push   %ebp
c010471a:	89 e5                	mov    %esp,%ebp
c010471c:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c010471f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104726:	e8 2e fe ff ff       	call   c0104559 <__intr_save>
c010472b:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c010472e:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104733:	8b 40 0c             	mov    0xc(%eax),%eax
c0104736:	8b 55 08             	mov    0x8(%ebp),%edx
c0104739:	89 14 24             	mov    %edx,(%esp)
c010473c:	ff d0                	call   *%eax
c010473e:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104741:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104744:	89 04 24             	mov    %eax,(%esp)
c0104747:	e8 37 fe ff ff       	call   c0104583 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c010474c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104750:	75 2d                	jne    c010477f <alloc_pages+0x66>
c0104752:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104756:	77 27                	ja     c010477f <alloc_pages+0x66>
c0104758:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c010475d:	85 c0                	test   %eax,%eax
c010475f:	74 1e                	je     c010477f <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104761:	8b 55 08             	mov    0x8(%ebp),%edx
c0104764:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0104769:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104770:	00 
c0104771:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104775:	89 04 24             	mov    %eax,(%esp)
c0104778:	e8 97 1a 00 00       	call   c0106214 <swap_out>
    }
c010477d:	eb a7                	jmp    c0104726 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c010477f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104782:	c9                   	leave  
c0104783:	c3                   	ret    

c0104784 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104784:	55                   	push   %ebp
c0104785:	89 e5                	mov    %esp,%ebp
c0104787:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010478a:	e8 ca fd ff ff       	call   c0104559 <__intr_save>
c010478f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104792:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104797:	8b 40 10             	mov    0x10(%eax),%eax
c010479a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010479d:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01047a4:	89 14 24             	mov    %edx,(%esp)
c01047a7:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01047a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047ac:	89 04 24             	mov    %eax,(%esp)
c01047af:	e8 cf fd ff ff       	call   c0104583 <__intr_restore>
}
c01047b4:	c9                   	leave  
c01047b5:	c3                   	ret    

c01047b6 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01047b6:	55                   	push   %ebp
c01047b7:	89 e5                	mov    %esp,%ebp
c01047b9:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01047bc:	e8 98 fd ff ff       	call   c0104559 <__intr_save>
c01047c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01047c4:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01047c9:	8b 40 14             	mov    0x14(%eax),%eax
c01047cc:	ff d0                	call   *%eax
c01047ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01047d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047d4:	89 04 24             	mov    %eax,(%esp)
c01047d7:	e8 a7 fd ff ff       	call   c0104583 <__intr_restore>
    return ret;
c01047dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01047df:	c9                   	leave  
c01047e0:	c3                   	ret    

c01047e1 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01047e1:	55                   	push   %ebp
c01047e2:	89 e5                	mov    %esp,%ebp
c01047e4:	57                   	push   %edi
c01047e5:	56                   	push   %esi
c01047e6:	53                   	push   %ebx
c01047e7:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01047ed:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01047f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01047fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104802:	c7 04 24 df 98 10 c0 	movl   $0xc01098df,(%esp)
c0104809:	e8 3d bb ff ff       	call   c010034b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010480e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104815:	e9 15 01 00 00       	jmp    c010492f <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010481a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010481d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104820:	89 d0                	mov    %edx,%eax
c0104822:	c1 e0 02             	shl    $0x2,%eax
c0104825:	01 d0                	add    %edx,%eax
c0104827:	c1 e0 02             	shl    $0x2,%eax
c010482a:	01 c8                	add    %ecx,%eax
c010482c:	8b 50 08             	mov    0x8(%eax),%edx
c010482f:	8b 40 04             	mov    0x4(%eax),%eax
c0104832:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104835:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104838:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010483b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010483e:	89 d0                	mov    %edx,%eax
c0104840:	c1 e0 02             	shl    $0x2,%eax
c0104843:	01 d0                	add    %edx,%eax
c0104845:	c1 e0 02             	shl    $0x2,%eax
c0104848:	01 c8                	add    %ecx,%eax
c010484a:	8b 48 0c             	mov    0xc(%eax),%ecx
c010484d:	8b 58 10             	mov    0x10(%eax),%ebx
c0104850:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104853:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104856:	01 c8                	add    %ecx,%eax
c0104858:	11 da                	adc    %ebx,%edx
c010485a:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010485d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104860:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104863:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104866:	89 d0                	mov    %edx,%eax
c0104868:	c1 e0 02             	shl    $0x2,%eax
c010486b:	01 d0                	add    %edx,%eax
c010486d:	c1 e0 02             	shl    $0x2,%eax
c0104870:	01 c8                	add    %ecx,%eax
c0104872:	83 c0 14             	add    $0x14,%eax
c0104875:	8b 00                	mov    (%eax),%eax
c0104877:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c010487d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104880:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104883:	83 c0 ff             	add    $0xffffffff,%eax
c0104886:	83 d2 ff             	adc    $0xffffffff,%edx
c0104889:	89 c6                	mov    %eax,%esi
c010488b:	89 d7                	mov    %edx,%edi
c010488d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104890:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104893:	89 d0                	mov    %edx,%eax
c0104895:	c1 e0 02             	shl    $0x2,%eax
c0104898:	01 d0                	add    %edx,%eax
c010489a:	c1 e0 02             	shl    $0x2,%eax
c010489d:	01 c8                	add    %ecx,%eax
c010489f:	8b 48 0c             	mov    0xc(%eax),%ecx
c01048a2:	8b 58 10             	mov    0x10(%eax),%ebx
c01048a5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01048ab:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01048af:	89 74 24 14          	mov    %esi,0x14(%esp)
c01048b3:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01048b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01048ba:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01048bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048c1:	89 54 24 10          	mov    %edx,0x10(%esp)
c01048c5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01048c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01048cd:	c7 04 24 ec 98 10 c0 	movl   $0xc01098ec,(%esp)
c01048d4:	e8 72 ba ff ff       	call   c010034b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01048d9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01048dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048df:	89 d0                	mov    %edx,%eax
c01048e1:	c1 e0 02             	shl    $0x2,%eax
c01048e4:	01 d0                	add    %edx,%eax
c01048e6:	c1 e0 02             	shl    $0x2,%eax
c01048e9:	01 c8                	add    %ecx,%eax
c01048eb:	83 c0 14             	add    $0x14,%eax
c01048ee:	8b 00                	mov    (%eax),%eax
c01048f0:	83 f8 01             	cmp    $0x1,%eax
c01048f3:	75 36                	jne    c010492b <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c01048f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01048f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048fb:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01048fe:	77 2b                	ja     c010492b <page_init+0x14a>
c0104900:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104903:	72 05                	jb     c010490a <page_init+0x129>
c0104905:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104908:	73 21                	jae    c010492b <page_init+0x14a>
c010490a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010490e:	77 1b                	ja     c010492b <page_init+0x14a>
c0104910:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104914:	72 09                	jb     c010491f <page_init+0x13e>
c0104916:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c010491d:	77 0c                	ja     c010492b <page_init+0x14a>
                maxpa = end;
c010491f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104922:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104925:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104928:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010492b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010492f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104932:	8b 00                	mov    (%eax),%eax
c0104934:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104937:	0f 8f dd fe ff ff    	jg     c010481a <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010493d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104941:	72 1d                	jb     c0104960 <page_init+0x17f>
c0104943:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104947:	77 09                	ja     c0104952 <page_init+0x171>
c0104949:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104950:	76 0e                	jbe    c0104960 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104952:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104959:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104960:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104963:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104966:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010496a:	c1 ea 0c             	shr    $0xc,%edx
c010496d:	a3 20 1a 12 c0       	mov    %eax,0xc0121a20
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104972:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104979:	b8 b0 1b 12 c0       	mov    $0xc0121bb0,%eax
c010497e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104981:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104984:	01 d0                	add    %edx,%eax
c0104986:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104989:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010498c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104991:	f7 75 ac             	divl   -0x54(%ebp)
c0104994:	89 d0                	mov    %edx,%eax
c0104996:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104999:	29 c2                	sub    %eax,%edx
c010499b:	89 d0                	mov    %edx,%eax
c010499d:	a3 d4 1a 12 c0       	mov    %eax,0xc0121ad4

    for (i = 0; i < npage; i ++) {
c01049a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01049a9:	eb 27                	jmp    c01049d2 <page_init+0x1f1>
        SetPageReserved(pages + i);
c01049ab:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01049b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049b3:	c1 e2 05             	shl    $0x5,%edx
c01049b6:	01 d0                	add    %edx,%eax
c01049b8:	83 c0 04             	add    $0x4,%eax
c01049bb:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01049c2:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01049c5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01049c8:	8b 55 90             	mov    -0x70(%ebp),%edx
c01049cb:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01049ce:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01049d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049d5:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01049da:	39 c2                	cmp    %eax,%edx
c01049dc:	72 cd                	jb     c01049ab <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01049de:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01049e3:	c1 e0 05             	shl    $0x5,%eax
c01049e6:	89 c2                	mov    %eax,%edx
c01049e8:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01049ed:	01 d0                	add    %edx,%eax
c01049ef:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01049f2:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01049f9:	77 23                	ja     c0104a1e <page_init+0x23d>
c01049fb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01049fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a02:	c7 44 24 08 78 98 10 	movl   $0xc0109878,0x8(%esp)
c0104a09:	c0 
c0104a0a:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104a11:	00 
c0104a12:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0104a19:	e8 be c2 ff ff       	call   c0100cdc <__panic>
c0104a1e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104a21:	05 00 00 00 40       	add    $0x40000000,%eax
c0104a26:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104a29:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104a30:	e9 74 01 00 00       	jmp    c0104ba9 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104a35:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a38:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a3b:	89 d0                	mov    %edx,%eax
c0104a3d:	c1 e0 02             	shl    $0x2,%eax
c0104a40:	01 d0                	add    %edx,%eax
c0104a42:	c1 e0 02             	shl    $0x2,%eax
c0104a45:	01 c8                	add    %ecx,%eax
c0104a47:	8b 50 08             	mov    0x8(%eax),%edx
c0104a4a:	8b 40 04             	mov    0x4(%eax),%eax
c0104a4d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a50:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104a53:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a56:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a59:	89 d0                	mov    %edx,%eax
c0104a5b:	c1 e0 02             	shl    $0x2,%eax
c0104a5e:	01 d0                	add    %edx,%eax
c0104a60:	c1 e0 02             	shl    $0x2,%eax
c0104a63:	01 c8                	add    %ecx,%eax
c0104a65:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104a68:	8b 58 10             	mov    0x10(%eax),%ebx
c0104a6b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a6e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a71:	01 c8                	add    %ecx,%eax
c0104a73:	11 da                	adc    %ebx,%edx
c0104a75:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104a78:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104a7b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a7e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a81:	89 d0                	mov    %edx,%eax
c0104a83:	c1 e0 02             	shl    $0x2,%eax
c0104a86:	01 d0                	add    %edx,%eax
c0104a88:	c1 e0 02             	shl    $0x2,%eax
c0104a8b:	01 c8                	add    %ecx,%eax
c0104a8d:	83 c0 14             	add    $0x14,%eax
c0104a90:	8b 00                	mov    (%eax),%eax
c0104a92:	83 f8 01             	cmp    $0x1,%eax
c0104a95:	0f 85 0a 01 00 00    	jne    c0104ba5 <page_init+0x3c4>
            if (begin < freemem) {
c0104a9b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a9e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104aa3:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104aa6:	72 17                	jb     c0104abf <page_init+0x2de>
c0104aa8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104aab:	77 05                	ja     c0104ab2 <page_init+0x2d1>
c0104aad:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104ab0:	76 0d                	jbe    c0104abf <page_init+0x2de>
                begin = freemem;
c0104ab2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104ab5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ab8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104abf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104ac3:	72 1d                	jb     c0104ae2 <page_init+0x301>
c0104ac5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104ac9:	77 09                	ja     c0104ad4 <page_init+0x2f3>
c0104acb:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104ad2:	76 0e                	jbe    c0104ae2 <page_init+0x301>
                end = KMEMSIZE;
c0104ad4:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104adb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104ae2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ae5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104ae8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104aeb:	0f 87 b4 00 00 00    	ja     c0104ba5 <page_init+0x3c4>
c0104af1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104af4:	72 09                	jb     c0104aff <page_init+0x31e>
c0104af6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104af9:	0f 83 a6 00 00 00    	jae    c0104ba5 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0104aff:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104b06:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104b09:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104b0c:	01 d0                	add    %edx,%eax
c0104b0e:	83 e8 01             	sub    $0x1,%eax
c0104b11:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104b14:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104b17:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b1c:	f7 75 9c             	divl   -0x64(%ebp)
c0104b1f:	89 d0                	mov    %edx,%eax
c0104b21:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104b24:	29 c2                	sub    %eax,%edx
c0104b26:	89 d0                	mov    %edx,%eax
c0104b28:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b2d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104b30:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104b33:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104b36:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104b39:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104b3c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b41:	89 c7                	mov    %eax,%edi
c0104b43:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104b49:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104b4c:	89 d0                	mov    %edx,%eax
c0104b4e:	83 e0 00             	and    $0x0,%eax
c0104b51:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104b54:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104b57:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104b5a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104b5d:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104b60:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b66:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b69:	77 3a                	ja     c0104ba5 <page_init+0x3c4>
c0104b6b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b6e:	72 05                	jb     c0104b75 <page_init+0x394>
c0104b70:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104b73:	73 30                	jae    c0104ba5 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104b75:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104b78:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104b7b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104b7e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104b81:	29 c8                	sub    %ecx,%eax
c0104b83:	19 da                	sbb    %ebx,%edx
c0104b85:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104b89:	c1 ea 0c             	shr    $0xc,%edx
c0104b8c:	89 c3                	mov    %eax,%ebx
c0104b8e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b91:	89 04 24             	mov    %eax,(%esp)
c0104b94:	e8 5a f8 ff ff       	call   c01043f3 <pa2page>
c0104b99:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104b9d:	89 04 24             	mov    %eax,(%esp)
c0104ba0:	e8 55 fb ff ff       	call   c01046fa <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104ba5:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104bac:	8b 00                	mov    (%eax),%eax
c0104bae:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104bb1:	0f 8f 7e fe ff ff    	jg     c0104a35 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104bb7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104bbd:	5b                   	pop    %ebx
c0104bbe:	5e                   	pop    %esi
c0104bbf:	5f                   	pop    %edi
c0104bc0:	5d                   	pop    %ebp
c0104bc1:	c3                   	ret    

c0104bc2 <enable_paging>:

static void
enable_paging(void) {
c0104bc2:	55                   	push   %ebp
c0104bc3:	89 e5                	mov    %esp,%ebp
c0104bc5:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104bc8:	a1 d0 1a 12 c0       	mov    0xc0121ad0,%eax
c0104bcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104bd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104bd3:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104bd6:	0f 20 c0             	mov    %cr0,%eax
c0104bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104bdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104be2:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104be9:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104bed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bf6:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104bf9:	c9                   	leave  
c0104bfa:	c3                   	ret    

c0104bfb <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104bfb:	55                   	push   %ebp
c0104bfc:	89 e5                	mov    %esp,%ebp
c0104bfe:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104c01:	8b 45 14             	mov    0x14(%ebp),%eax
c0104c04:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c07:	31 d0                	xor    %edx,%eax
c0104c09:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104c0e:	85 c0                	test   %eax,%eax
c0104c10:	74 24                	je     c0104c36 <boot_map_segment+0x3b>
c0104c12:	c7 44 24 0c 2a 99 10 	movl   $0xc010992a,0xc(%esp)
c0104c19:	c0 
c0104c1a:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0104c21:	c0 
c0104c22:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104c29:	00 
c0104c2a:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0104c31:	e8 a6 c0 ff ff       	call   c0100cdc <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104c36:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c40:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104c45:	89 c2                	mov    %eax,%edx
c0104c47:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c4a:	01 c2                	add    %eax,%edx
c0104c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c4f:	01 d0                	add    %edx,%eax
c0104c51:	83 e8 01             	sub    $0x1,%eax
c0104c54:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c5a:	ba 00 00 00 00       	mov    $0x0,%edx
c0104c5f:	f7 75 f0             	divl   -0x10(%ebp)
c0104c62:	89 d0                	mov    %edx,%eax
c0104c64:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104c67:	29 c2                	sub    %eax,%edx
c0104c69:	89 d0                	mov    %edx,%eax
c0104c6b:	c1 e8 0c             	shr    $0xc,%eax
c0104c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104c71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c74:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104c77:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c7f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104c82:	8b 45 14             	mov    0x14(%ebp),%eax
c0104c85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104c88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c90:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104c93:	eb 6b                	jmp    c0104d00 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104c95:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104c9c:	00 
c0104c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ca4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ca7:	89 04 24             	mov    %eax,(%esp)
c0104caa:	e8 cc 01 00 00       	call   c0104e7b <get_pte>
c0104caf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104cb2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104cb6:	75 24                	jne    c0104cdc <boot_map_segment+0xe1>
c0104cb8:	c7 44 24 0c 56 99 10 	movl   $0xc0109956,0xc(%esp)
c0104cbf:	c0 
c0104cc0:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0104cc7:	c0 
c0104cc8:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104ccf:	00 
c0104cd0:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0104cd7:	e8 00 c0 ff ff       	call   c0100cdc <__panic>
        *ptep = pa | PTE_P | perm;
c0104cdc:	8b 45 18             	mov    0x18(%ebp),%eax
c0104cdf:	8b 55 14             	mov    0x14(%ebp),%edx
c0104ce2:	09 d0                	or     %edx,%eax
c0104ce4:	83 c8 01             	or     $0x1,%eax
c0104ce7:	89 c2                	mov    %eax,%edx
c0104ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104cec:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104cee:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104cf2:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104cf9:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104d00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d04:	75 8f                	jne    c0104c95 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104d06:	c9                   	leave  
c0104d07:	c3                   	ret    

c0104d08 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104d08:	55                   	push   %ebp
c0104d09:	89 e5                	mov    %esp,%ebp
c0104d0b:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104d0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d15:	e8 ff f9 ff ff       	call   c0104719 <alloc_pages>
c0104d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d21:	75 1c                	jne    c0104d3f <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104d23:	c7 44 24 08 63 99 10 	movl   $0xc0109963,0x8(%esp)
c0104d2a:	c0 
c0104d2b:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104d32:	00 
c0104d33:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0104d3a:	e8 9d bf ff ff       	call   c0100cdc <__panic>
    }
    return page2kva(p);
c0104d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d42:	89 04 24             	mov    %eax,(%esp)
c0104d45:	e8 ee f6 ff ff       	call   c0104438 <page2kva>
}
c0104d4a:	c9                   	leave  
c0104d4b:	c3                   	ret    

c0104d4c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104d4c:	55                   	push   %ebp
c0104d4d:	89 e5                	mov    %esp,%ebp
c0104d4f:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104d52:	e8 70 f9 ff ff       	call   c01046c7 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104d57:	e8 85 fa ff ff       	call   c01047e1 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104d5c:	e8 31 05 00 00       	call   c0105292 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104d61:	e8 a2 ff ff ff       	call   c0104d08 <boot_alloc_page>
c0104d66:	a3 24 1a 12 c0       	mov    %eax,0xc0121a24
    memset(boot_pgdir, 0, PGSIZE);
c0104d6b:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104d70:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104d77:	00 
c0104d78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d7f:	00 
c0104d80:	89 04 24             	mov    %eax,(%esp)
c0104d83:	e8 f8 3c 00 00       	call   c0108a80 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104d88:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d90:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104d97:	77 23                	ja     c0104dbc <pmm_init+0x70>
c0104d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104da0:	c7 44 24 08 78 98 10 	movl   $0xc0109878,0x8(%esp)
c0104da7:	c0 
c0104da8:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104daf:	00 
c0104db0:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0104db7:	e8 20 bf ff ff       	call   c0100cdc <__panic>
c0104dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dbf:	05 00 00 00 40       	add    $0x40000000,%eax
c0104dc4:	a3 d0 1a 12 c0       	mov    %eax,0xc0121ad0

    check_pgdir();
c0104dc9:	e8 e2 04 00 00       	call   c01052b0 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104dce:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104dd3:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104dd9:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104de1:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104de8:	77 23                	ja     c0104e0d <pmm_init+0xc1>
c0104dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ded:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104df1:	c7 44 24 08 78 98 10 	movl   $0xc0109878,0x8(%esp)
c0104df8:	c0 
c0104df9:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104e00:	00 
c0104e01:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0104e08:	e8 cf be ff ff       	call   c0100cdc <__panic>
c0104e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e10:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e15:	83 c8 03             	or     $0x3,%eax
c0104e18:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104e1a:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e1f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104e26:	00 
c0104e27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104e2e:	00 
c0104e2f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104e36:	38 
c0104e37:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104e3e:	c0 
c0104e3f:	89 04 24             	mov    %eax,(%esp)
c0104e42:	e8 b4 fd ff ff       	call   c0104bfb <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104e47:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e4c:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0104e52:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104e58:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104e5a:	e8 63 fd ff ff       	call   c0104bc2 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104e5f:	e8 74 f7 ff ff       	call   c01045d8 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104e64:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104e6f:	e8 d7 0a 00 00       	call   c010594b <check_boot_pgdir>

    print_pgdir();
c0104e74:	e8 64 0f 00 00       	call   c0105ddd <print_pgdir>

}
c0104e79:	c9                   	leave  
c0104e7a:	c3                   	ret    

c0104e7b <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104e7b:	55                   	push   %ebp
c0104e7c:	89 e5                	mov    %esp,%ebp
c0104e7e:	83 ec 38             	sub    $0x38,%esp
    }
    return NULL;          // (8) return page table entry
#endif


    pde_t* pdep = pgdir + PDX(la);
c0104e81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e84:	c1 e8 16             	shr    $0x16,%eax
c0104e87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e91:	01 d0                	add    %edx,%eax
c0104e93:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (!(*pdep & PTE_P)) 	{
c0104e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e99:	8b 00                	mov    (%eax),%eax
c0104e9b:	83 e0 01             	and    $0x1,%eax
c0104e9e:	85 c0                	test   %eax,%eax
c0104ea0:	0f 85 af 00 00 00    	jne    c0104f55 <get_pte+0xda>
		struct Page* page;
		if (!create || (page = alloc_page()) == NULL)
c0104ea6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104eaa:	74 15                	je     c0104ec1 <get_pte+0x46>
c0104eac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104eb3:	e8 61 f8 ff ff       	call   c0104719 <alloc_pages>
c0104eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ebb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ebf:	75 0a                	jne    c0104ecb <get_pte+0x50>
			return NULL;
c0104ec1:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ec6:	e9 e6 00 00 00       	jmp    c0104fb1 <get_pte+0x136>

		set_page_ref(page, 1);
c0104ecb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ed2:	00 
c0104ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ed6:	89 04 24             	mov    %eax,(%esp)
c0104ed9:	e8 40 f6 ff ff       	call   c010451e <set_page_ref>
		uintptr_t pa = page2pa(page);
c0104ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ee1:	89 04 24             	mov    %eax,(%esp)
c0104ee4:	e8 f4 f4 ff ff       	call   c01043dd <page2pa>
c0104ee9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pa), 0, PGSIZE);
c0104eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104eef:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ef2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ef5:	c1 e8 0c             	shr    $0xc,%eax
c0104ef8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104efb:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104f00:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104f03:	72 23                	jb     c0104f28 <get_pte+0xad>
c0104f05:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f08:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f0c:	c7 44 24 08 54 98 10 	movl   $0xc0109854,0x8(%esp)
c0104f13:	c0 
c0104f14:	c7 44 24 04 98 01 00 	movl   $0x198,0x4(%esp)
c0104f1b:	00 
c0104f1c:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0104f23:	e8 b4 bd ff ff       	call   c0100cdc <__panic>
c0104f28:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f2b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f30:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104f37:	00 
c0104f38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104f3f:	00 
c0104f40:	89 04 24             	mov    %eax,(%esp)
c0104f43:	e8 38 3b 00 00       	call   c0108a80 <memset>
		*pdep= pa | PTE_P | PTE_W | PTE_U;
c0104f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f4b:	83 c8 07             	or     $0x7,%eax
c0104f4e:	89 c2                	mov    %eax,%edx
c0104f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f53:	89 10                	mov    %edx,(%eax)
	}
	return (pte_t*)KADDR(PDE_ADDR(*pdep)) + PTX(la);
c0104f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f58:	8b 00                	mov    (%eax),%eax
c0104f5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f62:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f65:	c1 e8 0c             	shr    $0xc,%eax
c0104f68:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104f6b:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104f70:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104f73:	72 23                	jb     c0104f98 <get_pte+0x11d>
c0104f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f78:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f7c:	c7 44 24 08 54 98 10 	movl   $0xc0109854,0x8(%esp)
c0104f83:	c0 
c0104f84:	c7 44 24 04 9b 01 00 	movl   $0x19b,0x4(%esp)
c0104f8b:	00 
c0104f8c:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0104f93:	e8 44 bd ff ff       	call   c0100cdc <__panic>
c0104f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f9b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104fa3:	c1 ea 0c             	shr    $0xc,%edx
c0104fa6:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104fac:	c1 e2 02             	shl    $0x2,%edx
c0104faf:	01 d0                	add    %edx,%eax
}
c0104fb1:	c9                   	leave  
c0104fb2:	c3                   	ret    

c0104fb3 <get_page>:


//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104fb3:	55                   	push   %ebp
c0104fb4:	89 e5                	mov    %esp,%ebp
c0104fb6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104fb9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104fc0:	00 
c0104fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fc4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fcb:	89 04 24             	mov    %eax,(%esp)
c0104fce:	e8 a8 fe ff ff       	call   c0104e7b <get_pte>
c0104fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104fd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104fda:	74 08                	je     c0104fe4 <get_page+0x31>
        *ptep_store = ptep;
c0104fdc:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104fe2:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104fe4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104fe8:	74 1b                	je     c0105005 <get_page+0x52>
c0104fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fed:	8b 00                	mov    (%eax),%eax
c0104fef:	83 e0 01             	and    $0x1,%eax
c0104ff2:	85 c0                	test   %eax,%eax
c0104ff4:	74 0f                	je     c0105005 <get_page+0x52>
        return pa2page(*ptep);
c0104ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ff9:	8b 00                	mov    (%eax),%eax
c0104ffb:	89 04 24             	mov    %eax,(%esp)
c0104ffe:	e8 f0 f3 ff ff       	call   c01043f3 <pa2page>
c0105003:	eb 05                	jmp    c010500a <get_page+0x57>
    }
    return NULL;
c0105005:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010500a:	c9                   	leave  
c010500b:	c3                   	ret    

c010500c <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010500c:	55                   	push   %ebp
c010500d:	89 e5                	mov    %esp,%ebp
c010500f:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

    if (*ptep & PTE_P) {
c0105012:	8b 45 10             	mov    0x10(%ebp),%eax
c0105015:	8b 00                	mov    (%eax),%eax
c0105017:	83 e0 01             	and    $0x1,%eax
c010501a:	85 c0                	test   %eax,%eax
c010501c:	74 4d                	je     c010506b <page_remove_pte+0x5f>
        struct Page* page = pte2page(*ptep);
c010501e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105021:	8b 00                	mov    (%eax),%eax
c0105023:	89 04 24             	mov    %eax,(%esp)
c0105026:	e8 ab f4 ff ff       	call   c01044d6 <pte2page>
c010502b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0)
c010502e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105031:	89 04 24             	mov    %eax,(%esp)
c0105034:	e8 09 f5 ff ff       	call   c0104542 <page_ref_dec>
c0105039:	85 c0                	test   %eax,%eax
c010503b:	75 13                	jne    c0105050 <page_remove_pte+0x44>
            free_page(page);
c010503d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105044:	00 
c0105045:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105048:	89 04 24             	mov    %eax,(%esp)
c010504b:	e8 34 f7 ff ff       	call   c0104784 <free_pages>

        *ptep = 0;
c0105050:	8b 45 10             	mov    0x10(%ebp),%eax
c0105053:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0105059:	8b 45 0c             	mov    0xc(%ebp),%eax
c010505c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105060:	8b 45 08             	mov    0x8(%ebp),%eax
c0105063:	89 04 24             	mov    %eax,(%esp)
c0105066:	e8 ff 00 00 00       	call   c010516a <tlb_invalidate>
    }
}
c010506b:	c9                   	leave  
c010506c:	c3                   	ret    

c010506d <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010506d:	55                   	push   %ebp
c010506e:	89 e5                	mov    %esp,%ebp
c0105070:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105073:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010507a:	00 
c010507b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010507e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105082:	8b 45 08             	mov    0x8(%ebp),%eax
c0105085:	89 04 24             	mov    %eax,(%esp)
c0105088:	e8 ee fd ff ff       	call   c0104e7b <get_pte>
c010508d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105090:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105094:	74 19                	je     c01050af <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105096:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105099:	89 44 24 08          	mov    %eax,0x8(%esp)
c010509d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01050a7:	89 04 24             	mov    %eax,(%esp)
c01050aa:	e8 5d ff ff ff       	call   c010500c <page_remove_pte>
    }
}
c01050af:	c9                   	leave  
c01050b0:	c3                   	ret    

c01050b1 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01050b1:	55                   	push   %ebp
c01050b2:	89 e5                	mov    %esp,%ebp
c01050b4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01050b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01050be:	00 
c01050bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01050c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01050c9:	89 04 24             	mov    %eax,(%esp)
c01050cc:	e8 aa fd ff ff       	call   c0104e7b <get_pte>
c01050d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01050d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050d8:	75 0a                	jne    c01050e4 <page_insert+0x33>
        return -E_NO_MEM;
c01050da:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01050df:	e9 84 00 00 00       	jmp    c0105168 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01050e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050e7:	89 04 24             	mov    %eax,(%esp)
c01050ea:	e8 3c f4 ff ff       	call   c010452b <page_ref_inc>
    if (*ptep & PTE_P) {
c01050ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050f2:	8b 00                	mov    (%eax),%eax
c01050f4:	83 e0 01             	and    $0x1,%eax
c01050f7:	85 c0                	test   %eax,%eax
c01050f9:	74 3e                	je     c0105139 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01050fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050fe:	8b 00                	mov    (%eax),%eax
c0105100:	89 04 24             	mov    %eax,(%esp)
c0105103:	e8 ce f3 ff ff       	call   c01044d6 <pte2page>
c0105108:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010510b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010510e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105111:	75 0d                	jne    c0105120 <page_insert+0x6f>
            page_ref_dec(page);
c0105113:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105116:	89 04 24             	mov    %eax,(%esp)
c0105119:	e8 24 f4 ff ff       	call   c0104542 <page_ref_dec>
c010511e:	eb 19                	jmp    c0105139 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105120:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105123:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105127:	8b 45 10             	mov    0x10(%ebp),%eax
c010512a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010512e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105131:	89 04 24             	mov    %eax,(%esp)
c0105134:	e8 d3 fe ff ff       	call   c010500c <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105139:	8b 45 0c             	mov    0xc(%ebp),%eax
c010513c:	89 04 24             	mov    %eax,(%esp)
c010513f:	e8 99 f2 ff ff       	call   c01043dd <page2pa>
c0105144:	0b 45 14             	or     0x14(%ebp),%eax
c0105147:	83 c8 01             	or     $0x1,%eax
c010514a:	89 c2                	mov    %eax,%edx
c010514c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010514f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105151:	8b 45 10             	mov    0x10(%ebp),%eax
c0105154:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105158:	8b 45 08             	mov    0x8(%ebp),%eax
c010515b:	89 04 24             	mov    %eax,(%esp)
c010515e:	e8 07 00 00 00       	call   c010516a <tlb_invalidate>
    return 0;
c0105163:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105168:	c9                   	leave  
c0105169:	c3                   	ret    

c010516a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010516a:	55                   	push   %ebp
c010516b:	89 e5                	mov    %esp,%ebp
c010516d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105170:	0f 20 d8             	mov    %cr3,%eax
c0105173:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105176:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105179:	89 c2                	mov    %eax,%edx
c010517b:	8b 45 08             	mov    0x8(%ebp),%eax
c010517e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105181:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105188:	77 23                	ja     c01051ad <tlb_invalidate+0x43>
c010518a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010518d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105191:	c7 44 24 08 78 98 10 	movl   $0xc0109878,0x8(%esp)
c0105198:	c0 
c0105199:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c01051a0:	00 
c01051a1:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01051a8:	e8 2f bb ff ff       	call   c0100cdc <__panic>
c01051ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051b0:	05 00 00 00 40       	add    $0x40000000,%eax
c01051b5:	39 c2                	cmp    %eax,%edx
c01051b7:	75 0c                	jne    c01051c5 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01051b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01051bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051c2:	0f 01 38             	invlpg (%eax)
    }
}
c01051c5:	c9                   	leave  
c01051c6:	c3                   	ret    

c01051c7 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c01051c7:	55                   	push   %ebp
c01051c8:	89 e5                	mov    %esp,%ebp
c01051ca:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c01051cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051d4:	e8 40 f5 ff ff       	call   c0104719 <alloc_pages>
c01051d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01051dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01051e0:	0f 84 a7 00 00 00    	je     c010528d <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01051e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01051e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01051f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fe:	89 04 24             	mov    %eax,(%esp)
c0105201:	e8 ab fe ff ff       	call   c01050b1 <page_insert>
c0105206:	85 c0                	test   %eax,%eax
c0105208:	74 1a                	je     c0105224 <pgdir_alloc_page+0x5d>
            free_page(page);
c010520a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105211:	00 
c0105212:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105215:	89 04 24             	mov    %eax,(%esp)
c0105218:	e8 67 f5 ff ff       	call   c0104784 <free_pages>
            return NULL;
c010521d:	b8 00 00 00 00       	mov    $0x0,%eax
c0105222:	eb 6c                	jmp    c0105290 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0105224:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0105229:	85 c0                	test   %eax,%eax
c010522b:	74 60                	je     c010528d <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c010522d:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0105232:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105239:	00 
c010523a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010523d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105241:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105244:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105248:	89 04 24             	mov    %eax,(%esp)
c010524b:	e8 78 0f 00 00       	call   c01061c8 <swap_map_swappable>
            page->pra_vaddr=la;
c0105250:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105253:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105256:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0105259:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010525c:	89 04 24             	mov    %eax,(%esp)
c010525f:	e8 b0 f2 ff ff       	call   c0104514 <page_ref>
c0105264:	83 f8 01             	cmp    $0x1,%eax
c0105267:	74 24                	je     c010528d <pgdir_alloc_page+0xc6>
c0105269:	c7 44 24 0c 7c 99 10 	movl   $0xc010997c,0xc(%esp)
c0105270:	c0 
c0105271:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105278:	c0 
c0105279:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0105280:	00 
c0105281:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105288:	e8 4f ba ff ff       	call   c0100cdc <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c010528d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105290:	c9                   	leave  
c0105291:	c3                   	ret    

c0105292 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105292:	55                   	push   %ebp
c0105293:	89 e5                	mov    %esp,%ebp
c0105295:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105298:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c010529d:	8b 40 18             	mov    0x18(%eax),%eax
c01052a0:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01052a2:	c7 04 24 90 99 10 c0 	movl   $0xc0109990,(%esp)
c01052a9:	e8 9d b0 ff ff       	call   c010034b <cprintf>
}
c01052ae:	c9                   	leave  
c01052af:	c3                   	ret    

c01052b0 <check_pgdir>:

static void
check_pgdir(void) {
c01052b0:	55                   	push   %ebp
c01052b1:	89 e5                	mov    %esp,%ebp
c01052b3:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01052b6:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01052bb:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01052c0:	76 24                	jbe    c01052e6 <check_pgdir+0x36>
c01052c2:	c7 44 24 0c af 99 10 	movl   $0xc01099af,0xc(%esp)
c01052c9:	c0 
c01052ca:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01052d1:	c0 
c01052d2:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c01052d9:	00 
c01052da:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01052e1:	e8 f6 b9 ff ff       	call   c0100cdc <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01052e6:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01052eb:	85 c0                	test   %eax,%eax
c01052ed:	74 0e                	je     c01052fd <check_pgdir+0x4d>
c01052ef:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01052f4:	25 ff 0f 00 00       	and    $0xfff,%eax
c01052f9:	85 c0                	test   %eax,%eax
c01052fb:	74 24                	je     c0105321 <check_pgdir+0x71>
c01052fd:	c7 44 24 0c cc 99 10 	movl   $0xc01099cc,0xc(%esp)
c0105304:	c0 
c0105305:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c010530c:	c0 
c010530d:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0105314:	00 
c0105315:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c010531c:	e8 bb b9 ff ff       	call   c0100cdc <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105321:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105326:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010532d:	00 
c010532e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105335:	00 
c0105336:	89 04 24             	mov    %eax,(%esp)
c0105339:	e8 75 fc ff ff       	call   c0104fb3 <get_page>
c010533e:	85 c0                	test   %eax,%eax
c0105340:	74 24                	je     c0105366 <check_pgdir+0xb6>
c0105342:	c7 44 24 0c 04 9a 10 	movl   $0xc0109a04,0xc(%esp)
c0105349:	c0 
c010534a:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105351:	c0 
c0105352:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105359:	00 
c010535a:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105361:	e8 76 b9 ff ff       	call   c0100cdc <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105366:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010536d:	e8 a7 f3 ff ff       	call   c0104719 <alloc_pages>
c0105372:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105375:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010537a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105381:	00 
c0105382:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105389:	00 
c010538a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010538d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105391:	89 04 24             	mov    %eax,(%esp)
c0105394:	e8 18 fd ff ff       	call   c01050b1 <page_insert>
c0105399:	85 c0                	test   %eax,%eax
c010539b:	74 24                	je     c01053c1 <check_pgdir+0x111>
c010539d:	c7 44 24 0c 2c 9a 10 	movl   $0xc0109a2c,0xc(%esp)
c01053a4:	c0 
c01053a5:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01053ac:	c0 
c01053ad:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c01053b4:	00 
c01053b5:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01053bc:	e8 1b b9 ff ff       	call   c0100cdc <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01053c1:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01053c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01053cd:	00 
c01053ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01053d5:	00 
c01053d6:	89 04 24             	mov    %eax,(%esp)
c01053d9:	e8 9d fa ff ff       	call   c0104e7b <get_pte>
c01053de:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053e5:	75 24                	jne    c010540b <check_pgdir+0x15b>
c01053e7:	c7 44 24 0c 58 9a 10 	movl   $0xc0109a58,0xc(%esp)
c01053ee:	c0 
c01053ef:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01053f6:	c0 
c01053f7:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c01053fe:	00 
c01053ff:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105406:	e8 d1 b8 ff ff       	call   c0100cdc <__panic>
    assert(pa2page(*ptep) == p1);
c010540b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010540e:	8b 00                	mov    (%eax),%eax
c0105410:	89 04 24             	mov    %eax,(%esp)
c0105413:	e8 db ef ff ff       	call   c01043f3 <pa2page>
c0105418:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010541b:	74 24                	je     c0105441 <check_pgdir+0x191>
c010541d:	c7 44 24 0c 85 9a 10 	movl   $0xc0109a85,0xc(%esp)
c0105424:	c0 
c0105425:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c010542c:	c0 
c010542d:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105434:	00 
c0105435:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c010543c:	e8 9b b8 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p1) == 1);
c0105441:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105444:	89 04 24             	mov    %eax,(%esp)
c0105447:	e8 c8 f0 ff ff       	call   c0104514 <page_ref>
c010544c:	83 f8 01             	cmp    $0x1,%eax
c010544f:	74 24                	je     c0105475 <check_pgdir+0x1c5>
c0105451:	c7 44 24 0c 9a 9a 10 	movl   $0xc0109a9a,0xc(%esp)
c0105458:	c0 
c0105459:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105460:	c0 
c0105461:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105468:	00 
c0105469:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105470:	e8 67 b8 ff ff       	call   c0100cdc <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105475:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010547a:	8b 00                	mov    (%eax),%eax
c010547c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105481:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105484:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105487:	c1 e8 0c             	shr    $0xc,%eax
c010548a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010548d:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105492:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105495:	72 23                	jb     c01054ba <check_pgdir+0x20a>
c0105497:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010549a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010549e:	c7 44 24 08 54 98 10 	movl   $0xc0109854,0x8(%esp)
c01054a5:	c0 
c01054a6:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c01054ad:	00 
c01054ae:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01054b5:	e8 22 b8 ff ff       	call   c0100cdc <__panic>
c01054ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054bd:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01054c2:	83 c0 04             	add    $0x4,%eax
c01054c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01054c8:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01054cd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01054d4:	00 
c01054d5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01054dc:	00 
c01054dd:	89 04 24             	mov    %eax,(%esp)
c01054e0:	e8 96 f9 ff ff       	call   c0104e7b <get_pte>
c01054e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01054e8:	74 24                	je     c010550e <check_pgdir+0x25e>
c01054ea:	c7 44 24 0c ac 9a 10 	movl   $0xc0109aac,0xc(%esp)
c01054f1:	c0 
c01054f2:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01054f9:	c0 
c01054fa:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0105501:	00 
c0105502:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105509:	e8 ce b7 ff ff       	call   c0100cdc <__panic>

    p2 = alloc_page();
c010550e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105515:	e8 ff f1 ff ff       	call   c0104719 <alloc_pages>
c010551a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010551d:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105522:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105529:	00 
c010552a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105531:	00 
c0105532:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105535:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105539:	89 04 24             	mov    %eax,(%esp)
c010553c:	e8 70 fb ff ff       	call   c01050b1 <page_insert>
c0105541:	85 c0                	test   %eax,%eax
c0105543:	74 24                	je     c0105569 <check_pgdir+0x2b9>
c0105545:	c7 44 24 0c d4 9a 10 	movl   $0xc0109ad4,0xc(%esp)
c010554c:	c0 
c010554d:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105554:	c0 
c0105555:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c010555c:	00 
c010555d:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105564:	e8 73 b7 ff ff       	call   c0100cdc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105569:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010556e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105575:	00 
c0105576:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010557d:	00 
c010557e:	89 04 24             	mov    %eax,(%esp)
c0105581:	e8 f5 f8 ff ff       	call   c0104e7b <get_pte>
c0105586:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105589:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010558d:	75 24                	jne    c01055b3 <check_pgdir+0x303>
c010558f:	c7 44 24 0c 0c 9b 10 	movl   $0xc0109b0c,0xc(%esp)
c0105596:	c0 
c0105597:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c010559e:	c0 
c010559f:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01055a6:	00 
c01055a7:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01055ae:	e8 29 b7 ff ff       	call   c0100cdc <__panic>
    assert(*ptep & PTE_U);
c01055b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055b6:	8b 00                	mov    (%eax),%eax
c01055b8:	83 e0 04             	and    $0x4,%eax
c01055bb:	85 c0                	test   %eax,%eax
c01055bd:	75 24                	jne    c01055e3 <check_pgdir+0x333>
c01055bf:	c7 44 24 0c 3c 9b 10 	movl   $0xc0109b3c,0xc(%esp)
c01055c6:	c0 
c01055c7:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01055ce:	c0 
c01055cf:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c01055d6:	00 
c01055d7:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01055de:	e8 f9 b6 ff ff       	call   c0100cdc <__panic>
    assert(*ptep & PTE_W);
c01055e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055e6:	8b 00                	mov    (%eax),%eax
c01055e8:	83 e0 02             	and    $0x2,%eax
c01055eb:	85 c0                	test   %eax,%eax
c01055ed:	75 24                	jne    c0105613 <check_pgdir+0x363>
c01055ef:	c7 44 24 0c 4a 9b 10 	movl   $0xc0109b4a,0xc(%esp)
c01055f6:	c0 
c01055f7:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01055fe:	c0 
c01055ff:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105606:	00 
c0105607:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c010560e:	e8 c9 b6 ff ff       	call   c0100cdc <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105613:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105618:	8b 00                	mov    (%eax),%eax
c010561a:	83 e0 04             	and    $0x4,%eax
c010561d:	85 c0                	test   %eax,%eax
c010561f:	75 24                	jne    c0105645 <check_pgdir+0x395>
c0105621:	c7 44 24 0c 58 9b 10 	movl   $0xc0109b58,0xc(%esp)
c0105628:	c0 
c0105629:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105630:	c0 
c0105631:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105638:	00 
c0105639:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105640:	e8 97 b6 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 1);
c0105645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105648:	89 04 24             	mov    %eax,(%esp)
c010564b:	e8 c4 ee ff ff       	call   c0104514 <page_ref>
c0105650:	83 f8 01             	cmp    $0x1,%eax
c0105653:	74 24                	je     c0105679 <check_pgdir+0x3c9>
c0105655:	c7 44 24 0c 6e 9b 10 	movl   $0xc0109b6e,0xc(%esp)
c010565c:	c0 
c010565d:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105664:	c0 
c0105665:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c010566c:	00 
c010566d:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105674:	e8 63 b6 ff ff       	call   c0100cdc <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105679:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010567e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105685:	00 
c0105686:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010568d:	00 
c010568e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105691:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105695:	89 04 24             	mov    %eax,(%esp)
c0105698:	e8 14 fa ff ff       	call   c01050b1 <page_insert>
c010569d:	85 c0                	test   %eax,%eax
c010569f:	74 24                	je     c01056c5 <check_pgdir+0x415>
c01056a1:	c7 44 24 0c 80 9b 10 	movl   $0xc0109b80,0xc(%esp)
c01056a8:	c0 
c01056a9:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01056b0:	c0 
c01056b1:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01056b8:	00 
c01056b9:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01056c0:	e8 17 b6 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p1) == 2);
c01056c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056c8:	89 04 24             	mov    %eax,(%esp)
c01056cb:	e8 44 ee ff ff       	call   c0104514 <page_ref>
c01056d0:	83 f8 02             	cmp    $0x2,%eax
c01056d3:	74 24                	je     c01056f9 <check_pgdir+0x449>
c01056d5:	c7 44 24 0c ac 9b 10 	movl   $0xc0109bac,0xc(%esp)
c01056dc:	c0 
c01056dd:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01056e4:	c0 
c01056e5:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c01056ec:	00 
c01056ed:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01056f4:	e8 e3 b5 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 0);
c01056f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056fc:	89 04 24             	mov    %eax,(%esp)
c01056ff:	e8 10 ee ff ff       	call   c0104514 <page_ref>
c0105704:	85 c0                	test   %eax,%eax
c0105706:	74 24                	je     c010572c <check_pgdir+0x47c>
c0105708:	c7 44 24 0c be 9b 10 	movl   $0xc0109bbe,0xc(%esp)
c010570f:	c0 
c0105710:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105717:	c0 
c0105718:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c010571f:	00 
c0105720:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105727:	e8 b0 b5 ff ff       	call   c0100cdc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010572c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105731:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105738:	00 
c0105739:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105740:	00 
c0105741:	89 04 24             	mov    %eax,(%esp)
c0105744:	e8 32 f7 ff ff       	call   c0104e7b <get_pte>
c0105749:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010574c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105750:	75 24                	jne    c0105776 <check_pgdir+0x4c6>
c0105752:	c7 44 24 0c 0c 9b 10 	movl   $0xc0109b0c,0xc(%esp)
c0105759:	c0 
c010575a:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105761:	c0 
c0105762:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105769:	00 
c010576a:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105771:	e8 66 b5 ff ff       	call   c0100cdc <__panic>
    assert(pa2page(*ptep) == p1);
c0105776:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105779:	8b 00                	mov    (%eax),%eax
c010577b:	89 04 24             	mov    %eax,(%esp)
c010577e:	e8 70 ec ff ff       	call   c01043f3 <pa2page>
c0105783:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105786:	74 24                	je     c01057ac <check_pgdir+0x4fc>
c0105788:	c7 44 24 0c 85 9a 10 	movl   $0xc0109a85,0xc(%esp)
c010578f:	c0 
c0105790:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105797:	c0 
c0105798:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c010579f:	00 
c01057a0:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01057a7:	e8 30 b5 ff ff       	call   c0100cdc <__panic>
    assert((*ptep & PTE_U) == 0);
c01057ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057af:	8b 00                	mov    (%eax),%eax
c01057b1:	83 e0 04             	and    $0x4,%eax
c01057b4:	85 c0                	test   %eax,%eax
c01057b6:	74 24                	je     c01057dc <check_pgdir+0x52c>
c01057b8:	c7 44 24 0c d0 9b 10 	movl   $0xc0109bd0,0xc(%esp)
c01057bf:	c0 
c01057c0:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01057c7:	c0 
c01057c8:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c01057cf:	00 
c01057d0:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01057d7:	e8 00 b5 ff ff       	call   c0100cdc <__panic>

    page_remove(boot_pgdir, 0x0);
c01057dc:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01057e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01057e8:	00 
c01057e9:	89 04 24             	mov    %eax,(%esp)
c01057ec:	e8 7c f8 ff ff       	call   c010506d <page_remove>
    assert(page_ref(p1) == 1);
c01057f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057f4:	89 04 24             	mov    %eax,(%esp)
c01057f7:	e8 18 ed ff ff       	call   c0104514 <page_ref>
c01057fc:	83 f8 01             	cmp    $0x1,%eax
c01057ff:	74 24                	je     c0105825 <check_pgdir+0x575>
c0105801:	c7 44 24 0c 9a 9a 10 	movl   $0xc0109a9a,0xc(%esp)
c0105808:	c0 
c0105809:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105810:	c0 
c0105811:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105818:	00 
c0105819:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105820:	e8 b7 b4 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 0);
c0105825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105828:	89 04 24             	mov    %eax,(%esp)
c010582b:	e8 e4 ec ff ff       	call   c0104514 <page_ref>
c0105830:	85 c0                	test   %eax,%eax
c0105832:	74 24                	je     c0105858 <check_pgdir+0x5a8>
c0105834:	c7 44 24 0c be 9b 10 	movl   $0xc0109bbe,0xc(%esp)
c010583b:	c0 
c010583c:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105843:	c0 
c0105844:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c010584b:	00 
c010584c:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105853:	e8 84 b4 ff ff       	call   c0100cdc <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105858:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010585d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105864:	00 
c0105865:	89 04 24             	mov    %eax,(%esp)
c0105868:	e8 00 f8 ff ff       	call   c010506d <page_remove>
    assert(page_ref(p1) == 0);
c010586d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105870:	89 04 24             	mov    %eax,(%esp)
c0105873:	e8 9c ec ff ff       	call   c0104514 <page_ref>
c0105878:	85 c0                	test   %eax,%eax
c010587a:	74 24                	je     c01058a0 <check_pgdir+0x5f0>
c010587c:	c7 44 24 0c e5 9b 10 	movl   $0xc0109be5,0xc(%esp)
c0105883:	c0 
c0105884:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c010588b:	c0 
c010588c:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105893:	00 
c0105894:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c010589b:	e8 3c b4 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 0);
c01058a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058a3:	89 04 24             	mov    %eax,(%esp)
c01058a6:	e8 69 ec ff ff       	call   c0104514 <page_ref>
c01058ab:	85 c0                	test   %eax,%eax
c01058ad:	74 24                	je     c01058d3 <check_pgdir+0x623>
c01058af:	c7 44 24 0c be 9b 10 	movl   $0xc0109bbe,0xc(%esp)
c01058b6:	c0 
c01058b7:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01058be:	c0 
c01058bf:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c01058c6:	00 
c01058c7:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01058ce:	e8 09 b4 ff ff       	call   c0100cdc <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c01058d3:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01058d8:	8b 00                	mov    (%eax),%eax
c01058da:	89 04 24             	mov    %eax,(%esp)
c01058dd:	e8 11 eb ff ff       	call   c01043f3 <pa2page>
c01058e2:	89 04 24             	mov    %eax,(%esp)
c01058e5:	e8 2a ec ff ff       	call   c0104514 <page_ref>
c01058ea:	83 f8 01             	cmp    $0x1,%eax
c01058ed:	74 24                	je     c0105913 <check_pgdir+0x663>
c01058ef:	c7 44 24 0c f8 9b 10 	movl   $0xc0109bf8,0xc(%esp)
c01058f6:	c0 
c01058f7:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01058fe:	c0 
c01058ff:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c0105906:	00 
c0105907:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c010590e:	e8 c9 b3 ff ff       	call   c0100cdc <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105913:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105918:	8b 00                	mov    (%eax),%eax
c010591a:	89 04 24             	mov    %eax,(%esp)
c010591d:	e8 d1 ea ff ff       	call   c01043f3 <pa2page>
c0105922:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105929:	00 
c010592a:	89 04 24             	mov    %eax,(%esp)
c010592d:	e8 52 ee ff ff       	call   c0104784 <free_pages>
    boot_pgdir[0] = 0;
c0105932:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105937:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c010593d:	c7 04 24 1e 9c 10 c0 	movl   $0xc0109c1e,(%esp)
c0105944:	e8 02 aa ff ff       	call   c010034b <cprintf>
}
c0105949:	c9                   	leave  
c010594a:	c3                   	ret    

c010594b <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010594b:	55                   	push   %ebp
c010594c:	89 e5                	mov    %esp,%ebp
c010594e:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105958:	e9 ca 00 00 00       	jmp    c0105a27 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c010595d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105960:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105963:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105966:	c1 e8 0c             	shr    $0xc,%eax
c0105969:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010596c:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105971:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105974:	72 23                	jb     c0105999 <check_boot_pgdir+0x4e>
c0105976:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105979:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010597d:	c7 44 24 08 54 98 10 	movl   $0xc0109854,0x8(%esp)
c0105984:	c0 
c0105985:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c010598c:	00 
c010598d:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105994:	e8 43 b3 ff ff       	call   c0100cdc <__panic>
c0105999:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010599c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01059a1:	89 c2                	mov    %eax,%edx
c01059a3:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01059a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059af:	00 
c01059b0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059b4:	89 04 24             	mov    %eax,(%esp)
c01059b7:	e8 bf f4 ff ff       	call   c0104e7b <get_pte>
c01059bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01059bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059c3:	75 24                	jne    c01059e9 <check_boot_pgdir+0x9e>
c01059c5:	c7 44 24 0c 38 9c 10 	movl   $0xc0109c38,0xc(%esp)
c01059cc:	c0 
c01059cd:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c01059d4:	c0 
c01059d5:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c01059dc:	00 
c01059dd:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c01059e4:	e8 f3 b2 ff ff       	call   c0100cdc <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01059e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059ec:	8b 00                	mov    (%eax),%eax
c01059ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01059f3:	89 c2                	mov    %eax,%edx
c01059f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059f8:	39 c2                	cmp    %eax,%edx
c01059fa:	74 24                	je     c0105a20 <check_boot_pgdir+0xd5>
c01059fc:	c7 44 24 0c 75 9c 10 	movl   $0xc0109c75,0xc(%esp)
c0105a03:	c0 
c0105a04:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105a0b:	c0 
c0105a0c:	c7 44 24 04 57 02 00 	movl   $0x257,0x4(%esp)
c0105a13:	00 
c0105a14:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105a1b:	e8 bc b2 ff ff       	call   c0100cdc <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105a20:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a2a:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105a2f:	39 c2                	cmp    %eax,%edx
c0105a31:	0f 82 26 ff ff ff    	jb     c010595d <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105a37:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105a3c:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105a41:	8b 00                	mov    (%eax),%eax
c0105a43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105a48:	89 c2                	mov    %eax,%edx
c0105a4a:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105a4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a52:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105a59:	77 23                	ja     c0105a7e <check_boot_pgdir+0x133>
c0105a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a62:	c7 44 24 08 78 98 10 	movl   $0xc0109878,0x8(%esp)
c0105a69:	c0 
c0105a6a:	c7 44 24 04 5a 02 00 	movl   $0x25a,0x4(%esp)
c0105a71:	00 
c0105a72:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105a79:	e8 5e b2 ff ff       	call   c0100cdc <__panic>
c0105a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a81:	05 00 00 00 40       	add    $0x40000000,%eax
c0105a86:	39 c2                	cmp    %eax,%edx
c0105a88:	74 24                	je     c0105aae <check_boot_pgdir+0x163>
c0105a8a:	c7 44 24 0c 8c 9c 10 	movl   $0xc0109c8c,0xc(%esp)
c0105a91:	c0 
c0105a92:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105a99:	c0 
c0105a9a:	c7 44 24 04 5a 02 00 	movl   $0x25a,0x4(%esp)
c0105aa1:	00 
c0105aa2:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105aa9:	e8 2e b2 ff ff       	call   c0100cdc <__panic>

    assert(boot_pgdir[0] == 0);
c0105aae:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105ab3:	8b 00                	mov    (%eax),%eax
c0105ab5:	85 c0                	test   %eax,%eax
c0105ab7:	74 24                	je     c0105add <check_boot_pgdir+0x192>
c0105ab9:	c7 44 24 0c c0 9c 10 	movl   $0xc0109cc0,0xc(%esp)
c0105ac0:	c0 
c0105ac1:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105ac8:	c0 
c0105ac9:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c0105ad0:	00 
c0105ad1:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105ad8:	e8 ff b1 ff ff       	call   c0100cdc <__panic>

    struct Page *p;
    p = alloc_page();
c0105add:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105ae4:	e8 30 ec ff ff       	call   c0104719 <alloc_pages>
c0105ae9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105aec:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105af1:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105af8:	00 
c0105af9:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105b00:	00 
c0105b01:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105b04:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b08:	89 04 24             	mov    %eax,(%esp)
c0105b0b:	e8 a1 f5 ff ff       	call   c01050b1 <page_insert>
c0105b10:	85 c0                	test   %eax,%eax
c0105b12:	74 24                	je     c0105b38 <check_boot_pgdir+0x1ed>
c0105b14:	c7 44 24 0c d4 9c 10 	movl   $0xc0109cd4,0xc(%esp)
c0105b1b:	c0 
c0105b1c:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105b23:	c0 
c0105b24:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c0105b2b:	00 
c0105b2c:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105b33:	e8 a4 b1 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p) == 1);
c0105b38:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b3b:	89 04 24             	mov    %eax,(%esp)
c0105b3e:	e8 d1 e9 ff ff       	call   c0104514 <page_ref>
c0105b43:	83 f8 01             	cmp    $0x1,%eax
c0105b46:	74 24                	je     c0105b6c <check_boot_pgdir+0x221>
c0105b48:	c7 44 24 0c 02 9d 10 	movl   $0xc0109d02,0xc(%esp)
c0105b4f:	c0 
c0105b50:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105b57:	c0 
c0105b58:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c0105b5f:	00 
c0105b60:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105b67:	e8 70 b1 ff ff       	call   c0100cdc <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105b6c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105b71:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105b78:	00 
c0105b79:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105b80:	00 
c0105b81:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105b84:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b88:	89 04 24             	mov    %eax,(%esp)
c0105b8b:	e8 21 f5 ff ff       	call   c01050b1 <page_insert>
c0105b90:	85 c0                	test   %eax,%eax
c0105b92:	74 24                	je     c0105bb8 <check_boot_pgdir+0x26d>
c0105b94:	c7 44 24 0c 14 9d 10 	movl   $0xc0109d14,0xc(%esp)
c0105b9b:	c0 
c0105b9c:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105ba3:	c0 
c0105ba4:	c7 44 24 04 62 02 00 	movl   $0x262,0x4(%esp)
c0105bab:	00 
c0105bac:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105bb3:	e8 24 b1 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p) == 2);
c0105bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105bbb:	89 04 24             	mov    %eax,(%esp)
c0105bbe:	e8 51 e9 ff ff       	call   c0104514 <page_ref>
c0105bc3:	83 f8 02             	cmp    $0x2,%eax
c0105bc6:	74 24                	je     c0105bec <check_boot_pgdir+0x2a1>
c0105bc8:	c7 44 24 0c 4b 9d 10 	movl   $0xc0109d4b,0xc(%esp)
c0105bcf:	c0 
c0105bd0:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105bd7:	c0 
c0105bd8:	c7 44 24 04 63 02 00 	movl   $0x263,0x4(%esp)
c0105bdf:	00 
c0105be0:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105be7:	e8 f0 b0 ff ff       	call   c0100cdc <__panic>

    const char *str = "ucore: Hello world!!";
c0105bec:	c7 45 dc 5c 9d 10 c0 	movl   $0xc0109d5c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105bf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bfa:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105c01:	e8 a3 2b 00 00       	call   c01087a9 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105c06:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105c0d:	00 
c0105c0e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105c15:	e8 08 2c 00 00       	call   c0108822 <strcmp>
c0105c1a:	85 c0                	test   %eax,%eax
c0105c1c:	74 24                	je     c0105c42 <check_boot_pgdir+0x2f7>
c0105c1e:	c7 44 24 0c 74 9d 10 	movl   $0xc0109d74,0xc(%esp)
c0105c25:	c0 
c0105c26:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105c2d:	c0 
c0105c2e:	c7 44 24 04 67 02 00 	movl   $0x267,0x4(%esp)
c0105c35:	00 
c0105c36:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105c3d:	e8 9a b0 ff ff       	call   c0100cdc <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c45:	89 04 24             	mov    %eax,(%esp)
c0105c48:	e8 eb e7 ff ff       	call   c0104438 <page2kva>
c0105c4d:	05 00 01 00 00       	add    $0x100,%eax
c0105c52:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105c55:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105c5c:	e8 f0 2a 00 00       	call   c0108751 <strlen>
c0105c61:	85 c0                	test   %eax,%eax
c0105c63:	74 24                	je     c0105c89 <check_boot_pgdir+0x33e>
c0105c65:	c7 44 24 0c ac 9d 10 	movl   $0xc0109dac,0xc(%esp)
c0105c6c:	c0 
c0105c6d:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105c74:	c0 
c0105c75:	c7 44 24 04 6a 02 00 	movl   $0x26a,0x4(%esp)
c0105c7c:	00 
c0105c7d:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105c84:	e8 53 b0 ff ff       	call   c0100cdc <__panic>

    free_page(p);
c0105c89:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c90:	00 
c0105c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c94:	89 04 24             	mov    %eax,(%esp)
c0105c97:	e8 e8 ea ff ff       	call   c0104784 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105c9c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105ca1:	8b 00                	mov    (%eax),%eax
c0105ca3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105ca8:	89 04 24             	mov    %eax,(%esp)
c0105cab:	e8 43 e7 ff ff       	call   c01043f3 <pa2page>
c0105cb0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105cb7:	00 
c0105cb8:	89 04 24             	mov    %eax,(%esp)
c0105cbb:	e8 c4 ea ff ff       	call   c0104784 <free_pages>
    boot_pgdir[0] = 0;
c0105cc0:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105cc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105ccb:	c7 04 24 d0 9d 10 c0 	movl   $0xc0109dd0,(%esp)
c0105cd2:	e8 74 a6 ff ff       	call   c010034b <cprintf>
}
c0105cd7:	c9                   	leave  
c0105cd8:	c3                   	ret    

c0105cd9 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105cd9:	55                   	push   %ebp
c0105cda:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdf:	83 e0 04             	and    $0x4,%eax
c0105ce2:	85 c0                	test   %eax,%eax
c0105ce4:	74 07                	je     c0105ced <perm2str+0x14>
c0105ce6:	b8 75 00 00 00       	mov    $0x75,%eax
c0105ceb:	eb 05                	jmp    c0105cf2 <perm2str+0x19>
c0105ced:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105cf2:	a2 a8 1a 12 c0       	mov    %al,0xc0121aa8
    str[1] = 'r';
c0105cf7:	c6 05 a9 1a 12 c0 72 	movb   $0x72,0xc0121aa9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105cfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d01:	83 e0 02             	and    $0x2,%eax
c0105d04:	85 c0                	test   %eax,%eax
c0105d06:	74 07                	je     c0105d0f <perm2str+0x36>
c0105d08:	b8 77 00 00 00       	mov    $0x77,%eax
c0105d0d:	eb 05                	jmp    c0105d14 <perm2str+0x3b>
c0105d0f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105d14:	a2 aa 1a 12 c0       	mov    %al,0xc0121aaa
    str[3] = '\0';
c0105d19:	c6 05 ab 1a 12 c0 00 	movb   $0x0,0xc0121aab
    return str;
c0105d20:	b8 a8 1a 12 c0       	mov    $0xc0121aa8,%eax
}
c0105d25:	5d                   	pop    %ebp
c0105d26:	c3                   	ret    

c0105d27 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105d27:	55                   	push   %ebp
c0105d28:	89 e5                	mov    %esp,%ebp
c0105d2a:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105d2d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d30:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d33:	72 0a                	jb     c0105d3f <get_pgtable_items+0x18>
        return 0;
c0105d35:	b8 00 00 00 00       	mov    $0x0,%eax
c0105d3a:	e9 9c 00 00 00       	jmp    c0105ddb <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105d3f:	eb 04                	jmp    c0105d45 <get_pgtable_items+0x1e>
        start ++;
c0105d41:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105d45:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d48:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d4b:	73 18                	jae    c0105d65 <get_pgtable_items+0x3e>
c0105d4d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d57:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d5a:	01 d0                	add    %edx,%eax
c0105d5c:	8b 00                	mov    (%eax),%eax
c0105d5e:	83 e0 01             	and    $0x1,%eax
c0105d61:	85 c0                	test   %eax,%eax
c0105d63:	74 dc                	je     c0105d41 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105d65:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d68:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d6b:	73 69                	jae    c0105dd6 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105d6d:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105d71:	74 08                	je     c0105d7b <get_pgtable_items+0x54>
            *left_store = start;
c0105d73:	8b 45 18             	mov    0x18(%ebp),%eax
c0105d76:	8b 55 10             	mov    0x10(%ebp),%edx
c0105d79:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105d7b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d7e:	8d 50 01             	lea    0x1(%eax),%edx
c0105d81:	89 55 10             	mov    %edx,0x10(%ebp)
c0105d84:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d8b:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d8e:	01 d0                	add    %edx,%eax
c0105d90:	8b 00                	mov    (%eax),%eax
c0105d92:	83 e0 07             	and    $0x7,%eax
c0105d95:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105d98:	eb 04                	jmp    c0105d9e <get_pgtable_items+0x77>
            start ++;
c0105d9a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105d9e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105da1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105da4:	73 1d                	jae    c0105dc3 <get_pgtable_items+0x9c>
c0105da6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105da9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105db0:	8b 45 14             	mov    0x14(%ebp),%eax
c0105db3:	01 d0                	add    %edx,%eax
c0105db5:	8b 00                	mov    (%eax),%eax
c0105db7:	83 e0 07             	and    $0x7,%eax
c0105dba:	89 c2                	mov    %eax,%edx
c0105dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dbf:	39 c2                	cmp    %eax,%edx
c0105dc1:	74 d7                	je     c0105d9a <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105dc3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105dc7:	74 08                	je     c0105dd1 <get_pgtable_items+0xaa>
            *right_store = start;
c0105dc9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105dcc:	8b 55 10             	mov    0x10(%ebp),%edx
c0105dcf:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dd4:	eb 05                	jmp    c0105ddb <get_pgtable_items+0xb4>
    }
    return 0;
c0105dd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ddb:	c9                   	leave  
c0105ddc:	c3                   	ret    

c0105ddd <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105ddd:	55                   	push   %ebp
c0105dde:	89 e5                	mov    %esp,%ebp
c0105de0:	57                   	push   %edi
c0105de1:	56                   	push   %esi
c0105de2:	53                   	push   %ebx
c0105de3:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105de6:	c7 04 24 f0 9d 10 c0 	movl   $0xc0109df0,(%esp)
c0105ded:	e8 59 a5 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
c0105df2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105df9:	e9 fa 00 00 00       	jmp    c0105ef8 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105dfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e01:	89 04 24             	mov    %eax,(%esp)
c0105e04:	e8 d0 fe ff ff       	call   c0105cd9 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105e09:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105e0f:	29 d1                	sub    %edx,%ecx
c0105e11:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105e13:	89 d6                	mov    %edx,%esi
c0105e15:	c1 e6 16             	shl    $0x16,%esi
c0105e18:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105e1b:	89 d3                	mov    %edx,%ebx
c0105e1d:	c1 e3 16             	shl    $0x16,%ebx
c0105e20:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105e23:	89 d1                	mov    %edx,%ecx
c0105e25:	c1 e1 16             	shl    $0x16,%ecx
c0105e28:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105e2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105e2e:	29 d7                	sub    %edx,%edi
c0105e30:	89 fa                	mov    %edi,%edx
c0105e32:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105e36:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105e3a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105e3e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105e42:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e46:	c7 04 24 21 9e 10 c0 	movl   $0xc0109e21,(%esp)
c0105e4d:	e8 f9 a4 ff ff       	call   c010034b <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105e52:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e55:	c1 e0 0a             	shl    $0xa,%eax
c0105e58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105e5b:	eb 54                	jmp    c0105eb1 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105e5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e60:	89 04 24             	mov    %eax,(%esp)
c0105e63:	e8 71 fe ff ff       	call   c0105cd9 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105e68:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105e6b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e6e:	29 d1                	sub    %edx,%ecx
c0105e70:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105e72:	89 d6                	mov    %edx,%esi
c0105e74:	c1 e6 0c             	shl    $0xc,%esi
c0105e77:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105e7a:	89 d3                	mov    %edx,%ebx
c0105e7c:	c1 e3 0c             	shl    $0xc,%ebx
c0105e7f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e82:	c1 e2 0c             	shl    $0xc,%edx
c0105e85:	89 d1                	mov    %edx,%ecx
c0105e87:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105e8a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e8d:	29 d7                	sub    %edx,%edi
c0105e8f:	89 fa                	mov    %edi,%edx
c0105e91:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105e95:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105e99:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105e9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105ea1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ea5:	c7 04 24 40 9e 10 c0 	movl   $0xc0109e40,(%esp)
c0105eac:	e8 9a a4 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105eb1:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105eb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105eb9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105ebc:	89 ce                	mov    %ecx,%esi
c0105ebe:	c1 e6 0a             	shl    $0xa,%esi
c0105ec1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105ec4:	89 cb                	mov    %ecx,%ebx
c0105ec6:	c1 e3 0a             	shl    $0xa,%ebx
c0105ec9:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105ecc:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105ed0:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105ed3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105ed7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105edb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105edf:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105ee3:	89 1c 24             	mov    %ebx,(%esp)
c0105ee6:	e8 3c fe ff ff       	call   c0105d27 <get_pgtable_items>
c0105eeb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105eee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105ef2:	0f 85 65 ff ff ff    	jne    c0105e5d <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105ef8:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105efd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f00:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105f03:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105f07:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105f0a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105f0e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105f12:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f16:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105f1d:	00 
c0105f1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105f25:	e8 fd fd ff ff       	call   c0105d27 <get_pgtable_items>
c0105f2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105f2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105f31:	0f 85 c7 fe ff ff    	jne    c0105dfe <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105f37:	c7 04 24 64 9e 10 c0 	movl   $0xc0109e64,(%esp)
c0105f3e:	e8 08 a4 ff ff       	call   c010034b <cprintf>
}
c0105f43:	83 c4 4c             	add    $0x4c,%esp
c0105f46:	5b                   	pop    %ebx
c0105f47:	5e                   	pop    %esi
c0105f48:	5f                   	pop    %edi
c0105f49:	5d                   	pop    %ebp
c0105f4a:	c3                   	ret    

c0105f4b <kmalloc>:

void *
kmalloc(size_t n) {
c0105f4b:	55                   	push   %ebp
c0105f4c:	89 e5                	mov    %esp,%ebp
c0105f4e:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105f51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105f58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105f5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105f63:	74 09                	je     c0105f6e <kmalloc+0x23>
c0105f65:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105f6c:	76 24                	jbe    c0105f92 <kmalloc+0x47>
c0105f6e:	c7 44 24 0c 95 9e 10 	movl   $0xc0109e95,0xc(%esp)
c0105f75:	c0 
c0105f76:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105f7d:	c0 
c0105f7e:	c7 44 24 04 b6 02 00 	movl   $0x2b6,0x4(%esp)
c0105f85:	00 
c0105f86:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105f8d:	e8 4a ad ff ff       	call   c0100cdc <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105f92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f95:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105f9a:	c1 e8 0c             	shr    $0xc,%eax
c0105f9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fa3:	89 04 24             	mov    %eax,(%esp)
c0105fa6:	e8 6e e7 ff ff       	call   c0104719 <alloc_pages>
c0105fab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105fae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105fb2:	75 24                	jne    c0105fd8 <kmalloc+0x8d>
c0105fb4:	c7 44 24 0c ac 9e 10 	movl   $0xc0109eac,0xc(%esp)
c0105fbb:	c0 
c0105fbc:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0105fc3:	c0 
c0105fc4:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c0105fcb:	00 
c0105fcc:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0105fd3:	e8 04 ad ff ff       	call   c0100cdc <__panic>
    ptr=page2kva(base);
c0105fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fdb:	89 04 24             	mov    %eax,(%esp)
c0105fde:	e8 55 e4 ff ff       	call   c0104438 <page2kva>
c0105fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0105fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105fe9:	c9                   	leave  
c0105fea:	c3                   	ret    

c0105feb <kfree>:

void 
kfree(void *ptr, size_t n) {
c0105feb:	55                   	push   %ebp
c0105fec:	89 e5                	mov    %esp,%ebp
c0105fee:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0105ff1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105ff5:	74 09                	je     c0106000 <kfree+0x15>
c0105ff7:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0105ffe:	76 24                	jbe    c0106024 <kfree+0x39>
c0106000:	c7 44 24 0c 95 9e 10 	movl   $0xc0109e95,0xc(%esp)
c0106007:	c0 
c0106008:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c010600f:	c0 
c0106010:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c0106017:	00 
c0106018:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c010601f:	e8 b8 ac ff ff       	call   c0100cdc <__panic>
    assert(ptr != NULL);
c0106024:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106028:	75 24                	jne    c010604e <kfree+0x63>
c010602a:	c7 44 24 0c b9 9e 10 	movl   $0xc0109eb9,0xc(%esp)
c0106031:	c0 
c0106032:	c7 44 24 08 41 99 10 	movl   $0xc0109941,0x8(%esp)
c0106039:	c0 
c010603a:	c7 44 24 04 c1 02 00 	movl   $0x2c1,0x4(%esp)
c0106041:	00 
c0106042:	c7 04 24 1c 99 10 c0 	movl   $0xc010991c,(%esp)
c0106049:	e8 8e ac ff ff       	call   c0100cdc <__panic>
    struct Page *base=NULL;
c010604e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0106055:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106058:	05 ff 0f 00 00       	add    $0xfff,%eax
c010605d:	c1 e8 0c             	shr    $0xc,%eax
c0106060:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0106063:	8b 45 08             	mov    0x8(%ebp),%eax
c0106066:	89 04 24             	mov    %eax,(%esp)
c0106069:	e8 1e e4 ff ff       	call   c010448c <kva2page>
c010606e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0106071:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106074:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106078:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010607b:	89 04 24             	mov    %eax,(%esp)
c010607e:	e8 01 e7 ff ff       	call   c0104784 <free_pages>
}
c0106083:	c9                   	leave  
c0106084:	c3                   	ret    

c0106085 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106085:	55                   	push   %ebp
c0106086:	89 e5                	mov    %esp,%ebp
c0106088:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010608b:	8b 45 08             	mov    0x8(%ebp),%eax
c010608e:	c1 e8 0c             	shr    $0xc,%eax
c0106091:	89 c2                	mov    %eax,%edx
c0106093:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0106098:	39 c2                	cmp    %eax,%edx
c010609a:	72 1c                	jb     c01060b8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010609c:	c7 44 24 08 c8 9e 10 	movl   $0xc0109ec8,0x8(%esp)
c01060a3:	c0 
c01060a4:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01060ab:	00 
c01060ac:	c7 04 24 e7 9e 10 c0 	movl   $0xc0109ee7,(%esp)
c01060b3:	e8 24 ac ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c01060b8:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01060bd:	8b 55 08             	mov    0x8(%ebp),%edx
c01060c0:	c1 ea 0c             	shr    $0xc,%edx
c01060c3:	c1 e2 05             	shl    $0x5,%edx
c01060c6:	01 d0                	add    %edx,%eax
}
c01060c8:	c9                   	leave  
c01060c9:	c3                   	ret    

c01060ca <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01060ca:	55                   	push   %ebp
c01060cb:	89 e5                	mov    %esp,%ebp
c01060cd:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01060d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01060d3:	83 e0 01             	and    $0x1,%eax
c01060d6:	85 c0                	test   %eax,%eax
c01060d8:	75 1c                	jne    c01060f6 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01060da:	c7 44 24 08 f8 9e 10 	movl   $0xc0109ef8,0x8(%esp)
c01060e1:	c0 
c01060e2:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01060e9:	00 
c01060ea:	c7 04 24 e7 9e 10 c0 	movl   $0xc0109ee7,(%esp)
c01060f1:	e8 e6 ab ff ff       	call   c0100cdc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01060f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01060f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01060fe:	89 04 24             	mov    %eax,(%esp)
c0106101:	e8 7f ff ff ff       	call   c0106085 <pa2page>
}
c0106106:	c9                   	leave  
c0106107:	c3                   	ret    

c0106108 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106108:	55                   	push   %ebp
c0106109:	89 e5                	mov    %esp,%ebp
c010610b:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c010610e:	e8 b9 1d 00 00       	call   c0107ecc <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106113:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c0106118:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c010611d:	76 0c                	jbe    c010612b <swap_init+0x23>
c010611f:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c0106124:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106129:	76 25                	jbe    c0106150 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c010612b:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c0106130:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106134:	c7 44 24 08 19 9f 10 	movl   $0xc0109f19,0x8(%esp)
c010613b:	c0 
c010613c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c0106143:	00 
c0106144:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c010614b:	e8 8c ab ff ff       	call   c0100cdc <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106150:	c7 05 b4 1a 12 c0 40 	movl   $0xc0120a40,0xc0121ab4
c0106157:	0a 12 c0 
     int r = sm->init();
c010615a:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010615f:	8b 40 04             	mov    0x4(%eax),%eax
c0106162:	ff d0                	call   *%eax
c0106164:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010616b:	75 26                	jne    c0106193 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c010616d:	c7 05 ac 1a 12 c0 01 	movl   $0x1,0xc0121aac
c0106174:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106177:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010617c:	8b 00                	mov    (%eax),%eax
c010617e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106182:	c7 04 24 43 9f 10 c0 	movl   $0xc0109f43,(%esp)
c0106189:	e8 bd a1 ff ff       	call   c010034b <cprintf>
          check_swap();
c010618e:	e8 a4 04 00 00       	call   c0106637 <check_swap>
     }

     return r;
c0106193:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106196:	c9                   	leave  
c0106197:	c3                   	ret    

c0106198 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106198:	55                   	push   %ebp
c0106199:	89 e5                	mov    %esp,%ebp
c010619b:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c010619e:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01061a3:	8b 40 08             	mov    0x8(%eax),%eax
c01061a6:	8b 55 08             	mov    0x8(%ebp),%edx
c01061a9:	89 14 24             	mov    %edx,(%esp)
c01061ac:	ff d0                	call   *%eax
}
c01061ae:	c9                   	leave  
c01061af:	c3                   	ret    

c01061b0 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c01061b0:	55                   	push   %ebp
c01061b1:	89 e5                	mov    %esp,%ebp
c01061b3:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c01061b6:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01061bb:	8b 40 0c             	mov    0xc(%eax),%eax
c01061be:	8b 55 08             	mov    0x8(%ebp),%edx
c01061c1:	89 14 24             	mov    %edx,(%esp)
c01061c4:	ff d0                	call   *%eax
}
c01061c6:	c9                   	leave  
c01061c7:	c3                   	ret    

c01061c8 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01061c8:	55                   	push   %ebp
c01061c9:	89 e5                	mov    %esp,%ebp
c01061cb:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c01061ce:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01061d3:	8b 40 10             	mov    0x10(%eax),%eax
c01061d6:	8b 55 14             	mov    0x14(%ebp),%edx
c01061d9:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01061dd:	8b 55 10             	mov    0x10(%ebp),%edx
c01061e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01061e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01061e7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01061ee:	89 14 24             	mov    %edx,(%esp)
c01061f1:	ff d0                	call   *%eax
}
c01061f3:	c9                   	leave  
c01061f4:	c3                   	ret    

c01061f5 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01061f5:	55                   	push   %ebp
c01061f6:	89 e5                	mov    %esp,%ebp
c01061f8:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c01061fb:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106200:	8b 40 14             	mov    0x14(%eax),%eax
c0106203:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106206:	89 54 24 04          	mov    %edx,0x4(%esp)
c010620a:	8b 55 08             	mov    0x8(%ebp),%edx
c010620d:	89 14 24             	mov    %edx,(%esp)
c0106210:	ff d0                	call   *%eax
}
c0106212:	c9                   	leave  
c0106213:	c3                   	ret    

c0106214 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106214:	55                   	push   %ebp
c0106215:	89 e5                	mov    %esp,%ebp
c0106217:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c010621a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106221:	e9 5a 01 00 00       	jmp    c0106380 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106226:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010622b:	8b 40 18             	mov    0x18(%eax),%eax
c010622e:	8b 55 10             	mov    0x10(%ebp),%edx
c0106231:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106235:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106238:	89 54 24 04          	mov    %edx,0x4(%esp)
c010623c:	8b 55 08             	mov    0x8(%ebp),%edx
c010623f:	89 14 24             	mov    %edx,(%esp)
c0106242:	ff d0                	call   *%eax
c0106244:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106247:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010624b:	74 18                	je     c0106265 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c010624d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106250:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106254:	c7 04 24 58 9f 10 c0 	movl   $0xc0109f58,(%esp)
c010625b:	e8 eb a0 ff ff       	call   c010034b <cprintf>
c0106260:	e9 27 01 00 00       	jmp    c010638c <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106268:	8b 40 1c             	mov    0x1c(%eax),%eax
c010626b:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c010626e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106271:	8b 40 0c             	mov    0xc(%eax),%eax
c0106274:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010627b:	00 
c010627c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010627f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106283:	89 04 24             	mov    %eax,(%esp)
c0106286:	e8 f0 eb ff ff       	call   c0104e7b <get_pte>
c010628b:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c010628e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106291:	8b 00                	mov    (%eax),%eax
c0106293:	83 e0 01             	and    $0x1,%eax
c0106296:	85 c0                	test   %eax,%eax
c0106298:	75 24                	jne    c01062be <swap_out+0xaa>
c010629a:	c7 44 24 0c 85 9f 10 	movl   $0xc0109f85,0xc(%esp)
c01062a1:	c0 
c01062a2:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c01062a9:	c0 
c01062aa:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01062b1:	00 
c01062b2:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c01062b9:	e8 1e aa ff ff       	call   c0100cdc <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c01062be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01062c4:	8b 52 1c             	mov    0x1c(%edx),%edx
c01062c7:	c1 ea 0c             	shr    $0xc,%edx
c01062ca:	83 c2 01             	add    $0x1,%edx
c01062cd:	c1 e2 08             	shl    $0x8,%edx
c01062d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062d4:	89 14 24             	mov    %edx,(%esp)
c01062d7:	e8 aa 1c 00 00       	call   c0107f86 <swapfs_write>
c01062dc:	85 c0                	test   %eax,%eax
c01062de:	74 34                	je     c0106314 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c01062e0:	c7 04 24 af 9f 10 c0 	movl   $0xc0109faf,(%esp)
c01062e7:	e8 5f a0 ff ff       	call   c010034b <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c01062ec:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01062f1:	8b 40 10             	mov    0x10(%eax),%eax
c01062f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01062f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01062fe:	00 
c01062ff:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106303:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106306:	89 54 24 04          	mov    %edx,0x4(%esp)
c010630a:	8b 55 08             	mov    0x8(%ebp),%edx
c010630d:	89 14 24             	mov    %edx,(%esp)
c0106310:	ff d0                	call   *%eax
c0106312:	eb 68                	jmp    c010637c <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106317:	8b 40 1c             	mov    0x1c(%eax),%eax
c010631a:	c1 e8 0c             	shr    $0xc,%eax
c010631d:	83 c0 01             	add    $0x1,%eax
c0106320:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106324:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106327:	89 44 24 08          	mov    %eax,0x8(%esp)
c010632b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010632e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106332:	c7 04 24 c8 9f 10 c0 	movl   $0xc0109fc8,(%esp)
c0106339:	e8 0d a0 ff ff       	call   c010034b <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c010633e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106341:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106344:	c1 e8 0c             	shr    $0xc,%eax
c0106347:	83 c0 01             	add    $0x1,%eax
c010634a:	c1 e0 08             	shl    $0x8,%eax
c010634d:	89 c2                	mov    %eax,%edx
c010634f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106352:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106354:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106357:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010635e:	00 
c010635f:	89 04 24             	mov    %eax,(%esp)
c0106362:	e8 1d e4 ff ff       	call   c0104784 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106367:	8b 45 08             	mov    0x8(%ebp),%eax
c010636a:	8b 40 0c             	mov    0xc(%eax),%eax
c010636d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106370:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106374:	89 04 24             	mov    %eax,(%esp)
c0106377:	e8 ee ed ff ff       	call   c010516a <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c010637c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106380:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106383:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106386:	0f 85 9a fe ff ff    	jne    c0106226 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c010638c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010638f:	c9                   	leave  
c0106390:	c3                   	ret    

c0106391 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106391:	55                   	push   %ebp
c0106392:	89 e5                	mov    %esp,%ebp
c0106394:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106397:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010639e:	e8 76 e3 ff ff       	call   c0104719 <alloc_pages>
c01063a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01063a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01063aa:	75 24                	jne    c01063d0 <swap_in+0x3f>
c01063ac:	c7 44 24 0c 08 a0 10 	movl   $0xc010a008,0xc(%esp)
c01063b3:	c0 
c01063b4:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c01063bb:	c0 
c01063bc:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c01063c3:	00 
c01063c4:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c01063cb:	e8 0c a9 ff ff       	call   c0100cdc <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c01063d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01063d3:	8b 40 0c             	mov    0xc(%eax),%eax
c01063d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01063dd:	00 
c01063de:	8b 55 0c             	mov    0xc(%ebp),%edx
c01063e1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063e5:	89 04 24             	mov    %eax,(%esp)
c01063e8:	e8 8e ea ff ff       	call   c0104e7b <get_pte>
c01063ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c01063f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063f3:	8b 00                	mov    (%eax),%eax
c01063f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01063f8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063fc:	89 04 24             	mov    %eax,(%esp)
c01063ff:	e8 10 1b 00 00       	call   c0107f14 <swapfs_read>
c0106404:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106407:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010640b:	74 2a                	je     c0106437 <swap_in+0xa6>
     {
        assert(r!=0);
c010640d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106411:	75 24                	jne    c0106437 <swap_in+0xa6>
c0106413:	c7 44 24 0c 15 a0 10 	movl   $0xc010a015,0xc(%esp)
c010641a:	c0 
c010641b:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106422:	c0 
c0106423:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c010642a:	00 
c010642b:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106432:	e8 a5 a8 ff ff       	call   c0100cdc <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106437:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010643a:	8b 00                	mov    (%eax),%eax
c010643c:	c1 e8 08             	shr    $0x8,%eax
c010643f:	89 c2                	mov    %eax,%edx
c0106441:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106444:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106448:	89 54 24 04          	mov    %edx,0x4(%esp)
c010644c:	c7 04 24 1c a0 10 c0 	movl   $0xc010a01c,(%esp)
c0106453:	e8 f3 9e ff ff       	call   c010034b <cprintf>
     *ptr_result=result;
c0106458:	8b 45 10             	mov    0x10(%ebp),%eax
c010645b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010645e:	89 10                	mov    %edx,(%eax)
     return 0;
c0106460:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106465:	c9                   	leave  
c0106466:	c3                   	ret    

c0106467 <check_content_set>:



static inline void
check_content_set(void)
{
c0106467:	55                   	push   %ebp
c0106468:	89 e5                	mov    %esp,%ebp
c010646a:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c010646d:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106472:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106475:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010647a:	83 f8 01             	cmp    $0x1,%eax
c010647d:	74 24                	je     c01064a3 <check_content_set+0x3c>
c010647f:	c7 44 24 0c 5a a0 10 	movl   $0xc010a05a,0xc(%esp)
c0106486:	c0 
c0106487:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c010648e:	c0 
c010648f:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106496:	00 
c0106497:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c010649e:	e8 39 a8 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01064a3:	b8 10 10 00 00       	mov    $0x1010,%eax
c01064a8:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01064ab:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01064b0:	83 f8 01             	cmp    $0x1,%eax
c01064b3:	74 24                	je     c01064d9 <check_content_set+0x72>
c01064b5:	c7 44 24 0c 5a a0 10 	movl   $0xc010a05a,0xc(%esp)
c01064bc:	c0 
c01064bd:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c01064c4:	c0 
c01064c5:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01064cc:	00 
c01064cd:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c01064d4:	e8 03 a8 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01064d9:	b8 00 20 00 00       	mov    $0x2000,%eax
c01064de:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01064e1:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01064e6:	83 f8 02             	cmp    $0x2,%eax
c01064e9:	74 24                	je     c010650f <check_content_set+0xa8>
c01064eb:	c7 44 24 0c 69 a0 10 	movl   $0xc010a069,0xc(%esp)
c01064f2:	c0 
c01064f3:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c01064fa:	c0 
c01064fb:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106502:	00 
c0106503:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c010650a:	e8 cd a7 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c010650f:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106514:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106517:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010651c:	83 f8 02             	cmp    $0x2,%eax
c010651f:	74 24                	je     c0106545 <check_content_set+0xde>
c0106521:	c7 44 24 0c 69 a0 10 	movl   $0xc010a069,0xc(%esp)
c0106528:	c0 
c0106529:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106530:	c0 
c0106531:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106538:	00 
c0106539:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106540:	e8 97 a7 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106545:	b8 00 30 00 00       	mov    $0x3000,%eax
c010654a:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c010654d:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106552:	83 f8 03             	cmp    $0x3,%eax
c0106555:	74 24                	je     c010657b <check_content_set+0x114>
c0106557:	c7 44 24 0c 78 a0 10 	movl   $0xc010a078,0xc(%esp)
c010655e:	c0 
c010655f:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106566:	c0 
c0106567:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c010656e:	00 
c010656f:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106576:	e8 61 a7 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c010657b:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106580:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106583:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106588:	83 f8 03             	cmp    $0x3,%eax
c010658b:	74 24                	je     c01065b1 <check_content_set+0x14a>
c010658d:	c7 44 24 0c 78 a0 10 	movl   $0xc010a078,0xc(%esp)
c0106594:	c0 
c0106595:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c010659c:	c0 
c010659d:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c01065a4:	00 
c01065a5:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c01065ac:	e8 2b a7 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01065b1:	b8 00 40 00 00       	mov    $0x4000,%eax
c01065b6:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01065b9:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01065be:	83 f8 04             	cmp    $0x4,%eax
c01065c1:	74 24                	je     c01065e7 <check_content_set+0x180>
c01065c3:	c7 44 24 0c 87 a0 10 	movl   $0xc010a087,0xc(%esp)
c01065ca:	c0 
c01065cb:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c01065d2:	c0 
c01065d3:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01065da:	00 
c01065db:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c01065e2:	e8 f5 a6 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c01065e7:	b8 10 40 00 00       	mov    $0x4010,%eax
c01065ec:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01065ef:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01065f4:	83 f8 04             	cmp    $0x4,%eax
c01065f7:	74 24                	je     c010661d <check_content_set+0x1b6>
c01065f9:	c7 44 24 0c 87 a0 10 	movl   $0xc010a087,0xc(%esp)
c0106600:	c0 
c0106601:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106608:	c0 
c0106609:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106610:	00 
c0106611:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106618:	e8 bf a6 ff ff       	call   c0100cdc <__panic>
}
c010661d:	c9                   	leave  
c010661e:	c3                   	ret    

c010661f <check_content_access>:

static inline int
check_content_access(void)
{
c010661f:	55                   	push   %ebp
c0106620:	89 e5                	mov    %esp,%ebp
c0106622:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106625:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010662a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010662d:	ff d0                	call   *%eax
c010662f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106632:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106635:	c9                   	leave  
c0106636:	c3                   	ret    

c0106637 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106637:	55                   	push   %ebp
c0106638:	89 e5                	mov    %esp,%ebp
c010663a:	53                   	push   %ebx
c010663b:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010663e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106645:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c010664c:	c7 45 e8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106653:	eb 6b                	jmp    c01066c0 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106655:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106658:	83 e8 0c             	sub    $0xc,%eax
c010665b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c010665e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106661:	83 c0 04             	add    $0x4,%eax
c0106664:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010666b:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010666e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106671:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106674:	0f a3 10             	bt     %edx,(%eax)
c0106677:	19 c0                	sbb    %eax,%eax
c0106679:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c010667c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106680:	0f 95 c0             	setne  %al
c0106683:	0f b6 c0             	movzbl %al,%eax
c0106686:	85 c0                	test   %eax,%eax
c0106688:	75 24                	jne    c01066ae <check_swap+0x77>
c010668a:	c7 44 24 0c 96 a0 10 	movl   $0xc010a096,0xc(%esp)
c0106691:	c0 
c0106692:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106699:	c0 
c010669a:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01066a1:	00 
c01066a2:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c01066a9:	e8 2e a6 ff ff       	call   c0100cdc <__panic>
        count ++, total += p->property;
c01066ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01066b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01066b5:	8b 50 08             	mov    0x8(%eax),%edx
c01066b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066bb:	01 d0                	add    %edx,%eax
c01066bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01066c3:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01066c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01066c9:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01066cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01066cf:	81 7d e8 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x18(%ebp)
c01066d6:	0f 85 79 ff ff ff    	jne    c0106655 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01066dc:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01066df:	e8 d2 e0 ff ff       	call   c01047b6 <nr_free_pages>
c01066e4:	39 c3                	cmp    %eax,%ebx
c01066e6:	74 24                	je     c010670c <check_swap+0xd5>
c01066e8:	c7 44 24 0c a6 a0 10 	movl   $0xc010a0a6,0xc(%esp)
c01066ef:	c0 
c01066f0:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c01066f7:	c0 
c01066f8:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01066ff:	00 
c0106700:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106707:	e8 d0 a5 ff ff       	call   c0100cdc <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010670c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010670f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106713:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106716:	89 44 24 04          	mov    %eax,0x4(%esp)
c010671a:	c7 04 24 c0 a0 10 c0 	movl   $0xc010a0c0,(%esp)
c0106721:	e8 25 9c ff ff       	call   c010034b <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106726:	e8 e7 09 00 00       	call   c0107112 <mm_create>
c010672b:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c010672e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106732:	75 24                	jne    c0106758 <check_swap+0x121>
c0106734:	c7 44 24 0c e6 a0 10 	movl   $0xc010a0e6,0xc(%esp)
c010673b:	c0 
c010673c:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106743:	c0 
c0106744:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c010674b:	00 
c010674c:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106753:	e8 84 a5 ff ff       	call   c0100cdc <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106758:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c010675d:	85 c0                	test   %eax,%eax
c010675f:	74 24                	je     c0106785 <check_swap+0x14e>
c0106761:	c7 44 24 0c f1 a0 10 	movl   $0xc010a0f1,0xc(%esp)
c0106768:	c0 
c0106769:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106770:	c0 
c0106771:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106778:	00 
c0106779:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106780:	e8 57 a5 ff ff       	call   c0100cdc <__panic>

     check_mm_struct = mm;
c0106785:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106788:	a3 ac 1b 12 c0       	mov    %eax,0xc0121bac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010678d:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0106793:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106796:	89 50 0c             	mov    %edx,0xc(%eax)
c0106799:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010679c:	8b 40 0c             	mov    0xc(%eax),%eax
c010679f:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c01067a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01067a5:	8b 00                	mov    (%eax),%eax
c01067a7:	85 c0                	test   %eax,%eax
c01067a9:	74 24                	je     c01067cf <check_swap+0x198>
c01067ab:	c7 44 24 0c 09 a1 10 	movl   $0xc010a109,0xc(%esp)
c01067b2:	c0 
c01067b3:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c01067ba:	c0 
c01067bb:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01067c2:	00 
c01067c3:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c01067ca:	e8 0d a5 ff ff       	call   c0100cdc <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01067cf:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c01067d6:	00 
c01067d7:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c01067de:	00 
c01067df:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c01067e6:	e8 9f 09 00 00       	call   c010718a <vma_create>
c01067eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c01067ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01067f2:	75 24                	jne    c0106818 <check_swap+0x1e1>
c01067f4:	c7 44 24 0c 17 a1 10 	movl   $0xc010a117,0xc(%esp)
c01067fb:	c0 
c01067fc:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106803:	c0 
c0106804:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010680b:	00 
c010680c:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106813:	e8 c4 a4 ff ff       	call   c0100cdc <__panic>

     insert_vma_struct(mm, vma);
c0106818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010681b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010681f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106822:	89 04 24             	mov    %eax,(%esp)
c0106825:	e8 f0 0a 00 00       	call   c010731a <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c010682a:	c7 04 24 24 a1 10 c0 	movl   $0xc010a124,(%esp)
c0106831:	e8 15 9b ff ff       	call   c010034b <cprintf>
     pte_t *temp_ptep=NULL;
c0106836:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c010683d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106840:	8b 40 0c             	mov    0xc(%eax),%eax
c0106843:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010684a:	00 
c010684b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106852:	00 
c0106853:	89 04 24             	mov    %eax,(%esp)
c0106856:	e8 20 e6 ff ff       	call   c0104e7b <get_pte>
c010685b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c010685e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106862:	75 24                	jne    c0106888 <check_swap+0x251>
c0106864:	c7 44 24 0c 58 a1 10 	movl   $0xc010a158,0xc(%esp)
c010686b:	c0 
c010686c:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106873:	c0 
c0106874:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c010687b:	00 
c010687c:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106883:	e8 54 a4 ff ff       	call   c0100cdc <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106888:	c7 04 24 6c a1 10 c0 	movl   $0xc010a16c,(%esp)
c010688f:	e8 b7 9a ff ff       	call   c010034b <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106894:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010689b:	e9 a3 00 00 00       	jmp    c0106943 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c01068a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01068a7:	e8 6d de ff ff       	call   c0104719 <alloc_pages>
c01068ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01068af:	89 04 95 e0 1a 12 c0 	mov    %eax,-0x3fede520(,%edx,4)
          assert(check_rp[i] != NULL );
c01068b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068b9:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c01068c0:	85 c0                	test   %eax,%eax
c01068c2:	75 24                	jne    c01068e8 <check_swap+0x2b1>
c01068c4:	c7 44 24 0c 90 a1 10 	movl   $0xc010a190,0xc(%esp)
c01068cb:	c0 
c01068cc:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c01068d3:	c0 
c01068d4:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01068db:	00 
c01068dc:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c01068e3:	e8 f4 a3 ff ff       	call   c0100cdc <__panic>
          assert(!PageProperty(check_rp[i]));
c01068e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068eb:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c01068f2:	83 c0 04             	add    $0x4,%eax
c01068f5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01068fc:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01068ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106902:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106905:	0f a3 10             	bt     %edx,(%eax)
c0106908:	19 c0                	sbb    %eax,%eax
c010690a:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c010690d:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106911:	0f 95 c0             	setne  %al
c0106914:	0f b6 c0             	movzbl %al,%eax
c0106917:	85 c0                	test   %eax,%eax
c0106919:	74 24                	je     c010693f <check_swap+0x308>
c010691b:	c7 44 24 0c a4 a1 10 	movl   $0xc010a1a4,0xc(%esp)
c0106922:	c0 
c0106923:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c010692a:	c0 
c010692b:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106932:	00 
c0106933:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c010693a:	e8 9d a3 ff ff       	call   c0100cdc <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010693f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106943:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106947:	0f 8e 53 ff ff ff    	jle    c01068a0 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c010694d:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0106952:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0106958:	89 45 98             	mov    %eax,-0x68(%ebp)
c010695b:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010695e:	c7 45 a8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106965:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106968:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010696b:	89 50 04             	mov    %edx,0x4(%eax)
c010696e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106971:	8b 50 04             	mov    0x4(%eax),%edx
c0106974:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106977:	89 10                	mov    %edx,(%eax)
c0106979:	c7 45 a4 c0 1a 12 c0 	movl   $0xc0121ac0,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106980:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106983:	8b 40 04             	mov    0x4(%eax),%eax
c0106986:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106989:	0f 94 c0             	sete   %al
c010698c:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c010698f:	85 c0                	test   %eax,%eax
c0106991:	75 24                	jne    c01069b7 <check_swap+0x380>
c0106993:	c7 44 24 0c bf a1 10 	movl   $0xc010a1bf,0xc(%esp)
c010699a:	c0 
c010699b:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c01069a2:	c0 
c01069a3:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01069aa:	00 
c01069ab:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c01069b2:	e8 25 a3 ff ff       	call   c0100cdc <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01069b7:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01069bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c01069bf:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c01069c6:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01069c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01069d0:	eb 1e                	jmp    c01069f0 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c01069d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069d5:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c01069dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01069e3:	00 
c01069e4:	89 04 24             	mov    %eax,(%esp)
c01069e7:	e8 98 dd ff ff       	call   c0104784 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01069ec:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01069f0:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01069f4:	7e dc                	jle    c01069d2 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c01069f6:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01069fb:	83 f8 04             	cmp    $0x4,%eax
c01069fe:	74 24                	je     c0106a24 <check_swap+0x3ed>
c0106a00:	c7 44 24 0c d8 a1 10 	movl   $0xc010a1d8,0xc(%esp)
c0106a07:	c0 
c0106a08:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106a0f:	c0 
c0106a10:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106a17:	00 
c0106a18:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106a1f:	e8 b8 a2 ff ff       	call   c0100cdc <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106a24:	c7 04 24 fc a1 10 c0 	movl   $0xc010a1fc,(%esp)
c0106a2b:	e8 1b 99 ff ff       	call   c010034b <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106a30:	c7 05 b8 1a 12 c0 00 	movl   $0x0,0xc0121ab8
c0106a37:	00 00 00 
     
     check_content_set();
c0106a3a:	e8 28 fa ff ff       	call   c0106467 <check_content_set>
     assert( nr_free == 0);         
c0106a3f:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106a44:	85 c0                	test   %eax,%eax
c0106a46:	74 24                	je     c0106a6c <check_swap+0x435>
c0106a48:	c7 44 24 0c 23 a2 10 	movl   $0xc010a223,0xc(%esp)
c0106a4f:	c0 
c0106a50:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106a57:	c0 
c0106a58:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106a5f:	00 
c0106a60:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106a67:	e8 70 a2 ff ff       	call   c0100cdc <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106a6c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106a73:	eb 26                	jmp    c0106a9b <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a78:	c7 04 85 00 1b 12 c0 	movl   $0xffffffff,-0x3fede500(,%eax,4)
c0106a7f:	ff ff ff ff 
c0106a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a86:	8b 14 85 00 1b 12 c0 	mov    -0x3fede500(,%eax,4),%edx
c0106a8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a90:	89 14 85 40 1b 12 c0 	mov    %edx,-0x3fede4c0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106a97:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106a9b:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106a9f:	7e d4                	jle    c0106a75 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106aa1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106aa8:	e9 eb 00 00 00       	jmp    c0106b98 <check_swap+0x561>
         check_ptep[i]=0;
c0106aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ab0:	c7 04 85 94 1b 12 c0 	movl   $0x0,-0x3fede46c(,%eax,4)
c0106ab7:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106abe:	83 c0 01             	add    $0x1,%eax
c0106ac1:	c1 e0 0c             	shl    $0xc,%eax
c0106ac4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106acb:	00 
c0106acc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106ad0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106ad3:	89 04 24             	mov    %eax,(%esp)
c0106ad6:	e8 a0 e3 ff ff       	call   c0104e7b <get_pte>
c0106adb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106ade:	89 04 95 94 1b 12 c0 	mov    %eax,-0x3fede46c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ae8:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106aef:	85 c0                	test   %eax,%eax
c0106af1:	75 24                	jne    c0106b17 <check_swap+0x4e0>
c0106af3:	c7 44 24 0c 30 a2 10 	movl   $0xc010a230,0xc(%esp)
c0106afa:	c0 
c0106afb:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106b02:	c0 
c0106b03:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106b0a:	00 
c0106b0b:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106b12:	e8 c5 a1 ff ff       	call   c0100cdc <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b1a:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106b21:	8b 00                	mov    (%eax),%eax
c0106b23:	89 04 24             	mov    %eax,(%esp)
c0106b26:	e8 9f f5 ff ff       	call   c01060ca <pte2page>
c0106b2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106b2e:	8b 14 95 e0 1a 12 c0 	mov    -0x3fede520(,%edx,4),%edx
c0106b35:	39 d0                	cmp    %edx,%eax
c0106b37:	74 24                	je     c0106b5d <check_swap+0x526>
c0106b39:	c7 44 24 0c 48 a2 10 	movl   $0xc010a248,0xc(%esp)
c0106b40:	c0 
c0106b41:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106b48:	c0 
c0106b49:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106b50:	00 
c0106b51:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106b58:	e8 7f a1 ff ff       	call   c0100cdc <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b60:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106b67:	8b 00                	mov    (%eax),%eax
c0106b69:	83 e0 01             	and    $0x1,%eax
c0106b6c:	85 c0                	test   %eax,%eax
c0106b6e:	75 24                	jne    c0106b94 <check_swap+0x55d>
c0106b70:	c7 44 24 0c 70 a2 10 	movl   $0xc010a270,0xc(%esp)
c0106b77:	c0 
c0106b78:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106b7f:	c0 
c0106b80:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106b87:	00 
c0106b88:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106b8f:	e8 48 a1 ff ff       	call   c0100cdc <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b94:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b98:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b9c:	0f 8e 0b ff ff ff    	jle    c0106aad <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106ba2:	c7 04 24 8c a2 10 c0 	movl   $0xc010a28c,(%esp)
c0106ba9:	e8 9d 97 ff ff       	call   c010034b <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106bae:	e8 6c fa ff ff       	call   c010661f <check_content_access>
c0106bb3:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106bb6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106bba:	74 24                	je     c0106be0 <check_swap+0x5a9>
c0106bbc:	c7 44 24 0c b2 a2 10 	movl   $0xc010a2b2,0xc(%esp)
c0106bc3:	c0 
c0106bc4:	c7 44 24 08 9a 9f 10 	movl   $0xc0109f9a,0x8(%esp)
c0106bcb:	c0 
c0106bcc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0106bd3:	00 
c0106bd4:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0106bdb:	e8 fc a0 ff ff       	call   c0100cdc <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106be0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106be7:	eb 1e                	jmp    c0106c07 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bec:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106bf3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106bfa:	00 
c0106bfb:	89 04 24             	mov    %eax,(%esp)
c0106bfe:	e8 81 db ff ff       	call   c0104784 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106c03:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106c07:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106c0b:	7e dc                	jle    c0106be9 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106c0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c10:	89 04 24             	mov    %eax,(%esp)
c0106c13:	e8 32 08 00 00       	call   c010744a <mm_destroy>
         
     nr_free = nr_free_store;
c0106c18:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106c1b:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
     free_list = free_list_store;
c0106c20:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106c23:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106c26:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0106c2b:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4

     
     le = &free_list;
c0106c31:	c7 45 e8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106c38:	eb 1d                	jmp    c0106c57 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0106c3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c3d:	83 e8 0c             	sub    $0xc,%eax
c0106c40:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106c43:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106c47:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106c4a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106c4d:	8b 40 08             	mov    0x8(%eax),%eax
c0106c50:	29 c2                	sub    %eax,%edx
c0106c52:	89 d0                	mov    %edx,%eax
c0106c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c57:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c5a:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106c5d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106c60:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106c63:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106c66:	81 7d e8 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x18(%ebp)
c0106c6d:	75 cb                	jne    c0106c3a <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c72:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c7d:	c7 04 24 b9 a2 10 c0 	movl   $0xc010a2b9,(%esp)
c0106c84:	e8 c2 96 ff ff       	call   c010034b <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106c89:	c7 04 24 d3 a2 10 c0 	movl   $0xc010a2d3,(%esp)
c0106c90:	e8 b6 96 ff ff       	call   c010034b <cprintf>
}
c0106c95:	83 c4 74             	add    $0x74,%esp
c0106c98:	5b                   	pop    %ebx
c0106c99:	5d                   	pop    %ebp
c0106c9a:	c3                   	ret    

c0106c9b <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106c9b:	55                   	push   %ebp
c0106c9c:	89 e5                	mov    %esp,%ebp
c0106c9e:	83 ec 10             	sub    $0x10,%esp
c0106ca1:	c7 45 fc a4 1b 12 c0 	movl   $0xc0121ba4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106cab:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106cae:	89 50 04             	mov    %edx,0x4(%eax)
c0106cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106cb4:	8b 50 04             	mov    0x4(%eax),%edx
c0106cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106cba:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cbf:	c7 40 14 a4 1b 12 c0 	movl   $0xc0121ba4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106ccb:	c9                   	leave  
c0106ccc:	c3                   	ret    

c0106ccd <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106ccd:	55                   	push   %ebp
c0106cce:	89 e5                	mov    %esp,%ebp
c0106cd0:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cd6:	8b 40 14             	mov    0x14(%eax),%eax
c0106cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106cdc:	8b 45 10             	mov    0x10(%ebp),%eax
c0106cdf:	83 c0 14             	add    $0x14,%eax
c0106ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106ce5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106ce9:	74 06                	je     c0106cf1 <_fifo_map_swappable+0x24>
c0106ceb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106cef:	75 24                	jne    c0106d15 <_fifo_map_swappable+0x48>
c0106cf1:	c7 44 24 0c ec a2 10 	movl   $0xc010a2ec,0xc(%esp)
c0106cf8:	c0 
c0106cf9:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0106d00:	c0 
c0106d01:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0106d08:	00 
c0106d09:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0106d10:	e8 c7 9f ff ff       	call   c0100cdc <__panic>
c0106d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d18:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106d27:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0106d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d30:	8b 40 04             	mov    0x4(%eax),%eax
c0106d33:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106d36:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106d39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d3c:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0106d3f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106d42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106d45:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d48:	89 10                	mov    %edx,(%eax)
c0106d4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106d4d:	8b 10                	mov    (%eax),%edx
c0106d4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106d52:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106d55:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106d58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106d5b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106d61:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106d64:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2013012213*/
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);
    return 0;
c0106d66:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d6b:	c9                   	leave  
c0106d6c:	c3                   	ret    

c0106d6d <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106d6d:	55                   	push   %ebp
c0106d6e:	89 e5                	mov    %esp,%ebp
c0106d70:	83 ec 28             	sub    $0x28,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d76:	8b 40 14             	mov    0x14(%eax),%eax
c0106d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106d7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106d80:	75 24                	jne    c0106da6 <_fifo_swap_out_victim+0x39>
c0106d82:	c7 44 24 0c 33 a3 10 	movl   $0xc010a333,0xc(%esp)
c0106d89:	c0 
c0106d8a:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0106d91:	c0 
c0106d92:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0106d99:	00 
c0106d9a:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0106da1:	e8 36 9f ff ff       	call   c0100cdc <__panic>
     assert(in_tick==0);
c0106da6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106daa:	74 24                	je     c0106dd0 <_fifo_swap_out_victim+0x63>
c0106dac:	c7 44 24 0c 40 a3 10 	movl   $0xc010a340,0xc(%esp)
c0106db3:	c0 
c0106db4:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0106dbb:	c0 
c0106dbc:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0106dc3:	00 
c0106dc4:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0106dcb:	e8 0c 9f ff ff       	call   c0100cdc <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2013012213*/
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page

	 *ptr_page = le2page(head->prev, pra_page_link);
c0106dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106dd3:	8b 00                	mov    (%eax),%eax
c0106dd5:	8d 50 ec             	lea    -0x14(%eax),%edx
c0106dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ddb:	89 10                	mov    %edx,(%eax)
	 list_del(head->prev);
c0106ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106de0:	8b 00                	mov    (%eax),%eax
c0106de2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106de8:	8b 40 04             	mov    0x4(%eax),%eax
c0106deb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106dee:	8b 12                	mov    (%edx),%edx
c0106df0:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0106df3:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106df9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106dfc:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106dff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106e02:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106e05:	89 10                	mov    %edx,(%eax)


     return 0;
c0106e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106e0c:	c9                   	leave  
c0106e0d:	c3                   	ret    

c0106e0e <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106e0e:	55                   	push   %ebp
c0106e0f:	89 e5                	mov    %esp,%ebp
c0106e11:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106e14:	c7 04 24 4c a3 10 c0 	movl   $0xc010a34c,(%esp)
c0106e1b:	e8 2b 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106e20:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106e25:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106e28:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106e2d:	83 f8 04             	cmp    $0x4,%eax
c0106e30:	74 24                	je     c0106e56 <_fifo_check_swap+0x48>
c0106e32:	c7 44 24 0c 72 a3 10 	movl   $0xc010a372,0xc(%esp)
c0106e39:	c0 
c0106e3a:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0106e41:	c0 
c0106e42:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
c0106e49:	00 
c0106e4a:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0106e51:	e8 86 9e ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106e56:	c7 04 24 84 a3 10 c0 	movl   $0xc010a384,(%esp)
c0106e5d:	e8 e9 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106e62:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106e67:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106e6a:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106e6f:	83 f8 04             	cmp    $0x4,%eax
c0106e72:	74 24                	je     c0106e98 <_fifo_check_swap+0x8a>
c0106e74:	c7 44 24 0c 72 a3 10 	movl   $0xc010a372,0xc(%esp)
c0106e7b:	c0 
c0106e7c:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0106e83:	c0 
c0106e84:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0106e8b:	00 
c0106e8c:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0106e93:	e8 44 9e ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106e98:	c7 04 24 ac a3 10 c0 	movl   $0xc010a3ac,(%esp)
c0106e9f:	e8 a7 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106ea4:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106ea9:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106eac:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106eb1:	83 f8 04             	cmp    $0x4,%eax
c0106eb4:	74 24                	je     c0106eda <_fifo_check_swap+0xcc>
c0106eb6:	c7 44 24 0c 72 a3 10 	movl   $0xc010a372,0xc(%esp)
c0106ebd:	c0 
c0106ebe:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0106ec5:	c0 
c0106ec6:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
c0106ecd:	00 
c0106ece:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0106ed5:	e8 02 9e ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106eda:	c7 04 24 d4 a3 10 c0 	movl   $0xc010a3d4,(%esp)
c0106ee1:	e8 65 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106ee6:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106eeb:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106eee:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106ef3:	83 f8 04             	cmp    $0x4,%eax
c0106ef6:	74 24                	je     c0106f1c <_fifo_check_swap+0x10e>
c0106ef8:	c7 44 24 0c 72 a3 10 	movl   $0xc010a372,0xc(%esp)
c0106eff:	c0 
c0106f00:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0106f07:	c0 
c0106f08:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
c0106f0f:	00 
c0106f10:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0106f17:	e8 c0 9d ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106f1c:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106f23:	e8 23 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106f28:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106f2d:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106f30:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106f35:	83 f8 05             	cmp    $0x5,%eax
c0106f38:	74 24                	je     c0106f5e <_fifo_check_swap+0x150>
c0106f3a:	c7 44 24 0c 22 a4 10 	movl   $0xc010a422,0xc(%esp)
c0106f41:	c0 
c0106f42:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0106f49:	c0 
c0106f4a:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0106f51:	00 
c0106f52:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0106f59:	e8 7e 9d ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106f5e:	c7 04 24 d4 a3 10 c0 	movl   $0xc010a3d4,(%esp)
c0106f65:	e8 e1 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106f6a:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106f6f:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0106f72:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106f77:	83 f8 05             	cmp    $0x5,%eax
c0106f7a:	74 24                	je     c0106fa0 <_fifo_check_swap+0x192>
c0106f7c:	c7 44 24 0c 22 a4 10 	movl   $0xc010a422,0xc(%esp)
c0106f83:	c0 
c0106f84:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0106f8b:	c0 
c0106f8c:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0106f93:	00 
c0106f94:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0106f9b:	e8 3c 9d ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106fa0:	c7 04 24 84 a3 10 c0 	movl   $0xc010a384,(%esp)
c0106fa7:	e8 9f 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106fac:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106fb1:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0106fb4:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106fb9:	83 f8 06             	cmp    $0x6,%eax
c0106fbc:	74 24                	je     c0106fe2 <_fifo_check_swap+0x1d4>
c0106fbe:	c7 44 24 0c 31 a4 10 	movl   $0xc010a431,0xc(%esp)
c0106fc5:	c0 
c0106fc6:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0106fcd:	c0 
c0106fce:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0106fd5:	00 
c0106fd6:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0106fdd:	e8 fa 9c ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106fe2:	c7 04 24 d4 a3 10 c0 	movl   $0xc010a3d4,(%esp)
c0106fe9:	e8 5d 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106fee:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106ff3:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0106ff6:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106ffb:	83 f8 07             	cmp    $0x7,%eax
c0106ffe:	74 24                	je     c0107024 <_fifo_check_swap+0x216>
c0107000:	c7 44 24 0c 40 a4 10 	movl   $0xc010a440,0xc(%esp)
c0107007:	c0 
c0107008:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c010700f:	c0 
c0107010:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0107017:	00 
c0107018:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c010701f:	e8 b8 9c ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107024:	c7 04 24 4c a3 10 c0 	movl   $0xc010a34c,(%esp)
c010702b:	e8 1b 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107030:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107035:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107038:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010703d:	83 f8 08             	cmp    $0x8,%eax
c0107040:	74 24                	je     c0107066 <_fifo_check_swap+0x258>
c0107042:	c7 44 24 0c 4f a4 10 	movl   $0xc010a44f,0xc(%esp)
c0107049:	c0 
c010704a:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0107051:	c0 
c0107052:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0107059:	00 
c010705a:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c0107061:	e8 76 9c ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107066:	c7 04 24 ac a3 10 c0 	movl   $0xc010a3ac,(%esp)
c010706d:	e8 d9 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107072:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107077:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c010707a:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010707f:	83 f8 09             	cmp    $0x9,%eax
c0107082:	74 24                	je     c01070a8 <_fifo_check_swap+0x29a>
c0107084:	c7 44 24 0c 5e a4 10 	movl   $0xc010a45e,0xc(%esp)
c010708b:	c0 
c010708c:	c7 44 24 08 0a a3 10 	movl   $0xc010a30a,0x8(%esp)
c0107093:	c0 
c0107094:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
c010709b:	00 
c010709c:	c7 04 24 1f a3 10 c0 	movl   $0xc010a31f,(%esp)
c01070a3:	e8 34 9c ff ff       	call   c0100cdc <__panic>
    return 0;
c01070a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01070ad:	c9                   	leave  
c01070ae:	c3                   	ret    

c01070af <_fifo_init>:


static int
_fifo_init(void)
{
c01070af:	55                   	push   %ebp
c01070b0:	89 e5                	mov    %esp,%ebp
    return 0;
c01070b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01070b7:	5d                   	pop    %ebp
c01070b8:	c3                   	ret    

c01070b9 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01070b9:	55                   	push   %ebp
c01070ba:	89 e5                	mov    %esp,%ebp
    return 0;
c01070bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01070c1:	5d                   	pop    %ebp
c01070c2:	c3                   	ret    

c01070c3 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c01070c3:	55                   	push   %ebp
c01070c4:	89 e5                	mov    %esp,%ebp
c01070c6:	b8 00 00 00 00       	mov    $0x0,%eax
c01070cb:	5d                   	pop    %ebp
c01070cc:	c3                   	ret    

c01070cd <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01070cd:	55                   	push   %ebp
c01070ce:	89 e5                	mov    %esp,%ebp
c01070d0:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01070d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01070d6:	c1 e8 0c             	shr    $0xc,%eax
c01070d9:	89 c2                	mov    %eax,%edx
c01070db:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01070e0:	39 c2                	cmp    %eax,%edx
c01070e2:	72 1c                	jb     c0107100 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01070e4:	c7 44 24 08 80 a4 10 	movl   $0xc010a480,0x8(%esp)
c01070eb:	c0 
c01070ec:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01070f3:	00 
c01070f4:	c7 04 24 9f a4 10 c0 	movl   $0xc010a49f,(%esp)
c01070fb:	e8 dc 9b ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c0107100:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0107105:	8b 55 08             	mov    0x8(%ebp),%edx
c0107108:	c1 ea 0c             	shr    $0xc,%edx
c010710b:	c1 e2 05             	shl    $0x5,%edx
c010710e:	01 d0                	add    %edx,%eax
}
c0107110:	c9                   	leave  
c0107111:	c3                   	ret    

c0107112 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107112:	55                   	push   %ebp
c0107113:	89 e5                	mov    %esp,%ebp
c0107115:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107118:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010711f:	e8 27 ee ff ff       	call   c0105f4b <kmalloc>
c0107124:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0107127:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010712b:	74 58                	je     c0107185 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c010712d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107130:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107133:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107136:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107139:	89 50 04             	mov    %edx,0x4(%eax)
c010713c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010713f:	8b 50 04             	mov    0x4(%eax),%edx
c0107142:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107145:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107147:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010714a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107151:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107154:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c010715b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010715e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107165:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c010716a:	85 c0                	test   %eax,%eax
c010716c:	74 0d                	je     c010717b <mm_create+0x69>
c010716e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107171:	89 04 24             	mov    %eax,(%esp)
c0107174:	e8 1f f0 ff ff       	call   c0106198 <swap_init_mm>
c0107179:	eb 0a                	jmp    c0107185 <mm_create+0x73>
        else mm->sm_priv = NULL;
c010717b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010717e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107185:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107188:	c9                   	leave  
c0107189:	c3                   	ret    

c010718a <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c010718a:	55                   	push   %ebp
c010718b:	89 e5                	mov    %esp,%ebp
c010718d:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107190:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107197:	e8 af ed ff ff       	call   c0105f4b <kmalloc>
c010719c:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c010719f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071a3:	74 1b                	je     c01071c0 <vma_create+0x36>
        vma->vm_start = vm_start;
c01071a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071a8:	8b 55 08             	mov    0x8(%ebp),%edx
c01071ab:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01071ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071b1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01071b4:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01071b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071ba:	8b 55 10             	mov    0x10(%ebp),%edx
c01071bd:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01071c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01071c3:	c9                   	leave  
c01071c4:	c3                   	ret    

c01071c5 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01071c5:	55                   	push   %ebp
c01071c6:	89 e5                	mov    %esp,%ebp
c01071c8:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01071cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01071d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01071d6:	0f 84 95 00 00 00    	je     c0107271 <find_vma+0xac>
        vma = mm->mmap_cache;
c01071dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01071df:	8b 40 08             	mov    0x8(%eax),%eax
c01071e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01071e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01071e9:	74 16                	je     c0107201 <find_vma+0x3c>
c01071eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071ee:	8b 40 04             	mov    0x4(%eax),%eax
c01071f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01071f4:	77 0b                	ja     c0107201 <find_vma+0x3c>
c01071f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071f9:	8b 40 08             	mov    0x8(%eax),%eax
c01071fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01071ff:	77 61                	ja     c0107262 <find_vma+0x9d>
                bool found = 0;
c0107201:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107208:	8b 45 08             	mov    0x8(%ebp),%eax
c010720b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010720e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107211:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107214:	eb 28                	jmp    c010723e <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107216:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107219:	83 e8 10             	sub    $0x10,%eax
c010721c:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c010721f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107222:	8b 40 04             	mov    0x4(%eax),%eax
c0107225:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107228:	77 14                	ja     c010723e <find_vma+0x79>
c010722a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010722d:	8b 40 08             	mov    0x8(%eax),%eax
c0107230:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107233:	76 09                	jbe    c010723e <find_vma+0x79>
                        found = 1;
c0107235:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c010723c:	eb 17                	jmp    c0107255 <find_vma+0x90>
c010723e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107241:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107244:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107247:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c010724a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010724d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107253:	75 c1                	jne    c0107216 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107255:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107259:	75 07                	jne    c0107262 <find_vma+0x9d>
                    vma = NULL;
c010725b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107262:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107266:	74 09                	je     c0107271 <find_vma+0xac>
            mm->mmap_cache = vma;
c0107268:	8b 45 08             	mov    0x8(%ebp),%eax
c010726b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010726e:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107271:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107274:	c9                   	leave  
c0107275:	c3                   	ret    

c0107276 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107276:	55                   	push   %ebp
c0107277:	89 e5                	mov    %esp,%ebp
c0107279:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c010727c:	8b 45 08             	mov    0x8(%ebp),%eax
c010727f:	8b 50 04             	mov    0x4(%eax),%edx
c0107282:	8b 45 08             	mov    0x8(%ebp),%eax
c0107285:	8b 40 08             	mov    0x8(%eax),%eax
c0107288:	39 c2                	cmp    %eax,%edx
c010728a:	72 24                	jb     c01072b0 <check_vma_overlap+0x3a>
c010728c:	c7 44 24 0c ad a4 10 	movl   $0xc010a4ad,0xc(%esp)
c0107293:	c0 
c0107294:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c010729b:	c0 
c010729c:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01072a3:	00 
c01072a4:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c01072ab:	e8 2c 9a ff ff       	call   c0100cdc <__panic>
    assert(prev->vm_end <= next->vm_start);
c01072b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01072b3:	8b 50 08             	mov    0x8(%eax),%edx
c01072b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072b9:	8b 40 04             	mov    0x4(%eax),%eax
c01072bc:	39 c2                	cmp    %eax,%edx
c01072be:	76 24                	jbe    c01072e4 <check_vma_overlap+0x6e>
c01072c0:	c7 44 24 0c f0 a4 10 	movl   $0xc010a4f0,0xc(%esp)
c01072c7:	c0 
c01072c8:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c01072cf:	c0 
c01072d0:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c01072d7:	00 
c01072d8:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c01072df:	e8 f8 99 ff ff       	call   c0100cdc <__panic>
    assert(next->vm_start < next->vm_end);
c01072e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072e7:	8b 50 04             	mov    0x4(%eax),%edx
c01072ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072ed:	8b 40 08             	mov    0x8(%eax),%eax
c01072f0:	39 c2                	cmp    %eax,%edx
c01072f2:	72 24                	jb     c0107318 <check_vma_overlap+0xa2>
c01072f4:	c7 44 24 0c 0f a5 10 	movl   $0xc010a50f,0xc(%esp)
c01072fb:	c0 
c01072fc:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c0107303:	c0 
c0107304:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c010730b:	00 
c010730c:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107313:	e8 c4 99 ff ff       	call   c0100cdc <__panic>
}
c0107318:	c9                   	leave  
c0107319:	c3                   	ret    

c010731a <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c010731a:	55                   	push   %ebp
c010731b:	89 e5                	mov    %esp,%ebp
c010731d:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107320:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107323:	8b 50 04             	mov    0x4(%eax),%edx
c0107326:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107329:	8b 40 08             	mov    0x8(%eax),%eax
c010732c:	39 c2                	cmp    %eax,%edx
c010732e:	72 24                	jb     c0107354 <insert_vma_struct+0x3a>
c0107330:	c7 44 24 0c 2d a5 10 	movl   $0xc010a52d,0xc(%esp)
c0107337:	c0 
c0107338:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c010733f:	c0 
c0107340:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0107347:	00 
c0107348:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c010734f:	e8 88 99 ff ff       	call   c0100cdc <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107354:	8b 45 08             	mov    0x8(%ebp),%eax
c0107357:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c010735a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010735d:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107360:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107363:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107366:	eb 21                	jmp    c0107389 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107368:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010736b:	83 e8 10             	sub    $0x10,%eax
c010736e:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107371:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107374:	8b 50 04             	mov    0x4(%eax),%edx
c0107377:	8b 45 0c             	mov    0xc(%ebp),%eax
c010737a:	8b 40 04             	mov    0x4(%eax),%eax
c010737d:	39 c2                	cmp    %eax,%edx
c010737f:	76 02                	jbe    c0107383 <insert_vma_struct+0x69>
                break;
c0107381:	eb 1d                	jmp    c01073a0 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107383:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107386:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107389:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010738c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010738f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107392:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107395:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107398:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010739b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010739e:	75 c8                	jne    c0107368 <insert_vma_struct+0x4e>
c01073a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01073a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01073a9:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c01073ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01073af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01073b5:	74 15                	je     c01073cc <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01073b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073ba:	8d 50 f0             	lea    -0x10(%eax),%edx
c01073bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01073c4:	89 14 24             	mov    %edx,(%esp)
c01073c7:	e8 aa fe ff ff       	call   c0107276 <check_vma_overlap>
    }
    if (le_next != list) {
c01073cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01073cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01073d2:	74 15                	je     c01073e9 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01073d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01073d7:	83 e8 10             	sub    $0x10,%eax
c01073da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01073de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073e1:	89 04 24             	mov    %eax,(%esp)
c01073e4:	e8 8d fe ff ff       	call   c0107276 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01073e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073ec:	8b 55 08             	mov    0x8(%ebp),%edx
c01073ef:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01073f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073f4:	8d 50 10             	lea    0x10(%eax),%edx
c01073f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01073fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107400:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107403:	8b 40 04             	mov    0x4(%eax),%eax
c0107406:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107409:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010740c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010740f:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107412:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107415:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107418:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010741b:	89 10                	mov    %edx,(%eax)
c010741d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107420:	8b 10                	mov    (%eax),%edx
c0107422:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107425:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107428:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010742b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010742e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107431:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107434:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107437:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107439:	8b 45 08             	mov    0x8(%ebp),%eax
c010743c:	8b 40 10             	mov    0x10(%eax),%eax
c010743f:	8d 50 01             	lea    0x1(%eax),%edx
c0107442:	8b 45 08             	mov    0x8(%ebp),%eax
c0107445:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107448:	c9                   	leave  
c0107449:	c3                   	ret    

c010744a <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c010744a:	55                   	push   %ebp
c010744b:	89 e5                	mov    %esp,%ebp
c010744d:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107450:	8b 45 08             	mov    0x8(%ebp),%eax
c0107453:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107456:	eb 3e                	jmp    c0107496 <mm_destroy+0x4c>
c0107458:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010745b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010745e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107461:	8b 40 04             	mov    0x4(%eax),%eax
c0107464:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107467:	8b 12                	mov    (%edx),%edx
c0107469:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010746c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010746f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107472:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107475:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010747b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010747e:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0107480:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107483:	83 e8 10             	sub    $0x10,%eax
c0107486:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c010748d:	00 
c010748e:	89 04 24             	mov    %eax,(%esp)
c0107491:	e8 55 eb ff ff       	call   c0105feb <kfree>
c0107496:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107499:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010749c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010749f:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01074a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01074a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01074a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01074ab:	75 ab                	jne    c0107458 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c01074ad:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c01074b4:	00 
c01074b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01074b8:	89 04 24             	mov    %eax,(%esp)
c01074bb:	e8 2b eb ff ff       	call   c0105feb <kfree>
    mm=NULL;
c01074c0:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01074c7:	c9                   	leave  
c01074c8:	c3                   	ret    

c01074c9 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c01074c9:	55                   	push   %ebp
c01074ca:	89 e5                	mov    %esp,%ebp
c01074cc:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c01074cf:	e8 02 00 00 00       	call   c01074d6 <check_vmm>
}
c01074d4:	c9                   	leave  
c01074d5:	c3                   	ret    

c01074d6 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c01074d6:	55                   	push   %ebp
c01074d7:	89 e5                	mov    %esp,%ebp
c01074d9:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01074dc:	e8 d5 d2 ff ff       	call   c01047b6 <nr_free_pages>
c01074e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01074e4:	e8 41 00 00 00       	call   c010752a <check_vma_struct>
    check_pgfault();
c01074e9:	e8 03 05 00 00       	call   c01079f1 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c01074ee:	e8 c3 d2 ff ff       	call   c01047b6 <nr_free_pages>
c01074f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01074f6:	74 24                	je     c010751c <check_vmm+0x46>
c01074f8:	c7 44 24 0c 4c a5 10 	movl   $0xc010a54c,0xc(%esp)
c01074ff:	c0 
c0107500:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c0107507:	c0 
c0107508:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c010750f:	00 
c0107510:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107517:	e8 c0 97 ff ff       	call   c0100cdc <__panic>

    cprintf("check_vmm() succeeded.\n");
c010751c:	c7 04 24 73 a5 10 c0 	movl   $0xc010a573,(%esp)
c0107523:	e8 23 8e ff ff       	call   c010034b <cprintf>
}
c0107528:	c9                   	leave  
c0107529:	c3                   	ret    

c010752a <check_vma_struct>:

static void
check_vma_struct(void) {
c010752a:	55                   	push   %ebp
c010752b:	89 e5                	mov    %esp,%ebp
c010752d:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107530:	e8 81 d2 ff ff       	call   c01047b6 <nr_free_pages>
c0107535:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107538:	e8 d5 fb ff ff       	call   c0107112 <mm_create>
c010753d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107540:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107544:	75 24                	jne    c010756a <check_vma_struct+0x40>
c0107546:	c7 44 24 0c 8b a5 10 	movl   $0xc010a58b,0xc(%esp)
c010754d:	c0 
c010754e:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c0107555:	c0 
c0107556:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c010755d:	00 
c010755e:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107565:	e8 72 97 ff ff       	call   c0100cdc <__panic>

    int step1 = 10, step2 = step1 * 10;
c010756a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107571:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107574:	89 d0                	mov    %edx,%eax
c0107576:	c1 e0 02             	shl    $0x2,%eax
c0107579:	01 d0                	add    %edx,%eax
c010757b:	01 c0                	add    %eax,%eax
c010757d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107583:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107586:	eb 70                	jmp    c01075f8 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107588:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010758b:	89 d0                	mov    %edx,%eax
c010758d:	c1 e0 02             	shl    $0x2,%eax
c0107590:	01 d0                	add    %edx,%eax
c0107592:	83 c0 02             	add    $0x2,%eax
c0107595:	89 c1                	mov    %eax,%ecx
c0107597:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010759a:	89 d0                	mov    %edx,%eax
c010759c:	c1 e0 02             	shl    $0x2,%eax
c010759f:	01 d0                	add    %edx,%eax
c01075a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01075a8:	00 
c01075a9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01075ad:	89 04 24             	mov    %eax,(%esp)
c01075b0:	e8 d5 fb ff ff       	call   c010718a <vma_create>
c01075b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c01075b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01075bc:	75 24                	jne    c01075e2 <check_vma_struct+0xb8>
c01075be:	c7 44 24 0c 96 a5 10 	movl   $0xc010a596,0xc(%esp)
c01075c5:	c0 
c01075c6:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c01075cd:	c0 
c01075ce:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c01075d5:	00 
c01075d6:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c01075dd:	e8 fa 96 ff ff       	call   c0100cdc <__panic>
        insert_vma_struct(mm, vma);
c01075e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01075e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01075e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01075ec:	89 04 24             	mov    %eax,(%esp)
c01075ef:	e8 26 fd ff ff       	call   c010731a <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c01075f4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01075f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01075fc:	7f 8a                	jg     c0107588 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01075fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107601:	83 c0 01             	add    $0x1,%eax
c0107604:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107607:	eb 70                	jmp    c0107679 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107609:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010760c:	89 d0                	mov    %edx,%eax
c010760e:	c1 e0 02             	shl    $0x2,%eax
c0107611:	01 d0                	add    %edx,%eax
c0107613:	83 c0 02             	add    $0x2,%eax
c0107616:	89 c1                	mov    %eax,%ecx
c0107618:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010761b:	89 d0                	mov    %edx,%eax
c010761d:	c1 e0 02             	shl    $0x2,%eax
c0107620:	01 d0                	add    %edx,%eax
c0107622:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107629:	00 
c010762a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010762e:	89 04 24             	mov    %eax,(%esp)
c0107631:	e8 54 fb ff ff       	call   c010718a <vma_create>
c0107636:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107639:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010763d:	75 24                	jne    c0107663 <check_vma_struct+0x139>
c010763f:	c7 44 24 0c 96 a5 10 	movl   $0xc010a596,0xc(%esp)
c0107646:	c0 
c0107647:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c010764e:	c0 
c010764f:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0107656:	00 
c0107657:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c010765e:	e8 79 96 ff ff       	call   c0100cdc <__panic>
        insert_vma_struct(mm, vma);
c0107663:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107666:	89 44 24 04          	mov    %eax,0x4(%esp)
c010766a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010766d:	89 04 24             	mov    %eax,(%esp)
c0107670:	e8 a5 fc ff ff       	call   c010731a <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107675:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107679:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010767c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010767f:	7e 88                	jle    c0107609 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107681:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107684:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107687:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010768a:	8b 40 04             	mov    0x4(%eax),%eax
c010768d:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107690:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107697:	e9 97 00 00 00       	jmp    c0107733 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c010769c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010769f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01076a2:	75 24                	jne    c01076c8 <check_vma_struct+0x19e>
c01076a4:	c7 44 24 0c a2 a5 10 	movl   $0xc010a5a2,0xc(%esp)
c01076ab:	c0 
c01076ac:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c01076b3:	c0 
c01076b4:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c01076bb:	00 
c01076bc:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c01076c3:	e8 14 96 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c01076c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076cb:	83 e8 10             	sub    $0x10,%eax
c01076ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c01076d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01076d4:	8b 48 04             	mov    0x4(%eax),%ecx
c01076d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01076da:	89 d0                	mov    %edx,%eax
c01076dc:	c1 e0 02             	shl    $0x2,%eax
c01076df:	01 d0                	add    %edx,%eax
c01076e1:	39 c1                	cmp    %eax,%ecx
c01076e3:	75 17                	jne    c01076fc <check_vma_struct+0x1d2>
c01076e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01076e8:	8b 48 08             	mov    0x8(%eax),%ecx
c01076eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01076ee:	89 d0                	mov    %edx,%eax
c01076f0:	c1 e0 02             	shl    $0x2,%eax
c01076f3:	01 d0                	add    %edx,%eax
c01076f5:	83 c0 02             	add    $0x2,%eax
c01076f8:	39 c1                	cmp    %eax,%ecx
c01076fa:	74 24                	je     c0107720 <check_vma_struct+0x1f6>
c01076fc:	c7 44 24 0c bc a5 10 	movl   $0xc010a5bc,0xc(%esp)
c0107703:	c0 
c0107704:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c010770b:	c0 
c010770c:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0107713:	00 
c0107714:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c010771b:	e8 bc 95 ff ff       	call   c0100cdc <__panic>
c0107720:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107723:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107726:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107729:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010772c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c010772f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107733:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107736:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107739:	0f 8e 5d ff ff ff    	jle    c010769c <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c010773f:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107746:	e9 cd 01 00 00       	jmp    c0107918 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c010774b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010774e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107752:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107755:	89 04 24             	mov    %eax,(%esp)
c0107758:	e8 68 fa ff ff       	call   c01071c5 <find_vma>
c010775d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107760:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107764:	75 24                	jne    c010778a <check_vma_struct+0x260>
c0107766:	c7 44 24 0c f1 a5 10 	movl   $0xc010a5f1,0xc(%esp)
c010776d:	c0 
c010776e:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c0107775:	c0 
c0107776:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c010777d:	00 
c010777e:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107785:	e8 52 95 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c010778a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010778d:	83 c0 01             	add    $0x1,%eax
c0107790:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107794:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107797:	89 04 24             	mov    %eax,(%esp)
c010779a:	e8 26 fa ff ff       	call   c01071c5 <find_vma>
c010779f:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c01077a2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01077a6:	75 24                	jne    c01077cc <check_vma_struct+0x2a2>
c01077a8:	c7 44 24 0c fe a5 10 	movl   $0xc010a5fe,0xc(%esp)
c01077af:	c0 
c01077b0:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c01077b7:	c0 
c01077b8:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01077bf:	00 
c01077c0:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c01077c7:	e8 10 95 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c01077cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077cf:	83 c0 02             	add    $0x2,%eax
c01077d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01077d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01077d9:	89 04 24             	mov    %eax,(%esp)
c01077dc:	e8 e4 f9 ff ff       	call   c01071c5 <find_vma>
c01077e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c01077e4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01077e8:	74 24                	je     c010780e <check_vma_struct+0x2e4>
c01077ea:	c7 44 24 0c 0b a6 10 	movl   $0xc010a60b,0xc(%esp)
c01077f1:	c0 
c01077f2:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c01077f9:	c0 
c01077fa:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0107801:	00 
c0107802:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107809:	e8 ce 94 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c010780e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107811:	83 c0 03             	add    $0x3,%eax
c0107814:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107818:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010781b:	89 04 24             	mov    %eax,(%esp)
c010781e:	e8 a2 f9 ff ff       	call   c01071c5 <find_vma>
c0107823:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107826:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c010782a:	74 24                	je     c0107850 <check_vma_struct+0x326>
c010782c:	c7 44 24 0c 18 a6 10 	movl   $0xc010a618,0xc(%esp)
c0107833:	c0 
c0107834:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c010783b:	c0 
c010783c:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0107843:	00 
c0107844:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c010784b:	e8 8c 94 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107850:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107853:	83 c0 04             	add    $0x4,%eax
c0107856:	89 44 24 04          	mov    %eax,0x4(%esp)
c010785a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010785d:	89 04 24             	mov    %eax,(%esp)
c0107860:	e8 60 f9 ff ff       	call   c01071c5 <find_vma>
c0107865:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107868:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c010786c:	74 24                	je     c0107892 <check_vma_struct+0x368>
c010786e:	c7 44 24 0c 25 a6 10 	movl   $0xc010a625,0xc(%esp)
c0107875:	c0 
c0107876:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c010787d:	c0 
c010787e:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0107885:	00 
c0107886:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c010788d:	e8 4a 94 ff ff       	call   c0100cdc <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107892:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107895:	8b 50 04             	mov    0x4(%eax),%edx
c0107898:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010789b:	39 c2                	cmp    %eax,%edx
c010789d:	75 10                	jne    c01078af <check_vma_struct+0x385>
c010789f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01078a2:	8b 50 08             	mov    0x8(%eax),%edx
c01078a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078a8:	83 c0 02             	add    $0x2,%eax
c01078ab:	39 c2                	cmp    %eax,%edx
c01078ad:	74 24                	je     c01078d3 <check_vma_struct+0x3a9>
c01078af:	c7 44 24 0c 34 a6 10 	movl   $0xc010a634,0xc(%esp)
c01078b6:	c0 
c01078b7:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c01078be:	c0 
c01078bf:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01078c6:	00 
c01078c7:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c01078ce:	e8 09 94 ff ff       	call   c0100cdc <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c01078d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01078d6:	8b 50 04             	mov    0x4(%eax),%edx
c01078d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078dc:	39 c2                	cmp    %eax,%edx
c01078de:	75 10                	jne    c01078f0 <check_vma_struct+0x3c6>
c01078e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01078e3:	8b 50 08             	mov    0x8(%eax),%edx
c01078e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078e9:	83 c0 02             	add    $0x2,%eax
c01078ec:	39 c2                	cmp    %eax,%edx
c01078ee:	74 24                	je     c0107914 <check_vma_struct+0x3ea>
c01078f0:	c7 44 24 0c 64 a6 10 	movl   $0xc010a664,0xc(%esp)
c01078f7:	c0 
c01078f8:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c01078ff:	c0 
c0107900:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0107907:	00 
c0107908:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c010790f:	e8 c8 93 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107914:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107918:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010791b:	89 d0                	mov    %edx,%eax
c010791d:	c1 e0 02             	shl    $0x2,%eax
c0107920:	01 d0                	add    %edx,%eax
c0107922:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107925:	0f 8d 20 fe ff ff    	jge    c010774b <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010792b:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107932:	eb 70                	jmp    c01079a4 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010793b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010793e:	89 04 24             	mov    %eax,(%esp)
c0107941:	e8 7f f8 ff ff       	call   c01071c5 <find_vma>
c0107946:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107949:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010794d:	74 27                	je     c0107976 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c010794f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107952:	8b 50 08             	mov    0x8(%eax),%edx
c0107955:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107958:	8b 40 04             	mov    0x4(%eax),%eax
c010795b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010795f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107963:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107966:	89 44 24 04          	mov    %eax,0x4(%esp)
c010796a:	c7 04 24 94 a6 10 c0 	movl   $0xc010a694,(%esp)
c0107971:	e8 d5 89 ff ff       	call   c010034b <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107976:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010797a:	74 24                	je     c01079a0 <check_vma_struct+0x476>
c010797c:	c7 44 24 0c b9 a6 10 	movl   $0xc010a6b9,0xc(%esp)
c0107983:	c0 
c0107984:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c010798b:	c0 
c010798c:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0107993:	00 
c0107994:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c010799b:	e8 3c 93 ff ff       	call   c0100cdc <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01079a0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01079a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01079a8:	79 8a                	jns    c0107934 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c01079aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079ad:	89 04 24             	mov    %eax,(%esp)
c01079b0:	e8 95 fa ff ff       	call   c010744a <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c01079b5:	e8 fc cd ff ff       	call   c01047b6 <nr_free_pages>
c01079ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01079bd:	74 24                	je     c01079e3 <check_vma_struct+0x4b9>
c01079bf:	c7 44 24 0c 4c a5 10 	movl   $0xc010a54c,0xc(%esp)
c01079c6:	c0 
c01079c7:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c01079ce:	c0 
c01079cf:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01079d6:	00 
c01079d7:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c01079de:	e8 f9 92 ff ff       	call   c0100cdc <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c01079e3:	c7 04 24 d0 a6 10 c0 	movl   $0xc010a6d0,(%esp)
c01079ea:	e8 5c 89 ff ff       	call   c010034b <cprintf>
}
c01079ef:	c9                   	leave  
c01079f0:	c3                   	ret    

c01079f1 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c01079f1:	55                   	push   %ebp
c01079f2:	89 e5                	mov    %esp,%ebp
c01079f4:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01079f7:	e8 ba cd ff ff       	call   c01047b6 <nr_free_pages>
c01079fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c01079ff:	e8 0e f7 ff ff       	call   c0107112 <mm_create>
c0107a04:	a3 ac 1b 12 c0       	mov    %eax,0xc0121bac
    assert(check_mm_struct != NULL);
c0107a09:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0107a0e:	85 c0                	test   %eax,%eax
c0107a10:	75 24                	jne    c0107a36 <check_pgfault+0x45>
c0107a12:	c7 44 24 0c ef a6 10 	movl   $0xc010a6ef,0xc(%esp)
c0107a19:	c0 
c0107a1a:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c0107a21:	c0 
c0107a22:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0107a29:	00 
c0107a2a:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107a31:	e8 a6 92 ff ff       	call   c0100cdc <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107a36:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0107a3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107a3e:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0107a44:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a47:	89 50 0c             	mov    %edx,0xc(%eax)
c0107a4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a4d:	8b 40 0c             	mov    0xc(%eax),%eax
c0107a50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a56:	8b 00                	mov    (%eax),%eax
c0107a58:	85 c0                	test   %eax,%eax
c0107a5a:	74 24                	je     c0107a80 <check_pgfault+0x8f>
c0107a5c:	c7 44 24 0c 07 a7 10 	movl   $0xc010a707,0xc(%esp)
c0107a63:	c0 
c0107a64:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c0107a6b:	c0 
c0107a6c:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107a73:	00 
c0107a74:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107a7b:	e8 5c 92 ff ff       	call   c0100cdc <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107a80:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107a87:	00 
c0107a88:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107a8f:	00 
c0107a90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107a97:	e8 ee f6 ff ff       	call   c010718a <vma_create>
c0107a9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107a9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107aa3:	75 24                	jne    c0107ac9 <check_pgfault+0xd8>
c0107aa5:	c7 44 24 0c 96 a5 10 	movl   $0xc010a596,0xc(%esp)
c0107aac:	c0 
c0107aad:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c0107ab4:	c0 
c0107ab5:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107abc:	00 
c0107abd:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107ac4:	e8 13 92 ff ff       	call   c0100cdc <__panic>

    insert_vma_struct(mm, vma);
c0107ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107acc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ad3:	89 04 24             	mov    %eax,(%esp)
c0107ad6:	e8 3f f8 ff ff       	call   c010731a <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107adb:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107ae2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107aec:	89 04 24             	mov    %eax,(%esp)
c0107aef:	e8 d1 f6 ff ff       	call   c01071c5 <find_vma>
c0107af4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107af7:	74 24                	je     c0107b1d <check_pgfault+0x12c>
c0107af9:	c7 44 24 0c 15 a7 10 	movl   $0xc010a715,0xc(%esp)
c0107b00:	c0 
c0107b01:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c0107b08:	c0 
c0107b09:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107b10:	00 
c0107b11:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107b18:	e8 bf 91 ff ff       	call   c0100cdc <__panic>

    int i, sum = 0;
c0107b1d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107b24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107b2b:	eb 17                	jmp    c0107b44 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b30:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b33:	01 d0                	add    %edx,%eax
c0107b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b38:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b3d:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107b40:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107b44:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107b48:	7e e3                	jle    c0107b2d <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107b4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107b51:	eb 15                	jmp    c0107b68 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b56:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b59:	01 d0                	add    %edx,%eax
c0107b5b:	0f b6 00             	movzbl (%eax),%eax
c0107b5e:	0f be c0             	movsbl %al,%eax
c0107b61:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107b64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107b68:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107b6c:	7e e5                	jle    c0107b53 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107b6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107b72:	74 24                	je     c0107b98 <check_pgfault+0x1a7>
c0107b74:	c7 44 24 0c 2f a7 10 	movl   $0xc010a72f,0xc(%esp)
c0107b7b:	c0 
c0107b7c:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c0107b83:	c0 
c0107b84:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107b8b:	00 
c0107b8c:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107b93:	e8 44 91 ff ff       	call   c0100cdc <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107b98:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107b9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107ba1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107bad:	89 04 24             	mov    %eax,(%esp)
c0107bb0:	e8 b8 d4 ff ff       	call   c010506d <page_remove>
    free_page(pa2page(pgdir[0]));
c0107bb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107bb8:	8b 00                	mov    (%eax),%eax
c0107bba:	89 04 24             	mov    %eax,(%esp)
c0107bbd:	e8 0b f5 ff ff       	call   c01070cd <pa2page>
c0107bc2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107bc9:	00 
c0107bca:	89 04 24             	mov    %eax,(%esp)
c0107bcd:	e8 b2 cb ff ff       	call   c0104784 <free_pages>
    pgdir[0] = 0;
c0107bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107bd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107bdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107bde:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107be8:	89 04 24             	mov    %eax,(%esp)
c0107beb:	e8 5a f8 ff ff       	call   c010744a <mm_destroy>
    check_mm_struct = NULL;
c0107bf0:	c7 05 ac 1b 12 c0 00 	movl   $0x0,0xc0121bac
c0107bf7:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107bfa:	e8 b7 cb ff ff       	call   c01047b6 <nr_free_pages>
c0107bff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107c02:	74 24                	je     c0107c28 <check_pgfault+0x237>
c0107c04:	c7 44 24 0c 4c a5 10 	movl   $0xc010a54c,0xc(%esp)
c0107c0b:	c0 
c0107c0c:	c7 44 24 08 cb a4 10 	movl   $0xc010a4cb,0x8(%esp)
c0107c13:	c0 
c0107c14:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107c1b:	00 
c0107c1c:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c0107c23:	e8 b4 90 ff ff       	call   c0100cdc <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107c28:	c7 04 24 38 a7 10 c0 	movl   $0xc010a738,(%esp)
c0107c2f:	e8 17 87 ff ff       	call   c010034b <cprintf>
}
c0107c34:	c9                   	leave  
c0107c35:	c3                   	ret    

c0107c36 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107c36:	55                   	push   %ebp
c0107c37:	89 e5                	mov    %esp,%ebp
c0107c39:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107c3c:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107c43:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c4d:	89 04 24             	mov    %eax,(%esp)
c0107c50:	e8 70 f5 ff ff       	call   c01071c5 <find_vma>
c0107c55:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107c58:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107c5d:	83 c0 01             	add    $0x1,%eax
c0107c60:	a3 b8 1a 12 c0       	mov    %eax,0xc0121ab8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107c65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107c69:	74 0b                	je     c0107c76 <do_pgfault+0x40>
c0107c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c6e:	8b 40 04             	mov    0x4(%eax),%eax
c0107c71:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107c74:	76 18                	jbe    c0107c8e <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107c76:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c7d:	c7 04 24 54 a7 10 c0 	movl   $0xc010a754,(%esp)
c0107c84:	e8 c2 86 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107c89:	e9 bb 01 00 00       	jmp    c0107e49 <do_pgfault+0x213>
    }
    //check the error_code
    switch (error_code & 3) {
c0107c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107c91:	83 e0 03             	and    $0x3,%eax
c0107c94:	85 c0                	test   %eax,%eax
c0107c96:	74 36                	je     c0107cce <do_pgfault+0x98>
c0107c98:	83 f8 01             	cmp    $0x1,%eax
c0107c9b:	74 20                	je     c0107cbd <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107ca0:	8b 40 0c             	mov    0xc(%eax),%eax
c0107ca3:	83 e0 02             	and    $0x2,%eax
c0107ca6:	85 c0                	test   %eax,%eax
c0107ca8:	75 11                	jne    c0107cbb <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107caa:	c7 04 24 84 a7 10 c0 	movl   $0xc010a784,(%esp)
c0107cb1:	e8 95 86 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107cb6:	e9 8e 01 00 00       	jmp    c0107e49 <do_pgfault+0x213>
        }
        break;
c0107cbb:	eb 2f                	jmp    c0107cec <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107cbd:	c7 04 24 e4 a7 10 c0 	movl   $0xc010a7e4,(%esp)
c0107cc4:	e8 82 86 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107cc9:	e9 7b 01 00 00       	jmp    c0107e49 <do_pgfault+0x213>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107cd1:	8b 40 0c             	mov    0xc(%eax),%eax
c0107cd4:	83 e0 05             	and    $0x5,%eax
c0107cd7:	85 c0                	test   %eax,%eax
c0107cd9:	75 11                	jne    c0107cec <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107cdb:	c7 04 24 1c a8 10 c0 	movl   $0xc010a81c,(%esp)
c0107ce2:	e8 64 86 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107ce7:	e9 5d 01 00 00       	jmp    c0107e49 <do_pgfault+0x213>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107cec:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107cf6:	8b 40 0c             	mov    0xc(%eax),%eax
c0107cf9:	83 e0 02             	and    $0x2,%eax
c0107cfc:	85 c0                	test   %eax,%eax
c0107cfe:	74 04                	je     c0107d04 <do_pgfault+0xce>
        perm |= PTE_W;
c0107d00:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107d04:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d07:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107d0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107d12:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107d15:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0107d1c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    *
    */

    /*LAB3 EXERCISE 1: 2013012213*/

    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
c0107d23:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d26:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d29:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107d30:	00 
c0107d31:	8b 55 10             	mov    0x10(%ebp),%edx
c0107d34:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107d38:	89 04 24             	mov    %eax,(%esp)
c0107d3b:	e8 3b d1 ff ff       	call   c0104e7b <get_pte>
c0107d40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107d43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107d47:	75 11                	jne    c0107d5a <do_pgfault+0x124>
        cprintf("get_pte in do_pgfault failed\n");
c0107d49:	c7 04 24 7f a8 10 c0 	movl   $0xc010a87f,(%esp)
c0107d50:	e8 f6 85 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107d55:	e9 ef 00 00 00       	jmp    c0107e49 <do_pgfault+0x213>
    }
    if (*ptep == 0) {
c0107d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d5d:	8b 00                	mov    (%eax),%eax
c0107d5f:	85 c0                	test   %eax,%eax
c0107d61:	75 35                	jne    c0107d98 <do_pgfault+0x162>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0107d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d66:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d69:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107d6c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107d70:	8b 55 10             	mov    0x10(%ebp),%edx
c0107d73:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107d77:	89 04 24             	mov    %eax,(%esp)
c0107d7a:	e8 48 d4 ff ff       	call   c01051c7 <pgdir_alloc_page>
c0107d7f:	85 c0                	test   %eax,%eax
c0107d81:	0f 85 bb 00 00 00    	jne    c0107e42 <do_pgfault+0x20c>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0107d87:	c7 04 24 a0 a8 10 c0 	movl   $0xc010a8a0,(%esp)
c0107d8e:	e8 b8 85 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107d93:	e9 b1 00 00 00       	jmp    c0107e49 <do_pgfault+0x213>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c0107d98:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0107d9d:	85 c0                	test   %eax,%eax
c0107d9f:	0f 84 86 00 00 00    	je     c0107e2b <do_pgfault+0x1f5>
            struct Page *page = NULL;
c0107da5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
c0107dac:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0107daf:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107db3:	8b 45 10             	mov    0x10(%ebp),%eax
c0107db6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107dba:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dbd:	89 04 24             	mov    %eax,(%esp)
c0107dc0:	e8 cc e5 ff ff       	call   c0106391 <swap_in>
c0107dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107dc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107dcc:	74 0e                	je     c0107ddc <do_pgfault+0x1a6>
                cprintf("swap_in in do_pgfault failed\n");
c0107dce:	c7 04 24 c7 a8 10 c0 	movl   $0xc010a8c7,(%esp)
c0107dd5:	e8 71 85 ff ff       	call   c010034b <cprintf>
c0107dda:	eb 6d                	jmp    c0107e49 <do_pgfault+0x213>
                goto failed;
            }
            page_insert(mm->pgdir, page, addr, perm);
c0107ddc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107ddf:	8b 45 08             	mov    0x8(%ebp),%eax
c0107de2:	8b 40 0c             	mov    0xc(%eax),%eax
c0107de5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107de8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107dec:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0107def:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107df3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107df7:	89 04 24             	mov    %eax,(%esp)
c0107dfa:	e8 b2 d2 ff ff       	call   c01050b1 <page_insert>
            swap_map_swappable(mm, addr, page, 1);
c0107dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107e02:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0107e09:	00 
c0107e0a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e0e:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e15:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e18:	89 04 24             	mov    %eax,(%esp)
c0107e1b:	e8 a8 e3 ff ff       	call   c01061c8 <swap_map_swappable>
            page->pra_vaddr = addr;
c0107e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107e23:	8b 55 10             	mov    0x10(%ebp),%edx
c0107e26:	89 50 1c             	mov    %edx,0x1c(%eax)
c0107e29:	eb 17                	jmp    c0107e42 <do_pgfault+0x20c>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0107e2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e2e:	8b 00                	mov    (%eax),%eax
c0107e30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e34:	c7 04 24 e8 a8 10 c0 	movl   $0xc010a8e8,(%esp)
c0107e3b:	e8 0b 85 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107e40:	eb 07                	jmp    c0107e49 <do_pgfault+0x213>
   }




   ret = 0;
c0107e42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0107e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107e4c:	c9                   	leave  
c0107e4d:	c3                   	ret    

c0107e4e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0107e4e:	55                   	push   %ebp
c0107e4f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107e51:	8b 55 08             	mov    0x8(%ebp),%edx
c0107e54:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0107e59:	29 c2                	sub    %eax,%edx
c0107e5b:	89 d0                	mov    %edx,%eax
c0107e5d:	c1 f8 05             	sar    $0x5,%eax
}
c0107e60:	5d                   	pop    %ebp
c0107e61:	c3                   	ret    

c0107e62 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107e62:	55                   	push   %ebp
c0107e63:	89 e5                	mov    %esp,%ebp
c0107e65:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0107e68:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e6b:	89 04 24             	mov    %eax,(%esp)
c0107e6e:	e8 db ff ff ff       	call   c0107e4e <page2ppn>
c0107e73:	c1 e0 0c             	shl    $0xc,%eax
}
c0107e76:	c9                   	leave  
c0107e77:	c3                   	ret    

c0107e78 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107e78:	55                   	push   %ebp
c0107e79:	89 e5                	mov    %esp,%ebp
c0107e7b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0107e7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e81:	89 04 24             	mov    %eax,(%esp)
c0107e84:	e8 d9 ff ff ff       	call   c0107e62 <page2pa>
c0107e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e8f:	c1 e8 0c             	shr    $0xc,%eax
c0107e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107e95:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107e9a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107e9d:	72 23                	jb     c0107ec2 <page2kva+0x4a>
c0107e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ea2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107ea6:	c7 44 24 08 10 a9 10 	movl   $0xc010a910,0x8(%esp)
c0107ead:	c0 
c0107eae:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0107eb5:	00 
c0107eb6:	c7 04 24 33 a9 10 c0 	movl   $0xc010a933,(%esp)
c0107ebd:	e8 1a 8e ff ff       	call   c0100cdc <__panic>
c0107ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ec5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107eca:	c9                   	leave  
c0107ecb:	c3                   	ret    

c0107ecc <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107ecc:	55                   	push   %ebp
c0107ecd:	89 e5                	mov    %esp,%ebp
c0107ecf:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0107ed2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107ed9:	e8 4e 9b ff ff       	call   c0101a2c <ide_device_valid>
c0107ede:	85 c0                	test   %eax,%eax
c0107ee0:	75 1c                	jne    c0107efe <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0107ee2:	c7 44 24 08 41 a9 10 	movl   $0xc010a941,0x8(%esp)
c0107ee9:	c0 
c0107eea:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0107ef1:	00 
c0107ef2:	c7 04 24 5b a9 10 c0 	movl   $0xc010a95b,(%esp)
c0107ef9:	e8 de 8d ff ff       	call   c0100cdc <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107efe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f05:	e8 61 9b ff ff       	call   c0101a6b <ide_device_size>
c0107f0a:	c1 e8 03             	shr    $0x3,%eax
c0107f0d:	a3 7c 1b 12 c0       	mov    %eax,0xc0121b7c
}
c0107f12:	c9                   	leave  
c0107f13:	c3                   	ret    

c0107f14 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107f14:	55                   	push   %ebp
c0107f15:	89 e5                	mov    %esp,%ebp
c0107f17:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f1d:	89 04 24             	mov    %eax,(%esp)
c0107f20:	e8 53 ff ff ff       	call   c0107e78 <page2kva>
c0107f25:	8b 55 08             	mov    0x8(%ebp),%edx
c0107f28:	c1 ea 08             	shr    $0x8,%edx
c0107f2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107f32:	74 0b                	je     c0107f3f <swapfs_read+0x2b>
c0107f34:	8b 15 7c 1b 12 c0    	mov    0xc0121b7c,%edx
c0107f3a:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107f3d:	72 23                	jb     c0107f62 <swapfs_read+0x4e>
c0107f3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f42:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107f46:	c7 44 24 08 6c a9 10 	movl   $0xc010a96c,0x8(%esp)
c0107f4d:	c0 
c0107f4e:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0107f55:	00 
c0107f56:	c7 04 24 5b a9 10 c0 	movl   $0xc010a95b,(%esp)
c0107f5d:	e8 7a 8d ff ff       	call   c0100cdc <__panic>
c0107f62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f65:	c1 e2 03             	shl    $0x3,%edx
c0107f68:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107f6f:	00 
c0107f70:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107f74:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107f78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f7f:	e8 26 9b ff ff       	call   c0101aaa <ide_read_secs>
}
c0107f84:	c9                   	leave  
c0107f85:	c3                   	ret    

c0107f86 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0107f86:	55                   	push   %ebp
c0107f87:	89 e5                	mov    %esp,%ebp
c0107f89:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f8f:	89 04 24             	mov    %eax,(%esp)
c0107f92:	e8 e1 fe ff ff       	call   c0107e78 <page2kva>
c0107f97:	8b 55 08             	mov    0x8(%ebp),%edx
c0107f9a:	c1 ea 08             	shr    $0x8,%edx
c0107f9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107fa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107fa4:	74 0b                	je     c0107fb1 <swapfs_write+0x2b>
c0107fa6:	8b 15 7c 1b 12 c0    	mov    0xc0121b7c,%edx
c0107fac:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107faf:	72 23                	jb     c0107fd4 <swapfs_write+0x4e>
c0107fb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fb4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107fb8:	c7 44 24 08 6c a9 10 	movl   $0xc010a96c,0x8(%esp)
c0107fbf:	c0 
c0107fc0:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0107fc7:	00 
c0107fc8:	c7 04 24 5b a9 10 c0 	movl   $0xc010a95b,(%esp)
c0107fcf:	e8 08 8d ff ff       	call   c0100cdc <__panic>
c0107fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107fd7:	c1 e2 03             	shl    $0x3,%edx
c0107fda:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107fe1:	00 
c0107fe2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107fe6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107fea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107ff1:	e8 f6 9c ff ff       	call   c0101cec <ide_write_secs>
}
c0107ff6:	c9                   	leave  
c0107ff7:	c3                   	ret    

c0107ff8 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0107ff8:	55                   	push   %ebp
c0107ff9:	89 e5                	mov    %esp,%ebp
c0107ffb:	83 ec 58             	sub    $0x58,%esp
c0107ffe:	8b 45 10             	mov    0x10(%ebp),%eax
c0108001:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0108004:	8b 45 14             	mov    0x14(%ebp),%eax
c0108007:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010800a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010800d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108010:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108013:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0108016:	8b 45 18             	mov    0x18(%ebp),%eax
c0108019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010801c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010801f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108022:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108025:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0108028:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010802b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010802e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108032:	74 1c                	je     c0108050 <printnum+0x58>
c0108034:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108037:	ba 00 00 00 00       	mov    $0x0,%edx
c010803c:	f7 75 e4             	divl   -0x1c(%ebp)
c010803f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108042:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108045:	ba 00 00 00 00       	mov    $0x0,%edx
c010804a:	f7 75 e4             	divl   -0x1c(%ebp)
c010804d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108050:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108053:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108056:	f7 75 e4             	divl   -0x1c(%ebp)
c0108059:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010805c:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010805f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108062:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108065:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108068:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010806b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010806e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0108071:	8b 45 18             	mov    0x18(%ebp),%eax
c0108074:	ba 00 00 00 00       	mov    $0x0,%edx
c0108079:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010807c:	77 56                	ja     c01080d4 <printnum+0xdc>
c010807e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108081:	72 05                	jb     c0108088 <printnum+0x90>
c0108083:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0108086:	77 4c                	ja     c01080d4 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0108088:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010808b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010808e:	8b 45 20             	mov    0x20(%ebp),%eax
c0108091:	89 44 24 18          	mov    %eax,0x18(%esp)
c0108095:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108099:	8b 45 18             	mov    0x18(%ebp),%eax
c010809c:	89 44 24 10          	mov    %eax,0x10(%esp)
c01080a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01080a6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01080aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01080ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01080b8:	89 04 24             	mov    %eax,(%esp)
c01080bb:	e8 38 ff ff ff       	call   c0107ff8 <printnum>
c01080c0:	eb 1c                	jmp    c01080de <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01080c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080c9:	8b 45 20             	mov    0x20(%ebp),%eax
c01080cc:	89 04 24             	mov    %eax,(%esp)
c01080cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01080d2:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01080d4:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01080d8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01080dc:	7f e4                	jg     c01080c2 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01080de:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01080e1:	05 0c aa 10 c0       	add    $0xc010aa0c,%eax
c01080e6:	0f b6 00             	movzbl (%eax),%eax
c01080e9:	0f be c0             	movsbl %al,%eax
c01080ec:	8b 55 0c             	mov    0xc(%ebp),%edx
c01080ef:	89 54 24 04          	mov    %edx,0x4(%esp)
c01080f3:	89 04 24             	mov    %eax,(%esp)
c01080f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01080f9:	ff d0                	call   *%eax
}
c01080fb:	c9                   	leave  
c01080fc:	c3                   	ret    

c01080fd <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01080fd:	55                   	push   %ebp
c01080fe:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108100:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108104:	7e 14                	jle    c010811a <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0108106:	8b 45 08             	mov    0x8(%ebp),%eax
c0108109:	8b 00                	mov    (%eax),%eax
c010810b:	8d 48 08             	lea    0x8(%eax),%ecx
c010810e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108111:	89 0a                	mov    %ecx,(%edx)
c0108113:	8b 50 04             	mov    0x4(%eax),%edx
c0108116:	8b 00                	mov    (%eax),%eax
c0108118:	eb 30                	jmp    c010814a <getuint+0x4d>
    }
    else if (lflag) {
c010811a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010811e:	74 16                	je     c0108136 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108120:	8b 45 08             	mov    0x8(%ebp),%eax
c0108123:	8b 00                	mov    (%eax),%eax
c0108125:	8d 48 04             	lea    0x4(%eax),%ecx
c0108128:	8b 55 08             	mov    0x8(%ebp),%edx
c010812b:	89 0a                	mov    %ecx,(%edx)
c010812d:	8b 00                	mov    (%eax),%eax
c010812f:	ba 00 00 00 00       	mov    $0x0,%edx
c0108134:	eb 14                	jmp    c010814a <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0108136:	8b 45 08             	mov    0x8(%ebp),%eax
c0108139:	8b 00                	mov    (%eax),%eax
c010813b:	8d 48 04             	lea    0x4(%eax),%ecx
c010813e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108141:	89 0a                	mov    %ecx,(%edx)
c0108143:	8b 00                	mov    (%eax),%eax
c0108145:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010814a:	5d                   	pop    %ebp
c010814b:	c3                   	ret    

c010814c <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010814c:	55                   	push   %ebp
c010814d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010814f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108153:	7e 14                	jle    c0108169 <getint+0x1d>
        return va_arg(*ap, long long);
c0108155:	8b 45 08             	mov    0x8(%ebp),%eax
c0108158:	8b 00                	mov    (%eax),%eax
c010815a:	8d 48 08             	lea    0x8(%eax),%ecx
c010815d:	8b 55 08             	mov    0x8(%ebp),%edx
c0108160:	89 0a                	mov    %ecx,(%edx)
c0108162:	8b 50 04             	mov    0x4(%eax),%edx
c0108165:	8b 00                	mov    (%eax),%eax
c0108167:	eb 28                	jmp    c0108191 <getint+0x45>
    }
    else if (lflag) {
c0108169:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010816d:	74 12                	je     c0108181 <getint+0x35>
        return va_arg(*ap, long);
c010816f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108172:	8b 00                	mov    (%eax),%eax
c0108174:	8d 48 04             	lea    0x4(%eax),%ecx
c0108177:	8b 55 08             	mov    0x8(%ebp),%edx
c010817a:	89 0a                	mov    %ecx,(%edx)
c010817c:	8b 00                	mov    (%eax),%eax
c010817e:	99                   	cltd   
c010817f:	eb 10                	jmp    c0108191 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0108181:	8b 45 08             	mov    0x8(%ebp),%eax
c0108184:	8b 00                	mov    (%eax),%eax
c0108186:	8d 48 04             	lea    0x4(%eax),%ecx
c0108189:	8b 55 08             	mov    0x8(%ebp),%edx
c010818c:	89 0a                	mov    %ecx,(%edx)
c010818e:	8b 00                	mov    (%eax),%eax
c0108190:	99                   	cltd   
    }
}
c0108191:	5d                   	pop    %ebp
c0108192:	c3                   	ret    

c0108193 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108193:	55                   	push   %ebp
c0108194:	89 e5                	mov    %esp,%ebp
c0108196:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0108199:	8d 45 14             	lea    0x14(%ebp),%eax
c010819c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010819f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01081a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01081a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01081a9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01081ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01081b7:	89 04 24             	mov    %eax,(%esp)
c01081ba:	e8 02 00 00 00       	call   c01081c1 <vprintfmt>
    va_end(ap);
}
c01081bf:	c9                   	leave  
c01081c0:	c3                   	ret    

c01081c1 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01081c1:	55                   	push   %ebp
c01081c2:	89 e5                	mov    %esp,%ebp
c01081c4:	56                   	push   %esi
c01081c5:	53                   	push   %ebx
c01081c6:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01081c9:	eb 18                	jmp    c01081e3 <vprintfmt+0x22>
            if (ch == '\0') {
c01081cb:	85 db                	test   %ebx,%ebx
c01081cd:	75 05                	jne    c01081d4 <vprintfmt+0x13>
                return;
c01081cf:	e9 d1 03 00 00       	jmp    c01085a5 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01081d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081db:	89 1c 24             	mov    %ebx,(%esp)
c01081de:	8b 45 08             	mov    0x8(%ebp),%eax
c01081e1:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01081e3:	8b 45 10             	mov    0x10(%ebp),%eax
c01081e6:	8d 50 01             	lea    0x1(%eax),%edx
c01081e9:	89 55 10             	mov    %edx,0x10(%ebp)
c01081ec:	0f b6 00             	movzbl (%eax),%eax
c01081ef:	0f b6 d8             	movzbl %al,%ebx
c01081f2:	83 fb 25             	cmp    $0x25,%ebx
c01081f5:	75 d4                	jne    c01081cb <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01081f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01081fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108205:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0108208:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010820f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108212:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0108215:	8b 45 10             	mov    0x10(%ebp),%eax
c0108218:	8d 50 01             	lea    0x1(%eax),%edx
c010821b:	89 55 10             	mov    %edx,0x10(%ebp)
c010821e:	0f b6 00             	movzbl (%eax),%eax
c0108221:	0f b6 d8             	movzbl %al,%ebx
c0108224:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0108227:	83 f8 55             	cmp    $0x55,%eax
c010822a:	0f 87 44 03 00 00    	ja     c0108574 <vprintfmt+0x3b3>
c0108230:	8b 04 85 30 aa 10 c0 	mov    -0x3fef55d0(,%eax,4),%eax
c0108237:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0108239:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010823d:	eb d6                	jmp    c0108215 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010823f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0108243:	eb d0                	jmp    c0108215 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108245:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010824c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010824f:	89 d0                	mov    %edx,%eax
c0108251:	c1 e0 02             	shl    $0x2,%eax
c0108254:	01 d0                	add    %edx,%eax
c0108256:	01 c0                	add    %eax,%eax
c0108258:	01 d8                	add    %ebx,%eax
c010825a:	83 e8 30             	sub    $0x30,%eax
c010825d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0108260:	8b 45 10             	mov    0x10(%ebp),%eax
c0108263:	0f b6 00             	movzbl (%eax),%eax
c0108266:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108269:	83 fb 2f             	cmp    $0x2f,%ebx
c010826c:	7e 0b                	jle    c0108279 <vprintfmt+0xb8>
c010826e:	83 fb 39             	cmp    $0x39,%ebx
c0108271:	7f 06                	jg     c0108279 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108273:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0108277:	eb d3                	jmp    c010824c <vprintfmt+0x8b>
            goto process_precision;
c0108279:	eb 33                	jmp    c01082ae <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010827b:	8b 45 14             	mov    0x14(%ebp),%eax
c010827e:	8d 50 04             	lea    0x4(%eax),%edx
c0108281:	89 55 14             	mov    %edx,0x14(%ebp)
c0108284:	8b 00                	mov    (%eax),%eax
c0108286:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0108289:	eb 23                	jmp    c01082ae <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010828b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010828f:	79 0c                	jns    c010829d <vprintfmt+0xdc>
                width = 0;
c0108291:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108298:	e9 78 ff ff ff       	jmp    c0108215 <vprintfmt+0x54>
c010829d:	e9 73 ff ff ff       	jmp    c0108215 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01082a2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01082a9:	e9 67 ff ff ff       	jmp    c0108215 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01082ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01082b2:	79 12                	jns    c01082c6 <vprintfmt+0x105>
                width = precision, precision = -1;
c01082b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01082ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01082c1:	e9 4f ff ff ff       	jmp    c0108215 <vprintfmt+0x54>
c01082c6:	e9 4a ff ff ff       	jmp    c0108215 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01082cb:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01082cf:	e9 41 ff ff ff       	jmp    c0108215 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01082d4:	8b 45 14             	mov    0x14(%ebp),%eax
c01082d7:	8d 50 04             	lea    0x4(%eax),%edx
c01082da:	89 55 14             	mov    %edx,0x14(%ebp)
c01082dd:	8b 00                	mov    (%eax),%eax
c01082df:	8b 55 0c             	mov    0xc(%ebp),%edx
c01082e2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01082e6:	89 04 24             	mov    %eax,(%esp)
c01082e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01082ec:	ff d0                	call   *%eax
            break;
c01082ee:	e9 ac 02 00 00       	jmp    c010859f <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01082f3:	8b 45 14             	mov    0x14(%ebp),%eax
c01082f6:	8d 50 04             	lea    0x4(%eax),%edx
c01082f9:	89 55 14             	mov    %edx,0x14(%ebp)
c01082fc:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01082fe:	85 db                	test   %ebx,%ebx
c0108300:	79 02                	jns    c0108304 <vprintfmt+0x143>
                err = -err;
c0108302:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108304:	83 fb 06             	cmp    $0x6,%ebx
c0108307:	7f 0b                	jg     c0108314 <vprintfmt+0x153>
c0108309:	8b 34 9d f0 a9 10 c0 	mov    -0x3fef5610(,%ebx,4),%esi
c0108310:	85 f6                	test   %esi,%esi
c0108312:	75 23                	jne    c0108337 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0108314:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108318:	c7 44 24 08 1d aa 10 	movl   $0xc010aa1d,0x8(%esp)
c010831f:	c0 
c0108320:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108323:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108327:	8b 45 08             	mov    0x8(%ebp),%eax
c010832a:	89 04 24             	mov    %eax,(%esp)
c010832d:	e8 61 fe ff ff       	call   c0108193 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108332:	e9 68 02 00 00       	jmp    c010859f <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0108337:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010833b:	c7 44 24 08 26 aa 10 	movl   $0xc010aa26,0x8(%esp)
c0108342:	c0 
c0108343:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108346:	89 44 24 04          	mov    %eax,0x4(%esp)
c010834a:	8b 45 08             	mov    0x8(%ebp),%eax
c010834d:	89 04 24             	mov    %eax,(%esp)
c0108350:	e8 3e fe ff ff       	call   c0108193 <printfmt>
            }
            break;
c0108355:	e9 45 02 00 00       	jmp    c010859f <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010835a:	8b 45 14             	mov    0x14(%ebp),%eax
c010835d:	8d 50 04             	lea    0x4(%eax),%edx
c0108360:	89 55 14             	mov    %edx,0x14(%ebp)
c0108363:	8b 30                	mov    (%eax),%esi
c0108365:	85 f6                	test   %esi,%esi
c0108367:	75 05                	jne    c010836e <vprintfmt+0x1ad>
                p = "(null)";
c0108369:	be 29 aa 10 c0       	mov    $0xc010aa29,%esi
            }
            if (width > 0 && padc != '-') {
c010836e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108372:	7e 3e                	jle    c01083b2 <vprintfmt+0x1f1>
c0108374:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0108378:	74 38                	je     c01083b2 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010837a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010837d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108380:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108384:	89 34 24             	mov    %esi,(%esp)
c0108387:	e8 ed 03 00 00       	call   c0108779 <strnlen>
c010838c:	29 c3                	sub    %eax,%ebx
c010838e:	89 d8                	mov    %ebx,%eax
c0108390:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108393:	eb 17                	jmp    c01083ac <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0108395:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108399:	8b 55 0c             	mov    0xc(%ebp),%edx
c010839c:	89 54 24 04          	mov    %edx,0x4(%esp)
c01083a0:	89 04 24             	mov    %eax,(%esp)
c01083a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01083a6:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01083a8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01083ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01083b0:	7f e3                	jg     c0108395 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01083b2:	eb 38                	jmp    c01083ec <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01083b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01083b8:	74 1f                	je     c01083d9 <vprintfmt+0x218>
c01083ba:	83 fb 1f             	cmp    $0x1f,%ebx
c01083bd:	7e 05                	jle    c01083c4 <vprintfmt+0x203>
c01083bf:	83 fb 7e             	cmp    $0x7e,%ebx
c01083c2:	7e 15                	jle    c01083d9 <vprintfmt+0x218>
                    putch('?', putdat);
c01083c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083cb:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01083d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01083d5:	ff d0                	call   *%eax
c01083d7:	eb 0f                	jmp    c01083e8 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01083d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083e0:	89 1c 24             	mov    %ebx,(%esp)
c01083e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01083e6:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01083e8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01083ec:	89 f0                	mov    %esi,%eax
c01083ee:	8d 70 01             	lea    0x1(%eax),%esi
c01083f1:	0f b6 00             	movzbl (%eax),%eax
c01083f4:	0f be d8             	movsbl %al,%ebx
c01083f7:	85 db                	test   %ebx,%ebx
c01083f9:	74 10                	je     c010840b <vprintfmt+0x24a>
c01083fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01083ff:	78 b3                	js     c01083b4 <vprintfmt+0x1f3>
c0108401:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0108405:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108409:	79 a9                	jns    c01083b4 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010840b:	eb 17                	jmp    c0108424 <vprintfmt+0x263>
                putch(' ', putdat);
c010840d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108410:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108414:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010841b:	8b 45 08             	mov    0x8(%ebp),%eax
c010841e:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108420:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108424:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108428:	7f e3                	jg     c010840d <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010842a:	e9 70 01 00 00       	jmp    c010859f <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010842f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108432:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108436:	8d 45 14             	lea    0x14(%ebp),%eax
c0108439:	89 04 24             	mov    %eax,(%esp)
c010843c:	e8 0b fd ff ff       	call   c010814c <getint>
c0108441:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108444:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0108447:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010844a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010844d:	85 d2                	test   %edx,%edx
c010844f:	79 26                	jns    c0108477 <vprintfmt+0x2b6>
                putch('-', putdat);
c0108451:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108454:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108458:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010845f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108462:	ff d0                	call   *%eax
                num = -(long long)num;
c0108464:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108467:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010846a:	f7 d8                	neg    %eax
c010846c:	83 d2 00             	adc    $0x0,%edx
c010846f:	f7 da                	neg    %edx
c0108471:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108474:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0108477:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010847e:	e9 a8 00 00 00       	jmp    c010852b <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0108483:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108486:	89 44 24 04          	mov    %eax,0x4(%esp)
c010848a:	8d 45 14             	lea    0x14(%ebp),%eax
c010848d:	89 04 24             	mov    %eax,(%esp)
c0108490:	e8 68 fc ff ff       	call   c01080fd <getuint>
c0108495:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108498:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010849b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01084a2:	e9 84 00 00 00       	jmp    c010852b <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01084a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01084aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084ae:	8d 45 14             	lea    0x14(%ebp),%eax
c01084b1:	89 04 24             	mov    %eax,(%esp)
c01084b4:	e8 44 fc ff ff       	call   c01080fd <getuint>
c01084b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01084bf:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01084c6:	eb 63                	jmp    c010852b <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01084c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084cf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01084d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01084d9:	ff d0                	call   *%eax
            putch('x', putdat);
c01084db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084e2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01084e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01084ec:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01084ee:	8b 45 14             	mov    0x14(%ebp),%eax
c01084f1:	8d 50 04             	lea    0x4(%eax),%edx
c01084f4:	89 55 14             	mov    %edx,0x14(%ebp)
c01084f7:	8b 00                	mov    (%eax),%eax
c01084f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0108503:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010850a:	eb 1f                	jmp    c010852b <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010850c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010850f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108513:	8d 45 14             	lea    0x14(%ebp),%eax
c0108516:	89 04 24             	mov    %eax,(%esp)
c0108519:	e8 df fb ff ff       	call   c01080fd <getuint>
c010851e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108521:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0108524:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010852b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010852f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108532:	89 54 24 18          	mov    %edx,0x18(%esp)
c0108536:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108539:	89 54 24 14          	mov    %edx,0x14(%esp)
c010853d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108541:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108544:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108547:	89 44 24 08          	mov    %eax,0x8(%esp)
c010854b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010854f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108552:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108556:	8b 45 08             	mov    0x8(%ebp),%eax
c0108559:	89 04 24             	mov    %eax,(%esp)
c010855c:	e8 97 fa ff ff       	call   c0107ff8 <printnum>
            break;
c0108561:	eb 3c                	jmp    c010859f <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0108563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108566:	89 44 24 04          	mov    %eax,0x4(%esp)
c010856a:	89 1c 24             	mov    %ebx,(%esp)
c010856d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108570:	ff d0                	call   *%eax
            break;
c0108572:	eb 2b                	jmp    c010859f <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108574:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108577:	89 44 24 04          	mov    %eax,0x4(%esp)
c010857b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0108582:	8b 45 08             	mov    0x8(%ebp),%eax
c0108585:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108587:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010858b:	eb 04                	jmp    c0108591 <vprintfmt+0x3d0>
c010858d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108591:	8b 45 10             	mov    0x10(%ebp),%eax
c0108594:	83 e8 01             	sub    $0x1,%eax
c0108597:	0f b6 00             	movzbl (%eax),%eax
c010859a:	3c 25                	cmp    $0x25,%al
c010859c:	75 ef                	jne    c010858d <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010859e:	90                   	nop
        }
    }
c010859f:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01085a0:	e9 3e fc ff ff       	jmp    c01081e3 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01085a5:	83 c4 40             	add    $0x40,%esp
c01085a8:	5b                   	pop    %ebx
c01085a9:	5e                   	pop    %esi
c01085aa:	5d                   	pop    %ebp
c01085ab:	c3                   	ret    

c01085ac <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01085ac:	55                   	push   %ebp
c01085ad:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01085af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085b2:	8b 40 08             	mov    0x8(%eax),%eax
c01085b5:	8d 50 01             	lea    0x1(%eax),%edx
c01085b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085bb:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01085be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085c1:	8b 10                	mov    (%eax),%edx
c01085c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085c6:	8b 40 04             	mov    0x4(%eax),%eax
c01085c9:	39 c2                	cmp    %eax,%edx
c01085cb:	73 12                	jae    c01085df <sprintputch+0x33>
        *b->buf ++ = ch;
c01085cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085d0:	8b 00                	mov    (%eax),%eax
c01085d2:	8d 48 01             	lea    0x1(%eax),%ecx
c01085d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01085d8:	89 0a                	mov    %ecx,(%edx)
c01085da:	8b 55 08             	mov    0x8(%ebp),%edx
c01085dd:	88 10                	mov    %dl,(%eax)
    }
}
c01085df:	5d                   	pop    %ebp
c01085e0:	c3                   	ret    

c01085e1 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01085e1:	55                   	push   %ebp
c01085e2:	89 e5                	mov    %esp,%ebp
c01085e4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01085e7:	8d 45 14             	lea    0x14(%ebp),%eax
c01085ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01085ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01085f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01085f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01085fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108602:	8b 45 08             	mov    0x8(%ebp),%eax
c0108605:	89 04 24             	mov    %eax,(%esp)
c0108608:	e8 08 00 00 00       	call   c0108615 <vsnprintf>
c010860d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0108610:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108613:	c9                   	leave  
c0108614:	c3                   	ret    

c0108615 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108615:	55                   	push   %ebp
c0108616:	89 e5                	mov    %esp,%ebp
c0108618:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010861b:	8b 45 08             	mov    0x8(%ebp),%eax
c010861e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108621:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108624:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108627:	8b 45 08             	mov    0x8(%ebp),%eax
c010862a:	01 d0                	add    %edx,%eax
c010862c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010862f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108636:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010863a:	74 0a                	je     c0108646 <vsnprintf+0x31>
c010863c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010863f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108642:	39 c2                	cmp    %eax,%edx
c0108644:	76 07                	jbe    c010864d <vsnprintf+0x38>
        return -E_INVAL;
c0108646:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010864b:	eb 2a                	jmp    c0108677 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010864d:	8b 45 14             	mov    0x14(%ebp),%eax
c0108650:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108654:	8b 45 10             	mov    0x10(%ebp),%eax
c0108657:	89 44 24 08          	mov    %eax,0x8(%esp)
c010865b:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010865e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108662:	c7 04 24 ac 85 10 c0 	movl   $0xc01085ac,(%esp)
c0108669:	e8 53 fb ff ff       	call   c01081c1 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010866e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108671:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108674:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108677:	c9                   	leave  
c0108678:	c3                   	ret    

c0108679 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108679:	55                   	push   %ebp
c010867a:	89 e5                	mov    %esp,%ebp
c010867c:	57                   	push   %edi
c010867d:	56                   	push   %esi
c010867e:	53                   	push   %ebx
c010867f:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0108682:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c0108687:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c010868d:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0108693:	6b f0 05             	imul   $0x5,%eax,%esi
c0108696:	01 f7                	add    %esi,%edi
c0108698:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010869d:	f7 e6                	mul    %esi
c010869f:	8d 34 17             	lea    (%edi,%edx,1),%esi
c01086a2:	89 f2                	mov    %esi,%edx
c01086a4:	83 c0 0b             	add    $0xb,%eax
c01086a7:	83 d2 00             	adc    $0x0,%edx
c01086aa:	89 c7                	mov    %eax,%edi
c01086ac:	83 e7 ff             	and    $0xffffffff,%edi
c01086af:	89 f9                	mov    %edi,%ecx
c01086b1:	0f b7 da             	movzwl %dx,%ebx
c01086b4:	89 0d 60 0a 12 c0    	mov    %ecx,0xc0120a60
c01086ba:	89 1d 64 0a 12 c0    	mov    %ebx,0xc0120a64
    unsigned long long result = (next >> 12);
c01086c0:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c01086c5:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c01086cb:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01086cf:	c1 ea 0c             	shr    $0xc,%edx
c01086d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01086d5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c01086d8:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c01086df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01086e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01086e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01086e8:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01086eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01086f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01086f5:	74 1c                	je     c0108713 <rand+0x9a>
c01086f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086fa:	ba 00 00 00 00       	mov    $0x0,%edx
c01086ff:	f7 75 dc             	divl   -0x24(%ebp)
c0108702:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108705:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108708:	ba 00 00 00 00       	mov    $0x0,%edx
c010870d:	f7 75 dc             	divl   -0x24(%ebp)
c0108710:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108713:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108716:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108719:	f7 75 dc             	divl   -0x24(%ebp)
c010871c:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010871f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108722:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108725:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108728:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010872b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010872e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0108731:	83 c4 24             	add    $0x24,%esp
c0108734:	5b                   	pop    %ebx
c0108735:	5e                   	pop    %esi
c0108736:	5f                   	pop    %edi
c0108737:	5d                   	pop    %ebp
c0108738:	c3                   	ret    

c0108739 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0108739:	55                   	push   %ebp
c010873a:	89 e5                	mov    %esp,%ebp
    next = seed;
c010873c:	8b 45 08             	mov    0x8(%ebp),%eax
c010873f:	ba 00 00 00 00       	mov    $0x0,%edx
c0108744:	a3 60 0a 12 c0       	mov    %eax,0xc0120a60
c0108749:	89 15 64 0a 12 c0    	mov    %edx,0xc0120a64
}
c010874f:	5d                   	pop    %ebp
c0108750:	c3                   	ret    

c0108751 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0108751:	55                   	push   %ebp
c0108752:	89 e5                	mov    %esp,%ebp
c0108754:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108757:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010875e:	eb 04                	jmp    c0108764 <strlen+0x13>
        cnt ++;
c0108760:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0108764:	8b 45 08             	mov    0x8(%ebp),%eax
c0108767:	8d 50 01             	lea    0x1(%eax),%edx
c010876a:	89 55 08             	mov    %edx,0x8(%ebp)
c010876d:	0f b6 00             	movzbl (%eax),%eax
c0108770:	84 c0                	test   %al,%al
c0108772:	75 ec                	jne    c0108760 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0108774:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108777:	c9                   	leave  
c0108778:	c3                   	ret    

c0108779 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0108779:	55                   	push   %ebp
c010877a:	89 e5                	mov    %esp,%ebp
c010877c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010877f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108786:	eb 04                	jmp    c010878c <strnlen+0x13>
        cnt ++;
c0108788:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010878c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010878f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108792:	73 10                	jae    c01087a4 <strnlen+0x2b>
c0108794:	8b 45 08             	mov    0x8(%ebp),%eax
c0108797:	8d 50 01             	lea    0x1(%eax),%edx
c010879a:	89 55 08             	mov    %edx,0x8(%ebp)
c010879d:	0f b6 00             	movzbl (%eax),%eax
c01087a0:	84 c0                	test   %al,%al
c01087a2:	75 e4                	jne    c0108788 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01087a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01087a7:	c9                   	leave  
c01087a8:	c3                   	ret    

c01087a9 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01087a9:	55                   	push   %ebp
c01087aa:	89 e5                	mov    %esp,%ebp
c01087ac:	57                   	push   %edi
c01087ad:	56                   	push   %esi
c01087ae:	83 ec 20             	sub    $0x20,%esp
c01087b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01087b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01087b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01087bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01087c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087c3:	89 d1                	mov    %edx,%ecx
c01087c5:	89 c2                	mov    %eax,%edx
c01087c7:	89 ce                	mov    %ecx,%esi
c01087c9:	89 d7                	mov    %edx,%edi
c01087cb:	ac                   	lods   %ds:(%esi),%al
c01087cc:	aa                   	stos   %al,%es:(%edi)
c01087cd:	84 c0                	test   %al,%al
c01087cf:	75 fa                	jne    c01087cb <strcpy+0x22>
c01087d1:	89 fa                	mov    %edi,%edx
c01087d3:	89 f1                	mov    %esi,%ecx
c01087d5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01087d8:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01087db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01087de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01087e1:	83 c4 20             	add    $0x20,%esp
c01087e4:	5e                   	pop    %esi
c01087e5:	5f                   	pop    %edi
c01087e6:	5d                   	pop    %ebp
c01087e7:	c3                   	ret    

c01087e8 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01087e8:	55                   	push   %ebp
c01087e9:	89 e5                	mov    %esp,%ebp
c01087eb:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01087ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01087f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01087f4:	eb 21                	jmp    c0108817 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01087f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087f9:	0f b6 10             	movzbl (%eax),%edx
c01087fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087ff:	88 10                	mov    %dl,(%eax)
c0108801:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108804:	0f b6 00             	movzbl (%eax),%eax
c0108807:	84 c0                	test   %al,%al
c0108809:	74 04                	je     c010880f <strncpy+0x27>
            src ++;
c010880b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010880f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108813:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0108817:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010881b:	75 d9                	jne    c01087f6 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010881d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108820:	c9                   	leave  
c0108821:	c3                   	ret    

c0108822 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0108822:	55                   	push   %ebp
c0108823:	89 e5                	mov    %esp,%ebp
c0108825:	57                   	push   %edi
c0108826:	56                   	push   %esi
c0108827:	83 ec 20             	sub    $0x20,%esp
c010882a:	8b 45 08             	mov    0x8(%ebp),%eax
c010882d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108830:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108833:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0108836:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108839:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010883c:	89 d1                	mov    %edx,%ecx
c010883e:	89 c2                	mov    %eax,%edx
c0108840:	89 ce                	mov    %ecx,%esi
c0108842:	89 d7                	mov    %edx,%edi
c0108844:	ac                   	lods   %ds:(%esi),%al
c0108845:	ae                   	scas   %es:(%edi),%al
c0108846:	75 08                	jne    c0108850 <strcmp+0x2e>
c0108848:	84 c0                	test   %al,%al
c010884a:	75 f8                	jne    c0108844 <strcmp+0x22>
c010884c:	31 c0                	xor    %eax,%eax
c010884e:	eb 04                	jmp    c0108854 <strcmp+0x32>
c0108850:	19 c0                	sbb    %eax,%eax
c0108852:	0c 01                	or     $0x1,%al
c0108854:	89 fa                	mov    %edi,%edx
c0108856:	89 f1                	mov    %esi,%ecx
c0108858:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010885b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010885e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0108861:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108864:	83 c4 20             	add    $0x20,%esp
c0108867:	5e                   	pop    %esi
c0108868:	5f                   	pop    %edi
c0108869:	5d                   	pop    %ebp
c010886a:	c3                   	ret    

c010886b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010886b:	55                   	push   %ebp
c010886c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010886e:	eb 0c                	jmp    c010887c <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0108870:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108874:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108878:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010887c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108880:	74 1a                	je     c010889c <strncmp+0x31>
c0108882:	8b 45 08             	mov    0x8(%ebp),%eax
c0108885:	0f b6 00             	movzbl (%eax),%eax
c0108888:	84 c0                	test   %al,%al
c010888a:	74 10                	je     c010889c <strncmp+0x31>
c010888c:	8b 45 08             	mov    0x8(%ebp),%eax
c010888f:	0f b6 10             	movzbl (%eax),%edx
c0108892:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108895:	0f b6 00             	movzbl (%eax),%eax
c0108898:	38 c2                	cmp    %al,%dl
c010889a:	74 d4                	je     c0108870 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010889c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01088a0:	74 18                	je     c01088ba <strncmp+0x4f>
c01088a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01088a5:	0f b6 00             	movzbl (%eax),%eax
c01088a8:	0f b6 d0             	movzbl %al,%edx
c01088ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088ae:	0f b6 00             	movzbl (%eax),%eax
c01088b1:	0f b6 c0             	movzbl %al,%eax
c01088b4:	29 c2                	sub    %eax,%edx
c01088b6:	89 d0                	mov    %edx,%eax
c01088b8:	eb 05                	jmp    c01088bf <strncmp+0x54>
c01088ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01088bf:	5d                   	pop    %ebp
c01088c0:	c3                   	ret    

c01088c1 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01088c1:	55                   	push   %ebp
c01088c2:	89 e5                	mov    %esp,%ebp
c01088c4:	83 ec 04             	sub    $0x4,%esp
c01088c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088ca:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01088cd:	eb 14                	jmp    c01088e3 <strchr+0x22>
        if (*s == c) {
c01088cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01088d2:	0f b6 00             	movzbl (%eax),%eax
c01088d5:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01088d8:	75 05                	jne    c01088df <strchr+0x1e>
            return (char *)s;
c01088da:	8b 45 08             	mov    0x8(%ebp),%eax
c01088dd:	eb 13                	jmp    c01088f2 <strchr+0x31>
        }
        s ++;
c01088df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c01088e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01088e6:	0f b6 00             	movzbl (%eax),%eax
c01088e9:	84 c0                	test   %al,%al
c01088eb:	75 e2                	jne    c01088cf <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c01088ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01088f2:	c9                   	leave  
c01088f3:	c3                   	ret    

c01088f4 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01088f4:	55                   	push   %ebp
c01088f5:	89 e5                	mov    %esp,%ebp
c01088f7:	83 ec 04             	sub    $0x4,%esp
c01088fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088fd:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108900:	eb 11                	jmp    c0108913 <strfind+0x1f>
        if (*s == c) {
c0108902:	8b 45 08             	mov    0x8(%ebp),%eax
c0108905:	0f b6 00             	movzbl (%eax),%eax
c0108908:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010890b:	75 02                	jne    c010890f <strfind+0x1b>
            break;
c010890d:	eb 0e                	jmp    c010891d <strfind+0x29>
        }
        s ++;
c010890f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0108913:	8b 45 08             	mov    0x8(%ebp),%eax
c0108916:	0f b6 00             	movzbl (%eax),%eax
c0108919:	84 c0                	test   %al,%al
c010891b:	75 e5                	jne    c0108902 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010891d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108920:	c9                   	leave  
c0108921:	c3                   	ret    

c0108922 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0108922:	55                   	push   %ebp
c0108923:	89 e5                	mov    %esp,%ebp
c0108925:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0108928:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010892f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108936:	eb 04                	jmp    c010893c <strtol+0x1a>
        s ++;
c0108938:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010893c:	8b 45 08             	mov    0x8(%ebp),%eax
c010893f:	0f b6 00             	movzbl (%eax),%eax
c0108942:	3c 20                	cmp    $0x20,%al
c0108944:	74 f2                	je     c0108938 <strtol+0x16>
c0108946:	8b 45 08             	mov    0x8(%ebp),%eax
c0108949:	0f b6 00             	movzbl (%eax),%eax
c010894c:	3c 09                	cmp    $0x9,%al
c010894e:	74 e8                	je     c0108938 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0108950:	8b 45 08             	mov    0x8(%ebp),%eax
c0108953:	0f b6 00             	movzbl (%eax),%eax
c0108956:	3c 2b                	cmp    $0x2b,%al
c0108958:	75 06                	jne    c0108960 <strtol+0x3e>
        s ++;
c010895a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010895e:	eb 15                	jmp    c0108975 <strtol+0x53>
    }
    else if (*s == '-') {
c0108960:	8b 45 08             	mov    0x8(%ebp),%eax
c0108963:	0f b6 00             	movzbl (%eax),%eax
c0108966:	3c 2d                	cmp    $0x2d,%al
c0108968:	75 0b                	jne    c0108975 <strtol+0x53>
        s ++, neg = 1;
c010896a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010896e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108975:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108979:	74 06                	je     c0108981 <strtol+0x5f>
c010897b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010897f:	75 24                	jne    c01089a5 <strtol+0x83>
c0108981:	8b 45 08             	mov    0x8(%ebp),%eax
c0108984:	0f b6 00             	movzbl (%eax),%eax
c0108987:	3c 30                	cmp    $0x30,%al
c0108989:	75 1a                	jne    c01089a5 <strtol+0x83>
c010898b:	8b 45 08             	mov    0x8(%ebp),%eax
c010898e:	83 c0 01             	add    $0x1,%eax
c0108991:	0f b6 00             	movzbl (%eax),%eax
c0108994:	3c 78                	cmp    $0x78,%al
c0108996:	75 0d                	jne    c01089a5 <strtol+0x83>
        s += 2, base = 16;
c0108998:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010899c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01089a3:	eb 2a                	jmp    c01089cf <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01089a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01089a9:	75 17                	jne    c01089c2 <strtol+0xa0>
c01089ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01089ae:	0f b6 00             	movzbl (%eax),%eax
c01089b1:	3c 30                	cmp    $0x30,%al
c01089b3:	75 0d                	jne    c01089c2 <strtol+0xa0>
        s ++, base = 8;
c01089b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01089b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01089c0:	eb 0d                	jmp    c01089cf <strtol+0xad>
    }
    else if (base == 0) {
c01089c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01089c6:	75 07                	jne    c01089cf <strtol+0xad>
        base = 10;
c01089c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01089cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01089d2:	0f b6 00             	movzbl (%eax),%eax
c01089d5:	3c 2f                	cmp    $0x2f,%al
c01089d7:	7e 1b                	jle    c01089f4 <strtol+0xd2>
c01089d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01089dc:	0f b6 00             	movzbl (%eax),%eax
c01089df:	3c 39                	cmp    $0x39,%al
c01089e1:	7f 11                	jg     c01089f4 <strtol+0xd2>
            dig = *s - '0';
c01089e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e6:	0f b6 00             	movzbl (%eax),%eax
c01089e9:	0f be c0             	movsbl %al,%eax
c01089ec:	83 e8 30             	sub    $0x30,%eax
c01089ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089f2:	eb 48                	jmp    c0108a3c <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01089f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01089f7:	0f b6 00             	movzbl (%eax),%eax
c01089fa:	3c 60                	cmp    $0x60,%al
c01089fc:	7e 1b                	jle    c0108a19 <strtol+0xf7>
c01089fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a01:	0f b6 00             	movzbl (%eax),%eax
c0108a04:	3c 7a                	cmp    $0x7a,%al
c0108a06:	7f 11                	jg     c0108a19 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0108a08:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a0b:	0f b6 00             	movzbl (%eax),%eax
c0108a0e:	0f be c0             	movsbl %al,%eax
c0108a11:	83 e8 57             	sub    $0x57,%eax
c0108a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a17:	eb 23                	jmp    c0108a3c <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a1c:	0f b6 00             	movzbl (%eax),%eax
c0108a1f:	3c 40                	cmp    $0x40,%al
c0108a21:	7e 3d                	jle    c0108a60 <strtol+0x13e>
c0108a23:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a26:	0f b6 00             	movzbl (%eax),%eax
c0108a29:	3c 5a                	cmp    $0x5a,%al
c0108a2b:	7f 33                	jg     c0108a60 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0108a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a30:	0f b6 00             	movzbl (%eax),%eax
c0108a33:	0f be c0             	movsbl %al,%eax
c0108a36:	83 e8 37             	sub    $0x37,%eax
c0108a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a3f:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108a42:	7c 02                	jl     c0108a46 <strtol+0x124>
            break;
c0108a44:	eb 1a                	jmp    c0108a60 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0108a46:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108a4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a4d:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108a51:	89 c2                	mov    %eax,%edx
c0108a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a56:	01 d0                	add    %edx,%eax
c0108a58:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108a5b:	e9 6f ff ff ff       	jmp    c01089cf <strtol+0xad>

    if (endptr) {
c0108a60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108a64:	74 08                	je     c0108a6e <strtol+0x14c>
        *endptr = (char *) s;
c0108a66:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a69:	8b 55 08             	mov    0x8(%ebp),%edx
c0108a6c:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108a6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108a72:	74 07                	je     c0108a7b <strtol+0x159>
c0108a74:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a77:	f7 d8                	neg    %eax
c0108a79:	eb 03                	jmp    c0108a7e <strtol+0x15c>
c0108a7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108a7e:	c9                   	leave  
c0108a7f:	c3                   	ret    

c0108a80 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108a80:	55                   	push   %ebp
c0108a81:	89 e5                	mov    %esp,%ebp
c0108a83:	57                   	push   %edi
c0108a84:	83 ec 24             	sub    $0x24,%esp
c0108a87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a8a:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108a8d:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108a91:	8b 55 08             	mov    0x8(%ebp),%edx
c0108a94:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108a97:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108a9a:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108aa0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108aa3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108aa7:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108aaa:	89 d7                	mov    %edx,%edi
c0108aac:	f3 aa                	rep stos %al,%es:(%edi)
c0108aae:	89 fa                	mov    %edi,%edx
c0108ab0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108ab3:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108ab9:	83 c4 24             	add    $0x24,%esp
c0108abc:	5f                   	pop    %edi
c0108abd:	5d                   	pop    %ebp
c0108abe:	c3                   	ret    

c0108abf <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108abf:	55                   	push   %ebp
c0108ac0:	89 e5                	mov    %esp,%ebp
c0108ac2:	57                   	push   %edi
c0108ac3:	56                   	push   %esi
c0108ac4:	53                   	push   %ebx
c0108ac5:	83 ec 30             	sub    $0x30,%esp
c0108ac8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108ace:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ad1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108ad4:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ad7:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108add:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108ae0:	73 42                	jae    c0108b24 <memmove+0x65>
c0108ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108aeb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108af1:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108af4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108af7:	c1 e8 02             	shr    $0x2,%eax
c0108afa:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108afc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108b02:	89 d7                	mov    %edx,%edi
c0108b04:	89 c6                	mov    %eax,%esi
c0108b06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b08:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108b0b:	83 e1 03             	and    $0x3,%ecx
c0108b0e:	74 02                	je     c0108b12 <memmove+0x53>
c0108b10:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b12:	89 f0                	mov    %esi,%eax
c0108b14:	89 fa                	mov    %edi,%edx
c0108b16:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108b19:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108b1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108b22:	eb 36                	jmp    c0108b5a <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b27:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b2d:	01 c2                	add    %eax,%edx
c0108b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b32:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b38:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0108b3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b3e:	89 c1                	mov    %eax,%ecx
c0108b40:	89 d8                	mov    %ebx,%eax
c0108b42:	89 d6                	mov    %edx,%esi
c0108b44:	89 c7                	mov    %eax,%edi
c0108b46:	fd                   	std    
c0108b47:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b49:	fc                   	cld    
c0108b4a:	89 f8                	mov    %edi,%eax
c0108b4c:	89 f2                	mov    %esi,%edx
c0108b4e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108b51:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108b54:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108b5a:	83 c4 30             	add    $0x30,%esp
c0108b5d:	5b                   	pop    %ebx
c0108b5e:	5e                   	pop    %esi
c0108b5f:	5f                   	pop    %edi
c0108b60:	5d                   	pop    %ebp
c0108b61:	c3                   	ret    

c0108b62 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108b62:	55                   	push   %ebp
c0108b63:	89 e5                	mov    %esp,%ebp
c0108b65:	57                   	push   %edi
c0108b66:	56                   	push   %esi
c0108b67:	83 ec 20             	sub    $0x20,%esp
c0108b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108b70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b76:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b7f:	c1 e8 02             	shr    $0x2,%eax
c0108b82:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b8a:	89 d7                	mov    %edx,%edi
c0108b8c:	89 c6                	mov    %eax,%esi
c0108b8e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b90:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108b93:	83 e1 03             	and    $0x3,%ecx
c0108b96:	74 02                	je     c0108b9a <memcpy+0x38>
c0108b98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b9a:	89 f0                	mov    %esi,%eax
c0108b9c:	89 fa                	mov    %edi,%edx
c0108b9e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108ba1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108ba4:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108baa:	83 c4 20             	add    $0x20,%esp
c0108bad:	5e                   	pop    %esi
c0108bae:	5f                   	pop    %edi
c0108baf:	5d                   	pop    %ebp
c0108bb0:	c3                   	ret    

c0108bb1 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108bb1:	55                   	push   %ebp
c0108bb2:	89 e5                	mov    %esp,%ebp
c0108bb4:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108bb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bba:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108bc0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108bc3:	eb 30                	jmp    c0108bf5 <memcmp+0x44>
        if (*s1 != *s2) {
c0108bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108bc8:	0f b6 10             	movzbl (%eax),%edx
c0108bcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108bce:	0f b6 00             	movzbl (%eax),%eax
c0108bd1:	38 c2                	cmp    %al,%dl
c0108bd3:	74 18                	je     c0108bed <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108bd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108bd8:	0f b6 00             	movzbl (%eax),%eax
c0108bdb:	0f b6 d0             	movzbl %al,%edx
c0108bde:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108be1:	0f b6 00             	movzbl (%eax),%eax
c0108be4:	0f b6 c0             	movzbl %al,%eax
c0108be7:	29 c2                	sub    %eax,%edx
c0108be9:	89 d0                	mov    %edx,%eax
c0108beb:	eb 1a                	jmp    c0108c07 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108bed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108bf1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108bf5:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108bfb:	89 55 10             	mov    %edx,0x10(%ebp)
c0108bfe:	85 c0                	test   %eax,%eax
c0108c00:	75 c3                	jne    c0108bc5 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108c02:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108c07:	c9                   	leave  
c0108c08:	c3                   	ret    
