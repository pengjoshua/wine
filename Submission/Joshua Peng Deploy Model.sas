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
