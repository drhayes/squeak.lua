.PHONY: test
test:
	@busted --lua=`which luajit` --helper=test/bustedHelper.lua .
