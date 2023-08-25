---@return Item

---@class Item
local Item = {}


---@param item string String to show
---@param uuid? string Unique identifier used for editing the text later
---@param margin? number Margin
---@return Item
function Item:new(item,uuid,margin)
    local newItem = setmetatable({}, self)
    self.__index = self
    newItem:init(item,uuid,margin)
    return newItem
end

--- Item obj initializator
function Item:init(text,uuid,margin)
    assert(type(text) == "string" and type(uuid) == "nil" or type(uuid) == "string")
    self.text = text
    self.uuid = uuid or tostring(math.random(0,9999))
    self.margin = margin or 0
    self.element = hud2D.newItem(text,0,0)
end

---Returns size of an element. <br> This does not error when element is gone!
---@see https://github.com/AdvancedMacros/AdvancedMacros/blob/1.12.2/src/main/java/com/theincgi/advancedMacros/hud/hud2D/Hud2d_itemIcon.java
---@return number width 
---@return number height
function Item:getSize()
    return 16, 16
end

function Item:__tostring()
    return "Item:new( "..table.concat({self.text,self.uuid},",").." )"
end

---gets element
function Item:getElement()
    assert(self.element,"Element is gone, please create new Item object.")
    return self.element
end

---Moves the hud element to desired position.
---@param x number
---@param y number
function Item:move(x,y)
    self:getElement().setX(x)
    self:getElement().setY(y)
end

---Shows the element.
function Item:show()
    self:getElement().enableDraw()
end

---Hides the element.
---to delete
---@see Item:delete()
function Item:hide()
    self:getElement().disableDraw()
end

---removes the element completely.
function Item:delete()
    self:hide()
    self.element = nil
    self.uuid = nil
end

---changes text of given element. Call to align is needed to align the items again!
---@param text string
function Item:changeItem(text)
    self.element.setItem(text)
end

return Item
