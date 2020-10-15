SRC_DIR := src
LIB_DIR := lib

.PHONY: test
test: src/lib
	@busted --lua=`which luajit` .

src/lib:
	ln -s $(abspath $(LIB_DIR)) $(abspath $(SRC_DIR)/$(LIB_DIR))
