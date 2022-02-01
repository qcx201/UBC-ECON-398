
// The Social Media Infodemic and Anxiety
// During the COVID-19 Pandemic

// Jack (Quan Cheng) Xie
// ECON 398: Introduction to Applied Economics
// Professor Jonathan L. Graves
// 8 December 2020


clear all

cd "C:\Users\qcx20\Documents\UBC Classes\Intro to Applied Economics\Project"

cls

* Data source
	* https://hdl.handle.net/11272.1/AB2/IIIOGC

* Other COVID-19 datasets
	* https://abacus.library.ubc.ca/dataverse/covid

* Data cleaning ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

use ".\CPSS_S4_2020_EN.DTA", clear

* Rename all variables as upper
rename *, upper


* GAD-7 cut-off (clinically significant symptoms)
generate GAD = .a // recode general anxiety disorder cut-off
replace GAD = 0 if ANXDVGAC == 2
replace GAD = 1 if ANXDVGAC	== 1

label define dummy 1 "Yes" 0 "No"
label values GAD dummy
label var GAD "Generalized Anxiety Disorder Cut-point"


* Mild GAD symptoms
generate MGAD = .a
replace MGAD = 0 if ANXDVSEV < 5
replace MGAD = 1 if ANXDVSEV == 1 | ANXDVSEV == 2

label values MGAD dummy
label var MGAD "Mild or minimal generalized anxiety symptoms"


* No anxiety symptoms
generate NOGAD = .a
replace NOGAD = 0 if ANXDVSEV < 5
replace NOGAD = 1 if ANXDVSEV == 0 

label values NOGAD dummy
label var NOGAD "No generalized anxiety symptoms"


* Reorganize GAD symptoms categories
generate GAD_CAT = .a
replace GAD_CAT = 0 if ANXDVSEV == 0
replace GAD_CAT = 1 if ANXDVSEV == 1 | ANXDVSEV == 2
replace GAD_CAT = 2 if ANXDVSEV == 3 | ANXDVSEV == 4

label define gad_label 0 "No GAD" 1 "Mild GAD" 2 "GAD"
label values GAD_CAT gad_label
label var GAD_CAT "Generalized Anxiety Cut-point Classifications"

* Categorical variable for social media use
generate USE_SOCIAL = .a
replace USE_SOCIAL = 0 if FC_05B == 2 | FC_05A == 2
replace USE_SOCIAL = 1 if FC_05B == 1
replace USE_SOCIAL = 2 if FC_05A == 1
replace USE_SOCIAL = 3 if FC_05B == 1 & FC_05A == 1

label define social_label  ///
	0 "Neither" ///
	1 "From news orgs or magazine only" ///
	2 "From other users or influencers only" ///
	3 "From both sources"
	
label values USE_SOCIAL social_label
label var USE_SOCIAL "Use social media posts for COVID-19 info" 
	

* Reorganize categorical variable for main info source
generate MAIN_SRC = .a
replace MAIN_SRC = 0 if BH_05C < 13
replace MAIN_SRC = 1 if BH_05C == 7
replace MAIN_SRC = 2 if BH_05C == 1
replace MAIN_SRC = 3 if BH_05C > 1 & BH_05C < 7
replace MAIN_SRC = 4 if BH_05C > 7 & BH_05C < 11

label define src_label  ///
	0 "Other Sources/none" 		///
	1 "Social media" 			///
	2 "News outlets" 			///
	3 "Government sources" 		///
	4 "Personal sources"
	
label values MAIN_SRC src_label
label var MAIN_SRC "Main source of information for COVID-19"

* Main info from social media
generate MAIN_SOCIAL = .a
replace MAIN_SOCIAL = 0 if BH_05C < 13
replace MAIN_SOCIAL = 1 if BH_05C == 7

label values MAIN_SOCIAL dummy
label var MAIN_SOCIAL  "Main info source: Social media"

* Frequency of suspected false COVID-19 information
generate SUS_FREQ = .a
replace SUS_FREQ = 0 if FC_25 < 6
replace SUS_FREQ = 1 if FC_25 == 1

label define sus_label 0 "Once a day or less" 1 "Multiple times a day"
label values SUS_FREQ sus_label
label var SUS_FREQ "Freq of suspected false COVID-19 info"


* Rename variables for presentation
label var BH_05C "Main COVID-19 info source"
label var BH_55A "Concern about my own health"
label var BH_55B "Concern about family member's health"
label var BH_55K "Concern about family stress from confinement"
label var BH_55L "Concern about violence in the home"
label var BH_25 "My general health"

label define edu_label 						///
	1 "Less than highschool or equivalent" 	///
	2 "Highschool or equivalent" 			///
	3 "Trade school" 						///
	4 "College/non-university" 				///
	5 "University below bachelor's" 		///
	6 "Bachelor's degree" 					///
	7 "Degree above Bachelor's"
	
label values PEDUC_LC edu_label
label var PEDUC_LC "Highest level of education completed"

* Data Summary +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// tabout documentation: http://fmwww.bc.edu/RePEc/bocode/t/tabout.html
// https://www.stata.com/meeting/oceania16/slides/watson-oceania16.pdf

* Dependent variables
tabout GAD_CAT ANXDVGAD ANXDVSEV 		///
	/// [aweight=PERS_WGT] ///
	using ".\Results\1_tab_GAD.tex", replace ///
	c(freq col)					 	/// frequency, row, col pct
	f(0c 1p) 						/// number format
	clab(Freq Col_%)			 	/// cell label
	style(tex) 						/// file type
	body font(bold) 				/// font
// 	ptotal(none) 					/// suppress total
	
* behavioural variables
tabout USE_SOCIAL MAIN_SRC FC_25 BH_55A BH_55B BH_55K BH_55L BH_25 GAD_CAT ///
	/// [aweight=PERS_WGT] ///
	using ".\Results\2_tab_behavioural.tex", replace ///
	c(freq col) 					/// frequency, row, col pct
	f(0c 1p) 						/// number format
	clab(Freq Col_%)		 		/// cell label
	style(tex) 						/// file type
	body font(bold) 				/// font
// 	ptotal(none) 					/// suppress total
// 	stats(chi2) 					/// chi-sq test

* Demographic covariates
tabout AGEGRP SEX PEDUC_LC RURURB GAD_CAT ///
	/// [aweight=PERS_WGT] ///
	using ".\Results\3_tab_demographic.tex", replace ///
	c(freq col) 					/// frequency, row, col pct
	f(0c 1p) 						/// number format
	clab(Freq Col_%)	 			/// cell label
	style(tex) 						/// file type
	body font(bold)			 		/// font
// 	ptotal(none) 					/// suppress total
// 	stats(chi2) 					/// chi-sq test


* Regressions ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

* baseline regression
regress GAD 					/// (outcome) generalized anxiety disorder
	i.USE_SOCIAL	/// COVID-19 from social media posts
	[pweight=PERS_WGT], baselevels vce(robust)
		
est store base_reg

* with main info source and suspicion freq

regress GAD 		/// (outcome) no symptoms of generalized anxiety disorder
	i.USE_SOCIAL	/// COVID-19 from social media posts
	/// behavioural controls 	-----------------------------------
	i.MAIN_SRC		/// main information source
	ib(5).FC_25		/// freq of suspect info
	[pweight=PERS_WGT], baselevels vce(robust)
	
est store info_freq_reg


* With behavioural and demographic controls

regress GAD 		/// (outcome) symptoms of generalized anxiety disorder
	i.USE_SOCIAL	/// COVID-19 from social media posts
	/// behavioural controls 	-----------------------------------
	i.MAIN_SRC		/// main information source
	ib(5).FC_25		/// freq of suspect info
	i.BH_55A 		/// concern about COVID-19 impact on my own health
	i.BH_55B		/// concern about COVID-19 impact on health of family member
	i.BH_55K 		/// concern about stress from family confinement
	i.BH_55L		/// concern about violence in the home
	i.BH_25 		/// how is your general health?
	/// demographic controls ----------------------------------
	i.AGEGRP 		/// age group
	i.SEX 			/// female or male
	i.PEDUC_LC		/// highest education level
	i.RURURB 		/// rural or urban
	[pweight=PERS_WGT], baselevels vce(robust)

est store control_reg


* Model on minimal/mild symptoms

regress MGAD 		/// (outcome) symptoms of generalized anxiety disorder
	i.USE_SOCIAL	/// COVID-19 from social media posts
	/// behavioural controls 	-----------------------------------
	i.MAIN_SRC		/// main information source
	ib(5).FC_25		/// freq of suspect info
	i.BH_55A 		/// concern about COVID-19 impact on my own health
	i.BH_55B		/// concern about COVID-19 impact on health of family member
	i.BH_55K 		/// concern about stress from family confinement
	i.BH_55L		/// concern about violence in the home
	i.BH_25 		/// how is your general health?
	/// demographic controls ----------------------------------
	i.AGEGRP 		/// age group
	i.SEX 			/// female or male
	i.PEDUC_LC		/// highest education level
	i.RURURB 		/// rural or urban
	[pweight=PERS_WGT], baselevels vce(robust)

est store mgad_reg


* Model on no symptoms

regress NOGAD 		/// (outcome) no symptoms of generalized anxiety disorder
	i.USE_SOCIAL	/// COVID-19 from social media posts
	/// behavioural controls 	-----------------------------------
	i.MAIN_SRC		/// main information source
	ib(5).FC_25		/// freq of suspect info
	i.BH_55A 		/// concern about COVID-19 impact on my own health
	i.BH_55B		/// concern about COVID-19 impact on health of family member
	i.BH_55K 		/// concern about stress from family confinement
	i.BH_55L		/// concern about violence in the home
	i.BH_25 		/// how is your general health?
	/// demographic controls ----------------------------------
	i.AGEGRP 		/// age group
	i.SEX 			/// female or male
	i.PEDUC_LC		/// highest education level
	i.RURURB 		/// rural or urban
	[pweight=PERS_WGT], baselevels vce(robust)

est store nogad_reg

* Output regression results

outreg2 [base_reg info_freq_reg control_reg ///
		 mgad_reg nogad_reg] 				///
	using ".\Results\4_basereg.tex", 		///
	replace tex label auto(2) stats(coef se) nocons /// e(N r2) ///
	drop(i.BH_55A i.BH_55B i.BH_55K i.BH_55L i.BH_25 i.AGEGRP i.SEX i.PEDUC_LC i.RURURB) ///
	title("Social Media Use for COVID-19 Information and Generalized Anxiety Disorder Symptoms") ///
	addnote("Columns 1 to 3 report the estimated regression coefficient of the probability of having clinically significant symptoms of generalized anxiety disorder (GAD) on social media use for information about COVID-19. The dependent and treatments are categories of social media use, with a baseline of not using social media for information. Columns 2 and 3 report regression results that incorporate observables based on survey responses to behaviour and demographic questions. Columns 4 and 5 report regression results with the control model on having mild or minimal GAD symptoms (column 4) and no symptoms (column 5). Standard errors for estimator coefficients are displayed in brackets. Sampling weights and robust standard errors are used.")


* Extensions ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

* Comparison of main info sources without interactions

regress GAD			/// (outcome) generalized anxiety disorder
	i.MAIN_SRC		/// main information source
	i.SUS_FREQ		/// freq of seeing suspected false info
	/// behavioural controls -----------------------------------
	i.BH_55A		/// concern about COVID-19 impact on my own health
	i.BH_55B		/// concern about COVID-19 impact on health of family member
	i.BH_55K 		/// concern about stress from family confinement
	i.BH_55L		/// concern about violence in the home
	i.BH_25 		/// how is your general health?
	/// demographic controls ----------------------------------
	i.AGEGRP 		/// age group
	i.SEX 			/// female or male
	i.PEDUC_LC		/// highest education level
	i.RURURB 		/// rural or urban
	[pweight=PERS_WGT], baselevels vce(robust)
	
est store noninteraction_reg


* Comparison of main info sources with interactions

regress GAD					/// (outcome) generalized anxiety disorder
	i.MAIN_SRC##i.SUS_FREQ 	/// main info source X freq false info
	/// behavioural controls 	-----------------------------------
	i.BH_55A		/// concern about COVID-19 impact on my own health
	i.BH_55B		/// concern about COVID-19 impact on health of family member
	i.BH_55K 		/// concern about stress from family confinement
	i.BH_55L		/// concern about violence in the home
	i.BH_25 		/// how is your general health?
	/// demographic controls ----------------------------------
	i.AGEGRP 		/// age group
	i.SEX 			/// female or male
	i.PEDUC_LC		/// highest education level
	i.RURURB 		/// rural or urban
	[pweight=PERS_WGT], baselevels vce(robust)
	
est store interaction_reg


* Mild/minimal GAD symptoms

regress MGAD				/// (outcome) generalized anxiety disorder
	i.MAIN_SRC##i.SUS_FREQ 	/// main info source X freq false info
	/// behavioural controls 	-----------------------------------
	i.BH_55A		/// concern about COVID-19 impact on my own health
	i.BH_55B		/// concern about COVID-19 impact on health of family member
	i.BH_55K 		/// concern about stress from family confinement
	i.BH_55L		/// concern about violence in the home
	i.BH_25 		/// how is your general health?
	/// demographic controls ----------------------------------
	i.AGEGRP 		/// age group
	i.SEX 			/// female or male
	i.PEDUC_LC		/// highest education level
	i.RURURB 		/// rural or urban
	[pweight=PERS_WGT], baselevels vce(robust)
	
est store mgad_interaction_reg


* No GAD symptoms

regress NOGAD				/// (outcome) generalized anxiety disorder
	i.MAIN_SRC##i.SUS_FREQ 	/// main info source X freq false info
	/// behavioural controls 	-----------------------------------
	i.BH_55A		/// concern about COVID-19 impact on my own health
	i.BH_55B		/// concern about COVID-19 impact on health of family member
	i.BH_55K 		/// concern about stress from family confinement
	i.BH_55L		/// concern about violence in the home
	i.BH_25 		/// how is your general health?
	/// demographic controls ----------------------------------
	i.AGEGRP 		/// age group
	i.SEX 			/// female or male
	i.PEDUC_LC		/// highest education level
	i.RURURB 		/// rural or urban
	[pweight=PERS_WGT], baselevels vce(robust)

est store nogad_interaction_reg

* Output results
outreg2 [noninteraction_reg interaction_reg 			///
		mgad_interaction_reg nogad_interaction_reg]	 	///
		using ".\Results\5_interactions.tex", 			///
	replace tex label auto(2) stats(coef se) nocons 	/// e(N r2) ///
	drop(i.BH_55A i.BH_55B i.BH_55K i.BH_55L i.BH_25 i.AGEGRP i.SEX i.PEDUC_LC i.RURURB) ///
	title("Interaction Effects of Information Sources With Frequency of Suspecting Misinformation and Generalized Anxiety Disorder Symptoms") ///
	addnote("Columns 1 and 2 report the regression estimators of the probability of having moderate or severe symptoms of generalized anxiety disorder. Column 2 features the interaction of different information sources and the frequency of suspecting misinformation. Column 3 show the results of the same model estimating outcomes with mild or minimal symptoms, and column 4 estimates outcomes with no symptoms. Standard errors are shown in brackets. Sampling weights and robust standard errors are used.")
