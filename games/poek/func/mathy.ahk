clamp(num, min="", max="")
{
	return ((num<min && min!="") ? min : (num>max && max!="") ? max : num)
}

choose(arr*)
{
	return arr[rand(arr.length())]
}

rand(max=100, min=1)
{
	if (min>max)
		t:=max, max:=min, min:=t
	random, r, %min%, %max%
	return r
}

about(in, num=5, perc=0) ; number give or take Num, optionally a percent
{
	ttt:=round(in*(num/100))
	if (perc=0)
		random, anum, % in-num, % in+num
	else
		random, anum, % in-ttt, % in+ttt
	return clamp(anum, 0)
}