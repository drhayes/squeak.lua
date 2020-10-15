.PHONY: test
test:
	@busted --lua=`which luajit` test/
