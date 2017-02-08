* Loading in data;
data test; set wine_test;
* Imputing missing observations with mean value and adding new variables in test set;
data test0; set test;
    if missing(Alcohol) then alcohol = 10.4892363;   
    if missing(FreeSulfurDioxide) then FreeSulfurDioxide = 30.8455713;    
    stars0 = stars;
    if missing(stars) then stars0 = 0;
    if missing(TotalSulfurDioxide) then TotalSulfurDioxide = 120.7142326;
	av_Alcohol = abs(Alcohol);
	av_VolatileAcidity = abs(VolatileAcidity);
	av_FreeSulfurDioxide = abs(FreeSulfurDioxide);
	av_TotalSulfurDioxide = abs(TotalSulfurDioxide);
	if av_VolatileAcidity = 0 then ln_av_VolatileAcidity = 0;
		else ln_av_VolatileAcidity = log(av_VolatileAcidity);
	if av_FreeSulfurDioxide = 0 then ln_av_FreeSulfurDioxide = 0;
		else ln_av_FreeSulfurDioxide = log(av_FreeSulfurDioxide);
	if av_TotalSulfurDioxide = 0 then ln_av_TotalSulfurDioxide = 0;
		else ln_av_TotalSulfurDioxide = log(av_TotalSulfurDioxide);
	* Variable of reference: 0;
	if STARS0 in (0 1 2 3 4) then do;
		STARS0_1 = (STARS0 eq 1);	
		STARS0_2 = (STARS0 eq 2);	
		STARS0_3 = (STARS0 eq 3);	
		STARS0_4 = (STARS0 eq 4);	
	end;
	* Variable of reference: -2;
	if LabelAppeal in (-2 -1 0 1 2) then do;
		LabelAppeal_n1 = (LabelAppeal eq -1);	
		LabelAppeal_0 = (LabelAppeal eq 0);	
		LabelAppeal_p1 = (LabelAppeal eq 1);	
		LabelAppeal_p2 = (LabelAppeal eq 2);	
	end;
run;
* Score test data (POI Model 2) with SAS data step;
data testscore_poi; set test0;
TEMP = 0.1413 
+ AcidIndex * -0.0778
+ ln_av_VolatileAcidity * -0.0262
+ ln_av_TotalSulfurDioxide * 0.0283
+ ln_av_FreeSulfurDioxide * 0.0156 
+ av_Alcohol * 0.0043
+ (stars0 in (1)) * 0.7676
+ (stars0 in (2)) * 1.0838
+ (stars0 in (3)) * 1.2051
+ (stars0 in (4)) * 1.3272
+ (LabelAppeal in (-1)) * 0.2381
+ (LabelAppeal in (0)) * 0.4274
+ (LabelAppeal in (1)) * 0.5602
+ (LabelAppeal in (2)) * 0.6962;
P_TARGET_POI = exp(TEMP);
keep INDEX P_TARGET_POI;
run;
* Score test data (NB Model 4) with SAS data step;
data testscore_nb; set test0;
TEMP = 0.1413 
+ AcidIndex * -0.0778
+ ln_av_VolatileAcidity * -0.0262
+ ln_av_TotalSulfurDioxide * 0.0283
+ ln_av_FreeSulfurDioxide * 0.0156 
+ av_Alcohol * 0.0043
+ (stars0 in (1)) * 0.7676
+ (stars0 in (2)) * 1.0838
+ (stars0 in (3)) * 1.2051
+ (stars0 in (4)) * 1.3272
+ (LabelAppeal in (-1)) * 0.2381
+ (LabelAppeal in (0)) * 0.4274
+ (LabelAppeal in (1)) * 0.5602
+ (LabelAppeal in (2)) * 0.6962;
P_TARGET_NB = exp(TEMP);
keep INDEX P_TARGET_NB;
run;
* Score test data (ZIP Model 6) with SAS data step;
data testscore_zip; set test0;
TEMP = 0.4532 
+ AcidIndex * -0.0632
+ ln_av_VolatileAcidity * -0.0135
+ ln_av_TotalSulfurDioxide * 0.0028
+ ln_av_FreeSulfurDioxide * 0.0059 
+ av_Alcohol * 0.0071
+ (stars0 in (1)) * 0.0632
+ (stars0 in (2)) * 0.1834
+ (stars0 in (3)) * 0.2816
+ (stars0 in (4)) * 0.3809
+ (LabelAppeal in (-1)) * 0.4432
+ (LabelAppeal in (0)) * 0.7311
+ (LabelAppeal in (1)) * 0.9213
+ (LabelAppeal in (2)) * 1.0785;
P_SCORE_ZIP_ALL = exp(TEMP);
TEMP = -5.1960 
+ AcidIndex * 0.4322
+ (stars0 in (1)) * -2.0682
+ (stars0 in (2)) * -5.8044
+ (stars0 in (3)) * -24.9701
+ (stars0 in (4)) * -25.1438
+ (LabelAppeal in (-1)) * 1.4799
+ (LabelAppeal in (0)) * 2.2270
+ (LabelAppeal in (1)) * 2.9280
+ (LabelAppeal in (2)) * 3.3765;
P_SCORE_ZERO = exp(TEMP)/(1+exp(TEMP));
P_TARGET_ZIP = P_SCORE_ZIP_ALL * (1-P_SCORE_ZERO);
keep INDEX P_TARGET_ZIP;
run;
* Score test data (ZINB Model 8) with SAS data step;
data testscore_zinb; set test0;
TEMP = 0.4532 
+ AcidIndex * -0.0632
+ ln_av_VolatileAcidity * -0.0135
+ ln_av_TotalSulfurDioxide * 0.0028
+ ln_av_FreeSulfurDioxide * 0.0059 
+ av_Alcohol * 0.0071
+ (stars0 in (1)) * 0.0632
+ (stars0 in (2)) * 0.1834
+ (stars0 in (3)) * 0.2816
+ (stars0 in (4)) * 0.3809
+ (LabelAppeal in (-1)) * 0.4432
+ (LabelAppeal in (0)) * 0.7311
+ (LabelAppeal in (1)) * 0.9213
+ (LabelAppeal in (2)) * 1.0785;
P_SCORE_ZINB_ALL = exp(TEMP);
TEMP = -5.1960 
+ AcidIndex * 0.4322
+ (stars0 in (1)) * -2.0682
+ (stars0 in (2)) * -5.8044
+ (stars0 in (3)) * -24.9701
+ (stars0 in (4)) * -25.1438
+ (LabelAppeal in (-1)) * 1.4799
+ (LabelAppeal in (0)) * 2.2270
+ (LabelAppeal in (1)) * 2.9280
+ (LabelAppeal in (2)) * 3.3765;
P_SCORE_ZERO = exp(TEMP)/(1+exp(TEMP));
P_TARGET_ZINB = P_SCORE_ZINB_ALL * (1-P_SCORE_ZERO);
keep INDEX P_TARGET_ZINB;
run;
* Score test data (REG Model 10) with SAS data step;
data testscore_reg; set test0;
P_TARGET_REG = 1.23003
+ AcidIndex * -0.19397
+ ln_av_VolatileAcidity * -0.08283
+ ln_av_TotalSulfurDioxide * 0.07861
+ ln_av_FreeSulfurDioxide * 0.04412 
+ av_Alcohol * 0.01434
+ stars0_1 * 1.36774
+ stars0_2 * 2.39443
+ stars0_3 * 2.96595
+ stars0_4 * 3.65759
+ LabelAppeal_n1 * 0.36814
+ LabelAppeal_0 * 0.83488
+ LabelAppeal_p1 * 1.29924
+ LabelAppeal_p2 * 1.88184;
keep INDEX P_TARGET_REG;
run;
* Score test data (ZIP with Cloglog link Model 11) with SAS data step;
data testscore_zip11; set test0;
TEMP = 0.4636
+ AcidIndex * -0.0209
+ ln_av_VolatileAcidity * -0.0135
+ ln_av_TotalSulfurDioxide * 0.0028
+ ln_av_FreeSulfurDioxide * 0.0060 
+ av_Alcohol * 0.0071
+ (stars0 in (1)) * 0.0688
+ (stars0 in (2)) * 0.1853
+ (stars0 in (3)) * 0.2838
+ (stars0 in (4)) * 0.3833
+ (LabelAppeal in (-1)) * 0.4450
+ (LabelAppeal in (0)) * 0.7311
+ (LabelAppeal in (1)) * 0.9209
+ (LabelAppeal in (2)) * 1.0777;
P_SCORE_ZIP_ALL = exp(TEMP);
TEMP = -4.0081 
+ AcidIndex * 0.2687
+ (stars0 in (1)) * -1.5432
+ (stars0 in (2)) * -5.1362
+ (stars0 in (3)) * -24.0085
+ (stars0 in (4)) * -25.1524
+ (LabelAppeal in (-1)) * 1.2427
+ (LabelAppeal in (0)) * 1.7738
+ (LabelAppeal in (1)) * 2.2531
+ (LabelAppeal in (2)) * 2.4212;
P_SCORE_ZERO = exp(TEMP)/(1+exp(TEMP));
P_TARGET_ZIP = P_SCORE_ZIP_ALL * (1-P_SCORE_ZERO);
keep INDEX P_TARGET_ZIP;
run;
* Score test data (ZIP with Probit link Model 12) with SAS data step;
data testscore_zip12; set test0;
TEMP = 0.4502
+ AcidIndex * -0.0189
+ ln_av_VolatileAcidity * -0.0135
+ ln_av_TotalSulfurDioxide * 0.0029
+ ln_av_FreeSulfurDioxide * 0.0060 
+ av_Alcohol * 0.0071
+ (stars0 in (1)) * 0.0608
+ (stars0 in (2)) * 0.1819
+ (stars0 in (3)) * 0.2804
+ (stars0 in (4)) * 0.3797
+ (LabelAppeal in (-1)) * 0.4439
+ (LabelAppeal in (0)) * 0.7329
+ (LabelAppeal in (1)) * 0.9233
+ (LabelAppeal in (2)) * 1.0807;
P_SCORE_ZIP_ALL = exp(TEMP);
TEMP = -3.0205 
+ AcidIndex * 0.2501
+ (stars0 in (1)) * -1.2351
+ (stars0 in (2)) * -3.0271
+ (stars0 in (3)) * -5.8146
+ (stars0 in (4)) * -5.5576
+ (LabelAppeal in (-1)) * 0.8673
+ (LabelAppeal in (0)) * 1.3150
+ (LabelAppeal in (1)) * 1.7290
+ (LabelAppeal in (2)) * 1.9903;
P_SCORE_ZERO = exp(TEMP)/(1+exp(TEMP));
P_TARGET_ZIP = P_SCORE_ZIP_ALL * (1-P_SCORE_ZERO);
keep INDEX P_TARGET_ZIP;
run;
*///merge all of the model results together///;
data testscore;
merge testscore_poi(in=ina) testscore_nb(in=inb) 
   testscore_zip testscore_zinb testscore_reg;
by INDEX;
if ina;
run;
*///final datastep to retain index and model results///;
data testscore;
set testscore;
keep index p_target_poi p_target_nb p_target_zip p_target_zinb p_target_reg;
run;
