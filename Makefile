
PROGRAM=example
SRC=example.c uart/uart.o bmp280/bmp280.c i2chw/twimaster.c
OBJ=$(SRC:.c=.o)


MCU=atmega328p
# AVRDUDE_MCU=$(MCU)
AVRDUDE_MCU=atmega328p
AVRDUDE_PROGRAMMER=arduino

CFLAGS=-Wall -Os -mmcu=$(MCU) -DUSE_LOGGING=1 -DF_CPU=16000000UL -std=gnu99
LDFLAGS=
AVRDUDE_FLAGS= -p$(AVRDUDE_MCU) -c $(AVRDUDE_PROGRAMMER) -P /dev/ttyUSB0 -b 57600

FORMAT=ihex

CC=avr-gcc
OBJCOPY=avr-objcopy
OBJDUMP=avr-objdump
AVRDUDE=avrdude

all: $(PROGRAM).hex $(PROGRAM).eep

program: $(PROGRAM).hex $(PROGRAM).eep
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$(PROGRAM).hex:i -U eeprom:w:$(PROGRAM).eep:i

program_flash: $(PROGRAM).hex
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$(PROGRAM).hex:i

program_eeprom: $(PROGRAM).eep
	$(AVRDUDE) $(AVRDUDE_FLAGS) eeprom:w:$(PROGRAM).eep:i

dump_eeprom:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U eeprom:r:eeprom.raw:r
	od -tx1 eeprom.raw

objdump: $(PROGRAM).elf
	$(OBJDUMP) --disassemble $<

.PRECIOUS : $(OBJ) $(PROGRAM).elf

%.hex: %.elf
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

%.eep: %.elf
	$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
		--change-section-lma .eeprom=0 -O $(FORMAT) $< $@

%.elf: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@ $(LDFLAGS)

%.o: %.c Makefile
	$(CC) -c $(CFLAGS) $< -o $@

%.s: %.c Makefile
	$(CC) -S -c $(CFLAGS) $< -o $@

%.o: %.S
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm -f $(PROGRAM).hex $(PROGRAM).eep $(PROGRAM).elf *.o *.s eeprom.raw \
		uart/*.o i2chw/*.o bmp280/*.o

.PHONY: all clean dump_eeprom program program_flash program_eeprom objdump

