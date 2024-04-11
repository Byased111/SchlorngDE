#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "include/lua.h"
#include "include/luaconf.h"
#include "include/lauxlib.h"
#include "include/lualib.h"

//make the functions that lua absolutely NEEDS in order for this to work
int cGetch(lua_State* L) {
	int result = getch();
	lua_pushinteger(L, result);
	return 1;
}

int ConClrW(lua_State* L) {
	fwrite("\x1b[H\x1b[0J", sizeof(char), 8, stdout);
	//system("cls") //use this if you don't care about speed
	return 0;
}

int ConWrite(lua_State* L) {
	int strn = lua_gettop(L); //juicy stack shenanigans
	const char* str = lua_tostring(L, strn);
	if (str)
		fwrite(str, sizeof(char), strlen(str), stdout);
	else {
		perror("Incorrect type sent, expected a string");
		return 1;
	}
	return 0;
}



int main(int argc, char** argv) {

	fprintf(stdout, "\x1b[?1049h");
	system("cls");

	fwrite("running!\n", sizeof(char), 9, stdout);

	fprintf(stdout, "Params (%s)(first, %s): %d, %s\n", "%d", "%s", argc, argv[1]);
	
	//LUA SETUP
	lua_State* L;
	L = luaL_newstate();
	luaL_openlibs(L);

	//give the lua files the necessary functions
	int GetFileName(lua_State * L) {
		lua_pushstring(L, argv[1]);
		return 1;
	}
	lua_register(L, "GetFileName", GetFileName);
	lua_register(L, "cGetch", cGetch);
	lua_register(L, "ConClrW", ConClrW);
	lua_register(L, "ConWrite", ConWrite);
	
	//open lua point of entry
	char TemporaryFilePath[257] = { '\0' };
	strcat_s(TemporaryFilePath, 256, argv[2]);
	/*argv[2] SHOULD be autosupplied by sde.bat (or sde.sh if this get fully ported to linux/mac)
	  and the exe should not be run standalone
	*/
	strcat_s(TemporaryFilePath, 256, "Pipe\\bossman.lua");
	TemporaryFilePath[256] = '\0';

	int f = luaL_dofile(L, TemporaryFilePath);
	if (f) {
		fprintf(stdout, "\x1b[38;5;1m");
		fprintf(stdout, "Errcode in opening file: %d\n", f);
		fprintf(stdout, "LuaExit: %s\n", lua_tostring(L, -1));
		lua_pop(L, 1);
		lua_close(L);
		fprintf(stdout, "\x1b[0m");
		fprintf(stdout, "\x1b[?1049l");
		return 1;
	}
	
	fwrite("closing...\n", sizeof(char), 11, stdout);

	lua_close(L);
	fprintf(stdout, "\x1b[?1049l");
	fprintf(stdout, "\x1b[38;5;104mThank you for using SchlorngDE!\n\x1b[0m");
	return 0;
}