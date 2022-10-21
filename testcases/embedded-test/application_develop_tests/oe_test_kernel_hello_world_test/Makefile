KERNELDIR := ${KERNEL_SRC_DIR}
CURRENT_PATH := $(shell pwd)

target := kernel_hello_world
obj-m := $(target).o

build := kernel_modules

kernel_modules:
	$(MAKE) -C $(KERNELDIR) M=$(CURRENT_PATH) modules
clean:
	$(MAKE) -C $(KERNELDIR) M=$(CURRENT_PATH) clean
