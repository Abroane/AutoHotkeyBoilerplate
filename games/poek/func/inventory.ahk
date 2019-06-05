invAdd(item=-1, qty="")
{
	iii:=getItem(item)
	
	if (qty="")
		iii.2.qty:=rand(iii.2.qty)
	else
		iii.2.qty:=qty
		
	if (player.hasKey(iii.1))
		player.inv[iii.1].qty+=iii.2.qty
	else
		player.inv[iii.1]:=iii.2
	; msgBox % iii.1 "," iii.2.qty
	return [iii.1, iii.2.qty]
}

getItem(name=-1, qty1=1, qty2=3)
{
	arr:={}
	if (name=-1)
		name:=randKey(items)
	; msgBox %name%<<
	for k, v in items[name]
		arr[k]:=v
	arr.qty:=rand(qty1, qty2)*items[name].qty
	return [name, arr]
}

itemEat(iToEat)
{
	global upool ; whatevs
	doNotDeleteItIsBeingUsed:=0
	if (iToEat~="^\.\w+\:")
		return "err: 100eat: item is equipped"
	if (player.hp>=player.hpm.1) ; you cannot eat on full hp
		return -1

	; save values before we potentially delete it
	hhh:=player.inv[iToEat].stat.3
	qqq:=player.inv[iToEat].qty
	player.inv[iToEat].qty-=1
	
	; nothing left? delete!
	for k, v in upool
		if (v~="^\.\w+\:" iToEat)
			doNotDeleteItIsBeingUsed:=1
			
	if (doNotDeleteItIsBeingUsed=0)
	{
		if (player.inv[iToEat].qty<=0)
			player.inv.delete(iToEat)
	}
	return [qqq, hhh]
}

itemUnequip(iToRemove)
{
	ttt:=substr(iToRemove, 2, 1)
	if (player.gear[ttt].length()<=0)
		return "err: 100iu" ttt ": gear empty"
	if (player.inv[iToRemove].qty<=0)
		return "err: 101iu" ttt ": quantity is " player.inv[iToRemove].qty ", " iToRemove
	if (!(iToRemove~="^\.\w+\:"))
		return "err: 102iu" ttt ": item is not equipped, " iToRemove

	player.inv[substr(iToRemove,4)].qty+=1
	player.inv[iToRemove].qty-=1
	if (player.inv[iToRemove].qty<=0)
		player.inv.delete(iToRemove)

	remOne(player.gear[ttt], substr(iToRemove,4))
	return 1
}

itemEquip(iToAdd, iType)
{
	global maxGear
	ttt:=substr(iType, 2, 1)
	if (player.gear[ttt].length()>=maxGear)
		return "Cannot equip anymore " ((ttt="w") ? "weapons" : "armor") " " player.gear[ttt].length() "/" maxGear
	if (player.inv[iToAdd].qty<=0)
		return "err: 101ie" ttt ": quantity is " player.inv[iToAdd].qty ", " iToAdd
	if (iToAdd~="^\.\w+\:")
		return "err: 102ie" ttt ": item is equipped, " iToAdd
		
	player.gear[ttt].push(iToAdd)
	player.inv[iToAdd].qty-=1
	
	; clone the attributes to the new "equipped" item
	for k, v in player.inv[iToAdd]
		player.inv[iType iToAdd, k]:=v
		, player.inv[iType iToAdd].qty:=0

	; count how many are equipped
	for k, v in player.gear[ttt]
		if (v=iToAdd)
			player.inv[iType iToAdd].qty+=1
	return 1
}