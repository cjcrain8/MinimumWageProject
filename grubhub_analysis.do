

//////////////////////////////
//							//
//	Chelsea Crain			//
//							//
//	12/28/2016				//
//							//
//	Calculate restaurant	//
// 		specific item info 	//
// 	Grubhuh				 	//
//							//
//////////////////////////////

clear all
set more off
set maxvar 32767
set matsize 11000


	
/////////////////////////////////////////////////////////////////
// regressions: rest level
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\GrubHub\grubhub_rest_level_merged_panel_data.dta", clear

drop if ls==0 & fs==0
drop if fastfood==1



/////////////// basic regs //////////////
eststo clear 

eststo: quietly reg ch_av_p mw_increase 
eststo: quietly reg ch_av_p mw_increase  i.group 
eststo: quietly reg ch_av_p mw_increase i.group chain employees sales ls

esttab using "C:\Users\Chelsea\Documents\AlumniSeminar\gh_regs.tex", ///
	se keep(mw_increase chain  employees sales ls ) replace label ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "$ \Delta Ln(mw_{kt}) $" ///
	sales Sales ls LS employees Employees) 
	
	
/////////////////////////////////////////////////////////////////
// regressions: item level
/////////////////////////////////////////////////////////////////
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\GrubHub\grubhub_merged_panel_data.dta", clear

drop if ls==0 & fs==0

drop if fastfood==1

xtset full_id t

reg ch_lnp mw_increase lag_mw_increase i.t i.group if price<50 ///
	, cluster(rest_id) noconstant

reg ch_lnp mw_increase lag_mw_increase chain ls employees sales ///
	i.t i.group total_items if price<50 , cluster(rest_id) noconstant

display _b[mw_increase]

		 
/////////////// basic regs //////////////
eststo clear 

eststo: quietly reg ch_lnp mw_increase , cluster(rest_id)

eststo: quietly reg ch_lnp mw_increase  i.group , cluster(rest_id)

eststo: quietly reg ch_lnp mw_increase i.group , cluster(rest_id)


//eststo: quietly reg ch_lnp mw_increase sales fastfood i.group i.rest_id , ///
	//	cluster(rest_id)

esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\gh_regs.tex", ///
	se keep(mw_increase ) replace label ///
	title(Price Response of a 1 Percent Minimum Wage Increase) ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("All" "LS" "FS" )

	
/////////////// by category //////////////	
eststo clear 

eststo: quietly reg ch_lnp mw_increase chain ls employees sales i.group,  ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase chain ls employees sales i.group if general_category=="popular" , ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase chain ls employees sales i.group if general_category=="side" , ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase  chain ls employees sales i.group if general_category=="sandwich" , ///
		cluster(rest_id)
// eststo: quietly reg ch_lnp mw_increase  chain ls employees sales i.group if general_category=="pizza" , ///
		// cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase  chain ls employees sales i.group if general_category=="entre" , ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase  chain ls employees sales i.group if general_category=="dessert" , ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase  chain ls employees sales i.group if general_category=="other" , ///
		cluster(rest_id)

esttab using "C:\Users\Chelsea\Documents\AlumniSeminar\gh_category_regs.tex", ///
	se keep(mw_increase ) replace label ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "$ \Delta Ln(mw_{kt}) $" ///
	sales Sales ls LS employees Employees) ///
	mtitles ( "All" "Popular" "Side" "Sandwich"  "Entre" "Desert" "Other")

	
/////////////// by fs ls //////////////
eststo clear 

eststo: quietly reg ch_lnp mw_increase i.group, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group if ls==1, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group if ls==0, ///
		cluster(rest_id)
		
eststo: quietly reg ch_lnp mw_increase i.group i.rest_id, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group i.rest_id if ls==1 , ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group i.rest_id if ls==0 , ///
		cluster(rest_id)

esttab using ls_fs_regs.tex, se keep(mw_increase) replace label ///
	title(Price Response of a 1 Percent Minimum Wage Increase by LS FS) ///
	coeflabels(ch_lnp "Change Ln(P)" mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("All" "LS" "FS" "All" "LS" "FS")

/////////////// basic regs //////////////
eststo clear 

eststo: quietly reg ch_lnp mw_increase i.group

eststo: quietly reg ch_lnp mw_increase  i.group if ls==1

eststo: quietly reg ch_lnp mw_increase i.group if ls==0

		
//eststo: quietly reg ch_lnp mw_increase sales fastfood i.group i.rest_id , ///
	//	cluster(rest_id)

esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\gh_regs.tex", ///
	se keep(mw_increase ) replace label ///
	title(Price Response of a 1 Percent Minimum Wage Increase) ///
	coeflabels(ch_lnp "$ \Delta Ln(P) $" mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("All" "LS" "FS" )

	
/////////////// by category //////////////	
eststo clear 

eststo: quietly reg ch_lnp mw_increase i.group if general_category=="popular" & ls==0, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group if general_category=="side" & ls==0, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group if general_category=="sandwich"  & ls==0, ///
		cluster(rest_id)
//eststo: quietly reg ch_lnp mw_increase i.group if general_category=="pizza" & ls==0, ///
		//cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group if general_category=="entre" & ls==0, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group if general_category=="dessert" & ls==0, ///
		cluster(rest_id)
//eststo: quietly reg ch_lnp mw_increase i.group if general_category=="other" & ls==0, ///
	//	cluster(rest_id)

esttab using "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\gh_category_regs.tex", se keep(mw_increase) replace label ///
	title(Price Response of a 1 Percent Minimum Wage Increase by Item Category) ///
	coeflabels(mw_increase "$ \Delta Ln(MW)$" sales Sales ls LS) ///
	mtitles ( "Popular" "Side" "Sandwich"  "Entre" "Desert" "Other")

	
/////////////// by fs ls //////////////
eststo clear 

eststo: quietly reg ch_lnp mw_increase i.group, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group if ls==1, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group if ls==0, ///
		cluster(rest_id)
		
eststo: quietly reg ch_lnp mw_increase i.group i.rest_id, ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group i.rest_id if ls==1 , ///
		cluster(rest_id)
eststo: quietly reg ch_lnp mw_increase i.group i.rest_id if ls==0 , ///
		cluster(rest_id)

esttab using ls_fs_regs.tex, se keep(mw_increase) replace label ///
	title(Price Response of a 1 Percent Minimum Wage Increase by LS FS) ///
	coeflabels(ch_lnp "Change Ln(P)" mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("All" "LS" "FS" "All" "LS" "FS")
	
	
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

eststo: quietly reg pr_inc mw_increase i.group, ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase i.group i.rest_id, ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase sales ls i.group , ///
		cluster(rest_id)
eststo: quietly reg pr_inc mw_increase sales ls i.group i.rest_id , ///
		cluster(rest_id)

esttab using prob_inc_regs.tex, se keep(mw_increase) replace label ///
	title(Probability of Price Increase Given a 1 Percent Minimum Wage Increase) ///
	coeflabels(prob_inc "Prob Pric Incrs" mw_increase "Change Ln(MW)" sales Sales ls LS) ///
	mtitles ("Group FE" "Group FE \& Cntrls" "Group \& Rest FE" "Group \& Rest FE \& Cntrls")
	
	
	
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
		
	
	
	
/*
reg ch_lnp mw_increase i.group close_higher



reg ch_lnp mw_increase i.group if general_category == "pizza" & ls==0
reg ch_lnp mw_increase i.group i.rest_id 

reg ch_lnp mw_increase  i.group  if fastfood !=1

reg ch_lnp mw_increase locationemployeesizeactual ///
	locationsalesvolumeactual  i.group 
	
reg ch_lnp mw_increase  locationemployeesizeactual ///
	locationsalesvolumeactual  i.group i.rest_id if ls==1


xtset full_id scrape

xtreg ch_lnp mw_increase i.scrape ///
	lag_ch_lnp star_4 i.group, fe

xtreg ch_lnp mw_increase i.scrape lag_ch_lnp, fe 
	
format full_id %11.0f

reg ch_lnp mw_increase lead_mw_increase lag_mw_increase ///
	lag_ch_lnp i.group

i.scrape i.rest_id
lag_ch_lnp i.group

i.full_id i.rest_id

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

			
	*/		
			
/////////////////////////////////////////////////////////////////
// plot ch_lnp vs mw increase
/////////////////////////////////////////////////////////////////

// note: collaping means collapsing the actual data, aka removing obs
use "C:\Users\Chelsea\Documents\Research\MinWage\Data\GrubHub\grubhub_merged_panel_data.dta", clear
drop if t==1
collapse (mean) av_price, by (rest_id mw_increase ls group)

twoway (scatter ch_lnp mw_inc if ls==1) (scatter ch_lnp mw_inc if ls==0)

scatter ch_lnp mw_inc if ls==1, name(a)
scatter ch_lnp mw_inc if ls==0, name(b)
graph combine a b


label var ch_lnp "% Change P"
label var mw_inc "% Change Min Wage"
twoway (scatter ch_lnp mw_inc if  mw_inc > .1, ) ///
		(lfit ch_lnp mw_inc if  mw_inc > .1 ) ///
		(scatter ch_lnp mw_inc if  mw_inc <= .1, mlabel(group_name)) ///
		(lfit ch_lnp mw_inc if mw_inc <=.1 ), ///
		legend(off) ytitle("% Change Price") graphregion(fcolor(white))
graph export "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\grubhub_scatter.pdf", as(pdf) replace



twoway (scatter ch_lnp mw_inc , mlabel(group_name)), ///
		legend(off) ytitle("% Change Price") graphregion(fcolor(white))
graph export "C:\Users\Chelsea\Documents\AppliedSeminar\MinWage_02.09.17\grubhub_scatter.pdf", as(pdf) replace
	


scatter ch_lnp mw_increase	if general_category == "popular" & ls==1
scatter ch_lnp mw_increase if general_category == "entre" & group > 6

scatter ch_lnp mw_increase if ls == 1 , name(a)
scatter ch_lnp mw_increase if ls == 0, name(b)
graph combine a b

twoway (scatter ch_lnp mw_increase if ls == 0 ) ///
	(lfit ch_lnp mw_increase if ls == 0 ) ///
(scatter ch_lnp mw_increase if ls == 1 ) ///
	(lfit ch_lnp mw_increase if ls == 1 )
	
	, name(b)
graph combine a b
	
	twoway (kdensity ln_p if group==4 & t==1) (kdensity ln_p if group==8 & t==1 ///
	& emps < 10) ///
	, name(a)


twoway (kdensity ln_p if group==4 & t==2) (kdensity ln_p if group==8 & t==2 ///
	& emps < 10) ///
	, name(b)
	
gr combine a b



/////////////////////////////////////////////////////////////////
// sum stats
/////////////////////////////////////////////////////////////////

summarize ch_av_p_rest if t==2 & yelp_prices==1 & ch_av_p > 0
summarize pr_inc_rest pr_dec_rest  if t==2 & yelp_prices==1 


summarize ch_lnp if t==2 & yelp_prices==1 & ch_lnp > 0
summarize pr_inc pr_dec total_items if t==2 & yelp_prices==1 


summarize ch_av_p_rest if t==2 &  ch_av_p > 0
summarize pr_inc_rest pr_dec_rest if t==2 

summarize ch_lnp if t==2 &  ch_lnp > 0
summarize pr_inc pr_dec if t==2 



/////////////////////////////////////////////////////////////////
// plots
/////////////////////////////////////////////////////////////////

twoway (lfitci total_inc lag_mw_increase if t==3), by(category) ///
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




twoway (lfitci total_chp time_l if str_inc_l==".0072" ///
	& group==4) ///
	(lfitci total_chp time_l_neg if group==8)
	
	
// ny nj downtown

twoway (lfitci total_chp time_l if str_inc_l==".0072" & ///
		t==3 & (group==4 | group==3) & time_l <3500) ///
		 (lfitci total_chp time_h_neg if group==8 & ///
		(str_inc_h==".2222" | str_inc_h==".1667") ///
		& time_h_neg>-3500 & t==3 ) 
	
	
// ny nj upstate

twoway (lfitci total_chp time_l if str_inc_l==".0072" & ///
		t==3 & (group==6) & time_l <3500) ///
		 (lfitci total_chp time_h_neg if group==8 & ///
		(str_inc_h==".0778") ///
		& time_h_neg>-3500 & t==3 ) 
	
	
	
// nyc to ny msa

twoway (lfitci total_chp time_l if str_inc_l==".1111" & ///
		t==3 & (group==4 | group==3) & time_l <2500) ///
		 (lfitci total_chp time_h_neg if group==5 & ///
		(str_inc_h==".2222" | str_inc_h==".1667") ///
		& time_h_neg>-2500 & t==3 ) 
	
	
	
	