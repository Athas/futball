all: engine.py

run: engine.py
	python3 futball.py

engine.py: engine/*.fut engine/lib
	futhark pyopencl --library engine/engine.fut -o engine

engine.c: engine/*.fut engine/lib
	futhark opencl --library engine/engine.fut -o engine

_engine.so: engine.c
	build_futhark_ffi engine

engine/lib: engine/futhark.pkg
	cd engine && futhark pkg sync

futball: engine.c futball.go engine.go
	go build

clean:
	rm -rf *.c *.o *.so *.pyc engine/lib engine.py futball
