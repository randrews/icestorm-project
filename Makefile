.PHONY: upload clean

all: main.bin

%.blif: %.v *.v
	yosys -p "read_verilog $<; synth_ice40 -blif $@"

%.pnr: %.blif
	arachne-pnr -d 1k -p go-board.pcf -P vq100 -o $@ $<

%.bin: %.pnr
	icepack $< $@

upload: main.bin
	iceprog main.bin

clean:
	rm -f *.bin *.pnr *.blif
