PACKAGE=rayd-base

BUILD=debug
DUB_FLAGS=

WIN32_CC=i686-w64-mingw32-gcc
WIN32_FLAGS=-Llib/raylib-bin/windows.x86 -lraylib
WIN32_BUILD_PATH=build/win32
WIN32_BUILD_LIB=$(WIN32_BUILD_PATH)/lib$(PACKAGE).a
WIN32_BUILD_EXE=$(WIN32_BUILD_PATH)/$(PACKAGE).exe
WIN32_RAYLIB=lib/raylib-bin/windows.x86/raylib.dll

LINUX32_CC=gcc
LINUX32_FLAGS=-m32 -Wl,--start-group $(CURDIR)/lib/raylib-bin/linux.x86/libraylib.so -Wl,--end-group -Wl,-rpath,$(CURDIR)/lib/raylib-bin/linux.x86 -Wl,-rpath-link,$(CURDIR)/lib/raylib-bin/linux.x86
LINUX32_BUILD_PATH=build/linux32
LINUX32_BUILD_LIB=$(LINUX32_BUILD_PATH)/lib$(PACKAGE).a
LINUX32_BUILD_EXE=$(LINUX32_BUILD_PATH)/$(PACKAGE)

LINUX64_CC=gcc
LINUX64_FLAGS=-Wl,--start-group $(CURDIR)/lib/raylib-bin/linux.x86_64/libraylib.so -Wl,--end-group -Wl,-rpath,$(CURDIR)/lib/raylib-bin/linux.x86_64 -Wl,-rpath-link,$(CURDIR)/lib/raylib-bin/linux.x86_64
LINUX64_BUILD_PATH=build/linux64
LINUX64_BUILD_LIB=$(LINUX64_BUILD_PATH)/lib$(PACKAGE).a
LINUX64_BUILD_EXE=$(LINUX64_BUILD_PATH)/$(PACKAGE)

WEB_CC=emcc
WEB_FLAGS=-s USE_GLFW=3
WEB_BUILD=build/web
WEB_BUILD_PATH=build/web
WEB_BUILD_LIB=$(WEB_BUILD_PATH)/lib$(PACKAGE).a
WEB_BUILD_EXE=$(WEB_BUILD_PATH)/index.html
WEB_RAYLIB=lib/raylib-bin/wasm/libraylib.bc

default:
	dub build --compiler=ldc --build=$(BUILD) --parallel $(DUB_FLAGS)

run:
	dub --compiler=ldc --build=$(BUILD) --parallel


# Windows 32
$(WIN32_BUILD_LIB): dub.json source/
	dub build --compiler=ldc --config=win32 --build=$(BUILD) --parallel $(DUB_FLAGS)

$(WIN32_BUILD_EXE): $(WIN32_BUILD_LIB)
	$(WIN32_CC) $^ -o $@ $(WIN32_FLAGS)

win32: $(WIN32_BUILD_EXE)

zip-win32: win32
	cd $(WIN32_BUILD_PATH) && zip $(PACKAGE)-win32 *.{dll,exe}


# Linux 32
$(LINUX32_BUILD_LIB): dub.json source/
	dub build --compiler=ldc --config=linux32 --build=$(BUILD) --parallel $(DUB_FLAGS)

$(LINUX32_BUILD_EXE): $(LINUX32_BUILD_LIB)
	$(LINUX32_CC) $^ -o $@ $(LINUX32_FLAGS)

linux32: $(LINUX32_BUILD_EXE)

zip-linux32: linux32
	cd $(LINUX32_BUILD_PATH) && zip $(PACKAGE)-linux32 $(PACKAGE) *.so* *.sh


# Linux 64
$(LINUX64_BUILD_LIB): dub.json source/
	dub build --compiler=ldc --config=linux64 --build=$(BUILD) --parallel $(DUB_FLAGS)

$(LINUX64_BUILD_EXE): $(LINUX64_BUILD_LIB)
	$(LINUX64_CC) $^ -o $@ $(LINUX64_FLAGS)

linux64: $(LINUX64_BUILD_EXE)

zip-linux64: linux64
	cd $(LINUX64_BUILD_PATH) && zip $(PACKAGE)-linux64 $(PACKAGE) *.so* *.sh


# web
$(WEB_BUILD_LIB): dub.json source/
	dub build --compiler=ldc --config=web --build=$(BUILD) --parallel $(DUB_FLAGS)

$(WEB_BUILD_EXE): $(WEB_BUILD_LIB) $(WEB_RAYLIB)
	$(WEB_CC) $^ $(WEB_FLAGS) -o $@

web: $(WEB_BUILD_EXE)

web-host:
	http-server -c-1 $(WEB_BUILD_PATH)

zip-web: web
	cd $(WEB_BUILD_PATH) && zip $(PACKAGE)-web *.{js,wasm,html,css}


all: win32 linux32 linux64 web
zip-all: zip-win32 zip-linux32 zip-linux64 zip-web 
