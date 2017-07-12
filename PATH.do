
/*


import delimited Z:\Yelp\yelp_rest_data_678910.csv, clear
merge m:1 url using "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_pubtrans_distances.dta"
drop _merge

 
import delimited Z:\MW_WriteUps\gh_reg_prepped.csv, clear 
merge m:1 full_address using "C:\Users\Chelsea\Documents\Research\MinWage\Distances\GrubhubPubTransp\gh_pubtrans_distances.dta"


destring(time_stop), replace force 

replace time_stop = time_stop * -1 if state=="NJ"
replace time_stop = time_stop /60

gen ny = state=="NY"

sort rest_id t
by rest_id: gen total_chlnp = ln_p[_n]-ln_p[_n-2]

sort rest_id t
by rest_id: gen total_chstar = exact_star[_n]-exact_star[_n-2]

*/


/////////////////////////////////////////////////////////////////
// yelp
/////////////////////////////////////////////////////////////////

local dist = 8
local lower = 8

import delimited Z:\Yelp\yelp_rest_data_678910.csv, clear
merge m:1 url using "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_pubtrans_distances.dta"
drop _merge

local output_path = "/Users/cjcrain/MW_WriteUps"

drop if fastfood==1

destring(time_stop), replace force 

replace time_stop = time_stop * -1 if state=="NJ"
replace time_stop = time_stop /60

gen ny = state=="NY"

sort rest_id t
by rest_id: gen total_chlnp = ln_p[_n]-ln_p[_n-2]


///////////// main distance graph ////////////////////
* ny nj

binscatter total_chlnp time_stop if time_stop<`dist' ///
	& time_stop >-	`lower' & t==3 , by(ny) nquantiles(80) ///
	graphregion(fcolor(white)) ///
	xtitle("Distance from PATH Stop") ///
	ytitle(" Change(Ln(p)): Oct16-Apr17") ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York")) name(a)
		

binscatter total_chlnp time_stop if time_stop<`dist' ///
	& time_stop >-	`lower' & t==5 , by(ny) nquantiles(80) ///
	graphregion(fcolor(white)) ///
	xtitle("Distance from PATH Stop") ///
	ytitle(" Change(Ln(p)): Oct16-Apr17") ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York")) name(b)
	
//graph export "`output_path'/distance_yelp.pdf", as(pdf) replace


	
//////////// distance regs //////////////////////
	
gen inter = ny * time_stop

destring(inter), replace force



* yelp
reg total_chlnp  ny time_stop inter  ///
	if time_stop < `dist' & time_stop>-`lower' & t==5
local n = e(N)
lincom time_stop + inter
local total = round(r(estimate), 0.0001)
local total_se = round(r(se), 0.0001)
local p_val = `total'/`total_se'
if `p_val'>1.281552 {
	local stars = "*"
}
if `p_val'>1.644854 {
	local stars = "**"
}
if `p_val'>2.32635 {
	local stars = "***"
}
if `p_val'<=1.281552 {
	local stars = ""
}
outreg, se ///
		noauto	starlevels( 10 05 1) starloc(1) ///
		sdec(4) ///
		addrows(" $ \alpha_2 + \alpha_3 $ " "0`total'`stars'" \ ///
				"" "(0`total_se')" \ " $ N $ " `n')  

reg total_chlnp  ny time_stop inter  ///
	if time_stop <`dist' & time_stop>-`lower'	& t==3
local n = e(N)
lincom inter + inter
local total = round(r(estimate), 0.0001)
local total_se = round(r(se), 0.0001)
local p_val = `total'/`total_se'
if `p_val'>1.281552 {
	local stars = "*"
}
if `p_val'>1.644854 {
	local stars = "**"
}
if `p_val'>2.32635 {
	local stars = "***"
}
if `p_val'<=1.281552 {
	local stars = ""
}
outreg, se ///
		noauto	starlevels( 10 05 1) starloc(1) merge ///
		sdec(4)  ///
		addrows(" $ \alpha_2 + \alpha_3 $ " "0`total'`stars'" \ ///
				"" "(0`total_se')" \ " $ N $ " `n')  

	
* grubhub	
 
 



import delimited Z:\MW_WriteUps\gh_reg_prepped.csv, clear 
merge m:1 full_address using "C:\Users\Chelsea\Documents\Research\MinWage\Distances\GrubhubPubTransp\gh_pubtrans_distances.dta"

drop if (state!="NY" & state!="NJ" & state!="MA")

gen ny = state=="NY"
	


destring(time_stop), replace force 

replace time_stop = time_stop * -1 if state=="NJ"
replace time_stop = time_stop /60

sort rest_id t
by rest_id: gen total_chlnp = ln_p[_n]-ln_p[_n-4]

gen inter = ny * time_stop



///////////// main distance graph ////////////////////

binscatter total_chlnp time_stop if time_stop<`dist' ///
	& time_stop >-	`lower' & t==5 , by(ny) nquantiles(80) ///
	graphregion(fcolor(white)) ///
	xtitle("Distance from PATH Stop") ///
	ytitle(" Change(Ln(p)): Oct16-Apr17") ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York")) name(c)
	
//graph export "`output_path'/distance_yelp.pdf", as(pdf) replace



reg total_chlnp  ny time_stop inter  ///
	if time_stop <`dist' & time_stop>-`lower'
local n = e(N)
lincom time_stop + inter
local total = round(r(estimate), 0.0001)
local total_se = round(r(se), 0.0001)
local p_val = `total'/`total_se'
if `p_val'>1.281552 {
	local stars = "*"
}
if `p_val'>1.644854 {
	local stars = "**"
}
if `p_val'>2.32635 {
	local stars = "***"
}
if `p_val'<=1.281552 {
	local stars = ""
}
outreg, se ///
		noauto	starlevels( 10 05 1) starloc(1) merge ///
		sdec(4)  ///
		addrows(" $ \alpha_2 + \alpha_3 $ " "0`total'`stars'" \ ///
				"" "(0`total_se')" \ " $ N $ " `n')  
			

	
frmttable using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\path_dist_regs8.tex", tex  replace fragment ///
	hlines(10001{0}1011) plain notefont(tiny) ///
	ctitles("Source", "Yelp", " ",  "Grubhub",  \ ///
		"", "(1)", "(2)", "(3)" \ ///
		"Comparison Area", "  NJ   ", "  NJ   ",  "  NJ   " \ ///
		"Time Frame", "Oct16-Apr17", "Apr16-Oct16", , "Dec16-Apr17" ) ///
	rtitles ( " $ \mathbbm{1}(NY) \quad (\alpha_1) $ " \ " " ///
		\ " Distance $\quad (\alpha_2) $ " \ " " \ ///
		" Distance * $ \mathbbm{1}(NY) \quad (\alpha_3) $ " \ " " ///
		\ " Constant $\quad (\alpha_0) $ " \ " "  ///
		\ " $ \alpha_2 + \alpha_3 $ " \ " " ///
		\ " $ N $ " ) ///
	multicol(1,2,2) 
			
			
			/*

local dist 30
reg total_chstar  ny time_stop ny#c.time_stop ///
	if time_stop < `dist' & time_stop>-`dist' & t==5
	
	///
	& (stop_name=="World Trade Center" ///
	| (state=="NJ" & stop_name!="Hoboken") )
	
reg total_chlnp  ny time_stop ny#c.time_stop ///
	if time_stop < `dist' & time_stop>-`dist' & t==3

local dist 15
local lower 15
	
binscatter total_chstar time_stop if time_stop < `dist' ///
	& time_stop >-	`lower'	& t==5 ///
	,by(ny) nquantiles(90) ///
	graphregion(fcolor(white)) title("Border Effects:" ///
	"Price Pass Through By Distance to NJ/NY Border") ///
	xtitle("Distance From PATH Stop") ///
	ytitle(" Change(P): Oct-Apr") ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York")) 
		
local dist 0
local lower 20
binscatter total_chlnp time_stop if time_stop < `dist' ///
	& time_stop >-	`lower'	& t==5 
	
	
graph drop a b
	
local dist 10
local lower 10
	
binscatter ch_lnp time_stop if time_stop < `dist' ///
	& time_stop >-	`lower'	& t==3  ///
	& total_chlnp<.4 & total_chlnp>-.1  ///
	, by(ny) nquantiles(70) ///
	graphregion(fcolor(white)) title("Border Effects:" ///
	"Price Pass Through By Distance to NJ/NY Border") ///
	xtitle("Distance from NJ/NY Border") ///
	ytitle(" Change(P): Oct-Apr") ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York")) name(a)
		
binscatter ch_lnp time_stop if time_stop < `dist' ///
	& time_stop >-	`lower'	& t==5  ///
	& total_chlnp<.4 & total_chlnp>-.1  ///
	, by(ny) nquantiles(70) ///
	graphregion(fcolor(white)) title("Border Effects:" ///
	"Price Pass Through By Distance to NJ/NY Border") ///
	xtitle("Distance from NJ/NY Border") ///
	ytitle(" Change(P): Oct-Apr") ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York")) name(b)
		
graph combine a b	
		

		
graph drop a b
	
local dist 10
local lower 10
	
binscatter ch_lnp time_stop if time_stop < `dist' ///
	& time_stop >-	`lower'	& t==3 & ///
	(stop_name=="World Trade Center" ///
	| state=="NJ") ///
	& total_chlnp<.4 & total_chlnp>-.1  ///
	, by(ny) nquantiles(70) ///
	graphregion(fcolor(white)) title("Border Effects:" ///
	"Price Pass Through By Distance to NJ/NY Border") ///
	xtitle("Distance from NJ/NY Border") ///
	ytitle(" Change(P): Oct-Apr") ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York")) name(a)
		
binscatter ch_lnp time_stop if time_stop < `dist' ///
	& time_stop >-	`lower'	& t==5 & ///
	(stop_name=="World Trade Center" ///
	| state=="NJ") ///
	& total_chlnp<.4 & total_chlnp>-.1  ///
	, by(ny) nquantiles(70) ///
	graphregion(fcolor(white)) title("Border Effects:" ///
	"Price Pass Through By Distance to NJ/NY Border") ///
	xtitle("Distance from NJ/NY Border") ///
	ytitle(" Change(P): Oct-Apr") ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York")) name(b)
		
graph combine a b	

local dist 5	
binscatter total_chlnp time_stop if time_stop < `dist' & t==5 ///
	& state=="NY", nquantiles(90)
	

gen temp_stars = star_apr16
replace temp_stars =2.5 if temp_stars<2.5
	graph drop a b c d e f


gen group_name=""
replace group_name = "NYC" if group ==2
replace group_name = "NYC MSA" if group ==3
replace group_name = "Upstate NY" if group ==4 
replace group_name = "NJ" if group ==6
replace group_name = "MA" if group ==7

//replace total_chstar = total_chstar/100




graph bar total_chstar  if all_stars==1 & star_apr16>2.5 & star_apr16<5 & t==5, ///
	over(group_name, label(angle(45) ) sort(mw_group)) graphregion(color(white)) ///
	by(star_apr16,  note("")  ) bgcolor(white) ///
	yscale(range(-.1,.15)) ylabel(#5) ymtick(-.1(.02).15) ///
	ytitle("Change in Star Rating Oct16-Apr17 (%)") ///
	bar(1,color(cranberry))
	
gr_edit plotregion1.subtitle[1].text = {}
gr_edit plotregion1.subtitle[1].text.Arrpush Stars=3

gr_edit plotregion1.subtitle[2].text = {}
gr_edit plotregion1.subtitle[2].text.Arrpush Stars=3.5
// subtitle[2] edits

gr_edit plotregion1.subtitle[3].text = {}
gr_edit plotregion1.subtitle[3].text.Arrpush Stars=4
// subtitle[3] edits

gr_edit plotregion1.subtitle[4].text = {}
graph export "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\qualitybars.pdf", as(pdf) replace



gr_edit plotregion1.subtitle[4].text.Arrpush Stars=4.5

	bgcolor(white) name(a) legend(off) ///
	title("Stars<=2.5") ytitle("Chane in Star Rating Oct-Apr") xtitle("")
twoway (lfitci ch_stars mw_group if all_stars==1 & star_apr16==3 & t==2), ///
	graphregion(color(white)) bgcolor(white) name(b) legend(off) ///
	title("Stars=3") xtitle("")
twoway (lfitci ch_stars mw_group if all_stars==1 & star_apr16==3.5 & t==2), ///
	graphregion(color(white)) bgcolor(white) name(c) legend(off) ///
	title("Stars=3.5") xtitle("")
twoway (lfitci ch_stars mw_group if all_stars==1 & star_apr16==4 & t==2), ///
	graphregion(color(white)) bgcolor(white) name(d) legend(off) ///
	title("Stars=4") xtitle("Change in MW") ytitle("Chane in Star Rating Oct-Apr")
twoway (lfitci ch_stars mw_group if all_stars==1 & star_apr16==4.5 & t==2), ///
	graphregion(color(white)) bgcolor(white) name(e) legend(off) ///
	title("Stars=4.5") xtitle("Change in MW")
twoway (lfitci ch_stars mw_group if all_stars==1 & star_apr16==5 & t==2 ), ///
	graphregion(color(white)) bgcolor(white) name(f) legend(off) ///
	title("Stars=5") xtitle("Change in MW")
graph combine a b c d e f, title("Change in Star Rating and Minimum Wage Increase")


