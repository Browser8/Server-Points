
local ServerPointsUI = require "ServerPointsUI"

local oldMainScreen_render = MainScreen.render
local function newRender(self)
  oldMainScreen_render(self)

  if self.inGame and isClient() then
    self.bottomPanel:setHeight(self.pointsOption:getBottom())
  end
end

local oldMainScreen_instantiate = MainScreen.instantiate
function MainScreen:instantiate()
  oldMainScreen_instantiate(self)

  if self.inGame and isClient() then
    self.serverPoints = ServerPointsUI:new(getCore():getScreenWidth() / 2 - 400, getCore():getScreenHeight() / 2 - 300, 800, 600)
    self.serverPoints:initialise()
    self.serverPoints:setVisible(false)
    self.serverPoints:setAnchorRight(true)
    self.serverPoints:setAnchorBottom(true)
    self:addChild(self.serverPoints)

    local labelHgt = getTextManager():getFontHeight(UIFont.Large) + 8 * 2
    self.pointsOption = ISLabel:new(self.quitToDesktop.x, self.quitToDesktop.y + labelHgt + 16, labelHgt, string.upper(SandboxVars.ServerPoints.PointsName) .. " SHOP", 1, 1, 1, 1, UIFont.Large, true)
    self.pointsOption.internal = "POINTS"
    self.pointsOption:initialise()
    self.bottomPanel:addChild(self.pointsOption)
    self.render = newRender
    self.pointsOption.onMouseDown = function()
      getSoundManager():playUISound("UIActivateMainMenuItem")
      MainScreen.instance.serverPoints:setVisible(true)
    end
    self.pointsOption.onMouseMove = function(self)
      self.fade:setFadeIn(true)
    end
    self.pointsOption.onMouseMoveOutside = function(self)
      self.fade:setFadeIn(false)
    end
    self.pointsOption:setWidth(self.quitToDesktop.width)
    self.pointsOption.fade = UITransition.new()
    self.pointsOption.fade:setFadeIn(false)
    self.pointsOption.prerender = self.prerenderBottomPanelLabel
  end
end
