\ FORTH

." Efika 5200B Device Tree Supplement 20071114" cr
." (c) 2007 Genesi USA, Inc." cr
." http://www.powerdeveloper.org/ for support" cr cr

\ headerless

s" /openprom" find-device
       d# 20071114 encode-int s" device-tree-version" property
device-end

s" /builtin/ata" find-device
       s" mpc5200-ata" encode-string
       s" mpc5200b-ata" encode-string encode+
       s" compatible" property
device-end

s" /builtin/sound" find-device
   s" fsl,mpc5200-psc-ac97" encode-string
   s" fsl,mpc5200b-psc-ac97" encode-string encode+
   s" compatible" property

   0x2 encode-int
   0x2 encode-int encode+
   0x3 encode-int encode+
   s" interrupts" property

   \ Audio is on PSC2, just for informational purposes
   1 encode-int s" cell-index" property

   new-device
      s" codec@0" 2dup device-name device-type
      0x1 0x1 reg

      s" sound" encode-string
      s" device_type" property

      s" idt,stac9766" encode-string
      s" ac97-audio" encode-string encode+
      s" compatible" property
   finish-device
device-end

\ Quick test to see if AC97 is enabled
0xf0000b00 dup dup l@ 0x20 and
0= if
       ." Enabling AC97" cr
       dup l@ 0x20 or
       swap l!
else
       drop
then

\ SRAM compatibles
s" /builtin/sram" find-device
       s" mpc5200-sram" encode-string
       s" mpc5200b-sram" encode-string encode+
       s" compatible" property

       s" sram" device-type \ this is a contentious one
device-end

\ PIC compatibles
s" /builtin/pic" find-device
       s" mpc5200-pic" encode-string
       s" mpc5200b-pic" encode-string encode+
       s" compatible" property
device-end

\ Serial compatibles. Also fix cell-index and port-number as per bindings
s" /builtin/serial" find-device
       s" mpc5200-psc-uart" encode-string
       s" mpc5200b-psc-uart" encode-string encode+
       s" compatible" property

       \ Serial port is PSC1 for informational purposes, Linux 0-indexes it
       0 encode-int s" cell-index" property
       \ Since this is the main, always there, preferred serial port..
       0 encode-int s" port-number" property
device-end

\ Ethernet compatibles
s" /builtin/ethernet" find-device
       s" mpc5200-fec" encode-string
       s" mpc5200b-fec" encode-string encode+
       s" compatible" property
device-end

\ BestComm compatibles, interrupt mess
s" /builtin/bestcomm" find-device
       s" mpc5200-bestcomm" encode-string
       s" mpc5200b-bestcomm" encode-string
       encode+
       s" compatible" property

       \ make 16 interrupt property in a batch. We have to do the first one by
       \ hand simply because of the way encode+ works.

       0x3 encode-int 0x0 encode-int 0x3 encode-int encode+ encode+
       0x10 1 do
               0x3 encode-int encode+ i encode-int encode+ 0x3 encode-int encode+
       loop

       \ now we can store the damn thing
       s" interrupts" property
device-end

\ New USB binding - change one of the numbers here to disable it for older kernels
\ as this is a destructive change
1 1 = if
s" /builtin/usb" find-device
       s" usb-ohci" device-type
       s" " encode-string s" big-endian" property

       s" mpc5200-ohci" encode-string
       s" mpc5200-usb-ohci" encode-string encode+
       s" ohci-be" encode-string encode+
       s" compatible" property
device-end
then

\ Go into the root node and kill off any mention of CHRP
s" /" find-device
       s" efika" device-type
       s" Efika 5200B" encode-string s" CODEGEN,board" property
       s" Efika 5200B PowerPC System" encode-string s" CODEGEN,description" property
       s" bplan,efika" encode-string
       s" compatible" property
device-end

\ Fix the /builtin device-type for Linux
s" /builtin" find-device
       s" soc" device-type
device-end

\ ADDING NEW ENTRIES TO THE DEVICE TREE
\
\ Clock Distribution Module - need this to change baud rates etc. and turn off
\ clocks for power management. Useful little thing. Needs an entry to find the
\ address without guessing (in case they change it in the 512X)

\ Clock Distribution Module
." Adding Clock Distribution Module" cr

s" /builtin" find-device
new-device
       " cdm" 2dup device-name device-type
       " MPC52xx Clock Distribution Module" encode-string " .description" property
       0xf0000200 0x38 reg

       " mpc5200-cdm" encode-string
       " mpc5200b-cdm" encode-string
       encode+
       " compatible" property

finish-device

\ GPIO (Simple) Module
." Adding Simple GPIO Module" cr

s" /builtin" find-device
new-device
       s" gpio" 2dup device-name device-type
       s" MPC52xx Simple GPIO" encode-string s" .description" property
       0xf0000b00 0x40 reg

       s" mpc5200-gpio" encode-string
       s" mpc5200b-gpio" encode-string encode+
       s" compatible" property

       0x10000000 encode-int s" gpio-mask" property

       0x1 encode-int
       0x7 encode-int
       0x3 encode-int
       encode+ encode+
       s" interrupts" property
finish-device

\ GPIO (Wakeup) Module
." Adding Wakeup GPIO Module" cr

s" /builtin" find-device
new-device
       s" gpio-wkup" 2dup device-name device-type
       s" MPC52xx Wakeup GPIO" encode-string s" .description" property
       0xf0000c00 0x28 reg

       s" mpc5200-gpio-wkup" encode-string
       s" mpc5200b-gpio-wkup" encode-string
       encode+
       s" compatible" property

       0x30000000 encode-int s" gpio-mask" property

       0x1 encode-int
       0x8 encode-int encode+
       0x3 encode-int encode+
       0x1 encode-int encode+
       0x3 encode-int encode+
       0x3 encode-int encode+
       s" interrupts" property
finish-device

\
\ High resolution (General Purpose and Slice) Timers
\
\ We ignore slice timer 0 since critical interrupt handling in Linux
\ is curiously missing
." Adding Slice Timer 1" cr

s" /builtin" find-device
new-device
       s" slt" 2dup device-name device-type
       s" MPC52xx Slice Timer 1" encode-string " .description" property
       0xf0000710 0x10 reg

       s" mpc5200-slt" encode-string
       s" mpc5200b-slt" encode-string
       encode+
       s" compatible" property

       1 encode-int " cell-index" property

       \ The interrupt listed here is probably wrong
       0x1 encode-int
       0x0 encode-int encode+
       0x3 encode-int encode+
       s" interrupts" property
finish-device

\ Add all the GPTs to the device-tree
\ : gpt-add ( gpt-id -- )
\ depth
\ 1 > if
8 0 do i
       dup 7 <= if
               dup
               0x9 +
               swap dup
               0x10 *
               0xf0000600 +
               swap dup

               ." Adding General Purpose Timer " .d cr

               s" /builtin" find-device
               new-device

               s" gpt" 2dup device-name device-type
               swap 0x10 reg

               encode-int s" cell-index" property

               s" MPC52xx General Purpose Timer X"
               2dup + 1 -              \ get the character position of the X
               0x30 i + swap c!        \ store ascii character of timer number
               encode-string s" .description" property

               s" mpc5200-gpt" encode-string
               s" mpc5200b-gpt" encode-string encode+
               s" fsl,mpc5200-gpt" encode-string encode+
               s" fsl,mpc5200b-gpt" encode-string encode+
               s" compatible" property

               0x1 encode-int
               2 pick encode-int encode+
               0x3 encode-int encode+
               s" interrupts" property

               finish-device
       then
loop
\ then
\ ;

\ Add watchdog marker to GPT0
s" /builtin/gpt@f0000600" find-device
       s" " encode-string s" has-wdt" property
       s" " encode-string s" fsl,has-wdt" property
device-end

\ PHY for ethernet. Thanks to Domen Puncer for this.
." Adding Ethernet PHY" cr

s" /builtin" find-device
new-device
       1 encode-int s" #address-cells" property
       0 encode-int s" #size-cells" property
       s" mdio" 2dup device-name device-type
       s" mpc5200b-fec-phy" encode-string s" compatible" property
       0xf0003000 0x400 reg

       0x2 encode-int
       0x5 encode-int encode+
       0x3 encode-int encode+
       s" interrupts" property

       new-device
               s" ethernet-phy" 2dup device-name device-type
               0x10 encode-int s" reg" property

               my-self         \ save our phandle to stack
               ihandle>phandle
       finish-device
finish-device

s" /builtin/ethernet" find-device
       encode-int              \ phy's phandle
       s" phy-handle" property
device-end

\
\ HERE BE DRAGONS

\ SDRAM Controller (needed to enter deep sleep and turn off RAM clocks)
." Adding SDRAM Controller" cr

s" /builtin" find-device
new-device
       s" sdram" device-name
       s" memory-controller" device-type

       0xf0000100 0x10 reg

       s" MPC52xx SDRAM Memory Controller" encode-string s" .description" property

       s" mpc5200b-sdram" encode-string
       s" mpc5200-sdram" encode-string encode+
       s" compatible" property
finish-device

\ XLB Arbiter (pipeline/bestcomm stuff enabled here)
." Adding XLB Arbiter" cr

s" /builtin" find-device
new-device
       s" xlb" 2dup device-name device-type

       0xf0001f00 0x100 reg

       s" MPC52xx XLB Arbiter" encode-string s" .description" property

       s" mpc5200-xlb" encode-string
       s" mpc5200b-xlb" encode-string encode+
       s" compatible" property
finish-device

." " cr cr
." boot Frugalware Linux PPC" cr

\ Optionally uncomment and boot your Linux
\ experimental feature is libata.force=<mode> (with mode=mwdma0,mwdma1,mwdma2,udma0,umda1,udma2)
\ s" hd:1 vmlinuz root=/dev/sda3 console=ttyPSC0" $boot
\ s" hd:1 vmlinuz root=/dev/sda3 video=radeonfb" $boot
