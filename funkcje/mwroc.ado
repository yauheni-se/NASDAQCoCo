program define mwroc

syntax varlist [if] [in] [, c(real 1) maxmin label(string) measure(string) zgr(string)]


tempname a b c1 d ds sd e f f1 f2 f3 f4 A B Amin Agr v m spec krok stop 
tempvar lab g s reszt wer 
local `spec' = "`if'" + "`in'"
local `krok'=0

qui gen `g'=0
gen `s'=_n
qui gen `wer'=0
qui replace `wer'=1 ``spec''
qui gen `reszt'=0

if "`label'"!=""	{
	qui gen `lab'=`label'
			}
else	{
	qui gen `lab'=_n
	}

mat dis `A'=`varlist' ``spec'', `measure'

local `v'=0
foreach i of varlist `varlist'	{
	local ++`v'
				}

local `a'=colsof(`A')

local `m'=0

//Znajdowanie największej wartości w macierzy odległości
forvalues i=1/``a''	{
	forvalues j=1/``a''	{
		if `A'[`i',`j']>``m''	{
			local `m'=`A'[`i',`j']
					}
				}
			}

//Tworzenie macierzy najmniejszych wartości w wierszach m. odl.
mat def `Amin'=J(1,``a'',``m'')

forvalues i=1/``a''	{
	local `m'=`Amin'[1,`i']
	
	forvalues j=1/``a''	{
		if `i'!=`j'		{
			if `A'[`i',`j']<``m''	{
				local `m'=`A'[`i',`j']
						}
					}
				}
	
	mat `Amin'[1,`i']=``m''
			}
di _newline(2)
di "Założenia analizy:"			
//Wyznaczanie promienia kuli
if "`maxmin'"!=""	{
	local `d'=0
	forvalues i=1/``a''	{
		if `Amin'[1,`i']>``d''	{
			local `d'=`Amin'[1,`i']
					}
				}
di "Promien hiperkul wyznaczony metoda maxmin wynosi" %-9.3f ``d''
			}
else			{
	local `ds'=0
	forvalues i=1/``a''	{
		local `ds'=``ds''+`Amin'[1,`i']
				}
	local `ds'=``ds''/``a''
	local `sd'=0
	forvalues i=1/``a''	{
		local `sd'=``sd''+(``ds''-`Amin'[1,`i'])^2
				}
	local `sd'=(``sd''/``a'')^0.5

	local `d'=``ds''+`c'*``sd''
di "Promien hiperkuli wynosi " %-9.3f ``d''
			}


local `stop'=``a''

while ``stop''>0	{
	mat def `Agr'=J(1,``a'',0)
	local ++`krok'
	
	forvalues i=1/``a''	{
		qui sum `reszt' in `i'
		if r(mean)==0		{
			forvalues j=1/``a''	{
				qui sum `reszt' in `j'
				if r(mean)==0		{
					if `i'!=`j'		{
						if `A'[`i',`j']<=``d''	{
							mat `Agr'[1,`i']=`Agr'[1,`i']+1
									}
								}
							}
						}
					}	
				}
	

	local `b'=0

	forvalues i=1/``a''	{
		qui sum `reszt' in `i'
		if r(mean)==0	{
			if `Agr'[1,`i']>=``b''	{
				local `b'=`Agr'[1,`i']
				local `e'=`i'
						}
				}
				}
	local `f3'=0
	foreach j of varlist `varlist'	{
			qui sum `j' in ``e''
			local `f3'=``f3''+r(mean)^2
					}
	
	local `f'=0
	local `f1'=""
	forvalues i=1/``a''	{
		qui sum `reszt' in `i'
		local `f4'=r(mean)
		if `Agr'[1,`i']==``b''	&  ``f4''==0 {
			local ++`f'
			local `f1'="``f1''" +" `i'"
					}
				}
	
	
	foreach i of local `f1'	{
		local `f2'=0
		foreach j of varlist `varlist'	{
			qui sum `j' in `i'
			local `f2'=``f2''+r(mean)^2
						}
			
			if ``f2''<``f3''		{
				local `f3'=``f2''
				local `e'=`i'
						}
			
				}
	

	local `stop'=``stop''-``b''-1

	di _newline(1)
	di "Centrum grupy obiektów w iteracji ``krok''" 
	list `lab' in ``e'', noheader noobs
	
	qui replace `reszt'=1 in ``e''
	qui replace `g'=``krok'' in ``e''
	
	forvalues i=1/``a''	{
		qui sum `reszt' in `i'
		if `A'[`i',``e'']<``d'' & `i'!=``e'' & r(mean)==0	{
			qui replace `reszt'=1 in `i'
			
			qui replace `g'=``krok'' in `i'
									}
				}
	char `lab' [varname] "Obiekt"
	char `g' [varname] "Nr grupy"
	di "W iteracji ``krok'' wyróżniono następującą grupę obiektów"
	list `lab' if `g'==``krok'' & `wer'==1 ,  noobs noheader
	
			}
sort `g'

di "Grupowanie obiektów metodą wrocławską"	
char `lab' [varname] "Obiekt"
char `g' [varname] "Nr grupy"		
list `lab' `g'  if `wer'==1, noobs subvarname sepby(`g') abb(33)

if "`zgr'"!=""	{
	qui gen `zgr'=`g' ``spec''
		}

sort `s'

end
//end

