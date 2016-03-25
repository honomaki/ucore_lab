
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
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
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
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
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 ec 5d 00 00       	call   c0105e42 <memset>

    cons_init();                // init the console
c0100056:	e8 78 15 00 00       	call   c01015d3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 e0 5f 10 c0 	movl   $0xc0105fe0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 fc 5f 10 c0 	movl   $0xc0105ffc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 da 42 00 00       	call   c010435e <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b3 16 00 00       	call   c010173c <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 05 18 00 00       	call   c0101893 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 f6 0c 00 00       	call   c0100d89 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 12 16 00 00       	call   c01016aa <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 ff 0b 00 00       	call   c0100cbb <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 01 60 10 c0 	movl   $0xc0106001,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 0f 60 10 c0 	movl   $0xc010600f,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 1d 60 10 c0 	movl   $0xc010601d,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 2b 60 10 c0 	movl   $0xc010602b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 39 60 10 c0 	movl   $0xc0106039,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 48 60 10 c0 	movl   $0xc0106048,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 68 60 10 c0 	movl   $0xc0106068,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 87 60 10 c0 	movl   $0xc0106087,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 05 13 00 00       	call   c01015ff <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 24 53 00 00       	call   c010565b <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 8c 12 00 00       	call   c01015ff <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 6c 12 00 00       	call   c010163b <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 8c 60 10 c0    	movl   $0xc010608c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 8c 60 10 c0 	movl   $0xc010608c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 e0 72 10 c0 	movl   $0xc01072e0,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 48 1f 11 c0 	movl   $0xc0111f48,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 49 1f 11 c0 	movl   $0xc0111f49,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 84 49 11 c0 	movl   $0xc0114984,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 ca 55 00 00       	call   c0105cb6 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 96 60 10 c0 	movl   $0xc0106096,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 af 60 10 c0 	movl   $0xc01060af,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 cb 5f 10 	movl   $0xc0105fcb,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 c7 60 10 c0 	movl   $0xc01060c7,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 df 60 10 c0 	movl   $0xc01060df,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 f7 60 10 c0 	movl   $0xc01060f7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 10 61 10 c0 	movl   $0xc0106110,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 3a 61 10 c0 	movl   $0xc010613a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 56 61 10 c0 	movl   $0xc0106156,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
	*    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
	*    (3.5) popup a calling stackframe
	*           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
	*                   the calling funciton's ebp = ss:[ebp]
	*/
	uint32_t ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int i = 0, j = 0;
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	while (i < STACKFRAME_DEPTH && ebp) {
c01009e1:	e9 88 00 00 00       	jmp    c0100a6e <print_stackframe+0xb4>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f4:	c7 04 24 68 61 10 c0 	movl   $0xc0106168,(%esp)
c01009fb:	e8 3c f9 ff ff       	call   c010033c <cprintf>
		uint32_t* arguments = (uint32_t)ebp + 2;
c0100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a03:	83 c0 02             	add    $0x2,%eax
c0100a06:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		j = 0;
c0100a09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		while (j < 4) {
c0100a10:	eb 25                	jmp    c0100a37 <print_stackframe+0x7d>
			cprintf("0x%08x ", arguments[j]);
c0100a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a1f:	01 d0                	add    %edx,%eax
c0100a21:	8b 00                	mov    (%eax),%eax
c0100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a27:	c7 04 24 84 61 10 c0 	movl   $0xc0106184,(%esp)
c0100a2e:	e8 09 f9 ff ff       	call   c010033c <cprintf>
			j++;
c0100a33:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
	while (i < STACKFRAME_DEPTH && ebp) {
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t* arguments = (uint32_t)ebp + 2;

		j = 0;
		while (j < 4) {
c0100a37:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3b:	7e d5                	jle    c0100a12 <print_stackframe+0x58>
			cprintf("0x%08x ", arguments[j]);
			j++;
		}

		cprintf("\n");
c0100a3d:	c7 04 24 8c 61 10 c0 	movl   $0xc010618c,(%esp)
c0100a44:	e8 f3 f8 ff ff       	call   c010033c <cprintf>
		print_debuginfo(eip - 1);
c0100a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4c:	83 e8 01             	sub    $0x1,%eax
c0100a4f:	89 04 24             	mov    %eax,(%esp)
c0100a52:	e8 af fe ff ff       	call   c0100906 <print_debuginfo>
		eip = *(uint32_t*)(ebp + 4);
c0100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5a:	83 c0 04             	add    $0x4,%eax
c0100a5d:	8b 00                	mov    (%eax),%eax
c0100a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *(uint32_t*)ebp;
c0100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a65:	8b 00                	mov    (%eax),%eax
c0100a67:	89 45 f4             	mov    %eax,-0xc(%ebp)

		i++;
c0100a6a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
	*/
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();

	int i = 0, j = 0;
	while (i < STACKFRAME_DEPTH && ebp) {
c0100a6e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a72:	7f 0a                	jg     c0100a7e <print_stackframe+0xc4>
c0100a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a78:	0f 85 68 ff ff ff    	jne    c01009e6 <print_stackframe+0x2c>
		eip = *(uint32_t*)(ebp + 4);
		ebp = *(uint32_t*)ebp;

		i++;
	}
}
c0100a7e:	c9                   	leave  
c0100a7f:	c3                   	ret    

c0100a80 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a80:	55                   	push   %ebp
c0100a81:	89 e5                	mov    %esp,%ebp
c0100a83:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8d:	eb 0c                	jmp    c0100a9b <parse+0x1b>
            *buf ++ = '\0';
c0100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a92:	8d 50 01             	lea    0x1(%eax),%edx
c0100a95:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a98:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9e:	0f b6 00             	movzbl (%eax),%eax
c0100aa1:	84 c0                	test   %al,%al
c0100aa3:	74 1d                	je     c0100ac2 <parse+0x42>
c0100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa8:	0f b6 00             	movzbl (%eax),%eax
c0100aab:	0f be c0             	movsbl %al,%eax
c0100aae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab2:	c7 04 24 10 62 10 c0 	movl   $0xc0106210,(%esp)
c0100ab9:	e8 c5 51 00 00       	call   c0105c83 <strchr>
c0100abe:	85 c0                	test   %eax,%eax
c0100ac0:	75 cd                	jne    c0100a8f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac5:	0f b6 00             	movzbl (%eax),%eax
c0100ac8:	84 c0                	test   %al,%al
c0100aca:	75 02                	jne    c0100ace <parse+0x4e>
            break;
c0100acc:	eb 67                	jmp    c0100b35 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad2:	75 14                	jne    c0100ae8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100adb:	00 
c0100adc:	c7 04 24 15 62 10 c0 	movl   $0xc0106215,(%esp)
c0100ae3:	e8 54 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aeb:	8d 50 01             	lea    0x1(%eax),%edx
c0100aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afb:	01 c2                	add    %eax,%edx
c0100afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b00:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b02:	eb 04                	jmp    c0100b08 <parse+0x88>
            buf ++;
c0100b04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0b:	0f b6 00             	movzbl (%eax),%eax
c0100b0e:	84 c0                	test   %al,%al
c0100b10:	74 1d                	je     c0100b2f <parse+0xaf>
c0100b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b15:	0f b6 00             	movzbl (%eax),%eax
c0100b18:	0f be c0             	movsbl %al,%eax
c0100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1f:	c7 04 24 10 62 10 c0 	movl   $0xc0106210,(%esp)
c0100b26:	e8 58 51 00 00       	call   c0105c83 <strchr>
c0100b2b:	85 c0                	test   %eax,%eax
c0100b2d:	74 d5                	je     c0100b04 <parse+0x84>
            buf ++;
        }
    }
c0100b2f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b30:	e9 66 ff ff ff       	jmp    c0100a9b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b38:	c9                   	leave  
c0100b39:	c3                   	ret    

c0100b3a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3a:	55                   	push   %ebp
c0100b3b:	89 e5                	mov    %esp,%ebp
c0100b3d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b40:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4a:	89 04 24             	mov    %eax,(%esp)
c0100b4d:	e8 2e ff ff ff       	call   c0100a80 <parse>
c0100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b59:	75 0a                	jne    c0100b65 <runcmd+0x2b>
        return 0;
c0100b5b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b60:	e9 85 00 00 00       	jmp    c0100bea <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6c:	eb 5c                	jmp    c0100bca <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b6e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b74:	89 d0                	mov    %edx,%eax
c0100b76:	01 c0                	add    %eax,%eax
c0100b78:	01 d0                	add    %edx,%eax
c0100b7a:	c1 e0 02             	shl    $0x2,%eax
c0100b7d:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b82:	8b 00                	mov    (%eax),%eax
c0100b84:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b88:	89 04 24             	mov    %eax,(%esp)
c0100b8b:	e8 54 50 00 00       	call   c0105be4 <strcmp>
c0100b90:	85 c0                	test   %eax,%eax
c0100b92:	75 32                	jne    c0100bc6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b97:	89 d0                	mov    %edx,%eax
c0100b99:	01 c0                	add    %eax,%eax
c0100b9b:	01 d0                	add    %edx,%eax
c0100b9d:	c1 e0 02             	shl    $0x2,%eax
c0100ba0:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ba5:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bab:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bae:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb5:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb8:	83 c2 04             	add    $0x4,%edx
c0100bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bbf:	89 0c 24             	mov    %ecx,(%esp)
c0100bc2:	ff d0                	call   *%eax
c0100bc4:	eb 24                	jmp    c0100bea <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcd:	83 f8 02             	cmp    $0x2,%eax
c0100bd0:	76 9c                	jbe    c0100b6e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd9:	c7 04 24 33 62 10 c0 	movl   $0xc0106233,(%esp)
c0100be0:	e8 57 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bea:	c9                   	leave  
c0100beb:	c3                   	ret    

c0100bec <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bec:	55                   	push   %ebp
c0100bed:	89 e5                	mov    %esp,%ebp
c0100bef:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf2:	c7 04 24 4c 62 10 c0 	movl   $0xc010624c,(%esp)
c0100bf9:	e8 3e f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bfe:	c7 04 24 74 62 10 c0 	movl   $0xc0106274,(%esp)
c0100c05:	e8 32 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c0e:	74 0b                	je     c0100c1b <kmonitor+0x2f>
        print_trapframe(tf);
c0100c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c13:	89 04 24             	mov    %eax,(%esp)
c0100c16:	e8 2c 0e 00 00       	call   c0101a47 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1b:	c7 04 24 99 62 10 c0 	movl   $0xc0106299,(%esp)
c0100c22:	e8 0c f6 ff ff       	call   c0100233 <readline>
c0100c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c2e:	74 18                	je     c0100c48 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3a:	89 04 24             	mov    %eax,(%esp)
c0100c3d:	e8 f8 fe ff ff       	call   c0100b3a <runcmd>
c0100c42:	85 c0                	test   %eax,%eax
c0100c44:	79 02                	jns    c0100c48 <kmonitor+0x5c>
                break;
c0100c46:	eb 02                	jmp    c0100c4a <kmonitor+0x5e>
            }
        }
    }
c0100c48:	eb d1                	jmp    c0100c1b <kmonitor+0x2f>
}
c0100c4a:	c9                   	leave  
c0100c4b:	c3                   	ret    

c0100c4c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4c:	55                   	push   %ebp
c0100c4d:	89 e5                	mov    %esp,%ebp
c0100c4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c59:	eb 3f                	jmp    c0100c9a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5e:	89 d0                	mov    %edx,%eax
c0100c60:	01 c0                	add    %eax,%eax
c0100c62:	01 d0                	add    %edx,%eax
c0100c64:	c1 e0 02             	shl    $0x2,%eax
c0100c67:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c6c:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c72:	89 d0                	mov    %edx,%eax
c0100c74:	01 c0                	add    %eax,%eax
c0100c76:	01 d0                	add    %edx,%eax
c0100c78:	c1 e0 02             	shl    $0x2,%eax
c0100c7b:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c80:	8b 00                	mov    (%eax),%eax
c0100c82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8a:	c7 04 24 9d 62 10 c0 	movl   $0xc010629d,(%esp)
c0100c91:	e8 a6 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9d:	83 f8 02             	cmp    $0x2,%eax
c0100ca0:	76 b9                	jbe    c0100c5b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca7:	c9                   	leave  
c0100ca8:	c3                   	ret    

c0100ca9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca9:	55                   	push   %ebp
c0100caa:	89 e5                	mov    %esp,%ebp
c0100cac:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100caf:	e8 bc fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb9:	c9                   	leave  
c0100cba:	c3                   	ret    

c0100cbb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cbb:	55                   	push   %ebp
c0100cbc:	89 e5                	mov    %esp,%ebp
c0100cbe:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc1:	e8 f4 fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccb:	c9                   	leave  
c0100ccc:	c3                   	ret    

c0100ccd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ccd:	55                   	push   %ebp
c0100cce:	89 e5                	mov    %esp,%ebp
c0100cd0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd3:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd8:	85 c0                	test   %eax,%eax
c0100cda:	74 02                	je     c0100cde <__panic+0x11>
        goto panic_dead;
c0100cdc:	eb 48                	jmp    c0100d26 <__panic+0x59>
    }
    is_panic = 1;
c0100cde:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100ce5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce8:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfc:	c7 04 24 a6 62 10 c0 	movl   $0xc01062a6,(%esp)
c0100d03:	e8 34 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d12:	89 04 24             	mov    %eax,(%esp)
c0100d15:	e8 ef f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d1a:	c7 04 24 c2 62 10 c0 	movl   $0xc01062c2,(%esp)
c0100d21:	e8 16 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d26:	e8 85 09 00 00       	call   c01016b0 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d32:	e8 b5 fe ff ff       	call   c0100bec <kmonitor>
    }
c0100d37:	eb f2                	jmp    c0100d2b <__panic+0x5e>

c0100d39 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d39:	55                   	push   %ebp
c0100d3a:	89 e5                	mov    %esp,%ebp
c0100d3c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d3f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d48:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d53:	c7 04 24 c4 62 10 c0 	movl   $0xc01062c4,(%esp)
c0100d5a:	e8 dd f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d66:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d69:	89 04 24             	mov    %eax,(%esp)
c0100d6c:	e8 98 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d71:	c7 04 24 c2 62 10 c0 	movl   $0xc01062c2,(%esp)
c0100d78:	e8 bf f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d7d:	c9                   	leave  
c0100d7e:	c3                   	ret    

c0100d7f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d7f:	55                   	push   %ebp
c0100d80:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d82:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d87:	5d                   	pop    %ebp
c0100d88:	c3                   	ret    

c0100d89 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d89:	55                   	push   %ebp
c0100d8a:	89 e5                	mov    %esp,%ebp
c0100d8c:	83 ec 28             	sub    $0x28,%esp
c0100d8f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d95:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d99:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d9d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da1:	ee                   	out    %al,(%dx)
c0100da2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dac:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db4:	ee                   	out    %al,(%dx)
c0100db5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dbb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dbf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc8:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dcf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd2:	c7 04 24 e2 62 10 c0 	movl   $0xc01062e2,(%esp)
c0100dd9:	e8 5e f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de5:	e8 24 09 00 00       	call   c010170e <pic_enable>
}
c0100dea:	c9                   	leave  
c0100deb:	c3                   	ret    

c0100dec <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dec:	55                   	push   %ebp
c0100ded:	89 e5                	mov    %esp,%ebp
c0100def:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df2:	9c                   	pushf  
c0100df3:	58                   	pop    %eax
c0100df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dfa:	25 00 02 00 00       	and    $0x200,%eax
c0100dff:	85 c0                	test   %eax,%eax
c0100e01:	74 0c                	je     c0100e0f <__intr_save+0x23>
        intr_disable();
c0100e03:	e8 a8 08 00 00       	call   c01016b0 <intr_disable>
        return 1;
c0100e08:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0d:	eb 05                	jmp    c0100e14 <__intr_save+0x28>
    }
    return 0;
c0100e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e14:	c9                   	leave  
c0100e15:	c3                   	ret    

c0100e16 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e16:	55                   	push   %ebp
c0100e17:	89 e5                	mov    %esp,%ebp
c0100e19:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e20:	74 05                	je     c0100e27 <__intr_restore+0x11>
        intr_enable();
c0100e22:	e8 83 08 00 00       	call   c01016aa <intr_enable>
    }
}
c0100e27:	c9                   	leave  
c0100e28:	c3                   	ret    

c0100e29 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e29:	55                   	push   %ebp
c0100e2a:	89 e5                	mov    %esp,%ebp
c0100e2c:	83 ec 10             	sub    $0x10,%esp
c0100e2f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e35:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e39:	89 c2                	mov    %eax,%edx
c0100e3b:	ec                   	in     (%dx),%al
c0100e3c:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e3f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e45:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e49:	89 c2                	mov    %eax,%edx
c0100e4b:	ec                   	in     (%dx),%al
c0100e4c:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e4f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e55:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e59:	89 c2                	mov    %eax,%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e5f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e65:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e69:	89 c2                	mov    %eax,%edx
c0100e6b:	ec                   	in     (%dx),%al
c0100e6c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e6f:	c9                   	leave  
c0100e70:	c3                   	ret    

c0100e71 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e71:	55                   	push   %ebp
c0100e72:	89 e5                	mov    %esp,%ebp
c0100e74:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e77:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e81:	0f b7 00             	movzwl (%eax),%eax
c0100e84:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e93:	0f b7 00             	movzwl (%eax),%eax
c0100e96:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e9a:	74 12                	je     c0100eae <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e9c:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea3:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100eaa:	b4 03 
c0100eac:	eb 13                	jmp    c0100ec1 <cga_init+0x50>
    } else {
        *cp = was;
c0100eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb8:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ebf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec1:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec8:	0f b7 c0             	movzwl %ax,%eax
c0100ecb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ecf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100edb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100edc:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee3:	83 c0 01             	add    $0x1,%eax
c0100ee6:	0f b7 c0             	movzwl %ax,%eax
c0100ee9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eed:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef1:	89 c2                	mov    %eax,%edx
c0100ef3:	ec                   	in     (%dx),%al
c0100ef4:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100efb:	0f b6 c0             	movzbl %al,%eax
c0100efe:	c1 e0 08             	shl    $0x8,%eax
c0100f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f04:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f0b:	0f b7 c0             	movzwl %ax,%eax
c0100f0e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f12:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f16:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f1a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f1e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f1f:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f26:	83 c0 01             	add    $0x1,%eax
c0100f29:	0f b7 c0             	movzwl %ax,%eax
c0100f2c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f30:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f34:	89 c2                	mov    %eax,%edx
c0100f36:	ec                   	in     (%dx),%al
c0100f37:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f3a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f3e:	0f b6 c0             	movzbl %al,%eax
c0100f41:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f47:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f4f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f55:	c9                   	leave  
c0100f56:	c3                   	ret    

c0100f57 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f57:	55                   	push   %ebp
c0100f58:	89 e5                	mov    %esp,%ebp
c0100f5a:	83 ec 48             	sub    $0x48,%esp
c0100f5d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f63:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f67:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f6b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f6f:	ee                   	out    %al,(%dx)
c0100f70:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f76:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f7a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f82:	ee                   	out    %al,(%dx)
c0100f83:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f89:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f8d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f91:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f95:	ee                   	out    %al,(%dx)
c0100f96:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f9c:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa8:	ee                   	out    %al,(%dx)
c0100fa9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100faf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbb:	ee                   	out    %al,(%dx)
c0100fbc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fc6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fca:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fce:	ee                   	out    %al,(%dx)
c0100fcf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fdd:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe1:	ee                   	out    %al,(%dx)
c0100fe2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fec:	89 c2                	mov    %eax,%edx
c0100fee:	ec                   	in     (%dx),%al
c0100fef:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff6:	3c ff                	cmp    $0xff,%al
c0100ff8:	0f 95 c0             	setne  %al
c0100ffb:	0f b6 c0             	movzbl %al,%eax
c0100ffe:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0101003:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101009:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010100d:	89 c2                	mov    %eax,%edx
c010100f:	ec                   	in     (%dx),%al
c0101010:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101013:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101019:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010101d:	89 c2                	mov    %eax,%edx
c010101f:	ec                   	in     (%dx),%al
c0101020:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101023:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101028:	85 c0                	test   %eax,%eax
c010102a:	74 0c                	je     c0101038 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010102c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101033:	e8 d6 06 00 00       	call   c010170e <pic_enable>
    }
}
c0101038:	c9                   	leave  
c0101039:	c3                   	ret    

c010103a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010103a:	55                   	push   %ebp
c010103b:	89 e5                	mov    %esp,%ebp
c010103d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101047:	eb 09                	jmp    c0101052 <lpt_putc_sub+0x18>
        delay();
c0101049:	e8 db fd ff ff       	call   c0100e29 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101052:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101058:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105c:	89 c2                	mov    %eax,%edx
c010105e:	ec                   	in     (%dx),%al
c010105f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101062:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101066:	84 c0                	test   %al,%al
c0101068:	78 09                	js     c0101073 <lpt_putc_sub+0x39>
c010106a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101071:	7e d6                	jle    c0101049 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101073:	8b 45 08             	mov    0x8(%ebp),%eax
c0101076:	0f b6 c0             	movzbl %al,%eax
c0101079:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010107f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101082:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101086:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010108a:	ee                   	out    %al,(%dx)
c010108b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101091:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101095:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101099:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109d:	ee                   	out    %al,(%dx)
c010109e:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010ac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b1:	c9                   	leave  
c01010b2:	c3                   	ret    

c01010b3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b3:	55                   	push   %ebp
c01010b4:	89 e5                	mov    %esp,%ebp
c01010b6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010bd:	74 0d                	je     c01010cc <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c2:	89 04 24             	mov    %eax,(%esp)
c01010c5:	e8 70 ff ff ff       	call   c010103a <lpt_putc_sub>
c01010ca:	eb 24                	jmp    c01010f0 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d3:	e8 62 ff ff ff       	call   c010103a <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010df:	e8 56 ff ff ff       	call   c010103a <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010eb:	e8 4a ff ff ff       	call   c010103a <lpt_putc_sub>
    }
}
c01010f0:	c9                   	leave  
c01010f1:	c3                   	ret    

c01010f2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f2:	55                   	push   %ebp
c01010f3:	89 e5                	mov    %esp,%ebp
c01010f5:	53                   	push   %ebx
c01010f6:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fc:	b0 00                	mov    $0x0,%al
c01010fe:	85 c0                	test   %eax,%eax
c0101100:	75 07                	jne    c0101109 <cga_putc+0x17>
        c |= 0x0700;
c0101102:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101109:	8b 45 08             	mov    0x8(%ebp),%eax
c010110c:	0f b6 c0             	movzbl %al,%eax
c010110f:	83 f8 0a             	cmp    $0xa,%eax
c0101112:	74 4c                	je     c0101160 <cga_putc+0x6e>
c0101114:	83 f8 0d             	cmp    $0xd,%eax
c0101117:	74 57                	je     c0101170 <cga_putc+0x7e>
c0101119:	83 f8 08             	cmp    $0x8,%eax
c010111c:	0f 85 88 00 00 00    	jne    c01011aa <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101122:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101129:	66 85 c0             	test   %ax,%ax
c010112c:	74 30                	je     c010115e <cga_putc+0x6c>
            crt_pos --;
c010112e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101135:	83 e8 01             	sub    $0x1,%eax
c0101138:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010113e:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101143:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c010114a:	0f b7 d2             	movzwl %dx,%edx
c010114d:	01 d2                	add    %edx,%edx
c010114f:	01 c2                	add    %eax,%edx
c0101151:	8b 45 08             	mov    0x8(%ebp),%eax
c0101154:	b0 00                	mov    $0x0,%al
c0101156:	83 c8 20             	or     $0x20,%eax
c0101159:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010115c:	eb 72                	jmp    c01011d0 <cga_putc+0xde>
c010115e:	eb 70                	jmp    c01011d0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101160:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101167:	83 c0 50             	add    $0x50,%eax
c010116a:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101170:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101177:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c010117e:	0f b7 c1             	movzwl %cx,%eax
c0101181:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101187:	c1 e8 10             	shr    $0x10,%eax
c010118a:	89 c2                	mov    %eax,%edx
c010118c:	66 c1 ea 06          	shr    $0x6,%dx
c0101190:	89 d0                	mov    %edx,%eax
c0101192:	c1 e0 02             	shl    $0x2,%eax
c0101195:	01 d0                	add    %edx,%eax
c0101197:	c1 e0 04             	shl    $0x4,%eax
c010119a:	29 c1                	sub    %eax,%ecx
c010119c:	89 ca                	mov    %ecx,%edx
c010119e:	89 d8                	mov    %ebx,%eax
c01011a0:	29 d0                	sub    %edx,%eax
c01011a2:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a8:	eb 26                	jmp    c01011d0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011aa:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011b0:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b7:	8d 50 01             	lea    0x1(%eax),%edx
c01011ba:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011c1:	0f b7 c0             	movzwl %ax,%eax
c01011c4:	01 c0                	add    %eax,%eax
c01011c6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01011cc:	66 89 02             	mov    %ax,(%edx)
        break;
c01011cf:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d0:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d7:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011db:	76 5b                	jbe    c0101238 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011dd:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e8:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011ed:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f4:	00 
c01011f5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f9:	89 04 24             	mov    %eax,(%esp)
c01011fc:	e8 80 4c 00 00       	call   c0105e81 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101201:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101208:	eb 15                	jmp    c010121f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010120a:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010120f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101212:	01 d2                	add    %edx,%edx
c0101214:	01 d0                	add    %edx,%eax
c0101216:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010121f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101226:	7e e2                	jle    c010120a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101228:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010122f:	83 e8 50             	sub    $0x50,%eax
c0101232:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101238:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010123f:	0f b7 c0             	movzwl %ax,%eax
c0101242:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101246:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010124a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010124e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101252:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101253:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010125a:	66 c1 e8 08          	shr    $0x8,%ax
c010125e:	0f b6 c0             	movzbl %al,%eax
c0101261:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101268:	83 c2 01             	add    $0x1,%edx
c010126b:	0f b7 d2             	movzwl %dx,%edx
c010126e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101272:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101275:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101279:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010127e:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101285:	0f b7 c0             	movzwl %ax,%eax
c0101288:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010128c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101290:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101294:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101298:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101299:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01012a0:	0f b6 c0             	movzbl %al,%eax
c01012a3:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012aa:	83 c2 01             	add    $0x1,%edx
c01012ad:	0f b7 d2             	movzwl %dx,%edx
c01012b0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b4:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012bb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012bf:	ee                   	out    %al,(%dx)
}
c01012c0:	83 c4 34             	add    $0x34,%esp
c01012c3:	5b                   	pop    %ebx
c01012c4:	5d                   	pop    %ebp
c01012c5:	c3                   	ret    

c01012c6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c6:	55                   	push   %ebp
c01012c7:	89 e5                	mov    %esp,%ebp
c01012c9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d3:	eb 09                	jmp    c01012de <serial_putc_sub+0x18>
        delay();
c01012d5:	e8 4f fb ff ff       	call   c0100e29 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012de:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e8:	89 c2                	mov    %eax,%edx
c01012ea:	ec                   	in     (%dx),%al
c01012eb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f2:	0f b6 c0             	movzbl %al,%eax
c01012f5:	83 e0 20             	and    $0x20,%eax
c01012f8:	85 c0                	test   %eax,%eax
c01012fa:	75 09                	jne    c0101305 <serial_putc_sub+0x3f>
c01012fc:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101303:	7e d0                	jle    c01012d5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101305:	8b 45 08             	mov    0x8(%ebp),%eax
c0101308:	0f b6 c0             	movzbl %al,%eax
c010130b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101311:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101314:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101318:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131c:	ee                   	out    %al,(%dx)
}
c010131d:	c9                   	leave  
c010131e:	c3                   	ret    

c010131f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010131f:	55                   	push   %ebp
c0101320:	89 e5                	mov    %esp,%ebp
c0101322:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101325:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101329:	74 0d                	je     c0101338 <serial_putc+0x19>
        serial_putc_sub(c);
c010132b:	8b 45 08             	mov    0x8(%ebp),%eax
c010132e:	89 04 24             	mov    %eax,(%esp)
c0101331:	e8 90 ff ff ff       	call   c01012c6 <serial_putc_sub>
c0101336:	eb 24                	jmp    c010135c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101338:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010133f:	e8 82 ff ff ff       	call   c01012c6 <serial_putc_sub>
        serial_putc_sub(' ');
c0101344:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010134b:	e8 76 ff ff ff       	call   c01012c6 <serial_putc_sub>
        serial_putc_sub('\b');
c0101350:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101357:	e8 6a ff ff ff       	call   c01012c6 <serial_putc_sub>
    }
}
c010135c:	c9                   	leave  
c010135d:	c3                   	ret    

c010135e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010135e:	55                   	push   %ebp
c010135f:	89 e5                	mov    %esp,%ebp
c0101361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101364:	eb 33                	jmp    c0101399 <cons_intr+0x3b>
        if (c != 0) {
c0101366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010136a:	74 2d                	je     c0101399 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010136c:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101371:	8d 50 01             	lea    0x1(%eax),%edx
c0101374:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010137a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010137d:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101383:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101388:	3d 00 02 00 00       	cmp    $0x200,%eax
c010138d:	75 0a                	jne    c0101399 <cons_intr+0x3b>
                cons.wpos = 0;
c010138f:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101396:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101399:	8b 45 08             	mov    0x8(%ebp),%eax
c010139c:	ff d0                	call   *%eax
c010139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a5:	75 bf                	jne    c0101366 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a7:	c9                   	leave  
c01013a8:	c3                   	ret    

c01013a9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a9:	55                   	push   %ebp
c01013aa:	89 e5                	mov    %esp,%ebp
c01013ac:	83 ec 10             	sub    $0x10,%esp
c01013af:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b9:	89 c2                	mov    %eax,%edx
c01013bb:	ec                   	in     (%dx),%al
c01013bc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013bf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c3:	0f b6 c0             	movzbl %al,%eax
c01013c6:	83 e0 01             	and    $0x1,%eax
c01013c9:	85 c0                	test   %eax,%eax
c01013cb:	75 07                	jne    c01013d4 <serial_proc_data+0x2b>
        return -1;
c01013cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d2:	eb 2a                	jmp    c01013fe <serial_proc_data+0x55>
c01013d4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013da:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013de:	89 c2                	mov    %eax,%edx
c01013e0:	ec                   	in     (%dx),%al
c01013e1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e8:	0f b6 c0             	movzbl %al,%eax
c01013eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013ee:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f2:	75 07                	jne    c01013fb <serial_proc_data+0x52>
        c = '\b';
c01013f4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013fe:	c9                   	leave  
c01013ff:	c3                   	ret    

c0101400 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101400:	55                   	push   %ebp
c0101401:	89 e5                	mov    %esp,%ebp
c0101403:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101406:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010140b:	85 c0                	test   %eax,%eax
c010140d:	74 0c                	je     c010141b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010140f:	c7 04 24 a9 13 10 c0 	movl   $0xc01013a9,(%esp)
c0101416:	e8 43 ff ff ff       	call   c010135e <cons_intr>
    }
}
c010141b:	c9                   	leave  
c010141c:	c3                   	ret    

c010141d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141d:	55                   	push   %ebp
c010141e:	89 e5                	mov    %esp,%ebp
c0101420:	83 ec 38             	sub    $0x38,%esp
c0101423:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101429:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142d:	89 c2                	mov    %eax,%edx
c010142f:	ec                   	in     (%dx),%al
c0101430:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101433:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101437:	0f b6 c0             	movzbl %al,%eax
c010143a:	83 e0 01             	and    $0x1,%eax
c010143d:	85 c0                	test   %eax,%eax
c010143f:	75 0a                	jne    c010144b <kbd_proc_data+0x2e>
        return -1;
c0101441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101446:	e9 59 01 00 00       	jmp    c01015a4 <kbd_proc_data+0x187>
c010144b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101451:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101455:	89 c2                	mov    %eax,%edx
c0101457:	ec                   	in     (%dx),%al
c0101458:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010145f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101462:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101466:	75 17                	jne    c010147f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101468:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010146d:	83 c8 40             	or     $0x40,%eax
c0101470:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101475:	b8 00 00 00 00       	mov    $0x0,%eax
c010147a:	e9 25 01 00 00       	jmp    c01015a4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010147f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101483:	84 c0                	test   %al,%al
c0101485:	79 47                	jns    c01014ce <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101487:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010148c:	83 e0 40             	and    $0x40,%eax
c010148f:	85 c0                	test   %eax,%eax
c0101491:	75 09                	jne    c010149c <kbd_proc_data+0x7f>
c0101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101497:	83 e0 7f             	and    $0x7f,%eax
c010149a:	eb 04                	jmp    c01014a0 <kbd_proc_data+0x83>
c010149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ae:	83 c8 40             	or     $0x40,%eax
c01014b1:	0f b6 c0             	movzbl %al,%eax
c01014b4:	f7 d0                	not    %eax
c01014b6:	89 c2                	mov    %eax,%edx
c01014b8:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014bd:	21 d0                	and    %edx,%eax
c01014bf:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014c4:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c9:	e9 d6 00 00 00       	jmp    c01015a4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014ce:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d3:	83 e0 40             	and    $0x40,%eax
c01014d6:	85 c0                	test   %eax,%eax
c01014d8:	74 11                	je     c01014eb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014da:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014de:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e3:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e6:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ef:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014f6:	0f b6 d0             	movzbl %al,%edx
c01014f9:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014fe:	09 d0                	or     %edx,%eax
c0101500:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101509:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101510:	0f b6 d0             	movzbl %al,%edx
c0101513:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101518:	31 d0                	xor    %edx,%eax
c010151a:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010151f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101524:	83 e0 03             	and    $0x3,%eax
c0101527:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010152e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101532:	01 d0                	add    %edx,%eax
c0101534:	0f b6 00             	movzbl (%eax),%eax
c0101537:	0f b6 c0             	movzbl %al,%eax
c010153a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101542:	83 e0 08             	and    $0x8,%eax
c0101545:	85 c0                	test   %eax,%eax
c0101547:	74 22                	je     c010156b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101549:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154d:	7e 0c                	jle    c010155b <kbd_proc_data+0x13e>
c010154f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101553:	7f 06                	jg     c010155b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101555:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101559:	eb 10                	jmp    c010156b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010155f:	7e 0a                	jle    c010156b <kbd_proc_data+0x14e>
c0101561:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101565:	7f 04                	jg     c010156b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101567:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101570:	f7 d0                	not    %eax
c0101572:	83 e0 06             	and    $0x6,%eax
c0101575:	85 c0                	test   %eax,%eax
c0101577:	75 28                	jne    c01015a1 <kbd_proc_data+0x184>
c0101579:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101580:	75 1f                	jne    c01015a1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101582:	c7 04 24 fd 62 10 c0 	movl   $0xc01062fd,(%esp)
c0101589:	e8 ae ed ff ff       	call   c010033c <cprintf>
c010158e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101594:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101598:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010159c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a4:	c9                   	leave  
c01015a5:	c3                   	ret    

c01015a6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a6:	55                   	push   %ebp
c01015a7:	89 e5                	mov    %esp,%ebp
c01015a9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015ac:	c7 04 24 1d 14 10 c0 	movl   $0xc010141d,(%esp)
c01015b3:	e8 a6 fd ff ff       	call   c010135e <cons_intr>
}
c01015b8:	c9                   	leave  
c01015b9:	c3                   	ret    

c01015ba <kbd_init>:

static void
kbd_init(void) {
c01015ba:	55                   	push   %ebp
c01015bb:	89 e5                	mov    %esp,%ebp
c01015bd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c0:	e8 e1 ff ff ff       	call   c01015a6 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015cc:	e8 3d 01 00 00       	call   c010170e <pic_enable>
}
c01015d1:	c9                   	leave  
c01015d2:	c3                   	ret    

c01015d3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d3:	55                   	push   %ebp
c01015d4:	89 e5                	mov    %esp,%ebp
c01015d6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d9:	e8 93 f8 ff ff       	call   c0100e71 <cga_init>
    serial_init();
c01015de:	e8 74 f9 ff ff       	call   c0100f57 <serial_init>
    kbd_init();
c01015e3:	e8 d2 ff ff ff       	call   c01015ba <kbd_init>
    if (!serial_exists) {
c01015e8:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015ed:	85 c0                	test   %eax,%eax
c01015ef:	75 0c                	jne    c01015fd <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f1:	c7 04 24 09 63 10 c0 	movl   $0xc0106309,(%esp)
c01015f8:	e8 3f ed ff ff       	call   c010033c <cprintf>
    }
}
c01015fd:	c9                   	leave  
c01015fe:	c3                   	ret    

c01015ff <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015ff:	55                   	push   %ebp
c0101600:	89 e5                	mov    %esp,%ebp
c0101602:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101605:	e8 e2 f7 ff ff       	call   c0100dec <__intr_save>
c010160a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010160d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101610:	89 04 24             	mov    %eax,(%esp)
c0101613:	e8 9b fa ff ff       	call   c01010b3 <lpt_putc>
        cga_putc(c);
c0101618:	8b 45 08             	mov    0x8(%ebp),%eax
c010161b:	89 04 24             	mov    %eax,(%esp)
c010161e:	e8 cf fa ff ff       	call   c01010f2 <cga_putc>
        serial_putc(c);
c0101623:	8b 45 08             	mov    0x8(%ebp),%eax
c0101626:	89 04 24             	mov    %eax,(%esp)
c0101629:	e8 f1 fc ff ff       	call   c010131f <serial_putc>
    }
    local_intr_restore(intr_flag);
c010162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101631:	89 04 24             	mov    %eax,(%esp)
c0101634:	e8 dd f7 ff ff       	call   c0100e16 <__intr_restore>
}
c0101639:	c9                   	leave  
c010163a:	c3                   	ret    

c010163b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163b:	55                   	push   %ebp
c010163c:	89 e5                	mov    %esp,%ebp
c010163e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101641:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101648:	e8 9f f7 ff ff       	call   c0100dec <__intr_save>
c010164d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101650:	e8 ab fd ff ff       	call   c0101400 <serial_intr>
        kbd_intr();
c0101655:	e8 4c ff ff ff       	call   c01015a6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010165a:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101660:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101665:	39 c2                	cmp    %eax,%edx
c0101667:	74 31                	je     c010169a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101669:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010166e:	8d 50 01             	lea    0x1(%eax),%edx
c0101671:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101677:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010167e:	0f b6 c0             	movzbl %al,%eax
c0101681:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101684:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101689:	3d 00 02 00 00       	cmp    $0x200,%eax
c010168e:	75 0a                	jne    c010169a <cons_getc+0x5f>
                cons.rpos = 0;
c0101690:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101697:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010169d:	89 04 24             	mov    %eax,(%esp)
c01016a0:	e8 71 f7 ff ff       	call   c0100e16 <__intr_restore>
    return c;
c01016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a8:	c9                   	leave  
c01016a9:	c3                   	ret    

c01016aa <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016aa:	55                   	push   %ebp
c01016ab:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016ad:	fb                   	sti    
    sti();
}
c01016ae:	5d                   	pop    %ebp
c01016af:	c3                   	ret    

c01016b0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016b0:	55                   	push   %ebp
c01016b1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016b3:	fa                   	cli    
    cli();
}
c01016b4:	5d                   	pop    %ebp
c01016b5:	c3                   	ret    

c01016b6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b6:	55                   	push   %ebp
c01016b7:	89 e5                	mov    %esp,%ebp
c01016b9:	83 ec 14             	sub    $0x14,%esp
c01016bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c7:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016cd:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016d2:	85 c0                	test   %eax,%eax
c01016d4:	74 36                	je     c010170c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016da:	0f b6 c0             	movzbl %al,%eax
c01016dd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e3:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016e6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016ea:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016ee:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ef:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f3:	66 c1 e8 08          	shr    $0x8,%ax
c01016f7:	0f b6 c0             	movzbl %al,%eax
c01016fa:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101700:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101703:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101707:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010170b:	ee                   	out    %al,(%dx)
    }
}
c010170c:	c9                   	leave  
c010170d:	c3                   	ret    

c010170e <pic_enable>:

void
pic_enable(unsigned int irq) {
c010170e:	55                   	push   %ebp
c010170f:	89 e5                	mov    %esp,%ebp
c0101711:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101714:	8b 45 08             	mov    0x8(%ebp),%eax
c0101717:	ba 01 00 00 00       	mov    $0x1,%edx
c010171c:	89 c1                	mov    %eax,%ecx
c010171e:	d3 e2                	shl    %cl,%edx
c0101720:	89 d0                	mov    %edx,%eax
c0101722:	f7 d0                	not    %eax
c0101724:	89 c2                	mov    %eax,%edx
c0101726:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010172d:	21 d0                	and    %edx,%eax
c010172f:	0f b7 c0             	movzwl %ax,%eax
c0101732:	89 04 24             	mov    %eax,(%esp)
c0101735:	e8 7c ff ff ff       	call   c01016b6 <pic_setmask>
}
c010173a:	c9                   	leave  
c010173b:	c3                   	ret    

c010173c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010173c:	55                   	push   %ebp
c010173d:	89 e5                	mov    %esp,%ebp
c010173f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101742:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101749:	00 00 00 
c010174c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101752:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101756:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010175a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010175e:	ee                   	out    %al,(%dx)
c010175f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101765:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101769:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101771:	ee                   	out    %al,(%dx)
c0101772:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101778:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010177c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101780:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101784:	ee                   	out    %al,(%dx)
c0101785:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010178b:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010178f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101793:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101797:	ee                   	out    %al,(%dx)
c0101798:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010179e:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017aa:	ee                   	out    %al,(%dx)
c01017ab:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017b1:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017bd:	ee                   	out    %al,(%dx)
c01017be:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c4:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017cc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017d0:	ee                   	out    %al,(%dx)
c01017d1:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d7:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017db:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017df:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e3:	ee                   	out    %al,(%dx)
c01017e4:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017ea:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017ee:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f6:	ee                   	out    %al,(%dx)
c01017f7:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017fd:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101801:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101805:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101809:	ee                   	out    %al,(%dx)
c010180a:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101810:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101814:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101818:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010181c:	ee                   	out    %al,(%dx)
c010181d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101823:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101827:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010182b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010182f:	ee                   	out    %al,(%dx)
c0101830:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101836:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010183a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010183e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101842:	ee                   	out    %al,(%dx)
c0101843:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101849:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010184d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101851:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101855:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101856:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010185d:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101861:	74 12                	je     c0101875 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101863:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010186a:	0f b7 c0             	movzwl %ax,%eax
c010186d:	89 04 24             	mov    %eax,(%esp)
c0101870:	e8 41 fe ff ff       	call   c01016b6 <pic_setmask>
    }
}
c0101875:	c9                   	leave  
c0101876:	c3                   	ret    

c0101877 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101877:	55                   	push   %ebp
c0101878:	89 e5                	mov    %esp,%ebp
c010187a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010187d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101884:	00 
c0101885:	c7 04 24 40 63 10 c0 	movl   $0xc0106340,(%esp)
c010188c:	e8 ab ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101891:	c9                   	leave  
c0101892:	c3                   	ret    

c0101893 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101893:	55                   	push   %ebp
c0101894:	89 e5                	mov    %esp,%ebp
c0101896:	83 ec 10             	sub    $0x10,%esp
	*     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
	*     Notice: the argument of lidt is idt_pd. try to find it!
	*/

	extern uintptr_t __vectors[];
	int i = 0;
c0101899:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < 256) {
c01018a0:	e9 c3 00 00 00       	jmp    c0101968 <idt_init+0xd5>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a8:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018af:	89 c2                	mov    %eax,%edx
c01018b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b4:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018bb:	c0 
c01018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018bf:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018c6:	c0 08 00 
c01018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018cc:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018d3:	c0 
c01018d4:	83 e2 e0             	and    $0xffffffe0,%edx
c01018d7:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e1:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018e8:	c0 
c01018e9:	83 e2 1f             	and    $0x1f,%edx
c01018ec:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f6:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018fd:	c0 
c01018fe:	83 e2 f0             	and    $0xfffffff0,%edx
c0101901:	83 ca 0e             	or     $0xe,%edx
c0101904:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010190b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010190e:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101915:	c0 
c0101916:	83 e2 ef             	and    $0xffffffef,%edx
c0101919:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101920:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101923:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010192a:	c0 
c010192b:	83 e2 9f             	and    $0xffffff9f,%edx
c010192e:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101938:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010193f:	c0 
c0101940:	83 ca 80             	or     $0xffffff80,%edx
c0101943:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010194a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194d:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101954:	c1 e8 10             	shr    $0x10,%eax
c0101957:	89 c2                	mov    %eax,%edx
c0101959:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195c:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101963:	c0 
		i++;
c0101964:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	*     Notice: the argument of lidt is idt_pd. try to find it!
	*/

	extern uintptr_t __vectors[];
	int i = 0;
	while (i < 256) {
c0101968:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010196f:	0f 8e 30 ff ff ff    	jle    c01018a5 <idt_init+0x12>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
		i++;
	}
	SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
c0101975:	a1 00 78 11 c0       	mov    0xc0117800,%eax
c010197a:	66 a3 c0 84 11 c0    	mov    %ax,0xc01184c0
c0101980:	66 c7 05 c2 84 11 c0 	movw   $0x8,0xc01184c2
c0101987:	08 00 
c0101989:	0f b6 05 c4 84 11 c0 	movzbl 0xc01184c4,%eax
c0101990:	83 e0 e0             	and    $0xffffffe0,%eax
c0101993:	a2 c4 84 11 c0       	mov    %al,0xc01184c4
c0101998:	0f b6 05 c4 84 11 c0 	movzbl 0xc01184c4,%eax
c010199f:	83 e0 1f             	and    $0x1f,%eax
c01019a2:	a2 c4 84 11 c0       	mov    %al,0xc01184c4
c01019a7:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c01019ae:	83 c8 0f             	or     $0xf,%eax
c01019b1:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c01019b6:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c01019bd:	83 e0 ef             	and    $0xffffffef,%eax
c01019c0:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c01019c5:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c01019cc:	83 c8 60             	or     $0x60,%eax
c01019cf:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c01019d4:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c01019db:	83 c8 80             	or     $0xffffff80,%eax
c01019de:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c01019e3:	a1 00 78 11 c0       	mov    0xc0117800,%eax
c01019e8:	c1 e8 10             	shr    $0x10,%eax
c01019eb:	66 a3 c6 84 11 c0    	mov    %ax,0xc01184c6
c01019f1:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019fb:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c01019fe:	c9                   	leave  
c01019ff:	c3                   	ret    

c0101a00 <trapname>:


static const char *
trapname(int trapno) {
c0101a00:	55                   	push   %ebp
c0101a01:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a06:	83 f8 13             	cmp    $0x13,%eax
c0101a09:	77 0c                	ja     c0101a17 <trapname+0x17>
        return excnames[trapno];
c0101a0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0e:	8b 04 85 a0 66 10 c0 	mov    -0x3fef9960(,%eax,4),%eax
c0101a15:	eb 18                	jmp    c0101a2f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a17:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a1b:	7e 0d                	jle    c0101a2a <trapname+0x2a>
c0101a1d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a21:	7f 07                	jg     c0101a2a <trapname+0x2a>
        return "Hardware Interrupt";
c0101a23:	b8 4a 63 10 c0       	mov    $0xc010634a,%eax
c0101a28:	eb 05                	jmp    c0101a2f <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a2a:	b8 5d 63 10 c0       	mov    $0xc010635d,%eax
}
c0101a2f:	5d                   	pop    %ebp
c0101a30:	c3                   	ret    

c0101a31 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a31:	55                   	push   %ebp
c0101a32:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a37:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a3b:	66 83 f8 08          	cmp    $0x8,%ax
c0101a3f:	0f 94 c0             	sete   %al
c0101a42:	0f b6 c0             	movzbl %al,%eax
}
c0101a45:	5d                   	pop    %ebp
c0101a46:	c3                   	ret    

c0101a47 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a47:	55                   	push   %ebp
c0101a48:	89 e5                	mov    %esp,%ebp
c0101a4a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a54:	c7 04 24 9e 63 10 c0 	movl   $0xc010639e,(%esp)
c0101a5b:	e8 dc e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a63:	89 04 24             	mov    %eax,(%esp)
c0101a66:	e8 a1 01 00 00       	call   c0101c0c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a72:	0f b7 c0             	movzwl %ax,%eax
c0101a75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a79:	c7 04 24 af 63 10 c0 	movl   $0xc01063af,(%esp)
c0101a80:	e8 b7 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a88:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a8c:	0f b7 c0             	movzwl %ax,%eax
c0101a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a93:	c7 04 24 c2 63 10 c0 	movl   $0xc01063c2,(%esp)
c0101a9a:	e8 9d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa2:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aa6:	0f b7 c0             	movzwl %ax,%eax
c0101aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aad:	c7 04 24 d5 63 10 c0 	movl   $0xc01063d5,(%esp)
c0101ab4:	e8 83 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ac0:	0f b7 c0             	movzwl %ax,%eax
c0101ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac7:	c7 04 24 e8 63 10 c0 	movl   $0xc01063e8,(%esp)
c0101ace:	e8 69 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad6:	8b 40 30             	mov    0x30(%eax),%eax
c0101ad9:	89 04 24             	mov    %eax,(%esp)
c0101adc:	e8 1f ff ff ff       	call   c0101a00 <trapname>
c0101ae1:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ae4:	8b 52 30             	mov    0x30(%edx),%edx
c0101ae7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101aeb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101aef:	c7 04 24 fb 63 10 c0 	movl   $0xc01063fb,(%esp)
c0101af6:	e8 41 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101afe:	8b 40 34             	mov    0x34(%eax),%eax
c0101b01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b05:	c7 04 24 0d 64 10 c0 	movl   $0xc010640d,(%esp)
c0101b0c:	e8 2b e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b14:	8b 40 38             	mov    0x38(%eax),%eax
c0101b17:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b1b:	c7 04 24 1c 64 10 c0 	movl   $0xc010641c,(%esp)
c0101b22:	e8 15 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b2e:	0f b7 c0             	movzwl %ax,%eax
c0101b31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b35:	c7 04 24 2b 64 10 c0 	movl   $0xc010642b,(%esp)
c0101b3c:	e8 fb e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b44:	8b 40 40             	mov    0x40(%eax),%eax
c0101b47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b4b:	c7 04 24 3e 64 10 c0 	movl   $0xc010643e,(%esp)
c0101b52:	e8 e5 e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b5e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b65:	eb 3e                	jmp    c0101ba5 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6a:	8b 50 40             	mov    0x40(%eax),%edx
c0101b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b70:	21 d0                	and    %edx,%eax
c0101b72:	85 c0                	test   %eax,%eax
c0101b74:	74 28                	je     c0101b9e <print_trapframe+0x157>
c0101b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b79:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b80:	85 c0                	test   %eax,%eax
c0101b82:	74 1a                	je     c0101b9e <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b87:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b92:	c7 04 24 4d 64 10 c0 	movl   $0xc010644d,(%esp)
c0101b99:	e8 9e e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101ba2:	d1 65 f0             	shll   -0x10(%ebp)
c0101ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba8:	83 f8 17             	cmp    $0x17,%eax
c0101bab:	76 ba                	jbe    c0101b67 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb0:	8b 40 40             	mov    0x40(%eax),%eax
c0101bb3:	25 00 30 00 00       	and    $0x3000,%eax
c0101bb8:	c1 e8 0c             	shr    $0xc,%eax
c0101bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbf:	c7 04 24 51 64 10 c0 	movl   $0xc0106451,(%esp)
c0101bc6:	e8 71 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bce:	89 04 24             	mov    %eax,(%esp)
c0101bd1:	e8 5b fe ff ff       	call   c0101a31 <trap_in_kernel>
c0101bd6:	85 c0                	test   %eax,%eax
c0101bd8:	75 30                	jne    c0101c0a <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bdd:	8b 40 44             	mov    0x44(%eax),%eax
c0101be0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be4:	c7 04 24 5a 64 10 c0 	movl   $0xc010645a,(%esp)
c0101beb:	e8 4c e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf3:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bf7:	0f b7 c0             	movzwl %ax,%eax
c0101bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bfe:	c7 04 24 69 64 10 c0 	movl   $0xc0106469,(%esp)
c0101c05:	e8 32 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101c0a:	c9                   	leave  
c0101c0b:	c3                   	ret    

c0101c0c <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c0c:	55                   	push   %ebp
c0101c0d:	89 e5                	mov    %esp,%ebp
c0101c0f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c15:	8b 00                	mov    (%eax),%eax
c0101c17:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c1b:	c7 04 24 7c 64 10 c0 	movl   $0xc010647c,(%esp)
c0101c22:	e8 15 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2a:	8b 40 04             	mov    0x4(%eax),%eax
c0101c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c31:	c7 04 24 8b 64 10 c0 	movl   $0xc010648b,(%esp)
c0101c38:	e8 ff e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c40:	8b 40 08             	mov    0x8(%eax),%eax
c0101c43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c47:	c7 04 24 9a 64 10 c0 	movl   $0xc010649a,(%esp)
c0101c4e:	e8 e9 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c53:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c56:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5d:	c7 04 24 a9 64 10 c0 	movl   $0xc01064a9,(%esp)
c0101c64:	e8 d3 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6c:	8b 40 10             	mov    0x10(%eax),%eax
c0101c6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c73:	c7 04 24 b8 64 10 c0 	movl   $0xc01064b8,(%esp)
c0101c7a:	e8 bd e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c82:	8b 40 14             	mov    0x14(%eax),%eax
c0101c85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c89:	c7 04 24 c7 64 10 c0 	movl   $0xc01064c7,(%esp)
c0101c90:	e8 a7 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c98:	8b 40 18             	mov    0x18(%eax),%eax
c0101c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9f:	c7 04 24 d6 64 10 c0 	movl   $0xc01064d6,(%esp)
c0101ca6:	e8 91 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cae:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb5:	c7 04 24 e5 64 10 c0 	movl   $0xc01064e5,(%esp)
c0101cbc:	e8 7b e6 ff ff       	call   c010033c <cprintf>
}
c0101cc1:	c9                   	leave  
c0101cc2:	c3                   	ret    

c0101cc3 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cc3:	55                   	push   %ebp
c0101cc4:	89 e5                	mov    %esp,%ebp
c0101cc6:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ccc:	8b 40 30             	mov    0x30(%eax),%eax
c0101ccf:	83 f8 2f             	cmp    $0x2f,%eax
c0101cd2:	77 21                	ja     c0101cf5 <trap_dispatch+0x32>
c0101cd4:	83 f8 2e             	cmp    $0x2e,%eax
c0101cd7:	0f 83 03 01 00 00    	jae    c0101de0 <trap_dispatch+0x11d>
c0101cdd:	83 f8 21             	cmp    $0x21,%eax
c0101ce0:	0f 84 80 00 00 00    	je     c0101d66 <trap_dispatch+0xa3>
c0101ce6:	83 f8 24             	cmp    $0x24,%eax
c0101ce9:	74 55                	je     c0101d40 <trap_dispatch+0x7d>
c0101ceb:	83 f8 20             	cmp    $0x20,%eax
c0101cee:	74 16                	je     c0101d06 <trap_dispatch+0x43>
c0101cf0:	e9 b3 00 00 00       	jmp    c0101da8 <trap_dispatch+0xe5>
c0101cf5:	83 e8 78             	sub    $0x78,%eax
c0101cf8:	83 f8 01             	cmp    $0x1,%eax
c0101cfb:	0f 87 a7 00 00 00    	ja     c0101da8 <trap_dispatch+0xe5>
c0101d01:	e9 86 00 00 00       	jmp    c0101d8c <trap_dispatch+0xc9>
		/* handle the timer interrupt */
		/* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
		* (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
		* (3) Too Simple? Yes, I think so!
		*/
		ticks = (ticks + 1) % TICK_NUM;
c0101d06:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d0b:	8d 48 01             	lea    0x1(%eax),%ecx
c0101d0e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d13:	89 c8                	mov    %ecx,%eax
c0101d15:	f7 e2                	mul    %edx
c0101d17:	89 d0                	mov    %edx,%eax
c0101d19:	c1 e8 05             	shr    $0x5,%eax
c0101d1c:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d1f:	29 c1                	sub    %eax,%ecx
c0101d21:	89 c8                	mov    %ecx,%eax
c0101d23:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
		if (ticks == 0)
c0101d28:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d2d:	85 c0                	test   %eax,%eax
c0101d2f:	75 0a                	jne    c0101d3b <trap_dispatch+0x78>
			print_ticks();
c0101d31:	e8 41 fb ff ff       	call   c0101877 <print_ticks>
		break;
c0101d36:	e9 a6 00 00 00       	jmp    c0101de1 <trap_dispatch+0x11e>
c0101d3b:	e9 a1 00 00 00       	jmp    c0101de1 <trap_dispatch+0x11e>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d40:	e8 f6 f8 ff ff       	call   c010163b <cons_getc>
c0101d45:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d48:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d4c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d50:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d58:	c7 04 24 f4 64 10 c0 	movl   $0xc01064f4,(%esp)
c0101d5f:	e8 d8 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d64:	eb 7b                	jmp    c0101de1 <trap_dispatch+0x11e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d66:	e8 d0 f8 ff ff       	call   c010163b <cons_getc>
c0101d6b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d6e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d72:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d76:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d7e:	c7 04 24 06 65 10 c0 	movl   $0xc0106506,(%esp)
c0101d85:	e8 b2 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d8a:	eb 55                	jmp    c0101de1 <trap_dispatch+0x11e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d8c:	c7 44 24 08 15 65 10 	movl   $0xc0106515,0x8(%esp)
c0101d93:	c0 
c0101d94:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0101d9b:	00 
c0101d9c:	c7 04 24 25 65 10 c0 	movl   $0xc0106525,(%esp)
c0101da3:	e8 25 ef ff ff       	call   c0100ccd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101da8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dab:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101daf:	0f b7 c0             	movzwl %ax,%eax
c0101db2:	83 e0 03             	and    $0x3,%eax
c0101db5:	85 c0                	test   %eax,%eax
c0101db7:	75 28                	jne    c0101de1 <trap_dispatch+0x11e>
            print_trapframe(tf);
c0101db9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dbc:	89 04 24             	mov    %eax,(%esp)
c0101dbf:	e8 83 fc ff ff       	call   c0101a47 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101dc4:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0101dcb:	c0 
c0101dcc:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0101dd3:	00 
c0101dd4:	c7 04 24 25 65 10 c0 	movl   $0xc0106525,(%esp)
c0101ddb:	e8 ed ee ff ff       	call   c0100ccd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101de0:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101de1:	c9                   	leave  
c0101de2:	c3                   	ret    

c0101de3 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101de3:	55                   	push   %ebp
c0101de4:	89 e5                	mov    %esp,%ebp
c0101de6:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101de9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dec:	89 04 24             	mov    %eax,(%esp)
c0101def:	e8 cf fe ff ff       	call   c0101cc3 <trap_dispatch>
}
c0101df4:	c9                   	leave  
c0101df5:	c3                   	ret    

c0101df6 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101df6:	1e                   	push   %ds
    pushl %es
c0101df7:	06                   	push   %es
    pushl %fs
c0101df8:	0f a0                	push   %fs
    pushl %gs
c0101dfa:	0f a8                	push   %gs
    pushal
c0101dfc:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101dfd:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e02:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e04:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e06:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e07:	e8 d7 ff ff ff       	call   c0101de3 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e0c:	5c                   	pop    %esp

c0101e0d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e0d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e0e:	0f a9                	pop    %gs
    popl %fs
c0101e10:	0f a1                	pop    %fs
    popl %es
c0101e12:	07                   	pop    %es
    popl %ds
c0101e13:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e14:	83 c4 08             	add    $0x8,%esp
    iret
c0101e17:	cf                   	iret   

c0101e18 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e18:	6a 00                	push   $0x0
  pushl $0
c0101e1a:	6a 00                	push   $0x0
  jmp __alltraps
c0101e1c:	e9 d5 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e21 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e21:	6a 00                	push   $0x0
  pushl $1
c0101e23:	6a 01                	push   $0x1
  jmp __alltraps
c0101e25:	e9 cc ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e2a <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e2a:	6a 00                	push   $0x0
  pushl $2
c0101e2c:	6a 02                	push   $0x2
  jmp __alltraps
c0101e2e:	e9 c3 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e33 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e33:	6a 00                	push   $0x0
  pushl $3
c0101e35:	6a 03                	push   $0x3
  jmp __alltraps
c0101e37:	e9 ba ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e3c <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e3c:	6a 00                	push   $0x0
  pushl $4
c0101e3e:	6a 04                	push   $0x4
  jmp __alltraps
c0101e40:	e9 b1 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e45 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e45:	6a 00                	push   $0x0
  pushl $5
c0101e47:	6a 05                	push   $0x5
  jmp __alltraps
c0101e49:	e9 a8 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e4e <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e4e:	6a 00                	push   $0x0
  pushl $6
c0101e50:	6a 06                	push   $0x6
  jmp __alltraps
c0101e52:	e9 9f ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e57 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e57:	6a 00                	push   $0x0
  pushl $7
c0101e59:	6a 07                	push   $0x7
  jmp __alltraps
c0101e5b:	e9 96 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e60 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e60:	6a 08                	push   $0x8
  jmp __alltraps
c0101e62:	e9 8f ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e67 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e67:	6a 09                	push   $0x9
  jmp __alltraps
c0101e69:	e9 88 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e6e <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e6e:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e70:	e9 81 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e75 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e75:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e77:	e9 7a ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e7c <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e7c:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e7e:	e9 73 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e83 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e83:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e85:	e9 6c ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e8a <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e8a:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e8c:	e9 65 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e91 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e91:	6a 00                	push   $0x0
  pushl $15
c0101e93:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e95:	e9 5c ff ff ff       	jmp    c0101df6 <__alltraps>

c0101e9a <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e9a:	6a 00                	push   $0x0
  pushl $16
c0101e9c:	6a 10                	push   $0x10
  jmp __alltraps
c0101e9e:	e9 53 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101ea3 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ea3:	6a 11                	push   $0x11
  jmp __alltraps
c0101ea5:	e9 4c ff ff ff       	jmp    c0101df6 <__alltraps>

c0101eaa <vector18>:
.globl vector18
vector18:
  pushl $0
c0101eaa:	6a 00                	push   $0x0
  pushl $18
c0101eac:	6a 12                	push   $0x12
  jmp __alltraps
c0101eae:	e9 43 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101eb3 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101eb3:	6a 00                	push   $0x0
  pushl $19
c0101eb5:	6a 13                	push   $0x13
  jmp __alltraps
c0101eb7:	e9 3a ff ff ff       	jmp    c0101df6 <__alltraps>

c0101ebc <vector20>:
.globl vector20
vector20:
  pushl $0
c0101ebc:	6a 00                	push   $0x0
  pushl $20
c0101ebe:	6a 14                	push   $0x14
  jmp __alltraps
c0101ec0:	e9 31 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101ec5 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101ec5:	6a 00                	push   $0x0
  pushl $21
c0101ec7:	6a 15                	push   $0x15
  jmp __alltraps
c0101ec9:	e9 28 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101ece <vector22>:
.globl vector22
vector22:
  pushl $0
c0101ece:	6a 00                	push   $0x0
  pushl $22
c0101ed0:	6a 16                	push   $0x16
  jmp __alltraps
c0101ed2:	e9 1f ff ff ff       	jmp    c0101df6 <__alltraps>

c0101ed7 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101ed7:	6a 00                	push   $0x0
  pushl $23
c0101ed9:	6a 17                	push   $0x17
  jmp __alltraps
c0101edb:	e9 16 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101ee0 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ee0:	6a 00                	push   $0x0
  pushl $24
c0101ee2:	6a 18                	push   $0x18
  jmp __alltraps
c0101ee4:	e9 0d ff ff ff       	jmp    c0101df6 <__alltraps>

c0101ee9 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101ee9:	6a 00                	push   $0x0
  pushl $25
c0101eeb:	6a 19                	push   $0x19
  jmp __alltraps
c0101eed:	e9 04 ff ff ff       	jmp    c0101df6 <__alltraps>

c0101ef2 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ef2:	6a 00                	push   $0x0
  pushl $26
c0101ef4:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ef6:	e9 fb fe ff ff       	jmp    c0101df6 <__alltraps>

c0101efb <vector27>:
.globl vector27
vector27:
  pushl $0
c0101efb:	6a 00                	push   $0x0
  pushl $27
c0101efd:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101eff:	e9 f2 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f04 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f04:	6a 00                	push   $0x0
  pushl $28
c0101f06:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f08:	e9 e9 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f0d <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f0d:	6a 00                	push   $0x0
  pushl $29
c0101f0f:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f11:	e9 e0 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f16 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f16:	6a 00                	push   $0x0
  pushl $30
c0101f18:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f1a:	e9 d7 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f1f <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f1f:	6a 00                	push   $0x0
  pushl $31
c0101f21:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f23:	e9 ce fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f28 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f28:	6a 00                	push   $0x0
  pushl $32
c0101f2a:	6a 20                	push   $0x20
  jmp __alltraps
c0101f2c:	e9 c5 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f31 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f31:	6a 00                	push   $0x0
  pushl $33
c0101f33:	6a 21                	push   $0x21
  jmp __alltraps
c0101f35:	e9 bc fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f3a <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f3a:	6a 00                	push   $0x0
  pushl $34
c0101f3c:	6a 22                	push   $0x22
  jmp __alltraps
c0101f3e:	e9 b3 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f43 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f43:	6a 00                	push   $0x0
  pushl $35
c0101f45:	6a 23                	push   $0x23
  jmp __alltraps
c0101f47:	e9 aa fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f4c <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f4c:	6a 00                	push   $0x0
  pushl $36
c0101f4e:	6a 24                	push   $0x24
  jmp __alltraps
c0101f50:	e9 a1 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f55 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f55:	6a 00                	push   $0x0
  pushl $37
c0101f57:	6a 25                	push   $0x25
  jmp __alltraps
c0101f59:	e9 98 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f5e <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f5e:	6a 00                	push   $0x0
  pushl $38
c0101f60:	6a 26                	push   $0x26
  jmp __alltraps
c0101f62:	e9 8f fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f67 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f67:	6a 00                	push   $0x0
  pushl $39
c0101f69:	6a 27                	push   $0x27
  jmp __alltraps
c0101f6b:	e9 86 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f70 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f70:	6a 00                	push   $0x0
  pushl $40
c0101f72:	6a 28                	push   $0x28
  jmp __alltraps
c0101f74:	e9 7d fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f79 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f79:	6a 00                	push   $0x0
  pushl $41
c0101f7b:	6a 29                	push   $0x29
  jmp __alltraps
c0101f7d:	e9 74 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f82 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f82:	6a 00                	push   $0x0
  pushl $42
c0101f84:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f86:	e9 6b fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f8b <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f8b:	6a 00                	push   $0x0
  pushl $43
c0101f8d:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f8f:	e9 62 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f94 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f94:	6a 00                	push   $0x0
  pushl $44
c0101f96:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f98:	e9 59 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101f9d <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f9d:	6a 00                	push   $0x0
  pushl $45
c0101f9f:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fa1:	e9 50 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101fa6 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101fa6:	6a 00                	push   $0x0
  pushl $46
c0101fa8:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101faa:	e9 47 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101faf <vector47>:
.globl vector47
vector47:
  pushl $0
c0101faf:	6a 00                	push   $0x0
  pushl $47
c0101fb1:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fb3:	e9 3e fe ff ff       	jmp    c0101df6 <__alltraps>

c0101fb8 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fb8:	6a 00                	push   $0x0
  pushl $48
c0101fba:	6a 30                	push   $0x30
  jmp __alltraps
c0101fbc:	e9 35 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101fc1 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fc1:	6a 00                	push   $0x0
  pushl $49
c0101fc3:	6a 31                	push   $0x31
  jmp __alltraps
c0101fc5:	e9 2c fe ff ff       	jmp    c0101df6 <__alltraps>

c0101fca <vector50>:
.globl vector50
vector50:
  pushl $0
c0101fca:	6a 00                	push   $0x0
  pushl $50
c0101fcc:	6a 32                	push   $0x32
  jmp __alltraps
c0101fce:	e9 23 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101fd3 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fd3:	6a 00                	push   $0x0
  pushl $51
c0101fd5:	6a 33                	push   $0x33
  jmp __alltraps
c0101fd7:	e9 1a fe ff ff       	jmp    c0101df6 <__alltraps>

c0101fdc <vector52>:
.globl vector52
vector52:
  pushl $0
c0101fdc:	6a 00                	push   $0x0
  pushl $52
c0101fde:	6a 34                	push   $0x34
  jmp __alltraps
c0101fe0:	e9 11 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101fe5 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101fe5:	6a 00                	push   $0x0
  pushl $53
c0101fe7:	6a 35                	push   $0x35
  jmp __alltraps
c0101fe9:	e9 08 fe ff ff       	jmp    c0101df6 <__alltraps>

c0101fee <vector54>:
.globl vector54
vector54:
  pushl $0
c0101fee:	6a 00                	push   $0x0
  pushl $54
c0101ff0:	6a 36                	push   $0x36
  jmp __alltraps
c0101ff2:	e9 ff fd ff ff       	jmp    c0101df6 <__alltraps>

c0101ff7 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101ff7:	6a 00                	push   $0x0
  pushl $55
c0101ff9:	6a 37                	push   $0x37
  jmp __alltraps
c0101ffb:	e9 f6 fd ff ff       	jmp    c0101df6 <__alltraps>

c0102000 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102000:	6a 00                	push   $0x0
  pushl $56
c0102002:	6a 38                	push   $0x38
  jmp __alltraps
c0102004:	e9 ed fd ff ff       	jmp    c0101df6 <__alltraps>

c0102009 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102009:	6a 00                	push   $0x0
  pushl $57
c010200b:	6a 39                	push   $0x39
  jmp __alltraps
c010200d:	e9 e4 fd ff ff       	jmp    c0101df6 <__alltraps>

c0102012 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102012:	6a 00                	push   $0x0
  pushl $58
c0102014:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102016:	e9 db fd ff ff       	jmp    c0101df6 <__alltraps>

c010201b <vector59>:
.globl vector59
vector59:
  pushl $0
c010201b:	6a 00                	push   $0x0
  pushl $59
c010201d:	6a 3b                	push   $0x3b
  jmp __alltraps
c010201f:	e9 d2 fd ff ff       	jmp    c0101df6 <__alltraps>

c0102024 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102024:	6a 00                	push   $0x0
  pushl $60
c0102026:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102028:	e9 c9 fd ff ff       	jmp    c0101df6 <__alltraps>

c010202d <vector61>:
.globl vector61
vector61:
  pushl $0
c010202d:	6a 00                	push   $0x0
  pushl $61
c010202f:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102031:	e9 c0 fd ff ff       	jmp    c0101df6 <__alltraps>

c0102036 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102036:	6a 00                	push   $0x0
  pushl $62
c0102038:	6a 3e                	push   $0x3e
  jmp __alltraps
c010203a:	e9 b7 fd ff ff       	jmp    c0101df6 <__alltraps>

c010203f <vector63>:
.globl vector63
vector63:
  pushl $0
c010203f:	6a 00                	push   $0x0
  pushl $63
c0102041:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102043:	e9 ae fd ff ff       	jmp    c0101df6 <__alltraps>

c0102048 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102048:	6a 00                	push   $0x0
  pushl $64
c010204a:	6a 40                	push   $0x40
  jmp __alltraps
c010204c:	e9 a5 fd ff ff       	jmp    c0101df6 <__alltraps>

c0102051 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102051:	6a 00                	push   $0x0
  pushl $65
c0102053:	6a 41                	push   $0x41
  jmp __alltraps
c0102055:	e9 9c fd ff ff       	jmp    c0101df6 <__alltraps>

c010205a <vector66>:
.globl vector66
vector66:
  pushl $0
c010205a:	6a 00                	push   $0x0
  pushl $66
c010205c:	6a 42                	push   $0x42
  jmp __alltraps
c010205e:	e9 93 fd ff ff       	jmp    c0101df6 <__alltraps>

c0102063 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102063:	6a 00                	push   $0x0
  pushl $67
c0102065:	6a 43                	push   $0x43
  jmp __alltraps
c0102067:	e9 8a fd ff ff       	jmp    c0101df6 <__alltraps>

c010206c <vector68>:
.globl vector68
vector68:
  pushl $0
c010206c:	6a 00                	push   $0x0
  pushl $68
c010206e:	6a 44                	push   $0x44
  jmp __alltraps
c0102070:	e9 81 fd ff ff       	jmp    c0101df6 <__alltraps>

c0102075 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102075:	6a 00                	push   $0x0
  pushl $69
c0102077:	6a 45                	push   $0x45
  jmp __alltraps
c0102079:	e9 78 fd ff ff       	jmp    c0101df6 <__alltraps>

c010207e <vector70>:
.globl vector70
vector70:
  pushl $0
c010207e:	6a 00                	push   $0x0
  pushl $70
c0102080:	6a 46                	push   $0x46
  jmp __alltraps
c0102082:	e9 6f fd ff ff       	jmp    c0101df6 <__alltraps>

c0102087 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102087:	6a 00                	push   $0x0
  pushl $71
c0102089:	6a 47                	push   $0x47
  jmp __alltraps
c010208b:	e9 66 fd ff ff       	jmp    c0101df6 <__alltraps>

c0102090 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102090:	6a 00                	push   $0x0
  pushl $72
c0102092:	6a 48                	push   $0x48
  jmp __alltraps
c0102094:	e9 5d fd ff ff       	jmp    c0101df6 <__alltraps>

c0102099 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102099:	6a 00                	push   $0x0
  pushl $73
c010209b:	6a 49                	push   $0x49
  jmp __alltraps
c010209d:	e9 54 fd ff ff       	jmp    c0101df6 <__alltraps>

c01020a2 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020a2:	6a 00                	push   $0x0
  pushl $74
c01020a4:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020a6:	e9 4b fd ff ff       	jmp    c0101df6 <__alltraps>

c01020ab <vector75>:
.globl vector75
vector75:
  pushl $0
c01020ab:	6a 00                	push   $0x0
  pushl $75
c01020ad:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020af:	e9 42 fd ff ff       	jmp    c0101df6 <__alltraps>

c01020b4 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020b4:	6a 00                	push   $0x0
  pushl $76
c01020b6:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020b8:	e9 39 fd ff ff       	jmp    c0101df6 <__alltraps>

c01020bd <vector77>:
.globl vector77
vector77:
  pushl $0
c01020bd:	6a 00                	push   $0x0
  pushl $77
c01020bf:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020c1:	e9 30 fd ff ff       	jmp    c0101df6 <__alltraps>

c01020c6 <vector78>:
.globl vector78
vector78:
  pushl $0
c01020c6:	6a 00                	push   $0x0
  pushl $78
c01020c8:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020ca:	e9 27 fd ff ff       	jmp    c0101df6 <__alltraps>

c01020cf <vector79>:
.globl vector79
vector79:
  pushl $0
c01020cf:	6a 00                	push   $0x0
  pushl $79
c01020d1:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020d3:	e9 1e fd ff ff       	jmp    c0101df6 <__alltraps>

c01020d8 <vector80>:
.globl vector80
vector80:
  pushl $0
c01020d8:	6a 00                	push   $0x0
  pushl $80
c01020da:	6a 50                	push   $0x50
  jmp __alltraps
c01020dc:	e9 15 fd ff ff       	jmp    c0101df6 <__alltraps>

c01020e1 <vector81>:
.globl vector81
vector81:
  pushl $0
c01020e1:	6a 00                	push   $0x0
  pushl $81
c01020e3:	6a 51                	push   $0x51
  jmp __alltraps
c01020e5:	e9 0c fd ff ff       	jmp    c0101df6 <__alltraps>

c01020ea <vector82>:
.globl vector82
vector82:
  pushl $0
c01020ea:	6a 00                	push   $0x0
  pushl $82
c01020ec:	6a 52                	push   $0x52
  jmp __alltraps
c01020ee:	e9 03 fd ff ff       	jmp    c0101df6 <__alltraps>

c01020f3 <vector83>:
.globl vector83
vector83:
  pushl $0
c01020f3:	6a 00                	push   $0x0
  pushl $83
c01020f5:	6a 53                	push   $0x53
  jmp __alltraps
c01020f7:	e9 fa fc ff ff       	jmp    c0101df6 <__alltraps>

c01020fc <vector84>:
.globl vector84
vector84:
  pushl $0
c01020fc:	6a 00                	push   $0x0
  pushl $84
c01020fe:	6a 54                	push   $0x54
  jmp __alltraps
c0102100:	e9 f1 fc ff ff       	jmp    c0101df6 <__alltraps>

c0102105 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102105:	6a 00                	push   $0x0
  pushl $85
c0102107:	6a 55                	push   $0x55
  jmp __alltraps
c0102109:	e9 e8 fc ff ff       	jmp    c0101df6 <__alltraps>

c010210e <vector86>:
.globl vector86
vector86:
  pushl $0
c010210e:	6a 00                	push   $0x0
  pushl $86
c0102110:	6a 56                	push   $0x56
  jmp __alltraps
c0102112:	e9 df fc ff ff       	jmp    c0101df6 <__alltraps>

c0102117 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102117:	6a 00                	push   $0x0
  pushl $87
c0102119:	6a 57                	push   $0x57
  jmp __alltraps
c010211b:	e9 d6 fc ff ff       	jmp    c0101df6 <__alltraps>

c0102120 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102120:	6a 00                	push   $0x0
  pushl $88
c0102122:	6a 58                	push   $0x58
  jmp __alltraps
c0102124:	e9 cd fc ff ff       	jmp    c0101df6 <__alltraps>

c0102129 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102129:	6a 00                	push   $0x0
  pushl $89
c010212b:	6a 59                	push   $0x59
  jmp __alltraps
c010212d:	e9 c4 fc ff ff       	jmp    c0101df6 <__alltraps>

c0102132 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102132:	6a 00                	push   $0x0
  pushl $90
c0102134:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102136:	e9 bb fc ff ff       	jmp    c0101df6 <__alltraps>

c010213b <vector91>:
.globl vector91
vector91:
  pushl $0
c010213b:	6a 00                	push   $0x0
  pushl $91
c010213d:	6a 5b                	push   $0x5b
  jmp __alltraps
c010213f:	e9 b2 fc ff ff       	jmp    c0101df6 <__alltraps>

c0102144 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102144:	6a 00                	push   $0x0
  pushl $92
c0102146:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102148:	e9 a9 fc ff ff       	jmp    c0101df6 <__alltraps>

c010214d <vector93>:
.globl vector93
vector93:
  pushl $0
c010214d:	6a 00                	push   $0x0
  pushl $93
c010214f:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102151:	e9 a0 fc ff ff       	jmp    c0101df6 <__alltraps>

c0102156 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102156:	6a 00                	push   $0x0
  pushl $94
c0102158:	6a 5e                	push   $0x5e
  jmp __alltraps
c010215a:	e9 97 fc ff ff       	jmp    c0101df6 <__alltraps>

c010215f <vector95>:
.globl vector95
vector95:
  pushl $0
c010215f:	6a 00                	push   $0x0
  pushl $95
c0102161:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102163:	e9 8e fc ff ff       	jmp    c0101df6 <__alltraps>

c0102168 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102168:	6a 00                	push   $0x0
  pushl $96
c010216a:	6a 60                	push   $0x60
  jmp __alltraps
c010216c:	e9 85 fc ff ff       	jmp    c0101df6 <__alltraps>

c0102171 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102171:	6a 00                	push   $0x0
  pushl $97
c0102173:	6a 61                	push   $0x61
  jmp __alltraps
c0102175:	e9 7c fc ff ff       	jmp    c0101df6 <__alltraps>

c010217a <vector98>:
.globl vector98
vector98:
  pushl $0
c010217a:	6a 00                	push   $0x0
  pushl $98
c010217c:	6a 62                	push   $0x62
  jmp __alltraps
c010217e:	e9 73 fc ff ff       	jmp    c0101df6 <__alltraps>

c0102183 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102183:	6a 00                	push   $0x0
  pushl $99
c0102185:	6a 63                	push   $0x63
  jmp __alltraps
c0102187:	e9 6a fc ff ff       	jmp    c0101df6 <__alltraps>

c010218c <vector100>:
.globl vector100
vector100:
  pushl $0
c010218c:	6a 00                	push   $0x0
  pushl $100
c010218e:	6a 64                	push   $0x64
  jmp __alltraps
c0102190:	e9 61 fc ff ff       	jmp    c0101df6 <__alltraps>

c0102195 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102195:	6a 00                	push   $0x0
  pushl $101
c0102197:	6a 65                	push   $0x65
  jmp __alltraps
c0102199:	e9 58 fc ff ff       	jmp    c0101df6 <__alltraps>

c010219e <vector102>:
.globl vector102
vector102:
  pushl $0
c010219e:	6a 00                	push   $0x0
  pushl $102
c01021a0:	6a 66                	push   $0x66
  jmp __alltraps
c01021a2:	e9 4f fc ff ff       	jmp    c0101df6 <__alltraps>

c01021a7 <vector103>:
.globl vector103
vector103:
  pushl $0
c01021a7:	6a 00                	push   $0x0
  pushl $103
c01021a9:	6a 67                	push   $0x67
  jmp __alltraps
c01021ab:	e9 46 fc ff ff       	jmp    c0101df6 <__alltraps>

c01021b0 <vector104>:
.globl vector104
vector104:
  pushl $0
c01021b0:	6a 00                	push   $0x0
  pushl $104
c01021b2:	6a 68                	push   $0x68
  jmp __alltraps
c01021b4:	e9 3d fc ff ff       	jmp    c0101df6 <__alltraps>

c01021b9 <vector105>:
.globl vector105
vector105:
  pushl $0
c01021b9:	6a 00                	push   $0x0
  pushl $105
c01021bb:	6a 69                	push   $0x69
  jmp __alltraps
c01021bd:	e9 34 fc ff ff       	jmp    c0101df6 <__alltraps>

c01021c2 <vector106>:
.globl vector106
vector106:
  pushl $0
c01021c2:	6a 00                	push   $0x0
  pushl $106
c01021c4:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021c6:	e9 2b fc ff ff       	jmp    c0101df6 <__alltraps>

c01021cb <vector107>:
.globl vector107
vector107:
  pushl $0
c01021cb:	6a 00                	push   $0x0
  pushl $107
c01021cd:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021cf:	e9 22 fc ff ff       	jmp    c0101df6 <__alltraps>

c01021d4 <vector108>:
.globl vector108
vector108:
  pushl $0
c01021d4:	6a 00                	push   $0x0
  pushl $108
c01021d6:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021d8:	e9 19 fc ff ff       	jmp    c0101df6 <__alltraps>

c01021dd <vector109>:
.globl vector109
vector109:
  pushl $0
c01021dd:	6a 00                	push   $0x0
  pushl $109
c01021df:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021e1:	e9 10 fc ff ff       	jmp    c0101df6 <__alltraps>

c01021e6 <vector110>:
.globl vector110
vector110:
  pushl $0
c01021e6:	6a 00                	push   $0x0
  pushl $110
c01021e8:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021ea:	e9 07 fc ff ff       	jmp    c0101df6 <__alltraps>

c01021ef <vector111>:
.globl vector111
vector111:
  pushl $0
c01021ef:	6a 00                	push   $0x0
  pushl $111
c01021f1:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021f3:	e9 fe fb ff ff       	jmp    c0101df6 <__alltraps>

c01021f8 <vector112>:
.globl vector112
vector112:
  pushl $0
c01021f8:	6a 00                	push   $0x0
  pushl $112
c01021fa:	6a 70                	push   $0x70
  jmp __alltraps
c01021fc:	e9 f5 fb ff ff       	jmp    c0101df6 <__alltraps>

c0102201 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102201:	6a 00                	push   $0x0
  pushl $113
c0102203:	6a 71                	push   $0x71
  jmp __alltraps
c0102205:	e9 ec fb ff ff       	jmp    c0101df6 <__alltraps>

c010220a <vector114>:
.globl vector114
vector114:
  pushl $0
c010220a:	6a 00                	push   $0x0
  pushl $114
c010220c:	6a 72                	push   $0x72
  jmp __alltraps
c010220e:	e9 e3 fb ff ff       	jmp    c0101df6 <__alltraps>

c0102213 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102213:	6a 00                	push   $0x0
  pushl $115
c0102215:	6a 73                	push   $0x73
  jmp __alltraps
c0102217:	e9 da fb ff ff       	jmp    c0101df6 <__alltraps>

c010221c <vector116>:
.globl vector116
vector116:
  pushl $0
c010221c:	6a 00                	push   $0x0
  pushl $116
c010221e:	6a 74                	push   $0x74
  jmp __alltraps
c0102220:	e9 d1 fb ff ff       	jmp    c0101df6 <__alltraps>

c0102225 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102225:	6a 00                	push   $0x0
  pushl $117
c0102227:	6a 75                	push   $0x75
  jmp __alltraps
c0102229:	e9 c8 fb ff ff       	jmp    c0101df6 <__alltraps>

c010222e <vector118>:
.globl vector118
vector118:
  pushl $0
c010222e:	6a 00                	push   $0x0
  pushl $118
c0102230:	6a 76                	push   $0x76
  jmp __alltraps
c0102232:	e9 bf fb ff ff       	jmp    c0101df6 <__alltraps>

c0102237 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102237:	6a 00                	push   $0x0
  pushl $119
c0102239:	6a 77                	push   $0x77
  jmp __alltraps
c010223b:	e9 b6 fb ff ff       	jmp    c0101df6 <__alltraps>

c0102240 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102240:	6a 00                	push   $0x0
  pushl $120
c0102242:	6a 78                	push   $0x78
  jmp __alltraps
c0102244:	e9 ad fb ff ff       	jmp    c0101df6 <__alltraps>

c0102249 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102249:	6a 00                	push   $0x0
  pushl $121
c010224b:	6a 79                	push   $0x79
  jmp __alltraps
c010224d:	e9 a4 fb ff ff       	jmp    c0101df6 <__alltraps>

c0102252 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102252:	6a 00                	push   $0x0
  pushl $122
c0102254:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102256:	e9 9b fb ff ff       	jmp    c0101df6 <__alltraps>

c010225b <vector123>:
.globl vector123
vector123:
  pushl $0
c010225b:	6a 00                	push   $0x0
  pushl $123
c010225d:	6a 7b                	push   $0x7b
  jmp __alltraps
c010225f:	e9 92 fb ff ff       	jmp    c0101df6 <__alltraps>

c0102264 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102264:	6a 00                	push   $0x0
  pushl $124
c0102266:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102268:	e9 89 fb ff ff       	jmp    c0101df6 <__alltraps>

c010226d <vector125>:
.globl vector125
vector125:
  pushl $0
c010226d:	6a 00                	push   $0x0
  pushl $125
c010226f:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102271:	e9 80 fb ff ff       	jmp    c0101df6 <__alltraps>

c0102276 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102276:	6a 00                	push   $0x0
  pushl $126
c0102278:	6a 7e                	push   $0x7e
  jmp __alltraps
c010227a:	e9 77 fb ff ff       	jmp    c0101df6 <__alltraps>

c010227f <vector127>:
.globl vector127
vector127:
  pushl $0
c010227f:	6a 00                	push   $0x0
  pushl $127
c0102281:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102283:	e9 6e fb ff ff       	jmp    c0101df6 <__alltraps>

c0102288 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102288:	6a 00                	push   $0x0
  pushl $128
c010228a:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010228f:	e9 62 fb ff ff       	jmp    c0101df6 <__alltraps>

c0102294 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $129
c0102296:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010229b:	e9 56 fb ff ff       	jmp    c0101df6 <__alltraps>

c01022a0 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022a0:	6a 00                	push   $0x0
  pushl $130
c01022a2:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022a7:	e9 4a fb ff ff       	jmp    c0101df6 <__alltraps>

c01022ac <vector131>:
.globl vector131
vector131:
  pushl $0
c01022ac:	6a 00                	push   $0x0
  pushl $131
c01022ae:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022b3:	e9 3e fb ff ff       	jmp    c0101df6 <__alltraps>

c01022b8 <vector132>:
.globl vector132
vector132:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $132
c01022ba:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022bf:	e9 32 fb ff ff       	jmp    c0101df6 <__alltraps>

c01022c4 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022c4:	6a 00                	push   $0x0
  pushl $133
c01022c6:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022cb:	e9 26 fb ff ff       	jmp    c0101df6 <__alltraps>

c01022d0 <vector134>:
.globl vector134
vector134:
  pushl $0
c01022d0:	6a 00                	push   $0x0
  pushl $134
c01022d2:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022d7:	e9 1a fb ff ff       	jmp    c0101df6 <__alltraps>

c01022dc <vector135>:
.globl vector135
vector135:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $135
c01022de:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022e3:	e9 0e fb ff ff       	jmp    c0101df6 <__alltraps>

c01022e8 <vector136>:
.globl vector136
vector136:
  pushl $0
c01022e8:	6a 00                	push   $0x0
  pushl $136
c01022ea:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022ef:	e9 02 fb ff ff       	jmp    c0101df6 <__alltraps>

c01022f4 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022f4:	6a 00                	push   $0x0
  pushl $137
c01022f6:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022fb:	e9 f6 fa ff ff       	jmp    c0101df6 <__alltraps>

c0102300 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $138
c0102302:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102307:	e9 ea fa ff ff       	jmp    c0101df6 <__alltraps>

c010230c <vector139>:
.globl vector139
vector139:
  pushl $0
c010230c:	6a 00                	push   $0x0
  pushl $139
c010230e:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102313:	e9 de fa ff ff       	jmp    c0101df6 <__alltraps>

c0102318 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102318:	6a 00                	push   $0x0
  pushl $140
c010231a:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010231f:	e9 d2 fa ff ff       	jmp    c0101df6 <__alltraps>

c0102324 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $141
c0102326:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010232b:	e9 c6 fa ff ff       	jmp    c0101df6 <__alltraps>

c0102330 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102330:	6a 00                	push   $0x0
  pushl $142
c0102332:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102337:	e9 ba fa ff ff       	jmp    c0101df6 <__alltraps>

c010233c <vector143>:
.globl vector143
vector143:
  pushl $0
c010233c:	6a 00                	push   $0x0
  pushl $143
c010233e:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102343:	e9 ae fa ff ff       	jmp    c0101df6 <__alltraps>

c0102348 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $144
c010234a:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010234f:	e9 a2 fa ff ff       	jmp    c0101df6 <__alltraps>

c0102354 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102354:	6a 00                	push   $0x0
  pushl $145
c0102356:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010235b:	e9 96 fa ff ff       	jmp    c0101df6 <__alltraps>

c0102360 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102360:	6a 00                	push   $0x0
  pushl $146
c0102362:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102367:	e9 8a fa ff ff       	jmp    c0101df6 <__alltraps>

c010236c <vector147>:
.globl vector147
vector147:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $147
c010236e:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102373:	e9 7e fa ff ff       	jmp    c0101df6 <__alltraps>

c0102378 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102378:	6a 00                	push   $0x0
  pushl $148
c010237a:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010237f:	e9 72 fa ff ff       	jmp    c0101df6 <__alltraps>

c0102384 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102384:	6a 00                	push   $0x0
  pushl $149
c0102386:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010238b:	e9 66 fa ff ff       	jmp    c0101df6 <__alltraps>

c0102390 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $150
c0102392:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102397:	e9 5a fa ff ff       	jmp    c0101df6 <__alltraps>

c010239c <vector151>:
.globl vector151
vector151:
  pushl $0
c010239c:	6a 00                	push   $0x0
  pushl $151
c010239e:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023a3:	e9 4e fa ff ff       	jmp    c0101df6 <__alltraps>

c01023a8 <vector152>:
.globl vector152
vector152:
  pushl $0
c01023a8:	6a 00                	push   $0x0
  pushl $152
c01023aa:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023af:	e9 42 fa ff ff       	jmp    c0101df6 <__alltraps>

c01023b4 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $153
c01023b6:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023bb:	e9 36 fa ff ff       	jmp    c0101df6 <__alltraps>

c01023c0 <vector154>:
.globl vector154
vector154:
  pushl $0
c01023c0:	6a 00                	push   $0x0
  pushl $154
c01023c2:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023c7:	e9 2a fa ff ff       	jmp    c0101df6 <__alltraps>

c01023cc <vector155>:
.globl vector155
vector155:
  pushl $0
c01023cc:	6a 00                	push   $0x0
  pushl $155
c01023ce:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023d3:	e9 1e fa ff ff       	jmp    c0101df6 <__alltraps>

c01023d8 <vector156>:
.globl vector156
vector156:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $156
c01023da:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023df:	e9 12 fa ff ff       	jmp    c0101df6 <__alltraps>

c01023e4 <vector157>:
.globl vector157
vector157:
  pushl $0
c01023e4:	6a 00                	push   $0x0
  pushl $157
c01023e6:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023eb:	e9 06 fa ff ff       	jmp    c0101df6 <__alltraps>

c01023f0 <vector158>:
.globl vector158
vector158:
  pushl $0
c01023f0:	6a 00                	push   $0x0
  pushl $158
c01023f2:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023f7:	e9 fa f9 ff ff       	jmp    c0101df6 <__alltraps>

c01023fc <vector159>:
.globl vector159
vector159:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $159
c01023fe:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102403:	e9 ee f9 ff ff       	jmp    c0101df6 <__alltraps>

c0102408 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102408:	6a 00                	push   $0x0
  pushl $160
c010240a:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010240f:	e9 e2 f9 ff ff       	jmp    c0101df6 <__alltraps>

c0102414 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102414:	6a 00                	push   $0x0
  pushl $161
c0102416:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010241b:	e9 d6 f9 ff ff       	jmp    c0101df6 <__alltraps>

c0102420 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $162
c0102422:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102427:	e9 ca f9 ff ff       	jmp    c0101df6 <__alltraps>

c010242c <vector163>:
.globl vector163
vector163:
  pushl $0
c010242c:	6a 00                	push   $0x0
  pushl $163
c010242e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102433:	e9 be f9 ff ff       	jmp    c0101df6 <__alltraps>

c0102438 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102438:	6a 00                	push   $0x0
  pushl $164
c010243a:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010243f:	e9 b2 f9 ff ff       	jmp    c0101df6 <__alltraps>

c0102444 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $165
c0102446:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010244b:	e9 a6 f9 ff ff       	jmp    c0101df6 <__alltraps>

c0102450 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102450:	6a 00                	push   $0x0
  pushl $166
c0102452:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102457:	e9 9a f9 ff ff       	jmp    c0101df6 <__alltraps>

c010245c <vector167>:
.globl vector167
vector167:
  pushl $0
c010245c:	6a 00                	push   $0x0
  pushl $167
c010245e:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102463:	e9 8e f9 ff ff       	jmp    c0101df6 <__alltraps>

c0102468 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $168
c010246a:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010246f:	e9 82 f9 ff ff       	jmp    c0101df6 <__alltraps>

c0102474 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102474:	6a 00                	push   $0x0
  pushl $169
c0102476:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010247b:	e9 76 f9 ff ff       	jmp    c0101df6 <__alltraps>

c0102480 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102480:	6a 00                	push   $0x0
  pushl $170
c0102482:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102487:	e9 6a f9 ff ff       	jmp    c0101df6 <__alltraps>

c010248c <vector171>:
.globl vector171
vector171:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $171
c010248e:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102493:	e9 5e f9 ff ff       	jmp    c0101df6 <__alltraps>

c0102498 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102498:	6a 00                	push   $0x0
  pushl $172
c010249a:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010249f:	e9 52 f9 ff ff       	jmp    c0101df6 <__alltraps>

c01024a4 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024a4:	6a 00                	push   $0x0
  pushl $173
c01024a6:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024ab:	e9 46 f9 ff ff       	jmp    c0101df6 <__alltraps>

c01024b0 <vector174>:
.globl vector174
vector174:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $174
c01024b2:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024b7:	e9 3a f9 ff ff       	jmp    c0101df6 <__alltraps>

c01024bc <vector175>:
.globl vector175
vector175:
  pushl $0
c01024bc:	6a 00                	push   $0x0
  pushl $175
c01024be:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024c3:	e9 2e f9 ff ff       	jmp    c0101df6 <__alltraps>

c01024c8 <vector176>:
.globl vector176
vector176:
  pushl $0
c01024c8:	6a 00                	push   $0x0
  pushl $176
c01024ca:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024cf:	e9 22 f9 ff ff       	jmp    c0101df6 <__alltraps>

c01024d4 <vector177>:
.globl vector177
vector177:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $177
c01024d6:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024db:	e9 16 f9 ff ff       	jmp    c0101df6 <__alltraps>

c01024e0 <vector178>:
.globl vector178
vector178:
  pushl $0
c01024e0:	6a 00                	push   $0x0
  pushl $178
c01024e2:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024e7:	e9 0a f9 ff ff       	jmp    c0101df6 <__alltraps>

c01024ec <vector179>:
.globl vector179
vector179:
  pushl $0
c01024ec:	6a 00                	push   $0x0
  pushl $179
c01024ee:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024f3:	e9 fe f8 ff ff       	jmp    c0101df6 <__alltraps>

c01024f8 <vector180>:
.globl vector180
vector180:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $180
c01024fa:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024ff:	e9 f2 f8 ff ff       	jmp    c0101df6 <__alltraps>

c0102504 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102504:	6a 00                	push   $0x0
  pushl $181
c0102506:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010250b:	e9 e6 f8 ff ff       	jmp    c0101df6 <__alltraps>

c0102510 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102510:	6a 00                	push   $0x0
  pushl $182
c0102512:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102517:	e9 da f8 ff ff       	jmp    c0101df6 <__alltraps>

c010251c <vector183>:
.globl vector183
vector183:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $183
c010251e:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102523:	e9 ce f8 ff ff       	jmp    c0101df6 <__alltraps>

c0102528 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102528:	6a 00                	push   $0x0
  pushl $184
c010252a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010252f:	e9 c2 f8 ff ff       	jmp    c0101df6 <__alltraps>

c0102534 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102534:	6a 00                	push   $0x0
  pushl $185
c0102536:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010253b:	e9 b6 f8 ff ff       	jmp    c0101df6 <__alltraps>

c0102540 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $186
c0102542:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102547:	e9 aa f8 ff ff       	jmp    c0101df6 <__alltraps>

c010254c <vector187>:
.globl vector187
vector187:
  pushl $0
c010254c:	6a 00                	push   $0x0
  pushl $187
c010254e:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102553:	e9 9e f8 ff ff       	jmp    c0101df6 <__alltraps>

c0102558 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102558:	6a 00                	push   $0x0
  pushl $188
c010255a:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010255f:	e9 92 f8 ff ff       	jmp    c0101df6 <__alltraps>

c0102564 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $189
c0102566:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010256b:	e9 86 f8 ff ff       	jmp    c0101df6 <__alltraps>

c0102570 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102570:	6a 00                	push   $0x0
  pushl $190
c0102572:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102577:	e9 7a f8 ff ff       	jmp    c0101df6 <__alltraps>

c010257c <vector191>:
.globl vector191
vector191:
  pushl $0
c010257c:	6a 00                	push   $0x0
  pushl $191
c010257e:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102583:	e9 6e f8 ff ff       	jmp    c0101df6 <__alltraps>

c0102588 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $192
c010258a:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010258f:	e9 62 f8 ff ff       	jmp    c0101df6 <__alltraps>

c0102594 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102594:	6a 00                	push   $0x0
  pushl $193
c0102596:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010259b:	e9 56 f8 ff ff       	jmp    c0101df6 <__alltraps>

c01025a0 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025a0:	6a 00                	push   $0x0
  pushl $194
c01025a2:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025a7:	e9 4a f8 ff ff       	jmp    c0101df6 <__alltraps>

c01025ac <vector195>:
.globl vector195
vector195:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $195
c01025ae:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025b3:	e9 3e f8 ff ff       	jmp    c0101df6 <__alltraps>

c01025b8 <vector196>:
.globl vector196
vector196:
  pushl $0
c01025b8:	6a 00                	push   $0x0
  pushl $196
c01025ba:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025bf:	e9 32 f8 ff ff       	jmp    c0101df6 <__alltraps>

c01025c4 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025c4:	6a 00                	push   $0x0
  pushl $197
c01025c6:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025cb:	e9 26 f8 ff ff       	jmp    c0101df6 <__alltraps>

c01025d0 <vector198>:
.globl vector198
vector198:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $198
c01025d2:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025d7:	e9 1a f8 ff ff       	jmp    c0101df6 <__alltraps>

c01025dc <vector199>:
.globl vector199
vector199:
  pushl $0
c01025dc:	6a 00                	push   $0x0
  pushl $199
c01025de:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025e3:	e9 0e f8 ff ff       	jmp    c0101df6 <__alltraps>

c01025e8 <vector200>:
.globl vector200
vector200:
  pushl $0
c01025e8:	6a 00                	push   $0x0
  pushl $200
c01025ea:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025ef:	e9 02 f8 ff ff       	jmp    c0101df6 <__alltraps>

c01025f4 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $201
c01025f6:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025fb:	e9 f6 f7 ff ff       	jmp    c0101df6 <__alltraps>

c0102600 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102600:	6a 00                	push   $0x0
  pushl $202
c0102602:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102607:	e9 ea f7 ff ff       	jmp    c0101df6 <__alltraps>

c010260c <vector203>:
.globl vector203
vector203:
  pushl $0
c010260c:	6a 00                	push   $0x0
  pushl $203
c010260e:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102613:	e9 de f7 ff ff       	jmp    c0101df6 <__alltraps>

c0102618 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $204
c010261a:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010261f:	e9 d2 f7 ff ff       	jmp    c0101df6 <__alltraps>

c0102624 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102624:	6a 00                	push   $0x0
  pushl $205
c0102626:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010262b:	e9 c6 f7 ff ff       	jmp    c0101df6 <__alltraps>

c0102630 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102630:	6a 00                	push   $0x0
  pushl $206
c0102632:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102637:	e9 ba f7 ff ff       	jmp    c0101df6 <__alltraps>

c010263c <vector207>:
.globl vector207
vector207:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $207
c010263e:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102643:	e9 ae f7 ff ff       	jmp    c0101df6 <__alltraps>

c0102648 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102648:	6a 00                	push   $0x0
  pushl $208
c010264a:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010264f:	e9 a2 f7 ff ff       	jmp    c0101df6 <__alltraps>

c0102654 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102654:	6a 00                	push   $0x0
  pushl $209
c0102656:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010265b:	e9 96 f7 ff ff       	jmp    c0101df6 <__alltraps>

c0102660 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $210
c0102662:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102667:	e9 8a f7 ff ff       	jmp    c0101df6 <__alltraps>

c010266c <vector211>:
.globl vector211
vector211:
  pushl $0
c010266c:	6a 00                	push   $0x0
  pushl $211
c010266e:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102673:	e9 7e f7 ff ff       	jmp    c0101df6 <__alltraps>

c0102678 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102678:	6a 00                	push   $0x0
  pushl $212
c010267a:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010267f:	e9 72 f7 ff ff       	jmp    c0101df6 <__alltraps>

c0102684 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $213
c0102686:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010268b:	e9 66 f7 ff ff       	jmp    c0101df6 <__alltraps>

c0102690 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102690:	6a 00                	push   $0x0
  pushl $214
c0102692:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102697:	e9 5a f7 ff ff       	jmp    c0101df6 <__alltraps>

c010269c <vector215>:
.globl vector215
vector215:
  pushl $0
c010269c:	6a 00                	push   $0x0
  pushl $215
c010269e:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026a3:	e9 4e f7 ff ff       	jmp    c0101df6 <__alltraps>

c01026a8 <vector216>:
.globl vector216
vector216:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $216
c01026aa:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026af:	e9 42 f7 ff ff       	jmp    c0101df6 <__alltraps>

c01026b4 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026b4:	6a 00                	push   $0x0
  pushl $217
c01026b6:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026bb:	e9 36 f7 ff ff       	jmp    c0101df6 <__alltraps>

c01026c0 <vector218>:
.globl vector218
vector218:
  pushl $0
c01026c0:	6a 00                	push   $0x0
  pushl $218
c01026c2:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026c7:	e9 2a f7 ff ff       	jmp    c0101df6 <__alltraps>

c01026cc <vector219>:
.globl vector219
vector219:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $219
c01026ce:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026d3:	e9 1e f7 ff ff       	jmp    c0101df6 <__alltraps>

c01026d8 <vector220>:
.globl vector220
vector220:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $220
c01026da:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026df:	e9 12 f7 ff ff       	jmp    c0101df6 <__alltraps>

c01026e4 <vector221>:
.globl vector221
vector221:
  pushl $0
c01026e4:	6a 00                	push   $0x0
  pushl $221
c01026e6:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026eb:	e9 06 f7 ff ff       	jmp    c0101df6 <__alltraps>

c01026f0 <vector222>:
.globl vector222
vector222:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $222
c01026f2:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026f7:	e9 fa f6 ff ff       	jmp    c0101df6 <__alltraps>

c01026fc <vector223>:
.globl vector223
vector223:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $223
c01026fe:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102703:	e9 ee f6 ff ff       	jmp    c0101df6 <__alltraps>

c0102708 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102708:	6a 00                	push   $0x0
  pushl $224
c010270a:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010270f:	e9 e2 f6 ff ff       	jmp    c0101df6 <__alltraps>

c0102714 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $225
c0102716:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010271b:	e9 d6 f6 ff ff       	jmp    c0101df6 <__alltraps>

c0102720 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102720:	6a 00                	push   $0x0
  pushl $226
c0102722:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102727:	e9 ca f6 ff ff       	jmp    c0101df6 <__alltraps>

c010272c <vector227>:
.globl vector227
vector227:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $227
c010272e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102733:	e9 be f6 ff ff       	jmp    c0101df6 <__alltraps>

c0102738 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $228
c010273a:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010273f:	e9 b2 f6 ff ff       	jmp    c0101df6 <__alltraps>

c0102744 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102744:	6a 00                	push   $0x0
  pushl $229
c0102746:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010274b:	e9 a6 f6 ff ff       	jmp    c0101df6 <__alltraps>

c0102750 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $230
c0102752:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102757:	e9 9a f6 ff ff       	jmp    c0101df6 <__alltraps>

c010275c <vector231>:
.globl vector231
vector231:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $231
c010275e:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102763:	e9 8e f6 ff ff       	jmp    c0101df6 <__alltraps>

c0102768 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102768:	6a 00                	push   $0x0
  pushl $232
c010276a:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010276f:	e9 82 f6 ff ff       	jmp    c0101df6 <__alltraps>

c0102774 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $233
c0102776:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010277b:	e9 76 f6 ff ff       	jmp    c0101df6 <__alltraps>

c0102780 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $234
c0102782:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102787:	e9 6a f6 ff ff       	jmp    c0101df6 <__alltraps>

c010278c <vector235>:
.globl vector235
vector235:
  pushl $0
c010278c:	6a 00                	push   $0x0
  pushl $235
c010278e:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102793:	e9 5e f6 ff ff       	jmp    c0101df6 <__alltraps>

c0102798 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $236
c010279a:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010279f:	e9 52 f6 ff ff       	jmp    c0101df6 <__alltraps>

c01027a4 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $237
c01027a6:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027ab:	e9 46 f6 ff ff       	jmp    c0101df6 <__alltraps>

c01027b0 <vector238>:
.globl vector238
vector238:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $238
c01027b2:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027b7:	e9 3a f6 ff ff       	jmp    c0101df6 <__alltraps>

c01027bc <vector239>:
.globl vector239
vector239:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $239
c01027be:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027c3:	e9 2e f6 ff ff       	jmp    c0101df6 <__alltraps>

c01027c8 <vector240>:
.globl vector240
vector240:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $240
c01027ca:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027cf:	e9 22 f6 ff ff       	jmp    c0101df6 <__alltraps>

c01027d4 <vector241>:
.globl vector241
vector241:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $241
c01027d6:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027db:	e9 16 f6 ff ff       	jmp    c0101df6 <__alltraps>

c01027e0 <vector242>:
.globl vector242
vector242:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $242
c01027e2:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027e7:	e9 0a f6 ff ff       	jmp    c0101df6 <__alltraps>

c01027ec <vector243>:
.globl vector243
vector243:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $243
c01027ee:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027f3:	e9 fe f5 ff ff       	jmp    c0101df6 <__alltraps>

c01027f8 <vector244>:
.globl vector244
vector244:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $244
c01027fa:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027ff:	e9 f2 f5 ff ff       	jmp    c0101df6 <__alltraps>

c0102804 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $245
c0102806:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010280b:	e9 e6 f5 ff ff       	jmp    c0101df6 <__alltraps>

c0102810 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $246
c0102812:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102817:	e9 da f5 ff ff       	jmp    c0101df6 <__alltraps>

c010281c <vector247>:
.globl vector247
vector247:
  pushl $0
c010281c:	6a 00                	push   $0x0
  pushl $247
c010281e:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102823:	e9 ce f5 ff ff       	jmp    c0101df6 <__alltraps>

c0102828 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $248
c010282a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010282f:	e9 c2 f5 ff ff       	jmp    c0101df6 <__alltraps>

c0102834 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $249
c0102836:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010283b:	e9 b6 f5 ff ff       	jmp    c0101df6 <__alltraps>

c0102840 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102840:	6a 00                	push   $0x0
  pushl $250
c0102842:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102847:	e9 aa f5 ff ff       	jmp    c0101df6 <__alltraps>

c010284c <vector251>:
.globl vector251
vector251:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $251
c010284e:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102853:	e9 9e f5 ff ff       	jmp    c0101df6 <__alltraps>

c0102858 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $252
c010285a:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010285f:	e9 92 f5 ff ff       	jmp    c0101df6 <__alltraps>

c0102864 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $253
c0102866:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010286b:	e9 86 f5 ff ff       	jmp    c0101df6 <__alltraps>

c0102870 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $254
c0102872:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102877:	e9 7a f5 ff ff       	jmp    c0101df6 <__alltraps>

c010287c <vector255>:
.globl vector255
vector255:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $255
c010287e:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102883:	e9 6e f5 ff ff       	jmp    c0101df6 <__alltraps>

c0102888 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102888:	55                   	push   %ebp
c0102889:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010288b:	8b 55 08             	mov    0x8(%ebp),%edx
c010288e:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0102893:	29 c2                	sub    %eax,%edx
c0102895:	89 d0                	mov    %edx,%eax
c0102897:	c1 f8 02             	sar    $0x2,%eax
c010289a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028a0:	5d                   	pop    %ebp
c01028a1:	c3                   	ret    

c01028a2 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028a2:	55                   	push   %ebp
c01028a3:	89 e5                	mov    %esp,%ebp
c01028a5:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01028ab:	89 04 24             	mov    %eax,(%esp)
c01028ae:	e8 d5 ff ff ff       	call   c0102888 <page2ppn>
c01028b3:	c1 e0 0c             	shl    $0xc,%eax
}
c01028b6:	c9                   	leave  
c01028b7:	c3                   	ret    

c01028b8 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028b8:	55                   	push   %ebp
c01028b9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01028be:	8b 00                	mov    (%eax),%eax
}
c01028c0:	5d                   	pop    %ebp
c01028c1:	c3                   	ret    

c01028c2 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028c2:	55                   	push   %ebp
c01028c3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028cb:	89 10                	mov    %edx,(%eax)
}
c01028cd:	5d                   	pop    %ebp
c01028ce:	c3                   	ret    

c01028cf <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01028cf:	55                   	push   %ebp
c01028d0:	89 e5                	mov    %esp,%ebp
c01028d2:	83 ec 10             	sub    $0x10,%esp
c01028d5:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01028dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028df:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028e2:	89 50 04             	mov    %edx,0x4(%eax)
c01028e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028e8:	8b 50 04             	mov    0x4(%eax),%edx
c01028eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028ee:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01028f0:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01028f7:	00 00 00 
}
c01028fa:	c9                   	leave  
c01028fb:	c3                   	ret    

c01028fc <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01028fc:	55                   	push   %ebp
c01028fd:	89 e5                	mov    %esp,%ebp
c01028ff:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102902:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102906:	75 24                	jne    c010292c <default_init_memmap+0x30>
c0102908:	c7 44 24 0c f0 66 10 	movl   $0xc01066f0,0xc(%esp)
c010290f:	c0 
c0102910:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102917:	c0 
c0102918:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010291f:	00 
c0102920:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102927:	e8 a1 e3 ff ff       	call   c0100ccd <__panic>
    struct Page *p = base;
c010292c:	8b 45 08             	mov    0x8(%ebp),%eax
c010292f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102932:	eb 7d                	jmp    c01029b1 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0102934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102937:	83 c0 04             	add    $0x4,%eax
c010293a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102941:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102947:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010294a:	0f a3 10             	bt     %edx,(%eax)
c010294d:	19 c0                	sbb    %eax,%eax
c010294f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102952:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102956:	0f 95 c0             	setne  %al
c0102959:	0f b6 c0             	movzbl %al,%eax
c010295c:	85 c0                	test   %eax,%eax
c010295e:	75 24                	jne    c0102984 <default_init_memmap+0x88>
c0102960:	c7 44 24 0c 21 67 10 	movl   $0xc0106721,0xc(%esp)
c0102967:	c0 
c0102968:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010296f:	c0 
c0102970:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0102977:	00 
c0102978:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010297f:	e8 49 e3 ff ff       	call   c0100ccd <__panic>
        p->flags = p->property = 0;
c0102984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102987:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102991:	8b 50 08             	mov    0x8(%eax),%edx
c0102994:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102997:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010299a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029a1:	00 
c01029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a5:	89 04 24             	mov    %eax,(%esp)
c01029a8:	e8 15 ff ff ff       	call   c01028c2 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01029ad:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01029b1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029b4:	89 d0                	mov    %edx,%eax
c01029b6:	c1 e0 02             	shl    $0x2,%eax
c01029b9:	01 d0                	add    %edx,%eax
c01029bb:	c1 e0 02             	shl    $0x2,%eax
c01029be:	89 c2                	mov    %eax,%edx
c01029c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c3:	01 d0                	add    %edx,%eax
c01029c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01029c8:	0f 85 66 ff ff ff    	jne    c0102934 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c01029ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01029d1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029d4:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01029d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01029da:	83 c0 04             	add    $0x4,%eax
c01029dd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029ed:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01029f0:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c01029f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029f9:	01 d0                	add    %edx,%eax
c01029fb:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    list_add(&free_list, &(base->page_link));
c0102a00:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a03:	83 c0 0c             	add    $0xc,%eax
c0102a06:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c0102a0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a10:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a13:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102a16:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a19:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102a1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a1f:	8b 40 04             	mov    0x4(%eax),%eax
c0102a22:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a25:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102a28:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a2b:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102a2e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a34:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a37:	89 10                	mov    %edx,(%eax)
c0102a39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a3c:	8b 10                	mov    (%eax),%edx
c0102a3e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102a41:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a44:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a47:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102a4a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a50:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102a53:	89 10                	mov    %edx,(%eax)
}
c0102a55:	c9                   	leave  
c0102a56:	c3                   	ret    

c0102a57 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a57:	55                   	push   %ebp
c0102a58:	89 e5                	mov    %esp,%ebp
c0102a5a:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102a5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a61:	75 24                	jne    c0102a87 <default_alloc_pages+0x30>
c0102a63:	c7 44 24 0c f0 66 10 	movl   $0xc01066f0,0xc(%esp)
c0102a6a:	c0 
c0102a6b:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102a72:	c0 
c0102a73:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0102a7a:	00 
c0102a7b:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102a82:	e8 46 e2 ff ff       	call   c0100ccd <__panic>
    if (n > nr_free) {
c0102a87:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102a8c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a8f:	73 0a                	jae    c0102a9b <default_alloc_pages+0x44>
        return NULL;
c0102a91:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a96:	e9 42 01 00 00       	jmp    c0102bdd <default_alloc_pages+0x186>
    }
    struct Page* page = NULL;
c0102a9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t* le = &free_list;
c0102aa2:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102aa9:	eb 1c                	jmp    c0102ac7 <default_alloc_pages+0x70>
        struct Page* p = le2page(le, page_link);
c0102aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102aae:	83 e8 0c             	sub    $0xc,%eax
c0102ab1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ab7:	8b 40 08             	mov    0x8(%eax),%eax
c0102aba:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102abd:	72 08                	jb     c0102ac7 <default_alloc_pages+0x70>
            page = p;
c0102abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102ac5:	eb 18                	jmp    c0102adf <default_alloc_pages+0x88>
c0102ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102acd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ad0:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page* page = NULL;
    list_entry_t* le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ad6:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102add:	75 cc                	jne    c0102aab <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL)	{
c0102adf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102ae3:	0f 84 f1 00 00 00    	je     c0102bda <default_alloc_pages+0x183>
    	if (page->property > n)	{
c0102ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aec:	8b 40 08             	mov    0x8(%eax),%eax
c0102aef:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102af2:	0f 86 88 00 00 00    	jbe    c0102b80 <default_alloc_pages+0x129>
            struct Page* p = page + n;
c0102af8:	8b 55 08             	mov    0x8(%ebp),%edx
c0102afb:	89 d0                	mov    %edx,%eax
c0102afd:	c1 e0 02             	shl    $0x2,%eax
c0102b00:	01 d0                	add    %edx,%eax
c0102b02:	c1 e0 02             	shl    $0x2,%eax
c0102b05:	89 c2                	mov    %eax,%edx
c0102b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b0a:	01 d0                	add    %edx,%eax
c0102b0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b12:	8b 40 08             	mov    0x8(%eax),%eax
c0102b15:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b18:	89 c2                	mov    %eax,%edx
c0102b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b1d:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0102b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b23:	83 c0 04             	add    $0x4,%eax
c0102b26:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102b2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102b30:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b33:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b36:	0f ab 10             	bts    %edx,(%eax)
            list_add_before(le, &(p->page_link));
c0102b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b3c:	8d 50 0c             	lea    0xc(%eax),%edx
c0102b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b42:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102b45:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b4b:	8b 00                	mov    (%eax),%eax
c0102b4d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b50:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102b53:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102b56:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b59:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b5f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b62:	89 10                	mov    %edx,(%eax)
c0102b64:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b67:	8b 10                	mov    (%eax),%edx
c0102b69:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b6c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b72:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b75:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b78:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b7b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b7e:	89 10                	mov    %edx,(%eax)
    	}
    	list_del(&(page->page_link));
c0102b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b83:	83 c0 0c             	add    $0xc,%eax
c0102b86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b8c:	8b 40 04             	mov    0x4(%eax),%eax
c0102b8f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b92:	8b 12                	mov    (%edx),%edx
c0102b94:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102b97:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b9a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b9d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102ba0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102ba3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ba6:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102ba9:	89 10                	mov    %edx,(%eax)
    	page->property= n;
c0102bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bae:	8b 55 08             	mov    0x8(%ebp),%edx
c0102bb1:	89 50 08             	mov    %edx,0x8(%eax)
        nr_free -= n;
c0102bb4:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102bb9:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bbc:	a3 58 89 11 c0       	mov    %eax,0xc0118958
        ClearPageProperty(page);
c0102bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bc4:	83 c0 04             	add    $0x4,%eax
c0102bc7:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102bce:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bd1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bd4:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102bd7:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102bdd:	c9                   	leave  
c0102bde:	c3                   	ret    

c0102bdf <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102bdf:	55                   	push   %ebp
c0102be0:	89 e5                	mov    %esp,%ebp
c0102be2:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102bec:	75 24                	jne    c0102c12 <default_free_pages+0x33>
c0102bee:	c7 44 24 0c f0 66 10 	movl   $0xc01066f0,0xc(%esp)
c0102bf5:	c0 
c0102bf6:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102bfd:	c0 
c0102bfe:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
c0102c05:	00 
c0102c06:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102c0d:	e8 bb e0 ff ff       	call   c0100ccd <__panic>
    struct Page* p = base;
c0102c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102c18:	e9 9d 00 00 00       	jmp    c0102cba <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c20:	83 c0 04             	add    $0x4,%eax
c0102c23:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0102c2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c30:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102c33:	0f a3 10             	bt     %edx,(%eax)
c0102c36:	19 c0                	sbb    %eax,%eax
c0102c38:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0102c3b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102c3f:	0f 95 c0             	setne  %al
c0102c42:	0f b6 c0             	movzbl %al,%eax
c0102c45:	85 c0                	test   %eax,%eax
c0102c47:	75 2c                	jne    c0102c75 <default_free_pages+0x96>
c0102c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c4c:	83 c0 04             	add    $0x4,%eax
c0102c4f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102c56:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102c5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c5f:	0f a3 10             	bt     %edx,(%eax)
c0102c62:	19 c0                	sbb    %eax,%eax
c0102c64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c0102c67:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102c6b:	0f 95 c0             	setne  %al
c0102c6e:	0f b6 c0             	movzbl %al,%eax
c0102c71:	85 c0                	test   %eax,%eax
c0102c73:	74 24                	je     c0102c99 <default_free_pages+0xba>
c0102c75:	c7 44 24 0c 34 67 10 	movl   $0xc0106734,0xc(%esp)
c0102c7c:	c0 
c0102c7d:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102c84:	c0 
c0102c85:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c0102c8c:	00 
c0102c8d:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102c94:	e8 34 e0 ff ff       	call   c0100ccd <__panic>
        p->flags = 0;
c0102c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102ca3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102caa:	00 
c0102cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cae:	89 04 24             	mov    %eax,(%esp)
c0102cb1:	e8 0c fc ff ff       	call   c01028c2 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page* p = base;
    for (; p != base + n; p ++) {
c0102cb6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102cba:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cbd:	89 d0                	mov    %edx,%eax
c0102cbf:	c1 e0 02             	shl    $0x2,%eax
c0102cc2:	01 d0                	add    %edx,%eax
c0102cc4:	c1 e0 02             	shl    $0x2,%eax
c0102cc7:	89 c2                	mov    %eax,%edx
c0102cc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ccc:	01 d0                	add    %edx,%eax
c0102cce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cd1:	0f 85 46 ff ff ff    	jne    c0102c1d <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property= n;
c0102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cda:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cdd:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102ce0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce3:	83 c0 04             	add    $0x4,%eax
c0102ce6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102ced:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cf0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cf3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102cf6:	0f ab 10             	bts    %edx,(%eax)
c0102cf9:	c7 45 c8 50 89 11 c0 	movl   $0xc0118950,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102d00:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d03:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t* le = list_next(&free_list);
c0102d06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list)	{
c0102d09:	eb 22                	jmp    c0102d2d <default_free_pages+0x14e>
    	p = le2page(le, page_link);
c0102d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d0e:	83 e8 0c             	sub    $0xc,%eax
c0102d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if (p > base)
c0102d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d17:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d1a:	76 02                	jbe    c0102d1e <default_free_pages+0x13f>
    		break ;
c0102d1c:	eb 18                	jmp    c0102d36 <default_free_pages+0x157>
c0102d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d21:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0102d24:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d27:	8b 40 04             	mov    0x4(%eax),%eax
    	le = list_next(le);
c0102d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        set_page_ref(p, 0);
    }
    base->property= n;
    SetPageProperty(base);
    list_entry_t* le = list_next(&free_list);
    while (le != &free_list)	{
c0102d2d:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102d34:	75 d5                	jne    c0102d0b <default_free_pages+0x12c>
    	if (p > base)
    		break ;
    	le = list_next(le);
    }

    p = le2page(le, page_link);
c0102d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d39:	83 e8 0c             	sub    $0xc,%eax
c0102d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	list_add_before(le, &(base->page_link));
c0102d3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d42:	8d 50 0c             	lea    0xc(%eax),%edx
c0102d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d48:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0102d4b:	89 55 bc             	mov    %edx,-0x44(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102d4e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d51:	8b 00                	mov    (%eax),%eax
c0102d53:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d56:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102d59:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102d5c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d5f:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102d62:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d65:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d68:	89 10                	mov    %edx,(%eax)
c0102d6a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d6d:	8b 10                	mov    (%eax),%edx
c0102d6f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d72:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102d75:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d78:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102d7b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102d7e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d81:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d84:	89 10                	mov    %edx,(%eax)
	le = list_prev(&(base->page_link));
c0102d86:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d89:	83 c0 0c             	add    $0xc,%eax
c0102d8c:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102d8f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102d92:	8b 00                	mov    (%eax),%eax
c0102d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct Page* pp = le2page(le, page_link);
c0102d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d9a:	83 e8 0c             	sub    $0xc,%eax
c0102d9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (base + base->property == p) {
c0102da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da3:	8b 50 08             	mov    0x8(%eax),%edx
c0102da6:	89 d0                	mov    %edx,%eax
c0102da8:	c1 e0 02             	shl    $0x2,%eax
c0102dab:	01 d0                	add    %edx,%eax
c0102dad:	c1 e0 02             	shl    $0x2,%eax
c0102db0:	89 c2                	mov    %eax,%edx
c0102db2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db5:	01 d0                	add    %edx,%eax
c0102db7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102dba:	75 58                	jne    c0102e14 <default_free_pages+0x235>
		base->property += p->property;
c0102dbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dbf:	8b 50 08             	mov    0x8(%eax),%edx
c0102dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc5:	8b 40 08             	mov    0x8(%eax),%eax
c0102dc8:	01 c2                	add    %eax,%edx
c0102dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dcd:	89 50 08             	mov    %edx,0x8(%eax)
		ClearPageProperty(p);
c0102dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd3:	83 c0 04             	add    $0x4,%eax
c0102dd6:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
c0102ddd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102de0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102de3:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102de6:	0f b3 10             	btr    %edx,(%eax)
		list_del(&(p->page_link));
c0102de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dec:	83 c0 0c             	add    $0xc,%eax
c0102def:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102df2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102df5:	8b 40 04             	mov    0x4(%eax),%eax
c0102df8:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102dfb:	8b 12                	mov    (%edx),%edx
c0102dfd:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0102e00:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e03:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102e06:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102e09:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e0c:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e0f:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102e12:	89 10                	mov    %edx,(%eax)
	}
	if (pp + pp->property == base) {
c0102e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e17:	8b 50 08             	mov    0x8(%eax),%edx
c0102e1a:	89 d0                	mov    %edx,%eax
c0102e1c:	c1 e0 02             	shl    $0x2,%eax
c0102e1f:	01 d0                	add    %edx,%eax
c0102e21:	c1 e0 02             	shl    $0x2,%eax
c0102e24:	89 c2                	mov    %eax,%edx
c0102e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e29:	01 d0                	add    %edx,%eax
c0102e2b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102e2e:	75 58                	jne    c0102e88 <default_free_pages+0x2a9>
		pp->property += base->property;
c0102e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e33:	8b 50 08             	mov    0x8(%eax),%edx
c0102e36:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e39:	8b 40 08             	mov    0x8(%eax),%eax
c0102e3c:	01 c2                	add    %eax,%edx
c0102e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e41:	89 50 08             	mov    %edx,0x8(%eax)
		ClearPageProperty(base);
c0102e44:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e47:	83 c0 04             	add    $0x4,%eax
c0102e4a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0102e51:	89 45 90             	mov    %eax,-0x70(%ebp)
c0102e54:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102e57:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102e5a:	0f b3 10             	btr    %edx,(%eax)
		list_del(&(base->page_link));
c0102e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e60:	83 c0 0c             	add    $0xc,%eax
c0102e63:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102e66:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e69:	8b 40 04             	mov    0x4(%eax),%eax
c0102e6c:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102e6f:	8b 12                	mov    (%edx),%edx
c0102e71:	89 55 88             	mov    %edx,-0x78(%ebp)
c0102e74:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e77:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102e7a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102e7d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e80:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e83:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102e86:	89 10                	mov    %edx,(%eax)
	}

	nr_free += n;
c0102e88:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e91:	01 d0                	add    %edx,%eax
c0102e93:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c0102e98:	c9                   	leave  
c0102e99:	c3                   	ret    

c0102e9a <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e9a:	55                   	push   %ebp
c0102e9b:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e9d:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102ea2:	5d                   	pop    %ebp
c0102ea3:	c3                   	ret    

c0102ea4 <basic_check>:

static void
basic_check(void) {
c0102ea4:	55                   	push   %ebp
c0102ea5:	89 e5                	mov    %esp,%ebp
c0102ea7:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102eba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102ebd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ec4:	e8 85 0e 00 00       	call   c0103d4e <alloc_pages>
c0102ec9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102ecc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102ed0:	75 24                	jne    c0102ef6 <basic_check+0x52>
c0102ed2:	c7 44 24 0c 59 67 10 	movl   $0xc0106759,0xc(%esp)
c0102ed9:	c0 
c0102eda:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102ee1:	c0 
c0102ee2:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0102ee9:	00 
c0102eea:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102ef1:	e8 d7 dd ff ff       	call   c0100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ef6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102efd:	e8 4c 0e 00 00       	call   c0103d4e <alloc_pages>
c0102f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f09:	75 24                	jne    c0102f2f <basic_check+0x8b>
c0102f0b:	c7 44 24 0c 75 67 10 	movl   $0xc0106775,0xc(%esp)
c0102f12:	c0 
c0102f13:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102f1a:	c0 
c0102f1b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0102f22:	00 
c0102f23:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102f2a:	e8 9e dd ff ff       	call   c0100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f36:	e8 13 0e 00 00       	call   c0103d4e <alloc_pages>
c0102f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f42:	75 24                	jne    c0102f68 <basic_check+0xc4>
c0102f44:	c7 44 24 0c 91 67 10 	movl   $0xc0106791,0xc(%esp)
c0102f4b:	c0 
c0102f4c:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102f53:	c0 
c0102f54:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0102f5b:	00 
c0102f5c:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102f63:	e8 65 dd ff ff       	call   c0100ccd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f6e:	74 10                	je     c0102f80 <basic_check+0xdc>
c0102f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f73:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f76:	74 08                	je     c0102f80 <basic_check+0xdc>
c0102f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f7b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f7e:	75 24                	jne    c0102fa4 <basic_check+0x100>
c0102f80:	c7 44 24 0c b0 67 10 	movl   $0xc01067b0,0xc(%esp)
c0102f87:	c0 
c0102f88:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102f8f:	c0 
c0102f90:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c0102f97:	00 
c0102f98:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102f9f:	e8 29 dd ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fa7:	89 04 24             	mov    %eax,(%esp)
c0102faa:	e8 09 f9 ff ff       	call   c01028b8 <page_ref>
c0102faf:	85 c0                	test   %eax,%eax
c0102fb1:	75 1e                	jne    c0102fd1 <basic_check+0x12d>
c0102fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fb6:	89 04 24             	mov    %eax,(%esp)
c0102fb9:	e8 fa f8 ff ff       	call   c01028b8 <page_ref>
c0102fbe:	85 c0                	test   %eax,%eax
c0102fc0:	75 0f                	jne    c0102fd1 <basic_check+0x12d>
c0102fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fc5:	89 04 24             	mov    %eax,(%esp)
c0102fc8:	e8 eb f8 ff ff       	call   c01028b8 <page_ref>
c0102fcd:	85 c0                	test   %eax,%eax
c0102fcf:	74 24                	je     c0102ff5 <basic_check+0x151>
c0102fd1:	c7 44 24 0c d4 67 10 	movl   $0xc01067d4,0xc(%esp)
c0102fd8:	c0 
c0102fd9:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102fe0:	c0 
c0102fe1:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0102fe8:	00 
c0102fe9:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102ff0:	e8 d8 dc ff ff       	call   c0100ccd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ff8:	89 04 24             	mov    %eax,(%esp)
c0102ffb:	e8 a2 f8 ff ff       	call   c01028a2 <page2pa>
c0103000:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103006:	c1 e2 0c             	shl    $0xc,%edx
c0103009:	39 d0                	cmp    %edx,%eax
c010300b:	72 24                	jb     c0103031 <basic_check+0x18d>
c010300d:	c7 44 24 0c 10 68 10 	movl   $0xc0106810,0xc(%esp)
c0103014:	c0 
c0103015:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010301c:	c0 
c010301d:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c0103024:	00 
c0103025:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010302c:	e8 9c dc ff ff       	call   c0100ccd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103031:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103034:	89 04 24             	mov    %eax,(%esp)
c0103037:	e8 66 f8 ff ff       	call   c01028a2 <page2pa>
c010303c:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103042:	c1 e2 0c             	shl    $0xc,%edx
c0103045:	39 d0                	cmp    %edx,%eax
c0103047:	72 24                	jb     c010306d <basic_check+0x1c9>
c0103049:	c7 44 24 0c 2d 68 10 	movl   $0xc010682d,0xc(%esp)
c0103050:	c0 
c0103051:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103058:	c0 
c0103059:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0103060:	00 
c0103061:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103068:	e8 60 dc ff ff       	call   c0100ccd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103070:	89 04 24             	mov    %eax,(%esp)
c0103073:	e8 2a f8 ff ff       	call   c01028a2 <page2pa>
c0103078:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c010307e:	c1 e2 0c             	shl    $0xc,%edx
c0103081:	39 d0                	cmp    %edx,%eax
c0103083:	72 24                	jb     c01030a9 <basic_check+0x205>
c0103085:	c7 44 24 0c 4a 68 10 	movl   $0xc010684a,0xc(%esp)
c010308c:	c0 
c010308d:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103094:	c0 
c0103095:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c010309c:	00 
c010309d:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01030a4:	e8 24 dc ff ff       	call   c0100ccd <__panic>

    list_entry_t free_list_store = free_list;
c01030a9:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01030ae:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c01030b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030b7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01030ba:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01030c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01030c7:	89 50 04             	mov    %edx,0x4(%eax)
c01030ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030cd:	8b 50 04             	mov    0x4(%eax),%edx
c01030d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030d3:	89 10                	mov    %edx,(%eax)
c01030d5:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01030dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030df:	8b 40 04             	mov    0x4(%eax),%eax
c01030e2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030e5:	0f 94 c0             	sete   %al
c01030e8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030eb:	85 c0                	test   %eax,%eax
c01030ed:	75 24                	jne    c0103113 <basic_check+0x26f>
c01030ef:	c7 44 24 0c 67 68 10 	movl   $0xc0106867,0xc(%esp)
c01030f6:	c0 
c01030f7:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01030fe:	c0 
c01030ff:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0103106:	00 
c0103107:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010310e:	e8 ba db ff ff       	call   c0100ccd <__panic>

    unsigned int nr_free_store = nr_free;
c0103113:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103118:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010311b:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103122:	00 00 00 

    assert(alloc_page() == NULL);
c0103125:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010312c:	e8 1d 0c 00 00       	call   c0103d4e <alloc_pages>
c0103131:	85 c0                	test   %eax,%eax
c0103133:	74 24                	je     c0103159 <basic_check+0x2b5>
c0103135:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c010313c:	c0 
c010313d:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103144:	c0 
c0103145:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c010314c:	00 
c010314d:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103154:	e8 74 db ff ff       	call   c0100ccd <__panic>

    free_page(p0);
c0103159:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103160:	00 
c0103161:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103164:	89 04 24             	mov    %eax,(%esp)
c0103167:	e8 1a 0c 00 00       	call   c0103d86 <free_pages>
    free_page(p1);
c010316c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103173:	00 
c0103174:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103177:	89 04 24             	mov    %eax,(%esp)
c010317a:	e8 07 0c 00 00       	call   c0103d86 <free_pages>
    free_page(p2);
c010317f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103186:	00 
c0103187:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010318a:	89 04 24             	mov    %eax,(%esp)
c010318d:	e8 f4 0b 00 00       	call   c0103d86 <free_pages>
    assert(nr_free == 3);
c0103192:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103197:	83 f8 03             	cmp    $0x3,%eax
c010319a:	74 24                	je     c01031c0 <basic_check+0x31c>
c010319c:	c7 44 24 0c 93 68 10 	movl   $0xc0106893,0xc(%esp)
c01031a3:	c0 
c01031a4:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01031ab:	c0 
c01031ac:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c01031b3:	00 
c01031b4:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01031bb:	e8 0d db ff ff       	call   c0100ccd <__panic>

    assert((p0 = alloc_page()) != NULL);
c01031c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031c7:	e8 82 0b 00 00       	call   c0103d4e <alloc_pages>
c01031cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01031d3:	75 24                	jne    c01031f9 <basic_check+0x355>
c01031d5:	c7 44 24 0c 59 67 10 	movl   $0xc0106759,0xc(%esp)
c01031dc:	c0 
c01031dd:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01031e4:	c0 
c01031e5:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c01031ec:	00 
c01031ed:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01031f4:	e8 d4 da ff ff       	call   c0100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
c01031f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103200:	e8 49 0b 00 00       	call   c0103d4e <alloc_pages>
c0103205:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103208:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010320c:	75 24                	jne    c0103232 <basic_check+0x38e>
c010320e:	c7 44 24 0c 75 67 10 	movl   $0xc0106775,0xc(%esp)
c0103215:	c0 
c0103216:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010321d:	c0 
c010321e:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103225:	00 
c0103226:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010322d:	e8 9b da ff ff       	call   c0100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103232:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103239:	e8 10 0b 00 00       	call   c0103d4e <alloc_pages>
c010323e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103245:	75 24                	jne    c010326b <basic_check+0x3c7>
c0103247:	c7 44 24 0c 91 67 10 	movl   $0xc0106791,0xc(%esp)
c010324e:	c0 
c010324f:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103256:	c0 
c0103257:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010325e:	00 
c010325f:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103266:	e8 62 da ff ff       	call   c0100ccd <__panic>

    assert(alloc_page() == NULL);
c010326b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103272:	e8 d7 0a 00 00       	call   c0103d4e <alloc_pages>
c0103277:	85 c0                	test   %eax,%eax
c0103279:	74 24                	je     c010329f <basic_check+0x3fb>
c010327b:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c0103282:	c0 
c0103283:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010328a:	c0 
c010328b:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0103292:	00 
c0103293:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010329a:	e8 2e da ff ff       	call   c0100ccd <__panic>

    free_page(p0);
c010329f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032a6:	00 
c01032a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032aa:	89 04 24             	mov    %eax,(%esp)
c01032ad:	e8 d4 0a 00 00       	call   c0103d86 <free_pages>
c01032b2:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c01032b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01032bc:	8b 40 04             	mov    0x4(%eax),%eax
c01032bf:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01032c2:	0f 94 c0             	sete   %al
c01032c5:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01032c8:	85 c0                	test   %eax,%eax
c01032ca:	74 24                	je     c01032f0 <basic_check+0x44c>
c01032cc:	c7 44 24 0c a0 68 10 	movl   $0xc01068a0,0xc(%esp)
c01032d3:	c0 
c01032d4:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01032db:	c0 
c01032dc:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c01032e3:	00 
c01032e4:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01032eb:	e8 dd d9 ff ff       	call   c0100ccd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01032f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032f7:	e8 52 0a 00 00       	call   c0103d4e <alloc_pages>
c01032fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103302:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103305:	74 24                	je     c010332b <basic_check+0x487>
c0103307:	c7 44 24 0c b8 68 10 	movl   $0xc01068b8,0xc(%esp)
c010330e:	c0 
c010330f:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103316:	c0 
c0103317:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c010331e:	00 
c010331f:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103326:	e8 a2 d9 ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c010332b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103332:	e8 17 0a 00 00       	call   c0103d4e <alloc_pages>
c0103337:	85 c0                	test   %eax,%eax
c0103339:	74 24                	je     c010335f <basic_check+0x4bb>
c010333b:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c0103342:	c0 
c0103343:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010334a:	c0 
c010334b:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103352:	00 
c0103353:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010335a:	e8 6e d9 ff ff       	call   c0100ccd <__panic>

    assert(nr_free == 0);
c010335f:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103364:	85 c0                	test   %eax,%eax
c0103366:	74 24                	je     c010338c <basic_check+0x4e8>
c0103368:	c7 44 24 0c d1 68 10 	movl   $0xc01068d1,0xc(%esp)
c010336f:	c0 
c0103370:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103377:	c0 
c0103378:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c010337f:	00 
c0103380:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103387:	e8 41 d9 ff ff       	call   c0100ccd <__panic>
    free_list = free_list_store;
c010338c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010338f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103392:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103397:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c010339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033a0:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c01033a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033ac:	00 
c01033ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033b0:	89 04 24             	mov    %eax,(%esp)
c01033b3:	e8 ce 09 00 00       	call   c0103d86 <free_pages>
    free_page(p1);
c01033b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033bf:	00 
c01033c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033c3:	89 04 24             	mov    %eax,(%esp)
c01033c6:	e8 bb 09 00 00       	call   c0103d86 <free_pages>
    free_page(p2);
c01033cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033d2:	00 
c01033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033d6:	89 04 24             	mov    %eax,(%esp)
c01033d9:	e8 a8 09 00 00       	call   c0103d86 <free_pages>
}
c01033de:	c9                   	leave  
c01033df:	c3                   	ret    

c01033e0 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01033e0:	55                   	push   %ebp
c01033e1:	89 e5                	mov    %esp,%ebp
c01033e3:	53                   	push   %ebx
c01033e4:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01033ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01033f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01033f8:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033ff:	eb 6b                	jmp    c010346c <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103401:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103404:	83 e8 0c             	sub    $0xc,%eax
c0103407:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010340d:	83 c0 04             	add    $0x4,%eax
c0103410:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103417:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010341a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010341d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103420:	0f a3 10             	bt     %edx,(%eax)
c0103423:	19 c0                	sbb    %eax,%eax
c0103425:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103428:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010342c:	0f 95 c0             	setne  %al
c010342f:	0f b6 c0             	movzbl %al,%eax
c0103432:	85 c0                	test   %eax,%eax
c0103434:	75 24                	jne    c010345a <default_check+0x7a>
c0103436:	c7 44 24 0c de 68 10 	movl   $0xc01068de,0xc(%esp)
c010343d:	c0 
c010343e:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103445:	c0 
c0103446:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c010344d:	00 
c010344e:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103455:	e8 73 d8 ff ff       	call   c0100ccd <__panic>
        count ++, total += p->property;
c010345a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010345e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103461:	8b 50 08             	mov    0x8(%eax),%edx
c0103464:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103467:	01 d0                	add    %edx,%eax
c0103469:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010346c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010346f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103472:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103475:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103478:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010347b:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103482:	0f 85 79 ff ff ff    	jne    c0103401 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103488:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010348b:	e8 28 09 00 00       	call   c0103db8 <nr_free_pages>
c0103490:	39 c3                	cmp    %eax,%ebx
c0103492:	74 24                	je     c01034b8 <default_check+0xd8>
c0103494:	c7 44 24 0c ee 68 10 	movl   $0xc01068ee,0xc(%esp)
c010349b:	c0 
c010349c:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01034a3:	c0 
c01034a4:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01034ab:	00 
c01034ac:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01034b3:	e8 15 d8 ff ff       	call   c0100ccd <__panic>

    basic_check();
c01034b8:	e8 e7 f9 ff ff       	call   c0102ea4 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01034bd:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01034c4:	e8 85 08 00 00       	call   c0103d4e <alloc_pages>
c01034c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01034cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01034d0:	75 24                	jne    c01034f6 <default_check+0x116>
c01034d2:	c7 44 24 0c 07 69 10 	movl   $0xc0106907,0xc(%esp)
c01034d9:	c0 
c01034da:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01034e1:	c0 
c01034e2:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01034e9:	00 
c01034ea:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01034f1:	e8 d7 d7 ff ff       	call   c0100ccd <__panic>
    assert(!PageProperty(p0));
c01034f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034f9:	83 c0 04             	add    $0x4,%eax
c01034fc:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103503:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103506:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103509:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010350c:	0f a3 10             	bt     %edx,(%eax)
c010350f:	19 c0                	sbb    %eax,%eax
c0103511:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103514:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103518:	0f 95 c0             	setne  %al
c010351b:	0f b6 c0             	movzbl %al,%eax
c010351e:	85 c0                	test   %eax,%eax
c0103520:	74 24                	je     c0103546 <default_check+0x166>
c0103522:	c7 44 24 0c 12 69 10 	movl   $0xc0106912,0xc(%esp)
c0103529:	c0 
c010352a:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103531:	c0 
c0103532:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0103539:	00 
c010353a:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103541:	e8 87 d7 ff ff       	call   c0100ccd <__panic>

    list_entry_t free_list_store = free_list;
c0103546:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010354b:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103551:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103554:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103557:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010355e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103561:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103564:	89 50 04             	mov    %edx,0x4(%eax)
c0103567:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010356a:	8b 50 04             	mov    0x4(%eax),%edx
c010356d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103570:	89 10                	mov    %edx,(%eax)
c0103572:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103579:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010357c:	8b 40 04             	mov    0x4(%eax),%eax
c010357f:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103582:	0f 94 c0             	sete   %al
c0103585:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103588:	85 c0                	test   %eax,%eax
c010358a:	75 24                	jne    c01035b0 <default_check+0x1d0>
c010358c:	c7 44 24 0c 67 68 10 	movl   $0xc0106867,0xc(%esp)
c0103593:	c0 
c0103594:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010359b:	c0 
c010359c:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01035a3:	00 
c01035a4:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01035ab:	e8 1d d7 ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c01035b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035b7:	e8 92 07 00 00       	call   c0103d4e <alloc_pages>
c01035bc:	85 c0                	test   %eax,%eax
c01035be:	74 24                	je     c01035e4 <default_check+0x204>
c01035c0:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c01035c7:	c0 
c01035c8:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01035cf:	c0 
c01035d0:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01035d7:	00 
c01035d8:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01035df:	e8 e9 d6 ff ff       	call   c0100ccd <__panic>

    unsigned int nr_free_store = nr_free;
c01035e4:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01035ec:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01035f3:	00 00 00 

    free_pages(p0 + 2, 3);
c01035f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035f9:	83 c0 28             	add    $0x28,%eax
c01035fc:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103603:	00 
c0103604:	89 04 24             	mov    %eax,(%esp)
c0103607:	e8 7a 07 00 00       	call   c0103d86 <free_pages>
    assert(alloc_pages(4) == NULL);
c010360c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103613:	e8 36 07 00 00       	call   c0103d4e <alloc_pages>
c0103618:	85 c0                	test   %eax,%eax
c010361a:	74 24                	je     c0103640 <default_check+0x260>
c010361c:	c7 44 24 0c 24 69 10 	movl   $0xc0106924,0xc(%esp)
c0103623:	c0 
c0103624:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010362b:	c0 
c010362c:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103633:	00 
c0103634:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010363b:	e8 8d d6 ff ff       	call   c0100ccd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103643:	83 c0 28             	add    $0x28,%eax
c0103646:	83 c0 04             	add    $0x4,%eax
c0103649:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103650:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103653:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103656:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103659:	0f a3 10             	bt     %edx,(%eax)
c010365c:	19 c0                	sbb    %eax,%eax
c010365e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103661:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103665:	0f 95 c0             	setne  %al
c0103668:	0f b6 c0             	movzbl %al,%eax
c010366b:	85 c0                	test   %eax,%eax
c010366d:	74 0e                	je     c010367d <default_check+0x29d>
c010366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103672:	83 c0 28             	add    $0x28,%eax
c0103675:	8b 40 08             	mov    0x8(%eax),%eax
c0103678:	83 f8 03             	cmp    $0x3,%eax
c010367b:	74 24                	je     c01036a1 <default_check+0x2c1>
c010367d:	c7 44 24 0c 3c 69 10 	movl   $0xc010693c,0xc(%esp)
c0103684:	c0 
c0103685:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010368c:	c0 
c010368d:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103694:	00 
c0103695:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010369c:	e8 2c d6 ff ff       	call   c0100ccd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01036a1:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01036a8:	e8 a1 06 00 00       	call   c0103d4e <alloc_pages>
c01036ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01036b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01036b4:	75 24                	jne    c01036da <default_check+0x2fa>
c01036b6:	c7 44 24 0c 68 69 10 	movl   $0xc0106968,0xc(%esp)
c01036bd:	c0 
c01036be:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01036c5:	c0 
c01036c6:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01036cd:	00 
c01036ce:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01036d5:	e8 f3 d5 ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c01036da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036e1:	e8 68 06 00 00       	call   c0103d4e <alloc_pages>
c01036e6:	85 c0                	test   %eax,%eax
c01036e8:	74 24                	je     c010370e <default_check+0x32e>
c01036ea:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c01036f1:	c0 
c01036f2:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01036f9:	c0 
c01036fa:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103701:	00 
c0103702:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103709:	e8 bf d5 ff ff       	call   c0100ccd <__panic>
    assert(p0 + 2 == p1);
c010370e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103711:	83 c0 28             	add    $0x28,%eax
c0103714:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103717:	74 24                	je     c010373d <default_check+0x35d>
c0103719:	c7 44 24 0c 86 69 10 	movl   $0xc0106986,0xc(%esp)
c0103720:	c0 
c0103721:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103728:	c0 
c0103729:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103730:	00 
c0103731:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103738:	e8 90 d5 ff ff       	call   c0100ccd <__panic>

    p2 = p0 + 1;
c010373d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103740:	83 c0 14             	add    $0x14,%eax
c0103743:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103746:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010374d:	00 
c010374e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103751:	89 04 24             	mov    %eax,(%esp)
c0103754:	e8 2d 06 00 00       	call   c0103d86 <free_pages>
    free_pages(p1, 3);
c0103759:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103760:	00 
c0103761:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103764:	89 04 24             	mov    %eax,(%esp)
c0103767:	e8 1a 06 00 00       	call   c0103d86 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010376c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010376f:	83 c0 04             	add    $0x4,%eax
c0103772:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103779:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010377c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010377f:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103782:	0f a3 10             	bt     %edx,(%eax)
c0103785:	19 c0                	sbb    %eax,%eax
c0103787:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010378a:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010378e:	0f 95 c0             	setne  %al
c0103791:	0f b6 c0             	movzbl %al,%eax
c0103794:	85 c0                	test   %eax,%eax
c0103796:	74 0b                	je     c01037a3 <default_check+0x3c3>
c0103798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010379b:	8b 40 08             	mov    0x8(%eax),%eax
c010379e:	83 f8 01             	cmp    $0x1,%eax
c01037a1:	74 24                	je     c01037c7 <default_check+0x3e7>
c01037a3:	c7 44 24 0c 94 69 10 	movl   $0xc0106994,0xc(%esp)
c01037aa:	c0 
c01037ab:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01037b2:	c0 
c01037b3:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c01037ba:	00 
c01037bb:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01037c2:	e8 06 d5 ff ff       	call   c0100ccd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01037c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037ca:	83 c0 04             	add    $0x4,%eax
c01037cd:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01037d4:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037d7:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037da:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01037dd:	0f a3 10             	bt     %edx,(%eax)
c01037e0:	19 c0                	sbb    %eax,%eax
c01037e2:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01037e5:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01037e9:	0f 95 c0             	setne  %al
c01037ec:	0f b6 c0             	movzbl %al,%eax
c01037ef:	85 c0                	test   %eax,%eax
c01037f1:	74 0b                	je     c01037fe <default_check+0x41e>
c01037f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037f6:	8b 40 08             	mov    0x8(%eax),%eax
c01037f9:	83 f8 03             	cmp    $0x3,%eax
c01037fc:	74 24                	je     c0103822 <default_check+0x442>
c01037fe:	c7 44 24 0c bc 69 10 	movl   $0xc01069bc,0xc(%esp)
c0103805:	c0 
c0103806:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010380d:	c0 
c010380e:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103815:	00 
c0103816:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010381d:	e8 ab d4 ff ff       	call   c0100ccd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103822:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103829:	e8 20 05 00 00       	call   c0103d4e <alloc_pages>
c010382e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103831:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103834:	83 e8 14             	sub    $0x14,%eax
c0103837:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010383a:	74 24                	je     c0103860 <default_check+0x480>
c010383c:	c7 44 24 0c e2 69 10 	movl   $0xc01069e2,0xc(%esp)
c0103843:	c0 
c0103844:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010384b:	c0 
c010384c:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103853:	00 
c0103854:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010385b:	e8 6d d4 ff ff       	call   c0100ccd <__panic>
    free_page(p0);
c0103860:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103867:	00 
c0103868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010386b:	89 04 24             	mov    %eax,(%esp)
c010386e:	e8 13 05 00 00       	call   c0103d86 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103873:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010387a:	e8 cf 04 00 00       	call   c0103d4e <alloc_pages>
c010387f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103882:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103885:	83 c0 14             	add    $0x14,%eax
c0103888:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010388b:	74 24                	je     c01038b1 <default_check+0x4d1>
c010388d:	c7 44 24 0c 00 6a 10 	movl   $0xc0106a00,0xc(%esp)
c0103894:	c0 
c0103895:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010389c:	c0 
c010389d:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01038a4:	00 
c01038a5:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01038ac:	e8 1c d4 ff ff       	call   c0100ccd <__panic>

    free_pages(p0, 2);
c01038b1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01038b8:	00 
c01038b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038bc:	89 04 24             	mov    %eax,(%esp)
c01038bf:	e8 c2 04 00 00       	call   c0103d86 <free_pages>
    free_page(p2);
c01038c4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038cb:	00 
c01038cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038cf:	89 04 24             	mov    %eax,(%esp)
c01038d2:	e8 af 04 00 00       	call   c0103d86 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01038d7:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01038de:	e8 6b 04 00 00       	call   c0103d4e <alloc_pages>
c01038e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01038ea:	75 24                	jne    c0103910 <default_check+0x530>
c01038ec:	c7 44 24 0c 20 6a 10 	movl   $0xc0106a20,0xc(%esp)
c01038f3:	c0 
c01038f4:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01038fb:	c0 
c01038fc:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103903:	00 
c0103904:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010390b:	e8 bd d3 ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c0103910:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103917:	e8 32 04 00 00       	call   c0103d4e <alloc_pages>
c010391c:	85 c0                	test   %eax,%eax
c010391e:	74 24                	je     c0103944 <default_check+0x564>
c0103920:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c0103927:	c0 
c0103928:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010392f:	c0 
c0103930:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103937:	00 
c0103938:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010393f:	e8 89 d3 ff ff       	call   c0100ccd <__panic>

    assert(nr_free == 0);
c0103944:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103949:	85 c0                	test   %eax,%eax
c010394b:	74 24                	je     c0103971 <default_check+0x591>
c010394d:	c7 44 24 0c d1 68 10 	movl   $0xc01068d1,0xc(%esp)
c0103954:	c0 
c0103955:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010395c:	c0 
c010395d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103964:	00 
c0103965:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010396c:	e8 5c d3 ff ff       	call   c0100ccd <__panic>
    nr_free = nr_free_store;
c0103971:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103974:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c0103979:	8b 45 80             	mov    -0x80(%ebp),%eax
c010397c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010397f:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103984:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c010398a:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103991:	00 
c0103992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103995:	89 04 24             	mov    %eax,(%esp)
c0103998:	e8 e9 03 00 00       	call   c0103d86 <free_pages>

    le = &free_list;
c010399d:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01039a4:	eb 1d                	jmp    c01039c3 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01039a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039a9:	83 e8 0c             	sub    $0xc,%eax
c01039ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01039af:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01039b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01039b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01039b9:	8b 40 08             	mov    0x8(%eax),%eax
c01039bc:	29 c2                	sub    %eax,%edx
c01039be:	89 d0                	mov    %edx,%eax
c01039c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039c6:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01039c9:	8b 45 88             	mov    -0x78(%ebp),%eax
c01039cc:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01039cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039d2:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01039d9:	75 cb                	jne    c01039a6 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01039db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039df:	74 24                	je     c0103a05 <default_check+0x625>
c01039e1:	c7 44 24 0c 3e 6a 10 	movl   $0xc0106a3e,0xc(%esp)
c01039e8:	c0 
c01039e9:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01039f0:	c0 
c01039f1:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01039f8:	00 
c01039f9:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103a00:	e8 c8 d2 ff ff       	call   c0100ccd <__panic>
    assert(total == 0);
c0103a05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a09:	74 24                	je     c0103a2f <default_check+0x64f>
c0103a0b:	c7 44 24 0c 49 6a 10 	movl   $0xc0106a49,0xc(%esp)
c0103a12:	c0 
c0103a13:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103a1a:	c0 
c0103a1b:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103a22:	00 
c0103a23:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103a2a:	e8 9e d2 ff ff       	call   c0100ccd <__panic>
}
c0103a2f:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103a35:	5b                   	pop    %ebx
c0103a36:	5d                   	pop    %ebp
c0103a37:	c3                   	ret    

c0103a38 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a38:	55                   	push   %ebp
c0103a39:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a3b:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a3e:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103a43:	29 c2                	sub    %eax,%edx
c0103a45:	89 d0                	mov    %edx,%eax
c0103a47:	c1 f8 02             	sar    $0x2,%eax
c0103a4a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a50:	5d                   	pop    %ebp
c0103a51:	c3                   	ret    

c0103a52 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a52:	55                   	push   %ebp
c0103a53:	89 e5                	mov    %esp,%ebp
c0103a55:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a5b:	89 04 24             	mov    %eax,(%esp)
c0103a5e:	e8 d5 ff ff ff       	call   c0103a38 <page2ppn>
c0103a63:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a66:	c9                   	leave  
c0103a67:	c3                   	ret    

c0103a68 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a68:	55                   	push   %ebp
c0103a69:	89 e5                	mov    %esp,%ebp
c0103a6b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a71:	c1 e8 0c             	shr    $0xc,%eax
c0103a74:	89 c2                	mov    %eax,%edx
c0103a76:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a7b:	39 c2                	cmp    %eax,%edx
c0103a7d:	72 1c                	jb     c0103a9b <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103a7f:	c7 44 24 08 84 6a 10 	movl   $0xc0106a84,0x8(%esp)
c0103a86:	c0 
c0103a87:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a8e:	00 
c0103a8f:	c7 04 24 a3 6a 10 c0 	movl   $0xc0106aa3,(%esp)
c0103a96:	e8 32 d2 ff ff       	call   c0100ccd <__panic>
    }
    return &pages[PPN(pa)];
c0103a9b:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aa4:	c1 e8 0c             	shr    $0xc,%eax
c0103aa7:	89 c2                	mov    %eax,%edx
c0103aa9:	89 d0                	mov    %edx,%eax
c0103aab:	c1 e0 02             	shl    $0x2,%eax
c0103aae:	01 d0                	add    %edx,%eax
c0103ab0:	c1 e0 02             	shl    $0x2,%eax
c0103ab3:	01 c8                	add    %ecx,%eax
}
c0103ab5:	c9                   	leave  
c0103ab6:	c3                   	ret    

c0103ab7 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103ab7:	55                   	push   %ebp
c0103ab8:	89 e5                	mov    %esp,%ebp
c0103aba:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac0:	89 04 24             	mov    %eax,(%esp)
c0103ac3:	e8 8a ff ff ff       	call   c0103a52 <page2pa>
c0103ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ace:	c1 e8 0c             	shr    $0xc,%eax
c0103ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ad4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103ad9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103adc:	72 23                	jb     c0103b01 <page2kva+0x4a>
c0103ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ae1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ae5:	c7 44 24 08 b4 6a 10 	movl   $0xc0106ab4,0x8(%esp)
c0103aec:	c0 
c0103aed:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103af4:	00 
c0103af5:	c7 04 24 a3 6a 10 c0 	movl   $0xc0106aa3,(%esp)
c0103afc:	e8 cc d1 ff ff       	call   c0100ccd <__panic>
c0103b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b04:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103b09:	c9                   	leave  
c0103b0a:	c3                   	ret    

c0103b0b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103b0b:	55                   	push   %ebp
c0103b0c:	89 e5                	mov    %esp,%ebp
c0103b0e:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b14:	83 e0 01             	and    $0x1,%eax
c0103b17:	85 c0                	test   %eax,%eax
c0103b19:	75 1c                	jne    c0103b37 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103b1b:	c7 44 24 08 d8 6a 10 	movl   $0xc0106ad8,0x8(%esp)
c0103b22:	c0 
c0103b23:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103b2a:	00 
c0103b2b:	c7 04 24 a3 6a 10 c0 	movl   $0xc0106aa3,(%esp)
c0103b32:	e8 96 d1 ff ff       	call   c0100ccd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103b37:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b3f:	89 04 24             	mov    %eax,(%esp)
c0103b42:	e8 21 ff ff ff       	call   c0103a68 <pa2page>
}
c0103b47:	c9                   	leave  
c0103b48:	c3                   	ret    

c0103b49 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103b49:	55                   	push   %ebp
c0103b4a:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4f:	8b 00                	mov    (%eax),%eax
}
c0103b51:	5d                   	pop    %ebp
c0103b52:	c3                   	ret    

c0103b53 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103b53:	55                   	push   %ebp
c0103b54:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b59:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b5c:	89 10                	mov    %edx,(%eax)
}
c0103b5e:	5d                   	pop    %ebp
c0103b5f:	c3                   	ret    

c0103b60 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103b60:	55                   	push   %ebp
c0103b61:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b66:	8b 00                	mov    (%eax),%eax
c0103b68:	8d 50 01             	lea    0x1(%eax),%edx
c0103b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b6e:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b70:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b73:	8b 00                	mov    (%eax),%eax
}
c0103b75:	5d                   	pop    %ebp
c0103b76:	c3                   	ret    

c0103b77 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103b77:	55                   	push   %ebp
c0103b78:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103b7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b7d:	8b 00                	mov    (%eax),%eax
c0103b7f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103b82:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b85:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b8a:	8b 00                	mov    (%eax),%eax
}
c0103b8c:	5d                   	pop    %ebp
c0103b8d:	c3                   	ret    

c0103b8e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103b8e:	55                   	push   %ebp
c0103b8f:	89 e5                	mov    %esp,%ebp
c0103b91:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b94:	9c                   	pushf  
c0103b95:	58                   	pop    %eax
c0103b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b9c:	25 00 02 00 00       	and    $0x200,%eax
c0103ba1:	85 c0                	test   %eax,%eax
c0103ba3:	74 0c                	je     c0103bb1 <__intr_save+0x23>
        intr_disable();
c0103ba5:	e8 06 db ff ff       	call   c01016b0 <intr_disable>
        return 1;
c0103baa:	b8 01 00 00 00       	mov    $0x1,%eax
c0103baf:	eb 05                	jmp    c0103bb6 <__intr_save+0x28>
    }
    return 0;
c0103bb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103bb6:	c9                   	leave  
c0103bb7:	c3                   	ret    

c0103bb8 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103bb8:	55                   	push   %ebp
c0103bb9:	89 e5                	mov    %esp,%ebp
c0103bbb:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103bc2:	74 05                	je     c0103bc9 <__intr_restore+0x11>
        intr_enable();
c0103bc4:	e8 e1 da ff ff       	call   c01016aa <intr_enable>
    }
}
c0103bc9:	c9                   	leave  
c0103bca:	c3                   	ret    

c0103bcb <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103bcb:	55                   	push   %ebp
c0103bcc:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103bce:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd1:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103bd4:	b8 23 00 00 00       	mov    $0x23,%eax
c0103bd9:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103bdb:	b8 23 00 00 00       	mov    $0x23,%eax
c0103be0:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103be2:	b8 10 00 00 00       	mov    $0x10,%eax
c0103be7:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103be9:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bee:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103bf0:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bf5:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103bf7:	ea fe 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103bfe
}
c0103bfe:	5d                   	pop    %ebp
c0103bff:	c3                   	ret    

c0103c00 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103c00:	55                   	push   %ebp
c0103c01:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c06:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103c0b:	5d                   	pop    %ebp
c0103c0c:	c3                   	ret    

c0103c0d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103c0d:	55                   	push   %ebp
c0103c0e:	89 e5                	mov    %esp,%ebp
c0103c10:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103c13:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103c18:	89 04 24             	mov    %eax,(%esp)
c0103c1b:	e8 e0 ff ff ff       	call   c0103c00 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103c20:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103c27:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103c29:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103c30:	68 00 
c0103c32:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c37:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c3d:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c42:	c1 e8 10             	shr    $0x10,%eax
c0103c45:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c4a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c51:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c54:	83 c8 09             	or     $0x9,%eax
c0103c57:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c5c:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c63:	83 e0 ef             	and    $0xffffffef,%eax
c0103c66:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c6b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c72:	83 e0 9f             	and    $0xffffff9f,%eax
c0103c75:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c7a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c81:	83 c8 80             	or     $0xffffff80,%eax
c0103c84:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c89:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c90:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c93:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c98:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c9f:	83 e0 ef             	and    $0xffffffef,%eax
c0103ca2:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ca7:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cae:	83 e0 df             	and    $0xffffffdf,%eax
c0103cb1:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cb6:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cbd:	83 c8 40             	or     $0x40,%eax
c0103cc0:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cc5:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ccc:	83 e0 7f             	and    $0x7f,%eax
c0103ccf:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cd4:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103cd9:	c1 e8 18             	shr    $0x18,%eax
c0103cdc:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103ce1:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103ce8:	e8 de fe ff ff       	call   c0103bcb <lgdt>
c0103ced:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103cf3:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103cf7:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103cfa:	c9                   	leave  
c0103cfb:	c3                   	ret    

c0103cfc <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103cfc:	55                   	push   %ebp
c0103cfd:	89 e5                	mov    %esp,%ebp
c0103cff:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103d02:	c7 05 5c 89 11 c0 68 	movl   $0xc0106a68,0xc011895c
c0103d09:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103d0c:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d11:	8b 00                	mov    (%eax),%eax
c0103d13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d17:	c7 04 24 04 6b 10 c0 	movl   $0xc0106b04,(%esp)
c0103d1e:	e8 19 c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103d23:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d28:	8b 40 04             	mov    0x4(%eax),%eax
c0103d2b:	ff d0                	call   *%eax
}
c0103d2d:	c9                   	leave  
c0103d2e:	c3                   	ret    

c0103d2f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103d2f:	55                   	push   %ebp
c0103d30:	89 e5                	mov    %esp,%ebp
c0103d32:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d35:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d3a:	8b 40 08             	mov    0x8(%eax),%eax
c0103d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d40:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d44:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d47:	89 14 24             	mov    %edx,(%esp)
c0103d4a:	ff d0                	call   *%eax
}
c0103d4c:	c9                   	leave  
c0103d4d:	c3                   	ret    

c0103d4e <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d4e:	55                   	push   %ebp
c0103d4f:	89 e5                	mov    %esp,%ebp
c0103d51:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d5b:	e8 2e fe ff ff       	call   c0103b8e <__intr_save>
c0103d60:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d63:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d68:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d6b:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d6e:	89 14 24             	mov    %edx,(%esp)
c0103d71:	ff d0                	call   *%eax
c0103d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d79:	89 04 24             	mov    %eax,(%esp)
c0103d7c:	e8 37 fe ff ff       	call   c0103bb8 <__intr_restore>
    return page;
c0103d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103d84:	c9                   	leave  
c0103d85:	c3                   	ret    

c0103d86 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d86:	55                   	push   %ebp
c0103d87:	89 e5                	mov    %esp,%ebp
c0103d89:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d8c:	e8 fd fd ff ff       	call   c0103b8e <__intr_save>
c0103d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d94:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d99:	8b 40 10             	mov    0x10(%eax),%eax
c0103d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d9f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103da3:	8b 55 08             	mov    0x8(%ebp),%edx
c0103da6:	89 14 24             	mov    %edx,(%esp)
c0103da9:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dae:	89 04 24             	mov    %eax,(%esp)
c0103db1:	e8 02 fe ff ff       	call   c0103bb8 <__intr_restore>
}
c0103db6:	c9                   	leave  
c0103db7:	c3                   	ret    

c0103db8 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103db8:	55                   	push   %ebp
c0103db9:	89 e5                	mov    %esp,%ebp
c0103dbb:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103dbe:	e8 cb fd ff ff       	call   c0103b8e <__intr_save>
c0103dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103dc6:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103dcb:	8b 40 14             	mov    0x14(%eax),%eax
c0103dce:	ff d0                	call   *%eax
c0103dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dd6:	89 04 24             	mov    %eax,(%esp)
c0103dd9:	e8 da fd ff ff       	call   c0103bb8 <__intr_restore>
    return ret;
c0103dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103de1:	c9                   	leave  
c0103de2:	c3                   	ret    

c0103de3 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103de3:	55                   	push   %ebp
c0103de4:	89 e5                	mov    %esp,%ebp
c0103de6:	57                   	push   %edi
c0103de7:	56                   	push   %esi
c0103de8:	53                   	push   %ebx
c0103de9:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103def:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103df6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103dfd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103e04:	c7 04 24 1b 6b 10 c0 	movl   $0xc0106b1b,(%esp)
c0103e0b:	e8 2c c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e17:	e9 15 01 00 00       	jmp    c0103f31 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e1c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e22:	89 d0                	mov    %edx,%eax
c0103e24:	c1 e0 02             	shl    $0x2,%eax
c0103e27:	01 d0                	add    %edx,%eax
c0103e29:	c1 e0 02             	shl    $0x2,%eax
c0103e2c:	01 c8                	add    %ecx,%eax
c0103e2e:	8b 50 08             	mov    0x8(%eax),%edx
c0103e31:	8b 40 04             	mov    0x4(%eax),%eax
c0103e34:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e37:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e3a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e40:	89 d0                	mov    %edx,%eax
c0103e42:	c1 e0 02             	shl    $0x2,%eax
c0103e45:	01 d0                	add    %edx,%eax
c0103e47:	c1 e0 02             	shl    $0x2,%eax
c0103e4a:	01 c8                	add    %ecx,%eax
c0103e4c:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e4f:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e52:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e55:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e58:	01 c8                	add    %ecx,%eax
c0103e5a:	11 da                	adc    %ebx,%edx
c0103e5c:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e5f:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e62:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e65:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e68:	89 d0                	mov    %edx,%eax
c0103e6a:	c1 e0 02             	shl    $0x2,%eax
c0103e6d:	01 d0                	add    %edx,%eax
c0103e6f:	c1 e0 02             	shl    $0x2,%eax
c0103e72:	01 c8                	add    %ecx,%eax
c0103e74:	83 c0 14             	add    $0x14,%eax
c0103e77:	8b 00                	mov    (%eax),%eax
c0103e79:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103e7f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e82:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e85:	83 c0 ff             	add    $0xffffffff,%eax
c0103e88:	83 d2 ff             	adc    $0xffffffff,%edx
c0103e8b:	89 c6                	mov    %eax,%esi
c0103e8d:	89 d7                	mov    %edx,%edi
c0103e8f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e92:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e95:	89 d0                	mov    %edx,%eax
c0103e97:	c1 e0 02             	shl    $0x2,%eax
c0103e9a:	01 d0                	add    %edx,%eax
c0103e9c:	c1 e0 02             	shl    $0x2,%eax
c0103e9f:	01 c8                	add    %ecx,%eax
c0103ea1:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103ea4:	8b 58 10             	mov    0x10(%eax),%ebx
c0103ea7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103ead:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103eb1:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103eb5:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103eb9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ebc:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103ebf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ec3:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103ec7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103ecb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103ecf:	c7 04 24 28 6b 10 c0 	movl   $0xc0106b28,(%esp)
c0103ed6:	e8 61 c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103edb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ede:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ee1:	89 d0                	mov    %edx,%eax
c0103ee3:	c1 e0 02             	shl    $0x2,%eax
c0103ee6:	01 d0                	add    %edx,%eax
c0103ee8:	c1 e0 02             	shl    $0x2,%eax
c0103eeb:	01 c8                	add    %ecx,%eax
c0103eed:	83 c0 14             	add    $0x14,%eax
c0103ef0:	8b 00                	mov    (%eax),%eax
c0103ef2:	83 f8 01             	cmp    $0x1,%eax
c0103ef5:	75 36                	jne    c0103f2d <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103ef7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103efa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103efd:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f00:	77 2b                	ja     c0103f2d <page_init+0x14a>
c0103f02:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f05:	72 05                	jb     c0103f0c <page_init+0x129>
c0103f07:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103f0a:	73 21                	jae    c0103f2d <page_init+0x14a>
c0103f0c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f10:	77 1b                	ja     c0103f2d <page_init+0x14a>
c0103f12:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f16:	72 09                	jb     c0103f21 <page_init+0x13e>
c0103f18:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103f1f:	77 0c                	ja     c0103f2d <page_init+0x14a>
                maxpa = end;
c0103f21:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f24:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f27:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103f2a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f2d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f34:	8b 00                	mov    (%eax),%eax
c0103f36:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f39:	0f 8f dd fe ff ff    	jg     c0103e1c <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f43:	72 1d                	jb     c0103f62 <page_init+0x17f>
c0103f45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f49:	77 09                	ja     c0103f54 <page_init+0x171>
c0103f4b:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f52:	76 0e                	jbe    c0103f62 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f54:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103f62:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f68:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f6c:	c1 ea 0c             	shr    $0xc,%edx
c0103f6f:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103f74:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103f7b:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103f80:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103f83:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f86:	01 d0                	add    %edx,%eax
c0103f88:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f8b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f8e:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f93:	f7 75 ac             	divl   -0x54(%ebp)
c0103f96:	89 d0                	mov    %edx,%eax
c0103f98:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f9b:	29 c2                	sub    %eax,%edx
c0103f9d:	89 d0                	mov    %edx,%eax
c0103f9f:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103fa4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fab:	eb 2f                	jmp    c0103fdc <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103fad:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103fb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fb6:	89 d0                	mov    %edx,%eax
c0103fb8:	c1 e0 02             	shl    $0x2,%eax
c0103fbb:	01 d0                	add    %edx,%eax
c0103fbd:	c1 e0 02             	shl    $0x2,%eax
c0103fc0:	01 c8                	add    %ecx,%eax
c0103fc2:	83 c0 04             	add    $0x4,%eax
c0103fc5:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103fcc:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103fcf:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103fd2:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103fd5:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103fd8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103fdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fdf:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103fe4:	39 c2                	cmp    %eax,%edx
c0103fe6:	72 c5                	jb     c0103fad <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103fe8:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103fee:	89 d0                	mov    %edx,%eax
c0103ff0:	c1 e0 02             	shl    $0x2,%eax
c0103ff3:	01 d0                	add    %edx,%eax
c0103ff5:	c1 e0 02             	shl    $0x2,%eax
c0103ff8:	89 c2                	mov    %eax,%edx
c0103ffa:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103fff:	01 d0                	add    %edx,%eax
c0104001:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104004:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c010400b:	77 23                	ja     c0104030 <page_init+0x24d>
c010400d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104010:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104014:	c7 44 24 08 58 6b 10 	movl   $0xc0106b58,0x8(%esp)
c010401b:	c0 
c010401c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104023:	00 
c0104024:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c010402b:	e8 9d cc ff ff       	call   c0100ccd <__panic>
c0104030:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104033:	05 00 00 00 40       	add    $0x40000000,%eax
c0104038:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010403b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104042:	e9 74 01 00 00       	jmp    c01041bb <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104047:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010404a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010404d:	89 d0                	mov    %edx,%eax
c010404f:	c1 e0 02             	shl    $0x2,%eax
c0104052:	01 d0                	add    %edx,%eax
c0104054:	c1 e0 02             	shl    $0x2,%eax
c0104057:	01 c8                	add    %ecx,%eax
c0104059:	8b 50 08             	mov    0x8(%eax),%edx
c010405c:	8b 40 04             	mov    0x4(%eax),%eax
c010405f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104062:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104065:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104068:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010406b:	89 d0                	mov    %edx,%eax
c010406d:	c1 e0 02             	shl    $0x2,%eax
c0104070:	01 d0                	add    %edx,%eax
c0104072:	c1 e0 02             	shl    $0x2,%eax
c0104075:	01 c8                	add    %ecx,%eax
c0104077:	8b 48 0c             	mov    0xc(%eax),%ecx
c010407a:	8b 58 10             	mov    0x10(%eax),%ebx
c010407d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104080:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104083:	01 c8                	add    %ecx,%eax
c0104085:	11 da                	adc    %ebx,%edx
c0104087:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010408a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010408d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104090:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104093:	89 d0                	mov    %edx,%eax
c0104095:	c1 e0 02             	shl    $0x2,%eax
c0104098:	01 d0                	add    %edx,%eax
c010409a:	c1 e0 02             	shl    $0x2,%eax
c010409d:	01 c8                	add    %ecx,%eax
c010409f:	83 c0 14             	add    $0x14,%eax
c01040a2:	8b 00                	mov    (%eax),%eax
c01040a4:	83 f8 01             	cmp    $0x1,%eax
c01040a7:	0f 85 0a 01 00 00    	jne    c01041b7 <page_init+0x3d4>
            if (begin < freemem) {
c01040ad:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040b0:	ba 00 00 00 00       	mov    $0x0,%edx
c01040b5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040b8:	72 17                	jb     c01040d1 <page_init+0x2ee>
c01040ba:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040bd:	77 05                	ja     c01040c4 <page_init+0x2e1>
c01040bf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01040c2:	76 0d                	jbe    c01040d1 <page_init+0x2ee>
                begin = freemem;
c01040c4:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040ca:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01040d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040d5:	72 1d                	jb     c01040f4 <page_init+0x311>
c01040d7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040db:	77 09                	ja     c01040e6 <page_init+0x303>
c01040dd:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01040e4:	76 0e                	jbe    c01040f4 <page_init+0x311>
                end = KMEMSIZE;
c01040e6:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01040ed:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01040f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040fa:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040fd:	0f 87 b4 00 00 00    	ja     c01041b7 <page_init+0x3d4>
c0104103:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104106:	72 09                	jb     c0104111 <page_init+0x32e>
c0104108:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010410b:	0f 83 a6 00 00 00    	jae    c01041b7 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104111:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104118:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010411b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010411e:	01 d0                	add    %edx,%eax
c0104120:	83 e8 01             	sub    $0x1,%eax
c0104123:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104126:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104129:	ba 00 00 00 00       	mov    $0x0,%edx
c010412e:	f7 75 9c             	divl   -0x64(%ebp)
c0104131:	89 d0                	mov    %edx,%eax
c0104133:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104136:	29 c2                	sub    %eax,%edx
c0104138:	89 d0                	mov    %edx,%eax
c010413a:	ba 00 00 00 00       	mov    $0x0,%edx
c010413f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104142:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104145:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104148:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010414b:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010414e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104153:	89 c7                	mov    %eax,%edi
c0104155:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010415b:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010415e:	89 d0                	mov    %edx,%eax
c0104160:	83 e0 00             	and    $0x0,%eax
c0104163:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104166:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104169:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010416c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010416f:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104172:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104175:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104178:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010417b:	77 3a                	ja     c01041b7 <page_init+0x3d4>
c010417d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104180:	72 05                	jb     c0104187 <page_init+0x3a4>
c0104182:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104185:	73 30                	jae    c01041b7 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104187:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010418a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010418d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104190:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104193:	29 c8                	sub    %ecx,%eax
c0104195:	19 da                	sbb    %ebx,%edx
c0104197:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010419b:	c1 ea 0c             	shr    $0xc,%edx
c010419e:	89 c3                	mov    %eax,%ebx
c01041a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041a3:	89 04 24             	mov    %eax,(%esp)
c01041a6:	e8 bd f8 ff ff       	call   c0103a68 <pa2page>
c01041ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01041af:	89 04 24             	mov    %eax,(%esp)
c01041b2:	e8 78 fb ff ff       	call   c0103d2f <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01041b7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01041bb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041be:	8b 00                	mov    (%eax),%eax
c01041c0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01041c3:	0f 8f 7e fe ff ff    	jg     c0104047 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01041c9:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01041cf:	5b                   	pop    %ebx
c01041d0:	5e                   	pop    %esi
c01041d1:	5f                   	pop    %edi
c01041d2:	5d                   	pop    %ebp
c01041d3:	c3                   	ret    

c01041d4 <enable_paging>:

static void
enable_paging(void) {
c01041d4:	55                   	push   %ebp
c01041d5:	89 e5                	mov    %esp,%ebp
c01041d7:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01041da:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c01041df:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01041e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01041e5:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01041e8:	0f 20 c0             	mov    %cr0,%eax
c01041eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01041ee:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01041f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01041f4:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01041fb:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01041ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104202:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104205:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104208:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010420b:	c9                   	leave  
c010420c:	c3                   	ret    

c010420d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010420d:	55                   	push   %ebp
c010420e:	89 e5                	mov    %esp,%ebp
c0104210:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104213:	8b 45 14             	mov    0x14(%ebp),%eax
c0104216:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104219:	31 d0                	xor    %edx,%eax
c010421b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104220:	85 c0                	test   %eax,%eax
c0104222:	74 24                	je     c0104248 <boot_map_segment+0x3b>
c0104224:	c7 44 24 0c 8a 6b 10 	movl   $0xc0106b8a,0xc(%esp)
c010422b:	c0 
c010422c:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104233:	c0 
c0104234:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010423b:	00 
c010423c:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104243:	e8 85 ca ff ff       	call   c0100ccd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104248:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010424f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104252:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104257:	89 c2                	mov    %eax,%edx
c0104259:	8b 45 10             	mov    0x10(%ebp),%eax
c010425c:	01 c2                	add    %eax,%edx
c010425e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104261:	01 d0                	add    %edx,%eax
c0104263:	83 e8 01             	sub    $0x1,%eax
c0104266:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104269:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010426c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104271:	f7 75 f0             	divl   -0x10(%ebp)
c0104274:	89 d0                	mov    %edx,%eax
c0104276:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104279:	29 c2                	sub    %eax,%edx
c010427b:	89 d0                	mov    %edx,%eax
c010427d:	c1 e8 0c             	shr    $0xc,%eax
c0104280:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104283:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104286:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104289:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010428c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104291:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104294:	8b 45 14             	mov    0x14(%ebp),%eax
c0104297:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010429a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010429d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042a2:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042a5:	eb 6b                	jmp    c0104312 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01042a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01042ae:	00 
c01042af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01042b9:	89 04 24             	mov    %eax,(%esp)
c01042bc:	e8 cc 01 00 00       	call   c010448d <get_pte>
c01042c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01042c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042c8:	75 24                	jne    c01042ee <boot_map_segment+0xe1>
c01042ca:	c7 44 24 0c b6 6b 10 	movl   $0xc0106bb6,0xc(%esp)
c01042d1:	c0 
c01042d2:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c01042d9:	c0 
c01042da:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01042e1:	00 
c01042e2:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c01042e9:	e8 df c9 ff ff       	call   c0100ccd <__panic>
        *ptep = pa | PTE_P | perm;
c01042ee:	8b 45 18             	mov    0x18(%ebp),%eax
c01042f1:	8b 55 14             	mov    0x14(%ebp),%edx
c01042f4:	09 d0                	or     %edx,%eax
c01042f6:	83 c8 01             	or     $0x1,%eax
c01042f9:	89 c2                	mov    %eax,%edx
c01042fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042fe:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104300:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104304:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010430b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104316:	75 8f                	jne    c01042a7 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104318:	c9                   	leave  
c0104319:	c3                   	ret    

c010431a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010431a:	55                   	push   %ebp
c010431b:	89 e5                	mov    %esp,%ebp
c010431d:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104320:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104327:	e8 22 fa ff ff       	call   c0103d4e <alloc_pages>
c010432c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010432f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104333:	75 1c                	jne    c0104351 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104335:	c7 44 24 08 c3 6b 10 	movl   $0xc0106bc3,0x8(%esp)
c010433c:	c0 
c010433d:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104344:	00 
c0104345:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c010434c:	e8 7c c9 ff ff       	call   c0100ccd <__panic>
    }
    return page2kva(p);
c0104351:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104354:	89 04 24             	mov    %eax,(%esp)
c0104357:	e8 5b f7 ff ff       	call   c0103ab7 <page2kva>
}
c010435c:	c9                   	leave  
c010435d:	c3                   	ret    

c010435e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010435e:	55                   	push   %ebp
c010435f:	89 e5                	mov    %esp,%ebp
c0104361:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104364:	e8 93 f9 ff ff       	call   c0103cfc <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104369:	e8 75 fa ff ff       	call   c0103de3 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010436e:	e8 66 04 00 00       	call   c01047d9 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104373:	e8 a2 ff ff ff       	call   c010431a <boot_alloc_page>
c0104378:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c010437d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104382:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104389:	00 
c010438a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104391:	00 
c0104392:	89 04 24             	mov    %eax,(%esp)
c0104395:	e8 a8 1a 00 00       	call   c0105e42 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010439a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010439f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043a2:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01043a9:	77 23                	ja     c01043ce <pmm_init+0x70>
c01043ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043b2:	c7 44 24 08 58 6b 10 	movl   $0xc0106b58,0x8(%esp)
c01043b9:	c0 
c01043ba:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01043c1:	00 
c01043c2:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c01043c9:	e8 ff c8 ff ff       	call   c0100ccd <__panic>
c01043ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043d1:	05 00 00 00 40       	add    $0x40000000,%eax
c01043d6:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c01043db:	e8 17 04 00 00       	call   c01047f7 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01043e0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043e5:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01043eb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043f3:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01043fa:	77 23                	ja     c010441f <pmm_init+0xc1>
c01043fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104403:	c7 44 24 08 58 6b 10 	movl   $0xc0106b58,0x8(%esp)
c010440a:	c0 
c010440b:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104412:	00 
c0104413:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c010441a:	e8 ae c8 ff ff       	call   c0100ccd <__panic>
c010441f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104422:	05 00 00 00 40       	add    $0x40000000,%eax
c0104427:	83 c8 03             	or     $0x3,%eax
c010442a:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010442c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104431:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104438:	00 
c0104439:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104440:	00 
c0104441:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104448:	38 
c0104449:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104450:	c0 
c0104451:	89 04 24             	mov    %eax,(%esp)
c0104454:	e8 b4 fd ff ff       	call   c010420d <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104459:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010445e:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104464:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010446a:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010446c:	e8 63 fd ff ff       	call   c01041d4 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104471:	e8 97 f7 ff ff       	call   c0103c0d <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104476:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010447b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104481:	e8 0c 0a 00 00       	call   c0104e92 <check_boot_pgdir>

    print_pgdir();
c0104486:	e8 99 0e 00 00       	call   c0105324 <print_pgdir>

}
c010448b:	c9                   	leave  
c010448c:	c3                   	ret    

c010448d <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010448d:	55                   	push   %ebp
c010448e:	89 e5                	mov    %esp,%ebp
c0104490:	83 ec 38             	sub    $0x38,%esp
    }
    return NULL;          // (8) return page table entry
#endif


    pde_t* pdep = pgdir + PDX(la);
c0104493:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104496:	c1 e8 16             	shr    $0x16,%eax
c0104499:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01044a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a3:	01 d0                	add    %edx,%eax
c01044a5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (!(*pdep & PTE_P)) 	{
c01044a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ab:	8b 00                	mov    (%eax),%eax
c01044ad:	83 e0 01             	and    $0x1,%eax
c01044b0:	85 c0                	test   %eax,%eax
c01044b2:	0f 85 af 00 00 00    	jne    c0104567 <get_pte+0xda>
		struct Page* page;
		if (!create || (page = alloc_page()) == NULL)
c01044b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01044bc:	74 15                	je     c01044d3 <get_pte+0x46>
c01044be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044c5:	e8 84 f8 ff ff       	call   c0103d4e <alloc_pages>
c01044ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01044d1:	75 0a                	jne    c01044dd <get_pte+0x50>
			return NULL;
c01044d3:	b8 00 00 00 00       	mov    $0x0,%eax
c01044d8:	e9 e6 00 00 00       	jmp    c01045c3 <get_pte+0x136>

		set_page_ref(page, 1);
c01044dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01044e4:	00 
c01044e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044e8:	89 04 24             	mov    %eax,(%esp)
c01044eb:	e8 63 f6 ff ff       	call   c0103b53 <set_page_ref>
		uintptr_t pa = page2pa(page);
c01044f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044f3:	89 04 24             	mov    %eax,(%esp)
c01044f6:	e8 57 f5 ff ff       	call   c0103a52 <page2pa>
c01044fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pa), 0, PGSIZE);
c01044fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104501:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104504:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104507:	c1 e8 0c             	shr    $0xc,%eax
c010450a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010450d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104512:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104515:	72 23                	jb     c010453a <get_pte+0xad>
c0104517:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010451a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010451e:	c7 44 24 08 b4 6a 10 	movl   $0xc0106ab4,0x8(%esp)
c0104525:	c0 
c0104526:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
c010452d:	00 
c010452e:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104535:	e8 93 c7 ff ff       	call   c0100ccd <__panic>
c010453a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010453d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104542:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104549:	00 
c010454a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104551:	00 
c0104552:	89 04 24             	mov    %eax,(%esp)
c0104555:	e8 e8 18 00 00       	call   c0105e42 <memset>
		*pdep= pa | PTE_P | PTE_W | PTE_U;
c010455a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010455d:	83 c8 07             	or     $0x7,%eax
c0104560:	89 c2                	mov    %eax,%edx
c0104562:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104565:	89 10                	mov    %edx,(%eax)
	}
	return (pte_t*)KADDR(PDE_ADDR(*pdep)) + PTX(la);
c0104567:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010456a:	8b 00                	mov    (%eax),%eax
c010456c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104571:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104574:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104577:	c1 e8 0c             	shr    $0xc,%eax
c010457a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010457d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104582:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104585:	72 23                	jb     c01045aa <get_pte+0x11d>
c0104587:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010458a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010458e:	c7 44 24 08 b4 6a 10 	movl   $0xc0106ab4,0x8(%esp)
c0104595:	c0 
c0104596:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
c010459d:	00 
c010459e:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c01045a5:	e8 23 c7 ff ff       	call   c0100ccd <__panic>
c01045aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045ad:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01045b2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01045b5:	c1 ea 0c             	shr    $0xc,%edx
c01045b8:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01045be:	c1 e2 02             	shl    $0x2,%edx
c01045c1:	01 d0                	add    %edx,%eax
}
c01045c3:	c9                   	leave  
c01045c4:	c3                   	ret    

c01045c5 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01045c5:	55                   	push   %ebp
c01045c6:	89 e5                	mov    %esp,%ebp
c01045c8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01045cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01045d2:	00 
c01045d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045da:	8b 45 08             	mov    0x8(%ebp),%eax
c01045dd:	89 04 24             	mov    %eax,(%esp)
c01045e0:	e8 a8 fe ff ff       	call   c010448d <get_pte>
c01045e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01045e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01045ec:	74 08                	je     c01045f6 <get_page+0x31>
        *ptep_store = ptep;
c01045ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01045f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01045f4:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01045f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045fa:	74 1b                	je     c0104617 <get_page+0x52>
c01045fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ff:	8b 00                	mov    (%eax),%eax
c0104601:	83 e0 01             	and    $0x1,%eax
c0104604:	85 c0                	test   %eax,%eax
c0104606:	74 0f                	je     c0104617 <get_page+0x52>
        return pa2page(*ptep);
c0104608:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010460b:	8b 00                	mov    (%eax),%eax
c010460d:	89 04 24             	mov    %eax,(%esp)
c0104610:	e8 53 f4 ff ff       	call   c0103a68 <pa2page>
c0104615:	eb 05                	jmp    c010461c <get_page+0x57>
    }
    return NULL;
c0104617:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010461c:	c9                   	leave  
c010461d:	c3                   	ret    

c010461e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010461e:	55                   	push   %ebp
c010461f:	89 e5                	mov    %esp,%ebp
c0104621:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

    if (*ptep & PTE_P) {
c0104624:	8b 45 10             	mov    0x10(%ebp),%eax
c0104627:	8b 00                	mov    (%eax),%eax
c0104629:	83 e0 01             	and    $0x1,%eax
c010462c:	85 c0                	test   %eax,%eax
c010462e:	74 4d                	je     c010467d <page_remove_pte+0x5f>
        struct Page* page = pte2page(*ptep);
c0104630:	8b 45 10             	mov    0x10(%ebp),%eax
c0104633:	8b 00                	mov    (%eax),%eax
c0104635:	89 04 24             	mov    %eax,(%esp)
c0104638:	e8 ce f4 ff ff       	call   c0103b0b <pte2page>
c010463d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0)
c0104640:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104643:	89 04 24             	mov    %eax,(%esp)
c0104646:	e8 2c f5 ff ff       	call   c0103b77 <page_ref_dec>
c010464b:	85 c0                	test   %eax,%eax
c010464d:	75 13                	jne    c0104662 <page_remove_pte+0x44>
            free_page(page);
c010464f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104656:	00 
c0104657:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010465a:	89 04 24             	mov    %eax,(%esp)
c010465d:	e8 24 f7 ff ff       	call   c0103d86 <free_pages>

        *ptep = 0;
c0104662:	8b 45 10             	mov    0x10(%ebp),%eax
c0104665:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c010466b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010466e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104672:	8b 45 08             	mov    0x8(%ebp),%eax
c0104675:	89 04 24             	mov    %eax,(%esp)
c0104678:	e8 ff 00 00 00       	call   c010477c <tlb_invalidate>
    }
}
c010467d:	c9                   	leave  
c010467e:	c3                   	ret    

c010467f <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010467f:	55                   	push   %ebp
c0104680:	89 e5                	mov    %esp,%ebp
c0104682:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104685:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010468c:	00 
c010468d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104690:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104694:	8b 45 08             	mov    0x8(%ebp),%eax
c0104697:	89 04 24             	mov    %eax,(%esp)
c010469a:	e8 ee fd ff ff       	call   c010448d <get_pte>
c010469f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01046a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046a6:	74 19                	je     c01046c1 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01046a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ab:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b9:	89 04 24             	mov    %eax,(%esp)
c01046bc:	e8 5d ff ff ff       	call   c010461e <page_remove_pte>
    }
}
c01046c1:	c9                   	leave  
c01046c2:	c3                   	ret    

c01046c3 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01046c3:	55                   	push   %ebp
c01046c4:	89 e5                	mov    %esp,%ebp
c01046c6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01046c9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01046d0:	00 
c01046d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01046d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01046db:	89 04 24             	mov    %eax,(%esp)
c01046de:	e8 aa fd ff ff       	call   c010448d <get_pte>
c01046e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01046e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046ea:	75 0a                	jne    c01046f6 <page_insert+0x33>
        return -E_NO_MEM;
c01046ec:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01046f1:	e9 84 00 00 00       	jmp    c010477a <page_insert+0xb7>
    }
    page_ref_inc(page);
c01046f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046f9:	89 04 24             	mov    %eax,(%esp)
c01046fc:	e8 5f f4 ff ff       	call   c0103b60 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104701:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104704:	8b 00                	mov    (%eax),%eax
c0104706:	83 e0 01             	and    $0x1,%eax
c0104709:	85 c0                	test   %eax,%eax
c010470b:	74 3e                	je     c010474b <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010470d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104710:	8b 00                	mov    (%eax),%eax
c0104712:	89 04 24             	mov    %eax,(%esp)
c0104715:	e8 f1 f3 ff ff       	call   c0103b0b <pte2page>
c010471a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010471d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104720:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104723:	75 0d                	jne    c0104732 <page_insert+0x6f>
            page_ref_dec(page);
c0104725:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104728:	89 04 24             	mov    %eax,(%esp)
c010472b:	e8 47 f4 ff ff       	call   c0103b77 <page_ref_dec>
c0104730:	eb 19                	jmp    c010474b <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104732:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104735:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104739:	8b 45 10             	mov    0x10(%ebp),%eax
c010473c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104740:	8b 45 08             	mov    0x8(%ebp),%eax
c0104743:	89 04 24             	mov    %eax,(%esp)
c0104746:	e8 d3 fe ff ff       	call   c010461e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010474b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010474e:	89 04 24             	mov    %eax,(%esp)
c0104751:	e8 fc f2 ff ff       	call   c0103a52 <page2pa>
c0104756:	0b 45 14             	or     0x14(%ebp),%eax
c0104759:	83 c8 01             	or     $0x1,%eax
c010475c:	89 c2                	mov    %eax,%edx
c010475e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104761:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104763:	8b 45 10             	mov    0x10(%ebp),%eax
c0104766:	89 44 24 04          	mov    %eax,0x4(%esp)
c010476a:	8b 45 08             	mov    0x8(%ebp),%eax
c010476d:	89 04 24             	mov    %eax,(%esp)
c0104770:	e8 07 00 00 00       	call   c010477c <tlb_invalidate>
    return 0;
c0104775:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010477a:	c9                   	leave  
c010477b:	c3                   	ret    

c010477c <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010477c:	55                   	push   %ebp
c010477d:	89 e5                	mov    %esp,%ebp
c010477f:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104782:	0f 20 d8             	mov    %cr3,%eax
c0104785:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104788:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c010478b:	89 c2                	mov    %eax,%edx
c010478d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104790:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104793:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010479a:	77 23                	ja     c01047bf <tlb_invalidate+0x43>
c010479c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010479f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047a3:	c7 44 24 08 58 6b 10 	movl   $0xc0106b58,0x8(%esp)
c01047aa:	c0 
c01047ab:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c01047b2:	00 
c01047b3:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c01047ba:	e8 0e c5 ff ff       	call   c0100ccd <__panic>
c01047bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047c2:	05 00 00 00 40       	add    $0x40000000,%eax
c01047c7:	39 c2                	cmp    %eax,%edx
c01047c9:	75 0c                	jne    c01047d7 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01047cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01047d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047d4:	0f 01 38             	invlpg (%eax)
    }
}
c01047d7:	c9                   	leave  
c01047d8:	c3                   	ret    

c01047d9 <check_alloc_page>:

static void
check_alloc_page(void) {
c01047d9:	55                   	push   %ebp
c01047da:	89 e5                	mov    %esp,%ebp
c01047dc:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01047df:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01047e4:	8b 40 18             	mov    0x18(%eax),%eax
c01047e7:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01047e9:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c01047f0:	e8 47 bb ff ff       	call   c010033c <cprintf>
}
c01047f5:	c9                   	leave  
c01047f6:	c3                   	ret    

c01047f7 <check_pgdir>:

static void
check_pgdir(void) {
c01047f7:	55                   	push   %ebp
c01047f8:	89 e5                	mov    %esp,%ebp
c01047fa:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01047fd:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104802:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104807:	76 24                	jbe    c010482d <check_pgdir+0x36>
c0104809:	c7 44 24 0c fb 6b 10 	movl   $0xc0106bfb,0xc(%esp)
c0104810:	c0 
c0104811:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104818:	c0 
c0104819:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104820:	00 
c0104821:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104828:	e8 a0 c4 ff ff       	call   c0100ccd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010482d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104832:	85 c0                	test   %eax,%eax
c0104834:	74 0e                	je     c0104844 <check_pgdir+0x4d>
c0104836:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010483b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104840:	85 c0                	test   %eax,%eax
c0104842:	74 24                	je     c0104868 <check_pgdir+0x71>
c0104844:	c7 44 24 0c 18 6c 10 	movl   $0xc0106c18,0xc(%esp)
c010484b:	c0 
c010484c:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104853:	c0 
c0104854:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c010485b:	00 
c010485c:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104863:	e8 65 c4 ff ff       	call   c0100ccd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104868:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010486d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104874:	00 
c0104875:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010487c:	00 
c010487d:	89 04 24             	mov    %eax,(%esp)
c0104880:	e8 40 fd ff ff       	call   c01045c5 <get_page>
c0104885:	85 c0                	test   %eax,%eax
c0104887:	74 24                	je     c01048ad <check_pgdir+0xb6>
c0104889:	c7 44 24 0c 50 6c 10 	movl   $0xc0106c50,0xc(%esp)
c0104890:	c0 
c0104891:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104898:	c0 
c0104899:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c01048a0:	00 
c01048a1:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c01048a8:	e8 20 c4 ff ff       	call   c0100ccd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01048ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048b4:	e8 95 f4 ff ff       	call   c0103d4e <alloc_pages>
c01048b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01048bc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01048c8:	00 
c01048c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048d0:	00 
c01048d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01048d4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048d8:	89 04 24             	mov    %eax,(%esp)
c01048db:	e8 e3 fd ff ff       	call   c01046c3 <page_insert>
c01048e0:	85 c0                	test   %eax,%eax
c01048e2:	74 24                	je     c0104908 <check_pgdir+0x111>
c01048e4:	c7 44 24 0c 78 6c 10 	movl   $0xc0106c78,0xc(%esp)
c01048eb:	c0 
c01048ec:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c01048f3:	c0 
c01048f4:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c01048fb:	00 
c01048fc:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104903:	e8 c5 c3 ff ff       	call   c0100ccd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104908:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010490d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104914:	00 
c0104915:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010491c:	00 
c010491d:	89 04 24             	mov    %eax,(%esp)
c0104920:	e8 68 fb ff ff       	call   c010448d <get_pte>
c0104925:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104928:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010492c:	75 24                	jne    c0104952 <check_pgdir+0x15b>
c010492e:	c7 44 24 0c a4 6c 10 	movl   $0xc0106ca4,0xc(%esp)
c0104935:	c0 
c0104936:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c010493d:	c0 
c010493e:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104945:	00 
c0104946:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c010494d:	e8 7b c3 ff ff       	call   c0100ccd <__panic>
    assert(pa2page(*ptep) == p1);
c0104952:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104955:	8b 00                	mov    (%eax),%eax
c0104957:	89 04 24             	mov    %eax,(%esp)
c010495a:	e8 09 f1 ff ff       	call   c0103a68 <pa2page>
c010495f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104962:	74 24                	je     c0104988 <check_pgdir+0x191>
c0104964:	c7 44 24 0c d1 6c 10 	movl   $0xc0106cd1,0xc(%esp)
c010496b:	c0 
c010496c:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104973:	c0 
c0104974:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c010497b:	00 
c010497c:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104983:	e8 45 c3 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p1) == 1);
c0104988:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010498b:	89 04 24             	mov    %eax,(%esp)
c010498e:	e8 b6 f1 ff ff       	call   c0103b49 <page_ref>
c0104993:	83 f8 01             	cmp    $0x1,%eax
c0104996:	74 24                	je     c01049bc <check_pgdir+0x1c5>
c0104998:	c7 44 24 0c e6 6c 10 	movl   $0xc0106ce6,0xc(%esp)
c010499f:	c0 
c01049a0:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c01049a7:	c0 
c01049a8:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c01049af:	00 
c01049b0:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c01049b7:	e8 11 c3 ff ff       	call   c0100ccd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01049bc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049c1:	8b 00                	mov    (%eax),%eax
c01049c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01049c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01049cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049ce:	c1 e8 0c             	shr    $0xc,%eax
c01049d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01049d4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01049d9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01049dc:	72 23                	jb     c0104a01 <check_pgdir+0x20a>
c01049de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01049e5:	c7 44 24 08 b4 6a 10 	movl   $0xc0106ab4,0x8(%esp)
c01049ec:	c0 
c01049ed:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c01049f4:	00 
c01049f5:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c01049fc:	e8 cc c2 ff ff       	call   c0100ccd <__panic>
c0104a01:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a04:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104a09:	83 c0 04             	add    $0x4,%eax
c0104a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104a0f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a14:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a1b:	00 
c0104a1c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a23:	00 
c0104a24:	89 04 24             	mov    %eax,(%esp)
c0104a27:	e8 61 fa ff ff       	call   c010448d <get_pte>
c0104a2c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104a2f:	74 24                	je     c0104a55 <check_pgdir+0x25e>
c0104a31:	c7 44 24 0c f8 6c 10 	movl   $0xc0106cf8,0xc(%esp)
c0104a38:	c0 
c0104a39:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104a40:	c0 
c0104a41:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104a48:	00 
c0104a49:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104a50:	e8 78 c2 ff ff       	call   c0100ccd <__panic>

    p2 = alloc_page();
c0104a55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a5c:	e8 ed f2 ff ff       	call   c0103d4e <alloc_pages>
c0104a61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104a64:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a69:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a70:	00 
c0104a71:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a78:	00 
c0104a79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a7c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a80:	89 04 24             	mov    %eax,(%esp)
c0104a83:	e8 3b fc ff ff       	call   c01046c3 <page_insert>
c0104a88:	85 c0                	test   %eax,%eax
c0104a8a:	74 24                	je     c0104ab0 <check_pgdir+0x2b9>
c0104a8c:	c7 44 24 0c 20 6d 10 	movl   $0xc0106d20,0xc(%esp)
c0104a93:	c0 
c0104a94:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104a9b:	c0 
c0104a9c:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104aa3:	00 
c0104aa4:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104aab:	e8 1d c2 ff ff       	call   c0100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ab0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ab5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104abc:	00 
c0104abd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ac4:	00 
c0104ac5:	89 04 24             	mov    %eax,(%esp)
c0104ac8:	e8 c0 f9 ff ff       	call   c010448d <get_pte>
c0104acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ad0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ad4:	75 24                	jne    c0104afa <check_pgdir+0x303>
c0104ad6:	c7 44 24 0c 58 6d 10 	movl   $0xc0106d58,0xc(%esp)
c0104add:	c0 
c0104ade:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104ae5:	c0 
c0104ae6:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104aed:	00 
c0104aee:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104af5:	e8 d3 c1 ff ff       	call   c0100ccd <__panic>
    assert(*ptep & PTE_U);
c0104afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104afd:	8b 00                	mov    (%eax),%eax
c0104aff:	83 e0 04             	and    $0x4,%eax
c0104b02:	85 c0                	test   %eax,%eax
c0104b04:	75 24                	jne    c0104b2a <check_pgdir+0x333>
c0104b06:	c7 44 24 0c 88 6d 10 	movl   $0xc0106d88,0xc(%esp)
c0104b0d:	c0 
c0104b0e:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104b15:	c0 
c0104b16:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104b1d:	00 
c0104b1e:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104b25:	e8 a3 c1 ff ff       	call   c0100ccd <__panic>
    assert(*ptep & PTE_W);
c0104b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b2d:	8b 00                	mov    (%eax),%eax
c0104b2f:	83 e0 02             	and    $0x2,%eax
c0104b32:	85 c0                	test   %eax,%eax
c0104b34:	75 24                	jne    c0104b5a <check_pgdir+0x363>
c0104b36:	c7 44 24 0c 96 6d 10 	movl   $0xc0106d96,0xc(%esp)
c0104b3d:	c0 
c0104b3e:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104b45:	c0 
c0104b46:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104b4d:	00 
c0104b4e:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104b55:	e8 73 c1 ff ff       	call   c0100ccd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104b5a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b5f:	8b 00                	mov    (%eax),%eax
c0104b61:	83 e0 04             	and    $0x4,%eax
c0104b64:	85 c0                	test   %eax,%eax
c0104b66:	75 24                	jne    c0104b8c <check_pgdir+0x395>
c0104b68:	c7 44 24 0c a4 6d 10 	movl   $0xc0106da4,0xc(%esp)
c0104b6f:	c0 
c0104b70:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104b77:	c0 
c0104b78:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104b7f:	00 
c0104b80:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104b87:	e8 41 c1 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 1);
c0104b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b8f:	89 04 24             	mov    %eax,(%esp)
c0104b92:	e8 b2 ef ff ff       	call   c0103b49 <page_ref>
c0104b97:	83 f8 01             	cmp    $0x1,%eax
c0104b9a:	74 24                	je     c0104bc0 <check_pgdir+0x3c9>
c0104b9c:	c7 44 24 0c ba 6d 10 	movl   $0xc0106dba,0xc(%esp)
c0104ba3:	c0 
c0104ba4:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104bab:	c0 
c0104bac:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104bb3:	00 
c0104bb4:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104bbb:	e8 0d c1 ff ff       	call   c0100ccd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104bc0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104bc5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104bcc:	00 
c0104bcd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104bd4:	00 
c0104bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104bd8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bdc:	89 04 24             	mov    %eax,(%esp)
c0104bdf:	e8 df fa ff ff       	call   c01046c3 <page_insert>
c0104be4:	85 c0                	test   %eax,%eax
c0104be6:	74 24                	je     c0104c0c <check_pgdir+0x415>
c0104be8:	c7 44 24 0c cc 6d 10 	movl   $0xc0106dcc,0xc(%esp)
c0104bef:	c0 
c0104bf0:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104bf7:	c0 
c0104bf8:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104bff:	00 
c0104c00:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104c07:	e8 c1 c0 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p1) == 2);
c0104c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c0f:	89 04 24             	mov    %eax,(%esp)
c0104c12:	e8 32 ef ff ff       	call   c0103b49 <page_ref>
c0104c17:	83 f8 02             	cmp    $0x2,%eax
c0104c1a:	74 24                	je     c0104c40 <check_pgdir+0x449>
c0104c1c:	c7 44 24 0c f8 6d 10 	movl   $0xc0106df8,0xc(%esp)
c0104c23:	c0 
c0104c24:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104c2b:	c0 
c0104c2c:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104c33:	00 
c0104c34:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104c3b:	e8 8d c0 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 0);
c0104c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c43:	89 04 24             	mov    %eax,(%esp)
c0104c46:	e8 fe ee ff ff       	call   c0103b49 <page_ref>
c0104c4b:	85 c0                	test   %eax,%eax
c0104c4d:	74 24                	je     c0104c73 <check_pgdir+0x47c>
c0104c4f:	c7 44 24 0c 0a 6e 10 	movl   $0xc0106e0a,0xc(%esp)
c0104c56:	c0 
c0104c57:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104c5e:	c0 
c0104c5f:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104c66:	00 
c0104c67:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104c6e:	e8 5a c0 ff ff       	call   c0100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c73:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c78:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c7f:	00 
c0104c80:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c87:	00 
c0104c88:	89 04 24             	mov    %eax,(%esp)
c0104c8b:	e8 fd f7 ff ff       	call   c010448d <get_pte>
c0104c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c97:	75 24                	jne    c0104cbd <check_pgdir+0x4c6>
c0104c99:	c7 44 24 0c 58 6d 10 	movl   $0xc0106d58,0xc(%esp)
c0104ca0:	c0 
c0104ca1:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104ca8:	c0 
c0104ca9:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104cb0:	00 
c0104cb1:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104cb8:	e8 10 c0 ff ff       	call   c0100ccd <__panic>
    assert(pa2page(*ptep) == p1);
c0104cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cc0:	8b 00                	mov    (%eax),%eax
c0104cc2:	89 04 24             	mov    %eax,(%esp)
c0104cc5:	e8 9e ed ff ff       	call   c0103a68 <pa2page>
c0104cca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ccd:	74 24                	je     c0104cf3 <check_pgdir+0x4fc>
c0104ccf:	c7 44 24 0c d1 6c 10 	movl   $0xc0106cd1,0xc(%esp)
c0104cd6:	c0 
c0104cd7:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104cde:	c0 
c0104cdf:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104ce6:	00 
c0104ce7:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104cee:	e8 da bf ff ff       	call   c0100ccd <__panic>
    assert((*ptep & PTE_U) == 0);
c0104cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cf6:	8b 00                	mov    (%eax),%eax
c0104cf8:	83 e0 04             	and    $0x4,%eax
c0104cfb:	85 c0                	test   %eax,%eax
c0104cfd:	74 24                	je     c0104d23 <check_pgdir+0x52c>
c0104cff:	c7 44 24 0c 1c 6e 10 	movl   $0xc0106e1c,0xc(%esp)
c0104d06:	c0 
c0104d07:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104d0e:	c0 
c0104d0f:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104d16:	00 
c0104d17:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104d1e:	e8 aa bf ff ff       	call   c0100ccd <__panic>

    page_remove(boot_pgdir, 0x0);
c0104d23:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d2f:	00 
c0104d30:	89 04 24             	mov    %eax,(%esp)
c0104d33:	e8 47 f9 ff ff       	call   c010467f <page_remove>
    assert(page_ref(p1) == 1);
c0104d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d3b:	89 04 24             	mov    %eax,(%esp)
c0104d3e:	e8 06 ee ff ff       	call   c0103b49 <page_ref>
c0104d43:	83 f8 01             	cmp    $0x1,%eax
c0104d46:	74 24                	je     c0104d6c <check_pgdir+0x575>
c0104d48:	c7 44 24 0c e6 6c 10 	movl   $0xc0106ce6,0xc(%esp)
c0104d4f:	c0 
c0104d50:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104d57:	c0 
c0104d58:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104d5f:	00 
c0104d60:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104d67:	e8 61 bf ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 0);
c0104d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d6f:	89 04 24             	mov    %eax,(%esp)
c0104d72:	e8 d2 ed ff ff       	call   c0103b49 <page_ref>
c0104d77:	85 c0                	test   %eax,%eax
c0104d79:	74 24                	je     c0104d9f <check_pgdir+0x5a8>
c0104d7b:	c7 44 24 0c 0a 6e 10 	movl   $0xc0106e0a,0xc(%esp)
c0104d82:	c0 
c0104d83:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104d8a:	c0 
c0104d8b:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104d92:	00 
c0104d93:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104d9a:	e8 2e bf ff ff       	call   c0100ccd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d9f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104da4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104dab:	00 
c0104dac:	89 04 24             	mov    %eax,(%esp)
c0104daf:	e8 cb f8 ff ff       	call   c010467f <page_remove>
    assert(page_ref(p1) == 0);
c0104db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104db7:	89 04 24             	mov    %eax,(%esp)
c0104dba:	e8 8a ed ff ff       	call   c0103b49 <page_ref>
c0104dbf:	85 c0                	test   %eax,%eax
c0104dc1:	74 24                	je     c0104de7 <check_pgdir+0x5f0>
c0104dc3:	c7 44 24 0c 31 6e 10 	movl   $0xc0106e31,0xc(%esp)
c0104dca:	c0 
c0104dcb:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104dd2:	c0 
c0104dd3:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104dda:	00 
c0104ddb:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104de2:	e8 e6 be ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 0);
c0104de7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dea:	89 04 24             	mov    %eax,(%esp)
c0104ded:	e8 57 ed ff ff       	call   c0103b49 <page_ref>
c0104df2:	85 c0                	test   %eax,%eax
c0104df4:	74 24                	je     c0104e1a <check_pgdir+0x623>
c0104df6:	c7 44 24 0c 0a 6e 10 	movl   $0xc0106e0a,0xc(%esp)
c0104dfd:	c0 
c0104dfe:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104e05:	c0 
c0104e06:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104e0d:	00 
c0104e0e:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104e15:	e8 b3 be ff ff       	call   c0100ccd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104e1a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e1f:	8b 00                	mov    (%eax),%eax
c0104e21:	89 04 24             	mov    %eax,(%esp)
c0104e24:	e8 3f ec ff ff       	call   c0103a68 <pa2page>
c0104e29:	89 04 24             	mov    %eax,(%esp)
c0104e2c:	e8 18 ed ff ff       	call   c0103b49 <page_ref>
c0104e31:	83 f8 01             	cmp    $0x1,%eax
c0104e34:	74 24                	je     c0104e5a <check_pgdir+0x663>
c0104e36:	c7 44 24 0c 44 6e 10 	movl   $0xc0106e44,0xc(%esp)
c0104e3d:	c0 
c0104e3e:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104e45:	c0 
c0104e46:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0104e4d:	00 
c0104e4e:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104e55:	e8 73 be ff ff       	call   c0100ccd <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104e5a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e5f:	8b 00                	mov    (%eax),%eax
c0104e61:	89 04 24             	mov    %eax,(%esp)
c0104e64:	e8 ff eb ff ff       	call   c0103a68 <pa2page>
c0104e69:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e70:	00 
c0104e71:	89 04 24             	mov    %eax,(%esp)
c0104e74:	e8 0d ef ff ff       	call   c0103d86 <free_pages>
    boot_pgdir[0] = 0;
c0104e79:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e84:	c7 04 24 6a 6e 10 c0 	movl   $0xc0106e6a,(%esp)
c0104e8b:	e8 ac b4 ff ff       	call   c010033c <cprintf>
}
c0104e90:	c9                   	leave  
c0104e91:	c3                   	ret    

c0104e92 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e92:	55                   	push   %ebp
c0104e93:	89 e5                	mov    %esp,%ebp
c0104e95:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e9f:	e9 ca 00 00 00       	jmp    c0104f6e <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ead:	c1 e8 0c             	shr    $0xc,%eax
c0104eb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104eb3:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104eb8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104ebb:	72 23                	jb     c0104ee0 <check_boot_pgdir+0x4e>
c0104ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ec0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ec4:	c7 44 24 08 b4 6a 10 	movl   $0xc0106ab4,0x8(%esp)
c0104ecb:	c0 
c0104ecc:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0104ed3:	00 
c0104ed4:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104edb:	e8 ed bd ff ff       	call   c0100ccd <__panic>
c0104ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ee3:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104ee8:	89 c2                	mov    %eax,%edx
c0104eea:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104eef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ef6:	00 
c0104ef7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104efb:	89 04 24             	mov    %eax,(%esp)
c0104efe:	e8 8a f5 ff ff       	call   c010448d <get_pte>
c0104f03:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104f06:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104f0a:	75 24                	jne    c0104f30 <check_boot_pgdir+0x9e>
c0104f0c:	c7 44 24 0c 84 6e 10 	movl   $0xc0106e84,0xc(%esp)
c0104f13:	c0 
c0104f14:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104f1b:	c0 
c0104f1c:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0104f23:	00 
c0104f24:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104f2b:	e8 9d bd ff ff       	call   c0100ccd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104f30:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f33:	8b 00                	mov    (%eax),%eax
c0104f35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f3a:	89 c2                	mov    %eax,%edx
c0104f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f3f:	39 c2                	cmp    %eax,%edx
c0104f41:	74 24                	je     c0104f67 <check_boot_pgdir+0xd5>
c0104f43:	c7 44 24 0c c1 6e 10 	movl   $0xc0106ec1,0xc(%esp)
c0104f4a:	c0 
c0104f4b:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104f52:	c0 
c0104f53:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0104f5a:	00 
c0104f5b:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104f62:	e8 66 bd ff ff       	call   c0100ccd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104f67:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f71:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104f76:	39 c2                	cmp    %eax,%edx
c0104f78:	0f 82 26 ff ff ff    	jb     c0104ea4 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f7e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f83:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f88:	8b 00                	mov    (%eax),%eax
c0104f8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f8f:	89 c2                	mov    %eax,%edx
c0104f91:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f99:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104fa0:	77 23                	ja     c0104fc5 <check_boot_pgdir+0x133>
c0104fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fa5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104fa9:	c7 44 24 08 58 6b 10 	movl   $0xc0106b58,0x8(%esp)
c0104fb0:	c0 
c0104fb1:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0104fb8:	00 
c0104fb9:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104fc0:	e8 08 bd ff ff       	call   c0100ccd <__panic>
c0104fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fc8:	05 00 00 00 40       	add    $0x40000000,%eax
c0104fcd:	39 c2                	cmp    %eax,%edx
c0104fcf:	74 24                	je     c0104ff5 <check_boot_pgdir+0x163>
c0104fd1:	c7 44 24 0c d8 6e 10 	movl   $0xc0106ed8,0xc(%esp)
c0104fd8:	c0 
c0104fd9:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0104fe0:	c0 
c0104fe1:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0104fe8:	00 
c0104fe9:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0104ff0:	e8 d8 bc ff ff       	call   c0100ccd <__panic>

    assert(boot_pgdir[0] == 0);
c0104ff5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ffa:	8b 00                	mov    (%eax),%eax
c0104ffc:	85 c0                	test   %eax,%eax
c0104ffe:	74 24                	je     c0105024 <check_boot_pgdir+0x192>
c0105000:	c7 44 24 0c 0c 6f 10 	movl   $0xc0106f0c,0xc(%esp)
c0105007:	c0 
c0105008:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c010500f:	c0 
c0105010:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105017:	00 
c0105018:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c010501f:	e8 a9 bc ff ff       	call   c0100ccd <__panic>

    struct Page *p;
    p = alloc_page();
c0105024:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010502b:	e8 1e ed ff ff       	call   c0103d4e <alloc_pages>
c0105030:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105033:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105038:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010503f:	00 
c0105040:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105047:	00 
c0105048:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010504b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010504f:	89 04 24             	mov    %eax,(%esp)
c0105052:	e8 6c f6 ff ff       	call   c01046c3 <page_insert>
c0105057:	85 c0                	test   %eax,%eax
c0105059:	74 24                	je     c010507f <check_boot_pgdir+0x1ed>
c010505b:	c7 44 24 0c 20 6f 10 	movl   $0xc0106f20,0xc(%esp)
c0105062:	c0 
c0105063:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c010506a:	c0 
c010506b:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105072:	00 
c0105073:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c010507a:	e8 4e bc ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p) == 1);
c010507f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105082:	89 04 24             	mov    %eax,(%esp)
c0105085:	e8 bf ea ff ff       	call   c0103b49 <page_ref>
c010508a:	83 f8 01             	cmp    $0x1,%eax
c010508d:	74 24                	je     c01050b3 <check_boot_pgdir+0x221>
c010508f:	c7 44 24 0c 4e 6f 10 	movl   $0xc0106f4e,0xc(%esp)
c0105096:	c0 
c0105097:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c010509e:	c0 
c010509f:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c01050a6:	00 
c01050a7:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c01050ae:	e8 1a bc ff ff       	call   c0100ccd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01050b3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050b8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01050bf:	00 
c01050c0:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01050c7:	00 
c01050c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01050cb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050cf:	89 04 24             	mov    %eax,(%esp)
c01050d2:	e8 ec f5 ff ff       	call   c01046c3 <page_insert>
c01050d7:	85 c0                	test   %eax,%eax
c01050d9:	74 24                	je     c01050ff <check_boot_pgdir+0x26d>
c01050db:	c7 44 24 0c 60 6f 10 	movl   $0xc0106f60,0xc(%esp)
c01050e2:	c0 
c01050e3:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c01050ea:	c0 
c01050eb:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c01050f2:	00 
c01050f3:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c01050fa:	e8 ce bb ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p) == 2);
c01050ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105102:	89 04 24             	mov    %eax,(%esp)
c0105105:	e8 3f ea ff ff       	call   c0103b49 <page_ref>
c010510a:	83 f8 02             	cmp    $0x2,%eax
c010510d:	74 24                	je     c0105133 <check_boot_pgdir+0x2a1>
c010510f:	c7 44 24 0c 97 6f 10 	movl   $0xc0106f97,0xc(%esp)
c0105116:	c0 
c0105117:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c010511e:	c0 
c010511f:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105126:	00 
c0105127:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c010512e:	e8 9a bb ff ff       	call   c0100ccd <__panic>

    const char *str = "ucore: Hello world!!";
c0105133:	c7 45 dc a8 6f 10 c0 	movl   $0xc0106fa8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c010513a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010513d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105141:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105148:	e8 1e 0a 00 00       	call   c0105b6b <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010514d:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105154:	00 
c0105155:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010515c:	e8 83 0a 00 00       	call   c0105be4 <strcmp>
c0105161:	85 c0                	test   %eax,%eax
c0105163:	74 24                	je     c0105189 <check_boot_pgdir+0x2f7>
c0105165:	c7 44 24 0c c0 6f 10 	movl   $0xc0106fc0,0xc(%esp)
c010516c:	c0 
c010516d:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c0105174:	c0 
c0105175:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c010517c:	00 
c010517d:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c0105184:	e8 44 bb ff ff       	call   c0100ccd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105189:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010518c:	89 04 24             	mov    %eax,(%esp)
c010518f:	e8 23 e9 ff ff       	call   c0103ab7 <page2kva>
c0105194:	05 00 01 00 00       	add    $0x100,%eax
c0105199:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010519c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051a3:	e8 6b 09 00 00       	call   c0105b13 <strlen>
c01051a8:	85 c0                	test   %eax,%eax
c01051aa:	74 24                	je     c01051d0 <check_boot_pgdir+0x33e>
c01051ac:	c7 44 24 0c f8 6f 10 	movl   $0xc0106ff8,0xc(%esp)
c01051b3:	c0 
c01051b4:	c7 44 24 08 a1 6b 10 	movl   $0xc0106ba1,0x8(%esp)
c01051bb:	c0 
c01051bc:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c01051c3:	00 
c01051c4:	c7 04 24 7c 6b 10 c0 	movl   $0xc0106b7c,(%esp)
c01051cb:	e8 fd ba ff ff       	call   c0100ccd <__panic>

    free_page(p);
c01051d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051d7:	00 
c01051d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051db:	89 04 24             	mov    %eax,(%esp)
c01051de:	e8 a3 eb ff ff       	call   c0103d86 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01051e3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051e8:	8b 00                	mov    (%eax),%eax
c01051ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01051ef:	89 04 24             	mov    %eax,(%esp)
c01051f2:	e8 71 e8 ff ff       	call   c0103a68 <pa2page>
c01051f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051fe:	00 
c01051ff:	89 04 24             	mov    %eax,(%esp)
c0105202:	e8 7f eb ff ff       	call   c0103d86 <free_pages>
    boot_pgdir[0] = 0;
c0105207:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010520c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105212:	c7 04 24 1c 70 10 c0 	movl   $0xc010701c,(%esp)
c0105219:	e8 1e b1 ff ff       	call   c010033c <cprintf>
}
c010521e:	c9                   	leave  
c010521f:	c3                   	ret    

c0105220 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105220:	55                   	push   %ebp
c0105221:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105223:	8b 45 08             	mov    0x8(%ebp),%eax
c0105226:	83 e0 04             	and    $0x4,%eax
c0105229:	85 c0                	test   %eax,%eax
c010522b:	74 07                	je     c0105234 <perm2str+0x14>
c010522d:	b8 75 00 00 00       	mov    $0x75,%eax
c0105232:	eb 05                	jmp    c0105239 <perm2str+0x19>
c0105234:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105239:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c010523e:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105245:	8b 45 08             	mov    0x8(%ebp),%eax
c0105248:	83 e0 02             	and    $0x2,%eax
c010524b:	85 c0                	test   %eax,%eax
c010524d:	74 07                	je     c0105256 <perm2str+0x36>
c010524f:	b8 77 00 00 00       	mov    $0x77,%eax
c0105254:	eb 05                	jmp    c010525b <perm2str+0x3b>
c0105256:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010525b:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0105260:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0105267:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c010526c:	5d                   	pop    %ebp
c010526d:	c3                   	ret    

c010526e <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010526e:	55                   	push   %ebp
c010526f:	89 e5                	mov    %esp,%ebp
c0105271:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105274:	8b 45 10             	mov    0x10(%ebp),%eax
c0105277:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010527a:	72 0a                	jb     c0105286 <get_pgtable_items+0x18>
        return 0;
c010527c:	b8 00 00 00 00       	mov    $0x0,%eax
c0105281:	e9 9c 00 00 00       	jmp    c0105322 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105286:	eb 04                	jmp    c010528c <get_pgtable_items+0x1e>
        start ++;
c0105288:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010528c:	8b 45 10             	mov    0x10(%ebp),%eax
c010528f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105292:	73 18                	jae    c01052ac <get_pgtable_items+0x3e>
c0105294:	8b 45 10             	mov    0x10(%ebp),%eax
c0105297:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010529e:	8b 45 14             	mov    0x14(%ebp),%eax
c01052a1:	01 d0                	add    %edx,%eax
c01052a3:	8b 00                	mov    (%eax),%eax
c01052a5:	83 e0 01             	and    $0x1,%eax
c01052a8:	85 c0                	test   %eax,%eax
c01052aa:	74 dc                	je     c0105288 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01052ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01052af:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052b2:	73 69                	jae    c010531d <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01052b4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01052b8:	74 08                	je     c01052c2 <get_pgtable_items+0x54>
            *left_store = start;
c01052ba:	8b 45 18             	mov    0x18(%ebp),%eax
c01052bd:	8b 55 10             	mov    0x10(%ebp),%edx
c01052c0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01052c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01052c5:	8d 50 01             	lea    0x1(%eax),%edx
c01052c8:	89 55 10             	mov    %edx,0x10(%ebp)
c01052cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052d2:	8b 45 14             	mov    0x14(%ebp),%eax
c01052d5:	01 d0                	add    %edx,%eax
c01052d7:	8b 00                	mov    (%eax),%eax
c01052d9:	83 e0 07             	and    $0x7,%eax
c01052dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052df:	eb 04                	jmp    c01052e5 <get_pgtable_items+0x77>
            start ++;
c01052e1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01052e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052eb:	73 1d                	jae    c010530a <get_pgtable_items+0x9c>
c01052ed:	8b 45 10             	mov    0x10(%ebp),%eax
c01052f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052f7:	8b 45 14             	mov    0x14(%ebp),%eax
c01052fa:	01 d0                	add    %edx,%eax
c01052fc:	8b 00                	mov    (%eax),%eax
c01052fe:	83 e0 07             	and    $0x7,%eax
c0105301:	89 c2                	mov    %eax,%edx
c0105303:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105306:	39 c2                	cmp    %eax,%edx
c0105308:	74 d7                	je     c01052e1 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c010530a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010530e:	74 08                	je     c0105318 <get_pgtable_items+0xaa>
            *right_store = start;
c0105310:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105313:	8b 55 10             	mov    0x10(%ebp),%edx
c0105316:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105318:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010531b:	eb 05                	jmp    c0105322 <get_pgtable_items+0xb4>
    }
    return 0;
c010531d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105322:	c9                   	leave  
c0105323:	c3                   	ret    

c0105324 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105324:	55                   	push   %ebp
c0105325:	89 e5                	mov    %esp,%ebp
c0105327:	57                   	push   %edi
c0105328:	56                   	push   %esi
c0105329:	53                   	push   %ebx
c010532a:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010532d:	c7 04 24 3c 70 10 c0 	movl   $0xc010703c,(%esp)
c0105334:	e8 03 b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105339:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105340:	e9 fa 00 00 00       	jmp    c010543f <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105345:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105348:	89 04 24             	mov    %eax,(%esp)
c010534b:	e8 d0 fe ff ff       	call   c0105220 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105350:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105353:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105356:	29 d1                	sub    %edx,%ecx
c0105358:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010535a:	89 d6                	mov    %edx,%esi
c010535c:	c1 e6 16             	shl    $0x16,%esi
c010535f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105362:	89 d3                	mov    %edx,%ebx
c0105364:	c1 e3 16             	shl    $0x16,%ebx
c0105367:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010536a:	89 d1                	mov    %edx,%ecx
c010536c:	c1 e1 16             	shl    $0x16,%ecx
c010536f:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105372:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105375:	29 d7                	sub    %edx,%edi
c0105377:	89 fa                	mov    %edi,%edx
c0105379:	89 44 24 14          	mov    %eax,0x14(%esp)
c010537d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105381:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105385:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105389:	89 54 24 04          	mov    %edx,0x4(%esp)
c010538d:	c7 04 24 6d 70 10 c0 	movl   $0xc010706d,(%esp)
c0105394:	e8 a3 af ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105399:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010539c:	c1 e0 0a             	shl    $0xa,%eax
c010539f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053a2:	eb 54                	jmp    c01053f8 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01053a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053a7:	89 04 24             	mov    %eax,(%esp)
c01053aa:	e8 71 fe ff ff       	call   c0105220 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01053af:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01053b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01053b5:	29 d1                	sub    %edx,%ecx
c01053b7:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01053b9:	89 d6                	mov    %edx,%esi
c01053bb:	c1 e6 0c             	shl    $0xc,%esi
c01053be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053c1:	89 d3                	mov    %edx,%ebx
c01053c3:	c1 e3 0c             	shl    $0xc,%ebx
c01053c6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01053c9:	c1 e2 0c             	shl    $0xc,%edx
c01053cc:	89 d1                	mov    %edx,%ecx
c01053ce:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01053d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01053d4:	29 d7                	sub    %edx,%edi
c01053d6:	89 fa                	mov    %edi,%edx
c01053d8:	89 44 24 14          	mov    %eax,0x14(%esp)
c01053dc:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053ec:	c7 04 24 8c 70 10 c0 	movl   $0xc010708c,(%esp)
c01053f3:	e8 44 af ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053f8:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01053fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105400:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105403:	89 ce                	mov    %ecx,%esi
c0105405:	c1 e6 0a             	shl    $0xa,%esi
c0105408:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010540b:	89 cb                	mov    %ecx,%ebx
c010540d:	c1 e3 0a             	shl    $0xa,%ebx
c0105410:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105413:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105417:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010541a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010541e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105422:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105426:	89 74 24 04          	mov    %esi,0x4(%esp)
c010542a:	89 1c 24             	mov    %ebx,(%esp)
c010542d:	e8 3c fe ff ff       	call   c010526e <get_pgtable_items>
c0105432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105435:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105439:	0f 85 65 ff ff ff    	jne    c01053a4 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010543f:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105444:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105447:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010544a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010544e:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105451:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105455:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105459:	89 44 24 08          	mov    %eax,0x8(%esp)
c010545d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105464:	00 
c0105465:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010546c:	e8 fd fd ff ff       	call   c010526e <get_pgtable_items>
c0105471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105474:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105478:	0f 85 c7 fe ff ff    	jne    c0105345 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010547e:	c7 04 24 b0 70 10 c0 	movl   $0xc01070b0,(%esp)
c0105485:	e8 b2 ae ff ff       	call   c010033c <cprintf>
}
c010548a:	83 c4 4c             	add    $0x4c,%esp
c010548d:	5b                   	pop    %ebx
c010548e:	5e                   	pop    %esi
c010548f:	5f                   	pop    %edi
c0105490:	5d                   	pop    %ebp
c0105491:	c3                   	ret    

c0105492 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105492:	55                   	push   %ebp
c0105493:	89 e5                	mov    %esp,%ebp
c0105495:	83 ec 58             	sub    $0x58,%esp
c0105498:	8b 45 10             	mov    0x10(%ebp),%eax
c010549b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010549e:	8b 45 14             	mov    0x14(%ebp),%eax
c01054a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01054a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01054b0:	8b 45 18             	mov    0x18(%ebp),%eax
c01054b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01054c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054cc:	74 1c                	je     c01054ea <printnum+0x58>
c01054ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054d1:	ba 00 00 00 00       	mov    $0x0,%edx
c01054d6:	f7 75 e4             	divl   -0x1c(%ebp)
c01054d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01054dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054df:	ba 00 00 00 00       	mov    $0x0,%edx
c01054e4:	f7 75 e4             	divl   -0x1c(%ebp)
c01054e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054f0:	f7 75 e4             	divl   -0x1c(%ebp)
c01054f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105502:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105505:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105508:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010550b:	8b 45 18             	mov    0x18(%ebp),%eax
c010550e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105513:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105516:	77 56                	ja     c010556e <printnum+0xdc>
c0105518:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010551b:	72 05                	jb     c0105522 <printnum+0x90>
c010551d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105520:	77 4c                	ja     c010556e <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105522:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105525:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105528:	8b 45 20             	mov    0x20(%ebp),%eax
c010552b:	89 44 24 18          	mov    %eax,0x18(%esp)
c010552f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105533:	8b 45 18             	mov    0x18(%ebp),%eax
c0105536:	89 44 24 10          	mov    %eax,0x10(%esp)
c010553a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010553d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105540:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105544:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010554b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010554f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105552:	89 04 24             	mov    %eax,(%esp)
c0105555:	e8 38 ff ff ff       	call   c0105492 <printnum>
c010555a:	eb 1c                	jmp    c0105578 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010555c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010555f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105563:	8b 45 20             	mov    0x20(%ebp),%eax
c0105566:	89 04 24             	mov    %eax,(%esp)
c0105569:	8b 45 08             	mov    0x8(%ebp),%eax
c010556c:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010556e:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105572:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105576:	7f e4                	jg     c010555c <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105578:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010557b:	05 64 71 10 c0       	add    $0xc0107164,%eax
c0105580:	0f b6 00             	movzbl (%eax),%eax
c0105583:	0f be c0             	movsbl %al,%eax
c0105586:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105589:	89 54 24 04          	mov    %edx,0x4(%esp)
c010558d:	89 04 24             	mov    %eax,(%esp)
c0105590:	8b 45 08             	mov    0x8(%ebp),%eax
c0105593:	ff d0                	call   *%eax
}
c0105595:	c9                   	leave  
c0105596:	c3                   	ret    

c0105597 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105597:	55                   	push   %ebp
c0105598:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010559a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010559e:	7e 14                	jle    c01055b4 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01055a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a3:	8b 00                	mov    (%eax),%eax
c01055a5:	8d 48 08             	lea    0x8(%eax),%ecx
c01055a8:	8b 55 08             	mov    0x8(%ebp),%edx
c01055ab:	89 0a                	mov    %ecx,(%edx)
c01055ad:	8b 50 04             	mov    0x4(%eax),%edx
c01055b0:	8b 00                	mov    (%eax),%eax
c01055b2:	eb 30                	jmp    c01055e4 <getuint+0x4d>
    }
    else if (lflag) {
c01055b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055b8:	74 16                	je     c01055d0 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01055ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01055bd:	8b 00                	mov    (%eax),%eax
c01055bf:	8d 48 04             	lea    0x4(%eax),%ecx
c01055c2:	8b 55 08             	mov    0x8(%ebp),%edx
c01055c5:	89 0a                	mov    %ecx,(%edx)
c01055c7:	8b 00                	mov    (%eax),%eax
c01055c9:	ba 00 00 00 00       	mov    $0x0,%edx
c01055ce:	eb 14                	jmp    c01055e4 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01055d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d3:	8b 00                	mov    (%eax),%eax
c01055d5:	8d 48 04             	lea    0x4(%eax),%ecx
c01055d8:	8b 55 08             	mov    0x8(%ebp),%edx
c01055db:	89 0a                	mov    %ecx,(%edx)
c01055dd:	8b 00                	mov    (%eax),%eax
c01055df:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01055e4:	5d                   	pop    %ebp
c01055e5:	c3                   	ret    

c01055e6 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01055e6:	55                   	push   %ebp
c01055e7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055e9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055ed:	7e 14                	jle    c0105603 <getint+0x1d>
        return va_arg(*ap, long long);
c01055ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f2:	8b 00                	mov    (%eax),%eax
c01055f4:	8d 48 08             	lea    0x8(%eax),%ecx
c01055f7:	8b 55 08             	mov    0x8(%ebp),%edx
c01055fa:	89 0a                	mov    %ecx,(%edx)
c01055fc:	8b 50 04             	mov    0x4(%eax),%edx
c01055ff:	8b 00                	mov    (%eax),%eax
c0105601:	eb 28                	jmp    c010562b <getint+0x45>
    }
    else if (lflag) {
c0105603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105607:	74 12                	je     c010561b <getint+0x35>
        return va_arg(*ap, long);
c0105609:	8b 45 08             	mov    0x8(%ebp),%eax
c010560c:	8b 00                	mov    (%eax),%eax
c010560e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105611:	8b 55 08             	mov    0x8(%ebp),%edx
c0105614:	89 0a                	mov    %ecx,(%edx)
c0105616:	8b 00                	mov    (%eax),%eax
c0105618:	99                   	cltd   
c0105619:	eb 10                	jmp    c010562b <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010561b:	8b 45 08             	mov    0x8(%ebp),%eax
c010561e:	8b 00                	mov    (%eax),%eax
c0105620:	8d 48 04             	lea    0x4(%eax),%ecx
c0105623:	8b 55 08             	mov    0x8(%ebp),%edx
c0105626:	89 0a                	mov    %ecx,(%edx)
c0105628:	8b 00                	mov    (%eax),%eax
c010562a:	99                   	cltd   
    }
}
c010562b:	5d                   	pop    %ebp
c010562c:	c3                   	ret    

c010562d <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010562d:	55                   	push   %ebp
c010562e:	89 e5                	mov    %esp,%ebp
c0105630:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105633:	8d 45 14             	lea    0x14(%ebp),%eax
c0105636:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105639:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010563c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105640:	8b 45 10             	mov    0x10(%ebp),%eax
c0105643:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105647:	8b 45 0c             	mov    0xc(%ebp),%eax
c010564a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010564e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105651:	89 04 24             	mov    %eax,(%esp)
c0105654:	e8 02 00 00 00       	call   c010565b <vprintfmt>
    va_end(ap);
}
c0105659:	c9                   	leave  
c010565a:	c3                   	ret    

c010565b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010565b:	55                   	push   %ebp
c010565c:	89 e5                	mov    %esp,%ebp
c010565e:	56                   	push   %esi
c010565f:	53                   	push   %ebx
c0105660:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105663:	eb 18                	jmp    c010567d <vprintfmt+0x22>
            if (ch == '\0') {
c0105665:	85 db                	test   %ebx,%ebx
c0105667:	75 05                	jne    c010566e <vprintfmt+0x13>
                return;
c0105669:	e9 d1 03 00 00       	jmp    c0105a3f <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010566e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105671:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105675:	89 1c 24             	mov    %ebx,(%esp)
c0105678:	8b 45 08             	mov    0x8(%ebp),%eax
c010567b:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010567d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105680:	8d 50 01             	lea    0x1(%eax),%edx
c0105683:	89 55 10             	mov    %edx,0x10(%ebp)
c0105686:	0f b6 00             	movzbl (%eax),%eax
c0105689:	0f b6 d8             	movzbl %al,%ebx
c010568c:	83 fb 25             	cmp    $0x25,%ebx
c010568f:	75 d4                	jne    c0105665 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105691:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105695:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010569c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010569f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01056a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01056a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056ac:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01056af:	8b 45 10             	mov    0x10(%ebp),%eax
c01056b2:	8d 50 01             	lea    0x1(%eax),%edx
c01056b5:	89 55 10             	mov    %edx,0x10(%ebp)
c01056b8:	0f b6 00             	movzbl (%eax),%eax
c01056bb:	0f b6 d8             	movzbl %al,%ebx
c01056be:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01056c1:	83 f8 55             	cmp    $0x55,%eax
c01056c4:	0f 87 44 03 00 00    	ja     c0105a0e <vprintfmt+0x3b3>
c01056ca:	8b 04 85 88 71 10 c0 	mov    -0x3fef8e78(,%eax,4),%eax
c01056d1:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01056d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01056d7:	eb d6                	jmp    c01056af <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01056d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01056dd:	eb d0                	jmp    c01056af <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01056e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056e9:	89 d0                	mov    %edx,%eax
c01056eb:	c1 e0 02             	shl    $0x2,%eax
c01056ee:	01 d0                	add    %edx,%eax
c01056f0:	01 c0                	add    %eax,%eax
c01056f2:	01 d8                	add    %ebx,%eax
c01056f4:	83 e8 30             	sub    $0x30,%eax
c01056f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01056fd:	0f b6 00             	movzbl (%eax),%eax
c0105700:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105703:	83 fb 2f             	cmp    $0x2f,%ebx
c0105706:	7e 0b                	jle    c0105713 <vprintfmt+0xb8>
c0105708:	83 fb 39             	cmp    $0x39,%ebx
c010570b:	7f 06                	jg     c0105713 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010570d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105711:	eb d3                	jmp    c01056e6 <vprintfmt+0x8b>
            goto process_precision;
c0105713:	eb 33                	jmp    c0105748 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105715:	8b 45 14             	mov    0x14(%ebp),%eax
c0105718:	8d 50 04             	lea    0x4(%eax),%edx
c010571b:	89 55 14             	mov    %edx,0x14(%ebp)
c010571e:	8b 00                	mov    (%eax),%eax
c0105720:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105723:	eb 23                	jmp    c0105748 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105725:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105729:	79 0c                	jns    c0105737 <vprintfmt+0xdc>
                width = 0;
c010572b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105732:	e9 78 ff ff ff       	jmp    c01056af <vprintfmt+0x54>
c0105737:	e9 73 ff ff ff       	jmp    c01056af <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010573c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105743:	e9 67 ff ff ff       	jmp    c01056af <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105748:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010574c:	79 12                	jns    c0105760 <vprintfmt+0x105>
                width = precision, precision = -1;
c010574e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105751:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105754:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010575b:	e9 4f ff ff ff       	jmp    c01056af <vprintfmt+0x54>
c0105760:	e9 4a ff ff ff       	jmp    c01056af <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105765:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105769:	e9 41 ff ff ff       	jmp    c01056af <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010576e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105771:	8d 50 04             	lea    0x4(%eax),%edx
c0105774:	89 55 14             	mov    %edx,0x14(%ebp)
c0105777:	8b 00                	mov    (%eax),%eax
c0105779:	8b 55 0c             	mov    0xc(%ebp),%edx
c010577c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105780:	89 04 24             	mov    %eax,(%esp)
c0105783:	8b 45 08             	mov    0x8(%ebp),%eax
c0105786:	ff d0                	call   *%eax
            break;
c0105788:	e9 ac 02 00 00       	jmp    c0105a39 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010578d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105790:	8d 50 04             	lea    0x4(%eax),%edx
c0105793:	89 55 14             	mov    %edx,0x14(%ebp)
c0105796:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105798:	85 db                	test   %ebx,%ebx
c010579a:	79 02                	jns    c010579e <vprintfmt+0x143>
                err = -err;
c010579c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010579e:	83 fb 06             	cmp    $0x6,%ebx
c01057a1:	7f 0b                	jg     c01057ae <vprintfmt+0x153>
c01057a3:	8b 34 9d 48 71 10 c0 	mov    -0x3fef8eb8(,%ebx,4),%esi
c01057aa:	85 f6                	test   %esi,%esi
c01057ac:	75 23                	jne    c01057d1 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01057ae:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01057b2:	c7 44 24 08 75 71 10 	movl   $0xc0107175,0x8(%esp)
c01057b9:	c0 
c01057ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c4:	89 04 24             	mov    %eax,(%esp)
c01057c7:	e8 61 fe ff ff       	call   c010562d <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01057cc:	e9 68 02 00 00       	jmp    c0105a39 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01057d1:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01057d5:	c7 44 24 08 7e 71 10 	movl   $0xc010717e,0x8(%esp)
c01057dc:	c0 
c01057dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e7:	89 04 24             	mov    %eax,(%esp)
c01057ea:	e8 3e fe ff ff       	call   c010562d <printfmt>
            }
            break;
c01057ef:	e9 45 02 00 00       	jmp    c0105a39 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01057f4:	8b 45 14             	mov    0x14(%ebp),%eax
c01057f7:	8d 50 04             	lea    0x4(%eax),%edx
c01057fa:	89 55 14             	mov    %edx,0x14(%ebp)
c01057fd:	8b 30                	mov    (%eax),%esi
c01057ff:	85 f6                	test   %esi,%esi
c0105801:	75 05                	jne    c0105808 <vprintfmt+0x1ad>
                p = "(null)";
c0105803:	be 81 71 10 c0       	mov    $0xc0107181,%esi
            }
            if (width > 0 && padc != '-') {
c0105808:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010580c:	7e 3e                	jle    c010584c <vprintfmt+0x1f1>
c010580e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105812:	74 38                	je     c010584c <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105814:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010581a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010581e:	89 34 24             	mov    %esi,(%esp)
c0105821:	e8 15 03 00 00       	call   c0105b3b <strnlen>
c0105826:	29 c3                	sub    %eax,%ebx
c0105828:	89 d8                	mov    %ebx,%eax
c010582a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010582d:	eb 17                	jmp    c0105846 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010582f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105833:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105836:	89 54 24 04          	mov    %edx,0x4(%esp)
c010583a:	89 04 24             	mov    %eax,(%esp)
c010583d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105840:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105842:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105846:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010584a:	7f e3                	jg     c010582f <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010584c:	eb 38                	jmp    c0105886 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010584e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105852:	74 1f                	je     c0105873 <vprintfmt+0x218>
c0105854:	83 fb 1f             	cmp    $0x1f,%ebx
c0105857:	7e 05                	jle    c010585e <vprintfmt+0x203>
c0105859:	83 fb 7e             	cmp    $0x7e,%ebx
c010585c:	7e 15                	jle    c0105873 <vprintfmt+0x218>
                    putch('?', putdat);
c010585e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105861:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105865:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010586c:	8b 45 08             	mov    0x8(%ebp),%eax
c010586f:	ff d0                	call   *%eax
c0105871:	eb 0f                	jmp    c0105882 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105873:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105876:	89 44 24 04          	mov    %eax,0x4(%esp)
c010587a:	89 1c 24             	mov    %ebx,(%esp)
c010587d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105880:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105882:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105886:	89 f0                	mov    %esi,%eax
c0105888:	8d 70 01             	lea    0x1(%eax),%esi
c010588b:	0f b6 00             	movzbl (%eax),%eax
c010588e:	0f be d8             	movsbl %al,%ebx
c0105891:	85 db                	test   %ebx,%ebx
c0105893:	74 10                	je     c01058a5 <vprintfmt+0x24a>
c0105895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105899:	78 b3                	js     c010584e <vprintfmt+0x1f3>
c010589b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010589f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058a3:	79 a9                	jns    c010584e <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01058a5:	eb 17                	jmp    c01058be <vprintfmt+0x263>
                putch(' ', putdat);
c01058a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058ae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01058b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b8:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01058ba:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01058be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058c2:	7f e3                	jg     c01058a7 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01058c4:	e9 70 01 00 00       	jmp    c0105a39 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01058c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d0:	8d 45 14             	lea    0x14(%ebp),%eax
c01058d3:	89 04 24             	mov    %eax,(%esp)
c01058d6:	e8 0b fd ff ff       	call   c01055e6 <getint>
c01058db:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058de:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01058e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058e7:	85 d2                	test   %edx,%edx
c01058e9:	79 26                	jns    c0105911 <vprintfmt+0x2b6>
                putch('-', putdat);
c01058eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01058f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fc:	ff d0                	call   *%eax
                num = -(long long)num;
c01058fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105901:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105904:	f7 d8                	neg    %eax
c0105906:	83 d2 00             	adc    $0x0,%edx
c0105909:	f7 da                	neg    %edx
c010590b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010590e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105911:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105918:	e9 a8 00 00 00       	jmp    c01059c5 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010591d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105920:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105924:	8d 45 14             	lea    0x14(%ebp),%eax
c0105927:	89 04 24             	mov    %eax,(%esp)
c010592a:	e8 68 fc ff ff       	call   c0105597 <getuint>
c010592f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105932:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105935:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010593c:	e9 84 00 00 00       	jmp    c01059c5 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105941:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105944:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105948:	8d 45 14             	lea    0x14(%ebp),%eax
c010594b:	89 04 24             	mov    %eax,(%esp)
c010594e:	e8 44 fc ff ff       	call   c0105597 <getuint>
c0105953:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105956:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105959:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105960:	eb 63                	jmp    c01059c5 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105962:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105965:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105969:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105970:	8b 45 08             	mov    0x8(%ebp),%eax
c0105973:	ff d0                	call   *%eax
            putch('x', putdat);
c0105975:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105978:	89 44 24 04          	mov    %eax,0x4(%esp)
c010597c:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105983:	8b 45 08             	mov    0x8(%ebp),%eax
c0105986:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105988:	8b 45 14             	mov    0x14(%ebp),%eax
c010598b:	8d 50 04             	lea    0x4(%eax),%edx
c010598e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105991:	8b 00                	mov    (%eax),%eax
c0105993:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010599d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01059a4:	eb 1f                	jmp    c01059c5 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01059a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ad:	8d 45 14             	lea    0x14(%ebp),%eax
c01059b0:	89 04 24             	mov    %eax,(%esp)
c01059b3:	e8 df fb ff ff       	call   c0105597 <getuint>
c01059b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01059be:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01059c5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01059c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059cc:	89 54 24 18          	mov    %edx,0x18(%esp)
c01059d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01059d3:	89 54 24 14          	mov    %edx,0x14(%esp)
c01059d7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01059db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059de:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059e1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01059e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f3:	89 04 24             	mov    %eax,(%esp)
c01059f6:	e8 97 fa ff ff       	call   c0105492 <printnum>
            break;
c01059fb:	eb 3c                	jmp    c0105a39 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01059fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a04:	89 1c 24             	mov    %ebx,(%esp)
c0105a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0a:	ff d0                	call   *%eax
            break;
c0105a0c:	eb 2b                	jmp    c0105a39 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a15:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a1f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105a21:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a25:	eb 04                	jmp    c0105a2b <vprintfmt+0x3d0>
c0105a27:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a2b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a2e:	83 e8 01             	sub    $0x1,%eax
c0105a31:	0f b6 00             	movzbl (%eax),%eax
c0105a34:	3c 25                	cmp    $0x25,%al
c0105a36:	75 ef                	jne    c0105a27 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105a38:	90                   	nop
        }
    }
c0105a39:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105a3a:	e9 3e fc ff ff       	jmp    c010567d <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105a3f:	83 c4 40             	add    $0x40,%esp
c0105a42:	5b                   	pop    %ebx
c0105a43:	5e                   	pop    %esi
c0105a44:	5d                   	pop    %ebp
c0105a45:	c3                   	ret    

c0105a46 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105a46:	55                   	push   %ebp
c0105a47:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105a49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4c:	8b 40 08             	mov    0x8(%eax),%eax
c0105a4f:	8d 50 01             	lea    0x1(%eax),%edx
c0105a52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a55:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a58:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a5b:	8b 10                	mov    (%eax),%edx
c0105a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a60:	8b 40 04             	mov    0x4(%eax),%eax
c0105a63:	39 c2                	cmp    %eax,%edx
c0105a65:	73 12                	jae    c0105a79 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a67:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a6a:	8b 00                	mov    (%eax),%eax
c0105a6c:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a72:	89 0a                	mov    %ecx,(%edx)
c0105a74:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a77:	88 10                	mov    %dl,(%eax)
    }
}
c0105a79:	5d                   	pop    %ebp
c0105a7a:	c3                   	ret    

c0105a7b <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a7b:	55                   	push   %ebp
c0105a7c:	89 e5                	mov    %esp,%ebp
c0105a7e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a81:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a8e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a91:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a9f:	89 04 24             	mov    %eax,(%esp)
c0105aa2:	e8 08 00 00 00       	call   c0105aaf <vsnprintf>
c0105aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105aad:	c9                   	leave  
c0105aae:	c3                   	ret    

c0105aaf <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105aaf:	55                   	push   %ebp
c0105ab0:	89 e5                	mov    %esp,%ebp
c0105ab2:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105abb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105abe:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac4:	01 d0                	add    %edx,%eax
c0105ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ac9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105ad0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105ad4:	74 0a                	je     c0105ae0 <vsnprintf+0x31>
c0105ad6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105adc:	39 c2                	cmp    %eax,%edx
c0105ade:	76 07                	jbe    c0105ae7 <vsnprintf+0x38>
        return -E_INVAL;
c0105ae0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105ae5:	eb 2a                	jmp    c0105b11 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105ae7:	8b 45 14             	mov    0x14(%ebp),%eax
c0105aea:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105aee:	8b 45 10             	mov    0x10(%ebp),%eax
c0105af1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105af5:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105af8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105afc:	c7 04 24 46 5a 10 c0 	movl   $0xc0105a46,(%esp)
c0105b03:	e8 53 fb ff ff       	call   c010565b <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b0b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b11:	c9                   	leave  
c0105b12:	c3                   	ret    

c0105b13 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105b13:	55                   	push   %ebp
c0105b14:	89 e5                	mov    %esp,%ebp
c0105b16:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105b20:	eb 04                	jmp    c0105b26 <strlen+0x13>
        cnt ++;
c0105b22:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105b26:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b29:	8d 50 01             	lea    0x1(%eax),%edx
c0105b2c:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b2f:	0f b6 00             	movzbl (%eax),%eax
c0105b32:	84 c0                	test   %al,%al
c0105b34:	75 ec                	jne    c0105b22 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105b36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b39:	c9                   	leave  
c0105b3a:	c3                   	ret    

c0105b3b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105b3b:	55                   	push   %ebp
c0105b3c:	89 e5                	mov    %esp,%ebp
c0105b3e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b48:	eb 04                	jmp    c0105b4e <strnlen+0x13>
        cnt ++;
c0105b4a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b51:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b54:	73 10                	jae    c0105b66 <strnlen+0x2b>
c0105b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b59:	8d 50 01             	lea    0x1(%eax),%edx
c0105b5c:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b5f:	0f b6 00             	movzbl (%eax),%eax
c0105b62:	84 c0                	test   %al,%al
c0105b64:	75 e4                	jne    c0105b4a <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105b66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b69:	c9                   	leave  
c0105b6a:	c3                   	ret    

c0105b6b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b6b:	55                   	push   %ebp
c0105b6c:	89 e5                	mov    %esp,%ebp
c0105b6e:	57                   	push   %edi
c0105b6f:	56                   	push   %esi
c0105b70:	83 ec 20             	sub    $0x20,%esp
c0105b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b79:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b85:	89 d1                	mov    %edx,%ecx
c0105b87:	89 c2                	mov    %eax,%edx
c0105b89:	89 ce                	mov    %ecx,%esi
c0105b8b:	89 d7                	mov    %edx,%edi
c0105b8d:	ac                   	lods   %ds:(%esi),%al
c0105b8e:	aa                   	stos   %al,%es:(%edi)
c0105b8f:	84 c0                	test   %al,%al
c0105b91:	75 fa                	jne    c0105b8d <strcpy+0x22>
c0105b93:	89 fa                	mov    %edi,%edx
c0105b95:	89 f1                	mov    %esi,%ecx
c0105b97:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b9a:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105ba3:	83 c4 20             	add    $0x20,%esp
c0105ba6:	5e                   	pop    %esi
c0105ba7:	5f                   	pop    %edi
c0105ba8:	5d                   	pop    %ebp
c0105ba9:	c3                   	ret    

c0105baa <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105baa:	55                   	push   %ebp
c0105bab:	89 e5                	mov    %esp,%ebp
c0105bad:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105bb6:	eb 21                	jmp    c0105bd9 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bbb:	0f b6 10             	movzbl (%eax),%edx
c0105bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105bc1:	88 10                	mov    %dl,(%eax)
c0105bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105bc6:	0f b6 00             	movzbl (%eax),%eax
c0105bc9:	84 c0                	test   %al,%al
c0105bcb:	74 04                	je     c0105bd1 <strncpy+0x27>
            src ++;
c0105bcd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105bd1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105bd5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105bd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bdd:	75 d9                	jne    c0105bb8 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105bdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105be2:	c9                   	leave  
c0105be3:	c3                   	ret    

c0105be4 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105be4:	55                   	push   %ebp
c0105be5:	89 e5                	mov    %esp,%ebp
c0105be7:	57                   	push   %edi
c0105be8:	56                   	push   %esi
c0105be9:	83 ec 20             	sub    $0x20,%esp
c0105bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bfe:	89 d1                	mov    %edx,%ecx
c0105c00:	89 c2                	mov    %eax,%edx
c0105c02:	89 ce                	mov    %ecx,%esi
c0105c04:	89 d7                	mov    %edx,%edi
c0105c06:	ac                   	lods   %ds:(%esi),%al
c0105c07:	ae                   	scas   %es:(%edi),%al
c0105c08:	75 08                	jne    c0105c12 <strcmp+0x2e>
c0105c0a:	84 c0                	test   %al,%al
c0105c0c:	75 f8                	jne    c0105c06 <strcmp+0x22>
c0105c0e:	31 c0                	xor    %eax,%eax
c0105c10:	eb 04                	jmp    c0105c16 <strcmp+0x32>
c0105c12:	19 c0                	sbb    %eax,%eax
c0105c14:	0c 01                	or     $0x1,%al
c0105c16:	89 fa                	mov    %edi,%edx
c0105c18:	89 f1                	mov    %esi,%ecx
c0105c1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c1d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105c20:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105c23:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105c26:	83 c4 20             	add    $0x20,%esp
c0105c29:	5e                   	pop    %esi
c0105c2a:	5f                   	pop    %edi
c0105c2b:	5d                   	pop    %ebp
c0105c2c:	c3                   	ret    

c0105c2d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105c2d:	55                   	push   %ebp
c0105c2e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c30:	eb 0c                	jmp    c0105c3e <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105c32:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c36:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c3a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c42:	74 1a                	je     c0105c5e <strncmp+0x31>
c0105c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c47:	0f b6 00             	movzbl (%eax),%eax
c0105c4a:	84 c0                	test   %al,%al
c0105c4c:	74 10                	je     c0105c5e <strncmp+0x31>
c0105c4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c51:	0f b6 10             	movzbl (%eax),%edx
c0105c54:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c57:	0f b6 00             	movzbl (%eax),%eax
c0105c5a:	38 c2                	cmp    %al,%dl
c0105c5c:	74 d4                	je     c0105c32 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c62:	74 18                	je     c0105c7c <strncmp+0x4f>
c0105c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c67:	0f b6 00             	movzbl (%eax),%eax
c0105c6a:	0f b6 d0             	movzbl %al,%edx
c0105c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c70:	0f b6 00             	movzbl (%eax),%eax
c0105c73:	0f b6 c0             	movzbl %al,%eax
c0105c76:	29 c2                	sub    %eax,%edx
c0105c78:	89 d0                	mov    %edx,%eax
c0105c7a:	eb 05                	jmp    c0105c81 <strncmp+0x54>
c0105c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c81:	5d                   	pop    %ebp
c0105c82:	c3                   	ret    

c0105c83 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c83:	55                   	push   %ebp
c0105c84:	89 e5                	mov    %esp,%ebp
c0105c86:	83 ec 04             	sub    $0x4,%esp
c0105c89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c8c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c8f:	eb 14                	jmp    c0105ca5 <strchr+0x22>
        if (*s == c) {
c0105c91:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c94:	0f b6 00             	movzbl (%eax),%eax
c0105c97:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c9a:	75 05                	jne    c0105ca1 <strchr+0x1e>
            return (char *)s;
c0105c9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9f:	eb 13                	jmp    c0105cb4 <strchr+0x31>
        }
        s ++;
c0105ca1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca8:	0f b6 00             	movzbl (%eax),%eax
c0105cab:	84 c0                	test   %al,%al
c0105cad:	75 e2                	jne    c0105c91 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105caf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cb4:	c9                   	leave  
c0105cb5:	c3                   	ret    

c0105cb6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105cb6:	55                   	push   %ebp
c0105cb7:	89 e5                	mov    %esp,%ebp
c0105cb9:	83 ec 04             	sub    $0x4,%esp
c0105cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cbf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105cc2:	eb 11                	jmp    c0105cd5 <strfind+0x1f>
        if (*s == c) {
c0105cc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc7:	0f b6 00             	movzbl (%eax),%eax
c0105cca:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105ccd:	75 02                	jne    c0105cd1 <strfind+0x1b>
            break;
c0105ccf:	eb 0e                	jmp    c0105cdf <strfind+0x29>
        }
        s ++;
c0105cd1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd8:	0f b6 00             	movzbl (%eax),%eax
c0105cdb:	84 c0                	test   %al,%al
c0105cdd:	75 e5                	jne    c0105cc4 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105cdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ce2:	c9                   	leave  
c0105ce3:	c3                   	ret    

c0105ce4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105ce4:	55                   	push   %ebp
c0105ce5:	89 e5                	mov    %esp,%ebp
c0105ce7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105cf1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105cf8:	eb 04                	jmp    c0105cfe <strtol+0x1a>
        s ++;
c0105cfa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105cfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d01:	0f b6 00             	movzbl (%eax),%eax
c0105d04:	3c 20                	cmp    $0x20,%al
c0105d06:	74 f2                	je     c0105cfa <strtol+0x16>
c0105d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d0b:	0f b6 00             	movzbl (%eax),%eax
c0105d0e:	3c 09                	cmp    $0x9,%al
c0105d10:	74 e8                	je     c0105cfa <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d15:	0f b6 00             	movzbl (%eax),%eax
c0105d18:	3c 2b                	cmp    $0x2b,%al
c0105d1a:	75 06                	jne    c0105d22 <strtol+0x3e>
        s ++;
c0105d1c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d20:	eb 15                	jmp    c0105d37 <strtol+0x53>
    }
    else if (*s == '-') {
c0105d22:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d25:	0f b6 00             	movzbl (%eax),%eax
c0105d28:	3c 2d                	cmp    $0x2d,%al
c0105d2a:	75 0b                	jne    c0105d37 <strtol+0x53>
        s ++, neg = 1;
c0105d2c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d30:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105d37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d3b:	74 06                	je     c0105d43 <strtol+0x5f>
c0105d3d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105d41:	75 24                	jne    c0105d67 <strtol+0x83>
c0105d43:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d46:	0f b6 00             	movzbl (%eax),%eax
c0105d49:	3c 30                	cmp    $0x30,%al
c0105d4b:	75 1a                	jne    c0105d67 <strtol+0x83>
c0105d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d50:	83 c0 01             	add    $0x1,%eax
c0105d53:	0f b6 00             	movzbl (%eax),%eax
c0105d56:	3c 78                	cmp    $0x78,%al
c0105d58:	75 0d                	jne    c0105d67 <strtol+0x83>
        s += 2, base = 16;
c0105d5a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d5e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d65:	eb 2a                	jmp    c0105d91 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105d67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d6b:	75 17                	jne    c0105d84 <strtol+0xa0>
c0105d6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d70:	0f b6 00             	movzbl (%eax),%eax
c0105d73:	3c 30                	cmp    $0x30,%al
c0105d75:	75 0d                	jne    c0105d84 <strtol+0xa0>
        s ++, base = 8;
c0105d77:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d7b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d82:	eb 0d                	jmp    c0105d91 <strtol+0xad>
    }
    else if (base == 0) {
c0105d84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d88:	75 07                	jne    c0105d91 <strtol+0xad>
        base = 10;
c0105d8a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d91:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d94:	0f b6 00             	movzbl (%eax),%eax
c0105d97:	3c 2f                	cmp    $0x2f,%al
c0105d99:	7e 1b                	jle    c0105db6 <strtol+0xd2>
c0105d9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9e:	0f b6 00             	movzbl (%eax),%eax
c0105da1:	3c 39                	cmp    $0x39,%al
c0105da3:	7f 11                	jg     c0105db6 <strtol+0xd2>
            dig = *s - '0';
c0105da5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da8:	0f b6 00             	movzbl (%eax),%eax
c0105dab:	0f be c0             	movsbl %al,%eax
c0105dae:	83 e8 30             	sub    $0x30,%eax
c0105db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105db4:	eb 48                	jmp    c0105dfe <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105db6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db9:	0f b6 00             	movzbl (%eax),%eax
c0105dbc:	3c 60                	cmp    $0x60,%al
c0105dbe:	7e 1b                	jle    c0105ddb <strtol+0xf7>
c0105dc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc3:	0f b6 00             	movzbl (%eax),%eax
c0105dc6:	3c 7a                	cmp    $0x7a,%al
c0105dc8:	7f 11                	jg     c0105ddb <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dcd:	0f b6 00             	movzbl (%eax),%eax
c0105dd0:	0f be c0             	movsbl %al,%eax
c0105dd3:	83 e8 57             	sub    $0x57,%eax
c0105dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105dd9:	eb 23                	jmp    c0105dfe <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105ddb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dde:	0f b6 00             	movzbl (%eax),%eax
c0105de1:	3c 40                	cmp    $0x40,%al
c0105de3:	7e 3d                	jle    c0105e22 <strtol+0x13e>
c0105de5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de8:	0f b6 00             	movzbl (%eax),%eax
c0105deb:	3c 5a                	cmp    $0x5a,%al
c0105ded:	7f 33                	jg     c0105e22 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105def:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df2:	0f b6 00             	movzbl (%eax),%eax
c0105df5:	0f be c0             	movsbl %al,%eax
c0105df8:	83 e8 37             	sub    $0x37,%eax
c0105dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e01:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105e04:	7c 02                	jl     c0105e08 <strtol+0x124>
            break;
c0105e06:	eb 1a                	jmp    c0105e22 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105e08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e0f:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105e13:	89 c2                	mov    %eax,%edx
c0105e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e18:	01 d0                	add    %edx,%eax
c0105e1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105e1d:	e9 6f ff ff ff       	jmp    c0105d91 <strtol+0xad>

    if (endptr) {
c0105e22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105e26:	74 08                	je     c0105e30 <strtol+0x14c>
        *endptr = (char *) s;
c0105e28:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e2b:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e2e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105e30:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105e34:	74 07                	je     c0105e3d <strtol+0x159>
c0105e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e39:	f7 d8                	neg    %eax
c0105e3b:	eb 03                	jmp    c0105e40 <strtol+0x15c>
c0105e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105e40:	c9                   	leave  
c0105e41:	c3                   	ret    

c0105e42 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105e42:	55                   	push   %ebp
c0105e43:	89 e5                	mov    %esp,%ebp
c0105e45:	57                   	push   %edi
c0105e46:	83 ec 24             	sub    $0x24,%esp
c0105e49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e4c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e4f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105e53:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e56:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105e59:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105e5c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105e62:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e65:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e69:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e6c:	89 d7                	mov    %edx,%edi
c0105e6e:	f3 aa                	rep stos %al,%es:(%edi)
c0105e70:	89 fa                	mov    %edi,%edx
c0105e72:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e75:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e7b:	83 c4 24             	add    $0x24,%esp
c0105e7e:	5f                   	pop    %edi
c0105e7f:	5d                   	pop    %ebp
c0105e80:	c3                   	ret    

c0105e81 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e81:	55                   	push   %ebp
c0105e82:	89 e5                	mov    %esp,%ebp
c0105e84:	57                   	push   %edi
c0105e85:	56                   	push   %esi
c0105e86:	53                   	push   %ebx
c0105e87:	83 ec 30             	sub    $0x30,%esp
c0105e8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e90:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e93:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e96:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e99:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e9f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105ea2:	73 42                	jae    c0105ee6 <memmove+0x65>
c0105ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ea7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105eaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ead:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eb3:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105eb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105eb9:	c1 e8 02             	shr    $0x2,%eax
c0105ebc:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105ebe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ec1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ec4:	89 d7                	mov    %edx,%edi
c0105ec6:	89 c6                	mov    %eax,%esi
c0105ec8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105eca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105ecd:	83 e1 03             	and    $0x3,%ecx
c0105ed0:	74 02                	je     c0105ed4 <memmove+0x53>
c0105ed2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ed4:	89 f0                	mov    %esi,%eax
c0105ed6:	89 fa                	mov    %edi,%edx
c0105ed8:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105edb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105ede:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ee4:	eb 36                	jmp    c0105f1c <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105ee6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ee9:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eef:	01 c2                	add    %eax,%edx
c0105ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ef4:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105efa:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f00:	89 c1                	mov    %eax,%ecx
c0105f02:	89 d8                	mov    %ebx,%eax
c0105f04:	89 d6                	mov    %edx,%esi
c0105f06:	89 c7                	mov    %eax,%edi
c0105f08:	fd                   	std    
c0105f09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f0b:	fc                   	cld    
c0105f0c:	89 f8                	mov    %edi,%eax
c0105f0e:	89 f2                	mov    %esi,%edx
c0105f10:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105f13:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105f16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105f1c:	83 c4 30             	add    $0x30,%esp
c0105f1f:	5b                   	pop    %ebx
c0105f20:	5e                   	pop    %esi
c0105f21:	5f                   	pop    %edi
c0105f22:	5d                   	pop    %ebp
c0105f23:	c3                   	ret    

c0105f24 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105f24:	55                   	push   %ebp
c0105f25:	89 e5                	mov    %esp,%ebp
c0105f27:	57                   	push   %edi
c0105f28:	56                   	push   %esi
c0105f29:	83 ec 20             	sub    $0x20,%esp
c0105f2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f38:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f41:	c1 e8 02             	shr    $0x2,%eax
c0105f44:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f4c:	89 d7                	mov    %edx,%edi
c0105f4e:	89 c6                	mov    %eax,%esi
c0105f50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f52:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f55:	83 e1 03             	and    $0x3,%ecx
c0105f58:	74 02                	je     c0105f5c <memcpy+0x38>
c0105f5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f5c:	89 f0                	mov    %esi,%eax
c0105f5e:	89 fa                	mov    %edi,%edx
c0105f60:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f63:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105f66:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f6c:	83 c4 20             	add    $0x20,%esp
c0105f6f:	5e                   	pop    %esi
c0105f70:	5f                   	pop    %edi
c0105f71:	5d                   	pop    %ebp
c0105f72:	c3                   	ret    

c0105f73 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f73:	55                   	push   %ebp
c0105f74:	89 e5                	mov    %esp,%ebp
c0105f76:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f82:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f85:	eb 30                	jmp    c0105fb7 <memcmp+0x44>
        if (*s1 != *s2) {
c0105f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f8a:	0f b6 10             	movzbl (%eax),%edx
c0105f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f90:	0f b6 00             	movzbl (%eax),%eax
c0105f93:	38 c2                	cmp    %al,%dl
c0105f95:	74 18                	je     c0105faf <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f9a:	0f b6 00             	movzbl (%eax),%eax
c0105f9d:	0f b6 d0             	movzbl %al,%edx
c0105fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105fa3:	0f b6 00             	movzbl (%eax),%eax
c0105fa6:	0f b6 c0             	movzbl %al,%eax
c0105fa9:	29 c2                	sub    %eax,%edx
c0105fab:	89 d0                	mov    %edx,%eax
c0105fad:	eb 1a                	jmp    c0105fc9 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105faf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105fb3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105fb7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fba:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105fbd:	89 55 10             	mov    %edx,0x10(%ebp)
c0105fc0:	85 c0                	test   %eax,%eax
c0105fc2:	75 c3                	jne    c0105f87 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105fc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105fc9:	c9                   	leave  
c0105fca:	c3                   	ret    
