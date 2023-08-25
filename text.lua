---@return Text

---@class Text
local Text = {}

---@alias positions
---| '"left"' # Aligned to the left
---| '"right"' # Aligned to the right
---| '"center"' # Aligned to the top center


---@param text string String to show
---@param uuid? string Unique identifier used for editing the text later
---@param margin? number Margin
---@return Text
function Text:new(text,uuid,margin)
    local newText = setmetatable({}, self)
    self.__index = self
    newText:init(text,uuid,margin)
    return newText
end

--- Text obj initializator
function Text:init(text,uuid,margin)
    assert(type(text) == "string" and type(uuid) == "nil" or type(uuid) == "string")
    self.text = text
    self.uuid = uuid or tostring(math.random(0,9999))
    self.margin = margin or 0
    self.magicCharAtEndLenght = 6
    self.element = hud2D.newText(text,0,0)
    self.fill = nil
end

---Returns size of an element. <br> This does not error when element is gone!
---@return number width 
---@return number height
function Text:getSize()
    if self.element then
        return self:getElement().getWidth() + self.margin - self.magicCharAtEndLenght, self:getElement().getHeight() + self.margin
    else
        return 0,0
    end
end

function Text:__tostring()
    return "Text:new( "..table.concat({self.text,self.uuid},",").." )"
end

---gets element
function Text:getElement()
    assert(self.element,"Element is gone, please create new Text object.")
    return self.element
end

---Moves the hud element to desired position.
---@param x number
---@param y number
function Text:move(x,y)
    self:getElement().setX(x)
    self:getElement().setY(y)
    local fill = self:getFill()
    if fill then
        fill.setX(x)
        fill.setY(y)
    end
end

---Shows the element.
function Text:show()
    self:getElement().enableDraw()
    local fill = self:getFill()
    if fill then
        fill.enableDraw()
    end
end

---Hides the element.
---to delete
---@see Text:delete()
function Text:hide()
    self:getElement().disableDraw()
    local fill = self:getFill()
    if fill then
        fill.disableDraw()
    end
end

---removes the element completely.
function Text:delete()
    self:hide()
    self.element = nil
    self.fill = nil
    self.uuid = nil
end

---Returns the fill object
---@return table
---@see Text:createFill()
function Text:getFill()
    return self.fill
end

---Creates a background for the text.
---@param r number red 0 - 1
---@param g number green 0 - 1
---@param b number blue 0 - 1
---@param a number opacity 0 - 1
function Text:createFill(r, g, b, a)
    local width, height = self:getSize()
    self.fill = hud2D.newRectangle(0,0,width, height)
    self.fill.setColor({r,g,b, a})
end

---changes text of given element. Call to align is needed to align the items again!
---@param text string
function Text:changeText(text)
    self.element.setText(text)
end

---Changes size of the text
---@param fontSize number
---note: changing the size might break some aligning. Reason:
---@see Text.magicCharAtEndLenght
---is not adjusted regarding the new size.
function Text:changeSize(fontSize)
    self.element.setTextSize(fontSize)
end

return Text
