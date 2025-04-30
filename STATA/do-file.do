log using "/Users/mujiechen/Jupyter-Notebook/STATA/demo.smcl", replace

cd "/Users/mujiechen/Jupyter-Notebook/STATA"

help meta

/*example 1 pigott 2022*/
clear
import excel "/Users/mujiechen/Jupyter-Notebook/STATA/Datasets/Pigott 202
> 2.xlsx", sheet("Sheet1") firstrow

save "Pigott.2022.dta", replace

use "Pigott.2022.dta", clear
des /*describe dataset*/
codebook /*shows missing values*/
meta esize nt meant sdt nc meanc sdc /*compute effect size for 2 groups*/
meta forestplot

meta summarize
meta forestplot, esrefline
/*suppress statistics*/


/*stata example datasets for metaanalysis*/
clear
webuse nsaids
des
meta esize nstreat nftreat nscontrol nfcontrol
meta forestplot


/*example 2 huang 2022*/
clear
import excel "/Users/mujiechen/Jupyter-Notebook/STATA/Datasets/Huang 2022
> .xlsx", sheet("Sheet1") firstrow

save "Huang 2022.dta", replace

use "Huang 2022.dta", clear
des
codebook
gen logrr=ln(RR) /*effect sizes are precalculated risk ratios*/
gen selogrr=(ln(RR)-ln(LCI)/1.96) /*SE is rr - lower CI / 1.96*/

meta set logrr selogrr, studylabel(Study)

meta forestplot, eform
meta summarize

/*subgroup by participants*/
meta summarize subgroup (Participants) random(dlaird)
meta forestplot, subgroup (Participants) random(dlaird)

/*funnel plot for publication bias*/
meta funnelplot, random
meta bias, egger
meta bias, begg
