npc = {}
npc.__index = npc

function npc:create(model, coords, heading)
    local self = setmetatable({}, npc)
    self.model = model
    self.coords = coords
    self.heading = heading
    self.ped = nil
    return self
end

function npc:loadModel()
    RequestModel(self.model)
    while not HasModelLoaded(self.model) do
        Wait(10)
    end
end

function npc:spawn()
    self:loadModel()
    self.ped = CreatePed(4, self.model, self.coords.x, self.coords.y, self.coords.z, self.heading, false, true)
    if DoesEntityExist(self.ped) then
        SetEntityAsMissionEntity(self.ped)
        SetPedFleeAttributes(self.ped, 0, 0)
        SetBlockingOfNonTemporaryEvents(self.ped, true)
        SetEntityInvincible(self.ped, true)
        FreezeEntityPosition(self.ped, true)
        TaskStartScenarioInPlace(self.ped, "WORLD_HUMAN_DRINKING", 0, false)
        SetModelAsNoLongerNeeded(self.model)
    
        dbg("Spawned npc. Model: "..self.model.." X: "..self.coords.x.." Y: "..self.coords.y.." Z: "..self.coords.z.." H: "..self.heading)
    else
        dbg("Failed to spawn NPC")
    end

    return self.ped
end

function npc:delete()
    if DoesEntityExist(self.ped) then
        DeleteEntity(self.ped)
        self.ped = nil
        print("NPC Deleted")
    end
end