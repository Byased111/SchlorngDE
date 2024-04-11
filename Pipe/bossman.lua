--BOSSMAN.LUA:
--the programs lua entry point

print("bossman: opening")
--get the requires out of the way first
local Enums = require("Enums")
print("Enums loaded")
local Config = require("Config")
print("Config loaded")
local KeyCode = require("AnsiCodes")
print("KeyCodes loaded")
print("requires loaded")

--define functions
local function printn(...)
	io.write(string.format(...))
end

local function AnsiCommand(...)
	--only used for the sake of readability
	printn(string.format(...))
end

local function ReformatToLineArray(str)
	local LineArray = {}
	for line in string.gmatch(str, "[^\r\n]*") do --that * does gods work bro
		table.insert(LineArray, line)
	end
	return LineArray
end

----writing funcs
local function DrawHeader(Filename, mode, index)
	AnsiCommand("\x1b[48;5;%dm\x1b[38;5;%dm", Config.Graphics.HeaderBackgroundColor, Config.Graphics.HeaderForegroundColor)
	printn("${"..Filename.."}$: in "..mode.." mode, at index: "..index.."\n")
	AnsiCommand("\x1b[0m")
end

local function WriteInput(str, arr, index)
	str = "" --reset
	local taggedline = 1
	local keeptagging = true
	for i = 1, #arr do
		if not (i == index) then
			if ((keeptagging == true) and (arr[i] == string.byte('\n'))) then
				taggedline = taggedline + 1
			end
			str = str..string.format("%c", arr[i])
		else
			keeptagging = false
			str = str..string.format("\x1b[38;5;%dm\x1b[48;5;%dm%c\x1b[0m", Config.Graphics.HighlightForegroundColor, Config.Graphics.HighlightBackgroundColor, arr[i])
		end
	end
	local StrArr = ReformatToLineArray(str)
	
	local half = ((Config.Graphics.ScreenRows - 3)/2)
	--[[local orighalf = half

	if half > taggedline then
		half = 0
	end
	]]
	for i = taggedline - math.floor(half), taggedline - 1--[[ + Config.Graphics.ScreenRows - 3]] do
		if (i == taggedline) then
			if Config.Graphics.LinesUseBgColor == true then
				ConWrite(string.format("\x1b[38;5;%dm\x1b[48;5;%dm%4d%s\x1b[0m%s\n", Config.Graphics.LineForegroundColor, Config.Graphics.LineBackgroundColor, Config.Graphics.LineSeparator, i, StrArr[i]))
			elseif Config.Graphics.LinesUseBgColor == false then
				ConWrite(string.format("\x1b[38;5;%dm%4d%s\x1b[0m%s\n", Config.Graphics.LineForegroundColor, i, Config.Graphics.LineSeparator, StrArr[i]))
			end
		else
			if not (StrArr[i]) then
				ConWrite("~\n")
			else
				ConWrite(string.format("%4d%s%s\n", i, Config.Graphics.LineSeparator, StrArr[i]))
			end
		end
	end
--[[	if half == 0 then
		half = orighalf*2 --set it back just in case
	end]]
	for i = taggedline, taggedline + math.ceil(half)--[[ + Config.Graphics.ScreenRows - 3]] do
		if (i == taggedline) then
			if Config.Graphics.LinesUseBgColor == true then
				ConWrite(string.format("\x1b[38;5;%dm\x1b[48;5;%dm%4d%s\x1b[0m%s\n", Config.Graphics.LineForegroundColor, Config.Graphics.LineBackgroundColor, Config.Graphics.LineSeparator, i, StrArr[i]))
			elseif Config.Graphics.LinesUseBgColor == false then
				ConWrite(string.format("\x1b[38;5;%dm%4d%s\x1b[0m%s\n", Config.Graphics.LineForegroundColor, i, Config.Graphics.LineSeparator, StrArr[i]))
			end
		else
			if not (StrArr[i]) then
				ConWrite("~\n")
			else
				ConWrite(string.format("%4d%s%s\n", i, Config.Graphics.LineSeparator, StrArr[i]))
			end
		end
	end
end

--all encompassing write func
local function WRITE_ALL(title, mode, str, arrgh, index)
	ConClrW()
	DrawHeader(title, mode, index)
	WriteInput(str, arrgh, index)
end

print("functions defined")


--define variables
local PROGRAM_IS_ON = true
local PGRM_MODE
local FilePath = GetFileName()

local OPENED_FILE

local CurrentMode = Enums.Modes.Mark
local CurrentIndex = 1

local InputArray = {} --contains keycodes
local InputString = ""

local MoveMultiplier = 1
local AlphaLockEnabled = false

if not (FilePath) or (FilePath == "") then
	print("\x1b[38;5;3mFile path necessary when calling this executable!\nThe executable will now run in sandbox mode.\x1b[0m")
	PGRM_MODE = Enums.ProgramModes.Sandbox
	FilePath = "Sandbox mode"
else --load the file into the InputArray
	OPENED_FILE = io.open(FilePath, "r+")
	if not (OPENED_FILE) then
		printn("File was found, but was not able to be loaded (maybe you don't have permission to write?)\n")
	end
	local filetext = OPENED_FILE:read("*a")
	OPENED_FILE:close()
	for i = 1, filetext:len() do
		InputArray[i] = string.byte(filetext:sub(i,i))
	end
	OPENED_FILE = io.open(FilePath, "r+")
	PGRM_MODE = Enums.ProgramModes.FileOpen
end

--load file (if provided)
----this one might be a todo ngl because I am WAYYYY too tired rn for this

print("main loop starting")
while (PROGRAM_IS_ON == true) do
	--don't mind the fat main (cause this is essentially the main())
	local cc = cGetch();

	----------TEXT MODE----------
	if (CurrentMode == Enums.Modes.Text) then
		if (cc == KeyCode.Special.Escape) then --escape
			CurrentMode = Enums.Modes.Motion
			AlphaLockEnabled = false
		elseif (cc == KeyCode.Special.Backspace) then --backspace
			if (CurrentIndex > 1) then
				table.remove(InputArray, CurrentIndex - 1)
				CurrentIndex = CurrentIndex - 1
				AlphaLockEnabled = false
			end
		elseif (cc == KeyCode.Special.Enter) then --enter
			table.insert(InputArray, CurrentIndex, 10)
			CurrentIndex = CurrentIndex + 1
			AlphaLockEnabled = false
		else									--regular char
			if (cc == KeyCode.Special.Alpha) then
				AlphaLockEnabled = true
			elseif (AlphaLockEnabled == true) then --alpha lock
				if (cc == KeyCode.Special.Delete) then --delete
					AlphaLockEnabled = false
					if (CurrentIndex <= #InputArray) then
						table.remove(InputArray, CurrentIndex)
					end
				else
					AlphaLockEnabled = false
				end
			else										 --normal key
				table.insert(InputArray, CurrentIndex, cc)
				CurrentIndex = CurrentIndex + 1
			end
		end
		WRITE_ALL(FilePath, "Text", InputString, InputArray, CurrentIndex)
	----------MARK MODE----------
	elseif (CurrentMode == Enums.Modes.Mark) then
		if ((cc == KeyCode.Regular.t) or (cc == KeyCode.Regular.T)) then --switch to text mode
			CurrentMode = Enums.Modes.Text
		elseif ((cc == KeyCode.Regular.q) or (cc == KeyCode.Regular.Q)) then --mark quit
			PROGRAM_IS_ON = false
		elseif ((cc == KeyCode.Regular.s) or (cc == KeyCode.Regular.S)) then --save file
			if (PGRM_MODE == Enums.ProgramModes.FileOpen) then
				local StringForSaving = ""
				for i = 1, #InputArray do
					StringForSaving = string.format("%s%c", StringForSaving, InputArray[i])
				end
				--wipe and write
				OPENED_FILE:close()
				OPENED_FILE = io.open(FilePath, "w+")
				OPENED_FILE:write(StringForSaving)
				printn("saved!")
			else
				printn("You're in sandbox mode, run this with a file to save")
			end
		end
	----------MOTION MODE---------- aka vi
	elseif (CurrentMode == Enums.Modes.Motion) then
		if ((cc == KeyCode.Regular.m) or (cc == KeyCode.Regular.M)) then --switch to mark
			CurrentMode = Enums.Modes.Mark
		elseif (cc == KeyCode.Special.Escape) then --switch back to text
			CurrentMode = Enums.Modes.Text
		elseif ((cc == KeyCode.Special.LeftArrow) or (cc == KeyCode.Regular.h) or (cc == KeyCode.Regular.H)) then --move left
			if (CurrentIndex > MoveMultiplier) then
				CurrentIndex = CurrentIndex - MoveMultiplier
			end
		elseif (cc == KeyCode.Special.RightArrow or (cc == KeyCode.Regular.l) or (cc == KeyCode.Regular.L)) then --move right
			if (CurrentIndex <= #InputArray - MoveMultiplier + 1) then
				CurrentIndex = CurrentIndex + MoveMultiplier
			end
		elseif ((cc >= string.byte('0')) and (string.byte('9') >= cc)) then --multiplier
			MoveMultiplier = (cc - string.byte('0'))
		end
		WRITE_ALL(FilePath, "Motion (vi) ("..MoveMultiplier..")", InputString, InputArray, CurrentIndex)
	end
end
printn("bossman:ended\n")
if (PGRM_MODE == Enums.ProgramModes.Sandbox) then
	printn("it was probably a good idea to not open a file with this ngl\n")
else
	printn("releasing files...\n")
	OPENED_FILE:close()
end
--[[
Helpful references:
https://github.com/sepehrsohrabi/Decimal-Virtual-Key-Codes
https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
]]