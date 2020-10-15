-- Modify package.path to include our lib folder.
-- People using this framework will have to help it out and let it know where
-- it can find classic.lua and lume.lua, used in nearly every file.
package.path = package.path .. ';./lib/?.lua;'
