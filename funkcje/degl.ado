program define degl

syntax varlist [if] [in] [, k(integer 0) label(string) measure(string) zgr(string) det]


tempname a b b1 b2 c d  e f it gr maxd o1 o2  A B spec lgrup krok stop  zmiana g gtemp grupy v n l_grup
tempvar lab g gg numer numerak numerg s  reszt wer przydzial
local `spec' = "`if'" + "`in'"
local `krok'=0
local `lgrup'=`k'
local `stop'=0
local `n'=_N
local `l_grup'=`k'

qui gen `reszt'=0


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

qui gen `przydzial'=1 ``spec''

local `grupy'="1"
qui gen `s'=_n
local `v'=0
foreach i of varlist `varlist'	{
	local ++`v'
				}
mat dis `A'=`varlist' ``spec'', `measure'

local `a'=colsof(`A')
local `lgrup'=`k'
qui gen `g'=1 ``spec''
qui gen `gtemp'=`g'
qui gen `gg'="1"
mat def `B'=J(``a'',2,.)
qui gen `numerg'=1 ``spec''
qui gen `numer'=_n
qui gen `numerak'=`numer'

local `stop'=0
local `krok'=0

char `g' [varname] "Nr_grupy"
char `numer' [varname] "Przebieg grupowania"
char `gg' [varname] "Nr grupy"
char `lab' [varname] "Obiekt"

local `it'=0
while ``stop''==0	{
	local `krok'=0
	qui replace `g'=`gtemp'
	qui levelsof(`g'), local(`a')
	qui sum `g'
	local `gr'=r(max)
	sort `g', stable
	forvalues i=1/``gr''	{
		local `b'=0
		forvalues j=1/``n''		{
			qui sum `g' in `j'
			
			if r(mean)==`i'			{
				local ++`b'
				qui replace `numerg'=``b'' in `j'
							}
						}
				}
	foreach i of local `a' {
		qui sum `g' if `g'==`i'
		if r(N)>1		{
			local ++`krok'
			tempvar D`i'
			mat dis `D`i''=`varlist' if `g'==`i', `measure'
			local `d'=rowsof(`D`i'')
			local `maxd'=0
			forvalues j=1/``d''	{
				forvalues k=1/``d''	{
				if `D`i''[`j',`k']>``maxd''	{
				local `b1'=`j'
				local `maxd'=`D`i''[`j',`k']
				local `b2'=`k'
								}
	
							} 
						}
			//matlist `D`i''
			qui sum `numer' if `numerg'==``b1'' & `g'==`i'
			local `o1'=r(mean)
			qui sum `numer' if `numerg'==``b2'' & `g'==`i'
			local `o2'=r(mean)
			if "`det'"!=""		{
				qui replace `numerak'=_n
				qui sum `numerak' if `numer'==``o1''
				local `o1'=r(mean)
				qui sum `numerak' if `numer'==``o2''
				local `o2'=r(mean)
				di _newline(1)
				di "W grupie G" `gg'[``o1''] " najbardziej oddalone od siebie są obiekty " `lab'[``o1''] " oraz " `lab'[``o2''] "."
				di as text "Odległość między nimi wynosi " %-9.3f ``maxd''
						}
			forvalues j=1/``n''	{
				qui sum `g' in `j'	
				if r(mean)==`i'		{
					
					qui sum `numerg' in `j'
					local `e'=r(mean) 
					
					if `D`i''[``e'',``b1'']<`D`i''[``e'',``b2'']		{
						
						qui replace `przydzial'=1 in `j'
												}
					else							{
						qui replace `przydzial'=2 in `j'
												}
					qui sum `przydzial' in `j'
					qui replace `gg'=`gg'+"`r(mean)'" in `j'
							}
						}
			
			if "`det'"!=""		{
				
				
				di "W oparciu o te dwa obiekty utworzono dwie nowe grupy obiektów"
				
				//levelsof(`gg') if `g'==`i', s( oraz ) 
				qui sort `gg', stable
				list `lab' `gg' if `g'==`i', subvarname noobs sepby(`gg') abb(33)
						}
			qui sort `gg', stable
			local `b'=1
			forvalues j=2/``n''	{
				if `gg'[`j'-1]!=`gg'[`j']	{
					local ++`b'
								}
				qui replace `gtemp'=``b'' in `j'
						}
			local ++`it'
			tempname g``it''
			qui gen `g``it'''=`gtemp'
			

				}
							


			
			}

		
				if ``krok''==0	{
					local `stop'=1
						}
	
	

			}	


		di "Przebieg procedury deglomeracji"
		char `lab' [varname] "Obiekt"
		format `g'  %9.0f
		char `gg' [varname] "Przebieg deglomeracji"
		sort `gg'
		tempvar len
		qui gen `len'=length(`gg'[_n])
		sort `len', stable
		local `n'=_N
		list `lab' `gg' ``spec'', subvarname noob abb(30) sep(``n'')
		if ``l_grup''>1	{
			local `a'=``l_grup''-1
			char `g``a''' [varname] "Nr grupy"
			sort `g'
			di "Grupowanie obiektów metodą deglomeracji"
			list `lab' `g``a''' , subvarname noobs abb(30) sepby(`g``a''')
			
			if "`zgr'" != "" {
				qui gen `zgr' = `g``a'''  // added export here
			}
		}
		sort `numer'	
		
	//matlist `B',  twidth(20) format(%9.0f) 
end
//end	