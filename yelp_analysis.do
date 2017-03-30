

//////////////////////////////
//							//
//	Chelsea Crain			//
//							//
//	12/28/2016				//
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



drop pricecategory foodcategory1 foodcategory2 foodcategory3 ///
	 daysopen  number itemcategory size ///
	parsed_menu breakfast appetizer side soup_salad sandwich ///
	pizza entre kids dessert drink entre kids dessert drink ///
	other  dup takeout ///
	creditcards takesreservations waiters delivery  run ///
	 folder fulladdress rusaid file
	 
drop if ls==0 & fs==0

	
/////////////////////////////////////////////////////////////////
// regressions: restaurant level
/////////////////////////////////////////////////////////////////

use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_rest_level_merged_panel_data.dta", clear
drop if fastfood==1
xtset rest_id scrape


/////////////// basic regs: rest level //////////////
eststo clear 

eststo:  xtreg ch_av_p mw_increase 
eststo: quietly xtreg ch_av_p mw_increase  i.group 
eststo: quietly xtreg ch_av_p mw_increase   ///
	chain emps sales ls  i.group  
eststo: quietly xtreg ch_av_p mw_increase , fe
eststo: quietly xtreg ch_av_p mw_increase i.group if eat24==1, fe 

esttab using "C:\Users\Chelsea\Documents\AlumniSeminar\y_rest_regs.tex", ///
	se keep(mw_increase chain  emps sales ls) replace label ///
		coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "$\Delta Ln(mw_{kt}) $" ///
	sales Sales ls LS lag_ch_lnp "$\Delta Ln(P_{it-1}$)" ///
	emps Employees chain Chain lag_ch_av_p " $\Delta Ln(P_{it-1}) $")
	


/////////////// star regs: rest level //////////////
eststo clear

eststo: quietly xtreg ch_av_p mw_increase chain emps sales ls  i.group if star_4 <= 2.5 
eststo: quietly xtreg ch_av_p mw_increase  chain emps sales ls i.group if star_4 ==3 
eststo: quietly xtreg ch_av_p mw_increase chain emps sales ls i.group if star_4 ==3.5  
eststo: quietly xtreg ch_av_p mw_increase chain emps sales ls i.group if star_4 ==4 
eststo: quietly xtreg ch_av_p mw_increase chain emps sales ls i.group if star_4 >= 4.5 

/*
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if ls==1
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , feif ls==0
*/
	
esttab using "C:\Users\Chelsea\Documents\AlumniSeminar\y_stars_regs.tex", ///
	se keep(mw_increase chain  emps sales ls ) replace label ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "$\Delta Ln(mw_{kt}) $" ///
	sales Sales ls LS lag_ch_lnp "$\Delta Ln(P_{it-1}$)" ///
		emps Employees chain Chain lag_ch_av_p " $\Delta Ln(P_{it-1}) $") ///
	mtitles ("$ <=2.5 $" "$ 3 $" "$3.5$" " $ 4 $" " $  >=4.5 $ ")
	
	
	
/////////////// only grubhub rests regs: rest level //////////////
eststo clear 

//eststo:  xtreg ch_av_p mw_increase lag_ch_lnp 
eststo: quietly xtreg ch_av_p mw_increase lag_ch_lnp if grubhub==1, fe if grubhub==1
eststo: quietly xtreg ch_av_p mw_increase lag_ch_lnp  i.group if grubhub==1
eststo: quietly xtreg ch_av_p mw_increase lag_ch_lnp  chain ///
	emps sales i.group if grubhub==1
eststo: quietly xtreg ch_av_p mw_increase lag_ch_lnp  i.group if eat24==1 grubhub==1

esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\y_rest_regs.tex", ///
	se keep(mw_increase lag_ch_lnp chain emps sales) replace label ///
	title(Price Response of a 1 Percent Minimum Wage Increase: Obs is Restaurant) ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "$\Delta Ln(MW_{kt}) $" ///
	sales Sales ls LS lag_ch_lnp "$\Delta Ln(P_{it-1}$)" ///
	emps Employees chain Chain) ///
	mtitles (" Restaurant FE " "Group FE" "Group FE + Cntrls" "Eat24")
	
	
	
/////////////// other regs: rest level //////////////
eststo clear 

eststo: quietly xtreg ch_items mw_increase  chain emps  sales ls  i.group 
eststo: quietly xtreg ch_hours mw_increase   chain emps  sales ls i.group 
eststo: quietly xtreg ch_days mw_increase  chain emps  sales ls i.group 

esttab using "C:\Users\Chelsea\Documents\AlumniSeminar\y_other_rest_regs.tex", ///
	se keep(mw_increase sales emps chain ls) replace label ///ncrease: Obs is Restaurant) ///
	coeflabels(ch_lnp "$\Delta$ Ln(P)" mw_increase "$\Delta$ Ln(MW_{kt})" ///
	sales Sales ls LS chain Chain emps Employees ) ///
	mtitles ("Total Items" "Hours" "Days")
	

/////////////// stars: rest level //////////////
eststo clear 

eststo:  quietly xtreg ch_lns mw_increase  
eststo:  quietly xtreg ch_lns mw_increase i.group 
eststo: quietly xtreg ch_lns mw_increase i.group  ch_av_p star_4 chain ls sales emps

/*
eststo:  xtreg ch_stars mw_increase i.group chain ch_lnp star_4 if star_4 >4
eststo:  xtreg ch_stars mw_increase i.group chain ch_lnp star_4 if star_4 <=4 & star_4 > 3.5 
eststo:  xtreg ch_stars mw_increase i.group chain ch_lnp star_4 if star_4 <=3.5 & star_4 > 3 
eststo:  xtreg ch_stars mw_increase i.group chain ch_lnp star_4 if star_4 <=3 & star_4 > 2.5
eststo:  xtreg ch_stars mw_increase i.group chain ch_lnp star_4 if star_4 < 2 
*/

esttab using "C:\Users\Chelsea\Documents\AlumniSeminar\y_star_rest_regs.tex", ///
	se keep(mw_increase chain ch_av_p star_4 chain emps sales) replace label ///
	coeflabels(ch_av_p "$\Delta Ln(P) $" mw_increase "$\Delta Ln(mw_{kt}) $" ///
	sales Sales ls LS chain Chain star_4 "Stars_April" emps Employees) 
	//mtitles ("All" "LS" "FS")

/////////////// star regs: by starting star //////////////
eststo clear

eststo: quietly xtreg ch_stars mw_increase ch_av_p  i.group if star_4 <= 2.5
eststo: quietly xtreg ch_stars mw_increase  ch_av_p i.group if star_4 ==3
eststo: quietly xtreg ch_stars mw_increase ch_av_p i.group if star_4 ==3.5 
eststo: quietly xtreg ch_stars mw_increase ch_av_p i.group if star_4 ==4
eststo: quietly xtreg ch_stars mw_increase ch_av_p i.group if star_4 >= 4.5 


/*
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if ls==1
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , feif ls==0
*/
	
esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\y_stars_by_starting_regs.tex", ///
	se keep(mw_increase ch_av_p ) replace label ///
	coeflabels( mw_increase "$\Delta ln(MW_{kt}) $" ///
	ch_av_p " $\Delta Ln(P) $ ") ///
	mtitles ("$ <=2.5 $" "$ 3 $" "$3.5$" " $ 4 $" " $  >=4.5 $ ")
	
	
	
/////////////// probs: rest level //////////////
eststo clear 

eststo: quietly xtreg pr_inc_rest mw_increase lag_ch_lnp i.group 
eststo: quietly xtreg pr_inc_rest mw_increase lag_ch_lnp i.group chain ///
	emps sales 
eststo: quietly xtreg pr_dec_rest mw_increase lag_ch_lnp i.group 


esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\prob_regs_rest.tex", ///
	se keep(mw_increase lag_ch_lnp chain emps sales) replace label ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "$\Delta Ln(MW_{kt}) $" ///
	sales Sales ls LS lag_ch_lnp "$\Delta Ln(P_{it-1}$)" ///
	emps Employees chain Chain) ///	
	mtitles ("Pr  Increase" "Pr Increase" "Pr  Decrease")
	
	
	
/////////////////////////////////////////////////////////////////
// regressions: item level
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_merged_panel_data.dta", clear
drop if fastfood==1

xtset full_id scrape

eststo clear 

eststo: quietly reg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id


/////////////// basic regs //////////////
eststo clear 

eststo:  xtreg ch_lnp mw_increase lag_ch_lnp  , fe 
eststo:  xtreg ch_lnp mw_increase lag_ch_lnp i.group 
eststo:  xtreg ch_lnp mw_increase lag_ch_lnp i.group chain ///
	emps sales 
eststo:  xtreg ch_lnp mw_increase lag_ch_lnp i.group if eat24==1

//eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp locationsalesvolumeactual ///
				//	total_items i.category i.group , fe 
/*
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group  i.rest_id
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group  i.rest_id, fe 
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp locationactualsalesvolume ///
					total_items i.category i.group , fe 
*/


esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\y_regs.tex", ///
	se keep(mw_increase lag_ch_lnp chain emps sales) replace label ///
	title(Probability of Price Increase Given a 1 Percent Minimum Wage Increase) ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "$\Delta Ln(MW_{kt}) $" ///
	sales Sales ls LS lag_ch_lnp "$\Delta Ln(P_{it-1}$)" ///
	emps Employees chain Chain) ///	
	mtitles (" Rest FE " "Group FE" "Cntrls" "Eat24")


	
/////////////// by category //////////////	
eststo clear 

//eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if general_category=="popular"
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if general_category=="side", fe 
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if general_category=="sandwich", fe 
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if general_category=="pizza" , fe 
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if general_category=="entre" , fe 
//eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if general_category=="soup_sal" , fe 
//eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if general_category=="dessert", fe 
//eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if general_category=="other", fe 

/*
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if general_category=="side"
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if general_category=="sandwich"
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if general_category=="pizza"
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if general_category=="entre"
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if general_category=="soup_sal"
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if general_category=="dessert"
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if general_category=="other"
*/

esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\category_regs.tex", ///
	se keep(mw_increase) replace label ///
	title(Price Response of a 1 Percent Minimum Wage Increase by Item Category) ///
	coeflabels(mw_increase "$\Delta Ln(MW)$" sales Sales ls LS) ///
	mtitles ( "Side" "Sandwich" "Pizza" "Entre" "Soup/Salad" "Desert" "Other")

	
/////////////// by fs ls //////////////
eststo clear 

eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group, fe
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if ls==1, fe 
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if ls==0, fe
		
/*
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if ls==1
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , feif ls==0
*/
	
esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\ls_regs.tex", se keep(mw_increase) replace label ///
	title(Price Response of a 1 Percent Minimum Wage Increase by LS FS) ///
	coeflabels(lag_ch_lnp "$\Delta ln(P_{it-1})$" mw_increase "$\Delta ln(MW_k)$" sales Sales ls LS) ///
	mtitles ("All" "LS" "FS")
	
/////////////// by stars //////////////
eststo clear 

eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if star_4 <= 2, fe
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if star_4 >2 & star_4 <=3, fe 
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if star_4 >3 & star_4 <=4, fe
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group if star_4 >4 , fe
		
/*
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , fe if ls==1
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id , feif ls==0
*/
	
esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\stars_regs.tex", ///
	se keep(mw_increase lag_ch_lnp) replace label ///
	title(Price Response of a 1 Percent Minimum Wage Increase by LS FS) ///
	coeflabels(lag_ch_lnp "$\Delta ln(P_{it-1})$" mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("$ s<=2 $" "$ 2<s<=3$" "$ 3<s<=4$" " $ s>4$")
/*	
/////////////// by sales level //////////////
eststo clear 

eststo: quietly reg ch_lnp mw_increase i.group, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group if sales < 300000 , ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group if sales > 300000, ///
		cluster(rest_id)
		
eststo: quietly reg ch_lnp mw_increase i.group i.rest_id, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group i.rest_id if sales < 300000 , ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group i.rest_id if sales < 300000 , ///
		cluster(rest_id)

esttab using sales_regs.tex, se keep(mw_increase) replace label ///
	title(Price Response of a 1 Percent Minimum Wage Increase by Sales Volume) ///
	coeflabels(ch_lnp "Change Ln(P)" mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("All" "$<$300K" "$>$300K" "All" "$<$300K" "$>$300K")
*/	
	
	
/////////////// basic regs prob of inc //////////////
eststo clear 

eststo: quietly xtreg pr_inc mw_increase lag_ch_lnp i.group 
eststo: quietly xtreg pr_inc mw_increase lag_ch_lnp i.group  , fe 
eststo: quietly xtreg pr_inc mw_increase lag_ch_lnp i.group i.scrape , fe 
//eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp locationsalesvolumeactual ///
				//	total_items i.category i.group , fe 
/*
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group i.rest_id
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group  i.rest_id
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp i.group  i.rest_id, fe 
eststo: quietly xtreg ch_lnp mw_increase lag_ch_lnp locationactualsalesvolume ///
					total_items i.category i.group , fe 
*/


esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\prob_regs.tex", ///
	se keep(mw_increase lag_ch_lnp) replace label ///
	title(Probability of Price Increase Given a 1 Percent Minimum Wage Increase) ///
	coeflabels(ch_lnp "$\Delta$ Ln(P)" mw_increase "$\Delta$ Ln(MW_{kt})" ///
	sales Sales ls LS lag_ch_lnp "$\Delta$ Ln(P_{it-1})") ///
	mtitles ("\textit{k} FE" "\textit{k} + \textit{i} FE "  ///
	"\textit{k} + \textit{i} + \textit{t} FE")
	
	
/////////////// basic regs prob of dec //////////////
eststo clear 

eststo: quietly reg pr_dec mw_increase i.group, ///
		cluster(rest_id)
eststo: quietly reg pr_dec mw_increase i.group i.rest_id, ///
		cluster(rest_id)
eststo: quietly reg pr_dec mw_increase sales ls i.group , ///
		cluster(rest_id)
eststo: quietly reg pr_dec mw_increase sales ls i.group i.rest_id , ///
		cluster(rest_id)

esttab using prob_dec_regs.tex, se keep(mw_increase) replace label ///
	title(Probability of Price Decrease Given a 1 Percent Minimum Wage Increase) ///
	coeflabels(pr_dec "Prob Price Dcrs" mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("Group FE" "Group FE \& Cntrls" "Group \& Rest FE" "Group \& Rest FE \& Cntrls")
		
		
/////////////// prob inc by category (Group FE) //////////////	
eststo clear 

eststo: quietly reg pr_inc mw_increase i.group if general_category=="popular", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group if general_category=="side", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group if general_category=="sandwich", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group if general_category=="pizza", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group if general_category=="entre", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group if general_category=="dessert", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group if general_category=="other", ///
		cluster(rest_id)

esttab using prob_category_group_regs.tex, se keep(mw_increase) replace label ///
	title(Prob of Price Increase Given a 1 Percent Minimum Wage Increase by ///
			Item Category (Group FE) ) ///
	coeflabels(mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("Popular" "Side" "Sandwich" "Pizza" "Entre" "Desert" "Other")


	
/////////////// prob inc by category (Group and Rest FE) //////////////	
eststo clear 

eststo: quietly reg pr_inc mw_increase i.group i.rest_id if general_category=="popular", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group i.rest_id if general_category=="side", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group i.rest_id if general_category=="sandwich", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group i.rest_id if general_category=="pizza", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group i.rest_id  if general_category=="entre", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group i.rest_id if general_category=="dessert", ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group i.rest_id if general_category=="other", ///
		cluster(rest_id)

esttab using prob_category_rest_regs.tex, se keep(mw_increase) replace label ///
	title(Prob of Price Increase Given a 1 Percent Minimum Wage Increase by ///
			Item Category (Group FE) ) ///
	coeflabels(mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("Popular" "Side" "Sandwich" "Pizza" "Entre" "Desert" "Other")
	
	
/////////////// prob by fs ls //////////////
eststo clear 

eststo: quietly reg pr_inc mw_increase i.group, ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group if ls==1, ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group if ls==0, ///
		cluster(rest_id)
		
eststo: quietly reg pr_inc mw_increase i.group i.rest_id, ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group i.rest_id if ls==1 , ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group i.rest_id if ls==0 , ///
		cluster(rest_id)

esttab using prob_ls_fs_regs.tex, se keep(mw_increase) replace label ///
	title(Prob of Price Increase Given a 1 Percent Minimum Wage Increase by LS FS) ///
	coeflabels(ch_lnp "Change Ln(P)" mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("All" "LS" "FS" "All" "LS" "FS")
	
	
gen t1 = scrape==4
gen t2 = scrape==5
gen t3 = scrape==6

xtset full_id scrape

xtreg ch_lnp mw_increase i.scrape ///
	lag_ch_lnp star_4 i.group

xtreg ch_lnp mw_increase i.scrape lag_ch_lnp, fe 
	
format full_id %11.0f

reg ch_lnp mw_increase lead_mw_increase lag_mw_increase ///
	lag_ch_lnp i.group

i.scrape i.rest_id
lag_ch_lnp i.group

i.full_id i.rest_id




/////////////////////////////////////////////////////////////////
// yelp star analysis: ordered probit
/////////////////////////////////////////////////////////////////

eststo clear 
eststo: quietly oprobit prob_star mw_increase  ch_av_p lag_ch_lnp
eststo: quietly oprobit prob_star mw_increase  ch_av_p lag_ch_lnp i.group 
eststo: quietly oprobit prob_star mw_increase ch_av_p lag_ch_av_p i.group  chain ls emps sales
esttab using "C:\Users\Chelsea\Documents\AlumniSeminar\yelp_ord_prob.tex", ///
	se keep(mw_increase ch_av_p lag_ch_lnp chain emps sales ls) replace label ///
	coeflabels(ch_av_p "$ \Delta Ln(p_{jkt}) $" lagch_av_p "$ \Delta Ln(p_{jkt-1}) $" ///
	mw_increase "$\Delta Ln(mw_{kt}) $" ///
	sales Sales ls LS lag_ch_lnp "$\Delta Ln(P_{it-1}$)" ///
	emps Employees chain Chain) 
	
	
	
	
	

/////////////////////////////////////////////////////////////////
// figures
/////////////////////////////////////////////////////////////////
	

graph drop a b 

twoway (kdensity exact_star if state=="NJ" & scrape==5) ///
(kdensity exact_star if state=="NY" & scrape==5), name(a)

twoway (kdensity exact_star if state=="NJ" & scrape==6) ///
(kdensity exact_star if state=="NY" & scrape==6), name(b)
	
twoway (kdensity exact_star if state=="NJ" & scrape==7) ///
(kdensity exact_star if state=="NY" & scrape==7), name(c)

//graph combine a b c

graph drop a b 

twoway  /// (kdensity exact_star if group==3 & scrape==4) ///
/// (kdensity exact_star if group==3 & scrape==5) ///
(kdensity exact_star if group==3 & scrape==6, lwidth(thick) lcolor(emidblue) ) ///
(kdensity exact_star if group==3 & scrape==7, lwidth(thick) lcolor(cranberry)), ///
xtitle("Exact Yelp Star Rating") ytitle("Density") ///
graphregion(fcolor(white)) ///
legend(label(1 "Oct '16") label(2 "Jan '17")) name(b) xsc(r(1 5))  ///
title("NYC Lg Non-Chain")

twoway /// (kdensity exact_star if newarkmsa==1 &  fs==1 & emps > 10 & scrape==4) ///
/// (kdensity exact_star if newarkmsa==1 &  fs==1 & emps > 10 & scrape==5) ///
(kdensity exact_star if  newarkmsa==1  & emps > 10 & scrape==6, lwidth(thick) lcolor(emidblue)  ) ///
(kdensity exact_star if newarkmsa==1 & emps >10 & scrape==7, lwidth(thick) lcolor(cranberry)) , ///
xtitle("Exact Yelp Star Rating") ytitle("Density") ///
graphregion(fcolor(white)) ///
legend(label(1 "Oct '16") label(2 "Jan '17")) name(a) xsc(r(1 5)) ///
title("Newark, NJ MSA Lg Non-Chain")

graph combine a b, ysize(3) xsize(7)

graph export "C:\Users\Chelsea\Documents\AlumniSeminar\star_dens_ny.pdf", as(pdf) replace



twoway (kdensity exact_star if state=="NY" & group!=6 &  fastfood==0 & scrape==6) ///
(kdensity exact_star if state=="NY" & group!=6 & fastfood==0 & scrape==7)

, name(b)

twoway (kdensity exact_star if state=="MA" & scrape==6) ///
(kdensity exact_star if state=="CT" & scrape==6), name(a)

graph combine a b

graph drop a b 

twoway (kdensity exact_star if group == 3 & scrape==6) ///
	(kdensity exact_star if group ==4& scrape==6) ///
	(kdensity exact_star if group ==5 & scrape==6), name(a)
	 ytitle("% Change Price") graphregion(fcolor(white))

twoway (kdensity exact_star if group ==3 & scrape==7) ///
(kdensity exact_star if group ==4 & scrape==7) ///
(kdensity exact_star if group ==5 & scrape==7), name(b)
	 ytitle("% Change Price") graphregion(fcolor(white))

graph combine a b

graph export "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\yelp_scatter6.pdf", as(pdf) replace


/////////////////////////////////////////////////////////////////
// summary statistics table: sample construction
/////////////////////////////////////////////////////////////////

la var item_info "Item Info"
la def item_info  0 "Don't have menu item info" ///
	1 "Have menu item info"
la val item_info item_info

la var rusa_info "RUSA Data"
la def rusa_info 0 "Not matched to RUSA Data" ///
			1 "Matched to RUSA Data"
la val rusa_info rusa_info
		
la var rusa_item "Item Info and RUSA"
la def rusa_item 0 "Not matched to RUSA Data or no Item Info" ///
			1 "Item Info and Matched to RUSA Data"
la val rusa_item rusa_item
		
la var eat24 "Eat24 Menu"
la def eat24 0 "Not Eat24 Menu" ///
			1 "Eat24 Menu"
la val eat24 eat24
		
la var eat24_rusa "Eat24 and RUSA"
la def eat24_rusa 0 "Not Eat24 Menu or no RUSA info" ///
			1 "Eat24 Menu and RUSA Info"
la val eat24_rusa eat24_rusa

gen wt = 10 * runiform()

tabout rusa_info item_info rusa_item eat24 eat24_rusa ///
using table1.xls, sum rep ///
c( N scrape ///
mean fs mean ls mean chain ///
mean creditcards mean daysopen mean delivery ///
mean hoursopen mean stars mean takeout ///
mean takesreservations mean waiters  ///
mean locationemployeesizeactual ///
mean locationsalesvolumeactual ///
mean total_items mean av_price mean med_price ///
mean num_1 mean num_2 mean num_3 mean num_4 mean num_5 mean num_6 ///
mean num_7 mean num_8 mean num_9 mean num_10 ///
mean num_0 mean av_p_1 mean av_p_2 ///
mean av_p_3 mean av_p_4 mean av_p_5 mean av_p_6 ///
mean av_p_7 mean av_p_8 mean av_p_9 ///
mean av_p_10 mean av_p_0) ///
format(0c 4p 4p 4p ///
	4p 2c 4p 2c 2c 4p 4p 4p 2c 0c ///
	2c 2c 2c 2c 2c 2c 2c 2c 2c 2c 2c  ///
	2c 2c 2c 2c 2c 2c 2c 2c 2c 2c 2c )

			
			
			
/////////////////////////////////////////////////////////////////
// plot change in price over mw increase
/////////////////////////////////////////////////////////////////

// note: collaping means collapsing the actual data, aka removing obs
use "`output_path'\yelp_merged_panel_data.dta", clear


use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_rest_level_merged_panel_data.dta", clear


use "C:\Users\Chelsea\Documents\Research\MinWage\Data\Yelp\yelp_merged_panel_data.dta", clear

drop if fastfood==1

by group scrape, sort: egen mean_ch_lnp = mean(ch_lnp)
by group scrape, sort: egen sd_ch_lnp = sd(ch_lnp)

collapse (mean) ch_lnp (mean) sd_ch_lnp (mean) mean_ch_lnp, ///
	by (group mw_increase scrape group_name)


label var ch_av_p "% Change P"
label var mw_inc "% Change Min Wage"

by group: egen inc = max(mw_increase)


twoway (scatter ch_lnp inc if scrape==5 & group >2 & fastfood==0, mlabel(group_name)) ///
		(lfit ch_lnp inc if scrape==5 & group >2 & fastfood==0), ///
		legend(off) ytitle("% Change Price") graphregion(fcolor(white))

	
	
////// scatter of pre and post price changes by min wage ///////		
graph drop a b

twoway 	(scatter ch_lnp inc if scrape==6 & group >2 , mlabel(group_name)) ///
		(lfit ch_lnp inc if scrape==6 & group >2 ), ///
		name(a) ytitle("% Change Price") xtitle("% Increase MW") graphregion(fcolor(white)) ///
		ysc(r(0(.001).005)) legend(off) title("July '16 - Dec '16")
gr_edit .yaxis1.reset_rule 10, tickset(major) ruletype(suggest) 
		
	
twoway (scatter ch_lnp inc if scrape==7 & group >2 , mlabel(group_name)) ///
		(lfit ch_lnp inc if scrape==7 & group >2), ///
		name(b) ytitle("% Change Price") xtitle("% Increase MW") graphregion(fcolor(white))	///
		ysc(r(0 .005)) legend(off) title("Dec '16 - Jan '17")
gr_edit .yaxis1.reset_rule 10, tickset(major) ruletype(suggest) 
			
graph combine a b

graph export "C:\Users\Chelsea\Documents\AlumniSeminar\yelp_scatter_lfit.pdf", as(pdf) replace





scatter ch_lnp scrape if fastfood==0	

twoway (scatter ch_av_p inc if scrape==5 & group >2 & fastfood==0, mlabel(group_name)) ///
		(lfit ch_av_p inc if scrape==5 & group >2 & fastfood==0), ///
		legend(off) ytitle("% Change Price") graphregion(fcolor(white))

twoway (scatter ch_av_p inc if scrape==6 & group >2 & fastfood==0, mlabel(group_name)) ///
		(lfit ch_av_p inc if scrape==6 & group >2 & fastfood==0), ///
		legend(off) ytitle("% Change Price") graphregion(fcolor(white))
		
twoway (scatter ch_av_p mw_inc if scrape==7 & group >2 & fastfood==0, mlabel(group_name)) ///
		(lfit ch_av_p inc if scrape==7 & group >2 & fastfood==0), ///
		legend(off) ytitle("% Change Price") graphregion(fcolor(white))	
		

		
		
		
twoway (scatter ch_lnp mw_inc if scrape==7 & mw_inc > .1, mlabel(group_name)) ///
		(lfit ch_lnp mw_inc if scrape==7 & mw_inc > .1 ) ///
		(scatter ch_lnp mw_inc if scrape==7 & mw_inc <= .1, mlabel(group_name)) ///
		(lfit ch_lnp mw_inc if scrape==7 & mw_inc <=.1 ), ///
		legend(off) ytitle("% Change Price") graphregion(fcolor(white))
graph export "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\yelp_scatter_lfit.pdf", as(pdf) replace



		
graph export "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\yelp_scatter.pdf", as(pdf) replace
	
	

		
graph export "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\yelp_scatter6.pdf", as(pdf) replace
		
		
sort group scrape


xtset group scrape
xtline price, overlay



/////////////////////////////////////////////////////////////////
// sum stats
/////////////////////////////////////////////////////////////////

summarize ch_av_p if scrape==7 & grubhub==1 & ch_av_p > 0
summarize pr_inc_rest pr_dec_rest if scrape==7 & grubhub==1 
summarize total_items if scrape==7==1 & grubhub==1


summarize ch_lnp if scrape==7 & grubhub==1 & ch_lnp > 0
summarize pr_inc pr_dec if scrape==7 & grubhub==1 




kdensity exact_stars if scrape==7, xtitle("Exact Yelp Star Rating") graphregion(fcolor(white))
graph export "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\star_density.pdf", as(pdf) replace





/////////////////////////////////////////////////////////////////
// distances
/////////////////////////////////////////////////////////////////

collapse (mean) av_ch_p, by (rest_id scrape group dist_nynj_bord newark)


twoway (lfitci ch_av_p dist_nynj_bord if scrape==7 & group==4 & ///
	dist_nynj_bord<1000 & mw_increase_competitor_l==.0072) ///
	(lfitci ch_av_p dist_nynj_bord if scrape==7 ///
	& newarkmsa==1 & dist_nynj_bord>-800) 

& ///
	dist_nynj_bord<1800) 
	
	(
	
	lfitci ch_av_p dist_nynj_bord if scrape==7 ///
	& newarkmsa==1 & dist_nynj_bord>-1800) 
	
	(scatter ch_av_p dist_nynj_bord ///
	if scrape==7 & (group==4 | newarkmsa==1) & ///
	dist_nynj_bord<1800 & dist_nynj_bord>-1800)




twoway (lfitci ch_lnp time_l if str_inc_l==".0072" & ///
		scrape==7 & ///
		(group==4 | group==3)& time_l <2000) ///
		(lfitci ch_lnp time_h_neg if group==8 & ///
		(str_inc_h==".2222" | str_inc_h==".1667") ///
		& time_h_neg>-2000 & scrape==7) 
	
	
	
	
	
	
	
	
	
	
	
	