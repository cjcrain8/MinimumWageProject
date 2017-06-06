

//////////////////////////////
//							//
//	Chelsea Crain			//
//							//
//	03/22/2017				//
//							//
//	Calculate restaurant	//
// 		specific item info 	//
//	Yelp					//
//							//
//////////////////////////////

//clear all
set more off
//set maxvar 32767
//set matsize 800

local output_path = "/Users/cjcrain/MW_WriteUps"

/////////////////////////////////////////////////////////////////
// GENRAL PRICE PASS THROUGH REGS
/////////////////////////////////////////////////////////////////

/*
/////////////////////////////////////////////////////////////////
// yelp: prep data for analysis
/////////////////////////////////////////////////////////////////
local path "/Users/cjcrain/Yelp"
use "`path'/CleanedFiles/yelp_geo_item_data456710.dta", clear

drop if fastfood==1

replace ch_lnp = ch_lnp*10

gen temp = (ch_lnp>0 & !missing(ch_lnp))
by rest_id, sort: egen change = max(temp)
drop temp
 
gen temp = eat24==1
by rest_id, sort: egen eat24_any = max(temp)
drop temp

collapse (mean) ch_lnp (mean) ln_p (mean) price, by (rest_id  ///
	group dist_nynj_bord t ///
	newark sales ls chain emps mw_increase lag_mw_increase ///
	 time_l time_h state ///
	 change  exact_stars eat24_any grubhub lead_mw_increase ///
	mw_increase_competitor_l mw_increase_competitor_h lat_geo lon_geo )

sort rest_id t
gen ln_star = ln(exact_stars)
by rest_id: gen ch_stars = ln_star[_n]-ln_star[_n-1]	 

gen temp = exact_stars if t==1
by rest_id: egen star_apr16 = max(temp)
drop temp



/////////////////////////////////////////////////////////////////
// yelp: price pass through regressions: rest level
/////////////////////////////////////////////////////////////////
rename mw_increase mw_increase_y
rename lag_mw_increase lag_mw_increase_y

eststo clear


// w/ fixed effects	
eststo: reg ch_lnp   mw_increase_y lag_mw_increase_y   ///
		 i.t i.group  ///
		, cluster(group) noconstant

// w/ controls
eststo: reg ch_lnp  mw_increase_y lag_mw_increase_y   ///
		 i.t i.group  chain ls emps sales ///
		, cluster(group) noconstant
	
//with controls	
eststo: reg ch_lnp   mw_increase_y  lag_mw_increase_y  ///
	i.t i.group   if eat24_any==1  ///
	, cluster(group) noconstant
	
//with controls	
eststo: reg ch_lnp   mw_increase_y  lag_mw_increase_y  ///
	i.t i.group   if grubhub==1  ///
	, cluster(group) noconstant
	
//with controls	
eststo: reg ch_lnp    mw_increase_y  lag_mw_increase_y  ///
	i.t i.group   if grubhub==1 & eat24==1  ///
	, cluster(group) noconstant
	
	
use "/Users/cjcrain/Grubhub/CleanedFiles/grubhub_merged_panel_data.dta", clear	
drop if fastfood==1
replace ch_lnp = ch_lnp*10

collapse (mean) ch_lnp (mean) ln_p (mean) price, by (rest_id t group dist_nynj_bord ///
	newark sales ls chain employees mw_increase lag_mw_increase ///
	lag2_mw_increase lag3_mw_increase time_l time_h state yelp)
	
eststo: reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase  ///
		lag3_mw_increase i.t i.group  ///
		, cluster(group) noconstant	
	
eststo: reg ch_lnp mw_increase  lag_mw_increase lag2_mw_increase ///
	 lag3_mw_increase chain ls employees sales ///
	i.t i.group    ///
	, cluster(group) noconstant	
	
eststo: reg ch_lnp mw_increase  lag_mw_increase lag2_mw_increase ///
	 lag3_mw_increase chain ls employees sales ///
	i.t i.group  if yelp==1  ///
	, cluster(group) noconstant	
		
	
	
esttab using "`output_path'/pass_through_rest_regs.tex", ///
	se keep( mw_increase_y lag_mw_increase_y ///
	mw_increase lag_mw_increase lag2_mw_increase lag3_mw_increase ///
	) replace label ///
	coeflabels( ///
	mw_increase_y " $ Oct-Jan $ " ///
	lag_mw_increase_y " $ Jan-Apr $ " ///
	mw_increase " $ Dec-Jan $ " ///
	lag_mw_increase " $ Jan-Feb $ " ///
	lag2_mw_increase " $ Feb-Mar $ " ///
	lag3_mw_increase " $ Mar-Apr $ " ///
	) ///
	star( * .10 ** .05 *** .001)
	
*/	
	
	
	
/////////////////////////////////////////////////////////////////
// PRICE PASS THROUGH REGS: REST CHARS
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
// Yelp: pass through by rest chars regs
/////////////////////////////////////////////////////////////////
local path "/Users/cjcrain/Yelp"
use "`path'/CleanedFiles/yelp_geo_item_data456710.dta", clear

drop if fastfood==1

replace ch_lnp = ch_lnp*10

gen temp = (ch_lnp>0 & !missing(ch_lnp))
by rest_id, sort: egen change = max(temp)
drop temp
 
gen temp = eat24==1
by rest_id, sort: egen eat24_any = max(temp)
drop temp

collapse (mean) ch_lnp (mean) ln_p (mean) price, by (rest_id  ///
	group dist_nynj_bord t ///
	newark sales ls chain emps mw_increase lag_mw_increase ///
	 time_l time_h state ///
	 change  exact_stars eat24_any grubhub lead_mw_increase ///
	mw_increase_competitor_l mw_increase_competitor_h lat_geo lon_geo )

sort rest_id t
gen ln_star = ln(exact_stars)
by rest_id: gen ch_stars = ln_star[_n]-ln_star[_n-1]	 

gen temp = exact_stars if t==1
by rest_id: egen star_apr16 = max(temp)
drop temp



eststo clear 

eststo: quietly reg ch_lnp   mw_increase lag_mw_increase  ///
	i.group i.t emps ls chain  if sales<=168000, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp    mw_increase lag_mw_increase  ///
	i.group i.t emps ls chain  if sales>=598000, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp   mw_increase lag_mw_increase  ///
	i.group i.t sales  ls chain  if emps<3, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp   mw_increase lag_mw_increase  ///
	i.group i.t  sales  ls chain  if emps>=10, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp   mw_increase lag_mw_increase  ///
	i.group i.t sales  emps ls chain  if star_apr16<3, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp   mw_increase lag_mw_increase  ///
	i.group i.t sales emps ls chain  if star_apr16>=4, ///
		cluster(group) noconstant

esttab using "`output_path'/yelp_regs_restcats.tex", ///
	se keep(  mw_increase lag_mw_increase) replace label ///
	coeflabels(mw_increase "$ Oct-Jan $" ///
	lag_mw_increase "$ Jan-Apr$" ///
	sales Sales ls LS) ///
	mtitles ("Low Sales" "High Sales" "Low Emps" "High Emps" "Low Stars" ///
				 "High Stars" )
				 
				 
/////////////////////////////////////////////////////////////////
// PRICE PASS THROUGH REGS: ITEM CHARS
/////////////////////////////////////////////////////////////////
				 
/////////////////////////////////////////////////////////////////
// GH: pass through by item category regs
/////////////////////////////////////////////////////////////////
use "/Users/cjcrain/Grubhub/CleanedFiles/grubhub_merged_panel_data.dta", clear

drop if fastfood==1
replace ch_lnp = ch_lnp*10

eststo clear 

eststo:  reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	 lag3_mw_increase i.group i.t  if general_category=="popular", ///
		cluster(group) noconstant

eststo:  reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	lag3_mw_increase  i.group i.t   if general_category=="side", ///
		cluster(group) noconstant
eststo:  reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	 	lag3_mw_increase i.group i.t  if general_category=="sandwich", ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	lag3_mw_increase i.group i.t if general_category=="pizza", ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	lag3_mw_increase i.group i.t   if general_category=="entre", ///
		cluster(group) noconstant
	
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	lag3_mw_increase i.group i.t if general_category=="dessert", ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	lag3_mw_increase i.group i.t  if general_category=="drink", ///
		cluster(group) noconstant

esttab using "`path'/gh_item_regs_cats.tex", ///
	se keep(mw_increase lag_mw_increase lag2_mw_increase lag3_mw_increase) replace label ///
	coeflabels(mw_increase "$ Dec-Jan $" ///
	lag_mw_increase " $ Jan-Feb $ " ///
	lag2_mw_increase " $ Feb-Mar $ " ///
	lag3_mw_increase " $ Mar-April $ " ///
	sales Sales ls LS) ///
	mtitles ("Popular" "Side" "Sandwich" "Pizza" "Entre" "Desert" "Drink") ///
	star( * .10 ** .05 *** .001) 

	/*
/*
	/*
/////////////////////////////////////////////////////////////////
// quality means: rest level: yelp
/////////////////////////////////////////////////////////////////
//use "`path'/yelp_merged_panel_data456710.dta", clear
//drop if fastfood==1


//collapse (mean) ch_lnp (mean) ln_p (mean) price, by (rest_id scrape group dist_nynj_bord ///
	//newark sales ls chain employees mw_increase lag_mw_increase ///
	//lag2_mw_increase lag3_mw_increase time_l time_h state)
	
	
sort rest_id t
by rest_id: gen chJul = (ch_stars)*100 if t ==2
by rest_id: gen chOct = (ch_stars)*100 if t ==3
by rest_id: gen chJan = (ch_stars)*100 if t ==4
by rest_id: gen chApr = (ch_stars)*100 if t ==5

label var chJul "Apr-Jul"
label var chOct "Jul-Oct"
label var chJan "Oct-Jan"
label var chApr "Jan-Apr"

eststo clear

eststo g3: estpost summarize chJul chOct chJan chApr  if group==2
eststo g5: estpost summarize chJul chOct chJan chApr if group==3 
eststo g9: estpost summarize chJul chOct chJan chApr  if group==7 
eststo g6: estpost summarize chJul chOct chJan chApr  if group==4
//eststo g7: estpost summarize chJul chOct chJan chApr  if group==5
eststo g11: estpost summarize chJul chOct chJan chApr  if group==6
eststo g8: estpost summarize chJul chOct chJan chApr  if group==8 


esttab g3 g5 g9 g6  g11 g8  ///
	using "`path'/Output/quality_means_rest_yelp.tex", ///
	replace main(mean) ///
	aux(sd) ///
	mtitle("NYC" "NYC MSA" "MA" "Upstate"  "NJ"  "PA" ) ///
	nonumbers label 
/*
*/

/*	
/////////////////////////////////////////////////////////////////
// means: item level: yelp
/////////////////////////////////////////////////////////////////
use "`path'/yelp_merged_panel_data456710.dta", clear
drop if fastfood==1


collapse (mean) ch_lnp (mean) ln_p (mean) price, by (rest_id scrape group dist_nynj_bord ///
	newark sales ls chain employees mw_increase lag_mw_increase ///
	lag2_mw_increase lag3_mw_increase time_l time_h state)
	
	
sort full_id scrape
by full_id: gen chJul = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==5
by full_id: gen chOct = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==6
by full_id: gen chJan = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==7
by full_id: gen chFeb = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==8
by full_id: gen chMar = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==9
by full_id: gen chOctMar = (ln_p[_n] - ln_p[_n-3])*100 if scrape ==9

label var chJul "Jul-Apr"
label var chOct "Oct-Jul"
label var chJan "Jan-Oct"
label var chFeb "Feb-Jan"
label var chMar "Mar-Feb"
label var chJanMar "Mar-Jan"

eststo clear

eststo g3: estpost summarize chJul chOct chJan chFeb chMar  if group==3 & general_category!="drink"
eststo g4: estpost summarize chJul chOct chJan chFeb chMar  if group==4 & general_category!="drink"
eststo g5: estpost summarize chJul chOct chJan chFeb chMar  if group==5 & general_category!="drink"
eststo g9: estpost summarize chJul chOct chJan chFeb chMar  if group==9 & general_category!="drink"
eststo g6: estpost summarize chJul chOct chJan chFeb chMar  if group==6 & general_category!="drink"
eststo g7: estpost summarize chJul chOct chJan chFeb chMar  if group==7 & general_category!="drink"
eststo g11: estpost summarize chJul chOct chJan chFeb chMar  if group==11 & general_category!="drink"
eststo g8: estpost summarize chJul chOct chJan chFeb chMar  if group==8 & general_category!="drink"
eststo g10: estpost summarize chJul chOct chJan chFeb chMar  if group==10 & general_category!="drink"

esttab g3 g4 g5 g9 g6 g7 g11 g8 g10 ///
	using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\means_items_yelp.tex", ///
	replace main(mean) ///
	aux(sd) ///
	mtitle("NYC Large" "NYC Small" "NYC MSA" "MA" "Upstate" "CT" "VT" "NJ"  "PA" ) ///
	nonumbers label 

	

	
/////////////////////////////////////////////////////////////////
// EAT24 means: item level: yelp
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_merged_panel_data45678.dta", clear
drop if fastfood==1

sort full_id scrape
by full_id: gen chJul = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==5
by full_id: gen chOct = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==6
by full_id: gen chJan = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==7
by full_id: gen chFeb = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==8
by full_id: gen chMar = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==9
by full_id: gen chOctMar = (ln_p[_n] - ln_p[_n-3])*100 if scrape ==9

label var chJul "Jul-Apr"
label var chOct "Oct-Jul"
label var chJan "Jan-Oct"
label var chFeb "Feb-Jan"
label var chMar "Mar-Feb"

eststo clear

eststo g3: estpost summarize chJul chOct chJan chFeb chMar  if group==3 & general_category!="drink" & eat24==1 & state!= "CT" & state!="VT"
eststo g4: estpost summarize chJul chOct chJan chFeb chMar  if group==4 & general_category!="drink" & eat24==1 & state!= "CT" & state!="VT"
eststo g5: estpost summarize chJul chOct chJan chFeb chMar  if group==5 & general_category!="drink" & eat24==1 & state!= "CT" & state!="VT"
eststo g9: estpost summarize chJul chOct chJan chFeb chMar  if group==9 & general_category!="drink" & eat24==1 & state!= "CT" & state!="VT"
eststo g6: estpost summarize chJul chOct chJan chFeb chMar  if group==6 & general_category!="drink" & eat24==1 & state!= "CT" & state!="VT"
// eststo g7: estpost summarize chJul chOct chJan chFeb chMar  if group==7 & general_category!="drink" & eat24==1 & state!= "CT" & state!="VT"
// eststo g11: estpost summarize chJul chOct chJan chFeb chMar  if group==11 & general_category!="drink" & eat24==1 & state!= "CT" & state!="VT"
eststo g8: estpost summarize chJul chOct chJan chFeb chMar  if group==8 & general_category!="drink" & eat24==1 & state!= "CT" & state!="VT"
eststo g10: estpost summarize chJul chOct chJan chFeb chMar  if group==10 & general_category!="drink" & eat24==1 & state!= "CT" & state!="VT"

esttab g3 g4 g5 g9 g6  g8 g10 ///
	using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\means_items_eat24.tex", ///
	replace main(mean) ///
	aux(sd) ///
	mtitle("NYC Large" "NYC Small" "NYC MSA" "MA" "Upstate" "NJ"  "PA" ) ///
	nonumbers label 

	
/////////////////////////////////////////////////////////////////
// means: item level: yelp geocoded 
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_geo_item_data456789.dta", clear
drop if fastfood==1

sort full_id scrape
by full_id: gen chJul = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==5
by full_id: gen chOct = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==6
by full_id: gen chJan = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==7
by full_id: gen chFeb = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==8
by full_id: gen chMar = (ln_p[_n] - ln_p[_n-1])*100 if scrape ==9
by full_id: gen chOctMar = (ln_p[_n] - ln_p[_n-3])*100 if scrape ==9

label var chJul "Jul-Apr"
label var chOct "Oct-Jul"
label var chJan "Jan-Oct"
label var chFeb "Feb-Jan"
label var chMar "Mar-Feb"


eststo clear

eststo g3: estpost summarize chJul chOct chJan chFeb chMar  if group==1 & general_category!="drink"
eststo g4: estpost summarize chJul chOct chJan chFeb chMar  if group==2 & general_category!="drink"
eststo g5: estpost summarize chJul chOct chJan chFeb chMar  if group==6 & general_category!="drink"
eststo g9: estpost summarize chJul chOct chJan chFeb chMar  if group==3 & general_category!="drink"
eststo g6: estpost summarize chJul chOct chJan chFeb chMar  if group==4 & general_category!="drink"
eststo g7: estpost summarize chJul chOct chJan chFeb chMar  if group== 8 & general_category!="drink"
eststo g11: estpost summarize chJul chOct chJan chFeb chMar  if group==5 & general_category!="drink"
eststo g8: estpost summarize chJul chOct chJan chFeb chMar  if group==7 & general_category!="drink"


esttab g3 g4 g5 g9 g6 g7 g11 g8  ///
	using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\means_items_yelp_geo.tex", ///
	replace main(mean) ///
	aux(sd) ///
	mtitle("NYC" "NYC MSA" "MA" "NY Upstate" "CT" "VT" "NJ" "PA" ) ///
	nonumbers label 
	
	
/////////////////////////////////////////////////////////////////
// means: rest level: yelp
/////////////////////////////////////////////////////////////////
sort rest_id scrape
gen chJul = (ln_av_p[_n] - ln_av_p[_n-1])*100 if scrape ==5
gen chOct = (ln_av_p[_n] - ln_av_p[_n-1])*100 if scrape ==6
gen chJan = (ln_av_p[_n] - ln_av_p[_n-1])*100 if scrape ==7
gen chFeb = (ln_av_p[_n] - ln_av_p[_n-1])*100 if scrape ==8

eststo clear

eststo g3: estpost summarize chJul chOct chJan chFeb if group==3 & general_category!="drink"
eststo g4: estpost summarize chJul chOct chJan chFeb if group==4 & general_category!="drink"
eststo g5: estpost summarize chJul chOct chJan chFeb if group==5 & general_category!="drink"
eststo g9: estpost summarize chJul chOct chJan chFeb if group==9 & general_category!="drink"
eststo g6: estpost summarize chJul chOct chJan chFeb if group==6 & general_category!="drink"
eststo g7: estpost summarize chJul chOct chJan chFeb if group==7 & general_category!="drink"
eststo g11: estpost summarize chJul chOct chJan chFeb if group==11 & general_category!="drink"
eststo g8: estpost summarize chJul chOct chJan chFeb if group==8 & general_category!="drink"
eststo g10: estpost summarize chJul chOct chJan chFeb if group==10 & general_category!="drink"

esttab g3 g4 g5 g6 g7 g8 g9 g10 g11 ///
	using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\means_rest.csv", ///
	replace main(mean ) ///
	aux(sd) ///
	mtitle("NYC Large" "NYC Small" "NYC MSA" "MA" "Upstate" "CT" "VT" "NJ"  "PA" ) ///
	nonumbers label 


/////////////////////////////////////////////////////////////////
// means: item level: grubhub
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\GrubHub\grubhub_merged_panel_data.dta", clear
drop if fastfood==1

sort full_id scrape
gen chJan = (ln_p[_n] - ln_p[_n-1])*100 if t==2
gen chFeb = (ln_p[_n] - ln_p[_n-1])*100 if t ==3
gen chMar = (ln_p[_n] - ln_p[_n-1])*100 if t ==4

label var chJan "Jan-Dec"
label var chFeb "Feb-Jan"
label var chMar "Mar-Feb"

eststo clear

eststo g3: estpost summarize  chJan chFeb chMar if group==3 & general_category!="drink"
eststo g4: estpost summarize  chJan chFeb chMar if group==4 & general_category!="drink"
eststo g5: estpost summarize  chJan chFeb chMar if group==5 & general_category!="drink"
eststo g9: estpost summarize  chJan chFeb chMar if group==9 & general_category!="drink"
eststo g6: estpost summarize chJan chFeb chMar if group==6 & general_category!="drink"
eststo g7: estpost summarize  chJan chFeb chMar if group==7 & general_category!="drink"
//eststo g11: estpost summarize chJan chFeb chMar if group==11 & general_category!="drink"
eststo g8: estpost summarize  chJan chFeb chMar if group==8 & general_category!="drink"
eststo g10: estpost summarize  chJan chFeb chMar if group==10 & general_category!="drink"

esttab g3 g4 g5 g9 g6 g7 g8 g10 ///
	using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\means_items_gh.tex", ///
	replace main(mean ) ///
	aux(sd) ///
	mtitle("NYC Large" "NYC Small" "NYC MSA" "MA" "Upstate" "CT"  "NJ"  "PA" ) ///
	nonumbers label

	


/////////////////////////////////////////////////////////////////
// means: rest level: grubhub
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\GrubHub\grubhub_merged_panel_data.dta", clear
drop if fastfood==1

sort rest_id scrape
gen chJan = (ln_av_p[_n] - ln_av_p[_n-1])*100 if t==2
gen chFeb = (ln_av_p[_n] - ln_av_p[_n-1])*100 if t ==3
gen chMar = (ln_av_p[_n] - ln_av_p[_n-1])*100 if t ==4

eststo clear

eststo g3: estpost summarize  chJan chFeb chMar if group==3 
eststo g4: estpost summarize  chJan chFeb chMar if group==4
eststo g5: estpost summarize  chJan chFeb chMar if group==5 
eststo g9: estpost summarize  chJan chFeb chMar if group==9 
eststo g6: estpost summarize chJan chFeb chMar if group==6
eststo g7: estpost summarize  chJan chFeb chMar if group==7 
//eststo g11: estpost summarize chJan chFeb chMar if group==11 & general_category!="drink"
eststo g8: estpost summarize  chJan chFeb chMar if group==8 
eststo g10: estpost summarize  chJan chFeb chMar if group==10

esttab g3 g4 g5 g9 g6 g7 g8 g10 ///
	using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\means_rest_gh.tex", ///
	replace main(mean ) ///
	aux(sd) ///
	mtitle("NYC Large" "NYC Small" "NYC MSA" "MA" "Upstate" "CT"  "NJ"  "PA" ) ///
	nonumbers label
	
	
/////////////////////////////////////////////////////////////////
// yelp: price pass through regressions: item level
/////////////////////////////////////////////////////////////////


use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_merged_panel_data456789.dta", clear
drop if fastfood==1
replace ch_lnp = ch_lnp*10

eststo clear 

// with controls (Apr-Jan)
eststo:  reg ch_lnp mw_increase   i.group ///
	ls chain sales emps total_items if scrape <8 ///
	, cluster(group) noconstant
// no controls (Apr-Mar) 
eststo:  reg ch_lnp mw_increase  lag_mw_increase lag2_mw_increase ///
		i.group i.scrape ///
		, cluster(group) noconstant
// with controls  (Apr-Mar) 
eststo:  reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
		ls chain sales emps total_items ///
		i.group i.scrape ///
		, cluster(group) noconstant	
// eat24 
eststo:  reg ch_lnp mw_increase  lag_mw_increase lag2_mw_increase ///
		ls chain sales emps total_items ///
		i.group  i.scrape ///
		if eat24==1, ///
		cluster(group) noconstant	
		
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_geo_item_data45678.dta", clear
drop if fastfood==1
drop mw_increase  lag_mw_increase
rename average_increase mw_increase
rename lag_av_mw_inc lag_mw_increase 
rename lag2_av_mw_inc lag2_mw_increase

replace ch_lnp = ch_lnp*10
// with controls (Apr-Jan)
eststo:  reg ch_lnp mw_increase   i.group ///
	 if scrape <8 ///
	, cluster(group) noconstant
// no controls (Apr-Mar) 
eststo:  reg ch_lnp mw_increase  lag_mw_increase lag2_mw_increase ///
		i.group i.scrape ///
		, cluster(group) noconstant
// eat24 
eststo:  reg ch_lnp mw_increase  lag_mw_increase lag2_mw_increase ///
		i.group i.scrape ///
		if eat24==1 , ///
		cluster(group) noconstant			

esttab using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\item_regs_yelp.tex", ///
	se keep(mw_increase lag_mw_increase lag2_mw_increase ///
		  ///
		) replace label ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "$\Delta Ln(mw_{Jan-Oct}) $" ///
	sales Sales ls LS lag_ch_lnp "$\Delta Ln(P_{it-1}$)" ///
	emps Employees chain Chain ///
	lag_mw_increase "$\Delta Ln(mw_{Feb-Jan}) $" ///
	lag2_mw_increase "$\Delta Ln(mw_{Mar-Feb}) $") ///
	star( * .10 ** .05 *** .001) ///
	mtitles("RUSA" "RUSA" "RUSA" "RUSA+Eat24" "Geo" "Geo" "Geo+Eat24") 

	
	
/////////////////////////////////////////////////////////////////
// grubhub: price pass through regressions: item level
/////////////////////////////////////////////////////////////////

use "C:\Users\Chelsea\Documents\Research\MinWage\Data\GrubHub\grubhub_merged_panel_data.dta", clear
drop if fastfood==1
replace ch_lnp = ch_lnp*10
eststo clear

// no controls
eststo: reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase  ///
	, cluster(group) noconstant
	
eststo: reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase  ///
		 i.t i.group  ///
		, cluster(group) noconstant
	
//with controls	
eststo: reg ch_lnp mw_increase  lag_mw_increase lag2_mw_increase ///
	 chain ls employees sales ///
	i.t i.group    ///
	, cluster(group) noconstant

//eststo: reg ln_p mw   chain ls employees sales ///
	//i.t i.group total_items   ///
	//, cluster(group) noconstant


esttab using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\item_regs_both.tex", ///
	se keep(mw_increase lag_mw_increase lag2_mw_increase ) replace label ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "$\Delta Ln(mw_{Jan-Dec}) $" ///
	sales Sales ls LS lag_ch_lnp "$\Delta Ln(P_{it-1}$)" ///
	emps Employees chain Chain ///
	lag_mw_increase "$\Delta Ln(mw_{Feb-Jan}) $" ///
	lag2_mw_increase "$\Delta Ln(mw_{Mar-Feb}) $") ///
	star( * .10 ** .05 *** .001)
	
	*/
	*/
	
/////////////////////////////////////////////////////////////////
// Yelp: pass through by rest chars regs
/////////////////////////////////////////////////////////////////
//use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_merged_panel_data5678.dta", clear
//drop if fastfood==1

eststo clear 

eststo: quietly reg ch_lnp lead2_mw_increase lead_mw_increase mw_increase lag_mw_increase  ///
	i.group i.t emps ls chain  if sales<=168000, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp lead2_mw_increase lead_mw_increase  mw_increase lag_mw_increase  ///
	i.group i.t emps ls chain  if sales>=598000, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp lead2_mw_increase lead_mw_increase mw_increase lag_mw_increase  ///
	i.group i.t sales  ls chain  if emps<3, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp lead2_mw_increase lead_mw_increase mw_increase lag_mw_increase  ///
	i.group i.t  sales  ls chain  if emps>=10, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp lead2_mw_increase lead_mw_increase mw_increase lag_mw_increase  ///
	i.group i.t sales  emps ls chain  if star_apr16<3, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp lead2_mw_increase lead_mw_increase mw_increase lag_mw_increase  ///
	i.group i.t sales emps ls chain  if star_apr16>=4, ///
		cluster(group) noconstant

esttab using "`path'/Output/yelp_regs_restcats.tex", ///
	se keep( lead2_mw_increase lead_mw_increase mw_increase lag_mw_increase) replace label ///
	coeflabels(mw_increase "$ Oct-Jan $" ///
	lag_mw_increase "$ Jan-Apr$" ///
	sales Sales ls LS) ///
	mtitles ("Low Sales" "High Sales" "Low Emps" "High Emps" "Low Stars" ///
				 "High Stars" )
	
/*
/////////////////////////////////////////////////////////////////
// GH: pass through by rest chars regs
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\GrubHub\grubhub_merged_panel_data.dta", clear
drop if fastfood==1

eststo clear 

eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	i.group i.t  employees ls chain total_items if sales<=168000, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	i.group i.t employees ls chain total_items if sales>598000, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	i.group i.t sales  ls chain total_items if employees<=3, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	i.group i.t sales  ls chain total_items if employees>10, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	i.group i.t sales employees ls chain  if av_price <7.07925 , ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	i.group i.t sales employees  chain ls if av_price>10.29806, ///
		cluster(group) noconstant


esttab using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\item_regs_restcats_gh.tex", ///
	se keep(mw_increase lag_mw_increase lag2_mw_increase) replace label ///
	coeflabels(mw_increase "$\Delta Ln(mw_kt)$" ///
	lag_mw_increase "$\Delta Ln(mw_kt-1)$" ///
	lag2_mw_increase "$\Delta Ln(mw_{kt-2}) $" ///
	sales Sales ls LS) ///
	mtitles ("Low Sales" "High Sales" "Low Emps" "High Emps" ///
	"Low Price" "High Price" ) ///
	star( * .10 ** .05 *** .001) 

	
/////////////////////////////////////////////////////////////////
// GH: pass through by item category regs
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\GrubHub\grubhub_merged_panel_data.dta", clear
drop if fastfood==1
eststo clear 
graph drop _all

eststo:  reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	 i.group i.t sales employees ls chain  if general_category=="popular", ///
		cluster(group) noconstant
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) lwidth(thick)), name(a) title("Popular") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") ysc(r(0 .05)) ytic(0(.01).05)
eststo:  reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	 i.group i.t sales employees ls chain  if general_category=="side", ///
		cluster(group) noconstant
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) lwidth(thick)), name(b) title("Side") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") ysc(r(0 .05)) ytic(0(.01).05)
eststo:  reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	 	i.group i.t sales employees ls chain  if general_category=="sandwich", ///
		cluster(group) noconstant
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) lwidth(thick)), name(c) title("Sandwich") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") ysc(r(0 .05)) ytic(0(.01).05)
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="pizza", ///
		cluster(group) noconstant
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) lwidth(thick)), name(d) title("Pizza") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") ysc(r(0 .05)) ytic(0(.01).05)
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="entre", ///
		cluster(group) noconstant
		
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) yscale(r(0 .05)) ytic(0(.01).05) ymlabel(0(.01).05) lwidth(thick)), ///
	name(e) title("Entre") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") 
	
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="dessert", ///
		cluster(group) noconstant
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) lwidth(thick)), name(f) title("Dessert") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") ysc(r(0 .05)) ytic(0(.01).05)
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag2_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="drink", ///
		cluster(group) noconstant

esttab using "C:\Users\Chelsea\Documents\Research\MinWage\WriteUps\item_regs_cats_gh2.tex", ///
	se keep(mw_increase lag_mw_increase lag2_mw_increase) replace label ///
	coeflabels(mw_increase "$\Delta Ln(mw_{kt})$" ///
	lag_mw_increase "$\Delta Ln(mw_{kt-1})$" ///
	lag2_mw_increase "$\Delta Ln(mw_{kt-2}) $" ///
	sales Sales ls LS) ///
	mtitles ("Popular" "Side" "Sandwich" "Pizza" "Entre" "Desert" "Drink") ///
	star( * .10 ** .05 *** .001) 
	
graph combine a b c d e f 

/////////////////////////////////////////////////////////////////
// GH: pass through by category plot
/////////////////////////////////////////////////////////////////

twoway (lfitci total_chp lag2_mw_increase ///
	if (general_category!="breakfast" & general_category!="kids") ///
	& general_category!="other" ), by(category) ///
	graphregion(color(white)) bgcolor(white)
gr_edit .plotregion1.subtitle[1].text = {}
gr_edit .plotregion1.subtitle[1].text.Arrpush Other	
gr_edit .plotregion1.subtitle[2].text = {}
gr_edit .plotregion1.subtitle[2].text.Arrpush Breakfast	
gr_edit .plotregion1.subtitle[3].text = {}
gr_edit .plotregion1.subtitle[3].text.Arrpush Appetizer	
gr_edit .plotregion1.subtitle[4].text = {}
gr_edit .plotregion1.subtitle[4].text.Arrpush Side	
gr_edit .plotregion1.subtitle[5].text = {}
gr_edit .plotregion1.subtitle[5].text.Arrpush Soup/Sal	
gr_edit .plotregion1.subtitle[6].text = {}
gr_edit .plotregion1.subtitle[6].text.Arrpush Sandwich	
gr_edit .plotregion1.subtitle[7].text = {}
gr_edit .plotregion1.subtitle[7].text.Arrpush Pizza	
gr_edit .plotregion1.subtitle[8].text = {}
gr_edit .plotregion1.subtitle[8].text.Arrpush Entre	
gr_edit .plotregion1.subtitle[9].text = {}
gr_edit .plotregion1.subtitle[9].text.Arrpush Kids	
gr_edit .plotregion1.subtitle[10].text = {}
gr_edit .plotregion1.subtitle[10].text.Arrpush Dessert
gr_edit .plotregion1.subtitle[11].text = {}
gr_edit .plotregion1.subtitle[11].text.Arrpush Drink
gr_edit .plotregion1.subtitle[12].text = {}
gr_edit .plotregion1.subtitle[12].text.Arrpush  Popular	
	
*/
*/
/////////////////////////////////////////////////////////////////
// change in quality regs
/////////////////////////////////////////////////////////////////

//use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_rest_level_merged_panel_data45678.dta", clear

//drop if fastfood==1
	
eststo clear

eststo:  reg ch_stars lead_mw_increase mw_increase lag_mw_increase ///
	 i.group star_apr16 i.t  ///
	, cluster(group) noconstant
	
eststo:  reg ch_stars lead_mw_increase mw_increase lag_mw_increase ///
	 i.group star_apr16 i.t ls sales emps price ///
	, cluster(group) noconstant
	
//eststo: quietly reg ch_star mw_increase lag_mw_increase ///
//	 ch_lnp i.group star_apr16 i.t  ///
//	, cluster(group) noconstant
	
//eststo: quietly reg ch_star mw_increase lag_mw_increase  ///
	// i.group star_apr16 i.t ls sales emps ///
	//, cluster(group) noconstant
	 
//eststo: quietly reg ch_star mw_increase lag_mw_increase ///
	//ch_lnp i.group i.scrape  stars_5 chain ls sales emps ///
	//if stars_5 < 3, cluster(group)

eststo:  reg ch_stars lead_mw_increase mw_increase lag_mw_increase ///
	  i.group  i.t ///
		if star_apr16 <3 , cluster(group) noconstant
		
eststo: quietly reg ch_stars lead_mw_increase mw_increase lag_mw_increase ///
	  i.group  i.t  ///
		if star_apr16 ==3 , cluster(group) noconstant
	
eststo: quietly reg ch_stars lead_mw_increase mw_increase lag_mw_increase ///
	  i.group i.t  ///
	if star_apr16 == 3.5, cluster(group) noconstant

eststo: quietly reg ch_stars lead_mw_increase  mw_increase lag_mw_increase ///
	   i.group i.t ///
	if star_apr16 == 4, cluster(group)	 noconstant
	
eststo: quietly reg ch_stars lead_mw_increase mw_increase lag_mw_increase ///
	  i.group i.t   ///
	if star_apr16 >4 , cluster(group) noconstant
	
//eststo: quietly reg ch_star mw_increase lag_mw_increase ///
	//ch_lnp i.group i.scrape stars_5 chain ls sales emps ///
	//if stars_5 ==5 , cluster(group)
	
esttab using "`path'/Output/quality_regs.tex", ///
	se keep(lead_mw_increase mw_increase lag_mw_increase) replace label ///
	coeflabels(mw_increase "$ Oct-Jan $" ///
	lag_mw_increase "$ Jan-Apr $" ///
	sales Sales ls LS) ///
	mtitles ("All" "Cntrls" "<=2.5" "3" "3.5" "4" ">4")

/*
/////////////////////////////////////////////////////////////////
// change in quality density figure
/////////////////////////////////////////////////////////////////

graph drop _all

twoway  /// (kdensity exact_star if group==3 & scrape==4) ///
/// (kdensity exact_star if group==3 & scrape==5) ///
(kdensity exact_star if group==3 & scrape==6 & chain==0 , lwidth(thick) lcolor(emidblue) ) ///
(kdensity exact_star if group==3 & scrape==8 & chain==0, lwidth(thick) lcolor(cranberry)), ///
xtitle("Exact Yelp Star Rating") ytitle("Density") ///
graphregion(fcolor(white)) ///
legend(label(1 "Oct '16") label(2 "Feb '17")) name(b) xsc(r(1 5))  ///
title("NYC Lg Non-Chain")

twoway /// (kdensity exact_star if newarkmsa==1 &  fs==1 & emps > 10 & scrape==4) ///
/// (kdensity exact_star if newarkmsa==1 &  fs==1 & emps > 10 & scrape==5) ///
(kdensity exact_star if  newarkmsa==1  & emps > 10 & scrape==6, lwidth(thick) lcolor(emidblue)  ) ///
(kdensity exact_star if newarkmsa==1 & emps >10 & scrape==8, lwidth(thick) lcolor(cranberry)) , ///
xtitle("Exact Yelp Star Rating") ytitle("Density") ///
graphregion(fcolor(white)) ///
legend(label(1 "Oct '16") label(2 "Feb '17")) name(a) xsc(r(1 5)) ///
title("Newark, NJ MSA Lg Non-Chain")

graph combine a b, ysize(3) xsize(7)


/////////////////////////////////////////////////////////////////
// other non-price outcomes 
/////////////////////////////////////////////////////////////////

drop if fastfood==1

eststo clear

eststo:  reg ch_hours mw_increase lag_mw_increase  i.group ///
	 ls chain sales emps  if hrs_days==1 ///
	, cluster(group) noconstant

eststo:  reg ch_days mw_increase lag_mw_increase  i.group ///
	 ls chain sales emps  if hrs_days==1, ///
	cluster(group) noconstant

eststo:  reg ch_items mw_increase lag_mw_increase  i.group ///
	 ls chain sales emps , ///
	cluster(group) noconstant
	
esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_03.23.17\non_pr_regs.tex", ///
	se keep(mw_increase lag_mw_increase) replace label ///
	coeflabels(mw_increase "$\Delta Ln(mw_kt)$" ///
	lag_mw_increase "$\Delta Ln(mw_kt-1)$" ///
	sales Sales ls LS) ///
	mtitles ("Hours" "Days" "Total Items")
	
	
*/
*/
/*
/////////////////////////////////////////////////////////////////
// distance
/////////////////////////////////////////////////////////////////

//use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_merged_panel_data5678.dta", clear
//drop if fastfood==1

sort rest_id t
by rest_id: gen total_chlnp = ln_p[_n]-ln_p[_n-2] if t==5

replace dist_nynj_bord = 	dist_nynj_bord /60
replace dist_nynj = dist_nynj-6 if dist_nynj >0

// create ny-nymsa border effects
gen ny = state=="NY"

gen dist_nyny_bord = .
replace dist_nyny_bord = time_l if (group== 2) ///
	& mw_increase_competitor_l==".1111"
	
replace dist_nyny_bord = time_h*-1 if group==3 & ///
	(mw_increase_competitor_h==.1945)
	
replace dist_nyny_bord = 	dist_nyny_bord /60

gen nyc = group==2



///////////// main distance graph ////////////////////
local dist = 10
binscatter total_chlnp dist_nynj_bord if dist_nynj_bord<`dist' ///
	& dist_nynj_bord >-	`dist'-7 & t==5, by(ny) nquantiles(60) ///
	graphregion(fcolor(white)) title("Border Effects:" ///
	"Price Pass Through By Distance to NJ/NY Border") ///
	xtitle("Distance from NJ/NY Border") ///
	ytitle("%Change(P): Oct to Feb") ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York"))
	
graph export "`path'/Output/distance_yelp.pdf", as(pdf) replace


//////////// distance regs //////////////////////

local dist = 10
eststo clear

/*
reg total_ch  ny dist_nynj_bord ny#c.dist_nynj_bord ///
	if dist_nynj_bord <25 & dist_nynj_bord>-35 

reg total_ch  ny dist_nynj_bord ny#c.dist_nynj_bord ///
	d2 ny#c.d2 ///
	if dist_nynj_bord <25 & dist_nynj_bord>-35
*/	
eststo: quietly reg total_chlnp  ny dist_nynj_bord ny#c.dist_nynj_bord  ///
	if dist_nynj_bord < `dist' & dist_nynj_bord>-`dist'-10
	
eststo: quietly reg total_chlnp  ny dist_nynj_bord ny#c.dist_nynj_bord  ///
	if dist_nynj_bord < `dist' & dist_nynj_bord>-`dist'-10 & change==1
	
eststo: quietly reg total_chlnp  ny dist_nynj_bord ny#c.dist_nynj_bord  ///
	if dist_nynj_bord < `dist' & dist_nynj_bord>-`dist'-10 & eat24_any==1
	
eststo: quietly reg total_chlnp  ny dist_nynj_bord ny#c.dist_nynj_bord ///
	chain ls emps sales ///
	if dist_nynj_bord <`dist' & dist_nynj_bord>-`dist'-10

//july to october: want to be non-significant
eststo: quietly reg ch_lnp  ny dist_nynj_bord ny#c.dist_nynj_bord chain ls emps sales ///
	if dist_nynj_bord <`dist' & dist_nynj_bord>-`dist'-10	& t==2

eststo: quietly reg total_chlnp  nyc dist_nyny_bord nyc#c.dist_nyny_bord ///
	if dist_nyny_bord <`dist' & dist_nyny_bord>-`dist'-10 
	
esttab using "`path'/Output/yelp_dist_regs.tex", ///
	se replace label  ///
	coeflabels( /// total_ch "$ \Delta Ln(P_{oct-feb}) $" ///
		ny "\textbf{1}(NY)" ///
		dist_nynj_bord "Distance" ) ///
				
		///
	//mtitles("$\Delta Ln(P_{oct-feb})$" "$\Delta Ln(P_{oct-feb})$" "$\Delta Ln(P_{jul-oct})$" ///
	//	"$\Delta Ln(P_{oct-feb})$")
	

