*create a log file to keep record of your work	
log using "N:\xxxx\xxxx\xxxx\xxx\final\demonstration.log", replace

*INTRODUCTION TO META-ANALYSIS 28/04/2025 DO FILE
	
*****************************************************
*	How to run a meta-analysis in STATA v18			*
* 	Examples 										*
*	GF 28/04/2025									*
*****************************************************

* first, change the directory to the folder where you are going to work for convenience
cd "N:\xxxx\xxxx\xxxxx\final"

* check help
	help meta


*********************************************************************
*EXAMPLE 1: 
	*Piggot 2022 - 
	*continuous outcome -raw data

	* PREPARE THE DATASET
	* import study estimates and study details from Excel table into Stata
  	clear
	import excel "Pigott 2022.xlsx", sheet("Sheet1") firstrow
	* create a Stata dataset and save it
	save "Pigott_2022.dta", replace
	
	*OPEN STATA DATASET
	use "Pigott_2022.dta", clear
	des /*describe dataset*/
	codebook
	meta esize nt meant sdt nc meanc sdc /* use this command when you have row data - compute and declare effect sizes for two-group comparison of continuous outcomes */
	help meta esize /*for details of commands*/
	meta forestplot /*create forest plot*/
	
	*the following are commands you may find useful if you wish to improve the forest plot display
	*add the Study label to the forest plot
	meta esize nt meant sdt nc meanc sdc, studylabel(Study)
	meta summarize 
	meta forestplot /*create forestplot*/
	meta forestplot, esrefline  /*add the vertical line for the overall effect */
	*save graph 
    graph export "forest plot Pigott_2022.emf", as(emf) name("Graph")
	*suppress statistics lines
	meta forestplot,   noohetstats noohomtest noosigtest
	
	
**********************************************************************
*EXAMPLE 2: 
	*STATA dataset 'nsaid' - available online 
	*binary outcome  - raw data

	*donwload example dataset 
	clear
	webuse nsaids
	des /*check dataset*/
	meta esize nstreat nftreat nscontrol nfcontrol /* declare meta-analysis data- use this commange when you have raw data, that is the number of failures and successes in the treatment and control groups */
	meta summarize
	meta forestplot
	meta forestplot, eform

	
	
**********************************************************************
*EXAMPLE 3: 
	*Huang 2022
	*binary outcome -pre-calculated risk ratios
		
	* PREPARE THE DATASET
	*import study estimates and study details from Excel table into Stata
  	clear
	import excel "Huang 2022.xlsx", sheet("Sheet1") firstrow	
	* create a Stata dataset and save it
	save "Huang.dta", replace
	
	* OPEN STATA DATASET
	 use "Huang.dta", clear
	* check dataset  
	des
	* because effect size are pre-calculated risk ratios, I need calculate the log of RR 
	gen logrr=ln(RR) 		
	* I also need to calculate the standard error of the log
	gen  selogrr=(ln(RR)-ln(LCI))/1.96 /*standard error*/
	
	/* declare meta-analysis data the pre-calculated effect sizes
	(log risk-ratios) and their standard errors  */
	meta set logrr selogrr, studylabel(Study)   /* use this command when you have only the effect size (in this case risk ratio ) but no raw data - Declare meta-analysis data using generic effect sizes*/
	*  run meta-analysis
	meta summarize 
	meta forestplot /* create forest plot*/
	
	* diplay data as risk ratio (rathern than logs)
	meta summarize, eform 
	meta forestplot,    eform
	*random effect (REML) not the same as in paper - try D-Laird method
	meta forestplot,    eform random(dlaird)
	
	*commands you may find useful if you wish to improve the forest plot display

	*add more details in the graph
	meta forestplot,    eform   random(dlaird) esrefline nullrefline  t1title(Late-onset epilepsy and risk of dementia)  nullrefline(favorsleft("LOE for lower risk") favorsright("LOE or higher risk")) 

	
*command for sub-group analysis
	meta summarize, subgroup (Participants)  random(dlaird)
	meta forestplot, subgroup  (Participants) eform random(dlaird)

	*FUNNEL PLOT
	*command to create a forest plot to investigate publication bias
	meta funnelplot, random  /*create funnel plot*/
	graph export "funnel plot Huang.emf", as(emf) name("Graph")
	meta bias, egger /*stats test for funnel plot  assymetry*/
	meta bias, begg /*stats test for funnel plot assymetry*/
	
clear
log close	
	
	

	