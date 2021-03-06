
SRCS = main.c bootstrap.s context_switch.s
OBJS = $(patsubst %.c, %.o, $(filter %.c, $(SRCS)))
OBJS += $(patsubst %.s, %.o, $(filter %.s, $(SRCS)))

TARGET = kernel.elf

CROSS_COMPILE = arm-none-eabi

CC = $(CROSS_COMPILE)-gcc
LD = $(CROSS_COMPILE)-ld
AS = $(CROSS_COMPILE)-as
GDB = $(CROSS_COMPILE)-gdb
OBJCOPY = $(CROSS_COMPILE)-objcopy
OBJDUMP = $(CROSS_COMPILE)-objdump
SIZE = $(CROSS_COMPILE)-size

CFLAGS = -march=armv6 -msoft-float
CFLAGS += -Os -Wall -Wall -Wextra -fPIC -nostartfiles -marm
LDFLAGS = -N -Ttext=0x10000

all : $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)
	$(SIZE) $(TARGET)

%.o : %.c %.s
	$(CC) $(CFLAGS) -c $<

qemu : all
	qemu-system-arm -M versatilepb -cpu arm1176 -nographic  -kernel $(TARGET)

clean:
	$(RM) -rf $(OBJS) $(TARGET)
