# BMP280 pressure sensor library for AVR (Arduino) in plain C

This library can be used to add BMP280 pressure and temperature
sensor from Bosch Sensortec to your AVR/Arduino projects.

## How to use the sample code

* Get an AVR/Arduino-based board with 3.3V power (I used Arduino Nano)
* Get a break-out board with BMP280 (I used GY-BMP280)
* Connect your 3.3V AVR/Arduino board to the BMP280 board using I2C:
	- GND at Arduino to GND at BMP280
	- 3.3V VCC to VCC
	- SDA to SDA
	- SCL to SCL
	- 3.3V VCC to SDO and CSB
* Connect the Arduno to your computer
* Run "`make`" and "`make program_flash`"
* Read the Arduino serial port ("`cat /dev/ttyUSB0`" when using Linux)

## How to use the library

* Copy the `bmp280/` and `i2chw/` subdirectories to your project.
* Adjust `bmp280/bmp280.c` (see the comments at the beginning)
* Edit your `Makefile` to compile `i2chw/i2cmaster.o` and `bmp280/bmp280.o`,
	and add these object files to your linker command.
* Profit! :-)

## Credits

This library uses the the [I2C/TWI master library](http://homepage.hispeed.ch/peterfleury/doxygen/avr-gcc-libraries/group__pfleury__ic2master.html) by Peter Fleury for its I2C configuration.

The `example.c` file uses the UART library by Peter Fleury for debugging output.

Apart from the above, the BMP280 library itself as well as the example file
is written by [Jan "Yenya" Kasprzak](https://www.fi.muni.cz/~kas/).



