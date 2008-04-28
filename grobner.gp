global(x,y,z,w,a,b,c,d,e,f)

lead_coeff_term(g) = 
{
local(dx, dy);
dx = poldegree(g, x);
g = polcoeff(g, dx, x);
dy = poldegree(g, y);
g = polcoeff(g, dy, y);
return([g, dx, dy]);
}

reduce(g, fff, lll) = 
{
local(i, lg, lh, gg);
lg = lead_coeff_term(g);
i = 1;
while(i <= lll,
	lh = lead_coeff_term(fff[i]);
	if((lg[2] == lh[2]) && (lg[3] == lh[3]),
		g = g + fff[i]; /* char 2 */
		lg = lead_coeff_term(g);
		i = 1
	,
		i++
	)
);
return(g);
}

s_pol(g1, g2) = 
{
return(g1*g2);
}

find_extra(fff, lll, i, j) = 
{
local(k, g, h);
while(j <= lll,
	g = s_pol(fff[i], fff[j]);
	h = reduce(g, fff, lll);
	if(h, return([h, i, j]));
	if(i + 1 <= j,
		i = i + 1
	,
		j = j + 1;
		i = 1
	)
);
return([0, 0, 0]);
}

do_it(v, N) = {
local(ff, ll, lg, dg, dd, uit, G, i, j, lijst);
if(N,,N = 200);
lijst = vector(N);
ll = #v;
ff = vector(ll);
dd = vector(ll);
j = 1;
while(j <= ll,
	ff[j] = v[j];
	lg = lead_coeff_term(ff[j]);
	dg = lg[2] + lg[3];
	dd[j] = dg;
	if(dg < N+1, lijst[dg]++);
	j++
);
i = 1;
while(i <= ll,
	j = 1;
	while(j < i,
		if(dd[j] > dd[i],
			G = ff[i];
			ff[i] = ff[j];
			ff[j] = G;
			dg = dd[i];
			dd[i] = dd[j];
			dd[j] = dg
		);
		j++
	);
	i++
);
uit = find_extra(ff, ll, 1, 2);
G = uit[1];
while(G,
	lg = lead_coeff_term(G);
	dg = lg[2] + lg[3];
	if(dg < N+1, lijst[dg]++);
	i = 1;
	j = 1;
	while(j != 0,
		if(dg < dd[i],
			j = 0
		,
			if(i == ll, j = 0);
			i++
		)
	);
	ff = concat(ff,[G]);
	dd = concat(dd,[dg]);
	ll = ll + 1;
	G = ff[i];
	ff[i] = ff[ll];
	ff[ll] = G;
	dg = dd[i];
	dd[i] = dd[ll];
	dd[ll] = dg;
	i = uit[2];
	j = uit[3];
	if(dd[i] + dd[j] > N, i = 1; j = j+1);
	uit = find_extra(ff, ll, i, j);
	G = uit[1];
	if(dd[j] >= N+1, return(lijst))
);
return(ff);
}

my_v(N)=
{
return(do_it(Mod(1,2)*[x^15*y^9, x^6*y^15, x^2*y^43 + x^40*y^5, y^(3*19) + x^(2*19)*y^19 + x^(3*19)], N))
}
