

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

clear all
set more off
set maxvar 32767
set matsize 11000




/////////////////////////////////////////////////////////////////
// price pass through regressions: item level
/////////////////////////////////////////////////////////////////

eststo clear 

use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_merged_panel_data5678.dta", clear
drop if fastfood==1
// no controls
eststo:  reg ch_lnp mw_increase lag_mw_increase lag_ch_lnp i.group ///
	i.scrape, cluster(group) noconstant
// with controls
eststo:  reg ch_lnp mw_increase lag_mw_increase lag_ch_lnp i.group ///
	i.scrape ls chain sales emps total_items, cluster(group) noconstant
	

use "C:\Users\Chelsea\Documents\Research\MinWage\Data\GrubHub\grubhub_merged_panel_data.dta", clear
drop if fastfood==1
// no controls
eststo: reg ch_lnp mw_increase lag_mw_increase   ///
	i.t i.group  ///
	, cluster(group) noconstant
//with controls	
eststo: reg ch_lnp mw_increase  lag_mw_increase chain ls employees sales ///
	i.t i.group total_items   ///
	, cluster(group) noconstant
// change from dec to feb 	
eststo: reg total_chp lag_mw_increase  chain ls employees sales ///
	i.t i.group total_items  ///
	, cluster(group) noconstant


esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_03.23.17\item_regs.tex", ///
	se keep(mw_increase lag_mw_increase lag_ch_lnp) replace label ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "$\Delta Ln(MW_{kt}) $" ///
	sales Sales ls LS lag_ch_lnp "$\Delta Ln(P_{it-1}$)" ///
	emps Employees chain Chain ///
	lag_mw_increase "$\Delta Ln(MW_{kt-1}) $") ///
	mtitles("Yelp" "Yelp" "GH" "GH" "GH")
	
	
/////////////////////////////////////////////////////////////////
// Yelp: pass through by rest chars regs
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_merged_panel_data5678.dta", clear
drop if fastfood==1

eststo clear 

eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag_ch_lnp ///
	i.group i.scrape  emps ls chain total_items if sales<=168000, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag_ch_lnp ///
	i.group i.scrape emps ls chain total_items if sales>=598000, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag_ch_lnp ///
	i.group i.scrape sales  ls chain total_items if emps<=3, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag_ch_lnp ///
	i.group i.scrape  sales  ls chain total_items if emps>=10, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag_ch_lnp ///
	i.group i.scrape sales emps ls chain total_items if stars_5<3, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase lag_ch_lnp ///
	i.group i.scrape sales emps ls chain total_items if stars_5>=4, ///
		cluster(group) noconstant

esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_03.23.17\item_regs_restcats_gh.tex", ///
	se keep(mw_increase lag_mw_increase) replace label ///
	coeflabels(mw_increase "$\Delta Ln(mw_kt)$" ///
	lag_mw_increase "$\Delta Ln(mw_kt-1)$" ///
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

eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t  employees ls chain total_items if sales<=229000, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t employees ls chain total_items if sales>229000, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales  ls chain total_items if employees<=7, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales  ls chain total_items if employees>7, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales employees ls chain  if total_items<=181, ///
		cluster(group) noconstant
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales employees ls chain  if total_items>181, ///
		cluster(group) noconstant


esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_03.23.17\item_regs_restcats_gh.tex", ///
	se keep(mw_increase lag_mw_increase) replace label ///
	coeflabels(mw_increase "$\Delta Ln(mw_kt)$" ///
	lag_mw_increase "$\Delta Ln(mw_kt-1)$" ///
	sales Sales ls LS) ///
	mtitles ("Low Sales" "High Sales" "Low Emps" "High Emps" "Low Items" "High Items" )
*/	
	
/////////////////////////////////////////////////////////////////
// GH: pass through by category regs
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\GrubHub\grubhub_merged_panel_data.dta", clear
drop if fastfood==1
eststo clear 
graph drop _all

eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="popular", ///
		cluster(group) noconstant
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) lwidth(thick)), name(a) title("Popular") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") ysc(r(0 .05)) ytic(0(.01).05)
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="side", ///
		cluster(group) noconstant
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) lwidth(thick)), name(b) title("Side") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") ysc(r(0 .05)) ytic(0(.01).05)
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="sandwich", ///
		cluster(group) noconstant
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) lwidth(thick)), name(c) title("Sandwich") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") ysc(r(0 .05)) ytic(0(.01).05)
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="pizza", ///
		cluster(group) noconstant
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) lwidth(thick)), name(d) title("Pizza") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") ysc(r(0 .05)) ytic(0(.01).05)
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="entre", ///
		cluster(group) noconstant
		
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) yscale(r(0 .05)) ytic(0(.01).05) ymlabel(0(.01).05) lwidth(thick)), ///
	name(e) title("Entre") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") 
	
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="dessert", ///
		cluster(group) noconstant
twoway (function y =  _b[mw_increase]*x + _b[lag_mw_increase]*x, ///
	range(0 .25) lwidth(thick)), name(f) title("Dessert") graphregion(color(white)) bgcolor(white) ///
	xtitle("% Change Min Wage") ytitle("% Change Price") ysc(r(0 .05)) ytic(0(.01).05)
eststo: quietly reg ch_lnp mw_increase lag_mw_increase ///
	i.group i.t sales employees ls chain total_items if general_category=="drink", ///
		cluster(group) noconstant

esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_03.23.17\item_regs_cats_gh.tex", ///
	se keep(mw_increase lag_mw_increase) replace label ///
	coeflabels(mw_increase "$\Delta Ln(mw_kt)$" ///
	lag_mw_increase "$\Delta Ln(mw_kt-1)$" ///
	sales Sales ls LS) ///
	mtitles ("Popular" "Side" "Sandwich" "Pizza" "Entre" "Desert" "Drink")
	
graph combine a b c d e f 

/////////////////////////////////////////////////////////////////
// GH: pass through by category plot
/////////////////////////////////////////////////////////////////

twoway (lfitci total_inc lag_mw_increase), by(category) ///
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
	
	
/////////////////////////////////////////////////////////////////
// change in quality regs
/////////////////////////////////////////////////////////////////

use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_rest_level_merged_panel_data5678.dta", clear

drop if fastfood==1
	
eststo clear

eststo: quietly reg ch_lnstr mw_increase lag_mw_increase ///
	ch_lnp lag_ch_lnp i.group i.scrape stars_5 chain ls sales emps ///
	, cluster(group) noconstant
	 
//eststo: quietly reg ch_star mw_increase lag_mw_increase ///
	//ch_lnp i.group i.scrape  stars_5 chain ls sales emps ///
	//if stars_5 < 3, cluster(group)
	
eststo: quietly reg ch_lnstr mw_increase lag_mw_increase ///
	ch_lnp lag_ch_lnp i.group i.scrape stars_5 chain ls sales emps ///
	if stars_5 <=3 , cluster(group) noconstant
	
eststo: quietly reg ch_lnstr mw_increase lag_mw_increase ///
	ch_lnp lag_ch_lnp i.group i.scrape stars_5 chain ls sales emps ///
	if stars_5 == 3.5, cluster(group) noconstant

eststo: quietly reg ch_lnstr mw_increase lag_mw_increase ///
	ch_lnp  lag_ch_lnp i.group i.scrape stars_5 chain ls sales emps ///
	if stars_5 == 4, cluster(group)	 noconstant
	
eststo: quietly reg ch_lnstr mw_increase lag_mw_increase ///
	ch_lnp lag_ch_lnp i.group i.scrape stars_5 chain ls sales emps ///
	if stars_5 >4 , cluster(group) noconstant
	
//eststo: quietly reg ch_star mw_increase lag_mw_increase ///
	//ch_lnp i.group i.scrape stars_5 chain ls sales emps ///
	//if stars_5 ==5 , cluster(group)
	
esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_03.23.17\quality_regs.tex", ///
	se keep(mw_increase lag_mw_increase) replace label ///
	coeflabels(mw_increase "$\Delta Ln(mw_kt)$" ///
	lag_mw_increase "$\Delta Ln(mw_kt-1)$" ///
	sales Sales ls LS) ///
	mtitles ("All" "<=3" "3.5" "4" ">4")

	
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
	
	

/////////////////////////////////////////////////////////////////
// distance
/////////////////////////////////////////////////////////////////

use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_merged_panel_data5678.dta", clear
drop if fastfood==1

gen dist_nyny_bord = .
replace dist_nyny_bord = time_l if (group== 3 | group==4) ///
	& mw_increase_competitor_l==.1111
	
replace dist_nyny_bord = time_h*-1 if group==5 & ///
	(mw_increase_competitor_h==.2222 | mw_increase_competitor_h==.1667)
	
replace dist_nyny_bord = 	dist_nyny_bord /60

gen nyc = group==3 | group==4


///////////// main distance graph ////////////////////
local dist = 25
binscatter total_chlnp dist_nynj_bord if dist_nynj_bord<`dist' ///
	& dist_nynj_bord >-	`dist'-10 & scrape==8, by(ny) nquantiles(60) ///
	graphregion(fcolor(white)) title("Border Effects:" ///
	"Price Pass Through By Distance to NJ/NY Border") ///
	xtitle("Distance from NJ/NY Border") ///
	xlabel(-30(10)20) ///
	ytitle("%Change(P): Oct to Feb") ///
	ylabel(-.005(.005).025) ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York"))
	
graph export "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_03.23.17\total_pricechange_dist_nynj.pdf", as(pdf) replace


//////////// distance regs //////////////////////

eststo clear

/*
reg total_ch  ny dist_nynj_bord ny#c.dist_nynj_bord ///
	if dist_nynj_bord <25 & dist_nynj_bord>-35 

reg total_ch  ny dist_nynj_bord ny#c.dist_nynj_bord ///
	d2 ny#c.d2 ///
	if dist_nynj_bord <25 & dist_nynj_bord>-35
*/	
eststo: quietly reg total_ch  ny dist_nynj_bord ny#c.dist_nynj_bord  ///
	if dist_nynj_bord <25 & dist_nynj_bord>-35
	
eststo: quietly reg total_ch  ny dist_nynj_bord ny#c.dist_nynj_bord ///
	chain ls emps sales ///
	if dist_nynj_bord <25 & dist_nynj_bord>-35

//july to october: want to be non-significant
eststo: quietly reg ch_lnp  ny dist_nynj_bord ny#c.dist_nynj_bord chain ls emps sales ///
	if dist_nynj_bord <25 & dist_nynj_bord>-35	& scrape==6	

eststo: quietly reg total_ch  nyc dist_nyny_bord nyc#c.dist_nyny_bord ///
	if dist_nyny_bord <25 & dist_nyny_bord>-35 
	
esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_03.23.17\dist_item_regs.tex", ///
	se replace label  ///
	coeflabels(total_ch "$ \Delta Ln(P_{oct-feb}) $" ///
		ny "\textbf{1}(NY)" ///
		dist_nynj_bord "Distance" ///
		ny#c.dist_nynj_bord "\textbf{1}(NY)*Distance" ///
		chain "Chain" ///
		ls "LS" ///
		emps "Employees" ///
		sales "Sales" ///
		_cons "Constant" ) ///
	mtitles("$\Delta Ln(P_{oct-feb})$" "$\Delta Ln(P_{oct-feb})$" "$\Delta Ln(P_{jul-oct})$" ///
		"$\Delta Ln(P_{oct-feb})$")
	
	



reg total_ch  nyc dist_nyny_bord nyc#c.dist_nyny_bord ///
	if dist_nyny_bord <25 & dist_nyny_bord>-35 
	
local dist = 25
binscatter total_chlnp dist_nyny_bord if dist_nyny_bord<`dist' ///
	& dist_nyny_bord >-	`dist' & scrape==8, by(nyc) nquantiles(50) ///
	graphregion(fcolor(white)) title("Border Effects:" ///
	"Price Pass Through By Distance to NJ/NY Border") ///
	xtitle("Distance from NJ/NY Border") ///
	xlabel(-30(10)20) ///
	ytitle("%Change(P): Oct to Feb") ///
	legend(label( 1 "New Jersey") ///
		label(2 "New York"))
	
