--- Source: https://github.com/wiremod/wire/blob/master/lua/entities/gmod_wire_expression2/core/entity.lua 

e2function void entity:applyForce(vector force)
	if not validPhysics(this) then return self:throw("Invalid physics object!", nil) end
	if not isOwner(self, this) then return self:throw("You do not own this entity!", nil) end

	force = clamp(force)

	local phys = this:GetPhysicsObject()
	phys:ApplyForceCenter(Vector(force[1],force[2],force[3]))
end

e2function void entity:applyOffsetForce(vector force, vector position)
	if not validPhysics(this) then return self:throw("Invalid physics object!", nil) end
	if not isOwner(self, this) then return self:throw("You do not own this entity!", nil) end

	force 		= clamp(force)
	position 	= clamp(position)

	local phys = this:GetPhysicsObject()
	phys:ApplyForceOffset(Vector(force[1],force[2],force[3]), Vector(position[1],position[2],position[3]))
end

e2function void entity:applyAngForce(angle angForce)
	if not validPhysics(this) then return self:throw("Invalid physics object!", nil) end
	if not isOwner(self, this) then return self:throw("You do not own this entity!", nil) end

	if angForce[1] == 0 and angForce[2] == 0 and angForce[3] == 0 then return end
	angForce = clamp(angForce)

	local phys = this:GetPhysicsObject()

	-- assign vectors
	local up = this:GetUp()
	local left = this:GetRight() * -1
	local forward = this:GetForward()

	-- apply pitch force
	if angForce[1] ~= 0 then
		local pitch = up      * (angForce[1] * 0.5)
		phys:ApplyForceOffset( forward, pitch )
		phys:ApplyForceOffset( forward * -1, pitch * -1 )
	end

	-- apply yaw force
	if angForce[2] ~= 0 then
		local yaw   = forward * (angForce[2] * 0.5)
		phys:ApplyForceOffset( left, yaw )
		phys:ApplyForceOffset( left * -1, yaw * -1 )
	end

	-- apply roll force
	if angForce[3] ~= 0 then
		local roll  = left    * (angForce[3] * 0.5)
		phys:ApplyForceOffset( up, roll )
		phys:ApplyForceOffset( up * -1, roll * -1 )
	end
end

--- Applies torque according to a local torque vector, with magnitude and sense given by the vector's direction, magnitude and orientation.
e2function void entity:applyTorque(vector torque)
	if not IsValid(this) then return self:throw("Invalid entity!", nil) end
	if not isOwner(self, this) then return self:throw("You do not own this entity!", nil) end

	if torque[1] == 0 and torque[2] == 0 and torque[3] == 0 then return end
	torque = clamp(torque)

	local phys = this:GetPhysicsObject()

	local tq = Vector(torque[1], torque[2], torque[3])
	local torqueamount = tq:Length()

	-- Convert torque from local to world axis
	tq = phys:LocalToWorld( tq ) - phys:GetPos()

	-- Find two vectors perpendicular to the torque axis
	local off
	if abs(tq.x) > torqueamount * 0.1 or abs(tq.z) > torqueamount * 0.1 then
		off = Vector(-tq.z, 0, tq.x)
	else
		off = Vector(-tq.y, tq.x, 0)
	end
	off = off:GetNormal() * torqueamount * 0.5

	local dir = ( tq:Cross(off) ):GetNormal()

	dir = clamp(dir)
	off = clamp(off)

	phys:ApplyForceOffset( dir, off )
	phys:ApplyForceOffset( dir * -1, off * -1 )
end

e2function vector entity:inertia()
	if not validPhysics(this) then return self:throw("Invalid physics object!", {0, 0, 0}) end
	return this:GetPhysicsObject():GetInertia()
end
