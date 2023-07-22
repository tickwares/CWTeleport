local p = game:service'Players'
local lp = p.LocalPlayer

function teleport(cf)
    assert(typeof(cf) == "CFrame", "Invalid argument 'cf'. Expected CFrame.")
    
    local character = lp.Character
    assert(character and character:FindFirstChild("HumanoidRootPart"), "Player character or HumanoidRootPart not found.")
    
    local dis = (character.HumanoidRootPart.Position - cf.Position).Magnitude
    local backpack = lp.Backpack
    
    if dis >= 100 then
        character.HumanoidRootPart.CFrame = CFrame.new(0, -50, 0)
        task.wait(.5)
        local tools = backpack:GetChildren()
        assert(#tools > 0, "No tools found in the player's backpack.")
        character.Humanoid:EquipTool(tools[1])
        task.wait(.1)
        character.HumanoidRootPart.CFrame = cf
        character.Humanoid:UnequipTools()
    else
        character.HumanoidRootPart.CFrame = cf
    end
end
