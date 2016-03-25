
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 ec 5d 00 00       	call   105e42 <memset>

    cons_init();                // init the console
  100056:	e8 78 15 00 00       	call   1015d3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 e0 5f 10 00 	movl   $0x105fe0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 fc 5f 10 00 	movl   $0x105ffc,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 da 42 00 00       	call   10435e <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b3 16 00 00       	call   10173c <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 05 18 00 00       	call   101893 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 f6 0c 00 00       	call   100d89 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 12 16 00 00       	call   1016aa <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 ff 0b 00 00       	call   100cbb <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 01 60 10 00 	movl   $0x106001,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 0f 60 10 00 	movl   $0x10600f,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 1d 60 10 00 	movl   $0x10601d,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 2b 60 10 00 	movl   $0x10602b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 39 60 10 00 	movl   $0x106039,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 48 60 10 00 	movl   $0x106048,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 68 60 10 00 	movl   $0x106068,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 87 60 10 00 	movl   $0x106087,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 05 13 00 00       	call   1015ff <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 24 53 00 00       	call   10565b <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 8c 12 00 00       	call   1015ff <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 6c 12 00 00       	call   10163b <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 8c 60 10 00    	movl   $0x10608c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 8c 60 10 00 	movl   $0x10608c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 e0 72 10 00 	movl   $0x1072e0,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 48 1f 11 00 	movl   $0x111f48,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 49 1f 11 00 	movl   $0x111f49,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 84 49 11 00 	movl   $0x114984,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 ca 55 00 00       	call   105cb6 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 96 60 10 00 	movl   $0x106096,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 af 60 10 00 	movl   $0x1060af,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 cb 5f 10 	movl   $0x105fcb,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 c7 60 10 00 	movl   $0x1060c7,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 df 60 10 00 	movl   $0x1060df,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 f7 60 10 00 	movl   $0x1060f7,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 10 61 10 00 	movl   $0x106110,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 3a 61 10 00 	movl   $0x10613a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 56 61 10 00 	movl   $0x106156,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
	*    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
	*    (3.5) popup a calling stackframe
	*           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
	*                   the calling funciton's ebp = ss:[ebp]
	*/
	uint32_t ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int i = 0, j = 0;
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	while (i < STACKFRAME_DEPTH && ebp) {
  1009e1:	e9 88 00 00 00       	jmp    100a6e <print_stackframe+0xb4>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f4:	c7 04 24 68 61 10 00 	movl   $0x106168,(%esp)
  1009fb:	e8 3c f9 ff ff       	call   10033c <cprintf>
		uint32_t* arguments = (uint32_t)ebp + 2;
  100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a03:	83 c0 02             	add    $0x2,%eax
  100a06:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		j = 0;
  100a09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		while (j < 4) {
  100a10:	eb 25                	jmp    100a37 <print_stackframe+0x7d>
			cprintf("0x%08x ", arguments[j]);
  100a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a1f:	01 d0                	add    %edx,%eax
  100a21:	8b 00                	mov    (%eax),%eax
  100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a27:	c7 04 24 84 61 10 00 	movl   $0x106184,(%esp)
  100a2e:	e8 09 f9 ff ff       	call   10033c <cprintf>
			j++;
  100a33:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
	while (i < STACKFRAME_DEPTH && ebp) {
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t* arguments = (uint32_t)ebp + 2;

		j = 0;
		while (j < 4) {
  100a37:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3b:	7e d5                	jle    100a12 <print_stackframe+0x58>
			cprintf("0x%08x ", arguments[j]);
			j++;
		}

		cprintf("\n");
  100a3d:	c7 04 24 8c 61 10 00 	movl   $0x10618c,(%esp)
  100a44:	e8 f3 f8 ff ff       	call   10033c <cprintf>
		print_debuginfo(eip - 1);
  100a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4c:	83 e8 01             	sub    $0x1,%eax
  100a4f:	89 04 24             	mov    %eax,(%esp)
  100a52:	e8 af fe ff ff       	call   100906 <print_debuginfo>
		eip = *(uint32_t*)(ebp + 4);
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	83 c0 04             	add    $0x4,%eax
  100a5d:	8b 00                	mov    (%eax),%eax
  100a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *(uint32_t*)ebp;
  100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a65:	8b 00                	mov    (%eax),%eax
  100a67:	89 45 f4             	mov    %eax,-0xc(%ebp)

		i++;
  100a6a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
	*/
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();

	int i = 0, j = 0;
	while (i < STACKFRAME_DEPTH && ebp) {
  100a6e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a72:	7f 0a                	jg     100a7e <print_stackframe+0xc4>
  100a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a78:	0f 85 68 ff ff ff    	jne    1009e6 <print_stackframe+0x2c>
		eip = *(uint32_t*)(ebp + 4);
		ebp = *(uint32_t*)ebp;

		i++;
	}
}
  100a7e:	c9                   	leave  
  100a7f:	c3                   	ret    

00100a80 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a80:	55                   	push   %ebp
  100a81:	89 e5                	mov    %esp,%ebp
  100a83:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8d:	eb 0c                	jmp    100a9b <parse+0x1b>
            *buf ++ = '\0';
  100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a92:	8d 50 01             	lea    0x1(%eax),%edx
  100a95:	89 55 08             	mov    %edx,0x8(%ebp)
  100a98:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9e:	0f b6 00             	movzbl (%eax),%eax
  100aa1:	84 c0                	test   %al,%al
  100aa3:	74 1d                	je     100ac2 <parse+0x42>
  100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa8:	0f b6 00             	movzbl (%eax),%eax
  100aab:	0f be c0             	movsbl %al,%eax
  100aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab2:	c7 04 24 10 62 10 00 	movl   $0x106210,(%esp)
  100ab9:	e8 c5 51 00 00       	call   105c83 <strchr>
  100abe:	85 c0                	test   %eax,%eax
  100ac0:	75 cd                	jne    100a8f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac5:	0f b6 00             	movzbl (%eax),%eax
  100ac8:	84 c0                	test   %al,%al
  100aca:	75 02                	jne    100ace <parse+0x4e>
            break;
  100acc:	eb 67                	jmp    100b35 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad2:	75 14                	jne    100ae8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100adb:	00 
  100adc:	c7 04 24 15 62 10 00 	movl   $0x106215,(%esp)
  100ae3:	e8 54 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aeb:	8d 50 01             	lea    0x1(%eax),%edx
  100aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afb:	01 c2                	add    %eax,%edx
  100afd:	8b 45 08             	mov    0x8(%ebp),%eax
  100b00:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b02:	eb 04                	jmp    100b08 <parse+0x88>
            buf ++;
  100b04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	0f b6 00             	movzbl (%eax),%eax
  100b0e:	84 c0                	test   %al,%al
  100b10:	74 1d                	je     100b2f <parse+0xaf>
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	0f b6 00             	movzbl (%eax),%eax
  100b18:	0f be c0             	movsbl %al,%eax
  100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1f:	c7 04 24 10 62 10 00 	movl   $0x106210,(%esp)
  100b26:	e8 58 51 00 00       	call   105c83 <strchr>
  100b2b:	85 c0                	test   %eax,%eax
  100b2d:	74 d5                	je     100b04 <parse+0x84>
            buf ++;
        }
    }
  100b2f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b30:	e9 66 ff ff ff       	jmp    100a9b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b38:	c9                   	leave  
  100b39:	c3                   	ret    

00100b3a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3a:	55                   	push   %ebp
  100b3b:	89 e5                	mov    %esp,%ebp
  100b3d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b40:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b47:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4a:	89 04 24             	mov    %eax,(%esp)
  100b4d:	e8 2e ff ff ff       	call   100a80 <parse>
  100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b59:	75 0a                	jne    100b65 <runcmd+0x2b>
        return 0;
  100b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  100b60:	e9 85 00 00 00       	jmp    100bea <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6c:	eb 5c                	jmp    100bca <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b6e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b74:	89 d0                	mov    %edx,%eax
  100b76:	01 c0                	add    %eax,%eax
  100b78:	01 d0                	add    %edx,%eax
  100b7a:	c1 e0 02             	shl    $0x2,%eax
  100b7d:	05 20 70 11 00       	add    $0x117020,%eax
  100b82:	8b 00                	mov    (%eax),%eax
  100b84:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b88:	89 04 24             	mov    %eax,(%esp)
  100b8b:	e8 54 50 00 00       	call   105be4 <strcmp>
  100b90:	85 c0                	test   %eax,%eax
  100b92:	75 32                	jne    100bc6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b97:	89 d0                	mov    %edx,%eax
  100b99:	01 c0                	add    %eax,%eax
  100b9b:	01 d0                	add    %edx,%eax
  100b9d:	c1 e0 02             	shl    $0x2,%eax
  100ba0:	05 20 70 11 00       	add    $0x117020,%eax
  100ba5:	8b 40 08             	mov    0x8(%eax),%eax
  100ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bab:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb5:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb8:	83 c2 04             	add    $0x4,%edx
  100bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bbf:	89 0c 24             	mov    %ecx,(%esp)
  100bc2:	ff d0                	call   *%eax
  100bc4:	eb 24                	jmp    100bea <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcd:	83 f8 02             	cmp    $0x2,%eax
  100bd0:	76 9c                	jbe    100b6e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd9:	c7 04 24 33 62 10 00 	movl   $0x106233,(%esp)
  100be0:	e8 57 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bea:	c9                   	leave  
  100beb:	c3                   	ret    

00100bec <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bec:	55                   	push   %ebp
  100bed:	89 e5                	mov    %esp,%ebp
  100bef:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf2:	c7 04 24 4c 62 10 00 	movl   $0x10624c,(%esp)
  100bf9:	e8 3e f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfe:	c7 04 24 74 62 10 00 	movl   $0x106274,(%esp)
  100c05:	e8 32 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0e:	74 0b                	je     100c1b <kmonitor+0x2f>
        print_trapframe(tf);
  100c10:	8b 45 08             	mov    0x8(%ebp),%eax
  100c13:	89 04 24             	mov    %eax,(%esp)
  100c16:	e8 2c 0e 00 00       	call   101a47 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1b:	c7 04 24 99 62 10 00 	movl   $0x106299,(%esp)
  100c22:	e8 0c f6 ff ff       	call   100233 <readline>
  100c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2e:	74 18                	je     100c48 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c30:	8b 45 08             	mov    0x8(%ebp),%eax
  100c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3a:	89 04 24             	mov    %eax,(%esp)
  100c3d:	e8 f8 fe ff ff       	call   100b3a <runcmd>
  100c42:	85 c0                	test   %eax,%eax
  100c44:	79 02                	jns    100c48 <kmonitor+0x5c>
                break;
  100c46:	eb 02                	jmp    100c4a <kmonitor+0x5e>
            }
        }
    }
  100c48:	eb d1                	jmp    100c1b <kmonitor+0x2f>
}
  100c4a:	c9                   	leave  
  100c4b:	c3                   	ret    

00100c4c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4c:	55                   	push   %ebp
  100c4d:	89 e5                	mov    %esp,%ebp
  100c4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c59:	eb 3f                	jmp    100c9a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5e:	89 d0                	mov    %edx,%eax
  100c60:	01 c0                	add    %eax,%eax
  100c62:	01 d0                	add    %edx,%eax
  100c64:	c1 e0 02             	shl    $0x2,%eax
  100c67:	05 20 70 11 00       	add    $0x117020,%eax
  100c6c:	8b 48 04             	mov    0x4(%eax),%ecx
  100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c72:	89 d0                	mov    %edx,%eax
  100c74:	01 c0                	add    %eax,%eax
  100c76:	01 d0                	add    %edx,%eax
  100c78:	c1 e0 02             	shl    $0x2,%eax
  100c7b:	05 20 70 11 00       	add    $0x117020,%eax
  100c80:	8b 00                	mov    (%eax),%eax
  100c82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c86:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8a:	c7 04 24 9d 62 10 00 	movl   $0x10629d,(%esp)
  100c91:	e8 a6 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9d:	83 f8 02             	cmp    $0x2,%eax
  100ca0:	76 b9                	jbe    100c5b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca7:	c9                   	leave  
  100ca8:	c3                   	ret    

00100ca9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca9:	55                   	push   %ebp
  100caa:	89 e5                	mov    %esp,%ebp
  100cac:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100caf:	e8 bc fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb9:	c9                   	leave  
  100cba:	c3                   	ret    

00100cbb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbb:	55                   	push   %ebp
  100cbc:	89 e5                	mov    %esp,%ebp
  100cbe:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc1:	e8 f4 fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccb:	c9                   	leave  
  100ccc:	c3                   	ret    

00100ccd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ccd:	55                   	push   %ebp
  100cce:	89 e5                	mov    %esp,%ebp
  100cd0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd3:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd8:	85 c0                	test   %eax,%eax
  100cda:	74 02                	je     100cde <__panic+0x11>
        goto panic_dead;
  100cdc:	eb 48                	jmp    100d26 <__panic+0x59>
    }
    is_panic = 1;
  100cde:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100ce5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce8:	8d 45 14             	lea    0x14(%ebp),%eax
  100ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfc:	c7 04 24 a6 62 10 00 	movl   $0x1062a6,(%esp)
  100d03:	e8 34 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d12:	89 04 24             	mov    %eax,(%esp)
  100d15:	e8 ef f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d1a:	c7 04 24 c2 62 10 00 	movl   $0x1062c2,(%esp)
  100d21:	e8 16 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d26:	e8 85 09 00 00       	call   1016b0 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d32:	e8 b5 fe ff ff       	call   100bec <kmonitor>
    }
  100d37:	eb f2                	jmp    100d2b <__panic+0x5e>

00100d39 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d39:	55                   	push   %ebp
  100d3a:	89 e5                	mov    %esp,%ebp
  100d3c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d3f:	8d 45 14             	lea    0x14(%ebp),%eax
  100d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d48:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d53:	c7 04 24 c4 62 10 00 	movl   $0x1062c4,(%esp)
  100d5a:	e8 dd f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d66:	8b 45 10             	mov    0x10(%ebp),%eax
  100d69:	89 04 24             	mov    %eax,(%esp)
  100d6c:	e8 98 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d71:	c7 04 24 c2 62 10 00 	movl   $0x1062c2,(%esp)
  100d78:	e8 bf f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d7d:	c9                   	leave  
  100d7e:	c3                   	ret    

00100d7f <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d7f:	55                   	push   %ebp
  100d80:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d82:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d87:	5d                   	pop    %ebp
  100d88:	c3                   	ret    

00100d89 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d89:	55                   	push   %ebp
  100d8a:	89 e5                	mov    %esp,%ebp
  100d8c:	83 ec 28             	sub    $0x28,%esp
  100d8f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d95:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d99:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da1:	ee                   	out    %al,(%dx)
  100da2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dac:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db4:	ee                   	out    %al,(%dx)
  100db5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dbb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dbf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc8:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dcf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd2:	c7 04 24 e2 62 10 00 	movl   $0x1062e2,(%esp)
  100dd9:	e8 5e f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de5:	e8 24 09 00 00       	call   10170e <pic_enable>
}
  100dea:	c9                   	leave  
  100deb:	c3                   	ret    

00100dec <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dec:	55                   	push   %ebp
  100ded:	89 e5                	mov    %esp,%ebp
  100def:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df2:	9c                   	pushf  
  100df3:	58                   	pop    %eax
  100df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dfa:	25 00 02 00 00       	and    $0x200,%eax
  100dff:	85 c0                	test   %eax,%eax
  100e01:	74 0c                	je     100e0f <__intr_save+0x23>
        intr_disable();
  100e03:	e8 a8 08 00 00       	call   1016b0 <intr_disable>
        return 1;
  100e08:	b8 01 00 00 00       	mov    $0x1,%eax
  100e0d:	eb 05                	jmp    100e14 <__intr_save+0x28>
    }
    return 0;
  100e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e14:	c9                   	leave  
  100e15:	c3                   	ret    

00100e16 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e16:	55                   	push   %ebp
  100e17:	89 e5                	mov    %esp,%ebp
  100e19:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e20:	74 05                	je     100e27 <__intr_restore+0x11>
        intr_enable();
  100e22:	e8 83 08 00 00       	call   1016aa <intr_enable>
    }
}
  100e27:	c9                   	leave  
  100e28:	c3                   	ret    

00100e29 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e29:	55                   	push   %ebp
  100e2a:	89 e5                	mov    %esp,%ebp
  100e2c:	83 ec 10             	sub    $0x10,%esp
  100e2f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e35:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e39:	89 c2                	mov    %eax,%edx
  100e3b:	ec                   	in     (%dx),%al
  100e3c:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e3f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e45:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e49:	89 c2                	mov    %eax,%edx
  100e4b:	ec                   	in     (%dx),%al
  100e4c:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e4f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e55:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e59:	89 c2                	mov    %eax,%edx
  100e5b:	ec                   	in     (%dx),%al
  100e5c:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e5f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e65:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e69:	89 c2                	mov    %eax,%edx
  100e6b:	ec                   	in     (%dx),%al
  100e6c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e6f:	c9                   	leave  
  100e70:	c3                   	ret    

00100e71 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e71:	55                   	push   %ebp
  100e72:	89 e5                	mov    %esp,%ebp
  100e74:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e77:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e81:	0f b7 00             	movzwl (%eax),%eax
  100e84:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e93:	0f b7 00             	movzwl (%eax),%eax
  100e96:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e9a:	74 12                	je     100eae <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e9c:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea3:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100eaa:	b4 03 
  100eac:	eb 13                	jmp    100ec1 <cga_init+0x50>
    } else {
        *cp = was;
  100eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb8:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ebf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec1:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec8:	0f b7 c0             	movzwl %ax,%eax
  100ecb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ecf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100edb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100edc:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee3:	83 c0 01             	add    $0x1,%eax
  100ee6:	0f b7 c0             	movzwl %ax,%eax
  100ee9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eed:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef1:	89 c2                	mov    %eax,%edx
  100ef3:	ec                   	in     (%dx),%al
  100ef4:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100efb:	0f b6 c0             	movzbl %al,%eax
  100efe:	c1 e0 08             	shl    $0x8,%eax
  100f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f04:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f0b:	0f b7 c0             	movzwl %ax,%eax
  100f0e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f12:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f16:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f1e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f1f:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f26:	83 c0 01             	add    $0x1,%eax
  100f29:	0f b7 c0             	movzwl %ax,%eax
  100f2c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f30:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f34:	89 c2                	mov    %eax,%edx
  100f36:	ec                   	in     (%dx),%al
  100f37:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f3a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f3e:	0f b6 c0             	movzbl %al,%eax
  100f41:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f47:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f4f:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f55:	c9                   	leave  
  100f56:	c3                   	ret    

00100f57 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f57:	55                   	push   %ebp
  100f58:	89 e5                	mov    %esp,%ebp
  100f5a:	83 ec 48             	sub    $0x48,%esp
  100f5d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f63:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f67:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f6b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f6f:	ee                   	out    %al,(%dx)
  100f70:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f76:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f7a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f82:	ee                   	out    %al,(%dx)
  100f83:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f89:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f8d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f91:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f95:	ee                   	out    %al,(%dx)
  100f96:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f9c:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fa0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa8:	ee                   	out    %al,(%dx)
  100fa9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100faf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fbb:	ee                   	out    %al,(%dx)
  100fbc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fc6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fca:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fce:	ee                   	out    %al,(%dx)
  100fcf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fdd:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fe1:	ee                   	out    %al,(%dx)
  100fe2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fec:	89 c2                	mov    %eax,%edx
  100fee:	ec                   	in     (%dx),%al
  100fef:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ff6:	3c ff                	cmp    $0xff,%al
  100ff8:	0f 95 c0             	setne  %al
  100ffb:	0f b6 c0             	movzbl %al,%eax
  100ffe:	a3 88 7e 11 00       	mov    %eax,0x117e88
  101003:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101009:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  10100d:	89 c2                	mov    %eax,%edx
  10100f:	ec                   	in     (%dx),%al
  101010:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101013:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101019:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  10101d:	89 c2                	mov    %eax,%edx
  10101f:	ec                   	in     (%dx),%al
  101020:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101023:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101028:	85 c0                	test   %eax,%eax
  10102a:	74 0c                	je     101038 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10102c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101033:	e8 d6 06 00 00       	call   10170e <pic_enable>
    }
}
  101038:	c9                   	leave  
  101039:	c3                   	ret    

0010103a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10103a:	55                   	push   %ebp
  10103b:	89 e5                	mov    %esp,%ebp
  10103d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101047:	eb 09                	jmp    101052 <lpt_putc_sub+0x18>
        delay();
  101049:	e8 db fd ff ff       	call   100e29 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101052:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101058:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10105c:	89 c2                	mov    %eax,%edx
  10105e:	ec                   	in     (%dx),%al
  10105f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101062:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101066:	84 c0                	test   %al,%al
  101068:	78 09                	js     101073 <lpt_putc_sub+0x39>
  10106a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101071:	7e d6                	jle    101049 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101073:	8b 45 08             	mov    0x8(%ebp),%eax
  101076:	0f b6 c0             	movzbl %al,%eax
  101079:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10107f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101082:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101086:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10108a:	ee                   	out    %al,(%dx)
  10108b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101091:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101095:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101099:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10109d:	ee                   	out    %al,(%dx)
  10109e:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010ac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010b1:	c9                   	leave  
  1010b2:	c3                   	ret    

001010b3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b3:	55                   	push   %ebp
  1010b4:	89 e5                	mov    %esp,%ebp
  1010b6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010bd:	74 0d                	je     1010cc <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c2:	89 04 24             	mov    %eax,(%esp)
  1010c5:	e8 70 ff ff ff       	call   10103a <lpt_putc_sub>
  1010ca:	eb 24                	jmp    1010f0 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d3:	e8 62 ff ff ff       	call   10103a <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010df:	e8 56 ff ff ff       	call   10103a <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010eb:	e8 4a ff ff ff       	call   10103a <lpt_putc_sub>
    }
}
  1010f0:	c9                   	leave  
  1010f1:	c3                   	ret    

001010f2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f2:	55                   	push   %ebp
  1010f3:	89 e5                	mov    %esp,%ebp
  1010f5:	53                   	push   %ebx
  1010f6:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fc:	b0 00                	mov    $0x0,%al
  1010fe:	85 c0                	test   %eax,%eax
  101100:	75 07                	jne    101109 <cga_putc+0x17>
        c |= 0x0700;
  101102:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101109:	8b 45 08             	mov    0x8(%ebp),%eax
  10110c:	0f b6 c0             	movzbl %al,%eax
  10110f:	83 f8 0a             	cmp    $0xa,%eax
  101112:	74 4c                	je     101160 <cga_putc+0x6e>
  101114:	83 f8 0d             	cmp    $0xd,%eax
  101117:	74 57                	je     101170 <cga_putc+0x7e>
  101119:	83 f8 08             	cmp    $0x8,%eax
  10111c:	0f 85 88 00 00 00    	jne    1011aa <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101122:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101129:	66 85 c0             	test   %ax,%ax
  10112c:	74 30                	je     10115e <cga_putc+0x6c>
            crt_pos --;
  10112e:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101135:	83 e8 01             	sub    $0x1,%eax
  101138:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10113e:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101143:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10114a:	0f b7 d2             	movzwl %dx,%edx
  10114d:	01 d2                	add    %edx,%edx
  10114f:	01 c2                	add    %eax,%edx
  101151:	8b 45 08             	mov    0x8(%ebp),%eax
  101154:	b0 00                	mov    $0x0,%al
  101156:	83 c8 20             	or     $0x20,%eax
  101159:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115c:	eb 72                	jmp    1011d0 <cga_putc+0xde>
  10115e:	eb 70                	jmp    1011d0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101160:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101167:	83 c0 50             	add    $0x50,%eax
  10116a:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101170:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101177:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  10117e:	0f b7 c1             	movzwl %cx,%eax
  101181:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101187:	c1 e8 10             	shr    $0x10,%eax
  10118a:	89 c2                	mov    %eax,%edx
  10118c:	66 c1 ea 06          	shr    $0x6,%dx
  101190:	89 d0                	mov    %edx,%eax
  101192:	c1 e0 02             	shl    $0x2,%eax
  101195:	01 d0                	add    %edx,%eax
  101197:	c1 e0 04             	shl    $0x4,%eax
  10119a:	29 c1                	sub    %eax,%ecx
  10119c:	89 ca                	mov    %ecx,%edx
  10119e:	89 d8                	mov    %ebx,%eax
  1011a0:	29 d0                	sub    %edx,%eax
  1011a2:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a8:	eb 26                	jmp    1011d0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011aa:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011b0:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b7:	8d 50 01             	lea    0x1(%eax),%edx
  1011ba:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011c1:	0f b7 c0             	movzwl %ax,%eax
  1011c4:	01 c0                	add    %eax,%eax
  1011c6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1011cc:	66 89 02             	mov    %ax,(%edx)
        break;
  1011cf:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d0:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d7:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011db:	76 5b                	jbe    101238 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011dd:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e8:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011ed:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f4:	00 
  1011f5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f9:	89 04 24             	mov    %eax,(%esp)
  1011fc:	e8 80 4c 00 00       	call   105e81 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101201:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101208:	eb 15                	jmp    10121f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10120a:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10120f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101212:	01 d2                	add    %edx,%edx
  101214:	01 d0                	add    %edx,%eax
  101216:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10121f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101226:	7e e2                	jle    10120a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101228:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10122f:	83 e8 50             	sub    $0x50,%eax
  101232:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101238:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10123f:	0f b7 c0             	movzwl %ax,%eax
  101242:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101246:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10124a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10124e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101252:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101253:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10125a:	66 c1 e8 08          	shr    $0x8,%ax
  10125e:	0f b6 c0             	movzbl %al,%eax
  101261:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101268:	83 c2 01             	add    $0x1,%edx
  10126b:	0f b7 d2             	movzwl %dx,%edx
  10126e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101272:	88 45 ed             	mov    %al,-0x13(%ebp)
  101275:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101279:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10127d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10127e:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101285:	0f b7 c0             	movzwl %ax,%eax
  101288:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10128c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101290:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101294:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101298:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101299:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012a0:	0f b6 c0             	movzbl %al,%eax
  1012a3:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012aa:	83 c2 01             	add    $0x1,%edx
  1012ad:	0f b7 d2             	movzwl %dx,%edx
  1012b0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b4:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012bb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012bf:	ee                   	out    %al,(%dx)
}
  1012c0:	83 c4 34             	add    $0x34,%esp
  1012c3:	5b                   	pop    %ebx
  1012c4:	5d                   	pop    %ebp
  1012c5:	c3                   	ret    

001012c6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c6:	55                   	push   %ebp
  1012c7:	89 e5                	mov    %esp,%ebp
  1012c9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d3:	eb 09                	jmp    1012de <serial_putc_sub+0x18>
        delay();
  1012d5:	e8 4f fb ff ff       	call   100e29 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012de:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e8:	89 c2                	mov    %eax,%edx
  1012ea:	ec                   	in     (%dx),%al
  1012eb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f2:	0f b6 c0             	movzbl %al,%eax
  1012f5:	83 e0 20             	and    $0x20,%eax
  1012f8:	85 c0                	test   %eax,%eax
  1012fa:	75 09                	jne    101305 <serial_putc_sub+0x3f>
  1012fc:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101303:	7e d0                	jle    1012d5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101305:	8b 45 08             	mov    0x8(%ebp),%eax
  101308:	0f b6 c0             	movzbl %al,%eax
  10130b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101311:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101314:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101318:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10131c:	ee                   	out    %al,(%dx)
}
  10131d:	c9                   	leave  
  10131e:	c3                   	ret    

0010131f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131f:	55                   	push   %ebp
  101320:	89 e5                	mov    %esp,%ebp
  101322:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101325:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101329:	74 0d                	je     101338 <serial_putc+0x19>
        serial_putc_sub(c);
  10132b:	8b 45 08             	mov    0x8(%ebp),%eax
  10132e:	89 04 24             	mov    %eax,(%esp)
  101331:	e8 90 ff ff ff       	call   1012c6 <serial_putc_sub>
  101336:	eb 24                	jmp    10135c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101338:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133f:	e8 82 ff ff ff       	call   1012c6 <serial_putc_sub>
        serial_putc_sub(' ');
  101344:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134b:	e8 76 ff ff ff       	call   1012c6 <serial_putc_sub>
        serial_putc_sub('\b');
  101350:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101357:	e8 6a ff ff ff       	call   1012c6 <serial_putc_sub>
    }
}
  10135c:	c9                   	leave  
  10135d:	c3                   	ret    

0010135e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135e:	55                   	push   %ebp
  10135f:	89 e5                	mov    %esp,%ebp
  101361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101364:	eb 33                	jmp    101399 <cons_intr+0x3b>
        if (c != 0) {
  101366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136a:	74 2d                	je     101399 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136c:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101371:	8d 50 01             	lea    0x1(%eax),%edx
  101374:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10137a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137d:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101383:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101388:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138d:	75 0a                	jne    101399 <cons_intr+0x3b>
                cons.wpos = 0;
  10138f:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101396:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101399:	8b 45 08             	mov    0x8(%ebp),%eax
  10139c:	ff d0                	call   *%eax
  10139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a5:	75 bf                	jne    101366 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a7:	c9                   	leave  
  1013a8:	c3                   	ret    

001013a9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a9:	55                   	push   %ebp
  1013aa:	89 e5                	mov    %esp,%ebp
  1013ac:	83 ec 10             	sub    $0x10,%esp
  1013af:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b9:	89 c2                	mov    %eax,%edx
  1013bb:	ec                   	in     (%dx),%al
  1013bc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013bf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c3:	0f b6 c0             	movzbl %al,%eax
  1013c6:	83 e0 01             	and    $0x1,%eax
  1013c9:	85 c0                	test   %eax,%eax
  1013cb:	75 07                	jne    1013d4 <serial_proc_data+0x2b>
        return -1;
  1013cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d2:	eb 2a                	jmp    1013fe <serial_proc_data+0x55>
  1013d4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013da:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013de:	89 c2                	mov    %eax,%edx
  1013e0:	ec                   	in     (%dx),%al
  1013e1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e8:	0f b6 c0             	movzbl %al,%eax
  1013eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013ee:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f2:	75 07                	jne    1013fb <serial_proc_data+0x52>
        c = '\b';
  1013f4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013fe:	c9                   	leave  
  1013ff:	c3                   	ret    

00101400 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101400:	55                   	push   %ebp
  101401:	89 e5                	mov    %esp,%ebp
  101403:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101406:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10140b:	85 c0                	test   %eax,%eax
  10140d:	74 0c                	je     10141b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140f:	c7 04 24 a9 13 10 00 	movl   $0x1013a9,(%esp)
  101416:	e8 43 ff ff ff       	call   10135e <cons_intr>
    }
}
  10141b:	c9                   	leave  
  10141c:	c3                   	ret    

0010141d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10141d:	55                   	push   %ebp
  10141e:	89 e5                	mov    %esp,%ebp
  101420:	83 ec 38             	sub    $0x38,%esp
  101423:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101429:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10142d:	89 c2                	mov    %eax,%edx
  10142f:	ec                   	in     (%dx),%al
  101430:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101433:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101437:	0f b6 c0             	movzbl %al,%eax
  10143a:	83 e0 01             	and    $0x1,%eax
  10143d:	85 c0                	test   %eax,%eax
  10143f:	75 0a                	jne    10144b <kbd_proc_data+0x2e>
        return -1;
  101441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101446:	e9 59 01 00 00       	jmp    1015a4 <kbd_proc_data+0x187>
  10144b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101451:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101455:	89 c2                	mov    %eax,%edx
  101457:	ec                   	in     (%dx),%al
  101458:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10145b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10145f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101462:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101466:	75 17                	jne    10147f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101468:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10146d:	83 c8 40             	or     $0x40,%eax
  101470:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101475:	b8 00 00 00 00       	mov    $0x0,%eax
  10147a:	e9 25 01 00 00       	jmp    1015a4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10147f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101483:	84 c0                	test   %al,%al
  101485:	79 47                	jns    1014ce <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101487:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10148c:	83 e0 40             	and    $0x40,%eax
  10148f:	85 c0                	test   %eax,%eax
  101491:	75 09                	jne    10149c <kbd_proc_data+0x7f>
  101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101497:	83 e0 7f             	and    $0x7f,%eax
  10149a:	eb 04                	jmp    1014a0 <kbd_proc_data+0x83>
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a7:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ae:	83 c8 40             	or     $0x40,%eax
  1014b1:	0f b6 c0             	movzbl %al,%eax
  1014b4:	f7 d0                	not    %eax
  1014b6:	89 c2                	mov    %eax,%edx
  1014b8:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014bd:	21 d0                	and    %edx,%eax
  1014bf:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c9:	e9 d6 00 00 00       	jmp    1015a4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014ce:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d3:	83 e0 40             	and    $0x40,%eax
  1014d6:	85 c0                	test   %eax,%eax
  1014d8:	74 11                	je     1014eb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014da:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014de:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e3:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e6:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ef:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014f6:	0f b6 d0             	movzbl %al,%edx
  1014f9:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014fe:	09 d0                	or     %edx,%eax
  101500:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101509:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101510:	0f b6 d0             	movzbl %al,%edx
  101513:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101518:	31 d0                	xor    %edx,%eax
  10151a:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10151f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101524:	83 e0 03             	and    $0x3,%eax
  101527:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  10152e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101532:	01 d0                	add    %edx,%eax
  101534:	0f b6 00             	movzbl (%eax),%eax
  101537:	0f b6 c0             	movzbl %al,%eax
  10153a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10153d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101542:	83 e0 08             	and    $0x8,%eax
  101545:	85 c0                	test   %eax,%eax
  101547:	74 22                	je     10156b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101549:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10154d:	7e 0c                	jle    10155b <kbd_proc_data+0x13e>
  10154f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101553:	7f 06                	jg     10155b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101555:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101559:	eb 10                	jmp    10156b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10155b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10155f:	7e 0a                	jle    10156b <kbd_proc_data+0x14e>
  101561:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101565:	7f 04                	jg     10156b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101567:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10156b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101570:	f7 d0                	not    %eax
  101572:	83 e0 06             	and    $0x6,%eax
  101575:	85 c0                	test   %eax,%eax
  101577:	75 28                	jne    1015a1 <kbd_proc_data+0x184>
  101579:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101580:	75 1f                	jne    1015a1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101582:	c7 04 24 fd 62 10 00 	movl   $0x1062fd,(%esp)
  101589:	e8 ae ed ff ff       	call   10033c <cprintf>
  10158e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101594:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101598:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10159c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015a0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a4:	c9                   	leave  
  1015a5:	c3                   	ret    

001015a6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a6:	55                   	push   %ebp
  1015a7:	89 e5                	mov    %esp,%ebp
  1015a9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015ac:	c7 04 24 1d 14 10 00 	movl   $0x10141d,(%esp)
  1015b3:	e8 a6 fd ff ff       	call   10135e <cons_intr>
}
  1015b8:	c9                   	leave  
  1015b9:	c3                   	ret    

001015ba <kbd_init>:

static void
kbd_init(void) {
  1015ba:	55                   	push   %ebp
  1015bb:	89 e5                	mov    %esp,%ebp
  1015bd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015c0:	e8 e1 ff ff ff       	call   1015a6 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015cc:	e8 3d 01 00 00       	call   10170e <pic_enable>
}
  1015d1:	c9                   	leave  
  1015d2:	c3                   	ret    

001015d3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d3:	55                   	push   %ebp
  1015d4:	89 e5                	mov    %esp,%ebp
  1015d6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d9:	e8 93 f8 ff ff       	call   100e71 <cga_init>
    serial_init();
  1015de:	e8 74 f9 ff ff       	call   100f57 <serial_init>
    kbd_init();
  1015e3:	e8 d2 ff ff ff       	call   1015ba <kbd_init>
    if (!serial_exists) {
  1015e8:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015ed:	85 c0                	test   %eax,%eax
  1015ef:	75 0c                	jne    1015fd <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f1:	c7 04 24 09 63 10 00 	movl   $0x106309,(%esp)
  1015f8:	e8 3f ed ff ff       	call   10033c <cprintf>
    }
}
  1015fd:	c9                   	leave  
  1015fe:	c3                   	ret    

001015ff <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015ff:	55                   	push   %ebp
  101600:	89 e5                	mov    %esp,%ebp
  101602:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101605:	e8 e2 f7 ff ff       	call   100dec <__intr_save>
  10160a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10160d:	8b 45 08             	mov    0x8(%ebp),%eax
  101610:	89 04 24             	mov    %eax,(%esp)
  101613:	e8 9b fa ff ff       	call   1010b3 <lpt_putc>
        cga_putc(c);
  101618:	8b 45 08             	mov    0x8(%ebp),%eax
  10161b:	89 04 24             	mov    %eax,(%esp)
  10161e:	e8 cf fa ff ff       	call   1010f2 <cga_putc>
        serial_putc(c);
  101623:	8b 45 08             	mov    0x8(%ebp),%eax
  101626:	89 04 24             	mov    %eax,(%esp)
  101629:	e8 f1 fc ff ff       	call   10131f <serial_putc>
    }
    local_intr_restore(intr_flag);
  10162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101631:	89 04 24             	mov    %eax,(%esp)
  101634:	e8 dd f7 ff ff       	call   100e16 <__intr_restore>
}
  101639:	c9                   	leave  
  10163a:	c3                   	ret    

0010163b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163b:	55                   	push   %ebp
  10163c:	89 e5                	mov    %esp,%ebp
  10163e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101641:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101648:	e8 9f f7 ff ff       	call   100dec <__intr_save>
  10164d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101650:	e8 ab fd ff ff       	call   101400 <serial_intr>
        kbd_intr();
  101655:	e8 4c ff ff ff       	call   1015a6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10165a:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101660:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101665:	39 c2                	cmp    %eax,%edx
  101667:	74 31                	je     10169a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101669:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10166e:	8d 50 01             	lea    0x1(%eax),%edx
  101671:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101677:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  10167e:	0f b6 c0             	movzbl %al,%eax
  101681:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101684:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101689:	3d 00 02 00 00       	cmp    $0x200,%eax
  10168e:	75 0a                	jne    10169a <cons_getc+0x5f>
                cons.rpos = 0;
  101690:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101697:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10169d:	89 04 24             	mov    %eax,(%esp)
  1016a0:	e8 71 f7 ff ff       	call   100e16 <__intr_restore>
    return c;
  1016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a8:	c9                   	leave  
  1016a9:	c3                   	ret    

001016aa <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016aa:	55                   	push   %ebp
  1016ab:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016ad:	fb                   	sti    
    sti();
}
  1016ae:	5d                   	pop    %ebp
  1016af:	c3                   	ret    

001016b0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b0:	55                   	push   %ebp
  1016b1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b3:	fa                   	cli    
    cli();
}
  1016b4:	5d                   	pop    %ebp
  1016b5:	c3                   	ret    

001016b6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b6:	55                   	push   %ebp
  1016b7:	89 e5                	mov    %esp,%ebp
  1016b9:	83 ec 14             	sub    $0x14,%esp
  1016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1016bf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c7:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016cd:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016d2:	85 c0                	test   %eax,%eax
  1016d4:	74 36                	je     10170c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016da:	0f b6 c0             	movzbl %al,%eax
  1016dd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e3:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016e6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ea:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ee:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016ef:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f3:	66 c1 e8 08          	shr    $0x8,%ax
  1016f7:	0f b6 c0             	movzbl %al,%eax
  1016fa:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101700:	88 45 f9             	mov    %al,-0x7(%ebp)
  101703:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101707:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170b:	ee                   	out    %al,(%dx)
    }
}
  10170c:	c9                   	leave  
  10170d:	c3                   	ret    

0010170e <pic_enable>:

void
pic_enable(unsigned int irq) {
  10170e:	55                   	push   %ebp
  10170f:	89 e5                	mov    %esp,%ebp
  101711:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101714:	8b 45 08             	mov    0x8(%ebp),%eax
  101717:	ba 01 00 00 00       	mov    $0x1,%edx
  10171c:	89 c1                	mov    %eax,%ecx
  10171e:	d3 e2                	shl    %cl,%edx
  101720:	89 d0                	mov    %edx,%eax
  101722:	f7 d0                	not    %eax
  101724:	89 c2                	mov    %eax,%edx
  101726:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10172d:	21 d0                	and    %edx,%eax
  10172f:	0f b7 c0             	movzwl %ax,%eax
  101732:	89 04 24             	mov    %eax,(%esp)
  101735:	e8 7c ff ff ff       	call   1016b6 <pic_setmask>
}
  10173a:	c9                   	leave  
  10173b:	c3                   	ret    

0010173c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173c:	55                   	push   %ebp
  10173d:	89 e5                	mov    %esp,%ebp
  10173f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101742:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101749:	00 00 00 
  10174c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101752:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101756:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10175e:	ee                   	out    %al,(%dx)
  10175f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101765:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101769:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101771:	ee                   	out    %al,(%dx)
  101772:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101778:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10177c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101780:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101784:	ee                   	out    %al,(%dx)
  101785:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178b:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10178f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101793:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101797:	ee                   	out    %al,(%dx)
  101798:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10179e:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017aa:	ee                   	out    %al,(%dx)
  1017ab:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b1:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017bd:	ee                   	out    %al,(%dx)
  1017be:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c4:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017cc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d0:	ee                   	out    %al,(%dx)
  1017d1:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d7:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017db:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017df:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e3:	ee                   	out    %al,(%dx)
  1017e4:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017ea:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017ee:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f6:	ee                   	out    %al,(%dx)
  1017f7:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017fd:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101801:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101805:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101809:	ee                   	out    %al,(%dx)
  10180a:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101810:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101814:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101818:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181c:	ee                   	out    %al,(%dx)
  10181d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101823:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101827:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10182f:	ee                   	out    %al,(%dx)
  101830:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101836:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10183a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10183e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101842:	ee                   	out    %al,(%dx)
  101843:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101849:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10184d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101851:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101855:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101856:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10185d:	66 83 f8 ff          	cmp    $0xffff,%ax
  101861:	74 12                	je     101875 <pic_init+0x139>
        pic_setmask(irq_mask);
  101863:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10186a:	0f b7 c0             	movzwl %ax,%eax
  10186d:	89 04 24             	mov    %eax,(%esp)
  101870:	e8 41 fe ff ff       	call   1016b6 <pic_setmask>
    }
}
  101875:	c9                   	leave  
  101876:	c3                   	ret    

00101877 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101877:	55                   	push   %ebp
  101878:	89 e5                	mov    %esp,%ebp
  10187a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10187d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101884:	00 
  101885:	c7 04 24 40 63 10 00 	movl   $0x106340,(%esp)
  10188c:	e8 ab ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101891:	c9                   	leave  
  101892:	c3                   	ret    

00101893 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101893:	55                   	push   %ebp
  101894:	89 e5                	mov    %esp,%ebp
  101896:	83 ec 10             	sub    $0x10,%esp
	*     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
	*     Notice: the argument of lidt is idt_pd. try to find it!
	*/

	extern uintptr_t __vectors[];
	int i = 0;
  101899:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < 256) {
  1018a0:	e9 c3 00 00 00       	jmp    101968 <idt_init+0xd5>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a8:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018af:	89 c2                	mov    %eax,%edx
  1018b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b4:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018bb:	00 
  1018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bf:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018c6:	00 08 00 
  1018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cc:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018d3:	00 
  1018d4:	83 e2 e0             	and    $0xffffffe0,%edx
  1018d7:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e1:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018e8:	00 
  1018e9:	83 e2 1f             	and    $0x1f,%edx
  1018ec:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f6:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1018fd:	00 
  1018fe:	83 e2 f0             	and    $0xfffffff0,%edx
  101901:	83 ca 0e             	or     $0xe,%edx
  101904:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10190b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190e:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101915:	00 
  101916:	83 e2 ef             	and    $0xffffffef,%edx
  101919:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101920:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101923:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10192a:	00 
  10192b:	83 e2 9f             	and    $0xffffff9f,%edx
  10192e:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101938:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10193f:	00 
  101940:	83 ca 80             	or     $0xffffff80,%edx
  101943:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10194a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194d:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101954:	c1 e8 10             	shr    $0x10,%eax
  101957:	89 c2                	mov    %eax,%edx
  101959:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195c:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101963:	00 
		i++;
  101964:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	*     Notice: the argument of lidt is idt_pd. try to find it!
	*/

	extern uintptr_t __vectors[];
	int i = 0;
	while (i < 256) {
  101968:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  10196f:	0f 8e 30 ff ff ff    	jle    1018a5 <idt_init+0x12>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		i++;
	}
	SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
  101975:	a1 00 78 11 00       	mov    0x117800,%eax
  10197a:	66 a3 c0 84 11 00    	mov    %ax,0x1184c0
  101980:	66 c7 05 c2 84 11 00 	movw   $0x8,0x1184c2
  101987:	08 00 
  101989:	0f b6 05 c4 84 11 00 	movzbl 0x1184c4,%eax
  101990:	83 e0 e0             	and    $0xffffffe0,%eax
  101993:	a2 c4 84 11 00       	mov    %al,0x1184c4
  101998:	0f b6 05 c4 84 11 00 	movzbl 0x1184c4,%eax
  10199f:	83 e0 1f             	and    $0x1f,%eax
  1019a2:	a2 c4 84 11 00       	mov    %al,0x1184c4
  1019a7:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  1019ae:	83 c8 0f             	or     $0xf,%eax
  1019b1:	a2 c5 84 11 00       	mov    %al,0x1184c5
  1019b6:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  1019bd:	83 e0 ef             	and    $0xffffffef,%eax
  1019c0:	a2 c5 84 11 00       	mov    %al,0x1184c5
  1019c5:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  1019cc:	83 c8 60             	or     $0x60,%eax
  1019cf:	a2 c5 84 11 00       	mov    %al,0x1184c5
  1019d4:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  1019db:	83 c8 80             	or     $0xffffff80,%eax
  1019de:	a2 c5 84 11 00       	mov    %al,0x1184c5
  1019e3:	a1 00 78 11 00       	mov    0x117800,%eax
  1019e8:	c1 e8 10             	shr    $0x10,%eax
  1019eb:	66 a3 c6 84 11 00    	mov    %ax,0x1184c6
  1019f1:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019fb:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  1019fe:	c9                   	leave  
  1019ff:	c3                   	ret    

00101a00 <trapname>:


static const char *
trapname(int trapno) {
  101a00:	55                   	push   %ebp
  101a01:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a03:	8b 45 08             	mov    0x8(%ebp),%eax
  101a06:	83 f8 13             	cmp    $0x13,%eax
  101a09:	77 0c                	ja     101a17 <trapname+0x17>
        return excnames[trapno];
  101a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0e:	8b 04 85 a0 66 10 00 	mov    0x1066a0(,%eax,4),%eax
  101a15:	eb 18                	jmp    101a2f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a17:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a1b:	7e 0d                	jle    101a2a <trapname+0x2a>
  101a1d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a21:	7f 07                	jg     101a2a <trapname+0x2a>
        return "Hardware Interrupt";
  101a23:	b8 4a 63 10 00       	mov    $0x10634a,%eax
  101a28:	eb 05                	jmp    101a2f <trapname+0x2f>
    }
    return "(unknown trap)";
  101a2a:	b8 5d 63 10 00       	mov    $0x10635d,%eax
}
  101a2f:	5d                   	pop    %ebp
  101a30:	c3                   	ret    

00101a31 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a31:	55                   	push   %ebp
  101a32:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a34:	8b 45 08             	mov    0x8(%ebp),%eax
  101a37:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a3b:	66 83 f8 08          	cmp    $0x8,%ax
  101a3f:	0f 94 c0             	sete   %al
  101a42:	0f b6 c0             	movzbl %al,%eax
}
  101a45:	5d                   	pop    %ebp
  101a46:	c3                   	ret    

00101a47 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a47:	55                   	push   %ebp
  101a48:	89 e5                	mov    %esp,%ebp
  101a4a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a54:	c7 04 24 9e 63 10 00 	movl   $0x10639e,(%esp)
  101a5b:	e8 dc e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a60:	8b 45 08             	mov    0x8(%ebp),%eax
  101a63:	89 04 24             	mov    %eax,(%esp)
  101a66:	e8 a1 01 00 00       	call   101c0c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a72:	0f b7 c0             	movzwl %ax,%eax
  101a75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a79:	c7 04 24 af 63 10 00 	movl   $0x1063af,(%esp)
  101a80:	e8 b7 e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a85:	8b 45 08             	mov    0x8(%ebp),%eax
  101a88:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a8c:	0f b7 c0             	movzwl %ax,%eax
  101a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a93:	c7 04 24 c2 63 10 00 	movl   $0x1063c2,(%esp)
  101a9a:	e8 9d e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aa6:	0f b7 c0             	movzwl %ax,%eax
  101aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aad:	c7 04 24 d5 63 10 00 	movl   $0x1063d5,(%esp)
  101ab4:	e8 83 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  101abc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ac0:	0f b7 c0             	movzwl %ax,%eax
  101ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac7:	c7 04 24 e8 63 10 00 	movl   $0x1063e8,(%esp)
  101ace:	e8 69 e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad6:	8b 40 30             	mov    0x30(%eax),%eax
  101ad9:	89 04 24             	mov    %eax,(%esp)
  101adc:	e8 1f ff ff ff       	call   101a00 <trapname>
  101ae1:	8b 55 08             	mov    0x8(%ebp),%edx
  101ae4:	8b 52 30             	mov    0x30(%edx),%edx
  101ae7:	89 44 24 08          	mov    %eax,0x8(%esp)
  101aeb:	89 54 24 04          	mov    %edx,0x4(%esp)
  101aef:	c7 04 24 fb 63 10 00 	movl   $0x1063fb,(%esp)
  101af6:	e8 41 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101afb:	8b 45 08             	mov    0x8(%ebp),%eax
  101afe:	8b 40 34             	mov    0x34(%eax),%eax
  101b01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b05:	c7 04 24 0d 64 10 00 	movl   $0x10640d,(%esp)
  101b0c:	e8 2b e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b11:	8b 45 08             	mov    0x8(%ebp),%eax
  101b14:	8b 40 38             	mov    0x38(%eax),%eax
  101b17:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1b:	c7 04 24 1c 64 10 00 	movl   $0x10641c,(%esp)
  101b22:	e8 15 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b27:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b2e:	0f b7 c0             	movzwl %ax,%eax
  101b31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b35:	c7 04 24 2b 64 10 00 	movl   $0x10642b,(%esp)
  101b3c:	e8 fb e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b41:	8b 45 08             	mov    0x8(%ebp),%eax
  101b44:	8b 40 40             	mov    0x40(%eax),%eax
  101b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4b:	c7 04 24 3e 64 10 00 	movl   $0x10643e,(%esp)
  101b52:	e8 e5 e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b5e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b65:	eb 3e                	jmp    101ba5 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b67:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6a:	8b 50 40             	mov    0x40(%eax),%edx
  101b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b70:	21 d0                	and    %edx,%eax
  101b72:	85 c0                	test   %eax,%eax
  101b74:	74 28                	je     101b9e <print_trapframe+0x157>
  101b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b79:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b80:	85 c0                	test   %eax,%eax
  101b82:	74 1a                	je     101b9e <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b87:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b92:	c7 04 24 4d 64 10 00 	movl   $0x10644d,(%esp)
  101b99:	e8 9e e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101ba2:	d1 65 f0             	shll   -0x10(%ebp)
  101ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba8:	83 f8 17             	cmp    $0x17,%eax
  101bab:	76 ba                	jbe    101b67 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bad:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb0:	8b 40 40             	mov    0x40(%eax),%eax
  101bb3:	25 00 30 00 00       	and    $0x3000,%eax
  101bb8:	c1 e8 0c             	shr    $0xc,%eax
  101bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbf:	c7 04 24 51 64 10 00 	movl   $0x106451,(%esp)
  101bc6:	e8 71 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	89 04 24             	mov    %eax,(%esp)
  101bd1:	e8 5b fe ff ff       	call   101a31 <trap_in_kernel>
  101bd6:	85 c0                	test   %eax,%eax
  101bd8:	75 30                	jne    101c0a <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bda:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdd:	8b 40 44             	mov    0x44(%eax),%eax
  101be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be4:	c7 04 24 5a 64 10 00 	movl   $0x10645a,(%esp)
  101beb:	e8 4c e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf3:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bf7:	0f b7 c0             	movzwl %ax,%eax
  101bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfe:	c7 04 24 69 64 10 00 	movl   $0x106469,(%esp)
  101c05:	e8 32 e7 ff ff       	call   10033c <cprintf>
    }
}
  101c0a:	c9                   	leave  
  101c0b:	c3                   	ret    

00101c0c <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c0c:	55                   	push   %ebp
  101c0d:	89 e5                	mov    %esp,%ebp
  101c0f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c12:	8b 45 08             	mov    0x8(%ebp),%eax
  101c15:	8b 00                	mov    (%eax),%eax
  101c17:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1b:	c7 04 24 7c 64 10 00 	movl   $0x10647c,(%esp)
  101c22:	e8 15 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c27:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2a:	8b 40 04             	mov    0x4(%eax),%eax
  101c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c31:	c7 04 24 8b 64 10 00 	movl   $0x10648b,(%esp)
  101c38:	e8 ff e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c40:	8b 40 08             	mov    0x8(%eax),%eax
  101c43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c47:	c7 04 24 9a 64 10 00 	movl   $0x10649a,(%esp)
  101c4e:	e8 e9 e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c53:	8b 45 08             	mov    0x8(%ebp),%eax
  101c56:	8b 40 0c             	mov    0xc(%eax),%eax
  101c59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5d:	c7 04 24 a9 64 10 00 	movl   $0x1064a9,(%esp)
  101c64:	e8 d3 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c69:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6c:	8b 40 10             	mov    0x10(%eax),%eax
  101c6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c73:	c7 04 24 b8 64 10 00 	movl   $0x1064b8,(%esp)
  101c7a:	e8 bd e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c82:	8b 40 14             	mov    0x14(%eax),%eax
  101c85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c89:	c7 04 24 c7 64 10 00 	movl   $0x1064c7,(%esp)
  101c90:	e8 a7 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c95:	8b 45 08             	mov    0x8(%ebp),%eax
  101c98:	8b 40 18             	mov    0x18(%eax),%eax
  101c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9f:	c7 04 24 d6 64 10 00 	movl   $0x1064d6,(%esp)
  101ca6:	e8 91 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cab:	8b 45 08             	mov    0x8(%ebp),%eax
  101cae:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb5:	c7 04 24 e5 64 10 00 	movl   $0x1064e5,(%esp)
  101cbc:	e8 7b e6 ff ff       	call   10033c <cprintf>
}
  101cc1:	c9                   	leave  
  101cc2:	c3                   	ret    

00101cc3 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cc3:	55                   	push   %ebp
  101cc4:	89 e5                	mov    %esp,%ebp
  101cc6:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccc:	8b 40 30             	mov    0x30(%eax),%eax
  101ccf:	83 f8 2f             	cmp    $0x2f,%eax
  101cd2:	77 21                	ja     101cf5 <trap_dispatch+0x32>
  101cd4:	83 f8 2e             	cmp    $0x2e,%eax
  101cd7:	0f 83 03 01 00 00    	jae    101de0 <trap_dispatch+0x11d>
  101cdd:	83 f8 21             	cmp    $0x21,%eax
  101ce0:	0f 84 80 00 00 00    	je     101d66 <trap_dispatch+0xa3>
  101ce6:	83 f8 24             	cmp    $0x24,%eax
  101ce9:	74 55                	je     101d40 <trap_dispatch+0x7d>
  101ceb:	83 f8 20             	cmp    $0x20,%eax
  101cee:	74 16                	je     101d06 <trap_dispatch+0x43>
  101cf0:	e9 b3 00 00 00       	jmp    101da8 <trap_dispatch+0xe5>
  101cf5:	83 e8 78             	sub    $0x78,%eax
  101cf8:	83 f8 01             	cmp    $0x1,%eax
  101cfb:	0f 87 a7 00 00 00    	ja     101da8 <trap_dispatch+0xe5>
  101d01:	e9 86 00 00 00       	jmp    101d8c <trap_dispatch+0xc9>
		/* handle the timer interrupt */
		/* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
		* (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
		* (3) Too Simple? Yes, I think so!
		*/
		ticks = (ticks + 1) % TICK_NUM;
  101d06:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d0b:	8d 48 01             	lea    0x1(%eax),%ecx
  101d0e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d13:	89 c8                	mov    %ecx,%eax
  101d15:	f7 e2                	mul    %edx
  101d17:	89 d0                	mov    %edx,%eax
  101d19:	c1 e8 05             	shr    $0x5,%eax
  101d1c:	6b c0 64             	imul   $0x64,%eax,%eax
  101d1f:	29 c1                	sub    %eax,%ecx
  101d21:	89 c8                	mov    %ecx,%eax
  101d23:	a3 4c 89 11 00       	mov    %eax,0x11894c
		if (ticks == 0)
  101d28:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d2d:	85 c0                	test   %eax,%eax
  101d2f:	75 0a                	jne    101d3b <trap_dispatch+0x78>
			print_ticks();
  101d31:	e8 41 fb ff ff       	call   101877 <print_ticks>
		break;
  101d36:	e9 a6 00 00 00       	jmp    101de1 <trap_dispatch+0x11e>
  101d3b:	e9 a1 00 00 00       	jmp    101de1 <trap_dispatch+0x11e>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d40:	e8 f6 f8 ff ff       	call   10163b <cons_getc>
  101d45:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d48:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d4c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d50:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d58:	c7 04 24 f4 64 10 00 	movl   $0x1064f4,(%esp)
  101d5f:	e8 d8 e5 ff ff       	call   10033c <cprintf>
        break;
  101d64:	eb 7b                	jmp    101de1 <trap_dispatch+0x11e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d66:	e8 d0 f8 ff ff       	call   10163b <cons_getc>
  101d6b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d6e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d72:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d76:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7e:	c7 04 24 06 65 10 00 	movl   $0x106506,(%esp)
  101d85:	e8 b2 e5 ff ff       	call   10033c <cprintf>
        break;
  101d8a:	eb 55                	jmp    101de1 <trap_dispatch+0x11e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d8c:	c7 44 24 08 15 65 10 	movl   $0x106515,0x8(%esp)
  101d93:	00 
  101d94:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  101d9b:	00 
  101d9c:	c7 04 24 25 65 10 00 	movl   $0x106525,(%esp)
  101da3:	e8 25 ef ff ff       	call   100ccd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101da8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dab:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101daf:	0f b7 c0             	movzwl %ax,%eax
  101db2:	83 e0 03             	and    $0x3,%eax
  101db5:	85 c0                	test   %eax,%eax
  101db7:	75 28                	jne    101de1 <trap_dispatch+0x11e>
            print_trapframe(tf);
  101db9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbc:	89 04 24             	mov    %eax,(%esp)
  101dbf:	e8 83 fc ff ff       	call   101a47 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101dc4:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  101dcb:	00 
  101dcc:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  101dd3:	00 
  101dd4:	c7 04 24 25 65 10 00 	movl   $0x106525,(%esp)
  101ddb:	e8 ed ee ff ff       	call   100ccd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101de0:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101de1:	c9                   	leave  
  101de2:	c3                   	ret    

00101de3 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101de3:	55                   	push   %ebp
  101de4:	89 e5                	mov    %esp,%ebp
  101de6:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101de9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dec:	89 04 24             	mov    %eax,(%esp)
  101def:	e8 cf fe ff ff       	call   101cc3 <trap_dispatch>
}
  101df4:	c9                   	leave  
  101df5:	c3                   	ret    

00101df6 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101df6:	1e                   	push   %ds
    pushl %es
  101df7:	06                   	push   %es
    pushl %fs
  101df8:	0f a0                	push   %fs
    pushl %gs
  101dfa:	0f a8                	push   %gs
    pushal
  101dfc:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101dfd:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e02:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e04:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e06:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e07:	e8 d7 ff ff ff       	call   101de3 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e0c:	5c                   	pop    %esp

00101e0d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e0d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e0e:	0f a9                	pop    %gs
    popl %fs
  101e10:	0f a1                	pop    %fs
    popl %es
  101e12:	07                   	pop    %es
    popl %ds
  101e13:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e14:	83 c4 08             	add    $0x8,%esp
    iret
  101e17:	cf                   	iret   

00101e18 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $0
  101e1a:	6a 00                	push   $0x0
  jmp __alltraps
  101e1c:	e9 d5 ff ff ff       	jmp    101df6 <__alltraps>

00101e21 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e21:	6a 00                	push   $0x0
  pushl $1
  101e23:	6a 01                	push   $0x1
  jmp __alltraps
  101e25:	e9 cc ff ff ff       	jmp    101df6 <__alltraps>

00101e2a <vector2>:
.globl vector2
vector2:
  pushl $0
  101e2a:	6a 00                	push   $0x0
  pushl $2
  101e2c:	6a 02                	push   $0x2
  jmp __alltraps
  101e2e:	e9 c3 ff ff ff       	jmp    101df6 <__alltraps>

00101e33 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e33:	6a 00                	push   $0x0
  pushl $3
  101e35:	6a 03                	push   $0x3
  jmp __alltraps
  101e37:	e9 ba ff ff ff       	jmp    101df6 <__alltraps>

00101e3c <vector4>:
.globl vector4
vector4:
  pushl $0
  101e3c:	6a 00                	push   $0x0
  pushl $4
  101e3e:	6a 04                	push   $0x4
  jmp __alltraps
  101e40:	e9 b1 ff ff ff       	jmp    101df6 <__alltraps>

00101e45 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e45:	6a 00                	push   $0x0
  pushl $5
  101e47:	6a 05                	push   $0x5
  jmp __alltraps
  101e49:	e9 a8 ff ff ff       	jmp    101df6 <__alltraps>

00101e4e <vector6>:
.globl vector6
vector6:
  pushl $0
  101e4e:	6a 00                	push   $0x0
  pushl $6
  101e50:	6a 06                	push   $0x6
  jmp __alltraps
  101e52:	e9 9f ff ff ff       	jmp    101df6 <__alltraps>

00101e57 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e57:	6a 00                	push   $0x0
  pushl $7
  101e59:	6a 07                	push   $0x7
  jmp __alltraps
  101e5b:	e9 96 ff ff ff       	jmp    101df6 <__alltraps>

00101e60 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e60:	6a 08                	push   $0x8
  jmp __alltraps
  101e62:	e9 8f ff ff ff       	jmp    101df6 <__alltraps>

00101e67 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e67:	6a 09                	push   $0x9
  jmp __alltraps
  101e69:	e9 88 ff ff ff       	jmp    101df6 <__alltraps>

00101e6e <vector10>:
.globl vector10
vector10:
  pushl $10
  101e6e:	6a 0a                	push   $0xa
  jmp __alltraps
  101e70:	e9 81 ff ff ff       	jmp    101df6 <__alltraps>

00101e75 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e75:	6a 0b                	push   $0xb
  jmp __alltraps
  101e77:	e9 7a ff ff ff       	jmp    101df6 <__alltraps>

00101e7c <vector12>:
.globl vector12
vector12:
  pushl $12
  101e7c:	6a 0c                	push   $0xc
  jmp __alltraps
  101e7e:	e9 73 ff ff ff       	jmp    101df6 <__alltraps>

00101e83 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e83:	6a 0d                	push   $0xd
  jmp __alltraps
  101e85:	e9 6c ff ff ff       	jmp    101df6 <__alltraps>

00101e8a <vector14>:
.globl vector14
vector14:
  pushl $14
  101e8a:	6a 0e                	push   $0xe
  jmp __alltraps
  101e8c:	e9 65 ff ff ff       	jmp    101df6 <__alltraps>

00101e91 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e91:	6a 00                	push   $0x0
  pushl $15
  101e93:	6a 0f                	push   $0xf
  jmp __alltraps
  101e95:	e9 5c ff ff ff       	jmp    101df6 <__alltraps>

00101e9a <vector16>:
.globl vector16
vector16:
  pushl $0
  101e9a:	6a 00                	push   $0x0
  pushl $16
  101e9c:	6a 10                	push   $0x10
  jmp __alltraps
  101e9e:	e9 53 ff ff ff       	jmp    101df6 <__alltraps>

00101ea3 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ea3:	6a 11                	push   $0x11
  jmp __alltraps
  101ea5:	e9 4c ff ff ff       	jmp    101df6 <__alltraps>

00101eaa <vector18>:
.globl vector18
vector18:
  pushl $0
  101eaa:	6a 00                	push   $0x0
  pushl $18
  101eac:	6a 12                	push   $0x12
  jmp __alltraps
  101eae:	e9 43 ff ff ff       	jmp    101df6 <__alltraps>

00101eb3 <vector19>:
.globl vector19
vector19:
  pushl $0
  101eb3:	6a 00                	push   $0x0
  pushl $19
  101eb5:	6a 13                	push   $0x13
  jmp __alltraps
  101eb7:	e9 3a ff ff ff       	jmp    101df6 <__alltraps>

00101ebc <vector20>:
.globl vector20
vector20:
  pushl $0
  101ebc:	6a 00                	push   $0x0
  pushl $20
  101ebe:	6a 14                	push   $0x14
  jmp __alltraps
  101ec0:	e9 31 ff ff ff       	jmp    101df6 <__alltraps>

00101ec5 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ec5:	6a 00                	push   $0x0
  pushl $21
  101ec7:	6a 15                	push   $0x15
  jmp __alltraps
  101ec9:	e9 28 ff ff ff       	jmp    101df6 <__alltraps>

00101ece <vector22>:
.globl vector22
vector22:
  pushl $0
  101ece:	6a 00                	push   $0x0
  pushl $22
  101ed0:	6a 16                	push   $0x16
  jmp __alltraps
  101ed2:	e9 1f ff ff ff       	jmp    101df6 <__alltraps>

00101ed7 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ed7:	6a 00                	push   $0x0
  pushl $23
  101ed9:	6a 17                	push   $0x17
  jmp __alltraps
  101edb:	e9 16 ff ff ff       	jmp    101df6 <__alltraps>

00101ee0 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ee0:	6a 00                	push   $0x0
  pushl $24
  101ee2:	6a 18                	push   $0x18
  jmp __alltraps
  101ee4:	e9 0d ff ff ff       	jmp    101df6 <__alltraps>

00101ee9 <vector25>:
.globl vector25
vector25:
  pushl $0
  101ee9:	6a 00                	push   $0x0
  pushl $25
  101eeb:	6a 19                	push   $0x19
  jmp __alltraps
  101eed:	e9 04 ff ff ff       	jmp    101df6 <__alltraps>

00101ef2 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ef2:	6a 00                	push   $0x0
  pushl $26
  101ef4:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ef6:	e9 fb fe ff ff       	jmp    101df6 <__alltraps>

00101efb <vector27>:
.globl vector27
vector27:
  pushl $0
  101efb:	6a 00                	push   $0x0
  pushl $27
  101efd:	6a 1b                	push   $0x1b
  jmp __alltraps
  101eff:	e9 f2 fe ff ff       	jmp    101df6 <__alltraps>

00101f04 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f04:	6a 00                	push   $0x0
  pushl $28
  101f06:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f08:	e9 e9 fe ff ff       	jmp    101df6 <__alltraps>

00101f0d <vector29>:
.globl vector29
vector29:
  pushl $0
  101f0d:	6a 00                	push   $0x0
  pushl $29
  101f0f:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f11:	e9 e0 fe ff ff       	jmp    101df6 <__alltraps>

00101f16 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $30
  101f18:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f1a:	e9 d7 fe ff ff       	jmp    101df6 <__alltraps>

00101f1f <vector31>:
.globl vector31
vector31:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $31
  101f21:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f23:	e9 ce fe ff ff       	jmp    101df6 <__alltraps>

00101f28 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $32
  101f2a:	6a 20                	push   $0x20
  jmp __alltraps
  101f2c:	e9 c5 fe ff ff       	jmp    101df6 <__alltraps>

00101f31 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $33
  101f33:	6a 21                	push   $0x21
  jmp __alltraps
  101f35:	e9 bc fe ff ff       	jmp    101df6 <__alltraps>

00101f3a <vector34>:
.globl vector34
vector34:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $34
  101f3c:	6a 22                	push   $0x22
  jmp __alltraps
  101f3e:	e9 b3 fe ff ff       	jmp    101df6 <__alltraps>

00101f43 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $35
  101f45:	6a 23                	push   $0x23
  jmp __alltraps
  101f47:	e9 aa fe ff ff       	jmp    101df6 <__alltraps>

00101f4c <vector36>:
.globl vector36
vector36:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $36
  101f4e:	6a 24                	push   $0x24
  jmp __alltraps
  101f50:	e9 a1 fe ff ff       	jmp    101df6 <__alltraps>

00101f55 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $37
  101f57:	6a 25                	push   $0x25
  jmp __alltraps
  101f59:	e9 98 fe ff ff       	jmp    101df6 <__alltraps>

00101f5e <vector38>:
.globl vector38
vector38:
  pushl $0
  101f5e:	6a 00                	push   $0x0
  pushl $38
  101f60:	6a 26                	push   $0x26
  jmp __alltraps
  101f62:	e9 8f fe ff ff       	jmp    101df6 <__alltraps>

00101f67 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f67:	6a 00                	push   $0x0
  pushl $39
  101f69:	6a 27                	push   $0x27
  jmp __alltraps
  101f6b:	e9 86 fe ff ff       	jmp    101df6 <__alltraps>

00101f70 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f70:	6a 00                	push   $0x0
  pushl $40
  101f72:	6a 28                	push   $0x28
  jmp __alltraps
  101f74:	e9 7d fe ff ff       	jmp    101df6 <__alltraps>

00101f79 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $41
  101f7b:	6a 29                	push   $0x29
  jmp __alltraps
  101f7d:	e9 74 fe ff ff       	jmp    101df6 <__alltraps>

00101f82 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f82:	6a 00                	push   $0x0
  pushl $42
  101f84:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f86:	e9 6b fe ff ff       	jmp    101df6 <__alltraps>

00101f8b <vector43>:
.globl vector43
vector43:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $43
  101f8d:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f8f:	e9 62 fe ff ff       	jmp    101df6 <__alltraps>

00101f94 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $44
  101f96:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f98:	e9 59 fe ff ff       	jmp    101df6 <__alltraps>

00101f9d <vector45>:
.globl vector45
vector45:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $45
  101f9f:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fa1:	e9 50 fe ff ff       	jmp    101df6 <__alltraps>

00101fa6 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $46
  101fa8:	6a 2e                	push   $0x2e
  jmp __alltraps
  101faa:	e9 47 fe ff ff       	jmp    101df6 <__alltraps>

00101faf <vector47>:
.globl vector47
vector47:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $47
  101fb1:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fb3:	e9 3e fe ff ff       	jmp    101df6 <__alltraps>

00101fb8 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $48
  101fba:	6a 30                	push   $0x30
  jmp __alltraps
  101fbc:	e9 35 fe ff ff       	jmp    101df6 <__alltraps>

00101fc1 <vector49>:
.globl vector49
vector49:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $49
  101fc3:	6a 31                	push   $0x31
  jmp __alltraps
  101fc5:	e9 2c fe ff ff       	jmp    101df6 <__alltraps>

00101fca <vector50>:
.globl vector50
vector50:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $50
  101fcc:	6a 32                	push   $0x32
  jmp __alltraps
  101fce:	e9 23 fe ff ff       	jmp    101df6 <__alltraps>

00101fd3 <vector51>:
.globl vector51
vector51:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $51
  101fd5:	6a 33                	push   $0x33
  jmp __alltraps
  101fd7:	e9 1a fe ff ff       	jmp    101df6 <__alltraps>

00101fdc <vector52>:
.globl vector52
vector52:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $52
  101fde:	6a 34                	push   $0x34
  jmp __alltraps
  101fe0:	e9 11 fe ff ff       	jmp    101df6 <__alltraps>

00101fe5 <vector53>:
.globl vector53
vector53:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $53
  101fe7:	6a 35                	push   $0x35
  jmp __alltraps
  101fe9:	e9 08 fe ff ff       	jmp    101df6 <__alltraps>

00101fee <vector54>:
.globl vector54
vector54:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $54
  101ff0:	6a 36                	push   $0x36
  jmp __alltraps
  101ff2:	e9 ff fd ff ff       	jmp    101df6 <__alltraps>

00101ff7 <vector55>:
.globl vector55
vector55:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $55
  101ff9:	6a 37                	push   $0x37
  jmp __alltraps
  101ffb:	e9 f6 fd ff ff       	jmp    101df6 <__alltraps>

00102000 <vector56>:
.globl vector56
vector56:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $56
  102002:	6a 38                	push   $0x38
  jmp __alltraps
  102004:	e9 ed fd ff ff       	jmp    101df6 <__alltraps>

00102009 <vector57>:
.globl vector57
vector57:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $57
  10200b:	6a 39                	push   $0x39
  jmp __alltraps
  10200d:	e9 e4 fd ff ff       	jmp    101df6 <__alltraps>

00102012 <vector58>:
.globl vector58
vector58:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $58
  102014:	6a 3a                	push   $0x3a
  jmp __alltraps
  102016:	e9 db fd ff ff       	jmp    101df6 <__alltraps>

0010201b <vector59>:
.globl vector59
vector59:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $59
  10201d:	6a 3b                	push   $0x3b
  jmp __alltraps
  10201f:	e9 d2 fd ff ff       	jmp    101df6 <__alltraps>

00102024 <vector60>:
.globl vector60
vector60:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $60
  102026:	6a 3c                	push   $0x3c
  jmp __alltraps
  102028:	e9 c9 fd ff ff       	jmp    101df6 <__alltraps>

0010202d <vector61>:
.globl vector61
vector61:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $61
  10202f:	6a 3d                	push   $0x3d
  jmp __alltraps
  102031:	e9 c0 fd ff ff       	jmp    101df6 <__alltraps>

00102036 <vector62>:
.globl vector62
vector62:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $62
  102038:	6a 3e                	push   $0x3e
  jmp __alltraps
  10203a:	e9 b7 fd ff ff       	jmp    101df6 <__alltraps>

0010203f <vector63>:
.globl vector63
vector63:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $63
  102041:	6a 3f                	push   $0x3f
  jmp __alltraps
  102043:	e9 ae fd ff ff       	jmp    101df6 <__alltraps>

00102048 <vector64>:
.globl vector64
vector64:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $64
  10204a:	6a 40                	push   $0x40
  jmp __alltraps
  10204c:	e9 a5 fd ff ff       	jmp    101df6 <__alltraps>

00102051 <vector65>:
.globl vector65
vector65:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $65
  102053:	6a 41                	push   $0x41
  jmp __alltraps
  102055:	e9 9c fd ff ff       	jmp    101df6 <__alltraps>

0010205a <vector66>:
.globl vector66
vector66:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $66
  10205c:	6a 42                	push   $0x42
  jmp __alltraps
  10205e:	e9 93 fd ff ff       	jmp    101df6 <__alltraps>

00102063 <vector67>:
.globl vector67
vector67:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $67
  102065:	6a 43                	push   $0x43
  jmp __alltraps
  102067:	e9 8a fd ff ff       	jmp    101df6 <__alltraps>

0010206c <vector68>:
.globl vector68
vector68:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $68
  10206e:	6a 44                	push   $0x44
  jmp __alltraps
  102070:	e9 81 fd ff ff       	jmp    101df6 <__alltraps>

00102075 <vector69>:
.globl vector69
vector69:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $69
  102077:	6a 45                	push   $0x45
  jmp __alltraps
  102079:	e9 78 fd ff ff       	jmp    101df6 <__alltraps>

0010207e <vector70>:
.globl vector70
vector70:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $70
  102080:	6a 46                	push   $0x46
  jmp __alltraps
  102082:	e9 6f fd ff ff       	jmp    101df6 <__alltraps>

00102087 <vector71>:
.globl vector71
vector71:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $71
  102089:	6a 47                	push   $0x47
  jmp __alltraps
  10208b:	e9 66 fd ff ff       	jmp    101df6 <__alltraps>

00102090 <vector72>:
.globl vector72
vector72:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $72
  102092:	6a 48                	push   $0x48
  jmp __alltraps
  102094:	e9 5d fd ff ff       	jmp    101df6 <__alltraps>

00102099 <vector73>:
.globl vector73
vector73:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $73
  10209b:	6a 49                	push   $0x49
  jmp __alltraps
  10209d:	e9 54 fd ff ff       	jmp    101df6 <__alltraps>

001020a2 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $74
  1020a4:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020a6:	e9 4b fd ff ff       	jmp    101df6 <__alltraps>

001020ab <vector75>:
.globl vector75
vector75:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $75
  1020ad:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020af:	e9 42 fd ff ff       	jmp    101df6 <__alltraps>

001020b4 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $76
  1020b6:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020b8:	e9 39 fd ff ff       	jmp    101df6 <__alltraps>

001020bd <vector77>:
.globl vector77
vector77:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $77
  1020bf:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020c1:	e9 30 fd ff ff       	jmp    101df6 <__alltraps>

001020c6 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $78
  1020c8:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020ca:	e9 27 fd ff ff       	jmp    101df6 <__alltraps>

001020cf <vector79>:
.globl vector79
vector79:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $79
  1020d1:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020d3:	e9 1e fd ff ff       	jmp    101df6 <__alltraps>

001020d8 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $80
  1020da:	6a 50                	push   $0x50
  jmp __alltraps
  1020dc:	e9 15 fd ff ff       	jmp    101df6 <__alltraps>

001020e1 <vector81>:
.globl vector81
vector81:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $81
  1020e3:	6a 51                	push   $0x51
  jmp __alltraps
  1020e5:	e9 0c fd ff ff       	jmp    101df6 <__alltraps>

001020ea <vector82>:
.globl vector82
vector82:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $82
  1020ec:	6a 52                	push   $0x52
  jmp __alltraps
  1020ee:	e9 03 fd ff ff       	jmp    101df6 <__alltraps>

001020f3 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $83
  1020f5:	6a 53                	push   $0x53
  jmp __alltraps
  1020f7:	e9 fa fc ff ff       	jmp    101df6 <__alltraps>

001020fc <vector84>:
.globl vector84
vector84:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $84
  1020fe:	6a 54                	push   $0x54
  jmp __alltraps
  102100:	e9 f1 fc ff ff       	jmp    101df6 <__alltraps>

00102105 <vector85>:
.globl vector85
vector85:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $85
  102107:	6a 55                	push   $0x55
  jmp __alltraps
  102109:	e9 e8 fc ff ff       	jmp    101df6 <__alltraps>

0010210e <vector86>:
.globl vector86
vector86:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $86
  102110:	6a 56                	push   $0x56
  jmp __alltraps
  102112:	e9 df fc ff ff       	jmp    101df6 <__alltraps>

00102117 <vector87>:
.globl vector87
vector87:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $87
  102119:	6a 57                	push   $0x57
  jmp __alltraps
  10211b:	e9 d6 fc ff ff       	jmp    101df6 <__alltraps>

00102120 <vector88>:
.globl vector88
vector88:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $88
  102122:	6a 58                	push   $0x58
  jmp __alltraps
  102124:	e9 cd fc ff ff       	jmp    101df6 <__alltraps>

00102129 <vector89>:
.globl vector89
vector89:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $89
  10212b:	6a 59                	push   $0x59
  jmp __alltraps
  10212d:	e9 c4 fc ff ff       	jmp    101df6 <__alltraps>

00102132 <vector90>:
.globl vector90
vector90:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $90
  102134:	6a 5a                	push   $0x5a
  jmp __alltraps
  102136:	e9 bb fc ff ff       	jmp    101df6 <__alltraps>

0010213b <vector91>:
.globl vector91
vector91:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $91
  10213d:	6a 5b                	push   $0x5b
  jmp __alltraps
  10213f:	e9 b2 fc ff ff       	jmp    101df6 <__alltraps>

00102144 <vector92>:
.globl vector92
vector92:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $92
  102146:	6a 5c                	push   $0x5c
  jmp __alltraps
  102148:	e9 a9 fc ff ff       	jmp    101df6 <__alltraps>

0010214d <vector93>:
.globl vector93
vector93:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $93
  10214f:	6a 5d                	push   $0x5d
  jmp __alltraps
  102151:	e9 a0 fc ff ff       	jmp    101df6 <__alltraps>

00102156 <vector94>:
.globl vector94
vector94:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $94
  102158:	6a 5e                	push   $0x5e
  jmp __alltraps
  10215a:	e9 97 fc ff ff       	jmp    101df6 <__alltraps>

0010215f <vector95>:
.globl vector95
vector95:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $95
  102161:	6a 5f                	push   $0x5f
  jmp __alltraps
  102163:	e9 8e fc ff ff       	jmp    101df6 <__alltraps>

00102168 <vector96>:
.globl vector96
vector96:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $96
  10216a:	6a 60                	push   $0x60
  jmp __alltraps
  10216c:	e9 85 fc ff ff       	jmp    101df6 <__alltraps>

00102171 <vector97>:
.globl vector97
vector97:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $97
  102173:	6a 61                	push   $0x61
  jmp __alltraps
  102175:	e9 7c fc ff ff       	jmp    101df6 <__alltraps>

0010217a <vector98>:
.globl vector98
vector98:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $98
  10217c:	6a 62                	push   $0x62
  jmp __alltraps
  10217e:	e9 73 fc ff ff       	jmp    101df6 <__alltraps>

00102183 <vector99>:
.globl vector99
vector99:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $99
  102185:	6a 63                	push   $0x63
  jmp __alltraps
  102187:	e9 6a fc ff ff       	jmp    101df6 <__alltraps>

0010218c <vector100>:
.globl vector100
vector100:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $100
  10218e:	6a 64                	push   $0x64
  jmp __alltraps
  102190:	e9 61 fc ff ff       	jmp    101df6 <__alltraps>

00102195 <vector101>:
.globl vector101
vector101:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $101
  102197:	6a 65                	push   $0x65
  jmp __alltraps
  102199:	e9 58 fc ff ff       	jmp    101df6 <__alltraps>

0010219e <vector102>:
.globl vector102
vector102:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $102
  1021a0:	6a 66                	push   $0x66
  jmp __alltraps
  1021a2:	e9 4f fc ff ff       	jmp    101df6 <__alltraps>

001021a7 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $103
  1021a9:	6a 67                	push   $0x67
  jmp __alltraps
  1021ab:	e9 46 fc ff ff       	jmp    101df6 <__alltraps>

001021b0 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $104
  1021b2:	6a 68                	push   $0x68
  jmp __alltraps
  1021b4:	e9 3d fc ff ff       	jmp    101df6 <__alltraps>

001021b9 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $105
  1021bb:	6a 69                	push   $0x69
  jmp __alltraps
  1021bd:	e9 34 fc ff ff       	jmp    101df6 <__alltraps>

001021c2 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $106
  1021c4:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021c6:	e9 2b fc ff ff       	jmp    101df6 <__alltraps>

001021cb <vector107>:
.globl vector107
vector107:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $107
  1021cd:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021cf:	e9 22 fc ff ff       	jmp    101df6 <__alltraps>

001021d4 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $108
  1021d6:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021d8:	e9 19 fc ff ff       	jmp    101df6 <__alltraps>

001021dd <vector109>:
.globl vector109
vector109:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $109
  1021df:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021e1:	e9 10 fc ff ff       	jmp    101df6 <__alltraps>

001021e6 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $110
  1021e8:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021ea:	e9 07 fc ff ff       	jmp    101df6 <__alltraps>

001021ef <vector111>:
.globl vector111
vector111:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $111
  1021f1:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021f3:	e9 fe fb ff ff       	jmp    101df6 <__alltraps>

001021f8 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $112
  1021fa:	6a 70                	push   $0x70
  jmp __alltraps
  1021fc:	e9 f5 fb ff ff       	jmp    101df6 <__alltraps>

00102201 <vector113>:
.globl vector113
vector113:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $113
  102203:	6a 71                	push   $0x71
  jmp __alltraps
  102205:	e9 ec fb ff ff       	jmp    101df6 <__alltraps>

0010220a <vector114>:
.globl vector114
vector114:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $114
  10220c:	6a 72                	push   $0x72
  jmp __alltraps
  10220e:	e9 e3 fb ff ff       	jmp    101df6 <__alltraps>

00102213 <vector115>:
.globl vector115
vector115:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $115
  102215:	6a 73                	push   $0x73
  jmp __alltraps
  102217:	e9 da fb ff ff       	jmp    101df6 <__alltraps>

0010221c <vector116>:
.globl vector116
vector116:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $116
  10221e:	6a 74                	push   $0x74
  jmp __alltraps
  102220:	e9 d1 fb ff ff       	jmp    101df6 <__alltraps>

00102225 <vector117>:
.globl vector117
vector117:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $117
  102227:	6a 75                	push   $0x75
  jmp __alltraps
  102229:	e9 c8 fb ff ff       	jmp    101df6 <__alltraps>

0010222e <vector118>:
.globl vector118
vector118:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $118
  102230:	6a 76                	push   $0x76
  jmp __alltraps
  102232:	e9 bf fb ff ff       	jmp    101df6 <__alltraps>

00102237 <vector119>:
.globl vector119
vector119:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $119
  102239:	6a 77                	push   $0x77
  jmp __alltraps
  10223b:	e9 b6 fb ff ff       	jmp    101df6 <__alltraps>

00102240 <vector120>:
.globl vector120
vector120:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $120
  102242:	6a 78                	push   $0x78
  jmp __alltraps
  102244:	e9 ad fb ff ff       	jmp    101df6 <__alltraps>

00102249 <vector121>:
.globl vector121
vector121:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $121
  10224b:	6a 79                	push   $0x79
  jmp __alltraps
  10224d:	e9 a4 fb ff ff       	jmp    101df6 <__alltraps>

00102252 <vector122>:
.globl vector122
vector122:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $122
  102254:	6a 7a                	push   $0x7a
  jmp __alltraps
  102256:	e9 9b fb ff ff       	jmp    101df6 <__alltraps>

0010225b <vector123>:
.globl vector123
vector123:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $123
  10225d:	6a 7b                	push   $0x7b
  jmp __alltraps
  10225f:	e9 92 fb ff ff       	jmp    101df6 <__alltraps>

00102264 <vector124>:
.globl vector124
vector124:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $124
  102266:	6a 7c                	push   $0x7c
  jmp __alltraps
  102268:	e9 89 fb ff ff       	jmp    101df6 <__alltraps>

0010226d <vector125>:
.globl vector125
vector125:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $125
  10226f:	6a 7d                	push   $0x7d
  jmp __alltraps
  102271:	e9 80 fb ff ff       	jmp    101df6 <__alltraps>

00102276 <vector126>:
.globl vector126
vector126:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $126
  102278:	6a 7e                	push   $0x7e
  jmp __alltraps
  10227a:	e9 77 fb ff ff       	jmp    101df6 <__alltraps>

0010227f <vector127>:
.globl vector127
vector127:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $127
  102281:	6a 7f                	push   $0x7f
  jmp __alltraps
  102283:	e9 6e fb ff ff       	jmp    101df6 <__alltraps>

00102288 <vector128>:
.globl vector128
vector128:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $128
  10228a:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10228f:	e9 62 fb ff ff       	jmp    101df6 <__alltraps>

00102294 <vector129>:
.globl vector129
vector129:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $129
  102296:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10229b:	e9 56 fb ff ff       	jmp    101df6 <__alltraps>

001022a0 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $130
  1022a2:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022a7:	e9 4a fb ff ff       	jmp    101df6 <__alltraps>

001022ac <vector131>:
.globl vector131
vector131:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $131
  1022ae:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022b3:	e9 3e fb ff ff       	jmp    101df6 <__alltraps>

001022b8 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $132
  1022ba:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022bf:	e9 32 fb ff ff       	jmp    101df6 <__alltraps>

001022c4 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $133
  1022c6:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022cb:	e9 26 fb ff ff       	jmp    101df6 <__alltraps>

001022d0 <vector134>:
.globl vector134
vector134:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $134
  1022d2:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022d7:	e9 1a fb ff ff       	jmp    101df6 <__alltraps>

001022dc <vector135>:
.globl vector135
vector135:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $135
  1022de:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022e3:	e9 0e fb ff ff       	jmp    101df6 <__alltraps>

001022e8 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $136
  1022ea:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022ef:	e9 02 fb ff ff       	jmp    101df6 <__alltraps>

001022f4 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $137
  1022f6:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022fb:	e9 f6 fa ff ff       	jmp    101df6 <__alltraps>

00102300 <vector138>:
.globl vector138
vector138:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $138
  102302:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102307:	e9 ea fa ff ff       	jmp    101df6 <__alltraps>

0010230c <vector139>:
.globl vector139
vector139:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $139
  10230e:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102313:	e9 de fa ff ff       	jmp    101df6 <__alltraps>

00102318 <vector140>:
.globl vector140
vector140:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $140
  10231a:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10231f:	e9 d2 fa ff ff       	jmp    101df6 <__alltraps>

00102324 <vector141>:
.globl vector141
vector141:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $141
  102326:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10232b:	e9 c6 fa ff ff       	jmp    101df6 <__alltraps>

00102330 <vector142>:
.globl vector142
vector142:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $142
  102332:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102337:	e9 ba fa ff ff       	jmp    101df6 <__alltraps>

0010233c <vector143>:
.globl vector143
vector143:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $143
  10233e:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102343:	e9 ae fa ff ff       	jmp    101df6 <__alltraps>

00102348 <vector144>:
.globl vector144
vector144:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $144
  10234a:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10234f:	e9 a2 fa ff ff       	jmp    101df6 <__alltraps>

00102354 <vector145>:
.globl vector145
vector145:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $145
  102356:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10235b:	e9 96 fa ff ff       	jmp    101df6 <__alltraps>

00102360 <vector146>:
.globl vector146
vector146:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $146
  102362:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102367:	e9 8a fa ff ff       	jmp    101df6 <__alltraps>

0010236c <vector147>:
.globl vector147
vector147:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $147
  10236e:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102373:	e9 7e fa ff ff       	jmp    101df6 <__alltraps>

00102378 <vector148>:
.globl vector148
vector148:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $148
  10237a:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10237f:	e9 72 fa ff ff       	jmp    101df6 <__alltraps>

00102384 <vector149>:
.globl vector149
vector149:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $149
  102386:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10238b:	e9 66 fa ff ff       	jmp    101df6 <__alltraps>

00102390 <vector150>:
.globl vector150
vector150:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $150
  102392:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102397:	e9 5a fa ff ff       	jmp    101df6 <__alltraps>

0010239c <vector151>:
.globl vector151
vector151:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $151
  10239e:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023a3:	e9 4e fa ff ff       	jmp    101df6 <__alltraps>

001023a8 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $152
  1023aa:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023af:	e9 42 fa ff ff       	jmp    101df6 <__alltraps>

001023b4 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $153
  1023b6:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023bb:	e9 36 fa ff ff       	jmp    101df6 <__alltraps>

001023c0 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $154
  1023c2:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023c7:	e9 2a fa ff ff       	jmp    101df6 <__alltraps>

001023cc <vector155>:
.globl vector155
vector155:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $155
  1023ce:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023d3:	e9 1e fa ff ff       	jmp    101df6 <__alltraps>

001023d8 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $156
  1023da:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023df:	e9 12 fa ff ff       	jmp    101df6 <__alltraps>

001023e4 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $157
  1023e6:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023eb:	e9 06 fa ff ff       	jmp    101df6 <__alltraps>

001023f0 <vector158>:
.globl vector158
vector158:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $158
  1023f2:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023f7:	e9 fa f9 ff ff       	jmp    101df6 <__alltraps>

001023fc <vector159>:
.globl vector159
vector159:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $159
  1023fe:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102403:	e9 ee f9 ff ff       	jmp    101df6 <__alltraps>

00102408 <vector160>:
.globl vector160
vector160:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $160
  10240a:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10240f:	e9 e2 f9 ff ff       	jmp    101df6 <__alltraps>

00102414 <vector161>:
.globl vector161
vector161:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $161
  102416:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10241b:	e9 d6 f9 ff ff       	jmp    101df6 <__alltraps>

00102420 <vector162>:
.globl vector162
vector162:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $162
  102422:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102427:	e9 ca f9 ff ff       	jmp    101df6 <__alltraps>

0010242c <vector163>:
.globl vector163
vector163:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $163
  10242e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102433:	e9 be f9 ff ff       	jmp    101df6 <__alltraps>

00102438 <vector164>:
.globl vector164
vector164:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $164
  10243a:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10243f:	e9 b2 f9 ff ff       	jmp    101df6 <__alltraps>

00102444 <vector165>:
.globl vector165
vector165:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $165
  102446:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10244b:	e9 a6 f9 ff ff       	jmp    101df6 <__alltraps>

00102450 <vector166>:
.globl vector166
vector166:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $166
  102452:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102457:	e9 9a f9 ff ff       	jmp    101df6 <__alltraps>

0010245c <vector167>:
.globl vector167
vector167:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $167
  10245e:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102463:	e9 8e f9 ff ff       	jmp    101df6 <__alltraps>

00102468 <vector168>:
.globl vector168
vector168:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $168
  10246a:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10246f:	e9 82 f9 ff ff       	jmp    101df6 <__alltraps>

00102474 <vector169>:
.globl vector169
vector169:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $169
  102476:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10247b:	e9 76 f9 ff ff       	jmp    101df6 <__alltraps>

00102480 <vector170>:
.globl vector170
vector170:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $170
  102482:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102487:	e9 6a f9 ff ff       	jmp    101df6 <__alltraps>

0010248c <vector171>:
.globl vector171
vector171:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $171
  10248e:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102493:	e9 5e f9 ff ff       	jmp    101df6 <__alltraps>

00102498 <vector172>:
.globl vector172
vector172:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $172
  10249a:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10249f:	e9 52 f9 ff ff       	jmp    101df6 <__alltraps>

001024a4 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $173
  1024a6:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024ab:	e9 46 f9 ff ff       	jmp    101df6 <__alltraps>

001024b0 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $174
  1024b2:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024b7:	e9 3a f9 ff ff       	jmp    101df6 <__alltraps>

001024bc <vector175>:
.globl vector175
vector175:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $175
  1024be:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024c3:	e9 2e f9 ff ff       	jmp    101df6 <__alltraps>

001024c8 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $176
  1024ca:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024cf:	e9 22 f9 ff ff       	jmp    101df6 <__alltraps>

001024d4 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $177
  1024d6:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024db:	e9 16 f9 ff ff       	jmp    101df6 <__alltraps>

001024e0 <vector178>:
.globl vector178
vector178:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $178
  1024e2:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024e7:	e9 0a f9 ff ff       	jmp    101df6 <__alltraps>

001024ec <vector179>:
.globl vector179
vector179:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $179
  1024ee:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024f3:	e9 fe f8 ff ff       	jmp    101df6 <__alltraps>

001024f8 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $180
  1024fa:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024ff:	e9 f2 f8 ff ff       	jmp    101df6 <__alltraps>

00102504 <vector181>:
.globl vector181
vector181:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $181
  102506:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10250b:	e9 e6 f8 ff ff       	jmp    101df6 <__alltraps>

00102510 <vector182>:
.globl vector182
vector182:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $182
  102512:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102517:	e9 da f8 ff ff       	jmp    101df6 <__alltraps>

0010251c <vector183>:
.globl vector183
vector183:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $183
  10251e:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102523:	e9 ce f8 ff ff       	jmp    101df6 <__alltraps>

00102528 <vector184>:
.globl vector184
vector184:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $184
  10252a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10252f:	e9 c2 f8 ff ff       	jmp    101df6 <__alltraps>

00102534 <vector185>:
.globl vector185
vector185:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $185
  102536:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10253b:	e9 b6 f8 ff ff       	jmp    101df6 <__alltraps>

00102540 <vector186>:
.globl vector186
vector186:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $186
  102542:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102547:	e9 aa f8 ff ff       	jmp    101df6 <__alltraps>

0010254c <vector187>:
.globl vector187
vector187:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $187
  10254e:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102553:	e9 9e f8 ff ff       	jmp    101df6 <__alltraps>

00102558 <vector188>:
.globl vector188
vector188:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $188
  10255a:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10255f:	e9 92 f8 ff ff       	jmp    101df6 <__alltraps>

00102564 <vector189>:
.globl vector189
vector189:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $189
  102566:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10256b:	e9 86 f8 ff ff       	jmp    101df6 <__alltraps>

00102570 <vector190>:
.globl vector190
vector190:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $190
  102572:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102577:	e9 7a f8 ff ff       	jmp    101df6 <__alltraps>

0010257c <vector191>:
.globl vector191
vector191:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $191
  10257e:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102583:	e9 6e f8 ff ff       	jmp    101df6 <__alltraps>

00102588 <vector192>:
.globl vector192
vector192:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $192
  10258a:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10258f:	e9 62 f8 ff ff       	jmp    101df6 <__alltraps>

00102594 <vector193>:
.globl vector193
vector193:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $193
  102596:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10259b:	e9 56 f8 ff ff       	jmp    101df6 <__alltraps>

001025a0 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $194
  1025a2:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025a7:	e9 4a f8 ff ff       	jmp    101df6 <__alltraps>

001025ac <vector195>:
.globl vector195
vector195:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $195
  1025ae:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025b3:	e9 3e f8 ff ff       	jmp    101df6 <__alltraps>

001025b8 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $196
  1025ba:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025bf:	e9 32 f8 ff ff       	jmp    101df6 <__alltraps>

001025c4 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $197
  1025c6:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025cb:	e9 26 f8 ff ff       	jmp    101df6 <__alltraps>

001025d0 <vector198>:
.globl vector198
vector198:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $198
  1025d2:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025d7:	e9 1a f8 ff ff       	jmp    101df6 <__alltraps>

001025dc <vector199>:
.globl vector199
vector199:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $199
  1025de:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025e3:	e9 0e f8 ff ff       	jmp    101df6 <__alltraps>

001025e8 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $200
  1025ea:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025ef:	e9 02 f8 ff ff       	jmp    101df6 <__alltraps>

001025f4 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $201
  1025f6:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025fb:	e9 f6 f7 ff ff       	jmp    101df6 <__alltraps>

00102600 <vector202>:
.globl vector202
vector202:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $202
  102602:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102607:	e9 ea f7 ff ff       	jmp    101df6 <__alltraps>

0010260c <vector203>:
.globl vector203
vector203:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $203
  10260e:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102613:	e9 de f7 ff ff       	jmp    101df6 <__alltraps>

00102618 <vector204>:
.globl vector204
vector204:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $204
  10261a:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10261f:	e9 d2 f7 ff ff       	jmp    101df6 <__alltraps>

00102624 <vector205>:
.globl vector205
vector205:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $205
  102626:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10262b:	e9 c6 f7 ff ff       	jmp    101df6 <__alltraps>

00102630 <vector206>:
.globl vector206
vector206:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $206
  102632:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102637:	e9 ba f7 ff ff       	jmp    101df6 <__alltraps>

0010263c <vector207>:
.globl vector207
vector207:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $207
  10263e:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102643:	e9 ae f7 ff ff       	jmp    101df6 <__alltraps>

00102648 <vector208>:
.globl vector208
vector208:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $208
  10264a:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10264f:	e9 a2 f7 ff ff       	jmp    101df6 <__alltraps>

00102654 <vector209>:
.globl vector209
vector209:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $209
  102656:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10265b:	e9 96 f7 ff ff       	jmp    101df6 <__alltraps>

00102660 <vector210>:
.globl vector210
vector210:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $210
  102662:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102667:	e9 8a f7 ff ff       	jmp    101df6 <__alltraps>

0010266c <vector211>:
.globl vector211
vector211:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $211
  10266e:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102673:	e9 7e f7 ff ff       	jmp    101df6 <__alltraps>

00102678 <vector212>:
.globl vector212
vector212:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $212
  10267a:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10267f:	e9 72 f7 ff ff       	jmp    101df6 <__alltraps>

00102684 <vector213>:
.globl vector213
vector213:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $213
  102686:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10268b:	e9 66 f7 ff ff       	jmp    101df6 <__alltraps>

00102690 <vector214>:
.globl vector214
vector214:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $214
  102692:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102697:	e9 5a f7 ff ff       	jmp    101df6 <__alltraps>

0010269c <vector215>:
.globl vector215
vector215:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $215
  10269e:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026a3:	e9 4e f7 ff ff       	jmp    101df6 <__alltraps>

001026a8 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $216
  1026aa:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026af:	e9 42 f7 ff ff       	jmp    101df6 <__alltraps>

001026b4 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $217
  1026b6:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026bb:	e9 36 f7 ff ff       	jmp    101df6 <__alltraps>

001026c0 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $218
  1026c2:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026c7:	e9 2a f7 ff ff       	jmp    101df6 <__alltraps>

001026cc <vector219>:
.globl vector219
vector219:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $219
  1026ce:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026d3:	e9 1e f7 ff ff       	jmp    101df6 <__alltraps>

001026d8 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $220
  1026da:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026df:	e9 12 f7 ff ff       	jmp    101df6 <__alltraps>

001026e4 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $221
  1026e6:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026eb:	e9 06 f7 ff ff       	jmp    101df6 <__alltraps>

001026f0 <vector222>:
.globl vector222
vector222:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $222
  1026f2:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026f7:	e9 fa f6 ff ff       	jmp    101df6 <__alltraps>

001026fc <vector223>:
.globl vector223
vector223:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $223
  1026fe:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102703:	e9 ee f6 ff ff       	jmp    101df6 <__alltraps>

00102708 <vector224>:
.globl vector224
vector224:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $224
  10270a:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10270f:	e9 e2 f6 ff ff       	jmp    101df6 <__alltraps>

00102714 <vector225>:
.globl vector225
vector225:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $225
  102716:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10271b:	e9 d6 f6 ff ff       	jmp    101df6 <__alltraps>

00102720 <vector226>:
.globl vector226
vector226:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $226
  102722:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102727:	e9 ca f6 ff ff       	jmp    101df6 <__alltraps>

0010272c <vector227>:
.globl vector227
vector227:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $227
  10272e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102733:	e9 be f6 ff ff       	jmp    101df6 <__alltraps>

00102738 <vector228>:
.globl vector228
vector228:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $228
  10273a:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10273f:	e9 b2 f6 ff ff       	jmp    101df6 <__alltraps>

00102744 <vector229>:
.globl vector229
vector229:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $229
  102746:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10274b:	e9 a6 f6 ff ff       	jmp    101df6 <__alltraps>

00102750 <vector230>:
.globl vector230
vector230:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $230
  102752:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102757:	e9 9a f6 ff ff       	jmp    101df6 <__alltraps>

0010275c <vector231>:
.globl vector231
vector231:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $231
  10275e:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102763:	e9 8e f6 ff ff       	jmp    101df6 <__alltraps>

00102768 <vector232>:
.globl vector232
vector232:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $232
  10276a:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10276f:	e9 82 f6 ff ff       	jmp    101df6 <__alltraps>

00102774 <vector233>:
.globl vector233
vector233:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $233
  102776:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10277b:	e9 76 f6 ff ff       	jmp    101df6 <__alltraps>

00102780 <vector234>:
.globl vector234
vector234:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $234
  102782:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102787:	e9 6a f6 ff ff       	jmp    101df6 <__alltraps>

0010278c <vector235>:
.globl vector235
vector235:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $235
  10278e:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102793:	e9 5e f6 ff ff       	jmp    101df6 <__alltraps>

00102798 <vector236>:
.globl vector236
vector236:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $236
  10279a:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10279f:	e9 52 f6 ff ff       	jmp    101df6 <__alltraps>

001027a4 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $237
  1027a6:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027ab:	e9 46 f6 ff ff       	jmp    101df6 <__alltraps>

001027b0 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $238
  1027b2:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027b7:	e9 3a f6 ff ff       	jmp    101df6 <__alltraps>

001027bc <vector239>:
.globl vector239
vector239:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $239
  1027be:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027c3:	e9 2e f6 ff ff       	jmp    101df6 <__alltraps>

001027c8 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $240
  1027ca:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027cf:	e9 22 f6 ff ff       	jmp    101df6 <__alltraps>

001027d4 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $241
  1027d6:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027db:	e9 16 f6 ff ff       	jmp    101df6 <__alltraps>

001027e0 <vector242>:
.globl vector242
vector242:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $242
  1027e2:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027e7:	e9 0a f6 ff ff       	jmp    101df6 <__alltraps>

001027ec <vector243>:
.globl vector243
vector243:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $243
  1027ee:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027f3:	e9 fe f5 ff ff       	jmp    101df6 <__alltraps>

001027f8 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $244
  1027fa:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027ff:	e9 f2 f5 ff ff       	jmp    101df6 <__alltraps>

00102804 <vector245>:
.globl vector245
vector245:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $245
  102806:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10280b:	e9 e6 f5 ff ff       	jmp    101df6 <__alltraps>

00102810 <vector246>:
.globl vector246
vector246:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $246
  102812:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102817:	e9 da f5 ff ff       	jmp    101df6 <__alltraps>

0010281c <vector247>:
.globl vector247
vector247:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $247
  10281e:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102823:	e9 ce f5 ff ff       	jmp    101df6 <__alltraps>

00102828 <vector248>:
.globl vector248
vector248:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $248
  10282a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10282f:	e9 c2 f5 ff ff       	jmp    101df6 <__alltraps>

00102834 <vector249>:
.globl vector249
vector249:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $249
  102836:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10283b:	e9 b6 f5 ff ff       	jmp    101df6 <__alltraps>

00102840 <vector250>:
.globl vector250
vector250:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $250
  102842:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102847:	e9 aa f5 ff ff       	jmp    101df6 <__alltraps>

0010284c <vector251>:
.globl vector251
vector251:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $251
  10284e:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102853:	e9 9e f5 ff ff       	jmp    101df6 <__alltraps>

00102858 <vector252>:
.globl vector252
vector252:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $252
  10285a:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10285f:	e9 92 f5 ff ff       	jmp    101df6 <__alltraps>

00102864 <vector253>:
.globl vector253
vector253:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $253
  102866:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10286b:	e9 86 f5 ff ff       	jmp    101df6 <__alltraps>

00102870 <vector254>:
.globl vector254
vector254:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $254
  102872:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102877:	e9 7a f5 ff ff       	jmp    101df6 <__alltraps>

0010287c <vector255>:
.globl vector255
vector255:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $255
  10287e:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102883:	e9 6e f5 ff ff       	jmp    101df6 <__alltraps>

00102888 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102888:	55                   	push   %ebp
  102889:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10288b:	8b 55 08             	mov    0x8(%ebp),%edx
  10288e:	a1 64 89 11 00       	mov    0x118964,%eax
  102893:	29 c2                	sub    %eax,%edx
  102895:	89 d0                	mov    %edx,%eax
  102897:	c1 f8 02             	sar    $0x2,%eax
  10289a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028a0:	5d                   	pop    %ebp
  1028a1:	c3                   	ret    

001028a2 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028a2:	55                   	push   %ebp
  1028a3:	89 e5                	mov    %esp,%ebp
  1028a5:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ab:	89 04 24             	mov    %eax,(%esp)
  1028ae:	e8 d5 ff ff ff       	call   102888 <page2ppn>
  1028b3:	c1 e0 0c             	shl    $0xc,%eax
}
  1028b6:	c9                   	leave  
  1028b7:	c3                   	ret    

001028b8 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028b8:	55                   	push   %ebp
  1028b9:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1028be:	8b 00                	mov    (%eax),%eax
}
  1028c0:	5d                   	pop    %ebp
  1028c1:	c3                   	ret    

001028c2 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1028c2:	55                   	push   %ebp
  1028c3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1028c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028cb:	89 10                	mov    %edx,(%eax)
}
  1028cd:	5d                   	pop    %ebp
  1028ce:	c3                   	ret    

001028cf <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1028cf:	55                   	push   %ebp
  1028d0:	89 e5                	mov    %esp,%ebp
  1028d2:	83 ec 10             	sub    $0x10,%esp
  1028d5:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1028dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1028e2:	89 50 04             	mov    %edx,0x4(%eax)
  1028e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028e8:	8b 50 04             	mov    0x4(%eax),%edx
  1028eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028ee:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1028f0:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1028f7:	00 00 00 
}
  1028fa:	c9                   	leave  
  1028fb:	c3                   	ret    

001028fc <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1028fc:	55                   	push   %ebp
  1028fd:	89 e5                	mov    %esp,%ebp
  1028ff:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102902:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102906:	75 24                	jne    10292c <default_init_memmap+0x30>
  102908:	c7 44 24 0c f0 66 10 	movl   $0x1066f0,0xc(%esp)
  10290f:	00 
  102910:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102917:	00 
  102918:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  10291f:	00 
  102920:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102927:	e8 a1 e3 ff ff       	call   100ccd <__panic>
    struct Page *p = base;
  10292c:	8b 45 08             	mov    0x8(%ebp),%eax
  10292f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102932:	eb 7d                	jmp    1029b1 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  102934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102937:	83 c0 04             	add    $0x4,%eax
  10293a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102941:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102947:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10294a:	0f a3 10             	bt     %edx,(%eax)
  10294d:	19 c0                	sbb    %eax,%eax
  10294f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102952:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102956:	0f 95 c0             	setne  %al
  102959:	0f b6 c0             	movzbl %al,%eax
  10295c:	85 c0                	test   %eax,%eax
  10295e:	75 24                	jne    102984 <default_init_memmap+0x88>
  102960:	c7 44 24 0c 21 67 10 	movl   $0x106721,0xc(%esp)
  102967:	00 
  102968:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10296f:	00 
  102970:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102977:	00 
  102978:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10297f:	e8 49 e3 ff ff       	call   100ccd <__panic>
        p->flags = p->property = 0;
  102984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102987:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102991:	8b 50 08             	mov    0x8(%eax),%edx
  102994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102997:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10299a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029a1:	00 
  1029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029a5:	89 04 24             	mov    %eax,(%esp)
  1029a8:	e8 15 ff ff ff       	call   1028c2 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1029ad:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1029b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029b4:	89 d0                	mov    %edx,%eax
  1029b6:	c1 e0 02             	shl    $0x2,%eax
  1029b9:	01 d0                	add    %edx,%eax
  1029bb:	c1 e0 02             	shl    $0x2,%eax
  1029be:	89 c2                	mov    %eax,%edx
  1029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c3:	01 d0                	add    %edx,%eax
  1029c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1029c8:	0f 85 66 ff ff ff    	jne    102934 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  1029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029d4:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029da:	83 c0 04             	add    $0x4,%eax
  1029dd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029ed:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  1029f0:	8b 15 58 89 11 00    	mov    0x118958,%edx
  1029f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029f9:	01 d0                	add    %edx,%eax
  1029fb:	a3 58 89 11 00       	mov    %eax,0x118958
    list_add(&free_list, &(base->page_link));
  102a00:	8b 45 08             	mov    0x8(%ebp),%eax
  102a03:	83 c0 0c             	add    $0xc,%eax
  102a06:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  102a0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a13:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102a16:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a19:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102a1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a1f:	8b 40 04             	mov    0x4(%eax),%eax
  102a22:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a25:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102a28:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a2b:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102a2e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a34:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a37:	89 10                	mov    %edx,(%eax)
  102a39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a3c:	8b 10                	mov    (%eax),%edx
  102a3e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102a41:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a44:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a47:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102a4a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a50:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102a53:	89 10                	mov    %edx,(%eax)
}
  102a55:	c9                   	leave  
  102a56:	c3                   	ret    

00102a57 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a57:	55                   	push   %ebp
  102a58:	89 e5                	mov    %esp,%ebp
  102a5a:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102a5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a61:	75 24                	jne    102a87 <default_alloc_pages+0x30>
  102a63:	c7 44 24 0c f0 66 10 	movl   $0x1066f0,0xc(%esp)
  102a6a:	00 
  102a6b:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102a72:	00 
  102a73:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  102a7a:	00 
  102a7b:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102a82:	e8 46 e2 ff ff       	call   100ccd <__panic>
    if (n > nr_free) {
  102a87:	a1 58 89 11 00       	mov    0x118958,%eax
  102a8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a8f:	73 0a                	jae    102a9b <default_alloc_pages+0x44>
        return NULL;
  102a91:	b8 00 00 00 00       	mov    $0x0,%eax
  102a96:	e9 42 01 00 00       	jmp    102bdd <default_alloc_pages+0x186>
    }
    struct Page* page = NULL;
  102a9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t* le = &free_list;
  102aa2:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102aa9:	eb 1c                	jmp    102ac7 <default_alloc_pages+0x70>
        struct Page* p = le2page(le, page_link);
  102aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aae:	83 e8 0c             	sub    $0xc,%eax
  102ab1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ab7:	8b 40 08             	mov    0x8(%eax),%eax
  102aba:	3b 45 08             	cmp    0x8(%ebp),%eax
  102abd:	72 08                	jb     102ac7 <default_alloc_pages+0x70>
            page = p;
  102abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102ac5:	eb 18                	jmp    102adf <default_alloc_pages+0x88>
  102ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102acd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ad0:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page* page = NULL;
    list_entry_t* le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ad6:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102add:	75 cc                	jne    102aab <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL)	{
  102adf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102ae3:	0f 84 f1 00 00 00    	je     102bda <default_alloc_pages+0x183>
    	if (page->property > n)	{
  102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aec:	8b 40 08             	mov    0x8(%eax),%eax
  102aef:	3b 45 08             	cmp    0x8(%ebp),%eax
  102af2:	0f 86 88 00 00 00    	jbe    102b80 <default_alloc_pages+0x129>
            struct Page* p = page + n;
  102af8:	8b 55 08             	mov    0x8(%ebp),%edx
  102afb:	89 d0                	mov    %edx,%eax
  102afd:	c1 e0 02             	shl    $0x2,%eax
  102b00:	01 d0                	add    %edx,%eax
  102b02:	c1 e0 02             	shl    $0x2,%eax
  102b05:	89 c2                	mov    %eax,%edx
  102b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b0a:	01 d0                	add    %edx,%eax
  102b0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b12:	8b 40 08             	mov    0x8(%eax),%eax
  102b15:	2b 45 08             	sub    0x8(%ebp),%eax
  102b18:	89 c2                	mov    %eax,%edx
  102b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b1d:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  102b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b23:	83 c0 04             	add    $0x4,%eax
  102b26:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102b2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102b30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102b36:	0f ab 10             	bts    %edx,(%eax)
            list_add_before(le, &(p->page_link));
  102b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b3c:	8d 50 0c             	lea    0xc(%eax),%edx
  102b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b42:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102b45:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b4b:	8b 00                	mov    (%eax),%eax
  102b4d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b50:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102b53:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102b56:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b59:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b5f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b62:	89 10                	mov    %edx,(%eax)
  102b64:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b67:	8b 10                	mov    (%eax),%edx
  102b69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b6c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b72:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b75:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b78:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b7b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b7e:	89 10                	mov    %edx,(%eax)
    	}
    	list_del(&(page->page_link));
  102b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b83:	83 c0 0c             	add    $0xc,%eax
  102b86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b8c:	8b 40 04             	mov    0x4(%eax),%eax
  102b8f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b92:	8b 12                	mov    (%edx),%edx
  102b94:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102b97:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b9a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b9d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102ba0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102ba3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ba6:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102ba9:	89 10                	mov    %edx,(%eax)
    	page->property= n;
  102bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bae:	8b 55 08             	mov    0x8(%ebp),%edx
  102bb1:	89 50 08             	mov    %edx,0x8(%eax)
        nr_free -= n;
  102bb4:	a1 58 89 11 00       	mov    0x118958,%eax
  102bb9:	2b 45 08             	sub    0x8(%ebp),%eax
  102bbc:	a3 58 89 11 00       	mov    %eax,0x118958
        ClearPageProperty(page);
  102bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bc4:	83 c0 04             	add    $0x4,%eax
  102bc7:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102bce:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bd1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bd4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102bd7:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102bdd:	c9                   	leave  
  102bde:	c3                   	ret    

00102bdf <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102bdf:	55                   	push   %ebp
  102be0:	89 e5                	mov    %esp,%ebp
  102be2:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bec:	75 24                	jne    102c12 <default_free_pages+0x33>
  102bee:	c7 44 24 0c f0 66 10 	movl   $0x1066f0,0xc(%esp)
  102bf5:	00 
  102bf6:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102bfd:	00 
  102bfe:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
  102c05:	00 
  102c06:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102c0d:	e8 bb e0 ff ff       	call   100ccd <__panic>
    struct Page* p = base;
  102c12:	8b 45 08             	mov    0x8(%ebp),%eax
  102c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102c18:	e9 9d 00 00 00       	jmp    102cba <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c20:	83 c0 04             	add    $0x4,%eax
  102c23:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  102c2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102c33:	0f a3 10             	bt     %edx,(%eax)
  102c36:	19 c0                	sbb    %eax,%eax
  102c38:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  102c3b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  102c3f:	0f 95 c0             	setne  %al
  102c42:	0f b6 c0             	movzbl %al,%eax
  102c45:	85 c0                	test   %eax,%eax
  102c47:	75 2c                	jne    102c75 <default_free_pages+0x96>
  102c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c4c:	83 c0 04             	add    $0x4,%eax
  102c4f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102c56:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c5f:	0f a3 10             	bt     %edx,(%eax)
  102c62:	19 c0                	sbb    %eax,%eax
  102c64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  102c67:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  102c6b:	0f 95 c0             	setne  %al
  102c6e:	0f b6 c0             	movzbl %al,%eax
  102c71:	85 c0                	test   %eax,%eax
  102c73:	74 24                	je     102c99 <default_free_pages+0xba>
  102c75:	c7 44 24 0c 34 67 10 	movl   $0x106734,0xc(%esp)
  102c7c:	00 
  102c7d:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102c84:	00 
  102c85:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  102c8c:	00 
  102c8d:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102c94:	e8 34 e0 ff ff       	call   100ccd <__panic>
        p->flags = 0;
  102c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102ca3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102caa:	00 
  102cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cae:	89 04 24             	mov    %eax,(%esp)
  102cb1:	e8 0c fc ff ff       	call   1028c2 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page* p = base;
    for (; p != base + n; p ++) {
  102cb6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cbd:	89 d0                	mov    %edx,%eax
  102cbf:	c1 e0 02             	shl    $0x2,%eax
  102cc2:	01 d0                	add    %edx,%eax
  102cc4:	c1 e0 02             	shl    $0x2,%eax
  102cc7:	89 c2                	mov    %eax,%edx
  102cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  102ccc:	01 d0                	add    %edx,%eax
  102cce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cd1:	0f 85 46 ff ff ff    	jne    102c1d <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property= n;
  102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cdd:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce3:	83 c0 04             	add    $0x4,%eax
  102ce6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102ced:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cf0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cf3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102cf6:	0f ab 10             	bts    %edx,(%eax)
  102cf9:	c7 45 c8 50 89 11 00 	movl   $0x118950,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102d00:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d03:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t* le = list_next(&free_list);
  102d06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list)	{
  102d09:	eb 22                	jmp    102d2d <default_free_pages+0x14e>
    	p = le2page(le, page_link);
  102d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d0e:	83 e8 0c             	sub    $0xc,%eax
  102d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if (p > base)
  102d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d17:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d1a:	76 02                	jbe    102d1e <default_free_pages+0x13f>
    		break ;
  102d1c:	eb 18                	jmp    102d36 <default_free_pages+0x157>
  102d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d21:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  102d24:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d27:	8b 40 04             	mov    0x4(%eax),%eax
    	le = list_next(le);
  102d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        set_page_ref(p, 0);
    }
    base->property= n;
    SetPageProperty(base);
    list_entry_t* le = list_next(&free_list);
    while (le != &free_list)	{
  102d2d:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102d34:	75 d5                	jne    102d0b <default_free_pages+0x12c>
    	if (p > base)
    		break ;
    	le = list_next(le);
    }

    p = le2page(le, page_link);
  102d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d39:	83 e8 0c             	sub    $0xc,%eax
  102d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	list_add_before(le, &(base->page_link));
  102d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d42:	8d 50 0c             	lea    0xc(%eax),%edx
  102d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d48:	89 45 c0             	mov    %eax,-0x40(%ebp)
  102d4b:	89 55 bc             	mov    %edx,-0x44(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102d4e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d51:	8b 00                	mov    (%eax),%eax
  102d53:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d56:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102d59:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102d5c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d5f:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102d62:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102d65:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102d68:	89 10                	mov    %edx,(%eax)
  102d6a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102d6d:	8b 10                	mov    (%eax),%edx
  102d6f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d72:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102d75:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d78:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102d7b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102d7e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d81:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d84:	89 10                	mov    %edx,(%eax)
	le = list_prev(&(base->page_link));
  102d86:	8b 45 08             	mov    0x8(%ebp),%eax
  102d89:	83 c0 0c             	add    $0xc,%eax
  102d8c:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102d8f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102d92:	8b 00                	mov    (%eax),%eax
  102d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct Page* pp = le2page(le, page_link);
  102d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d9a:	83 e8 0c             	sub    $0xc,%eax
  102d9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (base + base->property == p) {
  102da0:	8b 45 08             	mov    0x8(%ebp),%eax
  102da3:	8b 50 08             	mov    0x8(%eax),%edx
  102da6:	89 d0                	mov    %edx,%eax
  102da8:	c1 e0 02             	shl    $0x2,%eax
  102dab:	01 d0                	add    %edx,%eax
  102dad:	c1 e0 02             	shl    $0x2,%eax
  102db0:	89 c2                	mov    %eax,%edx
  102db2:	8b 45 08             	mov    0x8(%ebp),%eax
  102db5:	01 d0                	add    %edx,%eax
  102db7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102dba:	75 58                	jne    102e14 <default_free_pages+0x235>
		base->property += p->property;
  102dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbf:	8b 50 08             	mov    0x8(%eax),%edx
  102dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc5:	8b 40 08             	mov    0x8(%eax),%eax
  102dc8:	01 c2                	add    %eax,%edx
  102dca:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcd:	89 50 08             	mov    %edx,0x8(%eax)
		ClearPageProperty(p);
  102dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dd3:	83 c0 04             	add    $0x4,%eax
  102dd6:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  102ddd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102de0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102de3:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102de6:	0f b3 10             	btr    %edx,(%eax)
		list_del(&(p->page_link));
  102de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dec:	83 c0 0c             	add    $0xc,%eax
  102def:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102df2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102df5:	8b 40 04             	mov    0x4(%eax),%eax
  102df8:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102dfb:	8b 12                	mov    (%edx),%edx
  102dfd:	89 55 9c             	mov    %edx,-0x64(%ebp)
  102e00:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e03:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102e06:	8b 55 98             	mov    -0x68(%ebp),%edx
  102e09:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e0c:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e0f:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102e12:	89 10                	mov    %edx,(%eax)
	}
	if (pp + pp->property == base) {
  102e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e17:	8b 50 08             	mov    0x8(%eax),%edx
  102e1a:	89 d0                	mov    %edx,%eax
  102e1c:	c1 e0 02             	shl    $0x2,%eax
  102e1f:	01 d0                	add    %edx,%eax
  102e21:	c1 e0 02             	shl    $0x2,%eax
  102e24:	89 c2                	mov    %eax,%edx
  102e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e29:	01 d0                	add    %edx,%eax
  102e2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  102e2e:	75 58                	jne    102e88 <default_free_pages+0x2a9>
		pp->property += base->property;
  102e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e33:	8b 50 08             	mov    0x8(%eax),%edx
  102e36:	8b 45 08             	mov    0x8(%ebp),%eax
  102e39:	8b 40 08             	mov    0x8(%eax),%eax
  102e3c:	01 c2                	add    %eax,%edx
  102e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e41:	89 50 08             	mov    %edx,0x8(%eax)
		ClearPageProperty(base);
  102e44:	8b 45 08             	mov    0x8(%ebp),%eax
  102e47:	83 c0 04             	add    $0x4,%eax
  102e4a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  102e51:	89 45 90             	mov    %eax,-0x70(%ebp)
  102e54:	8b 45 90             	mov    -0x70(%ebp),%eax
  102e57:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102e5a:	0f b3 10             	btr    %edx,(%eax)
		list_del(&(base->page_link));
  102e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e60:	83 c0 0c             	add    $0xc,%eax
  102e63:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102e66:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e69:	8b 40 04             	mov    0x4(%eax),%eax
  102e6c:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102e6f:	8b 12                	mov    (%edx),%edx
  102e71:	89 55 88             	mov    %edx,-0x78(%ebp)
  102e74:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e77:	8b 45 88             	mov    -0x78(%ebp),%eax
  102e7a:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102e7d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e80:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102e83:	8b 55 88             	mov    -0x78(%ebp),%edx
  102e86:	89 10                	mov    %edx,(%eax)
	}

	nr_free += n;
  102e88:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e91:	01 d0                	add    %edx,%eax
  102e93:	a3 58 89 11 00       	mov    %eax,0x118958
}
  102e98:	c9                   	leave  
  102e99:	c3                   	ret    

00102e9a <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e9a:	55                   	push   %ebp
  102e9b:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e9d:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102ea2:	5d                   	pop    %ebp
  102ea3:	c3                   	ret    

00102ea4 <basic_check>:

static void
basic_check(void) {
  102ea4:	55                   	push   %ebp
  102ea5:	89 e5                	mov    %esp,%ebp
  102ea7:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102ebd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ec4:	e8 85 0e 00 00       	call   103d4e <alloc_pages>
  102ec9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ecc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102ed0:	75 24                	jne    102ef6 <basic_check+0x52>
  102ed2:	c7 44 24 0c 59 67 10 	movl   $0x106759,0xc(%esp)
  102ed9:	00 
  102eda:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102ee1:	00 
  102ee2:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  102ee9:	00 
  102eea:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102ef1:	e8 d7 dd ff ff       	call   100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
  102ef6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102efd:	e8 4c 0e 00 00       	call   103d4e <alloc_pages>
  102f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f09:	75 24                	jne    102f2f <basic_check+0x8b>
  102f0b:	c7 44 24 0c 75 67 10 	movl   $0x106775,0xc(%esp)
  102f12:	00 
  102f13:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102f1a:	00 
  102f1b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  102f22:	00 
  102f23:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102f2a:	e8 9e dd ff ff       	call   100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
  102f2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f36:	e8 13 0e 00 00       	call   103d4e <alloc_pages>
  102f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102f42:	75 24                	jne    102f68 <basic_check+0xc4>
  102f44:	c7 44 24 0c 91 67 10 	movl   $0x106791,0xc(%esp)
  102f4b:	00 
  102f4c:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102f53:	00 
  102f54:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  102f5b:	00 
  102f5c:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102f63:	e8 65 dd ff ff       	call   100ccd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102f6e:	74 10                	je     102f80 <basic_check+0xdc>
  102f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f73:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f76:	74 08                	je     102f80 <basic_check+0xdc>
  102f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f7b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f7e:	75 24                	jne    102fa4 <basic_check+0x100>
  102f80:	c7 44 24 0c b0 67 10 	movl   $0x1067b0,0xc(%esp)
  102f87:	00 
  102f88:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102f8f:	00 
  102f90:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  102f97:	00 
  102f98:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102f9f:	e8 29 dd ff ff       	call   100ccd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fa7:	89 04 24             	mov    %eax,(%esp)
  102faa:	e8 09 f9 ff ff       	call   1028b8 <page_ref>
  102faf:	85 c0                	test   %eax,%eax
  102fb1:	75 1e                	jne    102fd1 <basic_check+0x12d>
  102fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb6:	89 04 24             	mov    %eax,(%esp)
  102fb9:	e8 fa f8 ff ff       	call   1028b8 <page_ref>
  102fbe:	85 c0                	test   %eax,%eax
  102fc0:	75 0f                	jne    102fd1 <basic_check+0x12d>
  102fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fc5:	89 04 24             	mov    %eax,(%esp)
  102fc8:	e8 eb f8 ff ff       	call   1028b8 <page_ref>
  102fcd:	85 c0                	test   %eax,%eax
  102fcf:	74 24                	je     102ff5 <basic_check+0x151>
  102fd1:	c7 44 24 0c d4 67 10 	movl   $0x1067d4,0xc(%esp)
  102fd8:	00 
  102fd9:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102fe0:	00 
  102fe1:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  102fe8:	00 
  102fe9:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102ff0:	e8 d8 dc ff ff       	call   100ccd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff8:	89 04 24             	mov    %eax,(%esp)
  102ffb:	e8 a2 f8 ff ff       	call   1028a2 <page2pa>
  103000:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103006:	c1 e2 0c             	shl    $0xc,%edx
  103009:	39 d0                	cmp    %edx,%eax
  10300b:	72 24                	jb     103031 <basic_check+0x18d>
  10300d:	c7 44 24 0c 10 68 10 	movl   $0x106810,0xc(%esp)
  103014:	00 
  103015:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10301c:	00 
  10301d:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
  103024:	00 
  103025:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10302c:	e8 9c dc ff ff       	call   100ccd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  103031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103034:	89 04 24             	mov    %eax,(%esp)
  103037:	e8 66 f8 ff ff       	call   1028a2 <page2pa>
  10303c:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103042:	c1 e2 0c             	shl    $0xc,%edx
  103045:	39 d0                	cmp    %edx,%eax
  103047:	72 24                	jb     10306d <basic_check+0x1c9>
  103049:	c7 44 24 0c 2d 68 10 	movl   $0x10682d,0xc(%esp)
  103050:	00 
  103051:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103058:	00 
  103059:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  103060:	00 
  103061:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103068:	e8 60 dc ff ff       	call   100ccd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103070:	89 04 24             	mov    %eax,(%esp)
  103073:	e8 2a f8 ff ff       	call   1028a2 <page2pa>
  103078:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  10307e:	c1 e2 0c             	shl    $0xc,%edx
  103081:	39 d0                	cmp    %edx,%eax
  103083:	72 24                	jb     1030a9 <basic_check+0x205>
  103085:	c7 44 24 0c 4a 68 10 	movl   $0x10684a,0xc(%esp)
  10308c:	00 
  10308d:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103094:	00 
  103095:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  10309c:	00 
  10309d:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1030a4:	e8 24 dc ff ff       	call   100ccd <__panic>

    list_entry_t free_list_store = free_list;
  1030a9:	a1 50 89 11 00       	mov    0x118950,%eax
  1030ae:	8b 15 54 89 11 00    	mov    0x118954,%edx
  1030b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030b7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1030ba:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1030c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1030c7:	89 50 04             	mov    %edx,0x4(%eax)
  1030ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030cd:	8b 50 04             	mov    0x4(%eax),%edx
  1030d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030d3:	89 10                	mov    %edx,(%eax)
  1030d5:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1030dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030df:	8b 40 04             	mov    0x4(%eax),%eax
  1030e2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1030e5:	0f 94 c0             	sete   %al
  1030e8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1030eb:	85 c0                	test   %eax,%eax
  1030ed:	75 24                	jne    103113 <basic_check+0x26f>
  1030ef:	c7 44 24 0c 67 68 10 	movl   $0x106867,0xc(%esp)
  1030f6:	00 
  1030f7:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1030fe:	00 
  1030ff:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  103106:	00 
  103107:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10310e:	e8 ba db ff ff       	call   100ccd <__panic>

    unsigned int nr_free_store = nr_free;
  103113:	a1 58 89 11 00       	mov    0x118958,%eax
  103118:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10311b:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103122:	00 00 00 

    assert(alloc_page() == NULL);
  103125:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10312c:	e8 1d 0c 00 00       	call   103d4e <alloc_pages>
  103131:	85 c0                	test   %eax,%eax
  103133:	74 24                	je     103159 <basic_check+0x2b5>
  103135:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  10313c:	00 
  10313d:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103144:	00 
  103145:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  10314c:	00 
  10314d:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103154:	e8 74 db ff ff       	call   100ccd <__panic>

    free_page(p0);
  103159:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103160:	00 
  103161:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103164:	89 04 24             	mov    %eax,(%esp)
  103167:	e8 1a 0c 00 00       	call   103d86 <free_pages>
    free_page(p1);
  10316c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103173:	00 
  103174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103177:	89 04 24             	mov    %eax,(%esp)
  10317a:	e8 07 0c 00 00       	call   103d86 <free_pages>
    free_page(p2);
  10317f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103186:	00 
  103187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10318a:	89 04 24             	mov    %eax,(%esp)
  10318d:	e8 f4 0b 00 00       	call   103d86 <free_pages>
    assert(nr_free == 3);
  103192:	a1 58 89 11 00       	mov    0x118958,%eax
  103197:	83 f8 03             	cmp    $0x3,%eax
  10319a:	74 24                	je     1031c0 <basic_check+0x31c>
  10319c:	c7 44 24 0c 93 68 10 	movl   $0x106893,0xc(%esp)
  1031a3:	00 
  1031a4:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1031ab:	00 
  1031ac:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  1031b3:	00 
  1031b4:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1031bb:	e8 0d db ff ff       	call   100ccd <__panic>

    assert((p0 = alloc_page()) != NULL);
  1031c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031c7:	e8 82 0b 00 00       	call   103d4e <alloc_pages>
  1031cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1031d3:	75 24                	jne    1031f9 <basic_check+0x355>
  1031d5:	c7 44 24 0c 59 67 10 	movl   $0x106759,0xc(%esp)
  1031dc:	00 
  1031dd:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1031e4:	00 
  1031e5:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  1031ec:	00 
  1031ed:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1031f4:	e8 d4 da ff ff       	call   100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
  1031f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103200:	e8 49 0b 00 00       	call   103d4e <alloc_pages>
  103205:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103208:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10320c:	75 24                	jne    103232 <basic_check+0x38e>
  10320e:	c7 44 24 0c 75 67 10 	movl   $0x106775,0xc(%esp)
  103215:	00 
  103216:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10321d:	00 
  10321e:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  103225:	00 
  103226:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10322d:	e8 9b da ff ff       	call   100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
  103232:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103239:	e8 10 0b 00 00       	call   103d4e <alloc_pages>
  10323e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103245:	75 24                	jne    10326b <basic_check+0x3c7>
  103247:	c7 44 24 0c 91 67 10 	movl   $0x106791,0xc(%esp)
  10324e:	00 
  10324f:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103256:	00 
  103257:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  10325e:	00 
  10325f:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103266:	e8 62 da ff ff       	call   100ccd <__panic>

    assert(alloc_page() == NULL);
  10326b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103272:	e8 d7 0a 00 00       	call   103d4e <alloc_pages>
  103277:	85 c0                	test   %eax,%eax
  103279:	74 24                	je     10329f <basic_check+0x3fb>
  10327b:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  103282:	00 
  103283:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10328a:	00 
  10328b:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  103292:	00 
  103293:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10329a:	e8 2e da ff ff       	call   100ccd <__panic>

    free_page(p0);
  10329f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032a6:	00 
  1032a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032aa:	89 04 24             	mov    %eax,(%esp)
  1032ad:	e8 d4 0a 00 00       	call   103d86 <free_pages>
  1032b2:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  1032b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1032bc:	8b 40 04             	mov    0x4(%eax),%eax
  1032bf:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1032c2:	0f 94 c0             	sete   %al
  1032c5:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1032c8:	85 c0                	test   %eax,%eax
  1032ca:	74 24                	je     1032f0 <basic_check+0x44c>
  1032cc:	c7 44 24 0c a0 68 10 	movl   $0x1068a0,0xc(%esp)
  1032d3:	00 
  1032d4:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1032db:	00 
  1032dc:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  1032e3:	00 
  1032e4:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1032eb:	e8 dd d9 ff ff       	call   100ccd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1032f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032f7:	e8 52 0a 00 00       	call   103d4e <alloc_pages>
  1032fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103302:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103305:	74 24                	je     10332b <basic_check+0x487>
  103307:	c7 44 24 0c b8 68 10 	movl   $0x1068b8,0xc(%esp)
  10330e:	00 
  10330f:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103316:	00 
  103317:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  10331e:	00 
  10331f:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103326:	e8 a2 d9 ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  10332b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103332:	e8 17 0a 00 00       	call   103d4e <alloc_pages>
  103337:	85 c0                	test   %eax,%eax
  103339:	74 24                	je     10335f <basic_check+0x4bb>
  10333b:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  103342:	00 
  103343:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10334a:	00 
  10334b:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  103352:	00 
  103353:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10335a:	e8 6e d9 ff ff       	call   100ccd <__panic>

    assert(nr_free == 0);
  10335f:	a1 58 89 11 00       	mov    0x118958,%eax
  103364:	85 c0                	test   %eax,%eax
  103366:	74 24                	je     10338c <basic_check+0x4e8>
  103368:	c7 44 24 0c d1 68 10 	movl   $0x1068d1,0xc(%esp)
  10336f:	00 
  103370:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103377:	00 
  103378:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  10337f:	00 
  103380:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103387:	e8 41 d9 ff ff       	call   100ccd <__panic>
    free_list = free_list_store;
  10338c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10338f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103392:	a3 50 89 11 00       	mov    %eax,0x118950
  103397:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  10339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033a0:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  1033a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033ac:	00 
  1033ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033b0:	89 04 24             	mov    %eax,(%esp)
  1033b3:	e8 ce 09 00 00       	call   103d86 <free_pages>
    free_page(p1);
  1033b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033bf:	00 
  1033c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033c3:	89 04 24             	mov    %eax,(%esp)
  1033c6:	e8 bb 09 00 00       	call   103d86 <free_pages>
    free_page(p2);
  1033cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033d2:	00 
  1033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033d6:	89 04 24             	mov    %eax,(%esp)
  1033d9:	e8 a8 09 00 00       	call   103d86 <free_pages>
}
  1033de:	c9                   	leave  
  1033df:	c3                   	ret    

001033e0 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1033e0:	55                   	push   %ebp
  1033e1:	89 e5                	mov    %esp,%ebp
  1033e3:	53                   	push   %ebx
  1033e4:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1033ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1033f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1033f8:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1033ff:	eb 6b                	jmp    10346c <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103404:	83 e8 0c             	sub    $0xc,%eax
  103407:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10340d:	83 c0 04             	add    $0x4,%eax
  103410:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103417:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10341a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10341d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103420:	0f a3 10             	bt     %edx,(%eax)
  103423:	19 c0                	sbb    %eax,%eax
  103425:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103428:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10342c:	0f 95 c0             	setne  %al
  10342f:	0f b6 c0             	movzbl %al,%eax
  103432:	85 c0                	test   %eax,%eax
  103434:	75 24                	jne    10345a <default_check+0x7a>
  103436:	c7 44 24 0c de 68 10 	movl   $0x1068de,0xc(%esp)
  10343d:	00 
  10343e:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103445:	00 
  103446:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  10344d:	00 
  10344e:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103455:	e8 73 d8 ff ff       	call   100ccd <__panic>
        count ++, total += p->property;
  10345a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10345e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103461:	8b 50 08             	mov    0x8(%eax),%edx
  103464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103467:	01 d0                	add    %edx,%eax
  103469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10346c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10346f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103472:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103475:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103478:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10347b:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103482:	0f 85 79 ff ff ff    	jne    103401 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103488:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10348b:	e8 28 09 00 00       	call   103db8 <nr_free_pages>
  103490:	39 c3                	cmp    %eax,%ebx
  103492:	74 24                	je     1034b8 <default_check+0xd8>
  103494:	c7 44 24 0c ee 68 10 	movl   $0x1068ee,0xc(%esp)
  10349b:	00 
  10349c:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1034a3:	00 
  1034a4:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  1034ab:	00 
  1034ac:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1034b3:	e8 15 d8 ff ff       	call   100ccd <__panic>

    basic_check();
  1034b8:	e8 e7 f9 ff ff       	call   102ea4 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1034bd:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1034c4:	e8 85 08 00 00       	call   103d4e <alloc_pages>
  1034c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1034cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034d0:	75 24                	jne    1034f6 <default_check+0x116>
  1034d2:	c7 44 24 0c 07 69 10 	movl   $0x106907,0xc(%esp)
  1034d9:	00 
  1034da:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1034e1:	00 
  1034e2:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  1034e9:	00 
  1034ea:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1034f1:	e8 d7 d7 ff ff       	call   100ccd <__panic>
    assert(!PageProperty(p0));
  1034f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034f9:	83 c0 04             	add    $0x4,%eax
  1034fc:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103503:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103506:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103509:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10350c:	0f a3 10             	bt     %edx,(%eax)
  10350f:	19 c0                	sbb    %eax,%eax
  103511:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103514:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103518:	0f 95 c0             	setne  %al
  10351b:	0f b6 c0             	movzbl %al,%eax
  10351e:	85 c0                	test   %eax,%eax
  103520:	74 24                	je     103546 <default_check+0x166>
  103522:	c7 44 24 0c 12 69 10 	movl   $0x106912,0xc(%esp)
  103529:	00 
  10352a:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103531:	00 
  103532:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  103539:	00 
  10353a:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103541:	e8 87 d7 ff ff       	call   100ccd <__panic>

    list_entry_t free_list_store = free_list;
  103546:	a1 50 89 11 00       	mov    0x118950,%eax
  10354b:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103551:	89 45 80             	mov    %eax,-0x80(%ebp)
  103554:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103557:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10355e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103561:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103564:	89 50 04             	mov    %edx,0x4(%eax)
  103567:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10356a:	8b 50 04             	mov    0x4(%eax),%edx
  10356d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103570:	89 10                	mov    %edx,(%eax)
  103572:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103579:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10357c:	8b 40 04             	mov    0x4(%eax),%eax
  10357f:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103582:	0f 94 c0             	sete   %al
  103585:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103588:	85 c0                	test   %eax,%eax
  10358a:	75 24                	jne    1035b0 <default_check+0x1d0>
  10358c:	c7 44 24 0c 67 68 10 	movl   $0x106867,0xc(%esp)
  103593:	00 
  103594:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10359b:	00 
  10359c:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  1035a3:	00 
  1035a4:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1035ab:	e8 1d d7 ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  1035b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1035b7:	e8 92 07 00 00       	call   103d4e <alloc_pages>
  1035bc:	85 c0                	test   %eax,%eax
  1035be:	74 24                	je     1035e4 <default_check+0x204>
  1035c0:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  1035c7:	00 
  1035c8:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1035cf:	00 
  1035d0:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  1035d7:	00 
  1035d8:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1035df:	e8 e9 d6 ff ff       	call   100ccd <__panic>

    unsigned int nr_free_store = nr_free;
  1035e4:	a1 58 89 11 00       	mov    0x118958,%eax
  1035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1035ec:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1035f3:	00 00 00 

    free_pages(p0 + 2, 3);
  1035f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035f9:	83 c0 28             	add    $0x28,%eax
  1035fc:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103603:	00 
  103604:	89 04 24             	mov    %eax,(%esp)
  103607:	e8 7a 07 00 00       	call   103d86 <free_pages>
    assert(alloc_pages(4) == NULL);
  10360c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103613:	e8 36 07 00 00       	call   103d4e <alloc_pages>
  103618:	85 c0                	test   %eax,%eax
  10361a:	74 24                	je     103640 <default_check+0x260>
  10361c:	c7 44 24 0c 24 69 10 	movl   $0x106924,0xc(%esp)
  103623:	00 
  103624:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10362b:	00 
  10362c:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103633:	00 
  103634:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10363b:	e8 8d d6 ff ff       	call   100ccd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103643:	83 c0 28             	add    $0x28,%eax
  103646:	83 c0 04             	add    $0x4,%eax
  103649:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103650:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103653:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103656:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103659:	0f a3 10             	bt     %edx,(%eax)
  10365c:	19 c0                	sbb    %eax,%eax
  10365e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103661:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103665:	0f 95 c0             	setne  %al
  103668:	0f b6 c0             	movzbl %al,%eax
  10366b:	85 c0                	test   %eax,%eax
  10366d:	74 0e                	je     10367d <default_check+0x29d>
  10366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103672:	83 c0 28             	add    $0x28,%eax
  103675:	8b 40 08             	mov    0x8(%eax),%eax
  103678:	83 f8 03             	cmp    $0x3,%eax
  10367b:	74 24                	je     1036a1 <default_check+0x2c1>
  10367d:	c7 44 24 0c 3c 69 10 	movl   $0x10693c,0xc(%esp)
  103684:	00 
  103685:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10368c:	00 
  10368d:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103694:	00 
  103695:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10369c:	e8 2c d6 ff ff       	call   100ccd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1036a1:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1036a8:	e8 a1 06 00 00       	call   103d4e <alloc_pages>
  1036ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1036b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1036b4:	75 24                	jne    1036da <default_check+0x2fa>
  1036b6:	c7 44 24 0c 68 69 10 	movl   $0x106968,0xc(%esp)
  1036bd:	00 
  1036be:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1036c5:	00 
  1036c6:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  1036cd:	00 
  1036ce:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1036d5:	e8 f3 d5 ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  1036da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1036e1:	e8 68 06 00 00       	call   103d4e <alloc_pages>
  1036e6:	85 c0                	test   %eax,%eax
  1036e8:	74 24                	je     10370e <default_check+0x32e>
  1036ea:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  1036f1:	00 
  1036f2:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1036f9:	00 
  1036fa:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  103701:	00 
  103702:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103709:	e8 bf d5 ff ff       	call   100ccd <__panic>
    assert(p0 + 2 == p1);
  10370e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103711:	83 c0 28             	add    $0x28,%eax
  103714:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103717:	74 24                	je     10373d <default_check+0x35d>
  103719:	c7 44 24 0c 86 69 10 	movl   $0x106986,0xc(%esp)
  103720:	00 
  103721:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103728:	00 
  103729:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  103730:	00 
  103731:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103738:	e8 90 d5 ff ff       	call   100ccd <__panic>

    p2 = p0 + 1;
  10373d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103740:	83 c0 14             	add    $0x14,%eax
  103743:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103746:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10374d:	00 
  10374e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103751:	89 04 24             	mov    %eax,(%esp)
  103754:	e8 2d 06 00 00       	call   103d86 <free_pages>
    free_pages(p1, 3);
  103759:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103760:	00 
  103761:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103764:	89 04 24             	mov    %eax,(%esp)
  103767:	e8 1a 06 00 00       	call   103d86 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10376c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10376f:	83 c0 04             	add    $0x4,%eax
  103772:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103779:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10377c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10377f:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103782:	0f a3 10             	bt     %edx,(%eax)
  103785:	19 c0                	sbb    %eax,%eax
  103787:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10378a:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10378e:	0f 95 c0             	setne  %al
  103791:	0f b6 c0             	movzbl %al,%eax
  103794:	85 c0                	test   %eax,%eax
  103796:	74 0b                	je     1037a3 <default_check+0x3c3>
  103798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10379b:	8b 40 08             	mov    0x8(%eax),%eax
  10379e:	83 f8 01             	cmp    $0x1,%eax
  1037a1:	74 24                	je     1037c7 <default_check+0x3e7>
  1037a3:	c7 44 24 0c 94 69 10 	movl   $0x106994,0xc(%esp)
  1037aa:	00 
  1037ab:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1037b2:	00 
  1037b3:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  1037ba:	00 
  1037bb:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1037c2:	e8 06 d5 ff ff       	call   100ccd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1037c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037ca:	83 c0 04             	add    $0x4,%eax
  1037cd:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1037d4:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037d7:	8b 45 90             	mov    -0x70(%ebp),%eax
  1037da:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1037dd:	0f a3 10             	bt     %edx,(%eax)
  1037e0:	19 c0                	sbb    %eax,%eax
  1037e2:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1037e5:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1037e9:	0f 95 c0             	setne  %al
  1037ec:	0f b6 c0             	movzbl %al,%eax
  1037ef:	85 c0                	test   %eax,%eax
  1037f1:	74 0b                	je     1037fe <default_check+0x41e>
  1037f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037f6:	8b 40 08             	mov    0x8(%eax),%eax
  1037f9:	83 f8 03             	cmp    $0x3,%eax
  1037fc:	74 24                	je     103822 <default_check+0x442>
  1037fe:	c7 44 24 0c bc 69 10 	movl   $0x1069bc,0xc(%esp)
  103805:	00 
  103806:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10380d:	00 
  10380e:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  103815:	00 
  103816:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10381d:	e8 ab d4 ff ff       	call   100ccd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103822:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103829:	e8 20 05 00 00       	call   103d4e <alloc_pages>
  10382e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103831:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103834:	83 e8 14             	sub    $0x14,%eax
  103837:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10383a:	74 24                	je     103860 <default_check+0x480>
  10383c:	c7 44 24 0c e2 69 10 	movl   $0x1069e2,0xc(%esp)
  103843:	00 
  103844:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10384b:	00 
  10384c:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  103853:	00 
  103854:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10385b:	e8 6d d4 ff ff       	call   100ccd <__panic>
    free_page(p0);
  103860:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103867:	00 
  103868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10386b:	89 04 24             	mov    %eax,(%esp)
  10386e:	e8 13 05 00 00       	call   103d86 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103873:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10387a:	e8 cf 04 00 00       	call   103d4e <alloc_pages>
  10387f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103882:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103885:	83 c0 14             	add    $0x14,%eax
  103888:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10388b:	74 24                	je     1038b1 <default_check+0x4d1>
  10388d:	c7 44 24 0c 00 6a 10 	movl   $0x106a00,0xc(%esp)
  103894:	00 
  103895:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10389c:	00 
  10389d:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1038a4:	00 
  1038a5:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1038ac:	e8 1c d4 ff ff       	call   100ccd <__panic>

    free_pages(p0, 2);
  1038b1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1038b8:	00 
  1038b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038bc:	89 04 24             	mov    %eax,(%esp)
  1038bf:	e8 c2 04 00 00       	call   103d86 <free_pages>
    free_page(p2);
  1038c4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038cb:	00 
  1038cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038cf:	89 04 24             	mov    %eax,(%esp)
  1038d2:	e8 af 04 00 00       	call   103d86 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1038d7:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1038de:	e8 6b 04 00 00       	call   103d4e <alloc_pages>
  1038e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1038ea:	75 24                	jne    103910 <default_check+0x530>
  1038ec:	c7 44 24 0c 20 6a 10 	movl   $0x106a20,0xc(%esp)
  1038f3:	00 
  1038f4:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1038fb:	00 
  1038fc:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  103903:	00 
  103904:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10390b:	e8 bd d3 ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  103910:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103917:	e8 32 04 00 00       	call   103d4e <alloc_pages>
  10391c:	85 c0                	test   %eax,%eax
  10391e:	74 24                	je     103944 <default_check+0x564>
  103920:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  103927:	00 
  103928:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10392f:	00 
  103930:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103937:	00 
  103938:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10393f:	e8 89 d3 ff ff       	call   100ccd <__panic>

    assert(nr_free == 0);
  103944:	a1 58 89 11 00       	mov    0x118958,%eax
  103949:	85 c0                	test   %eax,%eax
  10394b:	74 24                	je     103971 <default_check+0x591>
  10394d:	c7 44 24 0c d1 68 10 	movl   $0x1068d1,0xc(%esp)
  103954:	00 
  103955:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10395c:	00 
  10395d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  103964:	00 
  103965:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10396c:	e8 5c d3 ff ff       	call   100ccd <__panic>
    nr_free = nr_free_store;
  103971:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103974:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  103979:	8b 45 80             	mov    -0x80(%ebp),%eax
  10397c:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10397f:	a3 50 89 11 00       	mov    %eax,0x118950
  103984:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  10398a:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103991:	00 
  103992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103995:	89 04 24             	mov    %eax,(%esp)
  103998:	e8 e9 03 00 00       	call   103d86 <free_pages>

    le = &free_list;
  10399d:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1039a4:	eb 1d                	jmp    1039c3 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  1039a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039a9:	83 e8 0c             	sub    $0xc,%eax
  1039ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  1039af:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1039b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1039b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1039b9:	8b 40 08             	mov    0x8(%eax),%eax
  1039bc:	29 c2                	sub    %eax,%edx
  1039be:	89 d0                	mov    %edx,%eax
  1039c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039c6:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1039c9:	8b 45 88             	mov    -0x78(%ebp),%eax
  1039cc:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1039cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039d2:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1039d9:	75 cb                	jne    1039a6 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  1039db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1039df:	74 24                	je     103a05 <default_check+0x625>
  1039e1:	c7 44 24 0c 3e 6a 10 	movl   $0x106a3e,0xc(%esp)
  1039e8:	00 
  1039e9:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1039f0:	00 
  1039f1:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  1039f8:	00 
  1039f9:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103a00:	e8 c8 d2 ff ff       	call   100ccd <__panic>
    assert(total == 0);
  103a05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a09:	74 24                	je     103a2f <default_check+0x64f>
  103a0b:	c7 44 24 0c 49 6a 10 	movl   $0x106a49,0xc(%esp)
  103a12:	00 
  103a13:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103a1a:	00 
  103a1b:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103a22:	00 
  103a23:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103a2a:	e8 9e d2 ff ff       	call   100ccd <__panic>
}
  103a2f:	81 c4 94 00 00 00    	add    $0x94,%esp
  103a35:	5b                   	pop    %ebx
  103a36:	5d                   	pop    %ebp
  103a37:	c3                   	ret    

00103a38 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103a38:	55                   	push   %ebp
  103a39:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103a3b:	8b 55 08             	mov    0x8(%ebp),%edx
  103a3e:	a1 64 89 11 00       	mov    0x118964,%eax
  103a43:	29 c2                	sub    %eax,%edx
  103a45:	89 d0                	mov    %edx,%eax
  103a47:	c1 f8 02             	sar    $0x2,%eax
  103a4a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103a50:	5d                   	pop    %ebp
  103a51:	c3                   	ret    

00103a52 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103a52:	55                   	push   %ebp
  103a53:	89 e5                	mov    %esp,%ebp
  103a55:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103a58:	8b 45 08             	mov    0x8(%ebp),%eax
  103a5b:	89 04 24             	mov    %eax,(%esp)
  103a5e:	e8 d5 ff ff ff       	call   103a38 <page2ppn>
  103a63:	c1 e0 0c             	shl    $0xc,%eax
}
  103a66:	c9                   	leave  
  103a67:	c3                   	ret    

00103a68 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103a68:	55                   	push   %ebp
  103a69:	89 e5                	mov    %esp,%ebp
  103a6b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  103a71:	c1 e8 0c             	shr    $0xc,%eax
  103a74:	89 c2                	mov    %eax,%edx
  103a76:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a7b:	39 c2                	cmp    %eax,%edx
  103a7d:	72 1c                	jb     103a9b <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103a7f:	c7 44 24 08 84 6a 10 	movl   $0x106a84,0x8(%esp)
  103a86:	00 
  103a87:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103a8e:	00 
  103a8f:	c7 04 24 a3 6a 10 00 	movl   $0x106aa3,(%esp)
  103a96:	e8 32 d2 ff ff       	call   100ccd <__panic>
    }
    return &pages[PPN(pa)];
  103a9b:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  103aa4:	c1 e8 0c             	shr    $0xc,%eax
  103aa7:	89 c2                	mov    %eax,%edx
  103aa9:	89 d0                	mov    %edx,%eax
  103aab:	c1 e0 02             	shl    $0x2,%eax
  103aae:	01 d0                	add    %edx,%eax
  103ab0:	c1 e0 02             	shl    $0x2,%eax
  103ab3:	01 c8                	add    %ecx,%eax
}
  103ab5:	c9                   	leave  
  103ab6:	c3                   	ret    

00103ab7 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103ab7:	55                   	push   %ebp
  103ab8:	89 e5                	mov    %esp,%ebp
  103aba:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103abd:	8b 45 08             	mov    0x8(%ebp),%eax
  103ac0:	89 04 24             	mov    %eax,(%esp)
  103ac3:	e8 8a ff ff ff       	call   103a52 <page2pa>
  103ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ace:	c1 e8 0c             	shr    $0xc,%eax
  103ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ad4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103ad9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103adc:	72 23                	jb     103b01 <page2kva+0x4a>
  103ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ae1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ae5:	c7 44 24 08 b4 6a 10 	movl   $0x106ab4,0x8(%esp)
  103aec:	00 
  103aed:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103af4:	00 
  103af5:	c7 04 24 a3 6a 10 00 	movl   $0x106aa3,(%esp)
  103afc:	e8 cc d1 ff ff       	call   100ccd <__panic>
  103b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b04:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103b09:	c9                   	leave  
  103b0a:	c3                   	ret    

00103b0b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103b0b:	55                   	push   %ebp
  103b0c:	89 e5                	mov    %esp,%ebp
  103b0e:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103b11:	8b 45 08             	mov    0x8(%ebp),%eax
  103b14:	83 e0 01             	and    $0x1,%eax
  103b17:	85 c0                	test   %eax,%eax
  103b19:	75 1c                	jne    103b37 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103b1b:	c7 44 24 08 d8 6a 10 	movl   $0x106ad8,0x8(%esp)
  103b22:	00 
  103b23:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103b2a:	00 
  103b2b:	c7 04 24 a3 6a 10 00 	movl   $0x106aa3,(%esp)
  103b32:	e8 96 d1 ff ff       	call   100ccd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103b37:	8b 45 08             	mov    0x8(%ebp),%eax
  103b3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b3f:	89 04 24             	mov    %eax,(%esp)
  103b42:	e8 21 ff ff ff       	call   103a68 <pa2page>
}
  103b47:	c9                   	leave  
  103b48:	c3                   	ret    

00103b49 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103b49:	55                   	push   %ebp
  103b4a:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  103b4f:	8b 00                	mov    (%eax),%eax
}
  103b51:	5d                   	pop    %ebp
  103b52:	c3                   	ret    

00103b53 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103b53:	55                   	push   %ebp
  103b54:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103b56:	8b 45 08             	mov    0x8(%ebp),%eax
  103b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  103b5c:	89 10                	mov    %edx,(%eax)
}
  103b5e:	5d                   	pop    %ebp
  103b5f:	c3                   	ret    

00103b60 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103b60:	55                   	push   %ebp
  103b61:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103b63:	8b 45 08             	mov    0x8(%ebp),%eax
  103b66:	8b 00                	mov    (%eax),%eax
  103b68:	8d 50 01             	lea    0x1(%eax),%edx
  103b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  103b6e:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b70:	8b 45 08             	mov    0x8(%ebp),%eax
  103b73:	8b 00                	mov    (%eax),%eax
}
  103b75:	5d                   	pop    %ebp
  103b76:	c3                   	ret    

00103b77 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103b77:	55                   	push   %ebp
  103b78:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  103b7d:	8b 00                	mov    (%eax),%eax
  103b7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103b82:	8b 45 08             	mov    0x8(%ebp),%eax
  103b85:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b87:	8b 45 08             	mov    0x8(%ebp),%eax
  103b8a:	8b 00                	mov    (%eax),%eax
}
  103b8c:	5d                   	pop    %ebp
  103b8d:	c3                   	ret    

00103b8e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103b8e:	55                   	push   %ebp
  103b8f:	89 e5                	mov    %esp,%ebp
  103b91:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b94:	9c                   	pushf  
  103b95:	58                   	pop    %eax
  103b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b9c:	25 00 02 00 00       	and    $0x200,%eax
  103ba1:	85 c0                	test   %eax,%eax
  103ba3:	74 0c                	je     103bb1 <__intr_save+0x23>
        intr_disable();
  103ba5:	e8 06 db ff ff       	call   1016b0 <intr_disable>
        return 1;
  103baa:	b8 01 00 00 00       	mov    $0x1,%eax
  103baf:	eb 05                	jmp    103bb6 <__intr_save+0x28>
    }
    return 0;
  103bb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103bb6:	c9                   	leave  
  103bb7:	c3                   	ret    

00103bb8 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103bb8:	55                   	push   %ebp
  103bb9:	89 e5                	mov    %esp,%ebp
  103bbb:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103bc2:	74 05                	je     103bc9 <__intr_restore+0x11>
        intr_enable();
  103bc4:	e8 e1 da ff ff       	call   1016aa <intr_enable>
    }
}
  103bc9:	c9                   	leave  
  103bca:	c3                   	ret    

00103bcb <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103bcb:	55                   	push   %ebp
  103bcc:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103bce:	8b 45 08             	mov    0x8(%ebp),%eax
  103bd1:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103bd4:	b8 23 00 00 00       	mov    $0x23,%eax
  103bd9:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103bdb:	b8 23 00 00 00       	mov    $0x23,%eax
  103be0:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103be2:	b8 10 00 00 00       	mov    $0x10,%eax
  103be7:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103be9:	b8 10 00 00 00       	mov    $0x10,%eax
  103bee:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103bf0:	b8 10 00 00 00       	mov    $0x10,%eax
  103bf5:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103bf7:	ea fe 3b 10 00 08 00 	ljmp   $0x8,$0x103bfe
}
  103bfe:	5d                   	pop    %ebp
  103bff:	c3                   	ret    

00103c00 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103c00:	55                   	push   %ebp
  103c01:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103c03:	8b 45 08             	mov    0x8(%ebp),%eax
  103c06:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103c0b:	5d                   	pop    %ebp
  103c0c:	c3                   	ret    

00103c0d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103c0d:	55                   	push   %ebp
  103c0e:	89 e5                	mov    %esp,%ebp
  103c10:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103c13:	b8 00 70 11 00       	mov    $0x117000,%eax
  103c18:	89 04 24             	mov    %eax,(%esp)
  103c1b:	e8 e0 ff ff ff       	call   103c00 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103c20:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103c27:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103c29:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103c30:	68 00 
  103c32:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c37:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103c3d:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c42:	c1 e8 10             	shr    $0x10,%eax
  103c45:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103c4a:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c51:	83 e0 f0             	and    $0xfffffff0,%eax
  103c54:	83 c8 09             	or     $0x9,%eax
  103c57:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c5c:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c63:	83 e0 ef             	and    $0xffffffef,%eax
  103c66:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c6b:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c72:	83 e0 9f             	and    $0xffffff9f,%eax
  103c75:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c7a:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c81:	83 c8 80             	or     $0xffffff80,%eax
  103c84:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c89:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c90:	83 e0 f0             	and    $0xfffffff0,%eax
  103c93:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c98:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c9f:	83 e0 ef             	and    $0xffffffef,%eax
  103ca2:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ca7:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cae:	83 e0 df             	and    $0xffffffdf,%eax
  103cb1:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cb6:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cbd:	83 c8 40             	or     $0x40,%eax
  103cc0:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cc5:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103ccc:	83 e0 7f             	and    $0x7f,%eax
  103ccf:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cd4:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103cd9:	c1 e8 18             	shr    $0x18,%eax
  103cdc:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103ce1:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103ce8:	e8 de fe ff ff       	call   103bcb <lgdt>
  103ced:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103cf3:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103cf7:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103cfa:	c9                   	leave  
  103cfb:	c3                   	ret    

00103cfc <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103cfc:	55                   	push   %ebp
  103cfd:	89 e5                	mov    %esp,%ebp
  103cff:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103d02:	c7 05 5c 89 11 00 68 	movl   $0x106a68,0x11895c
  103d09:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103d0c:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d11:	8b 00                	mov    (%eax),%eax
  103d13:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d17:	c7 04 24 04 6b 10 00 	movl   $0x106b04,(%esp)
  103d1e:	e8 19 c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103d23:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d28:	8b 40 04             	mov    0x4(%eax),%eax
  103d2b:	ff d0                	call   *%eax
}
  103d2d:	c9                   	leave  
  103d2e:	c3                   	ret    

00103d2f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103d2f:	55                   	push   %ebp
  103d30:	89 e5                	mov    %esp,%ebp
  103d32:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103d35:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d3a:	8b 40 08             	mov    0x8(%eax),%eax
  103d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d40:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d44:	8b 55 08             	mov    0x8(%ebp),%edx
  103d47:	89 14 24             	mov    %edx,(%esp)
  103d4a:	ff d0                	call   *%eax
}
  103d4c:	c9                   	leave  
  103d4d:	c3                   	ret    

00103d4e <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103d4e:	55                   	push   %ebp
  103d4f:	89 e5                	mov    %esp,%ebp
  103d51:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103d54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103d5b:	e8 2e fe ff ff       	call   103b8e <__intr_save>
  103d60:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103d63:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d68:	8b 40 0c             	mov    0xc(%eax),%eax
  103d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  103d6e:	89 14 24             	mov    %edx,(%esp)
  103d71:	ff d0                	call   *%eax
  103d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d79:	89 04 24             	mov    %eax,(%esp)
  103d7c:	e8 37 fe ff ff       	call   103bb8 <__intr_restore>
    return page;
  103d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103d84:	c9                   	leave  
  103d85:	c3                   	ret    

00103d86 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103d86:	55                   	push   %ebp
  103d87:	89 e5                	mov    %esp,%ebp
  103d89:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103d8c:	e8 fd fd ff ff       	call   103b8e <__intr_save>
  103d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d94:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d99:	8b 40 10             	mov    0x10(%eax),%eax
  103d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d9f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103da3:	8b 55 08             	mov    0x8(%ebp),%edx
  103da6:	89 14 24             	mov    %edx,(%esp)
  103da9:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dae:	89 04 24             	mov    %eax,(%esp)
  103db1:	e8 02 fe ff ff       	call   103bb8 <__intr_restore>
}
  103db6:	c9                   	leave  
  103db7:	c3                   	ret    

00103db8 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103db8:	55                   	push   %ebp
  103db9:	89 e5                	mov    %esp,%ebp
  103dbb:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103dbe:	e8 cb fd ff ff       	call   103b8e <__intr_save>
  103dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103dc6:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103dcb:	8b 40 14             	mov    0x14(%eax),%eax
  103dce:	ff d0                	call   *%eax
  103dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dd6:	89 04 24             	mov    %eax,(%esp)
  103dd9:	e8 da fd ff ff       	call   103bb8 <__intr_restore>
    return ret;
  103dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103de1:	c9                   	leave  
  103de2:	c3                   	ret    

00103de3 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103de3:	55                   	push   %ebp
  103de4:	89 e5                	mov    %esp,%ebp
  103de6:	57                   	push   %edi
  103de7:	56                   	push   %esi
  103de8:	53                   	push   %ebx
  103de9:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103def:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103df6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103dfd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103e04:	c7 04 24 1b 6b 10 00 	movl   $0x106b1b,(%esp)
  103e0b:	e8 2c c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103e17:	e9 15 01 00 00       	jmp    103f31 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103e1c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e22:	89 d0                	mov    %edx,%eax
  103e24:	c1 e0 02             	shl    $0x2,%eax
  103e27:	01 d0                	add    %edx,%eax
  103e29:	c1 e0 02             	shl    $0x2,%eax
  103e2c:	01 c8                	add    %ecx,%eax
  103e2e:	8b 50 08             	mov    0x8(%eax),%edx
  103e31:	8b 40 04             	mov    0x4(%eax),%eax
  103e34:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103e37:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103e3a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e40:	89 d0                	mov    %edx,%eax
  103e42:	c1 e0 02             	shl    $0x2,%eax
  103e45:	01 d0                	add    %edx,%eax
  103e47:	c1 e0 02             	shl    $0x2,%eax
  103e4a:	01 c8                	add    %ecx,%eax
  103e4c:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e4f:	8b 58 10             	mov    0x10(%eax),%ebx
  103e52:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e55:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e58:	01 c8                	add    %ecx,%eax
  103e5a:	11 da                	adc    %ebx,%edx
  103e5c:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103e5f:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103e62:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e65:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e68:	89 d0                	mov    %edx,%eax
  103e6a:	c1 e0 02             	shl    $0x2,%eax
  103e6d:	01 d0                	add    %edx,%eax
  103e6f:	c1 e0 02             	shl    $0x2,%eax
  103e72:	01 c8                	add    %ecx,%eax
  103e74:	83 c0 14             	add    $0x14,%eax
  103e77:	8b 00                	mov    (%eax),%eax
  103e79:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103e7f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e82:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e85:	83 c0 ff             	add    $0xffffffff,%eax
  103e88:	83 d2 ff             	adc    $0xffffffff,%edx
  103e8b:	89 c6                	mov    %eax,%esi
  103e8d:	89 d7                	mov    %edx,%edi
  103e8f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e92:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e95:	89 d0                	mov    %edx,%eax
  103e97:	c1 e0 02             	shl    $0x2,%eax
  103e9a:	01 d0                	add    %edx,%eax
  103e9c:	c1 e0 02             	shl    $0x2,%eax
  103e9f:	01 c8                	add    %ecx,%eax
  103ea1:	8b 48 0c             	mov    0xc(%eax),%ecx
  103ea4:	8b 58 10             	mov    0x10(%eax),%ebx
  103ea7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103ead:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103eb1:	89 74 24 14          	mov    %esi,0x14(%esp)
  103eb5:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103eb9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103ebc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103ebf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ec3:	89 54 24 10          	mov    %edx,0x10(%esp)
  103ec7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103ecb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103ecf:	c7 04 24 28 6b 10 00 	movl   $0x106b28,(%esp)
  103ed6:	e8 61 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103edb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ede:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ee1:	89 d0                	mov    %edx,%eax
  103ee3:	c1 e0 02             	shl    $0x2,%eax
  103ee6:	01 d0                	add    %edx,%eax
  103ee8:	c1 e0 02             	shl    $0x2,%eax
  103eeb:	01 c8                	add    %ecx,%eax
  103eed:	83 c0 14             	add    $0x14,%eax
  103ef0:	8b 00                	mov    (%eax),%eax
  103ef2:	83 f8 01             	cmp    $0x1,%eax
  103ef5:	75 36                	jne    103f2d <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103ef7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103efa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103efd:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f00:	77 2b                	ja     103f2d <page_init+0x14a>
  103f02:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f05:	72 05                	jb     103f0c <page_init+0x129>
  103f07:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103f0a:	73 21                	jae    103f2d <page_init+0x14a>
  103f0c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f10:	77 1b                	ja     103f2d <page_init+0x14a>
  103f12:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f16:	72 09                	jb     103f21 <page_init+0x13e>
  103f18:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103f1f:	77 0c                	ja     103f2d <page_init+0x14a>
                maxpa = end;
  103f21:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103f24:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103f27:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103f2a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103f2d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103f34:	8b 00                	mov    (%eax),%eax
  103f36:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103f39:	0f 8f dd fe ff ff    	jg     103e1c <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103f3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f43:	72 1d                	jb     103f62 <page_init+0x17f>
  103f45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f49:	77 09                	ja     103f54 <page_init+0x171>
  103f4b:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103f52:	76 0e                	jbe    103f62 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103f54:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103f5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103f62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f68:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103f6c:	c1 ea 0c             	shr    $0xc,%edx
  103f6f:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103f74:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103f7b:	b8 68 89 11 00       	mov    $0x118968,%eax
  103f80:	8d 50 ff             	lea    -0x1(%eax),%edx
  103f83:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f86:	01 d0                	add    %edx,%eax
  103f88:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103f8b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103f8e:	ba 00 00 00 00       	mov    $0x0,%edx
  103f93:	f7 75 ac             	divl   -0x54(%ebp)
  103f96:	89 d0                	mov    %edx,%eax
  103f98:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f9b:	29 c2                	sub    %eax,%edx
  103f9d:	89 d0                	mov    %edx,%eax
  103f9f:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103fa4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fab:	eb 2f                	jmp    103fdc <page_init+0x1f9>
        SetPageReserved(pages + i);
  103fad:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103fb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fb6:	89 d0                	mov    %edx,%eax
  103fb8:	c1 e0 02             	shl    $0x2,%eax
  103fbb:	01 d0                	add    %edx,%eax
  103fbd:	c1 e0 02             	shl    $0x2,%eax
  103fc0:	01 c8                	add    %ecx,%eax
  103fc2:	83 c0 04             	add    $0x4,%eax
  103fc5:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103fcc:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103fcf:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103fd2:	8b 55 90             	mov    -0x70(%ebp),%edx
  103fd5:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103fd8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103fdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fdf:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103fe4:	39 c2                	cmp    %eax,%edx
  103fe6:	72 c5                	jb     103fad <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103fe8:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103fee:	89 d0                	mov    %edx,%eax
  103ff0:	c1 e0 02             	shl    $0x2,%eax
  103ff3:	01 d0                	add    %edx,%eax
  103ff5:	c1 e0 02             	shl    $0x2,%eax
  103ff8:	89 c2                	mov    %eax,%edx
  103ffa:	a1 64 89 11 00       	mov    0x118964,%eax
  103fff:	01 d0                	add    %edx,%eax
  104001:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104004:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  10400b:	77 23                	ja     104030 <page_init+0x24d>
  10400d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104010:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104014:	c7 44 24 08 58 6b 10 	movl   $0x106b58,0x8(%esp)
  10401b:	00 
  10401c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104023:	00 
  104024:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  10402b:	e8 9d cc ff ff       	call   100ccd <__panic>
  104030:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104033:	05 00 00 00 40       	add    $0x40000000,%eax
  104038:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10403b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104042:	e9 74 01 00 00       	jmp    1041bb <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104047:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10404a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10404d:	89 d0                	mov    %edx,%eax
  10404f:	c1 e0 02             	shl    $0x2,%eax
  104052:	01 d0                	add    %edx,%eax
  104054:	c1 e0 02             	shl    $0x2,%eax
  104057:	01 c8                	add    %ecx,%eax
  104059:	8b 50 08             	mov    0x8(%eax),%edx
  10405c:	8b 40 04             	mov    0x4(%eax),%eax
  10405f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104062:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104065:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104068:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10406b:	89 d0                	mov    %edx,%eax
  10406d:	c1 e0 02             	shl    $0x2,%eax
  104070:	01 d0                	add    %edx,%eax
  104072:	c1 e0 02             	shl    $0x2,%eax
  104075:	01 c8                	add    %ecx,%eax
  104077:	8b 48 0c             	mov    0xc(%eax),%ecx
  10407a:	8b 58 10             	mov    0x10(%eax),%ebx
  10407d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104080:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104083:	01 c8                	add    %ecx,%eax
  104085:	11 da                	adc    %ebx,%edx
  104087:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10408a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10408d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104090:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104093:	89 d0                	mov    %edx,%eax
  104095:	c1 e0 02             	shl    $0x2,%eax
  104098:	01 d0                	add    %edx,%eax
  10409a:	c1 e0 02             	shl    $0x2,%eax
  10409d:	01 c8                	add    %ecx,%eax
  10409f:	83 c0 14             	add    $0x14,%eax
  1040a2:	8b 00                	mov    (%eax),%eax
  1040a4:	83 f8 01             	cmp    $0x1,%eax
  1040a7:	0f 85 0a 01 00 00    	jne    1041b7 <page_init+0x3d4>
            if (begin < freemem) {
  1040ad:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040b0:	ba 00 00 00 00       	mov    $0x0,%edx
  1040b5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1040b8:	72 17                	jb     1040d1 <page_init+0x2ee>
  1040ba:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1040bd:	77 05                	ja     1040c4 <page_init+0x2e1>
  1040bf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1040c2:	76 0d                	jbe    1040d1 <page_init+0x2ee>
                begin = freemem;
  1040c4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040ca:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1040d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040d5:	72 1d                	jb     1040f4 <page_init+0x311>
  1040d7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040db:	77 09                	ja     1040e6 <page_init+0x303>
  1040dd:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1040e4:	76 0e                	jbe    1040f4 <page_init+0x311>
                end = KMEMSIZE;
  1040e6:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1040ed:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1040f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040fa:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040fd:	0f 87 b4 00 00 00    	ja     1041b7 <page_init+0x3d4>
  104103:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104106:	72 09                	jb     104111 <page_init+0x32e>
  104108:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10410b:	0f 83 a6 00 00 00    	jae    1041b7 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104111:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104118:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10411b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10411e:	01 d0                	add    %edx,%eax
  104120:	83 e8 01             	sub    $0x1,%eax
  104123:	89 45 98             	mov    %eax,-0x68(%ebp)
  104126:	8b 45 98             	mov    -0x68(%ebp),%eax
  104129:	ba 00 00 00 00       	mov    $0x0,%edx
  10412e:	f7 75 9c             	divl   -0x64(%ebp)
  104131:	89 d0                	mov    %edx,%eax
  104133:	8b 55 98             	mov    -0x68(%ebp),%edx
  104136:	29 c2                	sub    %eax,%edx
  104138:	89 d0                	mov    %edx,%eax
  10413a:	ba 00 00 00 00       	mov    $0x0,%edx
  10413f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104142:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104145:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104148:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10414b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10414e:	ba 00 00 00 00       	mov    $0x0,%edx
  104153:	89 c7                	mov    %eax,%edi
  104155:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10415b:	89 7d 80             	mov    %edi,-0x80(%ebp)
  10415e:	89 d0                	mov    %edx,%eax
  104160:	83 e0 00             	and    $0x0,%eax
  104163:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104166:	8b 45 80             	mov    -0x80(%ebp),%eax
  104169:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10416c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10416f:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104172:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104175:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104178:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10417b:	77 3a                	ja     1041b7 <page_init+0x3d4>
  10417d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104180:	72 05                	jb     104187 <page_init+0x3a4>
  104182:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104185:	73 30                	jae    1041b7 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104187:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10418a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  10418d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104190:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104193:	29 c8                	sub    %ecx,%eax
  104195:	19 da                	sbb    %ebx,%edx
  104197:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10419b:	c1 ea 0c             	shr    $0xc,%edx
  10419e:	89 c3                	mov    %eax,%ebx
  1041a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041a3:	89 04 24             	mov    %eax,(%esp)
  1041a6:	e8 bd f8 ff ff       	call   103a68 <pa2page>
  1041ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1041af:	89 04 24             	mov    %eax,(%esp)
  1041b2:	e8 78 fb ff ff       	call   103d2f <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  1041b7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1041bb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1041be:	8b 00                	mov    (%eax),%eax
  1041c0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1041c3:	0f 8f 7e fe ff ff    	jg     104047 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1041c9:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1041cf:	5b                   	pop    %ebx
  1041d0:	5e                   	pop    %esi
  1041d1:	5f                   	pop    %edi
  1041d2:	5d                   	pop    %ebp
  1041d3:	c3                   	ret    

001041d4 <enable_paging>:

static void
enable_paging(void) {
  1041d4:	55                   	push   %ebp
  1041d5:	89 e5                	mov    %esp,%ebp
  1041d7:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1041da:	a1 60 89 11 00       	mov    0x118960,%eax
  1041df:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1041e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1041e5:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1041e8:	0f 20 c0             	mov    %cr0,%eax
  1041eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1041ee:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1041f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1041f4:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1041fb:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1041ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104202:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  104205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104208:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10420b:	c9                   	leave  
  10420c:	c3                   	ret    

0010420d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10420d:	55                   	push   %ebp
  10420e:	89 e5                	mov    %esp,%ebp
  104210:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104213:	8b 45 14             	mov    0x14(%ebp),%eax
  104216:	8b 55 0c             	mov    0xc(%ebp),%edx
  104219:	31 d0                	xor    %edx,%eax
  10421b:	25 ff 0f 00 00       	and    $0xfff,%eax
  104220:	85 c0                	test   %eax,%eax
  104222:	74 24                	je     104248 <boot_map_segment+0x3b>
  104224:	c7 44 24 0c 8a 6b 10 	movl   $0x106b8a,0xc(%esp)
  10422b:	00 
  10422c:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104233:	00 
  104234:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10423b:	00 
  10423c:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104243:	e8 85 ca ff ff       	call   100ccd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104248:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10424f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104252:	25 ff 0f 00 00       	and    $0xfff,%eax
  104257:	89 c2                	mov    %eax,%edx
  104259:	8b 45 10             	mov    0x10(%ebp),%eax
  10425c:	01 c2                	add    %eax,%edx
  10425e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104261:	01 d0                	add    %edx,%eax
  104263:	83 e8 01             	sub    $0x1,%eax
  104266:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10426c:	ba 00 00 00 00       	mov    $0x0,%edx
  104271:	f7 75 f0             	divl   -0x10(%ebp)
  104274:	89 d0                	mov    %edx,%eax
  104276:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104279:	29 c2                	sub    %eax,%edx
  10427b:	89 d0                	mov    %edx,%eax
  10427d:	c1 e8 0c             	shr    $0xc,%eax
  104280:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104283:	8b 45 0c             	mov    0xc(%ebp),%eax
  104286:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10428c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104291:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104294:	8b 45 14             	mov    0x14(%ebp),%eax
  104297:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10429a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10429d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042a2:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042a5:	eb 6b                	jmp    104312 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1042a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1042ae:	00 
  1042af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1042b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1042b9:	89 04 24             	mov    %eax,(%esp)
  1042bc:	e8 cc 01 00 00       	call   10448d <get_pte>
  1042c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1042c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1042c8:	75 24                	jne    1042ee <boot_map_segment+0xe1>
  1042ca:	c7 44 24 0c b6 6b 10 	movl   $0x106bb6,0xc(%esp)
  1042d1:	00 
  1042d2:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  1042d9:	00 
  1042da:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1042e1:	00 
  1042e2:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1042e9:	e8 df c9 ff ff       	call   100ccd <__panic>
        *ptep = pa | PTE_P | perm;
  1042ee:	8b 45 18             	mov    0x18(%ebp),%eax
  1042f1:	8b 55 14             	mov    0x14(%ebp),%edx
  1042f4:	09 d0                	or     %edx,%eax
  1042f6:	83 c8 01             	or     $0x1,%eax
  1042f9:	89 c2                	mov    %eax,%edx
  1042fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042fe:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104300:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104304:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10430b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104316:	75 8f                	jne    1042a7 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104318:	c9                   	leave  
  104319:	c3                   	ret    

0010431a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10431a:	55                   	push   %ebp
  10431b:	89 e5                	mov    %esp,%ebp
  10431d:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104320:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104327:	e8 22 fa ff ff       	call   103d4e <alloc_pages>
  10432c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10432f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104333:	75 1c                	jne    104351 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104335:	c7 44 24 08 c3 6b 10 	movl   $0x106bc3,0x8(%esp)
  10433c:	00 
  10433d:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104344:	00 
  104345:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  10434c:	e8 7c c9 ff ff       	call   100ccd <__panic>
    }
    return page2kva(p);
  104351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104354:	89 04 24             	mov    %eax,(%esp)
  104357:	e8 5b f7 ff ff       	call   103ab7 <page2kva>
}
  10435c:	c9                   	leave  
  10435d:	c3                   	ret    

0010435e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10435e:	55                   	push   %ebp
  10435f:	89 e5                	mov    %esp,%ebp
  104361:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104364:	e8 93 f9 ff ff       	call   103cfc <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104369:	e8 75 fa ff ff       	call   103de3 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10436e:	e8 66 04 00 00       	call   1047d9 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104373:	e8 a2 ff ff ff       	call   10431a <boot_alloc_page>
  104378:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  10437d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104382:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104389:	00 
  10438a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104391:	00 
  104392:	89 04 24             	mov    %eax,(%esp)
  104395:	e8 a8 1a 00 00       	call   105e42 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10439a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10439f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1043a2:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1043a9:	77 23                	ja     1043ce <pmm_init+0x70>
  1043ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043b2:	c7 44 24 08 58 6b 10 	movl   $0x106b58,0x8(%esp)
  1043b9:	00 
  1043ba:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1043c1:	00 
  1043c2:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1043c9:	e8 ff c8 ff ff       	call   100ccd <__panic>
  1043ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043d1:	05 00 00 00 40       	add    $0x40000000,%eax
  1043d6:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  1043db:	e8 17 04 00 00       	call   1047f7 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1043e0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043e5:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1043eb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1043f3:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1043fa:	77 23                	ja     10441f <pmm_init+0xc1>
  1043fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104403:	c7 44 24 08 58 6b 10 	movl   $0x106b58,0x8(%esp)
  10440a:	00 
  10440b:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104412:	00 
  104413:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  10441a:	e8 ae c8 ff ff       	call   100ccd <__panic>
  10441f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104422:	05 00 00 00 40       	add    $0x40000000,%eax
  104427:	83 c8 03             	or     $0x3,%eax
  10442a:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10442c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104431:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104438:	00 
  104439:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104440:	00 
  104441:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104448:	38 
  104449:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104450:	c0 
  104451:	89 04 24             	mov    %eax,(%esp)
  104454:	e8 b4 fd ff ff       	call   10420d <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  104459:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10445e:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  104464:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10446a:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10446c:	e8 63 fd ff ff       	call   1041d4 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104471:	e8 97 f7 ff ff       	call   103c0d <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104476:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10447b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104481:	e8 0c 0a 00 00       	call   104e92 <check_boot_pgdir>

    print_pgdir();
  104486:	e8 99 0e 00 00       	call   105324 <print_pgdir>

}
  10448b:	c9                   	leave  
  10448c:	c3                   	ret    

0010448d <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10448d:	55                   	push   %ebp
  10448e:	89 e5                	mov    %esp,%ebp
  104490:	83 ec 38             	sub    $0x38,%esp
    }
    return NULL;          // (8) return page table entry
#endif


    pde_t* pdep = pgdir + PDX(la);
  104493:	8b 45 0c             	mov    0xc(%ebp),%eax
  104496:	c1 e8 16             	shr    $0x16,%eax
  104499:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1044a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1044a3:	01 d0                	add    %edx,%eax
  1044a5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (!(*pdep & PTE_P)) 	{
  1044a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ab:	8b 00                	mov    (%eax),%eax
  1044ad:	83 e0 01             	and    $0x1,%eax
  1044b0:	85 c0                	test   %eax,%eax
  1044b2:	0f 85 af 00 00 00    	jne    104567 <get_pte+0xda>
		struct Page* page;
		if (!create || (page = alloc_page()) == NULL)
  1044b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1044bc:	74 15                	je     1044d3 <get_pte+0x46>
  1044be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044c5:	e8 84 f8 ff ff       	call   103d4e <alloc_pages>
  1044ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1044cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1044d1:	75 0a                	jne    1044dd <get_pte+0x50>
			return NULL;
  1044d3:	b8 00 00 00 00       	mov    $0x0,%eax
  1044d8:	e9 e6 00 00 00       	jmp    1045c3 <get_pte+0x136>

		set_page_ref(page, 1);
  1044dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1044e4:	00 
  1044e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044e8:	89 04 24             	mov    %eax,(%esp)
  1044eb:	e8 63 f6 ff ff       	call   103b53 <set_page_ref>
		uintptr_t pa = page2pa(page);
  1044f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044f3:	89 04 24             	mov    %eax,(%esp)
  1044f6:	e8 57 f5 ff ff       	call   103a52 <page2pa>
  1044fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pa), 0, PGSIZE);
  1044fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104501:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104504:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104507:	c1 e8 0c             	shr    $0xc,%eax
  10450a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10450d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104512:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104515:	72 23                	jb     10453a <get_pte+0xad>
  104517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10451a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10451e:	c7 44 24 08 b4 6a 10 	movl   $0x106ab4,0x8(%esp)
  104525:	00 
  104526:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
  10452d:	00 
  10452e:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104535:	e8 93 c7 ff ff       	call   100ccd <__panic>
  10453a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10453d:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104542:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104549:	00 
  10454a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104551:	00 
  104552:	89 04 24             	mov    %eax,(%esp)
  104555:	e8 e8 18 00 00       	call   105e42 <memset>
		*pdep= pa | PTE_P | PTE_W | PTE_U;
  10455a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10455d:	83 c8 07             	or     $0x7,%eax
  104560:	89 c2                	mov    %eax,%edx
  104562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104565:	89 10                	mov    %edx,(%eax)
	}
	return (pte_t*)KADDR(PDE_ADDR(*pdep)) + PTX(la);
  104567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10456a:	8b 00                	mov    (%eax),%eax
  10456c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104571:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104574:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104577:	c1 e8 0c             	shr    $0xc,%eax
  10457a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10457d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104582:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104585:	72 23                	jb     1045aa <get_pte+0x11d>
  104587:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10458a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10458e:	c7 44 24 08 b4 6a 10 	movl   $0x106ab4,0x8(%esp)
  104595:	00 
  104596:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
  10459d:	00 
  10459e:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1045a5:	e8 23 c7 ff ff       	call   100ccd <__panic>
  1045aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045ad:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1045b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1045b5:	c1 ea 0c             	shr    $0xc,%edx
  1045b8:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  1045be:	c1 e2 02             	shl    $0x2,%edx
  1045c1:	01 d0                	add    %edx,%eax
}
  1045c3:	c9                   	leave  
  1045c4:	c3                   	ret    

001045c5 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1045c5:	55                   	push   %ebp
  1045c6:	89 e5                	mov    %esp,%ebp
  1045c8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1045cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1045d2:	00 
  1045d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045da:	8b 45 08             	mov    0x8(%ebp),%eax
  1045dd:	89 04 24             	mov    %eax,(%esp)
  1045e0:	e8 a8 fe ff ff       	call   10448d <get_pte>
  1045e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1045e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1045ec:	74 08                	je     1045f6 <get_page+0x31>
        *ptep_store = ptep;
  1045ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1045f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1045f4:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1045f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045fa:	74 1b                	je     104617 <get_page+0x52>
  1045fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ff:	8b 00                	mov    (%eax),%eax
  104601:	83 e0 01             	and    $0x1,%eax
  104604:	85 c0                	test   %eax,%eax
  104606:	74 0f                	je     104617 <get_page+0x52>
        return pa2page(*ptep);
  104608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10460b:	8b 00                	mov    (%eax),%eax
  10460d:	89 04 24             	mov    %eax,(%esp)
  104610:	e8 53 f4 ff ff       	call   103a68 <pa2page>
  104615:	eb 05                	jmp    10461c <get_page+0x57>
    }
    return NULL;
  104617:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10461c:	c9                   	leave  
  10461d:	c3                   	ret    

0010461e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10461e:	55                   	push   %ebp
  10461f:	89 e5                	mov    %esp,%ebp
  104621:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

    if (*ptep & PTE_P) {
  104624:	8b 45 10             	mov    0x10(%ebp),%eax
  104627:	8b 00                	mov    (%eax),%eax
  104629:	83 e0 01             	and    $0x1,%eax
  10462c:	85 c0                	test   %eax,%eax
  10462e:	74 4d                	je     10467d <page_remove_pte+0x5f>
        struct Page* page = pte2page(*ptep);
  104630:	8b 45 10             	mov    0x10(%ebp),%eax
  104633:	8b 00                	mov    (%eax),%eax
  104635:	89 04 24             	mov    %eax,(%esp)
  104638:	e8 ce f4 ff ff       	call   103b0b <pte2page>
  10463d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0)
  104640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104643:	89 04 24             	mov    %eax,(%esp)
  104646:	e8 2c f5 ff ff       	call   103b77 <page_ref_dec>
  10464b:	85 c0                	test   %eax,%eax
  10464d:	75 13                	jne    104662 <page_remove_pte+0x44>
            free_page(page);
  10464f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104656:	00 
  104657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10465a:	89 04 24             	mov    %eax,(%esp)
  10465d:	e8 24 f7 ff ff       	call   103d86 <free_pages>

        *ptep = 0;
  104662:	8b 45 10             	mov    0x10(%ebp),%eax
  104665:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  10466b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10466e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104672:	8b 45 08             	mov    0x8(%ebp),%eax
  104675:	89 04 24             	mov    %eax,(%esp)
  104678:	e8 ff 00 00 00       	call   10477c <tlb_invalidate>
    }
}
  10467d:	c9                   	leave  
  10467e:	c3                   	ret    

0010467f <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10467f:	55                   	push   %ebp
  104680:	89 e5                	mov    %esp,%ebp
  104682:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104685:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10468c:	00 
  10468d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104690:	89 44 24 04          	mov    %eax,0x4(%esp)
  104694:	8b 45 08             	mov    0x8(%ebp),%eax
  104697:	89 04 24             	mov    %eax,(%esp)
  10469a:	e8 ee fd ff ff       	call   10448d <get_pte>
  10469f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1046a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046a6:	74 19                	je     1046c1 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1046a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1046b9:	89 04 24             	mov    %eax,(%esp)
  1046bc:	e8 5d ff ff ff       	call   10461e <page_remove_pte>
    }
}
  1046c1:	c9                   	leave  
  1046c2:	c3                   	ret    

001046c3 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1046c3:	55                   	push   %ebp
  1046c4:	89 e5                	mov    %esp,%ebp
  1046c6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1046c9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1046d0:	00 
  1046d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1046d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1046db:	89 04 24             	mov    %eax,(%esp)
  1046de:	e8 aa fd ff ff       	call   10448d <get_pte>
  1046e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1046e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046ea:	75 0a                	jne    1046f6 <page_insert+0x33>
        return -E_NO_MEM;
  1046ec:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1046f1:	e9 84 00 00 00       	jmp    10477a <page_insert+0xb7>
    }
    page_ref_inc(page);
  1046f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046f9:	89 04 24             	mov    %eax,(%esp)
  1046fc:	e8 5f f4 ff ff       	call   103b60 <page_ref_inc>
    if (*ptep & PTE_P) {
  104701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104704:	8b 00                	mov    (%eax),%eax
  104706:	83 e0 01             	and    $0x1,%eax
  104709:	85 c0                	test   %eax,%eax
  10470b:	74 3e                	je     10474b <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10470d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104710:	8b 00                	mov    (%eax),%eax
  104712:	89 04 24             	mov    %eax,(%esp)
  104715:	e8 f1 f3 ff ff       	call   103b0b <pte2page>
  10471a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10471d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104720:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104723:	75 0d                	jne    104732 <page_insert+0x6f>
            page_ref_dec(page);
  104725:	8b 45 0c             	mov    0xc(%ebp),%eax
  104728:	89 04 24             	mov    %eax,(%esp)
  10472b:	e8 47 f4 ff ff       	call   103b77 <page_ref_dec>
  104730:	eb 19                	jmp    10474b <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104735:	89 44 24 08          	mov    %eax,0x8(%esp)
  104739:	8b 45 10             	mov    0x10(%ebp),%eax
  10473c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104740:	8b 45 08             	mov    0x8(%ebp),%eax
  104743:	89 04 24             	mov    %eax,(%esp)
  104746:	e8 d3 fe ff ff       	call   10461e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10474b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10474e:	89 04 24             	mov    %eax,(%esp)
  104751:	e8 fc f2 ff ff       	call   103a52 <page2pa>
  104756:	0b 45 14             	or     0x14(%ebp),%eax
  104759:	83 c8 01             	or     $0x1,%eax
  10475c:	89 c2                	mov    %eax,%edx
  10475e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104761:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104763:	8b 45 10             	mov    0x10(%ebp),%eax
  104766:	89 44 24 04          	mov    %eax,0x4(%esp)
  10476a:	8b 45 08             	mov    0x8(%ebp),%eax
  10476d:	89 04 24             	mov    %eax,(%esp)
  104770:	e8 07 00 00 00       	call   10477c <tlb_invalidate>
    return 0;
  104775:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10477a:	c9                   	leave  
  10477b:	c3                   	ret    

0010477c <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10477c:	55                   	push   %ebp
  10477d:	89 e5                	mov    %esp,%ebp
  10477f:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104782:	0f 20 d8             	mov    %cr3,%eax
  104785:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104788:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  10478b:	89 c2                	mov    %eax,%edx
  10478d:	8b 45 08             	mov    0x8(%ebp),%eax
  104790:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104793:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10479a:	77 23                	ja     1047bf <tlb_invalidate+0x43>
  10479c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10479f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047a3:	c7 44 24 08 58 6b 10 	movl   $0x106b58,0x8(%esp)
  1047aa:	00 
  1047ab:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  1047b2:	00 
  1047b3:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1047ba:	e8 0e c5 ff ff       	call   100ccd <__panic>
  1047bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047c2:	05 00 00 00 40       	add    $0x40000000,%eax
  1047c7:	39 c2                	cmp    %eax,%edx
  1047c9:	75 0c                	jne    1047d7 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  1047cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1047d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047d4:	0f 01 38             	invlpg (%eax)
    }
}
  1047d7:	c9                   	leave  
  1047d8:	c3                   	ret    

001047d9 <check_alloc_page>:

static void
check_alloc_page(void) {
  1047d9:	55                   	push   %ebp
  1047da:	89 e5                	mov    %esp,%ebp
  1047dc:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1047df:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1047e4:	8b 40 18             	mov    0x18(%eax),%eax
  1047e7:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1047e9:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  1047f0:	e8 47 bb ff ff       	call   10033c <cprintf>
}
  1047f5:	c9                   	leave  
  1047f6:	c3                   	ret    

001047f7 <check_pgdir>:

static void
check_pgdir(void) {
  1047f7:	55                   	push   %ebp
  1047f8:	89 e5                	mov    %esp,%ebp
  1047fa:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1047fd:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104802:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104807:	76 24                	jbe    10482d <check_pgdir+0x36>
  104809:	c7 44 24 0c fb 6b 10 	movl   $0x106bfb,0xc(%esp)
  104810:	00 
  104811:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104818:	00 
  104819:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104820:	00 
  104821:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104828:	e8 a0 c4 ff ff       	call   100ccd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10482d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104832:	85 c0                	test   %eax,%eax
  104834:	74 0e                	je     104844 <check_pgdir+0x4d>
  104836:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10483b:	25 ff 0f 00 00       	and    $0xfff,%eax
  104840:	85 c0                	test   %eax,%eax
  104842:	74 24                	je     104868 <check_pgdir+0x71>
  104844:	c7 44 24 0c 18 6c 10 	movl   $0x106c18,0xc(%esp)
  10484b:	00 
  10484c:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104853:	00 
  104854:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  10485b:	00 
  10485c:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104863:	e8 65 c4 ff ff       	call   100ccd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104868:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10486d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104874:	00 
  104875:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10487c:	00 
  10487d:	89 04 24             	mov    %eax,(%esp)
  104880:	e8 40 fd ff ff       	call   1045c5 <get_page>
  104885:	85 c0                	test   %eax,%eax
  104887:	74 24                	je     1048ad <check_pgdir+0xb6>
  104889:	c7 44 24 0c 50 6c 10 	movl   $0x106c50,0xc(%esp)
  104890:	00 
  104891:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104898:	00 
  104899:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  1048a0:	00 
  1048a1:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1048a8:	e8 20 c4 ff ff       	call   100ccd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1048ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048b4:	e8 95 f4 ff ff       	call   103d4e <alloc_pages>
  1048b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1048bc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1048c8:	00 
  1048c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048d0:	00 
  1048d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1048d4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048d8:	89 04 24             	mov    %eax,(%esp)
  1048db:	e8 e3 fd ff ff       	call   1046c3 <page_insert>
  1048e0:	85 c0                	test   %eax,%eax
  1048e2:	74 24                	je     104908 <check_pgdir+0x111>
  1048e4:	c7 44 24 0c 78 6c 10 	movl   $0x106c78,0xc(%esp)
  1048eb:	00 
  1048ec:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  1048f3:	00 
  1048f4:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  1048fb:	00 
  1048fc:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104903:	e8 c5 c3 ff ff       	call   100ccd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104908:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10490d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104914:	00 
  104915:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10491c:	00 
  10491d:	89 04 24             	mov    %eax,(%esp)
  104920:	e8 68 fb ff ff       	call   10448d <get_pte>
  104925:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104928:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10492c:	75 24                	jne    104952 <check_pgdir+0x15b>
  10492e:	c7 44 24 0c a4 6c 10 	movl   $0x106ca4,0xc(%esp)
  104935:	00 
  104936:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  10493d:	00 
  10493e:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104945:	00 
  104946:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  10494d:	e8 7b c3 ff ff       	call   100ccd <__panic>
    assert(pa2page(*ptep) == p1);
  104952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104955:	8b 00                	mov    (%eax),%eax
  104957:	89 04 24             	mov    %eax,(%esp)
  10495a:	e8 09 f1 ff ff       	call   103a68 <pa2page>
  10495f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104962:	74 24                	je     104988 <check_pgdir+0x191>
  104964:	c7 44 24 0c d1 6c 10 	movl   $0x106cd1,0xc(%esp)
  10496b:	00 
  10496c:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104973:	00 
  104974:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  10497b:	00 
  10497c:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104983:	e8 45 c3 ff ff       	call   100ccd <__panic>
    assert(page_ref(p1) == 1);
  104988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10498b:	89 04 24             	mov    %eax,(%esp)
  10498e:	e8 b6 f1 ff ff       	call   103b49 <page_ref>
  104993:	83 f8 01             	cmp    $0x1,%eax
  104996:	74 24                	je     1049bc <check_pgdir+0x1c5>
  104998:	c7 44 24 0c e6 6c 10 	movl   $0x106ce6,0xc(%esp)
  10499f:	00 
  1049a0:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  1049a7:	00 
  1049a8:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  1049af:	00 
  1049b0:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1049b7:	e8 11 c3 ff ff       	call   100ccd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1049bc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049c1:	8b 00                	mov    (%eax),%eax
  1049c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1049c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1049cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049ce:	c1 e8 0c             	shr    $0xc,%eax
  1049d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1049d4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1049d9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1049dc:	72 23                	jb     104a01 <check_pgdir+0x20a>
  1049de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1049e5:	c7 44 24 08 b4 6a 10 	movl   $0x106ab4,0x8(%esp)
  1049ec:	00 
  1049ed:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  1049f4:	00 
  1049f5:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1049fc:	e8 cc c2 ff ff       	call   100ccd <__panic>
  104a01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a04:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104a09:	83 c0 04             	add    $0x4,%eax
  104a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104a0f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a14:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a1b:	00 
  104a1c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a23:	00 
  104a24:	89 04 24             	mov    %eax,(%esp)
  104a27:	e8 61 fa ff ff       	call   10448d <get_pte>
  104a2c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104a2f:	74 24                	je     104a55 <check_pgdir+0x25e>
  104a31:	c7 44 24 0c f8 6c 10 	movl   $0x106cf8,0xc(%esp)
  104a38:	00 
  104a39:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104a40:	00 
  104a41:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104a48:	00 
  104a49:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104a50:	e8 78 c2 ff ff       	call   100ccd <__panic>

    p2 = alloc_page();
  104a55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a5c:	e8 ed f2 ff ff       	call   103d4e <alloc_pages>
  104a61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104a64:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a69:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a70:	00 
  104a71:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a78:	00 
  104a79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a7c:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a80:	89 04 24             	mov    %eax,(%esp)
  104a83:	e8 3b fc ff ff       	call   1046c3 <page_insert>
  104a88:	85 c0                	test   %eax,%eax
  104a8a:	74 24                	je     104ab0 <check_pgdir+0x2b9>
  104a8c:	c7 44 24 0c 20 6d 10 	movl   $0x106d20,0xc(%esp)
  104a93:	00 
  104a94:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104a9b:	00 
  104a9c:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104aa3:	00 
  104aa4:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104aab:	e8 1d c2 ff ff       	call   100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104ab0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ab5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104abc:	00 
  104abd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ac4:	00 
  104ac5:	89 04 24             	mov    %eax,(%esp)
  104ac8:	e8 c0 f9 ff ff       	call   10448d <get_pte>
  104acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ad0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ad4:	75 24                	jne    104afa <check_pgdir+0x303>
  104ad6:	c7 44 24 0c 58 6d 10 	movl   $0x106d58,0xc(%esp)
  104add:	00 
  104ade:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104ae5:	00 
  104ae6:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104aed:	00 
  104aee:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104af5:	e8 d3 c1 ff ff       	call   100ccd <__panic>
    assert(*ptep & PTE_U);
  104afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104afd:	8b 00                	mov    (%eax),%eax
  104aff:	83 e0 04             	and    $0x4,%eax
  104b02:	85 c0                	test   %eax,%eax
  104b04:	75 24                	jne    104b2a <check_pgdir+0x333>
  104b06:	c7 44 24 0c 88 6d 10 	movl   $0x106d88,0xc(%esp)
  104b0d:	00 
  104b0e:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104b15:	00 
  104b16:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104b1d:	00 
  104b1e:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104b25:	e8 a3 c1 ff ff       	call   100ccd <__panic>
    assert(*ptep & PTE_W);
  104b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b2d:	8b 00                	mov    (%eax),%eax
  104b2f:	83 e0 02             	and    $0x2,%eax
  104b32:	85 c0                	test   %eax,%eax
  104b34:	75 24                	jne    104b5a <check_pgdir+0x363>
  104b36:	c7 44 24 0c 96 6d 10 	movl   $0x106d96,0xc(%esp)
  104b3d:	00 
  104b3e:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104b45:	00 
  104b46:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104b4d:	00 
  104b4e:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104b55:	e8 73 c1 ff ff       	call   100ccd <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104b5a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b5f:	8b 00                	mov    (%eax),%eax
  104b61:	83 e0 04             	and    $0x4,%eax
  104b64:	85 c0                	test   %eax,%eax
  104b66:	75 24                	jne    104b8c <check_pgdir+0x395>
  104b68:	c7 44 24 0c a4 6d 10 	movl   $0x106da4,0xc(%esp)
  104b6f:	00 
  104b70:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104b77:	00 
  104b78:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104b7f:	00 
  104b80:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104b87:	e8 41 c1 ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 1);
  104b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b8f:	89 04 24             	mov    %eax,(%esp)
  104b92:	e8 b2 ef ff ff       	call   103b49 <page_ref>
  104b97:	83 f8 01             	cmp    $0x1,%eax
  104b9a:	74 24                	je     104bc0 <check_pgdir+0x3c9>
  104b9c:	c7 44 24 0c ba 6d 10 	movl   $0x106dba,0xc(%esp)
  104ba3:	00 
  104ba4:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104bab:	00 
  104bac:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104bb3:	00 
  104bb4:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104bbb:	e8 0d c1 ff ff       	call   100ccd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104bc0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104bc5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104bcc:	00 
  104bcd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104bd4:	00 
  104bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104bd8:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bdc:	89 04 24             	mov    %eax,(%esp)
  104bdf:	e8 df fa ff ff       	call   1046c3 <page_insert>
  104be4:	85 c0                	test   %eax,%eax
  104be6:	74 24                	je     104c0c <check_pgdir+0x415>
  104be8:	c7 44 24 0c cc 6d 10 	movl   $0x106dcc,0xc(%esp)
  104bef:	00 
  104bf0:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104bf7:	00 
  104bf8:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104bff:	00 
  104c00:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104c07:	e8 c1 c0 ff ff       	call   100ccd <__panic>
    assert(page_ref(p1) == 2);
  104c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c0f:	89 04 24             	mov    %eax,(%esp)
  104c12:	e8 32 ef ff ff       	call   103b49 <page_ref>
  104c17:	83 f8 02             	cmp    $0x2,%eax
  104c1a:	74 24                	je     104c40 <check_pgdir+0x449>
  104c1c:	c7 44 24 0c f8 6d 10 	movl   $0x106df8,0xc(%esp)
  104c23:	00 
  104c24:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104c2b:	00 
  104c2c:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104c33:	00 
  104c34:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104c3b:	e8 8d c0 ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 0);
  104c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c43:	89 04 24             	mov    %eax,(%esp)
  104c46:	e8 fe ee ff ff       	call   103b49 <page_ref>
  104c4b:	85 c0                	test   %eax,%eax
  104c4d:	74 24                	je     104c73 <check_pgdir+0x47c>
  104c4f:	c7 44 24 0c 0a 6e 10 	movl   $0x106e0a,0xc(%esp)
  104c56:	00 
  104c57:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104c5e:	00 
  104c5f:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104c66:	00 
  104c67:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104c6e:	e8 5a c0 ff ff       	call   100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c73:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c78:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c7f:	00 
  104c80:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c87:	00 
  104c88:	89 04 24             	mov    %eax,(%esp)
  104c8b:	e8 fd f7 ff ff       	call   10448d <get_pte>
  104c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c97:	75 24                	jne    104cbd <check_pgdir+0x4c6>
  104c99:	c7 44 24 0c 58 6d 10 	movl   $0x106d58,0xc(%esp)
  104ca0:	00 
  104ca1:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104ca8:	00 
  104ca9:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104cb0:	00 
  104cb1:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104cb8:	e8 10 c0 ff ff       	call   100ccd <__panic>
    assert(pa2page(*ptep) == p1);
  104cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cc0:	8b 00                	mov    (%eax),%eax
  104cc2:	89 04 24             	mov    %eax,(%esp)
  104cc5:	e8 9e ed ff ff       	call   103a68 <pa2page>
  104cca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104ccd:	74 24                	je     104cf3 <check_pgdir+0x4fc>
  104ccf:	c7 44 24 0c d1 6c 10 	movl   $0x106cd1,0xc(%esp)
  104cd6:	00 
  104cd7:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104cde:	00 
  104cdf:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104ce6:	00 
  104ce7:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104cee:	e8 da bf ff ff       	call   100ccd <__panic>
    assert((*ptep & PTE_U) == 0);
  104cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cf6:	8b 00                	mov    (%eax),%eax
  104cf8:	83 e0 04             	and    $0x4,%eax
  104cfb:	85 c0                	test   %eax,%eax
  104cfd:	74 24                	je     104d23 <check_pgdir+0x52c>
  104cff:	c7 44 24 0c 1c 6e 10 	movl   $0x106e1c,0xc(%esp)
  104d06:	00 
  104d07:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104d0e:	00 
  104d0f:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104d16:	00 
  104d17:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104d1e:	e8 aa bf ff ff       	call   100ccd <__panic>

    page_remove(boot_pgdir, 0x0);
  104d23:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d2f:	00 
  104d30:	89 04 24             	mov    %eax,(%esp)
  104d33:	e8 47 f9 ff ff       	call   10467f <page_remove>
    assert(page_ref(p1) == 1);
  104d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d3b:	89 04 24             	mov    %eax,(%esp)
  104d3e:	e8 06 ee ff ff       	call   103b49 <page_ref>
  104d43:	83 f8 01             	cmp    $0x1,%eax
  104d46:	74 24                	je     104d6c <check_pgdir+0x575>
  104d48:	c7 44 24 0c e6 6c 10 	movl   $0x106ce6,0xc(%esp)
  104d4f:	00 
  104d50:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104d57:	00 
  104d58:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104d5f:	00 
  104d60:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104d67:	e8 61 bf ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 0);
  104d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d6f:	89 04 24             	mov    %eax,(%esp)
  104d72:	e8 d2 ed ff ff       	call   103b49 <page_ref>
  104d77:	85 c0                	test   %eax,%eax
  104d79:	74 24                	je     104d9f <check_pgdir+0x5a8>
  104d7b:	c7 44 24 0c 0a 6e 10 	movl   $0x106e0a,0xc(%esp)
  104d82:	00 
  104d83:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104d8a:	00 
  104d8b:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104d92:	00 
  104d93:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104d9a:	e8 2e bf ff ff       	call   100ccd <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d9f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104da4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104dab:	00 
  104dac:	89 04 24             	mov    %eax,(%esp)
  104daf:	e8 cb f8 ff ff       	call   10467f <page_remove>
    assert(page_ref(p1) == 0);
  104db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104db7:	89 04 24             	mov    %eax,(%esp)
  104dba:	e8 8a ed ff ff       	call   103b49 <page_ref>
  104dbf:	85 c0                	test   %eax,%eax
  104dc1:	74 24                	je     104de7 <check_pgdir+0x5f0>
  104dc3:	c7 44 24 0c 31 6e 10 	movl   $0x106e31,0xc(%esp)
  104dca:	00 
  104dcb:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104dd2:	00 
  104dd3:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104dda:	00 
  104ddb:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104de2:	e8 e6 be ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 0);
  104de7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dea:	89 04 24             	mov    %eax,(%esp)
  104ded:	e8 57 ed ff ff       	call   103b49 <page_ref>
  104df2:	85 c0                	test   %eax,%eax
  104df4:	74 24                	je     104e1a <check_pgdir+0x623>
  104df6:	c7 44 24 0c 0a 6e 10 	movl   $0x106e0a,0xc(%esp)
  104dfd:	00 
  104dfe:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104e05:	00 
  104e06:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104e0d:	00 
  104e0e:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104e15:	e8 b3 be ff ff       	call   100ccd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104e1a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e1f:	8b 00                	mov    (%eax),%eax
  104e21:	89 04 24             	mov    %eax,(%esp)
  104e24:	e8 3f ec ff ff       	call   103a68 <pa2page>
  104e29:	89 04 24             	mov    %eax,(%esp)
  104e2c:	e8 18 ed ff ff       	call   103b49 <page_ref>
  104e31:	83 f8 01             	cmp    $0x1,%eax
  104e34:	74 24                	je     104e5a <check_pgdir+0x663>
  104e36:	c7 44 24 0c 44 6e 10 	movl   $0x106e44,0xc(%esp)
  104e3d:	00 
  104e3e:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104e45:	00 
  104e46:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104e4d:	00 
  104e4e:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104e55:	e8 73 be ff ff       	call   100ccd <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104e5a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e5f:	8b 00                	mov    (%eax),%eax
  104e61:	89 04 24             	mov    %eax,(%esp)
  104e64:	e8 ff eb ff ff       	call   103a68 <pa2page>
  104e69:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e70:	00 
  104e71:	89 04 24             	mov    %eax,(%esp)
  104e74:	e8 0d ef ff ff       	call   103d86 <free_pages>
    boot_pgdir[0] = 0;
  104e79:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e84:	c7 04 24 6a 6e 10 00 	movl   $0x106e6a,(%esp)
  104e8b:	e8 ac b4 ff ff       	call   10033c <cprintf>
}
  104e90:	c9                   	leave  
  104e91:	c3                   	ret    

00104e92 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e92:	55                   	push   %ebp
  104e93:	89 e5                	mov    %esp,%ebp
  104e95:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e9f:	e9 ca 00 00 00       	jmp    104f6e <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ead:	c1 e8 0c             	shr    $0xc,%eax
  104eb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104eb3:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104eb8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104ebb:	72 23                	jb     104ee0 <check_boot_pgdir+0x4e>
  104ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ec0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104ec4:	c7 44 24 08 b4 6a 10 	movl   $0x106ab4,0x8(%esp)
  104ecb:	00 
  104ecc:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104ed3:	00 
  104ed4:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104edb:	e8 ed bd ff ff       	call   100ccd <__panic>
  104ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ee3:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104ee8:	89 c2                	mov    %eax,%edx
  104eea:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104eef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ef6:	00 
  104ef7:	89 54 24 04          	mov    %edx,0x4(%esp)
  104efb:	89 04 24             	mov    %eax,(%esp)
  104efe:	e8 8a f5 ff ff       	call   10448d <get_pte>
  104f03:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104f06:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104f0a:	75 24                	jne    104f30 <check_boot_pgdir+0x9e>
  104f0c:	c7 44 24 0c 84 6e 10 	movl   $0x106e84,0xc(%esp)
  104f13:	00 
  104f14:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104f1b:	00 
  104f1c:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104f23:	00 
  104f24:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104f2b:	e8 9d bd ff ff       	call   100ccd <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104f30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f33:	8b 00                	mov    (%eax),%eax
  104f35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f3a:	89 c2                	mov    %eax,%edx
  104f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f3f:	39 c2                	cmp    %eax,%edx
  104f41:	74 24                	je     104f67 <check_boot_pgdir+0xd5>
  104f43:	c7 44 24 0c c1 6e 10 	movl   $0x106ec1,0xc(%esp)
  104f4a:	00 
  104f4b:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104f52:	00 
  104f53:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  104f5a:	00 
  104f5b:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104f62:	e8 66 bd ff ff       	call   100ccd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104f67:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f71:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104f76:	39 c2                	cmp    %eax,%edx
  104f78:	0f 82 26 ff ff ff    	jb     104ea4 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f7e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f83:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f88:	8b 00                	mov    (%eax),%eax
  104f8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f8f:	89 c2                	mov    %eax,%edx
  104f91:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f99:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104fa0:	77 23                	ja     104fc5 <check_boot_pgdir+0x133>
  104fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fa5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104fa9:	c7 44 24 08 58 6b 10 	movl   $0x106b58,0x8(%esp)
  104fb0:	00 
  104fb1:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  104fb8:	00 
  104fb9:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104fc0:	e8 08 bd ff ff       	call   100ccd <__panic>
  104fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fc8:	05 00 00 00 40       	add    $0x40000000,%eax
  104fcd:	39 c2                	cmp    %eax,%edx
  104fcf:	74 24                	je     104ff5 <check_boot_pgdir+0x163>
  104fd1:	c7 44 24 0c d8 6e 10 	movl   $0x106ed8,0xc(%esp)
  104fd8:	00 
  104fd9:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  104fe0:	00 
  104fe1:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  104fe8:	00 
  104fe9:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  104ff0:	e8 d8 bc ff ff       	call   100ccd <__panic>

    assert(boot_pgdir[0] == 0);
  104ff5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ffa:	8b 00                	mov    (%eax),%eax
  104ffc:	85 c0                	test   %eax,%eax
  104ffe:	74 24                	je     105024 <check_boot_pgdir+0x192>
  105000:	c7 44 24 0c 0c 6f 10 	movl   $0x106f0c,0xc(%esp)
  105007:	00 
  105008:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  10500f:	00 
  105010:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  105017:	00 
  105018:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  10501f:	e8 a9 bc ff ff       	call   100ccd <__panic>

    struct Page *p;
    p = alloc_page();
  105024:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10502b:	e8 1e ed ff ff       	call   103d4e <alloc_pages>
  105030:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105033:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105038:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10503f:	00 
  105040:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105047:	00 
  105048:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10504b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10504f:	89 04 24             	mov    %eax,(%esp)
  105052:	e8 6c f6 ff ff       	call   1046c3 <page_insert>
  105057:	85 c0                	test   %eax,%eax
  105059:	74 24                	je     10507f <check_boot_pgdir+0x1ed>
  10505b:	c7 44 24 0c 20 6f 10 	movl   $0x106f20,0xc(%esp)
  105062:	00 
  105063:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  10506a:	00 
  10506b:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  105072:	00 
  105073:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  10507a:	e8 4e bc ff ff       	call   100ccd <__panic>
    assert(page_ref(p) == 1);
  10507f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105082:	89 04 24             	mov    %eax,(%esp)
  105085:	e8 bf ea ff ff       	call   103b49 <page_ref>
  10508a:	83 f8 01             	cmp    $0x1,%eax
  10508d:	74 24                	je     1050b3 <check_boot_pgdir+0x221>
  10508f:	c7 44 24 0c 4e 6f 10 	movl   $0x106f4e,0xc(%esp)
  105096:	00 
  105097:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  10509e:	00 
  10509f:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  1050a6:	00 
  1050a7:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1050ae:	e8 1a bc ff ff       	call   100ccd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1050b3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050b8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1050bf:	00 
  1050c0:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1050c7:	00 
  1050c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1050cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050cf:	89 04 24             	mov    %eax,(%esp)
  1050d2:	e8 ec f5 ff ff       	call   1046c3 <page_insert>
  1050d7:	85 c0                	test   %eax,%eax
  1050d9:	74 24                	je     1050ff <check_boot_pgdir+0x26d>
  1050db:	c7 44 24 0c 60 6f 10 	movl   $0x106f60,0xc(%esp)
  1050e2:	00 
  1050e3:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  1050ea:	00 
  1050eb:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  1050f2:	00 
  1050f3:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1050fa:	e8 ce bb ff ff       	call   100ccd <__panic>
    assert(page_ref(p) == 2);
  1050ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105102:	89 04 24             	mov    %eax,(%esp)
  105105:	e8 3f ea ff ff       	call   103b49 <page_ref>
  10510a:	83 f8 02             	cmp    $0x2,%eax
  10510d:	74 24                	je     105133 <check_boot_pgdir+0x2a1>
  10510f:	c7 44 24 0c 97 6f 10 	movl   $0x106f97,0xc(%esp)
  105116:	00 
  105117:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  10511e:	00 
  10511f:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  105126:	00 
  105127:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  10512e:	e8 9a bb ff ff       	call   100ccd <__panic>

    const char *str = "ucore: Hello world!!";
  105133:	c7 45 dc a8 6f 10 00 	movl   $0x106fa8,-0x24(%ebp)
    strcpy((void *)0x100, str);
  10513a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10513d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105141:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105148:	e8 1e 0a 00 00       	call   105b6b <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10514d:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105154:	00 
  105155:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10515c:	e8 83 0a 00 00       	call   105be4 <strcmp>
  105161:	85 c0                	test   %eax,%eax
  105163:	74 24                	je     105189 <check_boot_pgdir+0x2f7>
  105165:	c7 44 24 0c c0 6f 10 	movl   $0x106fc0,0xc(%esp)
  10516c:	00 
  10516d:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  105174:	00 
  105175:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
  10517c:	00 
  10517d:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  105184:	e8 44 bb ff ff       	call   100ccd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105189:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10518c:	89 04 24             	mov    %eax,(%esp)
  10518f:	e8 23 e9 ff ff       	call   103ab7 <page2kva>
  105194:	05 00 01 00 00       	add    $0x100,%eax
  105199:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10519c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051a3:	e8 6b 09 00 00       	call   105b13 <strlen>
  1051a8:	85 c0                	test   %eax,%eax
  1051aa:	74 24                	je     1051d0 <check_boot_pgdir+0x33e>
  1051ac:	c7 44 24 0c f8 6f 10 	movl   $0x106ff8,0xc(%esp)
  1051b3:	00 
  1051b4:	c7 44 24 08 a1 6b 10 	movl   $0x106ba1,0x8(%esp)
  1051bb:	00 
  1051bc:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
  1051c3:	00 
  1051c4:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1051cb:	e8 fd ba ff ff       	call   100ccd <__panic>

    free_page(p);
  1051d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051d7:	00 
  1051d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051db:	89 04 24             	mov    %eax,(%esp)
  1051de:	e8 a3 eb ff ff       	call   103d86 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  1051e3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051e8:	8b 00                	mov    (%eax),%eax
  1051ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1051ef:	89 04 24             	mov    %eax,(%esp)
  1051f2:	e8 71 e8 ff ff       	call   103a68 <pa2page>
  1051f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051fe:	00 
  1051ff:	89 04 24             	mov    %eax,(%esp)
  105202:	e8 7f eb ff ff       	call   103d86 <free_pages>
    boot_pgdir[0] = 0;
  105207:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10520c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105212:	c7 04 24 1c 70 10 00 	movl   $0x10701c,(%esp)
  105219:	e8 1e b1 ff ff       	call   10033c <cprintf>
}
  10521e:	c9                   	leave  
  10521f:	c3                   	ret    

00105220 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105220:	55                   	push   %ebp
  105221:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105223:	8b 45 08             	mov    0x8(%ebp),%eax
  105226:	83 e0 04             	and    $0x4,%eax
  105229:	85 c0                	test   %eax,%eax
  10522b:	74 07                	je     105234 <perm2str+0x14>
  10522d:	b8 75 00 00 00       	mov    $0x75,%eax
  105232:	eb 05                	jmp    105239 <perm2str+0x19>
  105234:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105239:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  10523e:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105245:	8b 45 08             	mov    0x8(%ebp),%eax
  105248:	83 e0 02             	and    $0x2,%eax
  10524b:	85 c0                	test   %eax,%eax
  10524d:	74 07                	je     105256 <perm2str+0x36>
  10524f:	b8 77 00 00 00       	mov    $0x77,%eax
  105254:	eb 05                	jmp    10525b <perm2str+0x3b>
  105256:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10525b:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  105260:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  105267:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  10526c:	5d                   	pop    %ebp
  10526d:	c3                   	ret    

0010526e <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10526e:	55                   	push   %ebp
  10526f:	89 e5                	mov    %esp,%ebp
  105271:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105274:	8b 45 10             	mov    0x10(%ebp),%eax
  105277:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10527a:	72 0a                	jb     105286 <get_pgtable_items+0x18>
        return 0;
  10527c:	b8 00 00 00 00       	mov    $0x0,%eax
  105281:	e9 9c 00 00 00       	jmp    105322 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105286:	eb 04                	jmp    10528c <get_pgtable_items+0x1e>
        start ++;
  105288:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  10528c:	8b 45 10             	mov    0x10(%ebp),%eax
  10528f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105292:	73 18                	jae    1052ac <get_pgtable_items+0x3e>
  105294:	8b 45 10             	mov    0x10(%ebp),%eax
  105297:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10529e:	8b 45 14             	mov    0x14(%ebp),%eax
  1052a1:	01 d0                	add    %edx,%eax
  1052a3:	8b 00                	mov    (%eax),%eax
  1052a5:	83 e0 01             	and    $0x1,%eax
  1052a8:	85 c0                	test   %eax,%eax
  1052aa:	74 dc                	je     105288 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1052ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1052af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052b2:	73 69                	jae    10531d <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1052b4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1052b8:	74 08                	je     1052c2 <get_pgtable_items+0x54>
            *left_store = start;
  1052ba:	8b 45 18             	mov    0x18(%ebp),%eax
  1052bd:	8b 55 10             	mov    0x10(%ebp),%edx
  1052c0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1052c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1052c5:	8d 50 01             	lea    0x1(%eax),%edx
  1052c8:	89 55 10             	mov    %edx,0x10(%ebp)
  1052cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052d2:	8b 45 14             	mov    0x14(%ebp),%eax
  1052d5:	01 d0                	add    %edx,%eax
  1052d7:	8b 00                	mov    (%eax),%eax
  1052d9:	83 e0 07             	and    $0x7,%eax
  1052dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052df:	eb 04                	jmp    1052e5 <get_pgtable_items+0x77>
            start ++;
  1052e1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1052e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052eb:	73 1d                	jae    10530a <get_pgtable_items+0x9c>
  1052ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1052f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052f7:	8b 45 14             	mov    0x14(%ebp),%eax
  1052fa:	01 d0                	add    %edx,%eax
  1052fc:	8b 00                	mov    (%eax),%eax
  1052fe:	83 e0 07             	and    $0x7,%eax
  105301:	89 c2                	mov    %eax,%edx
  105303:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105306:	39 c2                	cmp    %eax,%edx
  105308:	74 d7                	je     1052e1 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  10530a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10530e:	74 08                	je     105318 <get_pgtable_items+0xaa>
            *right_store = start;
  105310:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105313:	8b 55 10             	mov    0x10(%ebp),%edx
  105316:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105318:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10531b:	eb 05                	jmp    105322 <get_pgtable_items+0xb4>
    }
    return 0;
  10531d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105322:	c9                   	leave  
  105323:	c3                   	ret    

00105324 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105324:	55                   	push   %ebp
  105325:	89 e5                	mov    %esp,%ebp
  105327:	57                   	push   %edi
  105328:	56                   	push   %esi
  105329:	53                   	push   %ebx
  10532a:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10532d:	c7 04 24 3c 70 10 00 	movl   $0x10703c,(%esp)
  105334:	e8 03 b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  105339:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105340:	e9 fa 00 00 00       	jmp    10543f <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105345:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105348:	89 04 24             	mov    %eax,(%esp)
  10534b:	e8 d0 fe ff ff       	call   105220 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105350:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105353:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105356:	29 d1                	sub    %edx,%ecx
  105358:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10535a:	89 d6                	mov    %edx,%esi
  10535c:	c1 e6 16             	shl    $0x16,%esi
  10535f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105362:	89 d3                	mov    %edx,%ebx
  105364:	c1 e3 16             	shl    $0x16,%ebx
  105367:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10536a:	89 d1                	mov    %edx,%ecx
  10536c:	c1 e1 16             	shl    $0x16,%ecx
  10536f:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105372:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105375:	29 d7                	sub    %edx,%edi
  105377:	89 fa                	mov    %edi,%edx
  105379:	89 44 24 14          	mov    %eax,0x14(%esp)
  10537d:	89 74 24 10          	mov    %esi,0x10(%esp)
  105381:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105385:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105389:	89 54 24 04          	mov    %edx,0x4(%esp)
  10538d:	c7 04 24 6d 70 10 00 	movl   $0x10706d,(%esp)
  105394:	e8 a3 af ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105399:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10539c:	c1 e0 0a             	shl    $0xa,%eax
  10539f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053a2:	eb 54                	jmp    1053f8 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1053a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053a7:	89 04 24             	mov    %eax,(%esp)
  1053aa:	e8 71 fe ff ff       	call   105220 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1053af:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1053b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1053b5:	29 d1                	sub    %edx,%ecx
  1053b7:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1053b9:	89 d6                	mov    %edx,%esi
  1053bb:	c1 e6 0c             	shl    $0xc,%esi
  1053be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1053c1:	89 d3                	mov    %edx,%ebx
  1053c3:	c1 e3 0c             	shl    $0xc,%ebx
  1053c6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1053c9:	c1 e2 0c             	shl    $0xc,%edx
  1053cc:	89 d1                	mov    %edx,%ecx
  1053ce:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1053d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1053d4:	29 d7                	sub    %edx,%edi
  1053d6:	89 fa                	mov    %edi,%edx
  1053d8:	89 44 24 14          	mov    %eax,0x14(%esp)
  1053dc:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053ec:	c7 04 24 8c 70 10 00 	movl   $0x10708c,(%esp)
  1053f3:	e8 44 af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053f8:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1053fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105400:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105403:	89 ce                	mov    %ecx,%esi
  105405:	c1 e6 0a             	shl    $0xa,%esi
  105408:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10540b:	89 cb                	mov    %ecx,%ebx
  10540d:	c1 e3 0a             	shl    $0xa,%ebx
  105410:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105413:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105417:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10541a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10541e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105422:	89 44 24 08          	mov    %eax,0x8(%esp)
  105426:	89 74 24 04          	mov    %esi,0x4(%esp)
  10542a:	89 1c 24             	mov    %ebx,(%esp)
  10542d:	e8 3c fe ff ff       	call   10526e <get_pgtable_items>
  105432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105435:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105439:	0f 85 65 ff ff ff    	jne    1053a4 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10543f:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105447:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10544a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10544e:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105451:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105455:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105459:	89 44 24 08          	mov    %eax,0x8(%esp)
  10545d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105464:	00 
  105465:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10546c:	e8 fd fd ff ff       	call   10526e <get_pgtable_items>
  105471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105474:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105478:	0f 85 c7 fe ff ff    	jne    105345 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10547e:	c7 04 24 b0 70 10 00 	movl   $0x1070b0,(%esp)
  105485:	e8 b2 ae ff ff       	call   10033c <cprintf>
}
  10548a:	83 c4 4c             	add    $0x4c,%esp
  10548d:	5b                   	pop    %ebx
  10548e:	5e                   	pop    %esi
  10548f:	5f                   	pop    %edi
  105490:	5d                   	pop    %ebp
  105491:	c3                   	ret    

00105492 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105492:	55                   	push   %ebp
  105493:	89 e5                	mov    %esp,%ebp
  105495:	83 ec 58             	sub    $0x58,%esp
  105498:	8b 45 10             	mov    0x10(%ebp),%eax
  10549b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10549e:	8b 45 14             	mov    0x14(%ebp),%eax
  1054a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1054a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1054b0:	8b 45 18             	mov    0x18(%ebp),%eax
  1054b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1054c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1054c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1054cc:	74 1c                	je     1054ea <printnum+0x58>
  1054ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054d1:	ba 00 00 00 00       	mov    $0x0,%edx
  1054d6:	f7 75 e4             	divl   -0x1c(%ebp)
  1054d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1054dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054df:	ba 00 00 00 00       	mov    $0x0,%edx
  1054e4:	f7 75 e4             	divl   -0x1c(%ebp)
  1054e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054f0:	f7 75 e4             	divl   -0x1c(%ebp)
  1054f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1054f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1054ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105502:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105505:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105508:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10550b:	8b 45 18             	mov    0x18(%ebp),%eax
  10550e:	ba 00 00 00 00       	mov    $0x0,%edx
  105513:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105516:	77 56                	ja     10556e <printnum+0xdc>
  105518:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10551b:	72 05                	jb     105522 <printnum+0x90>
  10551d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105520:	77 4c                	ja     10556e <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105522:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105525:	8d 50 ff             	lea    -0x1(%eax),%edx
  105528:	8b 45 20             	mov    0x20(%ebp),%eax
  10552b:	89 44 24 18          	mov    %eax,0x18(%esp)
  10552f:	89 54 24 14          	mov    %edx,0x14(%esp)
  105533:	8b 45 18             	mov    0x18(%ebp),%eax
  105536:	89 44 24 10          	mov    %eax,0x10(%esp)
  10553a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10553d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105540:	89 44 24 08          	mov    %eax,0x8(%esp)
  105544:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105548:	8b 45 0c             	mov    0xc(%ebp),%eax
  10554b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10554f:	8b 45 08             	mov    0x8(%ebp),%eax
  105552:	89 04 24             	mov    %eax,(%esp)
  105555:	e8 38 ff ff ff       	call   105492 <printnum>
  10555a:	eb 1c                	jmp    105578 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10555c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10555f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105563:	8b 45 20             	mov    0x20(%ebp),%eax
  105566:	89 04 24             	mov    %eax,(%esp)
  105569:	8b 45 08             	mov    0x8(%ebp),%eax
  10556c:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10556e:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105572:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105576:	7f e4                	jg     10555c <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105578:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10557b:	05 64 71 10 00       	add    $0x107164,%eax
  105580:	0f b6 00             	movzbl (%eax),%eax
  105583:	0f be c0             	movsbl %al,%eax
  105586:	8b 55 0c             	mov    0xc(%ebp),%edx
  105589:	89 54 24 04          	mov    %edx,0x4(%esp)
  10558d:	89 04 24             	mov    %eax,(%esp)
  105590:	8b 45 08             	mov    0x8(%ebp),%eax
  105593:	ff d0                	call   *%eax
}
  105595:	c9                   	leave  
  105596:	c3                   	ret    

00105597 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105597:	55                   	push   %ebp
  105598:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10559a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10559e:	7e 14                	jle    1055b4 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1055a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a3:	8b 00                	mov    (%eax),%eax
  1055a5:	8d 48 08             	lea    0x8(%eax),%ecx
  1055a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1055ab:	89 0a                	mov    %ecx,(%edx)
  1055ad:	8b 50 04             	mov    0x4(%eax),%edx
  1055b0:	8b 00                	mov    (%eax),%eax
  1055b2:	eb 30                	jmp    1055e4 <getuint+0x4d>
    }
    else if (lflag) {
  1055b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055b8:	74 16                	je     1055d0 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1055ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1055bd:	8b 00                	mov    (%eax),%eax
  1055bf:	8d 48 04             	lea    0x4(%eax),%ecx
  1055c2:	8b 55 08             	mov    0x8(%ebp),%edx
  1055c5:	89 0a                	mov    %ecx,(%edx)
  1055c7:	8b 00                	mov    (%eax),%eax
  1055c9:	ba 00 00 00 00       	mov    $0x0,%edx
  1055ce:	eb 14                	jmp    1055e4 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1055d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d3:	8b 00                	mov    (%eax),%eax
  1055d5:	8d 48 04             	lea    0x4(%eax),%ecx
  1055d8:	8b 55 08             	mov    0x8(%ebp),%edx
  1055db:	89 0a                	mov    %ecx,(%edx)
  1055dd:	8b 00                	mov    (%eax),%eax
  1055df:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1055e4:	5d                   	pop    %ebp
  1055e5:	c3                   	ret    

001055e6 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1055e6:	55                   	push   %ebp
  1055e7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055e9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055ed:	7e 14                	jle    105603 <getint+0x1d>
        return va_arg(*ap, long long);
  1055ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1055f2:	8b 00                	mov    (%eax),%eax
  1055f4:	8d 48 08             	lea    0x8(%eax),%ecx
  1055f7:	8b 55 08             	mov    0x8(%ebp),%edx
  1055fa:	89 0a                	mov    %ecx,(%edx)
  1055fc:	8b 50 04             	mov    0x4(%eax),%edx
  1055ff:	8b 00                	mov    (%eax),%eax
  105601:	eb 28                	jmp    10562b <getint+0x45>
    }
    else if (lflag) {
  105603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105607:	74 12                	je     10561b <getint+0x35>
        return va_arg(*ap, long);
  105609:	8b 45 08             	mov    0x8(%ebp),%eax
  10560c:	8b 00                	mov    (%eax),%eax
  10560e:	8d 48 04             	lea    0x4(%eax),%ecx
  105611:	8b 55 08             	mov    0x8(%ebp),%edx
  105614:	89 0a                	mov    %ecx,(%edx)
  105616:	8b 00                	mov    (%eax),%eax
  105618:	99                   	cltd   
  105619:	eb 10                	jmp    10562b <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10561b:	8b 45 08             	mov    0x8(%ebp),%eax
  10561e:	8b 00                	mov    (%eax),%eax
  105620:	8d 48 04             	lea    0x4(%eax),%ecx
  105623:	8b 55 08             	mov    0x8(%ebp),%edx
  105626:	89 0a                	mov    %ecx,(%edx)
  105628:	8b 00                	mov    (%eax),%eax
  10562a:	99                   	cltd   
    }
}
  10562b:	5d                   	pop    %ebp
  10562c:	c3                   	ret    

0010562d <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10562d:	55                   	push   %ebp
  10562e:	89 e5                	mov    %esp,%ebp
  105630:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105633:	8d 45 14             	lea    0x14(%ebp),%eax
  105636:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10563c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105640:	8b 45 10             	mov    0x10(%ebp),%eax
  105643:	89 44 24 08          	mov    %eax,0x8(%esp)
  105647:	8b 45 0c             	mov    0xc(%ebp),%eax
  10564a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10564e:	8b 45 08             	mov    0x8(%ebp),%eax
  105651:	89 04 24             	mov    %eax,(%esp)
  105654:	e8 02 00 00 00       	call   10565b <vprintfmt>
    va_end(ap);
}
  105659:	c9                   	leave  
  10565a:	c3                   	ret    

0010565b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10565b:	55                   	push   %ebp
  10565c:	89 e5                	mov    %esp,%ebp
  10565e:	56                   	push   %esi
  10565f:	53                   	push   %ebx
  105660:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105663:	eb 18                	jmp    10567d <vprintfmt+0x22>
            if (ch == '\0') {
  105665:	85 db                	test   %ebx,%ebx
  105667:	75 05                	jne    10566e <vprintfmt+0x13>
                return;
  105669:	e9 d1 03 00 00       	jmp    105a3f <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  10566e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105671:	89 44 24 04          	mov    %eax,0x4(%esp)
  105675:	89 1c 24             	mov    %ebx,(%esp)
  105678:	8b 45 08             	mov    0x8(%ebp),%eax
  10567b:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10567d:	8b 45 10             	mov    0x10(%ebp),%eax
  105680:	8d 50 01             	lea    0x1(%eax),%edx
  105683:	89 55 10             	mov    %edx,0x10(%ebp)
  105686:	0f b6 00             	movzbl (%eax),%eax
  105689:	0f b6 d8             	movzbl %al,%ebx
  10568c:	83 fb 25             	cmp    $0x25,%ebx
  10568f:	75 d4                	jne    105665 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105691:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105695:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10569c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10569f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1056a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1056a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056ac:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1056af:	8b 45 10             	mov    0x10(%ebp),%eax
  1056b2:	8d 50 01             	lea    0x1(%eax),%edx
  1056b5:	89 55 10             	mov    %edx,0x10(%ebp)
  1056b8:	0f b6 00             	movzbl (%eax),%eax
  1056bb:	0f b6 d8             	movzbl %al,%ebx
  1056be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1056c1:	83 f8 55             	cmp    $0x55,%eax
  1056c4:	0f 87 44 03 00 00    	ja     105a0e <vprintfmt+0x3b3>
  1056ca:	8b 04 85 88 71 10 00 	mov    0x107188(,%eax,4),%eax
  1056d1:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1056d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1056d7:	eb d6                	jmp    1056af <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1056d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1056dd:	eb d0                	jmp    1056af <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1056e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056e9:	89 d0                	mov    %edx,%eax
  1056eb:	c1 e0 02             	shl    $0x2,%eax
  1056ee:	01 d0                	add    %edx,%eax
  1056f0:	01 c0                	add    %eax,%eax
  1056f2:	01 d8                	add    %ebx,%eax
  1056f4:	83 e8 30             	sub    $0x30,%eax
  1056f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1056fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1056fd:	0f b6 00             	movzbl (%eax),%eax
  105700:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105703:	83 fb 2f             	cmp    $0x2f,%ebx
  105706:	7e 0b                	jle    105713 <vprintfmt+0xb8>
  105708:	83 fb 39             	cmp    $0x39,%ebx
  10570b:	7f 06                	jg     105713 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10570d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105711:	eb d3                	jmp    1056e6 <vprintfmt+0x8b>
            goto process_precision;
  105713:	eb 33                	jmp    105748 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105715:	8b 45 14             	mov    0x14(%ebp),%eax
  105718:	8d 50 04             	lea    0x4(%eax),%edx
  10571b:	89 55 14             	mov    %edx,0x14(%ebp)
  10571e:	8b 00                	mov    (%eax),%eax
  105720:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105723:	eb 23                	jmp    105748 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105725:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105729:	79 0c                	jns    105737 <vprintfmt+0xdc>
                width = 0;
  10572b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105732:	e9 78 ff ff ff       	jmp    1056af <vprintfmt+0x54>
  105737:	e9 73 ff ff ff       	jmp    1056af <vprintfmt+0x54>

        case '#':
            altflag = 1;
  10573c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105743:	e9 67 ff ff ff       	jmp    1056af <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105748:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10574c:	79 12                	jns    105760 <vprintfmt+0x105>
                width = precision, precision = -1;
  10574e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105751:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105754:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10575b:	e9 4f ff ff ff       	jmp    1056af <vprintfmt+0x54>
  105760:	e9 4a ff ff ff       	jmp    1056af <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105765:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105769:	e9 41 ff ff ff       	jmp    1056af <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10576e:	8b 45 14             	mov    0x14(%ebp),%eax
  105771:	8d 50 04             	lea    0x4(%eax),%edx
  105774:	89 55 14             	mov    %edx,0x14(%ebp)
  105777:	8b 00                	mov    (%eax),%eax
  105779:	8b 55 0c             	mov    0xc(%ebp),%edx
  10577c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105780:	89 04 24             	mov    %eax,(%esp)
  105783:	8b 45 08             	mov    0x8(%ebp),%eax
  105786:	ff d0                	call   *%eax
            break;
  105788:	e9 ac 02 00 00       	jmp    105a39 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10578d:	8b 45 14             	mov    0x14(%ebp),%eax
  105790:	8d 50 04             	lea    0x4(%eax),%edx
  105793:	89 55 14             	mov    %edx,0x14(%ebp)
  105796:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105798:	85 db                	test   %ebx,%ebx
  10579a:	79 02                	jns    10579e <vprintfmt+0x143>
                err = -err;
  10579c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10579e:	83 fb 06             	cmp    $0x6,%ebx
  1057a1:	7f 0b                	jg     1057ae <vprintfmt+0x153>
  1057a3:	8b 34 9d 48 71 10 00 	mov    0x107148(,%ebx,4),%esi
  1057aa:	85 f6                	test   %esi,%esi
  1057ac:	75 23                	jne    1057d1 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1057ae:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1057b2:	c7 44 24 08 75 71 10 	movl   $0x107175,0x8(%esp)
  1057b9:	00 
  1057ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c4:	89 04 24             	mov    %eax,(%esp)
  1057c7:	e8 61 fe ff ff       	call   10562d <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1057cc:	e9 68 02 00 00       	jmp    105a39 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1057d1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1057d5:	c7 44 24 08 7e 71 10 	movl   $0x10717e,0x8(%esp)
  1057dc:	00 
  1057dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e7:	89 04 24             	mov    %eax,(%esp)
  1057ea:	e8 3e fe ff ff       	call   10562d <printfmt>
            }
            break;
  1057ef:	e9 45 02 00 00       	jmp    105a39 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1057f4:	8b 45 14             	mov    0x14(%ebp),%eax
  1057f7:	8d 50 04             	lea    0x4(%eax),%edx
  1057fa:	89 55 14             	mov    %edx,0x14(%ebp)
  1057fd:	8b 30                	mov    (%eax),%esi
  1057ff:	85 f6                	test   %esi,%esi
  105801:	75 05                	jne    105808 <vprintfmt+0x1ad>
                p = "(null)";
  105803:	be 81 71 10 00       	mov    $0x107181,%esi
            }
            if (width > 0 && padc != '-') {
  105808:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10580c:	7e 3e                	jle    10584c <vprintfmt+0x1f1>
  10580e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105812:	74 38                	je     10584c <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105814:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10581a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10581e:	89 34 24             	mov    %esi,(%esp)
  105821:	e8 15 03 00 00       	call   105b3b <strnlen>
  105826:	29 c3                	sub    %eax,%ebx
  105828:	89 d8                	mov    %ebx,%eax
  10582a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10582d:	eb 17                	jmp    105846 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  10582f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105833:	8b 55 0c             	mov    0xc(%ebp),%edx
  105836:	89 54 24 04          	mov    %edx,0x4(%esp)
  10583a:	89 04 24             	mov    %eax,(%esp)
  10583d:	8b 45 08             	mov    0x8(%ebp),%eax
  105840:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105842:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105846:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10584a:	7f e3                	jg     10582f <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10584c:	eb 38                	jmp    105886 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  10584e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105852:	74 1f                	je     105873 <vprintfmt+0x218>
  105854:	83 fb 1f             	cmp    $0x1f,%ebx
  105857:	7e 05                	jle    10585e <vprintfmt+0x203>
  105859:	83 fb 7e             	cmp    $0x7e,%ebx
  10585c:	7e 15                	jle    105873 <vprintfmt+0x218>
                    putch('?', putdat);
  10585e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105861:	89 44 24 04          	mov    %eax,0x4(%esp)
  105865:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10586c:	8b 45 08             	mov    0x8(%ebp),%eax
  10586f:	ff d0                	call   *%eax
  105871:	eb 0f                	jmp    105882 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105873:	8b 45 0c             	mov    0xc(%ebp),%eax
  105876:	89 44 24 04          	mov    %eax,0x4(%esp)
  10587a:	89 1c 24             	mov    %ebx,(%esp)
  10587d:	8b 45 08             	mov    0x8(%ebp),%eax
  105880:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105882:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105886:	89 f0                	mov    %esi,%eax
  105888:	8d 70 01             	lea    0x1(%eax),%esi
  10588b:	0f b6 00             	movzbl (%eax),%eax
  10588e:	0f be d8             	movsbl %al,%ebx
  105891:	85 db                	test   %ebx,%ebx
  105893:	74 10                	je     1058a5 <vprintfmt+0x24a>
  105895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105899:	78 b3                	js     10584e <vprintfmt+0x1f3>
  10589b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10589f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058a3:	79 a9                	jns    10584e <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1058a5:	eb 17                	jmp    1058be <vprintfmt+0x263>
                putch(' ', putdat);
  1058a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058ae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1058b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1058b8:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1058ba:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1058be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058c2:	7f e3                	jg     1058a7 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  1058c4:	e9 70 01 00 00       	jmp    105a39 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1058c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058d0:	8d 45 14             	lea    0x14(%ebp),%eax
  1058d3:	89 04 24             	mov    %eax,(%esp)
  1058d6:	e8 0b fd ff ff       	call   1055e6 <getint>
  1058db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058de:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1058e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058e7:	85 d2                	test   %edx,%edx
  1058e9:	79 26                	jns    105911 <vprintfmt+0x2b6>
                putch('-', putdat);
  1058eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1058f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1058fc:	ff d0                	call   *%eax
                num = -(long long)num;
  1058fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105901:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105904:	f7 d8                	neg    %eax
  105906:	83 d2 00             	adc    $0x0,%edx
  105909:	f7 da                	neg    %edx
  10590b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10590e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105911:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105918:	e9 a8 00 00 00       	jmp    1059c5 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10591d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105920:	89 44 24 04          	mov    %eax,0x4(%esp)
  105924:	8d 45 14             	lea    0x14(%ebp),%eax
  105927:	89 04 24             	mov    %eax,(%esp)
  10592a:	e8 68 fc ff ff       	call   105597 <getuint>
  10592f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105932:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105935:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10593c:	e9 84 00 00 00       	jmp    1059c5 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105941:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105944:	89 44 24 04          	mov    %eax,0x4(%esp)
  105948:	8d 45 14             	lea    0x14(%ebp),%eax
  10594b:	89 04 24             	mov    %eax,(%esp)
  10594e:	e8 44 fc ff ff       	call   105597 <getuint>
  105953:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105956:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105959:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105960:	eb 63                	jmp    1059c5 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105962:	8b 45 0c             	mov    0xc(%ebp),%eax
  105965:	89 44 24 04          	mov    %eax,0x4(%esp)
  105969:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105970:	8b 45 08             	mov    0x8(%ebp),%eax
  105973:	ff d0                	call   *%eax
            putch('x', putdat);
  105975:	8b 45 0c             	mov    0xc(%ebp),%eax
  105978:	89 44 24 04          	mov    %eax,0x4(%esp)
  10597c:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105983:	8b 45 08             	mov    0x8(%ebp),%eax
  105986:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105988:	8b 45 14             	mov    0x14(%ebp),%eax
  10598b:	8d 50 04             	lea    0x4(%eax),%edx
  10598e:	89 55 14             	mov    %edx,0x14(%ebp)
  105991:	8b 00                	mov    (%eax),%eax
  105993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10599d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1059a4:	eb 1f                	jmp    1059c5 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1059a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ad:	8d 45 14             	lea    0x14(%ebp),%eax
  1059b0:	89 04 24             	mov    %eax,(%esp)
  1059b3:	e8 df fb ff ff       	call   105597 <getuint>
  1059b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1059be:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1059c5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1059c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059cc:	89 54 24 18          	mov    %edx,0x18(%esp)
  1059d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1059d3:	89 54 24 14          	mov    %edx,0x14(%esp)
  1059d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1059db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1059e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f3:	89 04 24             	mov    %eax,(%esp)
  1059f6:	e8 97 fa ff ff       	call   105492 <printnum>
            break;
  1059fb:	eb 3c                	jmp    105a39 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1059fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a04:	89 1c 24             	mov    %ebx,(%esp)
  105a07:	8b 45 08             	mov    0x8(%ebp),%eax
  105a0a:	ff d0                	call   *%eax
            break;
  105a0c:	eb 2b                	jmp    105a39 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a11:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a15:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a1f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105a21:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105a25:	eb 04                	jmp    105a2b <vprintfmt+0x3d0>
  105a27:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105a2b:	8b 45 10             	mov    0x10(%ebp),%eax
  105a2e:	83 e8 01             	sub    $0x1,%eax
  105a31:	0f b6 00             	movzbl (%eax),%eax
  105a34:	3c 25                	cmp    $0x25,%al
  105a36:	75 ef                	jne    105a27 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105a38:	90                   	nop
        }
    }
  105a39:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105a3a:	e9 3e fc ff ff       	jmp    10567d <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105a3f:	83 c4 40             	add    $0x40,%esp
  105a42:	5b                   	pop    %ebx
  105a43:	5e                   	pop    %esi
  105a44:	5d                   	pop    %ebp
  105a45:	c3                   	ret    

00105a46 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105a46:	55                   	push   %ebp
  105a47:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a4c:	8b 40 08             	mov    0x8(%eax),%eax
  105a4f:	8d 50 01             	lea    0x1(%eax),%edx
  105a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a55:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a5b:	8b 10                	mov    (%eax),%edx
  105a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a60:	8b 40 04             	mov    0x4(%eax),%eax
  105a63:	39 c2                	cmp    %eax,%edx
  105a65:	73 12                	jae    105a79 <sprintputch+0x33>
        *b->buf ++ = ch;
  105a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a6a:	8b 00                	mov    (%eax),%eax
  105a6c:	8d 48 01             	lea    0x1(%eax),%ecx
  105a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a72:	89 0a                	mov    %ecx,(%edx)
  105a74:	8b 55 08             	mov    0x8(%ebp),%edx
  105a77:	88 10                	mov    %dl,(%eax)
    }
}
  105a79:	5d                   	pop    %ebp
  105a7a:	c3                   	ret    

00105a7b <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105a7b:	55                   	push   %ebp
  105a7c:	89 e5                	mov    %esp,%ebp
  105a7e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a81:	8d 45 14             	lea    0x14(%ebp),%eax
  105a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a8e:	8b 45 10             	mov    0x10(%ebp),%eax
  105a91:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a9f:	89 04 24             	mov    %eax,(%esp)
  105aa2:	e8 08 00 00 00       	call   105aaf <vsnprintf>
  105aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105aad:	c9                   	leave  
  105aae:	c3                   	ret    

00105aaf <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105aaf:	55                   	push   %ebp
  105ab0:	89 e5                	mov    %esp,%ebp
  105ab2:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105abe:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac4:	01 d0                	add    %edx,%eax
  105ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ac9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105ad0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105ad4:	74 0a                	je     105ae0 <vsnprintf+0x31>
  105ad6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105adc:	39 c2                	cmp    %eax,%edx
  105ade:	76 07                	jbe    105ae7 <vsnprintf+0x38>
        return -E_INVAL;
  105ae0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105ae5:	eb 2a                	jmp    105b11 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  105aea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105aee:	8b 45 10             	mov    0x10(%ebp),%eax
  105af1:	89 44 24 08          	mov    %eax,0x8(%esp)
  105af5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105afc:	c7 04 24 46 5a 10 00 	movl   $0x105a46,(%esp)
  105b03:	e8 53 fb ff ff       	call   10565b <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b0b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b11:	c9                   	leave  
  105b12:	c3                   	ret    

00105b13 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105b13:	55                   	push   %ebp
  105b14:	89 e5                	mov    %esp,%ebp
  105b16:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105b20:	eb 04                	jmp    105b26 <strlen+0x13>
        cnt ++;
  105b22:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105b26:	8b 45 08             	mov    0x8(%ebp),%eax
  105b29:	8d 50 01             	lea    0x1(%eax),%edx
  105b2c:	89 55 08             	mov    %edx,0x8(%ebp)
  105b2f:	0f b6 00             	movzbl (%eax),%eax
  105b32:	84 c0                	test   %al,%al
  105b34:	75 ec                	jne    105b22 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105b36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b39:	c9                   	leave  
  105b3a:	c3                   	ret    

00105b3b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105b3b:	55                   	push   %ebp
  105b3c:	89 e5                	mov    %esp,%ebp
  105b3e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b48:	eb 04                	jmp    105b4e <strnlen+0x13>
        cnt ++;
  105b4a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b51:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b54:	73 10                	jae    105b66 <strnlen+0x2b>
  105b56:	8b 45 08             	mov    0x8(%ebp),%eax
  105b59:	8d 50 01             	lea    0x1(%eax),%edx
  105b5c:	89 55 08             	mov    %edx,0x8(%ebp)
  105b5f:	0f b6 00             	movzbl (%eax),%eax
  105b62:	84 c0                	test   %al,%al
  105b64:	75 e4                	jne    105b4a <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105b66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b69:	c9                   	leave  
  105b6a:	c3                   	ret    

00105b6b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b6b:	55                   	push   %ebp
  105b6c:	89 e5                	mov    %esp,%ebp
  105b6e:	57                   	push   %edi
  105b6f:	56                   	push   %esi
  105b70:	83 ec 20             	sub    $0x20,%esp
  105b73:	8b 45 08             	mov    0x8(%ebp),%eax
  105b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b85:	89 d1                	mov    %edx,%ecx
  105b87:	89 c2                	mov    %eax,%edx
  105b89:	89 ce                	mov    %ecx,%esi
  105b8b:	89 d7                	mov    %edx,%edi
  105b8d:	ac                   	lods   %ds:(%esi),%al
  105b8e:	aa                   	stos   %al,%es:(%edi)
  105b8f:	84 c0                	test   %al,%al
  105b91:	75 fa                	jne    105b8d <strcpy+0x22>
  105b93:	89 fa                	mov    %edi,%edx
  105b95:	89 f1                	mov    %esi,%ecx
  105b97:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b9a:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105ba3:	83 c4 20             	add    $0x20,%esp
  105ba6:	5e                   	pop    %esi
  105ba7:	5f                   	pop    %edi
  105ba8:	5d                   	pop    %ebp
  105ba9:	c3                   	ret    

00105baa <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105baa:	55                   	push   %ebp
  105bab:	89 e5                	mov    %esp,%ebp
  105bad:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105bb6:	eb 21                	jmp    105bd9 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bbb:	0f b6 10             	movzbl (%eax),%edx
  105bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bc1:	88 10                	mov    %dl,(%eax)
  105bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bc6:	0f b6 00             	movzbl (%eax),%eax
  105bc9:	84 c0                	test   %al,%al
  105bcb:	74 04                	je     105bd1 <strncpy+0x27>
            src ++;
  105bcd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105bd1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105bd5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105bd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bdd:	75 d9                	jne    105bb8 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105bdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105be2:	c9                   	leave  
  105be3:	c3                   	ret    

00105be4 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105be4:	55                   	push   %ebp
  105be5:	89 e5                	mov    %esp,%ebp
  105be7:	57                   	push   %edi
  105be8:	56                   	push   %esi
  105be9:	83 ec 20             	sub    $0x20,%esp
  105bec:	8b 45 08             	mov    0x8(%ebp),%eax
  105bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bfe:	89 d1                	mov    %edx,%ecx
  105c00:	89 c2                	mov    %eax,%edx
  105c02:	89 ce                	mov    %ecx,%esi
  105c04:	89 d7                	mov    %edx,%edi
  105c06:	ac                   	lods   %ds:(%esi),%al
  105c07:	ae                   	scas   %es:(%edi),%al
  105c08:	75 08                	jne    105c12 <strcmp+0x2e>
  105c0a:	84 c0                	test   %al,%al
  105c0c:	75 f8                	jne    105c06 <strcmp+0x22>
  105c0e:	31 c0                	xor    %eax,%eax
  105c10:	eb 04                	jmp    105c16 <strcmp+0x32>
  105c12:	19 c0                	sbb    %eax,%eax
  105c14:	0c 01                	or     $0x1,%al
  105c16:	89 fa                	mov    %edi,%edx
  105c18:	89 f1                	mov    %esi,%ecx
  105c1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c1d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105c20:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105c23:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105c26:	83 c4 20             	add    $0x20,%esp
  105c29:	5e                   	pop    %esi
  105c2a:	5f                   	pop    %edi
  105c2b:	5d                   	pop    %ebp
  105c2c:	c3                   	ret    

00105c2d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105c2d:	55                   	push   %ebp
  105c2e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c30:	eb 0c                	jmp    105c3e <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105c32:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c36:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c3a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c42:	74 1a                	je     105c5e <strncmp+0x31>
  105c44:	8b 45 08             	mov    0x8(%ebp),%eax
  105c47:	0f b6 00             	movzbl (%eax),%eax
  105c4a:	84 c0                	test   %al,%al
  105c4c:	74 10                	je     105c5e <strncmp+0x31>
  105c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c51:	0f b6 10             	movzbl (%eax),%edx
  105c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c57:	0f b6 00             	movzbl (%eax),%eax
  105c5a:	38 c2                	cmp    %al,%dl
  105c5c:	74 d4                	je     105c32 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c62:	74 18                	je     105c7c <strncmp+0x4f>
  105c64:	8b 45 08             	mov    0x8(%ebp),%eax
  105c67:	0f b6 00             	movzbl (%eax),%eax
  105c6a:	0f b6 d0             	movzbl %al,%edx
  105c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c70:	0f b6 00             	movzbl (%eax),%eax
  105c73:	0f b6 c0             	movzbl %al,%eax
  105c76:	29 c2                	sub    %eax,%edx
  105c78:	89 d0                	mov    %edx,%eax
  105c7a:	eb 05                	jmp    105c81 <strncmp+0x54>
  105c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c81:	5d                   	pop    %ebp
  105c82:	c3                   	ret    

00105c83 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c83:	55                   	push   %ebp
  105c84:	89 e5                	mov    %esp,%ebp
  105c86:	83 ec 04             	sub    $0x4,%esp
  105c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c8c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c8f:	eb 14                	jmp    105ca5 <strchr+0x22>
        if (*s == c) {
  105c91:	8b 45 08             	mov    0x8(%ebp),%eax
  105c94:	0f b6 00             	movzbl (%eax),%eax
  105c97:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c9a:	75 05                	jne    105ca1 <strchr+0x1e>
            return (char *)s;
  105c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c9f:	eb 13                	jmp    105cb4 <strchr+0x31>
        }
        s ++;
  105ca1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca8:	0f b6 00             	movzbl (%eax),%eax
  105cab:	84 c0                	test   %al,%al
  105cad:	75 e2                	jne    105c91 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105caf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105cb4:	c9                   	leave  
  105cb5:	c3                   	ret    

00105cb6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105cb6:	55                   	push   %ebp
  105cb7:	89 e5                	mov    %esp,%ebp
  105cb9:	83 ec 04             	sub    $0x4,%esp
  105cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cbf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105cc2:	eb 11                	jmp    105cd5 <strfind+0x1f>
        if (*s == c) {
  105cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc7:	0f b6 00             	movzbl (%eax),%eax
  105cca:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105ccd:	75 02                	jne    105cd1 <strfind+0x1b>
            break;
  105ccf:	eb 0e                	jmp    105cdf <strfind+0x29>
        }
        s ++;
  105cd1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd8:	0f b6 00             	movzbl (%eax),%eax
  105cdb:	84 c0                	test   %al,%al
  105cdd:	75 e5                	jne    105cc4 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105cdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105ce2:	c9                   	leave  
  105ce3:	c3                   	ret    

00105ce4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105ce4:	55                   	push   %ebp
  105ce5:	89 e5                	mov    %esp,%ebp
  105ce7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105cf1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105cf8:	eb 04                	jmp    105cfe <strtol+0x1a>
        s ++;
  105cfa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  105d01:	0f b6 00             	movzbl (%eax),%eax
  105d04:	3c 20                	cmp    $0x20,%al
  105d06:	74 f2                	je     105cfa <strtol+0x16>
  105d08:	8b 45 08             	mov    0x8(%ebp),%eax
  105d0b:	0f b6 00             	movzbl (%eax),%eax
  105d0e:	3c 09                	cmp    $0x9,%al
  105d10:	74 e8                	je     105cfa <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105d12:	8b 45 08             	mov    0x8(%ebp),%eax
  105d15:	0f b6 00             	movzbl (%eax),%eax
  105d18:	3c 2b                	cmp    $0x2b,%al
  105d1a:	75 06                	jne    105d22 <strtol+0x3e>
        s ++;
  105d1c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d20:	eb 15                	jmp    105d37 <strtol+0x53>
    }
    else if (*s == '-') {
  105d22:	8b 45 08             	mov    0x8(%ebp),%eax
  105d25:	0f b6 00             	movzbl (%eax),%eax
  105d28:	3c 2d                	cmp    $0x2d,%al
  105d2a:	75 0b                	jne    105d37 <strtol+0x53>
        s ++, neg = 1;
  105d2c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d30:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105d37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d3b:	74 06                	je     105d43 <strtol+0x5f>
  105d3d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105d41:	75 24                	jne    105d67 <strtol+0x83>
  105d43:	8b 45 08             	mov    0x8(%ebp),%eax
  105d46:	0f b6 00             	movzbl (%eax),%eax
  105d49:	3c 30                	cmp    $0x30,%al
  105d4b:	75 1a                	jne    105d67 <strtol+0x83>
  105d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d50:	83 c0 01             	add    $0x1,%eax
  105d53:	0f b6 00             	movzbl (%eax),%eax
  105d56:	3c 78                	cmp    $0x78,%al
  105d58:	75 0d                	jne    105d67 <strtol+0x83>
        s += 2, base = 16;
  105d5a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105d5e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105d65:	eb 2a                	jmp    105d91 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105d67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d6b:	75 17                	jne    105d84 <strtol+0xa0>
  105d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d70:	0f b6 00             	movzbl (%eax),%eax
  105d73:	3c 30                	cmp    $0x30,%al
  105d75:	75 0d                	jne    105d84 <strtol+0xa0>
        s ++, base = 8;
  105d77:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d7b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d82:	eb 0d                	jmp    105d91 <strtol+0xad>
    }
    else if (base == 0) {
  105d84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d88:	75 07                	jne    105d91 <strtol+0xad>
        base = 10;
  105d8a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d91:	8b 45 08             	mov    0x8(%ebp),%eax
  105d94:	0f b6 00             	movzbl (%eax),%eax
  105d97:	3c 2f                	cmp    $0x2f,%al
  105d99:	7e 1b                	jle    105db6 <strtol+0xd2>
  105d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9e:	0f b6 00             	movzbl (%eax),%eax
  105da1:	3c 39                	cmp    $0x39,%al
  105da3:	7f 11                	jg     105db6 <strtol+0xd2>
            dig = *s - '0';
  105da5:	8b 45 08             	mov    0x8(%ebp),%eax
  105da8:	0f b6 00             	movzbl (%eax),%eax
  105dab:	0f be c0             	movsbl %al,%eax
  105dae:	83 e8 30             	sub    $0x30,%eax
  105db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105db4:	eb 48                	jmp    105dfe <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105db6:	8b 45 08             	mov    0x8(%ebp),%eax
  105db9:	0f b6 00             	movzbl (%eax),%eax
  105dbc:	3c 60                	cmp    $0x60,%al
  105dbe:	7e 1b                	jle    105ddb <strtol+0xf7>
  105dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc3:	0f b6 00             	movzbl (%eax),%eax
  105dc6:	3c 7a                	cmp    $0x7a,%al
  105dc8:	7f 11                	jg     105ddb <strtol+0xf7>
            dig = *s - 'a' + 10;
  105dca:	8b 45 08             	mov    0x8(%ebp),%eax
  105dcd:	0f b6 00             	movzbl (%eax),%eax
  105dd0:	0f be c0             	movsbl %al,%eax
  105dd3:	83 e8 57             	sub    $0x57,%eax
  105dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105dd9:	eb 23                	jmp    105dfe <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  105dde:	0f b6 00             	movzbl (%eax),%eax
  105de1:	3c 40                	cmp    $0x40,%al
  105de3:	7e 3d                	jle    105e22 <strtol+0x13e>
  105de5:	8b 45 08             	mov    0x8(%ebp),%eax
  105de8:	0f b6 00             	movzbl (%eax),%eax
  105deb:	3c 5a                	cmp    $0x5a,%al
  105ded:	7f 33                	jg     105e22 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105def:	8b 45 08             	mov    0x8(%ebp),%eax
  105df2:	0f b6 00             	movzbl (%eax),%eax
  105df5:	0f be c0             	movsbl %al,%eax
  105df8:	83 e8 37             	sub    $0x37,%eax
  105dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e01:	3b 45 10             	cmp    0x10(%ebp),%eax
  105e04:	7c 02                	jl     105e08 <strtol+0x124>
            break;
  105e06:	eb 1a                	jmp    105e22 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105e08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e0f:	0f af 45 10          	imul   0x10(%ebp),%eax
  105e13:	89 c2                	mov    %eax,%edx
  105e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e18:	01 d0                	add    %edx,%eax
  105e1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105e1d:	e9 6f ff ff ff       	jmp    105d91 <strtol+0xad>

    if (endptr) {
  105e22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105e26:	74 08                	je     105e30 <strtol+0x14c>
        *endptr = (char *) s;
  105e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  105e2e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105e30:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105e34:	74 07                	je     105e3d <strtol+0x159>
  105e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e39:	f7 d8                	neg    %eax
  105e3b:	eb 03                	jmp    105e40 <strtol+0x15c>
  105e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105e40:	c9                   	leave  
  105e41:	c3                   	ret    

00105e42 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105e42:	55                   	push   %ebp
  105e43:	89 e5                	mov    %esp,%ebp
  105e45:	57                   	push   %edi
  105e46:	83 ec 24             	sub    $0x24,%esp
  105e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e4c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105e4f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105e53:	8b 55 08             	mov    0x8(%ebp),%edx
  105e56:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105e59:	88 45 f7             	mov    %al,-0x9(%ebp)
  105e5c:	8b 45 10             	mov    0x10(%ebp),%eax
  105e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105e62:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105e65:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e69:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e6c:	89 d7                	mov    %edx,%edi
  105e6e:	f3 aa                	rep stos %al,%es:(%edi)
  105e70:	89 fa                	mov    %edi,%edx
  105e72:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e75:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e7b:	83 c4 24             	add    $0x24,%esp
  105e7e:	5f                   	pop    %edi
  105e7f:	5d                   	pop    %ebp
  105e80:	c3                   	ret    

00105e81 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e81:	55                   	push   %ebp
  105e82:	89 e5                	mov    %esp,%ebp
  105e84:	57                   	push   %edi
  105e85:	56                   	push   %esi
  105e86:	53                   	push   %ebx
  105e87:	83 ec 30             	sub    $0x30,%esp
  105e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  105e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e96:	8b 45 10             	mov    0x10(%ebp),%eax
  105e99:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e9f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105ea2:	73 42                	jae    105ee6 <memmove+0x65>
  105ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ea7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105eaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ead:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eb3:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105eb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105eb9:	c1 e8 02             	shr    $0x2,%eax
  105ebc:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105ebe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ec1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ec4:	89 d7                	mov    %edx,%edi
  105ec6:	89 c6                	mov    %eax,%esi
  105ec8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105eca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105ecd:	83 e1 03             	and    $0x3,%ecx
  105ed0:	74 02                	je     105ed4 <memmove+0x53>
  105ed2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ed4:	89 f0                	mov    %esi,%eax
  105ed6:	89 fa                	mov    %edi,%edx
  105ed8:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105edb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105ede:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ee4:	eb 36                	jmp    105f1c <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105ee6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ee9:	8d 50 ff             	lea    -0x1(%eax),%edx
  105eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eef:	01 c2                	add    %eax,%edx
  105ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ef4:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105efa:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f00:	89 c1                	mov    %eax,%ecx
  105f02:	89 d8                	mov    %ebx,%eax
  105f04:	89 d6                	mov    %edx,%esi
  105f06:	89 c7                	mov    %eax,%edi
  105f08:	fd                   	std    
  105f09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f0b:	fc                   	cld    
  105f0c:	89 f8                	mov    %edi,%eax
  105f0e:	89 f2                	mov    %esi,%edx
  105f10:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105f13:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105f16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105f1c:	83 c4 30             	add    $0x30,%esp
  105f1f:	5b                   	pop    %ebx
  105f20:	5e                   	pop    %esi
  105f21:	5f                   	pop    %edi
  105f22:	5d                   	pop    %ebp
  105f23:	c3                   	ret    

00105f24 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105f24:	55                   	push   %ebp
  105f25:	89 e5                	mov    %esp,%ebp
  105f27:	57                   	push   %edi
  105f28:	56                   	push   %esi
  105f29:	83 ec 20             	sub    $0x20,%esp
  105f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f38:	8b 45 10             	mov    0x10(%ebp),%eax
  105f3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f41:	c1 e8 02             	shr    $0x2,%eax
  105f44:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f4c:	89 d7                	mov    %edx,%edi
  105f4e:	89 c6                	mov    %eax,%esi
  105f50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f52:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f55:	83 e1 03             	and    $0x3,%ecx
  105f58:	74 02                	je     105f5c <memcpy+0x38>
  105f5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f5c:	89 f0                	mov    %esi,%eax
  105f5e:	89 fa                	mov    %edi,%edx
  105f60:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f63:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105f66:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f6c:	83 c4 20             	add    $0x20,%esp
  105f6f:	5e                   	pop    %esi
  105f70:	5f                   	pop    %edi
  105f71:	5d                   	pop    %ebp
  105f72:	c3                   	ret    

00105f73 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105f73:	55                   	push   %ebp
  105f74:	89 e5                	mov    %esp,%ebp
  105f76:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f79:	8b 45 08             	mov    0x8(%ebp),%eax
  105f7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f82:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f85:	eb 30                	jmp    105fb7 <memcmp+0x44>
        if (*s1 != *s2) {
  105f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f8a:	0f b6 10             	movzbl (%eax),%edx
  105f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f90:	0f b6 00             	movzbl (%eax),%eax
  105f93:	38 c2                	cmp    %al,%dl
  105f95:	74 18                	je     105faf <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f9a:	0f b6 00             	movzbl (%eax),%eax
  105f9d:	0f b6 d0             	movzbl %al,%edx
  105fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fa3:	0f b6 00             	movzbl (%eax),%eax
  105fa6:	0f b6 c0             	movzbl %al,%eax
  105fa9:	29 c2                	sub    %eax,%edx
  105fab:	89 d0                	mov    %edx,%eax
  105fad:	eb 1a                	jmp    105fc9 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105faf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105fb3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105fb7:	8b 45 10             	mov    0x10(%ebp),%eax
  105fba:	8d 50 ff             	lea    -0x1(%eax),%edx
  105fbd:	89 55 10             	mov    %edx,0x10(%ebp)
  105fc0:	85 c0                	test   %eax,%eax
  105fc2:	75 c3                	jne    105f87 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105fc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105fc9:	c9                   	leave  
  105fca:	c3                   	ret    
