.PHONY: upload clean

all: main.bin

mem_init.v: splash.rb splash.xpm
	ruby splash.rb splash.xpm > mem_init.v

%.blif: %.v *.v mem_init.v
	yosys -p "read_verilog $<; synth_ice40 -blif $@"

%.pnr: %.blif
	arachne-pnr -d 1k -p go-board.pcf -P vq100 -o $@ $<

%.bin: %.pnr
	icepack $< $@

upload: main.bin
	iceprog main.bin

clean:
	rm -f *.bin *.pnr *.blif mem_init.v
