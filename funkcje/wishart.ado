program define wishart

syntax varlist [if] [in] [, l_grup(integer 2) mlg(integer 2) group(string) label(string) det l_iter(integer 100) odlm(real 0) zgr(string)]


tempname a b c c1 d e f f1 A v v1 x y odl odl2 spec lgrup krok stop powod_zatrzymania zmiana grupy
tempvar lab g s reszt wer 
local `spec' = "`if'" + "`in'"
local `krok'=0
local `lgrup'=`l_grup'
local `stop'=0

qui gen `reszt'=0
qui gen `wer'=0
qui replace `wer'=1 ``spec''

if "`label'"!=""	{
	qui gen `lab'=`label'
			}
else	{
	qui gen `lab'=_n
	}


qui gen `s'=_n
local `v'=0
foreach i of varlist `varlist'	{
	local ++`v'
				}
local `v1'=``v''^0.5

if "`odlm'"=="0"	{
	local `odl'=``v1''
		}
else		{
	local `odl'=`odlm'
		}
di _newline(2)
di "Założenia analizy:"
di "Liczba grup obiektów = " `l_grup'
di "Maksymalna dopuszczalna odległość od środka ciężkości grupy obiektów = " ``odl''
di "Maksymalna liczba iteracji = " `l_iter'
di "Minimalna liczba obiektów w grupie = "`mlg'
local `a'=c(N)
di _newline(1)
//Wyznaczanie początkowych grup


if "`group'"!=""	{
	qui gen `g'=`group'
			}
else			{
	qui gen `g'=0
	mat dis `A'=`varlist'
	forvalues i=1/``lgrup''	{
		qui replace `g'=`i' in `i'
				}
	
	local `b'=``lgrup''+1
	forvalues i=``b''/``a''		{
	local `c'=`A'[`i',1]
	qui replace `g'=1 in `i'
		forvalues j=1/``lgrup''		{ 
			if `A'[`i',`j']<=``c''		{
				qui replace `g'=`j' in `i'
							}
						}
					}
			}
mat def `grupy'=J(1,``lgrup'',0)
forvalues i=1/``a''	{
	qui sum `g' in `i'
	mat `grupy'[1,r(mean)]=`grupy'[1,r(mean)]+1
			}

	
sort `g'
di "Początkowe grupy obiektów:"
char `g' [varname] "Nr grupy"
char `lab' [varname] "Obiekt"
list `lab' `g' , noobs sepby(`g') subvarname abb(33)
di _newline(1)
local `zmiana'=1



while ``stop''==0	{

local ++`krok'
if ``krok''>=`l_iter'	{
	local `stop'=1
	local `powod_zatrzymania'="Procedura zakończyła się z powodu osiągnięcia maksylanej liczby iteracji równej `l_iter'. Rozważ zwiększenie liczby dopuszczalnych iteracji."
			}
if ``zmiana''==0	{
	local `stop'=1
	local `powod_zatrzymania'="Procedura zakończyła się ponieważ w iteracji ``krok'' wynik grupowania nie zmienił się"
			}
//Obliczanie środków ciężkości grup
local `c'=1

sort `g'
mat def `A'=J(`l_grup',``v'',0)
forvalues i=1/``a''	{
	qui sum `reszt' in `i'
	if r(mean)==0		{
		qui sum `g' in `i'
		local `b'=r(mean)
		local `c'=0
		foreach j of varlist `varlist'	{
			local ++`c'
			qui sum `j' in `i'
			mat `A'[``b'',``c'']=`A'[``b'',``c'']+r(mean)
						}
				}
			}


forvalues i=1/`l_grup'	{
	forvalues j=1/``v''	{
		mat `A'[`i',`j']=`A'[`i',`j']/`grupy'[1,`i']
				}
			}

local `b'=""	
forvalues i=1/`l_grup'	{
	local `b'="``b''"+" Grupa_`i'"
			}
	
mat rown `A'=``b''
mat coln `A'=`varlist'
di "Centra grup obiektów w iteracji ``krok''"
	
		
		matlist `A', format(%9.3f)
				
		
//Określanie resztowości
forvalues i=1/``a''	{
	qui sum `reszt' in `i'
	if r(mean)==0	{
	local `b'=0
	local `c'=0
	qui sum `g' in `i'
	local `d'=r(mean)
	foreach j of varlist `varlist'	{
		local ++ `b'
		qui sum `j' in `i' if `wer'==1
		
		local `c'=``c''+(r(mean)-`A'[``d'',``b''])
					}
	local `c'=``c''^0.5
	if ``c''>=``odl''		{
		qui replace `reszt'=1 in `i'
		qui sum `g' in `i'
		mat `grupy'[1,r(mean)]=`grupy'[1,r(mean)]-1
			//Zmiana środków ciężkości po wyresztowaniu obserwacji
				forvalues i=1/``a''	{
					qui sum `g' in `i'
					if r(mean)==``d''	{
						qui sum `reszt' in `i'
						if r(mean)==0		{
						local `c'=0
						forvalues j=1/``v''	{
							mat `A'[``d'',`j']=0
									}
						
						foreach j of varlist `varlist'	{
						local ++`c'
						qui sum `j' in `i'
						mat `A'[``d'',``c'']=`A'[``d'',``c'']+r(mean)
										}
									}
								}
							}
				forvalues i=1/``v''	{
					mat `A'[``d'',`i']=`A'[``d'',`i']/`grupy'[1,``d'']
							}
				
					}
			}
			}


//Przemieszczanie obiektów do innych grup
local `zmiana'=0
forvalues j=1/``a''	{
	//di `j'
	
	//Określanie aktualnej odległośi od środka ciężkości
	
	local `b'=0
		local `c'=0		
		foreach m of varlist `varlist' 		{
			//di "`m'"
			local ++`c'
			qui sum `m' in `j'
			local `d'=r(mean)
			qui sum `g' in `j'
			local `f'=r(mean)
			local `b'=``b''+(`A'[``f'',``c'']-``d'')^2
							}
		local `e'=``b''^0.5


	//Ograniczenie na liczebność grup
	qui sum `g' in `j'
	
	
	if `grupy'[1,r(mean)]>`mlg'	{
	

			//Szukanie bliższych grup
			forvalues i=1/``lgrup''	{
				//di `i'
				local `b'=0
				local `c'=0		
				foreach m of varlist `varlist' 		{
					//di "`m'"
					local ++`c'
					qui sum `m' in `j'
					local `d'=r(mean)
					local `b'=``b''+(`A'[`i',``c'']-``d'')^2
									}
				local `b'=``b''^0.5
		
				if ``b''<``e''	& ``b''<``odl''	{
					qui sum `g' in `j'
					local `f1'=r(mean)
					qui replace `g'=`i' in `j'
					qui replace `reszt'=0 in `j'
					local `e'=``b''
					local `zmiana'=1
					//di "w obiekcie `j' zmiana ``f1'' na `i'"
					mat `grupy'[1,``f1'']=`grupy'[1,``f1'']-1
					mat `grupy'[1,`i']=`grupy'[1,`i']+1
							}
						}
					}
			}
//Wyświetlanie wyników pośrednich
sort `g'
di "Grupy obiektów wyróżnione w iteracji ``krok''"

list `lab' `g' if `reszt'==0 & `wer'==1, subvarname sepby(`g') noobs abb(30) 

local `b'=0
forvalues i=1/``a''	{
	qui sum `reszt' in `i'
	if r(mean)==1		{
		local `b'=1
				}
			}
if ``b''==1	{
di "Obiekty resztowe wyróżnione po iteracji ``krok'', tworzące grupy jednoelementowe:"
list `lab' if `reszt'==1 & `wer'==1, noheader noobs
		}
else		{
di "W iteracji ``krok'' nie wyróżniono obiektów resztowych"
		}

mat drop `A'

//koniec pętli while
		}
di "``powod_zatrzymania''"

if "`zgr'" != "" {
	qui gen `zgr' = `g'  // added export here
}

sort `s'			
end
//end