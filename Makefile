PACKAGE=rayd-base

DUB_PREREQUISITES=dub.json source

WIN32_CC=i686-w64-mingw32-gcc
WIN32_FLAGS=-Llib/raylib-bin/windows.x86 -lraylib
WIN32_BUILD_PATH=build/win32
WIN32_BUILD_LIB=$(WIN32_BUILD_PATH)/lib$(PACKAGE).a
WIN32_BUILD_EXE=$(WIN32_BUILD_PATH)/$(PACKAGE).exe
WIN32_RAYLIB=lib/raylib-bin/windows.x86/raylib.dll

WEB_CC=emcc
WEB_FLAGS=-s USE_GLFW=3
WEB_BUILD=build/web
WEB_BUILD_PATH=build/web
WEB_BUILD_LIB=$(WEB_BUILD_PATH)/lib$(PACKAGE).a
WEB_BUILD_EXE=$(WEB_BUILD_PATH)/index.html
WEB_RAYLIB=lib/raylib-bin/wasm/libraylib.bc


$(WEB_BUILD_LIB): $(DUB_PREREQUISITES)
	dub build --compiler=ldc --config=web --parallel

$(WEB_BUILD_EXE): $(WEB_BUILD_LIB) $(WEB_RAYLIB)
	$(WEB_CC) $^ $(WEB_FLAGS) -o $@

web: $(WEB_BUILD_EXE)

web-host:
	http-server -c-1 $(WEB_BUILD_PATH)

zip-web: web
	cd $(WEB_BUILD_PATH) && zip $(PACKAGE)-web *.{js,wasm,html,css}


$(WIN32_BUILD_LIB): $(DUB_PREREQUISITES)
	dub build --compiler=ldc --config=win32 --parallel

$(WIN32_BUILD_EXE): $(WIN32_BUILD_LIB)
	$(WIN32_CC) $^ -o $@ $(WIN32_FLAGS)

win32: $(WIN32_BUILD_EXE)

zip-win32: win32
	cd $(WIN32_BUILD_PATH) && zip $(PACKAGE)-win32 *.{dll,exe}


zip-all: zip-web zip-win32
