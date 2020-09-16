AS = /usr/bin/as
LD = /usr/bin/ld

wtf-server:
	$(AS) -o wtf-server.o wtf-server.s
	$(LD) -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -o wtf-server wtf-server.o

clean:
	rm -f ./wtf-server.o ./wtf-server
