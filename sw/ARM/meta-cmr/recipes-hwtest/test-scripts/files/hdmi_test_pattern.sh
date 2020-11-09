#! /bin/bash


# Script for initiating test pattern output via HDMI on CMR board

# Arg1 = addr Arg2 = val
write_reg() {
	i2cset -y 2 0x39 $1 $2 
}

###
# From Section 3 - Quick Start Guide
###

###
# Power-up the Tx (HPD must be high)
###

## 0x41[6] = 0b0 for power-up – power-down
write_reg 0x41 0x10

# Fixed registers that must be set on power up
## 0x98 = 0x03
write_reg 0x98 0x03
## 0x9A[7:5] = 0b111
write_reg 0x9A 0xE0
## 0x9C = 0x30
write_reg 0x9C 0x30
## 0x9D[1:0] = 0b01
write_reg 0x9D 0x61
## 0xA2 = 0xA4
write_reg 0xA2 0xA4
## 0xA3 = 0xA4
write_reg 0xA3 0xA4
## 0xE0[7:0] = 0xD0
write_reg 0xE0 0xD0
## 0xF9[7:0] = 0x00
write_reg 0xF9 0x00

###
# Set up the video input mode:
###

## 0x15[3:0] – Video Format ID (YCbCr 4:2:2, 2x pixel clock and embedded syncs)
write_reg 0x15 0x04

# Table 21 - 0x48[4:3]=01(right justified)
write_reg 0x48 0x04

## 0x16[7] – Output Format (1 = 4:2:2)
## 0x16[5:4] – Input Color Depth (11 = 8 bit)
## 0x16[3:2] – Video Input Style (01 = style 2)
## 0x16[1] – DDR Input Edge (1 = rising edge)
## 0x16[0] – Output Colorspace for Black Image
write_reg 0x16 0xB4

## 0x17[1] – Aspect ratio of input video (4x3 = 0b0, 16x9 = 0b1)
write_reg 0x17 0x02


###
# Set up the video output mode:
###

## 0x18[7] = 0b1 for YCbCr to RGB – CSC Enable
## 0x18[6:5] = 0b00 for YCbCr to RGB – CSC Scaling Factor
write_reg 0x18 0xC6

## 0xAF[1] = 0b1 for HDMI – Manual HDMI or DVI mode select
write_reg 0xAF 0x16

## 0x40[7] = 0b1 – Enable GC
write_reg 0x40 0x80


## 0x4C[3:0] – Output Color Depth and General Control Color Depth (GC CD)
write_reg 0x4C 0x84


###
# Related to embedded sync generation (See Table 33-35)
###

write_reg 0x35 0x40
write_reg 0x36 0xD9
write_reg 0x37 0x0A
write_reg 0x38 0x00
write_reg 0x39 0x2D
write_reg 0x3A 0x00

write_reg 0xD7 0x1B
write_reg 0xD8 0x82
write_reg 0xD9 0x80
write_reg 0xDA 0x14
write_reg 0xDB 0x05

write_reg 0x30 0x1B
write_reg 0x31 0x82
write_reg 0x32 0x80
write_reg 0x33 0x14
write_reg 0x34 0x05


###
# HDCP
###

## 0xAF[7] = 0b1 for enable HDCP
## 0x97[6] – BKSV Interrupt Flag (Wait for value to be 0b1 then write 0b1)


###
# Audio setup
###

## 0x01 – 0x03 = 0x001800 for 48kHz - N Value
## 0x0A[6:4] – Audio Select (I2S = 0b000, SPDIF = 0b001, DSD = 0b010, HBR = 0b011, DST = 0b011) Audio Mode
## 0x0B[7] = 0b1 – SPDIF Enable
## 0x0C[5:2] = 0b1111 – I2S Enable
## 0x46 = 0xFF – DSD Enable
## 0x15[7:4] – I2S Sampling Frequency
## 0x0A[3:2] – Audio Mode
## 0x0A[3:2] – Audio Select

