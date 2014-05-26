

# based on the Makefile by Alex Chadwick 
#    for generation of raspberry pi kernel images


# The toolchain to use. arm-none-eabi works, but there does exist 
# arm-bcm2708-linux-gnueabi.
ARMGNU ?= arm-none-eabi

#source folder
SOURCE = source/

#intermediate folder
BUILD = build/

#final folder
KERNEL = kernel/

#output kernel file
TARGET = kernel.img

#assembler listing file generated
LIST = kernel.list

#map file to generate
MAP = kernel.map

#linker script to use
LINKER = kernel.ld

#the name of the files to be compiled
OBJECTS := $(patsubst $(SOURCE)%.s,$(BUILD)%.o,$(wildcard $(SOURCE)*.s))

all: $(KERNEL) $(TARGET) $(LIST)

rebuild: all

#rule to make listing file
$(LIST) : $(BUILD)output.elf
	$(ARMGNU)-objdump -d $(BUILD)output.elf > $(KERNEL)$(LIST)

#rule to make image file
$(TARGET) : $(BUILD)output.elf
	$(ARMGNU)-objcopy $(BUILD)output.elf -O binary $(KERNEL)$(TARGET) 

#rule to make elf files
$(BUILD)output.elf : $(OBJECTS) $(LINKER)
	$(ARMGNU)-ld --no-undefined $(OBJECTS) -Map $(KERNEL)$(MAP) -o $(BUILD)output.elf -T $(LINKER)

#rule to make object files
$(BUILD)%.o: $(SOURCE)%.s $(BUILD)
	$(ARMGNU)-as -I $(SOURCE) $< -o $@

$(BUILD):
	mkdir $@

$(KERNEL):
	mkdir $@

clean : 
	-rm -rf $(BUILD)
	-rm -rf $(KERNEL)
