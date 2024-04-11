SCHLORNG-DE, the best text editor in the world (ctrl-backspace still not supported)

This text editor was honestly just a fun little side-project, that turned into a 
massive pain in the ass. This text editor is also kinda finnicky, and was written
on windows with visual studio and then itself around the end.


SETUP:
1. Get your lua files (lua 5.4 recommended, as it was used throughout this)
2. Drop your dll file (or .so if you're a NERD) into the same dir as "bossman.lua"
3. Put your "lua.h", "lauxlib.h", "lualib.h", and "luaconf.h" into the include dir
4. Compile (gcc recommended)
5 (optional). Customize
6 (optional, and for linux/mac). Create a bash/zsh script to replace SDE.bat
7. (optional, but very recommended, for windows) add the dir containing SDE.bat to
your PATH
8. Pass a valid file (name in your current dir) to the executable, it should load
correctly, and then you can mess around as much as you want (you won the tutorial)


SHORTCUTS:
In mark (menu) mode:
	t --switch to text mode
	s --save file
	q --mark quit
In text mode:
	esc --switch to motion mode
	literally any other key --type that key
In motion mode:
	0-9 --set multiplier
	h --left (by multiplier)
	l --right (by multiplier)
	esc --back to text mode
	m --switch to mark mode


ISSUES:
Stuck on the first screen?
	Press T, it'll set you to text mode, and then press any other key to continue
To all the other issues:
	You can always just fork this and rewrite it to fit your own needs
	(though I'll never look at you in the same way again for that betrayal)


FINAL NOTES:
The colors in the config use ansi escape sequences
Also, you get stuck with my config when you start this, cause its just that good
(I like purple)