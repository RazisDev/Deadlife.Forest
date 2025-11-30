-- KillerCameraController.lua (Counter-Strike Style)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

local Controller = {}
Controller.enabled = false
Controller.connection = nil
Controller.root = nil
Controller.humanoid = nil

local mouseSensitive = 0.3
local yaw = 0 -- horizontal rotate
local pitch = 0 -- vertical rotate

function Controller:Enable(root)
	if self.enabled then
		self:Disable()
	end

	self.enabled = true
	self.root = root
	self.humanoid = root.Parent:FindFirstChildOfClass("Humanoid")
	self.humanoid.AutoRotate = false

	-- Save old camera state
	self._oldType = cam.CameraType
	self._oldSubject = cam.CameraSubject

	cam.CameraType = Enum.CameraType.Scriptable
	cam.CameraSubject = nil
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

	-- Reset look angles
	yaw = 0
	pitch = 0

	-- MAIN LOOP
	self.connection = RunService.RenderStepped:Connect(function(dt)
		if not self.root then
			return
		end
		cam.FieldOfView = 100
		-- Mouse look
		local delta = UserInputService:GetMouseDelta()
		yaw -= delta.X * mouseSensitive
		pitch -= delta.Y * mouseSensitive

		-- Clamp up/down look
		pitch = math.clamp(pitch, -80, 80)

		self.root.CFrame = CFrame.new(self.root.Position) * CFrame.Angles(0, math.rad(yaw), 0)

		cam.CFrame = self.root.CFrame * CFrame.Angles(math.rad(pitch), 0, 0) * CFrame.new(0, 1.5, 0)
	end)
end

function Controller:Disable()
	if not self.enabled then
		return
	end

	self.enabled = false

	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end

	-- restore states
	cam.CameraType = self._oldType
	cam.CameraSubject = self._oldSubject
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default

	if self.humanoid then
		self.humanoid.AutoRotate = true
	end
end

return Controller
