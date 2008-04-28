global(f,x,y,z,w,t,A,B,C);

my_first_f()=
{
f = 1*x^8 + 1*x^3*y^3*w^1 + 1*x^1*y^8 + 1*y^7*z^1 + 1*y^1*w^3 + 1*z^3*w^1;
A = polcoeff(f, 3, w);
B = polcoeff(f, 1, w);
C = polcoeff(f, 0, w);
if(f - A*w^3 - B*w - C != 0, error("kjahsjhkjasjk"));
print("f = ", f);
}

my_second_f()=
{
f = 1*x^5 + 1*x^2*y^4*w^1 + 1*x^1*y^1*z^1*w^2 + 1*x^1*w^3 + 1*y^12 + 1*y^1*z^5 + 1*z^4*w^1;
f = lift(Mod(1,2)*subst(f, w, w + y*z));
A = polcoeff(f, 3, w);
B = polcoeff(f, 1, w);
C = polcoeff(f, 0, w);
if(f - A*w^3 - B*w - C != 0, error("kjahsjhkjasjk"));
print("f = ", f);
}


/*
	(aa*w^2 + bb*w + cc)*(aaa*w + ccc) 
	=
	aaa*aa*w^3 + (ccc*aa + aaa*bb)*w^2 + (ccc*bb + aaa*cc)*w + ccc*cc
*/
do_it(xx,yy,zz)=
{
local(i,j,a,b,c,lista,listc,nra,nrc,aa,aaa,bb,ccc,cc,divv);
a = subst(subst(subst(A,x,xx),y,yy),z,zz);
b = subst(subst(subst(B,x,xx),y,yy),z,zz);
c = subst(subst(subst(C,x,xx),y,yy),z,zz);
lista = divisors(a);
listc = divisors(c);
nra = #lista;
nrc = #listc;
i = 1;
while(i <= nra,
	aa = lista[i];
	aaa = lista[nra - i + 1];
	j = 1;
	while(j <= nrc,
		cc = listc[j];
		ccc = listc[nrc - j + 1];
		divv = divrem(ccc*aa, aaa);
		if(divv[2],,
			bb = divv[1];
			if(ccc*bb+aaa*cc == b,
				print("Success!");
				print("aa = ", aa);
				print("aaa = ", aaa);
				print("bb = ", bb);
				print("ccc = ", ccc);
				print("cc = ", cc);
				print("x = ", xx);
				print("y = ", yy);
				print("z = ", zz);
				print("w = ", ccc/aaa);
				return(1);
			);
		);
		j++
	);
	i++
);
return(0)
}

test_case()=
{
local(g, h, i, j, aa, aaa, cc, ccc, bb);
f = x*w^3 + y*w + z;
A = polcoeff(f, 3, w);
B = polcoeff(f, 1, w);
C = polcoeff(f, 0, w);
if(f - A*w^3 - B*w - C != 0, error("kjahsjhkjasjk"));
/*
with ccc*aa + aaa*bb = 0 and
	x = aaa*aa
	y = (ccc*bb + aaa*cc)
	z = ccc*cc
for example we could take
*/
g = Mod(1,2)*(1+t);
h = Mod(1,2)*t^2;
i = Mod(1,2)*(t^3+1);
j = Mod(1,2)*(t^4+1);
cc = Mod(1,2)*(1+t+t^2);
ccc = g*h;
aa = i*j;
aaa = g*i;
bb = -j*h;
cc = cc;
print("Here is the test run with");
print("aa = ", aa);
print("aaa = ", aaa);
print("bb = ", bb);
print("ccc = ", ccc);
print("cc = ", cc);
print("Here it comes...");
do_it(aaa*aa, ccc*bb + aaa*cc, ccc*cc);
}

next_one(ww)=
{
local(i);
i = 0;
while(polcoeff(ww, i, t),
	ww = ww + Mod(1,2)*t^i;
	i++
);
ww = ww + Mod(1,2)*t^i;
return(ww)
}

loop()=
{
local(ONE,xn,yn,zn,xx,yy,zz,nr);
if(f - A*w^3 - B*w - C != 0, error("kjahsjhkjasjk"));
xn = 1;
yn = 1;
zn = 1;
ONE = Mod(1,2)*t;
ONE = ONE/t;
xx = ONE;
yy = ONE;
zz = ONE;
nr = 0;
while(1,
	do_it(xx,yy,zz);
	if(xn < yn,
		xn++;
		xx = next_one(xx)
	,
		if(yn < zn,
			yn++;
			yy = next_one(yy);
			xn = 1;
			xx = ONE;
		,
			zn++;
			zz = next_one(zz);
			xn = 1;
			xx = ONE;
			yn = 1;
			yy = ONE
		)
	);
	nr++;
	if(nr % 1000 == 0, print(nr))
)
}

