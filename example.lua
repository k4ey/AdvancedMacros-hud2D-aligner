--we import the library

local Line = run("./line.lua")
local Text = run("./text.lua")
local Item = run("./item.lua")
-- to show text "Hello World at the left top corner of our screen, we should follow these steps:"

-- we createa new line object and provide arguments:
-- "left" - that means the line will be aligned to the LEFT side of the screen
-- {} - an empty table, here we will store our Text / Item objects.
local l = Line:new("left",{})

-- we createa new text object and provide arguments:
-- "Hello World!" - this will be the text displayed
-- "abc" - an unique identifier of this object, it can be later used to find it in the elements list and change its text for example.
local text = Text:new("Hello World!","abc")
-- we append our newly created Text object to the line we created before.
l:append(text)
-- and now we align the line elements!
l:align()



-- to add a new item element, we just do the same thing
local item = Item:new("diamond")
l:append(item)
l:align()
-- happy coding!
