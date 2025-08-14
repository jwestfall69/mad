all:
	make -C util
	make -C machine

clean:
	make -C util clean
	make -C machine clean

