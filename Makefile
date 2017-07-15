###########################################################
#              Makefile for AVR projects                  #
###########################################################

# HERE: set output binary name
OUT           = blinky
MCU           = atmega328p
CPU_FREQ      = 16000000
PORT          = /dev/ttyUSB0

# HERE: add C files
C_FILES      += main.c

# HERE: add include directories
INCLUDEDIRS  += .

CFLAGS       += -Os
CFLAGS       += -DF_CPU=$(CPU_FREQ)UL
CFLAGS       += -mmcu=$(MCU)
CFLAGS       += -Wall

LDFLAGS      += 

###########################################################

CC             = avr-gcc
OBJCOPY        = avr-objcopy
MK             = mkdir
RM             = rm -rf

OUTDIR         = _build

remduplicates = $(strip $(if $1,$(firstword $1) $(call remduplicates,$(filter-out $(firstword $1),$1))))

C_FILENAMES   = $(notdir $(C_FILES))
C_PATHS       = $(call remduplicates, $(dir $(C_FILES)))
C_OBJS        = $(addprefix $(OUTDIR)/, $(C_FILENAMES:.c=.o))
DEPS          = $(C_OBJS:.o=.d)
INCLUDEPATHS  = $(addprefix -I, $(INCLUDEDIRS))

vpath %.c $(C_PATHS)



.PHONY: all install clean

all: $(OUTDIR)/$(OUT).hex


# Create output directory
$(OUTDIR):
	$(MK) $@

-include $(DEPS)

# Create objects from C source files
$(OUTDIR)/%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDEPATHS) -c $< -o $@ -MMD -MF $(@:.o=.d)


# Link C objects to an .elf file
$(OUTDIR)/$(OUT).elf: $(OUTDIR) $(C_OBJS)
	$(CC) $(LDFLAGS) $(C_OBJS) -o $(OUTDIR)/$(OUT).elf


# Convert .elf file to .hex
$(OUTDIR)/$(OUT).hex: $(OUTDIR)/$(OUT).elf
	$(OBJCOPY) -O ihex $< $@


# Program device
install: $(OUTDIR)/$(OUT).hex
	avrdude -v -c arduino -p $(MCU) -P $(PORT) -b 115200 -U flash:w:$<

# Do the clean-up
clean:
	$(RM) $(OUTDIR)

