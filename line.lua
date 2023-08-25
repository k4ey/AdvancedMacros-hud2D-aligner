---@return Line

---@class Line
local Line = {}

---@class Text
local Text = run("./text.lua")
---@class Item
local Item = run("./item.lua")


---@param position positions
---@param elements (Text | Item)[]
---@param tresholdX? number
---@param tresholdY? number TresholdY does not currently work.
---I wanted to allow for vertical orientation, but this would require rewriting all of the positioning again so lets just stick to this. If you want a column like structure just set the tresholdX to 0
function Line:new(position,elements,tresholdX, tresholdY)
    local newLine = setmetatable({}, self)
    self.__index = self
    newLine:init(position,elements,tresholdX, tresholdY)
    return newLine
end

--- Line obj initializator
---@param position positions
---@param elements (Text | Item)[]
---@param tresholdX? number
---@param tresholdY? number
function Line:init(position,elements,tresholdX, tresholdY)
    self.position = position
    self.elements = elements
    local width, height = hud2D.getSize()
    self.tresholdX, self.tresholdY = tresholdX or width, tresholdY or height
end

---Returns size of an entire line.
---@return number width 
---@return number height
function Line:getSize()
    local sizeX = 0
    local sizeY = 0
    for _, element in pairs(self:getElements()) do
        local x, y = element:getSize()
        sizeX = sizeX + x
        sizeY = sizeY + y
    end
    return sizeX, sizeY
end

---Returns maximum size of a line
---@return number width 
---@return number height
function Line:getMaxSize()
    local maxX = 0
    local maxY = 0
    for _, element in pairs(self:getElements()) do
        local sizeX, sizeY = element:getSize()
        maxX = (sizeX > maxX) and sizeX or maxX
        maxY = (sizeY > maxY) and sizeY or maxY
    end
    return maxX, maxY
end

function Line:__tostring()
    return "Line:new( "..table.concat({},",").." )"
end

---gets elements
---@return Text[]
function Line:getElements()
    assert(#self.elements > 0 ,"No elements, please create new Line object.")
    return self.elements
end

---Shows all elements.
function Line:show()
    for _, element in pairs(self:getElements()) do
        element:show()
    end
end

---Hides all elements.
function Line:hide()
    for _, element in pairs(self:getElements()) do
        element:hide()
    end
end

---Fits the elements so that they do not cross the treshold
---@return Line[]
function Line:horizontalFit()
    local maxWidth = self.tresholdX
    local lines = {}
    local line = {}
    local width = 0
    for _, element in pairs(self:getElements()) do
        local elemWidth = element:getSize()
        if elemWidth > maxWidth then
            maxWidth = elemWidth
        elseif elemWidth + width  >= maxWidth then
            lines[#lines+1] = Line:new(self.position, line, self.tresholdX, self.tresholdY)
            line = {}
            width = 0
        end
        line[#line+1] = element
        width = width + elemWidth
    end
    if #line > 0 then
        lines[#lines+1] = Line:new(self.position, line, self.tresholdX, self.tresholdY)
    end
    return lines
end


---Helper function for fitting the lines. I wanted to allow for vertical fitting too, but failed :D
---@return Line[]
function Line:fit()
    return self:horizontalFit()
end

---Aligns line to the left
function Line:alignLeft()
    local y = 0
    local x = 0
    local lines = self:fit()
    for _, line in pairs(lines) do
        local _, maxHeight = line:getMaxSize()
        for _, element in pairs(line:getElements()) do
            local sizeX = element:getSize()

            -- get maximum value
            element:move(x,y)
            element:show()
            x = x + sizeX
        end
        x = 0
        y = y + maxHeight
    end
end

---Aligns line to the right
function Line:alignRight()
    local y = 0
    local lines = self:fit()
    for _, line in pairs(lines) do
        local _, maxHeight = line:getMaxSize()
        -- 6 is a magic number cuz some carriage return or smth is always at the end.
        local x = hud2D:getSize()
        for _, element in pairs(line:getElements()) do
            local elemWidth = element:getSize()

            element:move(x - elemWidth,y)
            element:show()
            x = x - elemWidth
        end
        y = y + maxHeight
    end
end

---Aligns line to the center
function Line:alignCenter()
    local windowSizeX = hud2D.getSize()
    local y = 0
    local lines = self:fit()
    for _, line in pairs(lines) do
        local _, maxHeight = line:getMaxSize()
        local totalWidth = line:getSize()
        local x = (windowSizeX - totalWidth) / 2
        for _, element in pairs(line:getElements()) do
            local sizeX = element:getSize()
            element:move(x,y)
            element:show()
            x = x + sizeX
        end
        y = y + maxHeight
    end
end

---Adds element
---@param element Text | Item
function Line:append(element)
    self.elements[#self.elements+1] = element
end

---Removes element
---@param element Text | string
function Line:remove(element)
    local uuid
    if element.uuid then
        uuid = element.uuid
    elseif type(element) == "string" then
        uuid = element
    end
    for i, elem in pairs(self:getElements()) do
        if uuid == elem.uuid then
            elem:delete()
            table.remove(self.elements,i)
        end
    end
end

---Aligns the line towards its original position.
function Line:align()
    if self.position == "left" then
        self:alignLeft()
    elseif self.position == "right" then
        self:alignRight()
    elseif self.position == "center" then
        self:alignCenter()
    end
end

---Finds element with given uuid
---@param uuid string
---@return Text | nil
function Line:getElement(uuid)
    for _, element in pairs(self:getElements()) do
        if element.uuid == uuid then return element end
    end
    return nil
end

---Changes text of element with given UUID. AND forces aligning again
---@param uuid string
---@param text string
function Line:changeTextOfElement(uuid,text)
    local element = self:getElement(uuid)
    assert(element, "could not find element with given uuid! uuid:\n"..uuid)
    element:changeText(text)
    self:align()
end

return Line
