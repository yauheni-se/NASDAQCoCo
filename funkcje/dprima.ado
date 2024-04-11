program define dprima

syntax varlist  [, measure(string) label(string) zgr(string) g nat k(integer 0) det]

tempname A B C1 C2 a b c d e f h var  obs obs2 licz iter lista listb lista2 listb2 min max maxp result stop 

tempvar lab lab2 pos w w1 w2 l1 l2 l p gor d pg pd lg ld gr s nr sor
mat dis `A'=`varlist', `measure'

qui gen `sor'=_n
qui gen `w1'=0
qui gen `w2'=0
qui gen `w'=0
qui gen `p'=0
qui gen `l'=0
qui gen `gor'=0
qui gen `d'=0
qui gen `s'=_n
qui gen `lab2'=""
qui gen `l1'=0
qui gen `l2'=0
qui gen `pg'=0
qui gen `pd'=0
qui gen `lg'=0
qui gen `ld'=0
qui gen `pos'=12
qui gen `nr'=1

local `licz'=_N
local `obs'=colsof(`A')
forvalues i=1/``obs''	{
	local `listb'="``listb''"+"`i' "
			}

forvalues i=1/``obs''	{
	local `lista'="``lista''"+" o`i'"
}

if "`label'"!=""	{
	qui gen `lab'=`label' ``spec''
			}
else			{
	
	qui gen `lab'=1 ``spec''
	local `a'=_N
	local `b'=0
	forvalues i=1/``a''	{
		qui sum `ind' in `i'
			if r(mean)==1	{
				local ++`b'
				qui replace `lab'=``b'' in `i'
					}
				}
			}


local `max'=0
forvalues i=1/``obs''	{
	forvalues j=1/``obs''	{
		if `A'[`i',`j']>``max''	{
			local `max'=`A'[`i',`j']
					}
				}
			}

if "`det'"!=""	{
di "W pierwszym kroku do zbioru A dołączono obiekt 1"
		}
local `stop'=0
local `lista'="1"

local `iter'=1
local `listb' : list `listb' - `lista'
mat def `B'=J(1,``obs'',0)

mat def `C1'=J(``obs'', ``obs'',0)
mat def `C2'=J(``obs'', ``obs'',0)
		

while ``stop''==0	{
	local `maxp'=``max''
	local ++`iter'	
	
	foreach i of local `lista' 	{	
		foreach j of local `listb'		{
			if `A'[`i',`j']<``maxp'' & `i'!=`j'	{
				local `maxp'=`A'[`i',`j']
				local `a'=`i'
				local `b'=`j'
								}
						}
					}
	mat `B'[1,``iter'']=``maxp''
	qui replace `lab2'=string(``maxp'',"%9.2f") in ``b''
	qui replace `w'=``maxp'' in ``b''
	qui replace `nr'=``iter'' in ``b''
	if "`g'"!=""	{
		mat `C1'[``a'',``b'']=1
		mat `C2'[``a'',``b'']=``maxp''
		}
	if `p'[``a'']==0	{
		qui replace `w1'=`w1'[``a'']+``maxp'' in ``b''
		qui replace `w2'=`w2'[``a''] in ``b''
		local `f'=`w2'[``a'']
		local `c'=`w1'[``a'']
		local `d'=`w1'[``b'']
		qui replace `l1'=(``c''+``d'')/2 in ``b''
		qui replace `l2'=``f'' in ``b''
		local funkcje``iter'' ="function (``f''), ra(``c'' ``d'') lc(gs5) n(2000) ||"
		qui replace `p'=1 in ``a''
		qui replace `l'=1 in ``b''
				}
	else			{
		if `l'[``a'']==0	{
			qui replace `w1'=`w1'[``a'']-``maxp'' in ``b''
			qui replace `w2'=`w2'[``a''] in ``b''
			local `f'=`w2'[``a'']
			local `c'=`w1'[``a'']
			local `d'=`w1'[``b'']
			qui replace `l1'=(``c''+``d'')/2 in ``b''
			qui replace `l2'=``f'' in ``b''
			local funkcje``iter'' ="function (``f''), ra(``d'' ``c'') lc(gs5)  n(2000) legend(off) ||"
			qui replace `l'=1 in ``a''
			qui replace `p'=1 in ``b''			

					}
		else			{
			if `gor'[``a'']==0	{
				qui replace `w2'=`w2'[``a'']+``maxp'' in ``b''
				qui replace `w1'=`w1'[``a''] in ``b''
				local `f'=`w1'[``a'']
				local `c'=`w2'[``a'']
				local `d'=`w2'[``b'']
				qui replace `l2'=(``c''+``d'')/2 in ``b''
				qui replace `l1'=``f'' in ``b''

				local funkcje``iter'' = "scatteri ``d'' ``f'' ``c'' ``f'', recast(line) lc(gs5) legend(off) ||"
				qui replace `gor'=1 in ``a''
				qui replace `d'=1 in ``b''
				qui replace `pos'=9 in ``b''
						}
			else			{
				if `d'[``a'']==0	{
					qui replace `w2'=`w2'[``a'']-``maxp'' in ``b''
					qui replace `w1'=`w1'[``a''] in ``b''
	
					local `f'=`w1'[``a'']
					local `c'=`w2'[``a'']
					local `d'=`w2'[``b'']
					qui replace `l2'=(``c''+``d'')/2 in ``b''
					qui replace `l1'=``f'' in ``b''

					local funkcje``iter'' = "scatteri ``c'' ``f'' ``d'' ``f'', recast(line) lc(gs5) legend(off) ||"

					qui replace `d'=1 in ``a''
					qui replace `gor'=1 in ``b''
					qui replace `pos'=9 in ``b''
							}

				else			{
					if `pg'[``a'']==0	{
					qui replace `w2'=`w2'[``a'']+(``maxp''/(2^0.5)) in ``b''
					qui replace `w1'=`w1'[``a'']+(``maxp''/(2^0.5)) in ``b''
	
					local `f'=`w1'[``a'']
					local `h'=`w1'[``b'']
					local `c'=`w2'[``a'']
					local `d'=`w2'[``b'']
					qui replace `l2'=(``c''+``d'')/2 in ``b''
					qui replace `l1'=(``f''+``h'')/2 in ``b''

					local funkcje``iter'' = "scatteri ``c'' ``f'' ``d'' ``h'', recast(line) lc(gs5) legend(off) ||"

					qui replace `pg'=1 in ``a''
					qui replace `ld'=1 in ``b'' 
					qui replace `pos'=10 in ``b''
								}
					else			{
						if `pd'[``a'']==0	{
						qui replace `w2'=`w2'[``a'']-(``maxp''/(2^0.5)) in ``b''
						qui replace `w1'=`w1'[``a'']+(``maxp''/(2^0.5)) in ``b''
	
						local `f'=`w1'[``a'']
						local `h'=`w1'[``b'']
						local `c'=`w2'[``a'']
						local `d'=`w2'[``b'']
						qui replace `l1'=(``c''+``d'')/2 in ``b''
						qui replace `l2'=(``f''+``h'')/2 in ``b''

						local funkcje``iter'' = "scatteri ``d'' ``h'' ``c'' ``f'' , recast(line) lc(gs5) legend(off) ||"

						qui replace `pd'=1 in ``a''
						qui replace `lg'=1 in ``b'' 
						qui replace `pos'=2 in ``b''
								}						


								}


							}
						}
					}
				}

	
	//sort `s'


	local `lista'="``lista''"+" ``b''"
	local `listb' : list `listb' - `lista'
	local `c'=`lab'[``b'']
	local `d'=`lab'[``a'']
	if "`det'"!=""	{
	di "W kroku ``iter'' do zbioru A przyłączono obiekt ``c'', przy długości wiązania wynoszącej " %-9.3f ``maxp''
	di "Obiekt przyłączono do obiektu ``d''"
	di "Skład grupy A po kroku ``iter'':"
	foreach i of local `lista' 	{
		local `lista2' = "``lista2'' " + `lab'[`i']
					}
	di "``lista2''"
	local `lista2'=""
	di "Skład grupy B po kroku ``iter'':"
	foreach i of local `listb' 	{
		local `listb2' = "``listb2'' " + `lab'[`i']
					}
	di "``listb2''"
	local `listb2'=""
			}
	local `result':  list sizeof `lista'
		
	if ``obs''==``result''	{	
	local `stop'=1	
				}

			}

	
tempname funkcje		
forvalues i=1/``obs''	{
	
	if "`funkcje`i''"!=""	{
	local `funkcje' "``funkcje'' `funkcje`i''"
				}
			}


graph twoway ``funkcje'' (scatter `w2' `w1' , mc(dknavy)  mlabel(`lab') mlabangle(345) mlabpos(4) mlabcolor(dknavy)  xsca(titlegap(*2))) (scatter `l2' `l1', msymbol(none) mlabel(`lab2') mlabv(`pos') mlabcolor(dknavy)), title(Dendryt Prima) yscale(off) xscale(off)




if "`g'"!=""	{
	tempname pnat
	local `pnat'=0
	if `k'>0	{
		
		di "Na podstawie Dendrytu Prima zostanie dokonane grupowanie na zadane `k' grup"
		local `c'=`k'-1
		gsort -`w'
		local `d'=`w'[``c''+1]
		sort `w'
			}
	else		{
		
		local `pnat'=1
		di "Grupowanie obiektów zostanie przeprowadzone na podstawie naturalnego podziału dendrytu"
		di "Tabela przedstawia wartości ilorazów długości kolejnych wiązadeł"
		di "Krytyczna długość wiązadła oznaczona jest gwiazdką"
		gsort -`w'
		char `w' [varname] "Długość] wiązadła"
		tempvar gw rk ik ikw nw
		qui gen `nw'=_n
		char `nw' [varname] "Nr wiązadła k"
		qui gen `ik'=`w'[_n]/`w'[_n+1]
		char `ik' [varname] "Ilorazy kolejnych wiąz. i(k)"
		local `obs2'=``obs''-1
		qui gen `rk'=`ik'[_n]-`ik'[_n+1]
		char `rk' [varname] "Różnice kolejnych ilorazów"
		qui gen `ikw'=`ik' if `rk'<0
		char `ikw' [varname] "Ilorazy spełniające i(k)<i(k+1)"
		qui sum `ikw'
		qui gen `gw'=""
		char `gw' [varname] " "
		forvalues i=1/``obs''	{
			if `ikw'[`i']==r(min)	{
				qui replace `gw'="*" in `i'
				local `c'=`i'-1
				local `d'=`w'[`i']
						}
					}
		format `w' `ik' `ikw' %9.3f
		list `nw' `w' `ik'  `ikw' `gw' in 1/``obs2'', noobs subvarname abb(33)
		di "Naturalny podział dendrytu wymaga usunięcia ``c'' najdłuższych wiązadeł"
		sort `w'

			}
		
	




//matlist `C1'
//matlist `C2'
tempvar gr
qui gen `gr'=0

//Rysowanie Grafu bez najdłuższych wiązadeł
local `a'=``obs''-``c''
local `funkcje'=""
local `b'=""
forvalues i=1/``a''	{
	local `b'="``b'' "+ string(`nr'[`i'])
			}

foreach i of local `b'	{
	
	if "`funkcje`i''"!=""	{
	local `funkcje' "``funkcje'' `funkcje`i''"
				}
			}
				
graph twoway ``funkcje'' (scatter `w2' `w1' , mc(dknavy)  mlabel(`lab') mlabangle(345) mlabpos(4) mlabcolor(dknavy)  xsca(titlegap(*2))) (scatter `l2' `l1' in 1/``a'', msymbol(none) mlabel(`lab2') mlabv(`pos') mlabcolor(dknavy)), title(Dendryt Prima po usunięciu ``c'' najdłuższych wiązadeł) yscale(off) xscale(off)

//Wyznaczanie grup

local `stop' =0
tempname stop2 h
local `e'=0


local `d'=``d''+0.0000001
forvalues i=1/``obs''	{
	forvalues j=1/``obs''	{
		if `C2'[`i',`j']>``d''	{
			mat `C1'[`i',`j']=0
					}
				}
			}


sort `sor'
while ``stop''==0	{
	local `stop2'=0
	
	local ++`e'
	
	local `f'=0
	while ``stop2''==0	{
		local ++`f'
		if ``f''<=``obs''	{
		
		local `h'= `gr'[``f'']
		
		if ``h''==0		{
			
			
			local `lista'="``f''"
			local `stop2'=1
					}
					}
		else		{
			local `stop2'=1
				}
	
		forvalues k=1/``obs''	{
			foreach i of local `lista'	{
				forvalues j=1/``obs''		{
					if `C1'[`i',`j']==1		{
						local `listb'="`j'"
						local `lista' : list `lista' | `listb'	
								
									}
								}
							}
					}
		foreach i of local `lista'	{
			qui replace `gr'=``e'' in `i'
						}
		
		local `lista'=""
				
				}	
	qui sum `gr'
	
		if r(min)>0		{
			local `stop'=1
					}	
			}
char `lab' [varname] "Obiekt"
tempvar gr2
egen `gr2'=group(`gr')
char `gr2'  [varname] "Nr grupy"

if ``pnat''==0	{
	
	di "Grupowanie obiektów metodą podziału dendrytu Prima"
		}
else		{
	di "Grupowanie obiektów metodą naturalnego podziału dendrytu"
		}
sort `gr2'

list `lab' `gr2', noobs subvarname sepby(`gr2') abb(33)

if "`zgr'"!=""	{
	qui gen `zgr'=`gr2'   // added export here
}

sort `sor'
}

end
//end