SRC_DIR := src
LIB_DIR := lib

.PHONY: test
test:
	@busted --lua=`which luajit` --helper=test/bustedHelper.lua .
