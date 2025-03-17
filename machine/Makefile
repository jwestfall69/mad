MAIN_DIRS = $(wildcard */main/)
SOUND_DIRS = $(wildcard */sound/)

all: main sound
main:
	for DIR in $(MAIN_DIRS); do \
		make -C $$DIR; \
	done

sound:
	for DIR in $(SOUND_DIRS); do \
		make -C $$DIR; \
	done

clean: main-clean sound-clean
main-clean:
	for DIR in $(MAIN_DIRS); do \
		make -C $$DIR clean; \
	done

sound-clean:
	for DIR in $(SOUND_DIRS); do \
		make -C $$DIR clean; \
	done
