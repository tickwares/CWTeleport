local wait = task.wait
local players = game:GetService('Players')
local networkclient = game:GetService('NetworkClient')

local function waitforclass(parent, class)
    local object = parent:FindFirstChildWhichIsA(class)
    while typeof(object) ~= 'Instance' do
        object = parent:FindFirstChildWhichIsA(class)
        wait()
    end
    return object
end

local function waitforprop(parent, prop)
    local res = parent[prop]
    while type(res) == 'nil' do
        parent:GetPropertyChangedSignal(prop):Wait()
        res = parent[prop]
    end
    return res
end

local clientreplicator = networkclient:WaitForChild('ClientReplicator')
local localplayer = typeof(clientreplicator) == 'Instance' and clientreplicator:IsA('ClientReplicator') and clientreplicator:GetPlayer() or players.LocalPlayer
local character, humanoid, rootpart, backpack

local function loadcharacter()
    character = localplayer.Character
    humanoid = waitforclass(character, 'Humanoid')
    rootpart = waitforprop(humanoid, 'RootPart')
    backpack = waitforclass(localplayer, 'Backpack')
end

local function teleport(cf)
    if typeof(rootpart) == 'Instance' then
        local distance = (rootpart.Position - cf.Position).Magnitude
        if distance >= 100 then
            rootpart.CFrame = CFrame.new(0, -50, 0)
            wait(.5)
            local tool = backpack:GetChildren()[1]
            if typeof(tool) == 'Instance' then
                humanoid:EquipTool(tool)
                wait(.1)
                rootpart.CFrame = cf
                humanoid:UnequipTools()
            end
        else
            rootpart.CFrame = cf
        end
    end
end

pcall(loadcharacter)
localplayer.CharacterAdded:Connect(loadcharacter)