use DEMO;
SELECT [Custid] --Unique Identifier for customers
      ,[Ownership_of_Business_Premises] --if applicant has an office/building asset
      ,[Length_of_time_in_Business_months] --duration in biz (not less than 6months)
      ,[Nature_of_Business] --Biz name
      ,[Business_Type] --if sole proprietor, cooperate or partnership
      ,[Sector] --Applicant biz Industry 
      ,[Paid_up_capital_DTI] --Debt to income ratio (must not be more than 28%)
      ,[Annual_Turnover] --Estimated annual biz profit
      ,[Purpose] --reason for loan obtained at point of application
      ,[Asset] -- applicant possible collateral
      ,[Loan_Amount]  --requested amount can be obtained at point of loan application
      ,[City_Home] --Applicant residence (city) obtained from form
      ,[LGA_Home] --Applicant residential LGA obtained from form
      ,[State_Home] --Applicant residential State 
      ,[City_Office] --Applicant city office address
      ,[LGA_Office] --Applicant LGA office address
      ,[State_Office] --Applicant State office 
      ,[Telephone] --Applicant contact
      ,[SMS_Alert] --Notification preference for contact
      ,[email] -- Notification Preference (maybe expected email address) for contact
      ,[Company_website] --verification of authenticity/online presence
      ,[Own_Office_Space] --verify possible asset
      ,[Duration_rented_office] --
      ,[Has_TIN] --
      ,[Date_of_incorporation] --
      ,[Shareholder_Fund] --
      ,[Has_Subsidiaries]
      ,[Relationship_Exist_with_Bank_s_Top_officers]
      ,[Relationship_Type]
      ,[Shareholder_1_Gender]
      ,[Shareholder_1_DOB]
      ,[Shareholder_1_Marital_Stat]
      ,[Shareholder_1_Ownership]
      ,[Shareholder_1_Shareholding]
      ,[Shareholder_1_Designation]
      ,[Shareholder_1_Education]
      ,[Shareholder_1_City]
      ,[Shareholder_1_LGA]
      ,[Shareholder_1_State]
      ,[Shareholder_1_Yr_Current_Address]
      ,[Shareholder_1_Yr_At_City]
      ,[Shareholder_1_Joined_Since]
      ,[Shareholder_2_Gender]
      ,[Shareholder_2_DOB]
      ,[Shareholder_2_Marital_Stat]
      ,[Shareholder_2_Ownership]
      ,[Shareholder_2_Shareholding]
      ,[Shareholder_2_Designation]
      ,[Shareholder_2_Education]
      ,[Shareholder_2_City]
      ,[Shareholder_2_LGA]
      ,[Shareholder_2_State]
      ,[Shareholder_2_Yr_Current_Add]
      ,[Shareholder_2_Yr_At_City]
      ,[Shareholder_2_Joined_Since]
      ,[Shareholder_3_Gender]
      ,[Shareholder_3_DOB]
      ,[Shareholder_3_Marital_Stat]
      ,[Shareholder_3_Ownership]
      ,[Shareholder_3_Shareholding]
      ,[Shareholder_3_Designation]
      ,[Shareholder_3_Education]
      ,[Shareholder_3_City]
      ,[Shareholder_3_LGA]
      ,[Shareholder_3_State]
      ,[Shareholder_3_Yr_Current_Add]
      ,[Shareholder_3_Yr_At_City]
      ,[Shareholder_3_Joined_Since]
      ,[First_Time_Request]
      ,[Loan_Type]
      ,[Due_Date]
      ,[Tenure_in_months]
      ,[Installment_Plan]
      ,[Repayment_Frequency]
      ,[Disbursal_type]
      ,[Existing_Bank_Borrowing]
  FROM [DEMO].[dbo].[Demo_SME_Loan_Application]

  use DEMO;

  --CREDIT APPLICATION FOR RETAIL LENDING
SELECT [CUSTID]
      ,[Present employment since] -- duration of employment
      ,[Installment rate in percentage of disposable income] --don't have access to this/to be treated later
      ,[Other debtors / guarantors] --verify the necessary criteria for being a guarantor/reduce assigned weight
      ,[Present residence since] --address can be gotten from bank's db/cross-validate with loan application
      ,[Property] ----may not exist
      ,[Other installment plans] --verify existence of multiple loans
      ,[Housing] --confirm if this is collected from loan application platform
      ,[Number of existing credits at this bank] --can only be verified after subsequent loan application
      ,[Dependents] --sourced during loan application/review weight attached 
      ,[Account_Type] --verify value of asset owned by customer
      ,[Residential_status] --Could be gotten from Nationality info on KYC form
      ,[Status_of_existing_checking_ac] --daily checking of account balance
      ,[Employment_type] -- Assign weight public = 5, Private & Self = 3, others = 2
      ,[Duration_in_months] --expected repayment duration/can be evaluated
      ,[Purpose] --reason for loan can be obtained at point of application
      ,[Credit_amount] --requested amount can be obtained at point of loan application
FROM [DEMO].[dbo].[Demo_Credit_Application];

--CREDIT HISTORY FOR RETAIL LENDING
SELECT [CUSTID]
      ,[loan_from_other_banks]
      ,[outstanding_loan]
      ,[outstanding_loan_balance]
      ,[defaulted_previously]
      ,[payment_default_history]
      ,[outstanding_loan_duration]
	  ,[Credit_history] --existence of previous credits/confirm existence of credit within bank/bvn verification on holds
FROM  [DEMO].[dbo].[Demo_Credit_History];



select csc.*
		--  credit score ranking computation
		,case when [Credit_Score] between 300 and 600 then 'Very bad'
			when [Credit_Score] between 600 and 650 then 'Poor'
			when [Credit_Score] between 650 and 700 then 'Fair'
			when [Credit_Score] between 700 and 750 then 'Good'
			when [Credit_Score] between 750 and 800 then 'Very good'
			when [Credit_Score] >= 800 then 'Excellent' end Score_ranking
	--  Interest rate computation
		,case when [Credit_Score] between 300 and 600 then 10
			when [Credit_Score] between 600 and 650 then 9
			when [Credit_Score] between 650 and 700 then 7
			when [Credit_Score] between 700 and 750 then 5
			when [Credit_Score] between 750 and 800 then 3
			when [Credit_Score] >= 800 then 2 end Interest_rate
	-- "Recomended loan to be granted" computation
		,(case when(((Credit_amount)/Duration_in_months) <= (0.333 * (coalesce(Net_transaction_value,0)/6)) and coalesce(Average_salary,0) = 0) then Cast(round(Credit_amount,-2) as int)
			when (((Credit_amount)/Duration_in_months) > (0.333 * (coalesce(Net_transaction_value,0)/6)) and coalesce(Average_salary,0) = 0) then cast(round(((0.333*coalesce(lodgement-withdrawal,0)/6)*Duration_in_months*0.8),-2) as int)
			when (((Credit_amount)/Duration_in_months) <= (0.333 * (coalesce(Average_salary,0)))) then cast(round(Credit_amount,-2) as int)
			when (((Credit_amount)/Duration_in_months) > (0.333 * (coalesce(Average_salary,0)))) then cast(round((0.333*coalesce(Average_salary,0)*Duration_in_months*0.8),-2) as int)
			end) Rec_loan_amount
	-- Pay back amount computation using Compound Interest
		,CAST(ROUND((((case when(((Credit_amount)/Duration_in_months) <= (0.333 * (coalesce(Net_transaction_value,0)/6)) and coalesce(Average_salary,0) = 0) then Cast(round(Credit_amount,-2) as int)
			when (((Credit_amount)/Duration_in_months) > (0.333 * (coalesce(Net_transaction_value,0)/6)) and coalesce(Average_salary,0) = 0) then cast(round(((0.333*coalesce(lodgement-withdrawal,0)/6)*Duration_in_months*0.8),-2) as int)
			when (((Credit_amount)/Duration_in_months) <= (0.333 * (coalesce(Average_salary,0)))) then cast(round(Credit_amount,-2) as int)
			when (((Credit_amount)/Duration_in_months) > (0.333 * (coalesce(Average_salary,0)))) then cast(round((0.333*coalesce(Average_salary,0)*Duration_in_months*0.8),-2) as int)
			end)) * 
			(power((1 +((case when [Credit_Score] between 300 and 600 then 10
			when [Credit_Score] between 600 and 650 then 9
			when [Credit_Score] between 650 and 700 then 7
			when [Credit_Score] between 700 and 750 then 5
			when [Credit_Score] between 750 and 800 then 3
			when [Credit_Score] >= 800 then 2 end)*0.01)), Duration_in_months))), -2) as int) as Pay_back_amount
from 
(SELECT cdt.[CUSTID]
	,bio.[Marital_Status] 
	,bio.[Occupation]
	--,datediff(year,[DOB], getdate()) as Age
	,case when datediff(year,[DOB], getdate()) < 16 then 'Below 16'
		  when datediff(year,[DOB], getdate()) between 16 and 21 then '16 - 21'
		  when datediff(year,[DOB], getdate()) between 22 and 31 then '22 - 31'
		  when datediff(year,[DOB], getdate()) between 32 and 41 then '32 - 41'
		  when datediff(year,[DOB], getdate()) between 42 and 51 then '42 - 51'
		  when datediff(year,[DOB], getdate()) between 52 and 65 then '52 - 65'
		  when datediff(year,[DOB], getdate()) > 65 then 'Above 65'
	 End as Age_Band 
	,bio.[Education] 
	,bio.[Segment] 
	,bio.[No_of_Accounts] 
	,cdt.[Present employment since] 
	,cdt.[Present residence since]
	,cdt.[Housing] 
	,cdt.[Dependents] 
	,cdt.[Account_type] 
	,cdt.[Residential_status] 
	,cdt.[Employment_type] 
	,cdt.[Purpose] 
	,coalesce(lodgement,0)lodgement 
	,coalesce(lodgement_freq,0)lodgement_freq
	,coalesce(withdrawal,0)withdrawal
	,coalesce(withdrawal_freq,0)withdrawal_freq
	,bio.EOD_Balance 
	,coalesce(Average_salary,0) Average_salary
	,coalesce(lodgement,0) - coalesce(withdrawal,0) as Net_transaction_value
    ---categorizing credit carrying capacity
	,case when ((Credit_amount)/Duration_in_months) <= (0.333 * (coalesce(lodgement-withdrawal,0)/6)) and coalesce(Average_salary,0) = 0 then '<= 33.3%'
		when ((Credit_amount)/Duration_in_months) > (0.333 * (coalesce(lodgement-withdrawal,0)/6)) 
		and ((Credit_amount)/Duration_in_months) <= (0.50 * (coalesce(lodgement-withdrawal,0)/6)) and coalesce(Average_salary,0) =0 then '33.4% - 50%'
		when ((Credit_amount)/Duration_in_months) > (0.50 * (coalesce(lodgement-withdrawal,0)/6)) and coalesce(Average_salary,0) = 0 then '> 50%'
		when ((Credit_amount)/Duration_in_months) <= (0.333 * (coalesce(Average_salary,0))) then '<= 33.3%'
		when ((Credit_amount)/Duration_in_months) > (0.333 * (coalesce(Average_salary,0))) 
		and ((Credit_amount)/Duration_in_months) <= (0.50 *(coalesce(Average_salary,0))) then '33.4% - 50%'
		when ((Credit_amount)/Duration_in_months) > (0.50 * (coalesce(Average_salary,0))) then '> 50%'
		end credit_carrying_cap_category
	,(0.333 * (coalesce(lodgement-withdrawal,0)/6)) Net_txn_33_percent
	,(0.333 * (coalesce(Average_salary,0))) Avg_salary_33_percent
	,(0.50 * (coalesce(lodgement-withdrawal,0)/6))  Net_txn_50_percent
	,(0.50 * (coalesce(Average_salary,0))) Avg_salary_50_percent
	,coalesce(EOD_Balance,0) + (coalesce(lodgement_all,0) - coalesce(withdrawal_all,0)) as Account_Balance
	,isnull(inflow_value_1, 0) inflow_value_1
	,isnull(inflow_value_2, 0) inflow_value_2
	,isnull(inflow_value_3, 0) inflow_value_3
	,isnull(inflow_value_4, 0) inflow_value_4
	,isnull(inflow_value_5, 0) inflow_value_5
	,isnull(inflow_value_6, 0) inflow_value_6
	,isnull(inflow_vol_1, 0) inflow_vol_1
	,isnull(inflow_vol_2, 0) inflow_vol_2
	,isnull(inflow_vol_3, 0) inflow_vol_3
	,isnull(inflow_vol_4, 0) inflow_vol_4
	,isnull(inflow_vol_5, 0) inflow_vol_5
	,isnull(inflow_vol_6, 0) inflow_vol_6
	,isnull(outflow_value_1, 0) outflow_value_1
	,isnull(outflow_value_2, 0) outflow_value_2
	,isnull(outflow_value_3, 0) outflow_value_3
	,isnull(outflow_value_4, 0) outflow_value_4
	,isnull(outflow_value_5, 0) outflow_value_5
	,isnull(outflow_value_6, 0) outflow_value_6
	,isnull(outflow_vol_1, 0) outflow_vol_1	   
	,isnull(outflow_vol_2, 0) outflow_vol_2
	,isnull(outflow_vol_3, 0) outflow_vol_3	  
	,isnull(outflow_vol_4, 0) outflow_vol_4	  
	,isnull(outflow_vol_5, 0) outflow_vol_5	  
	,isnull(outflow_vol_6, 0) outflow_vol_6
	---categorizing inflow amount
	,case when (coalesce(inflow_value_1,0) > 0  and coalesce(inflow_value_2,0) = 0) then 'NewUser'
		when coalesce(inflow_value_1, 0 ) > coalesce(inflow_value_2, 0) and  coalesce(inflow_value_1, 0) >= 1.25 * coalesce(inflow_value_2, 0) then 'Grower'
		when (coalesce(inflow_value_1, 0 ) >= coalesce(inflow_value_2, 0) and coalesce(inflow_value_1, 0) < 1.25 * coalesce(inflow_value_2, 0)) then 'Flat'
		when (coalesce(inflow_value_1,0) = 0  and coalesce(inflow_value_2,0) > 0) then 'Stopper'
		when (coalesce(inflow_value_1, 0 ) < coalesce(inflow_value_2, 0) and  coalesce(inflow_value_1, 0) >= 0.75 * coalesce(inflow_value_2, 0)) then 'Flat'
		when (coalesce(inflow_value_1, 0 ) < coalesce(inflow_value_2, 0) and  coalesce(inflow_value_1, 0) < 0.75 * coalesce(inflow_value_2, 0)) then 'Dropper'
		when (coalesce(inflow_value_1,0) = 0 and coalesce(inflow_value_2,0) =0) then 'No_usage'
	end inflow_amount_comparison_1
	,case when (coalesce(inflow_value_2,0) > 0  and coalesce(inflow_value_3,0) = 0) then 'NewUser'
		when coalesce(inflow_value_2, 0 ) > coalesce(inflow_value_3, 0) and  coalesce(inflow_value_2, 0) >= 1.25 * coalesce(inflow_value_3, 0) then 'Grower'
		when (coalesce(inflow_value_2, 0 ) >= coalesce(inflow_value_3, 0) and coalesce(inflow_value_2, 0) < 1.25 * coalesce(inflow_value_3, 0)) then 'Flat'
		when (coalesce(inflow_value_2,0) = 0  and coalesce(inflow_value_3,0) > 0) then 'Stopper'
		when (coalesce(inflow_value_2, 0 ) < coalesce(inflow_value_3, 0) and  coalesce(inflow_value_2, 0) >= 0.75 * coalesce(inflow_value_3, 0)) then 'Flat'
		when (coalesce(inflow_value_2, 0 ) < coalesce(inflow_value_3, 0) and  coalesce(inflow_value_2, 0) < 0.75 * coalesce(inflow_value_3, 0)) then 'Dropper'
		when (coalesce(inflow_value_2,0) = 0 and coalesce(inflow_value_3,0) =0) then 'No_usage' 
	end inflow_amount_comparison_2
	,case when (coalesce(inflow_value_3,0) > 0  and coalesce(inflow_value_4,0) = 0) then 'NewUser'
		when coalesce(inflow_value_3, 0 ) > coalesce(inflow_value_4, 0) and  coalesce(inflow_value_3, 0) >= 1.25 * coalesce(inflow_value_4, 0) then 'Grower'
		when (coalesce(inflow_value_3, 0 ) >= coalesce(inflow_value_4, 0) and coalesce(inflow_value_3, 0) < 1.25 * coalesce(inflow_value_4, 0)) then 'Flat'
		when (coalesce(inflow_value_3,0) = 0  and coalesce(inflow_value_4,0) > 0) then 'Stopper'
		when (coalesce(inflow_value_3, 0 ) < coalesce(inflow_value_4, 0) and  coalesce(inflow_value_3, 0) >= 0.75 * coalesce(inflow_value_4, 0)) then 'Flat'
		when (coalesce(inflow_value_3, 0 ) < coalesce(inflow_value_4, 0) and  coalesce(inflow_value_3, 0) < 0.75 * coalesce(inflow_value_4, 0)) then 'Dropper'
		when (coalesce(inflow_value_3,0) = 0 and coalesce(inflow_value_4,0) =0) then 'No_usage' 
	end inflow_amount_comparison_3
	,case when (coalesce(inflow_value_4,0) > 0  and coalesce(inflow_value_5,0) = 0) then 'NewUser'
		when coalesce(inflow_value_4, 0 ) > coalesce(inflow_value_5, 0) and  coalesce(inflow_value_4, 0) >= 1.25 * coalesce(inflow_value_5, 0) then 'Grower'
		when (coalesce(inflow_value_4, 0 ) >= coalesce(inflow_value_5, 0) and coalesce(inflow_value_4, 0) < 1.25 * coalesce(inflow_value_5, 0)) then 'Flat'
		when (coalesce(inflow_value_4,0) = 0  and coalesce(inflow_value_5,0) > 0) then 'Stopper'
		when (coalesce(inflow_value_4, 0 ) < coalesce(inflow_value_5, 0) and  coalesce(inflow_value_4, 0) >= 0.75 * coalesce(inflow_value_5, 0)) then 'Flat'
		when (coalesce(inflow_value_4, 0 ) < coalesce(inflow_value_5, 0) and  coalesce(inflow_value_4, 0) < 0.75 * coalesce(inflow_value_5, 0)) then 'Dropper'
		when (coalesce(inflow_value_4,0) = 0 and coalesce(inflow_value_5,0) =0) then 'No_usage' 
	end inflow_amount_comparison_4
	,case when (coalesce(inflow_value_5,0) > 0  and coalesce(inflow_value_6,0) = 0) then 'NewUser'
		when coalesce(inflow_value_5, 0 ) > coalesce(inflow_value_6, 0) and  coalesce(inflow_value_5, 0) >= 1.25 * coalesce(inflow_value_6, 0) then 'Grower'
		when (coalesce(inflow_value_5, 0 ) >= coalesce(inflow_value_6, 0) and coalesce(inflow_value_5, 0) < 1.25 * coalesce(inflow_value_6, 0)) then 'Flat'
		when (coalesce(inflow_value_5,0) = 0  and coalesce(inflow_value_6,0) > 0) then 'Stopper'
		when (coalesce(inflow_value_5, 0 ) < coalesce(inflow_value_6, 0) and  coalesce(inflow_value_5, 0) >= 0.75 * coalesce(inflow_value_6, 0)) then 'Flat'
		when (coalesce(inflow_value_5, 0 ) < coalesce(inflow_value_6, 0) and  coalesce(inflow_value_5, 0) < 0.75 * coalesce(inflow_value_6, 0)) then 'Dropper'
		when (coalesce(inflow_value_5,0) = 0 and coalesce(inflow_value_6,0) =0) then 'No_usage' 
	end inflow_amount_comparison_5
	,isnull(txn_Vol_M1, 0) txn_Vol_M1
	,isnull(txn_Vol_M2, 0) txn_Vol_M2
	,isnull(txn_Vol_M3, 0) txn_Vol_M3
	,isnull(txn_Vol_M4, 0) txn_Vol_M4
	,isnull(txn_Vol_M5, 0) txn_Vol_M5
	,isnull(txn_Vol_M6, 0) txn_Vol_M6	 
	---categorizing inflow volume
	,case when (coalesce(inflow_vol_1,0) > 0  and coalesce(inflow_vol_2,0) = 0) then 'NewUser'
		when coalesce(inflow_vol_1, 0 ) > coalesce(inflow_vol_2, 0) and  coalesce(inflow_vol_1, 0) >= 1.25 * coalesce(inflow_vol_2, 0) then 'Grower'
		when (coalesce(inflow_vol_1, 0 ) >= coalesce(inflow_vol_2, 0) and coalesce(inflow_vol_1, 0) < 1.25 * coalesce(inflow_vol_2, 0)) then 'Flat'
		when (coalesce(inflow_vol_1,0) = 0  and coalesce(inflow_vol_2,0) > 0) then 'Stopper'
		when (coalesce(inflow_vol_1, 0 ) < coalesce(inflow_vol_2, 0) and  coalesce(inflow_vol_1, 0) >= 0.75 * coalesce(inflow_vol_2, 0)) then 'Flat'
		when (coalesce(inflow_vol_1, 0 ) < coalesce(inflow_vol_2, 0) and  coalesce(inflow_vol_1, 0) < 0.75 * coalesce(inflow_vol_2, 0)) then 'Dropper'
		when (coalesce(inflow_vol_1,0) = 0 and coalesce(inflow_vol_2,0) =0) then 'No_usage'
	end inflow_vol_comparison_1
	,case when (coalesce(inflow_vol_2,0) > 0  and coalesce(inflow_vol_3,0) = 0) then 'NewUser'
		when coalesce(inflow_vol_2, 0 ) > coalesce(inflow_vol_3, 0) and  coalesce(inflow_vol_2, 0) >= 1.25 * coalesce(inflow_vol_3, 0) then 'Grower'
		when (coalesce(inflow_vol_2, 0 ) >= coalesce(inflow_vol_3, 0) and coalesce(inflow_vol_2, 0) < 1.25 * coalesce(inflow_vol_3, 0)) then 'Flat'
		when (coalesce(inflow_vol_2,0) = 0  and coalesce(inflow_vol_3,0) > 0) then 'Stopper'
		when (coalesce(inflow_vol_2, 0 ) < coalesce(inflow_vol_3, 0) and  coalesce(inflow_vol_2, 0) >= 0.75 * coalesce(inflow_vol_3, 0)) then 'Flat'
		when (coalesce(inflow_vol_2, 0 ) < coalesce(inflow_vol_3, 0) and  coalesce(inflow_vol_2, 0) < 0.75 * coalesce(inflow_vol_3, 0)) then 'Dropper'
		when (coalesce(inflow_vol_2,0) = 0 and coalesce(inflow_vol_3,0) =0) then 'No_usage' 
	end inflow_vol_comparison_2
	,case when (coalesce(inflow_vol_3,0) > 0  and coalesce(inflow_vol_4,0) = 0) then 'NewUser'
		when coalesce(inflow_vol_3, 0 ) > coalesce(inflow_vol_4, 0) and  coalesce(inflow_vol_3, 0) >= 1.25 * coalesce(inflow_vol_4, 0) then 'Grower'
		when (coalesce(inflow_vol_3, 0 ) >= coalesce(inflow_vol_4, 0) and coalesce(inflow_vol_3, 0) < 1.25 * coalesce(inflow_vol_4, 0)) then 'Flat'
		when (coalesce(inflow_vol_3,0) = 0  and coalesce(inflow_vol_4,0) > 0) then 'Stopper'
		when (coalesce(inflow_vol_3, 0 ) < coalesce(inflow_vol_4, 0) and  coalesce(inflow_vol_3, 0) >= 0.75 * coalesce(inflow_vol_4, 0)) then 'Flat'
		when (coalesce(inflow_vol_3, 0 ) < coalesce(inflow_vol_4, 0) and  coalesce(inflow_vol_3, 0) < 0.75 * coalesce(inflow_vol_4, 0)) then 'Dropper'
		when (coalesce(inflow_vol_3,0) = 0 and coalesce(inflow_vol_4,0) =0) then 'No_usage' 
	end inflow_vol_comparison_3
	,case when (coalesce(inflow_vol_4,0) > 0  and coalesce(inflow_vol_5,0) = 0) then 'NewUser'
		when coalesce(inflow_vol_4, 0 ) > coalesce(inflow_vol_5, 0) and  coalesce(inflow_vol_4, 0) >= 1.25 * coalesce(inflow_vol_5, 0) then 'Grower'
		when (coalesce(inflow_vol_4, 0 ) >= coalesce(inflow_vol_5, 0) and coalesce(inflow_vol_4, 0) < 1.25 * coalesce(inflow_vol_5, 0)) then 'Flat'
		when (coalesce(inflow_vol_4,0) = 0  and coalesce(inflow_vol_5,0) > 0) then 'Stopper'
		when (coalesce(inflow_vol_4, 0 ) < coalesce(inflow_vol_5, 0) and  coalesce(inflow_vol_4, 0) >= 0.75 * coalesce(inflow_vol_5, 0)) then 'Flat'
		when (coalesce(inflow_vol_4, 0 ) < coalesce(inflow_vol_5, 0) and  coalesce(inflow_vol_4, 0) < 0.75 * coalesce(inflow_vol_5, 0)) then 'Dropper'
		when (coalesce(inflow_vol_4,0) = 0 and coalesce(inflow_vol_5,0) =0) then 'No_usage' 
	end inflow_vol_comparison_4
	,case when (coalesce(inflow_vol_5,0) > 0  and coalesce(inflow_vol_6,0) = 0) then 'NewUser'
		when coalesce(inflow_vol_5, 0 ) > coalesce(inflow_vol_6, 0) and  coalesce(inflow_vol_5, 0) >= 1.25 * coalesce(inflow_vol_6, 0) then 'Grower'
		when (coalesce(inflow_vol_5, 0 ) >= coalesce(inflow_vol_6, 0) and coalesce(inflow_vol_5, 0) < 1.25 * coalesce(inflow_vol_6, 0)) then 'Flat'
		when (coalesce(inflow_vol_5,0) = 0  and coalesce(inflow_vol_6,0) > 0) then 'Stopper'
		when (coalesce(inflow_vol_5, 0 ) < coalesce(inflow_vol_6, 0) and  coalesce(inflow_vol_5, 0) >= 0.75 * coalesce(inflow_vol_6, 0)) then 'Flat'
		when (coalesce(inflow_vol_5, 0 ) < coalesce(inflow_vol_6, 0) and  coalesce(inflow_vol_5, 0) < 0.75 * coalesce(inflow_vol_6, 0)) then 'Dropper'
		when (coalesce(inflow_vol_5,0) = 0 and coalesce(inflow_vol_6,0) =0) then 'No_usage' 
	end inflow_vol_comparison_5
	,isnull(txn_consistency_1, 0) txn_consistency_1
	,isnull(txn_consistency_2, 0) txn_consistency_2
	,isnull(txn_consistency_3, 0) txn_consistency_3
	,isnull(txn_consistency_4, 0) txn_consistency_4
	,isnull(txn_consistency_5, 0) txn_consistency_5
	,isnull(txn_consistency_6, 0) txn_consistency_6
	,(coalesce(txn_consistency_1,0) + coalesce(txn_consistency_2,0) + coalesce(txn_consistency_3,0) +coalesce(txn_consistency_4,0) +coalesce(txn_consistency_5,0) + coalesce(txn_consistency_6,0)) as Consistency_score
	---transaction consistency rating
	,case when (coalesce(txn_consistency_1,0) + coalesce(txn_consistency_2,0) + coalesce(txn_consistency_3,0) +coalesce(txn_consistency_4,0) +coalesce(txn_consistency_5,0) + coalesce(txn_consistency_6,0)) = 6 then 'consistent'
		when (coalesce(txn_consistency_1,0) + coalesce(txn_consistency_2,0) + coalesce(txn_consistency_3,0) +coalesce(txn_consistency_4,0) +coalesce(txn_consistency_5,0) + coalesce(txn_consistency_6,0)) <6 and 
			 (coalesce(txn_consistency_1,0) + coalesce(txn_consistency_2,0) + coalesce(txn_consistency_3,0) +coalesce(txn_consistency_4,0) +coalesce(txn_consistency_5,0) + coalesce(txn_consistency_6,0)) >= 3 then 'less consistent'
		when (coalesce(txn_consistency_1,0) + coalesce(txn_consistency_2,0) + coalesce(txn_consistency_3,0) +coalesce(txn_consistency_4,0) +coalesce(txn_consistency_5,0) + coalesce(txn_consistency_6,0)) < 3 then 'Poor' end Consistency_Rating
	---categorizing recency of latest transaction
	,case when datediff(day,[Latest_TxnDate], getdate()) <= 30 then '<=30 days'
		when datediff(day,[Latest_TxnDate], getdate()) between 30 and 61 then '30-60 days'
		when datediff(day,[Latest_TxnDate], getdate()) between 60 and 91 then '60-90 days'
		when datediff(day,[Latest_TxnDate], getdate()) between 90 and 181 then '90-180 days'
		when datediff(day,[Latest_TxnDate], getdate()) between 180 and 361 then '180-360 days'
		when datediff(day,[Latest_TxnDate], getdate()) > 360 then 'Above 360 days' end Recency 
	,coalesce(transfers_amount,0) Transfers_amount
	,coalesce(transfers_freq,0) transfers_freq
	---categorizing transfer frequency
	,case when coalesce(transfers_freq,0) >= 6  then 'Heavy'
		when coalesce(transfers_freq,0) > 2 and coalesce(transfers_freq,0)  <= 5  then 'Regular'
		when coalesce(transfers_freq,0) > 0 and coalesce(transfers_freq,0)  <= 2  then 'Light'
		else 'no usage' end Transfers_Freq_Category
	,coalesce(utility_spending_amount,0) utility_spending_amount
	,coalesce(utility_spending_freq,0) utility_spending_freq
	---categorizing utility spending frequency
	,case when coalesce(utility_spending_freq,0) >= 6 then 'Heavy'
		when coalesce(utility_spending_freq,0) < 6 and coalesce(utility_spending_freq,0) >= 3 then 'Regular'
		when coalesce(utility_spending_freq,0) < 3 and coalesce(utility_spending_freq,0) >= 1 then 'Light'
		else 'No usage' end Utility_Spending_Freq_Category
	,coalesce(fees_amount,0) fees_amount
	,coalesce(fees_freq,0) fees_freq
	---categorizing fees frequency
	,case when coalesce(fees_freq,0) >= 6  then 'Heavy'
		when coalesce(fees_freq,0) > 2 and coalesce(fees_freq,0)  <= 5  then 'Regular'
		when coalesce(fees_freq,0) > 0 and coalesce(fees_freq,0)  <= 2  then 'Light'
		else 'No usage' end Fees_Freq_Category
	,coalesce(mobile_nw_amount,0) mobile_nw_amount
	,coalesce(mobile_nw_freq,0) mobile_nw_freq
	---categorzing frequency of transactions on mobile network
	,case when coalesce(mobile_nw_freq,0) >= 12 then 'Heavy'
		when coalesce(mobile_nw_freq,0) < 12 and coalesce(mobile_nw_freq,0) >= 6 then 'Regular'
		when coalesce(mobile_nw_freq,0) < 6 and coalesce(mobile_nw_freq,0) >= 1 then 'Light'
		else 'No usage' end Mobile_nw_Freq_Category
	,coalesce(purchase_amount,0) purchase_amount
	,coalesce(purchase_freq,0) purchase_freq
	---categorizing purchase frquency
	,case when coalesce(purchase_freq,0) >= 8 then 'Heavy'
		when coalesce(purchase_freq,0) < 8 and coalesce(purchase_freq,0) >= 5 then 'Regular'
		when coalesce(purchase_freq,0) < 5 and coalesce(purchase_freq,0) >= 1 then 'Light'
		else 'No usage' end Purchase_Freq_Category
	---categorizing transaction frequency for month 1
	,case when txn_vol_M1 <=3 and txn_vol_M1 > 0 then 'poor'
		when txn_vol_M1 >3 and txn_vol_M1 <=8 then 'light'
		when txn_vol_M1 >8 and txn_vol_M1 <=12 then 'average'
		when txn_vol_M1 >12 and txn_vol_M1 <=20 then 'regular'
		when txn_vol_M1 >20 then 'Heavy'
		else 'no usage' end Txn_Freq_M1
	---categorizing transaction frequency for month 2
	,case when txn_vol_M2  <=3 and txn_vol_M2 > 0 then 'poor'
		when txn_vol_M2 >3 and txn_vol_M2 <=8 then 'light'
		when txn_vol_M2 >8 and txn_vol_M2 <=12 then 'average'
		when txn_vol_M2 >12 and txn_vol_M2 <=20 then 'regular'
		when txn_vol_M2 >20 then 'Heavy'
		else 'no usage' end txn_Freq_M2
	---categorizing transaction frequency for month 3
	,case when txn_vol_M3 <=3 and txn_vol_M3 > 0 then 'poor'
		when txn_vol_M3 >3 and txn_vol_M3 <=8 then 'light'
		when txn_vol_M3 >8 and txn_vol_M3 <=12 then 'average'
		when txn_vol_M3 >12 and txn_vol_M3 <=20 then 'regular'
		when txn_vol_M3 >20 then 'Heavy'
		else 'no usage' end txn_Freq_M3
	---categorizing transaction frequency for month 4
	,case when txn_vol_M4 <=3 and txn_vol_M4 > 0 then 'poor'
		when txn_vol_M4 >3 and txn_vol_M4 <=8 then 'light'
		when txn_vol_M4 >8 and txn_vol_M4 <=12 then 'average'
		when txn_vol_M4 >12 and txn_vol_M4 <=20 then 'regular'
		when txn_vol_M4 >20 then 'Heavy'
		else 'no usage' end txn_Freq_M4
	---categorizing transaction frequency for month 5
	,case when txn_vol_M5 <=3 and txn_vol_M5 > 0 then 'poor'
		when txn_vol_M5 >3 and txn_vol_M5 <=8 then 'light'
		when txn_vol_M5 >8 and txn_vol_M5 <=12 then 'average'
		when txn_vol_M5 >12 and txn_vol_M5 <=20 then 'regular'
		when txn_vol_M5 >20 then 'Heavy'
		else 'no usage' end txn_Freq_M5
	---categorizing transaction frequency for month 6
	,case when txn_vol_M6 <=3 and txn_vol_M6 > 0 then 'poor'
		when txn_vol_M6 >3 and txn_vol_M6 <=8 then 'light'
		when txn_vol_M6 >8 and txn_vol_M6 <=12 then 'average'
		when txn_vol_M6 >12 and txn_vol_M6 <=20 then 'regular'
		when txn_vol_M6 >20 then 'Heavy'
		else 'no usage' end txn_Freq_M6
	,[Credit_amount]
	,[Duration_in_months]
	,coalesce(loan_from_other_banks,'NA') loan_from_other_banks 
    ,coalesce(outstanding_loan ,'NA') outstanding_loan
    ,coalesce(outstanding_loan_balance , 0) outstanding_loan_balance
    ,coalesce(defaulted_previously ,'NA') defaulted_previously
    ,coalesce(payment_default_history , 'NA') payment_default_history
	,isnull(outstanding_loan_duration, 0) outstanding_loan_duration
	
	---credit score computation
	,(select (
			---- Credict Application Data       Proposed score = 10% of Score =  85     Actual = 122 (14+18+19+10+19+42)
			(case when Housing = 'own' then 14
				when Housing = 'rent' then 6 else 10 
			end ) +
			
			(case when Dependents < 1 then 18 
				when Dependents = 1 then 17
				when Dependents = 2 then 14
				when Dependents = 3 then 10
				when Dependents >= 4 then 6 
			end) +

			(case when Employment_type = 'private' then 19
				when Employment_type = 'public' then 19
				when Employment_type = 'Self Employed' then 10
				when Employment_type = 'Unemployed' then 0 
			end) +

			(case when Purpose = 'education' then 10
				when Purpose = 'housing' then 10
				when Purpose = 'Car purchase' then 10
				when Purpose = 'Medicals' then 10
				when Purpose = 'business' then 10
				when Purpose = 'rent' then 10
				else 10
			end) +

			(case when Residential_status = 'Immigrant' then 10
				else 19 
			end) + 
			
			(case when [Present employment since] = 'more than 7 years' then 42
				when [Present employment since] = '4 to 7 years' then 36
				when [Present employment since] = '1 to 4 years' then 24
				when [Present employment since] = 'less than 1 year' then 12
				when [Present employment since] = 'Unemployed' then 0 
			end) +


			---- Demography Data      Proposed score = 20% of Score =  170     Actual = 70 (33+28+9)
			(case when datediff(year,[DOB], getdate()) <= 17 then 0
					when datediff(year,[DOB], getdate())between 18 and 29 then 21
					when datediff(year,[DOB], getdate())between 30 and 39 then 33
					when datediff(year,[DOB], getdate())between 40 and 49 then 33
					when datediff(year,[DOB], getdate())between 50 and 59 then 21
					when datediff(year,[DOB], getdate()) >= 60 then 0 
			end) +
			
			(case when Segment = 'HNI' then 28
				when Segment = 'Mass Market' then 12 
			end) +
					
			(case when No_of_accounts < 2 then 5 else 9 
			end) +
			

			----- Transaction Data       Proposed score = 50% of Score =  425     Actual = 593 (120+18+19+19+19+19+19+3+19+19+19+19+19+38+19+19+19+19+19+19+22+22+22+22+22)
			(case when ((Credit_amount )/Duration_in_months) < (0.33 * (coalesce(lodgement-withdrawal,0)/6)) and coalesce(Average_salary,0) = 0 then 120
				when ((Credit_amount )/Duration_in_months) > (0.33 * (coalesce(lodgement-withdrawal,0)/6)) 
				and ((Credit_amount )/Duration_in_months) < (0.50 * (coalesce(lodgement-withdrawal,0)/6)) and coalesce(Average_salary,0) =0 then 60
				when ((Credit_amount )/Duration_in_months) > (0.50 * (coalesce(lodgement-withdrawal,0)/6)) and coalesce(Average_salary,0) = 0 then 10
				when ((Credit_amount )/Duration_in_months) < (0.33 * (coalesce(Average_salary,0))) then 120
				when ((Credit_amount )/Duration_in_months) > (0.33 * (coalesce(Average_salary,0))) 
				and ((Credit_amount )/Duration_in_months) < (0.50 *(coalesce(Average_salary,0))) then 60
				when ((Credit_amount )/Duration_in_months) > (0.50 * (coalesce(Average_salary,0))) then 10 
			end) +  
			(case when (coalesce(lodgement,0)/6 - coalesce(withdrawal,0)/6) < 0 then 0
				when (coalesce(lodgement,0)/6 - coalesce(withdrawal,0)/6) < coalesce(withdrawal,0)/6 and (coalesce(lodgement,0)/6 - coalesce(withdrawal,0)/6) > 0 then 10
				when (coalesce(lodgement,0)/6 - coalesce(withdrawal,0)/6) > coalesce(withdrawal,0)/6 then 18 
			end) +
			(case when (coalesce(inflow_value_1,0) > 0  and coalesce(inflow_value_2,0) = 0) then 9
				when coalesce(inflow_value_1, 0 ) > coalesce(inflow_value_2, 0) and  coalesce(inflow_value_1, 0) >= 1.25 * coalesce(inflow_value_2, 0) then 19
				when (coalesce(inflow_value_1, 0 ) >= coalesce(inflow_value_2, 0) and coalesce(inflow_value_1, 0) < 1.25 * coalesce(inflow_value_2, 0)) then 12
				when (coalesce(inflow_value_1,0) = 0  and coalesce(inflow_value_2,0) > 0) then 3
				when (coalesce(inflow_value_1, 0 ) < coalesce(inflow_value_2, 0) and  coalesce(inflow_value_1, 0) >= 0.75 * coalesce(inflow_value_2, 0)) then 12
				when (coalesce(inflow_value_1, 0 ) < coalesce(inflow_value_2, 0) and  coalesce(inflow_value_1, 0) < 0.75 * coalesce(inflow_value_2, 0)) then 6
				when (coalesce(inflow_value_1,0) = 0 and coalesce(inflow_value_2,0) =0) then 0
			end) +
			(case when (coalesce(inflow_value_2,0) > 0  and coalesce(inflow_value_3,0) = 0) then 9
				when coalesce(inflow_value_2, 0 ) > coalesce(inflow_value_3, 0) and  coalesce(inflow_value_2, 0) >= 1.25 * coalesce(inflow_value_3, 0) then 19
				when (coalesce(inflow_value_2, 0 ) >= coalesce(inflow_value_3, 0) and coalesce(inflow_value_2, 0) < 1.25 * coalesce(inflow_value_3, 0)) then 12
				when (coalesce(inflow_value_2,0) = 0  and coalesce(inflow_value_3,0) > 0) then 3
				when (coalesce(inflow_value_2, 0 ) < coalesce(inflow_value_3, 0) and  coalesce(inflow_value_2, 0) >= 0.75 * coalesce(inflow_value_3, 0)) then 12
				when (coalesce(inflow_value_2, 0 ) < coalesce(inflow_value_3, 0) and  coalesce(inflow_value_2, 0) < 0.75 * coalesce(inflow_value_3, 0)) then 6
				when (coalesce(inflow_value_2,0) = 0 and coalesce(inflow_value_3,0) =0) then 0 
			end) +
			(case when (coalesce(inflow_value_3,0) > 0  and coalesce(inflow_value_4,0) = 0) then 9
				when coalesce(inflow_value_3, 0 ) > coalesce(inflow_value_4, 0) and  coalesce(inflow_value_3, 0) >= 1.25 * coalesce(inflow_value_4, 0) then 19
				when (coalesce(inflow_value_3, 0 ) >= coalesce(inflow_value_4, 0) and coalesce(inflow_value_3, 0) < 1.25 * coalesce(inflow_value_4, 0)) then 12
				when (coalesce(inflow_value_3,0) = 0  and coalesce(inflow_value_4,0) > 0) then 3
				when (coalesce(inflow_value_3, 0 ) < coalesce(inflow_value_4, 0) and  coalesce(inflow_value_3, 0) >= 0.75 * coalesce(inflow_value_4, 0)) then 12
				when (coalesce(inflow_value_3, 0 ) < coalesce(inflow_value_4, 0) and  coalesce(inflow_value_3, 0) < 0.75 * coalesce(inflow_value_4, 0)) then 6
				when (coalesce(inflow_value_3,0) = 0 and coalesce(inflow_value_4,0) =0) then 0 
			end) +
			(case when (coalesce(inflow_value_4,0) > 0  and coalesce(inflow_value_5,0) = 0) then 9
				when coalesce(inflow_value_4, 0 ) > coalesce(inflow_value_5, 0) and  coalesce(inflow_value_4, 0) >= 1.25 * coalesce(inflow_value_5, 0) then 19
				when (coalesce(inflow_value_4, 0 ) >= coalesce(inflow_value_5, 0) and coalesce(inflow_value_4, 0) < 1.25 * coalesce(inflow_value_5, 0)) then 12
				when (coalesce(inflow_value_4,0) = 0  and coalesce(inflow_value_5,0) > 0) then 3
				when (coalesce(inflow_value_4, 0 ) < coalesce(inflow_value_5, 0) and  coalesce(inflow_value_4, 0) >= 0.75 * coalesce(inflow_value_5, 0)) then 12
				when (coalesce(inflow_value_4, 0 ) < coalesce(inflow_value_5, 0) and  coalesce(inflow_value_4, 0) < 0.75 * coalesce(inflow_value_5, 0)) then 6
				when (coalesce(inflow_value_4,0) = 0 and coalesce(inflow_value_5,0) =0) then 0 
			end) +
			(case when (coalesce(inflow_value_5,0) > 0  and coalesce(inflow_value_6,0) = 0) then 9
				when coalesce(inflow_value_5, 0 ) > coalesce(inflow_value_6, 0) and  coalesce(inflow_value_5, 0) >= 1.25 * coalesce(inflow_value_6, 0) then 19
				when (coalesce(inflow_value_5, 0 ) >= coalesce(inflow_value_6, 0) and coalesce(inflow_value_5, 0) < 1.25 * coalesce(inflow_value_6, 0)) then 12
				when (coalesce(inflow_value_5,0) = 0  and coalesce(inflow_value_6,0) > 0) then 3
				when (coalesce(inflow_value_5, 0 ) < coalesce(inflow_value_6, 0) and  coalesce(inflow_value_5, 0) >= 0.75 * coalesce(inflow_value_6, 0)) then 12
				when (coalesce(inflow_value_5, 0 ) < coalesce(inflow_value_6, 0) and  coalesce(inflow_value_5, 0) < 0.75 * coalesce(inflow_value_6, 0)) then 6
				when (coalesce(inflow_value_5,0) = 0 and coalesce(inflow_value_6,0) =0) then 0 
			end) +
			(case when coalesce(txn_consistency_1,0) >= 1 then 3 else 0 end) +
			(case when coalesce(txn_consistency_2,0) >= 1 then 3 else 0 end) +
			(case when coalesce(txn_consistency_3,0) >= 1 then 3 else 0 end) +
			(case when coalesce(txn_consistency_4,0) >= 1 then 3 else 0 end) +
			(case when coalesce(txn_consistency_5,0) >= 1 then 3 else 0 end) +
			(case when coalesce(txn_consistency_6,0) >= 1 then 3 else 0 end) +				
			(case when (coalesce(inflow_vol_1,0) > 0  and coalesce(inflow_vol_2,0) = 0) then 9
				when coalesce(inflow_vol_1, 0 ) > coalesce(inflow_vol_2, 0) and  coalesce(inflow_vol_1, 0) >= 1.25 * coalesce(inflow_vol_2, 0) then 19
				when (coalesce(inflow_vol_1, 0 ) >= coalesce(inflow_vol_2, 0) and coalesce(inflow_vol_1, 0) < 1.25 * coalesce(inflow_vol_2, 0)) then 12
				when (coalesce(inflow_vol_1,0) = 0  and coalesce(inflow_vol_2,0) > 0) then 3
				when (coalesce(inflow_vol_1, 0 ) < coalesce(inflow_vol_2, 0) and  coalesce(inflow_vol_1, 0) >= 0.75 * coalesce(inflow_vol_2, 0)) then 12
				when (coalesce(inflow_vol_1, 0 ) < coalesce(inflow_vol_2, 0) and  coalesce(inflow_vol_1, 0) < 0.75 * coalesce(inflow_vol_2, 0)) then 6
				when (coalesce(inflow_vol_1,0) = 0 and coalesce(inflow_vol_2,0) =0) then 0
			end) +
			(case when (coalesce(inflow_vol_2,0) > 0  and coalesce(inflow_vol_3,0) = 0) then 9
				when coalesce(inflow_vol_2, 0 ) > coalesce(inflow_vol_3, 0) and  coalesce(inflow_vol_2, 0) >= 1.25 * coalesce(inflow_vol_3, 0) then 19
				when (coalesce(inflow_vol_2, 0 ) >= coalesce(inflow_vol_3, 0) and coalesce(inflow_vol_2, 0) < 1.25 * coalesce(inflow_vol_3, 0)) then 12
				when (coalesce(inflow_vol_2,0) = 0  and coalesce(inflow_vol_3,0) > 0) then 3
				when (coalesce(inflow_vol_2, 0 ) < coalesce(inflow_vol_3, 0) and  coalesce(inflow_vol_2, 0) >= 0.75 * coalesce(inflow_vol_3, 0)) then 12
				when (coalesce(inflow_vol_2, 0 ) < coalesce(inflow_vol_3, 0) and  coalesce(inflow_vol_2, 0) < 0.75 * coalesce(inflow_vol_3, 0)) then 6
				when (coalesce(inflow_vol_2,0) = 0 and coalesce(inflow_vol_3,0) =0) then 0 
			end) +
			(case when (coalesce(inflow_vol_3,0) > 0  and coalesce(inflow_vol_4,0) = 0) then 9
				when coalesce(inflow_vol_3, 0 ) > coalesce(inflow_vol_4, 0) and  coalesce(inflow_vol_3, 0) >= 1.25 * coalesce(inflow_vol_4, 0) then 19
				when (coalesce(inflow_vol_3, 0 ) >= coalesce(inflow_vol_4, 0) and coalesce(inflow_vol_3, 0) < 1.25 * coalesce(inflow_vol_4, 0)) then 12
				when (coalesce(inflow_vol_3,0) = 0  and coalesce(inflow_vol_4,0) > 0) then 3
				when (coalesce(inflow_vol_3, 0 ) < coalesce(inflow_vol_4, 0) and  coalesce(inflow_vol_3, 0) >= 0.75 * coalesce(inflow_vol_4, 0)) then 12
				when (coalesce(inflow_vol_3, 0 ) < coalesce(inflow_vol_4, 0) and  coalesce(inflow_vol_3, 0) < 0.75 * coalesce(inflow_vol_4, 0)) then 6
				when (coalesce(inflow_vol_3,0) = 0 and coalesce(inflow_vol_4,0) =0) then 0 
			end) +
			(case when (coalesce(inflow_vol_4,0) > 0  and coalesce(inflow_vol_5,0) = 0) then 9
				when coalesce(inflow_vol_4, 0 ) > coalesce(inflow_vol_5, 0) and  coalesce(inflow_vol_4, 0) >= 1.25 * coalesce(inflow_vol_5, 0) then 19
				when (coalesce(inflow_vol_4, 0 ) >= coalesce(inflow_vol_5, 0) and coalesce(inflow_vol_4, 0) < 1.25 * coalesce(inflow_vol_5, 0)) then 12
				when (coalesce(inflow_vol_4,0) = 0  and coalesce(inflow_vol_5,0) > 0) then 3
				when (coalesce(inflow_vol_4, 0 ) < coalesce(inflow_vol_5, 0) and  coalesce(inflow_vol_4, 0) >= 0.75 * coalesce(inflow_vol_5, 0)) then 12
				when (coalesce(inflow_vol_4, 0 ) < coalesce(inflow_vol_5, 0) and  coalesce(inflow_vol_4, 0) < 0.75 * coalesce(inflow_vol_5, 0)) then 6
				when (coalesce(inflow_vol_4,0) = 0 and coalesce(inflow_vol_5,0) =0) then 0 
			end) +
			(case when (coalesce(inflow_vol_5,0) > 0  and coalesce(inflow_vol_6,0) = 0) then 9
				when coalesce(inflow_vol_5, 0 ) > coalesce(inflow_vol_6, 0) and  coalesce(inflow_vol_5, 0) >= 1.25 * coalesce(inflow_vol_6, 0) then 19
				when (coalesce(inflow_vol_5, 0 ) >= coalesce(inflow_vol_6, 0) and coalesce(inflow_vol_5, 0) < 1.25 * coalesce(inflow_vol_6, 0)) then 12
				when (coalesce(inflow_vol_5,0) = 0  and coalesce(inflow_vol_6,0) > 0) then 3
				when (coalesce(inflow_vol_5, 0 ) < coalesce(inflow_vol_6, 0) and  coalesce(inflow_vol_5, 0) >= 0.75 * coalesce(inflow_vol_6, 0)) then 12
				when (coalesce(inflow_vol_5, 0 ) < coalesce(inflow_vol_6, 0) and  coalesce(inflow_vol_5, 0) < 0.75 * coalesce(inflow_vol_6, 0)) then 6
				when (coalesce(inflow_vol_5,0) = 0 and coalesce(inflow_vol_6,0) =0) then 0 
			end) +
			(case when datediff(day,[Latest_TxnDate], getdate()) <= 30 then 38
				when datediff(day,[Latest_TxnDate], getdate()) between 30 and 61 then 26
				when datediff(day,[Latest_TxnDate], getdate()) between 60 and 91 then 21
				when datediff(day,[Latest_TxnDate], getdate()) between 90 and 181 then 16
				when datediff(day,[Latest_TxnDate], getdate()) between 180 and 361 then 10
				when datediff(day,[Latest_TxnDate], getdate()) > 360 then 5 
			end) +
			(case when txn_vol_M1 <= 3 and txn_vol_M1 > 0 then 3
				when txn_vol_M1 > 3 and txn_vol_M1 <= 8 then 9
				when txn_vol_M1 > 8 and txn_vol_M1 <= 12 then 12
				when txn_vol_M1 > 12 and txn_vol_M1 <= 20 then 15
				when txn_vol_M1 > 20 then 19
				else 0 
			end) +
			(case when txn_vol_M2  <= 3 and txn_vol_M2 > 0 then 3
				when txn_vol_M2 > 3 and txn_vol_M2 <= 8 then 9
				when txn_vol_M2 > 8 and txn_vol_M2 <= 12 then 12
				when txn_vol_M2 > 12 and txn_vol_M2 <= 20 then 15
				when txn_vol_M2 > 20 then 19
				else 0 
			end) +
			(case when txn_vol_M3 <= 3 and txn_vol_M3 > 0 then 3
				when txn_vol_M3 > 3 and txn_vol_M3 <= 8 then 9
				when txn_vol_M3 > 8 and txn_vol_M3 <= 12 then 12
				when txn_vol_M3 > 12 and txn_vol_M3 <= 20 then 15
				when txn_vol_M3 > 20 then 19
				else 0 
			end) +
			(case when txn_vol_M4 <= 3 and txn_vol_M4 > 0 then 3
				when txn_vol_M4 > 3 and txn_vol_M4 <= 8 then 9
				when txn_vol_M4 > 8 and txn_vol_M4 <= 12 then 12
				when txn_vol_M4 > 12 and txn_vol_M4 <= 20 then 15
				when txn_vol_M4 > 20 then 19
				else 0 
			end) +
			(case when txn_vol_M5 <= 3 and txn_vol_M5 > 0 then 3
				when txn_vol_M5 > 3 and txn_vol_M5 <= 8 then 9
				when txn_vol_M5 > 8 and txn_vol_M5 <= 12 then 12
				when txn_vol_M5 > 12 and txn_vol_M5 <= 20 then 15
				when txn_vol_M5 > 20 then 19
				else 0 
			end) +
			(case when txn_vol_M6 <= 3 and txn_vol_M6 > 0 then 3
				when txn_vol_M6 > 3 and txn_vol_M6 <= 8 then 9
				when txn_vol_M6 > 8 and txn_vol_M6 <= 12 then 12
				when txn_vol_M6 > 12 and txn_vol_M6 <= 20 then 15
				when txn_vol_M6 > 20 then 19
				else 0 
			end) + 

			--- Transaction Lifestyle Data
			(case when coalesce(transfers_freq,0) >= 6  then 22
				when coalesce(transfers_freq,0) > 2 and coalesce(transfers_freq,0)  <= 5  then 14
				when coalesce(transfers_freq,0) > 0 and coalesce(transfers_freq,0)  <= 2  then 7
				else 0
			end) +
			(case when coalesce(utility_spending_freq,0) >= 6 then 22
				when coalesce(utility_spending_freq,0) < 6 and coalesce(utility_spending_freq,0) >= 3 then 14
				when coalesce(utility_spending_freq,0) < 3 and coalesce(utility_spending_freq,0) >= 1 then 7
				else 0 
			end ) +
			(case when coalesce(fees_freq,0) >= 6  then 22
				when coalesce(fees_freq,0) > 2 and coalesce(fees_freq,0)  <= 5  then 14
				when coalesce(fees_freq,0) > 0 and coalesce(fees_freq,0)  <= 2  then 7
				else 0 
			end ) +
			(case when coalesce(mobile_nw_freq,0) >= 12 then 22
				when coalesce(mobile_nw_freq,0) < 12 and coalesce(mobile_nw_freq,0) >= 6 then 14
				when coalesce(mobile_nw_freq,0) < 6 and coalesce(mobile_nw_freq,0) >= 1 then 7
				else 0 
			end ) +
			(case when coalesce(purchase_freq,0) >= 8 then 22
				when coalesce(purchase_freq,0) < 8 and coalesce(purchase_freq,0) >= 5 then 14
				when coalesce(purchase_freq,0) < 5 and coalesce(purchase_freq,0) >= 1 then 7
				else 0 
			end ) +

			---- Credit History Data     Proposed score = 16% of Score =  136     Actual = 40 (5+10+15+0+10)
			(case when loan_from_other_banks = 'NA' then 0
				when loan_from_other_banks = 'yes' then 0
				when loan_from_other_banks = 'no' then 5 else 0
			end) +
			(case when outstanding_loan = 'NA' then 0
				when outstanding_loan = 'yes' then 0
				when outstanding_loan = 'no' then 10 else 0
			end) +
			(case when defaulted_previously = 'NA' then 0
				when defaulted_previously = 'yes' then 0
				when defaulted_previously = 'no' then 15 else 0
			end) +
			(case when payment_default_history = 'NA' then 0
				when payment_default_history like '> 90 days' then -10
				when payment_default_history like '%60 - 90 days%' then -5
				when payment_default_history like '%30 - 60 days%' then -3
				when payment_default_history like '>%1 - 30 days%' then -2
				when payment_default_history like '%none%' then 0
		end) +
		(case when (coalesce(outstanding_loan_balance, 0)) > (0.33*Average_salary*outstanding_loan_duration)  then 0
			  when (coalesce(outstanding_loan_balance, 0)) < (0.33*Average_salary*outstanding_loan_duration)  then 10
			  when (coalesce(outstanding_loan_balance, 0)) > (0.33*(lodgement-withdrawal)) then 0
			  when (coalesce(outstanding_loan_balance, 0)) < (0.33*(lodgement-withdrawal))  then 10
		end) 

		--- Socio-Economic Data    Proposed score = 4% of Score =  34     Actual = 
		-- +
	))AS Credit_Score
FROM [DEMO].[dbo].[Demo_Credit_Application] cdt ---- Perform verification at this point 
--join with the Demography Table
left outer join [DEMO].[dbo].DEMO_Demography bio
 on bio.CUSTID = cdt.CUSTID ---- use account ID
---- Join with Credit History Data
left outer join [DEMO].[dbo].[Demo_Credit_History] ch
 on bio.CUSTID = ch.CUSTID 
--join to transaction table
left outer join --- join and compute total deposit transaction and transaction frequency for the passt 6 months from the transaction table
				(select custid, isnull(sum(txn.txn_amount),0) lodgement, isnull(count(txn.txn_amount), 0)lodgement_freq
				from [dbo].[Demo_Transactions_dup] txn
				where (FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy'))
				and txn.[Txn_Amount] is not null and txn.Txn_type =  'C' 
				group by custid, Txn_Type) ct
on cdt.CUSTID = ct.CUSTID
left outer join --- join and compute total withdrawal transaction and transaction frequency for the passt 6 months from the transaction table
				(select custid, isnull(sum(txn.txn_amount),0) withdrawal, isnull(count(txn.txn_amount), 0) withdrawal_freq
                from [dbo].[Demo_Transactions_dup] txn
				where (FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy'))
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  
				group by custid, Txn_Type) dt
on cdt.CUSTID = dt.CUSTID
--join and compute the Average salary amount for the 6 months period from the transaction table
left outer join (select custid ,(isnull(sum(txn_amount),0) / 6) Average_salary
                from [dbo].[Demo_Transactions_dup] txn
				where (FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy'))
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'C'  and  lower (Txn_Narration) like '%salary%'
				group by custid, Txn_Type) sal 
on cdt.CUSTID = sal.CUSTID
------ --join and compute the Average salary count for the 6 months period from the transaction table
left outer join (select custid ,(isnull(count(txn_amount),0) / 6) Average_salary_count
                from [dbo].[Demo_Transactions_dup] txn
				where (FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy'))
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'C'  and  lower (Txn_Narration) like '%salary%'
				group by custid, Txn_Type) sal_count
on cdt.CUSTID = sal_count.CUSTID
-- Utility spending from the transaction(transactions_dup) table
left outer join (select custid, isnull(sum(Txn_amount),0) utility_spending_amount ,isnull(count(txn_amount),0) utility_spending_freq --- , isnull(sum(Txn_amount),0)/isnull(count(txn_amount),0), isnull(sum(Txn_amount),0)/6
                from [dbo].[Demo_Transactions_dup] txn
				where (FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy'))
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  
				and (lower (Txn_Narration) like '%electricity%' 
							or lower (Txn_Narration) like '%dstv%' 
							or lower (Txn_Narration) like '%netflix%' 
							or lower (Txn_Narration) like '%waste%disposal%bill%' 
							or lower (Txn_Narration) like '%utility%')
				group by custid, Txn_Type) ut 
on cdt.CUSTID = ut.CUSTID
-- Transfers from the transaction (transactions_dup) table
left outer join (select custid, isnull(sum(Txn_amount),0) Transfers_amount ,isnull(count(txn_amount),0) Transfers_freq --- , isnull(sum(Txn_amount),0)/isnull(count(txn_amount),0), isnull(sum(Txn_amount),0)/6
                from [dbo].[Demo_Transactions_dup] txn
				where (FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy'))
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  and (lower (Txn_Narration) like '%transfer%' 
				or lower (Txn_Narration) like '%trf%')
				group by custid, Txn_Type) tr
on cdt.CUSTID = tr.CUSTID
-- Fees & Rent spending from the transaction table
left outer join (select custid, isnull(sum(Txn_amount),0) fees_amount ,isnull(count(txn_amount),0) fees_freq --- , isnull(sum(Txn_amount),0)/isnull(count(txn_amount),0), isnull(sum(Txn_amount),0)/6
                from [dbo].[Demo_Transactions_dup] txn
				where (FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy'))
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  and (lower (Txn_Narration) like '%fees%' 
				or lower (Txn_Narration) like '%rent%')
				group by custid, Txn_Type) fe
on cdt.CUSTID = fe.CUSTID
-- Purchases from the transaction table
left outer join (select custid, isnull(sum(Txn_amount),0)Purchase_amount ,isnull(count(txn_amount),0) purchase_freq --- , isnull(sum(Txn_amount),0)/isnull(count(txn_amount),0), isnull(sum(Txn_amount),0)/6
                from [dbo].[Demo_Transactions_dup] txn
				where (FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy'))
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  and (Txn_Narration = 'Shopping' 
							or lower (Txn_Narration) like '%online%purchases%' 
						--or lower (Txn_Narration) like '%pos%'
							or lower (Txn_Narration) like '%online%shopping%' 
							or lower (Txn_Narration) like '%betting%')
				group by custid, Txn_Type) pu 
on cdt.CUSTID = pu.CUSTID
-- Telco & Internet subscription from the transaction table
left outer join (select custid, isnull(sum(Txn_amount),0) mobile_nw_amount ,isnull(count(txn_amount),0) mobile_nw_freq --- , isnull(sum(Txn_amount),0)/isnull(count(txn_amount),0), isnull(sum(Txn_amount),0)/6
                from [dbo].[Demo_Transactions_dup] txn
				where (FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
				or FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy'))
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  
				and   (lower (Txn_Narration) like '%data%subscription%' 
					or lower (Txn_Narration) like '%airtime%purchase%'
					or lower (Txn_Narration) like '%ussd%')
				group by custid, Txn_Type) mn
on cdt.CUSTID = mn.CUSTID
--join and compute Total Credit transaction
left outer join (select custid, isnull(sum(txn.txn_amount),0) lodgement_all, isnull(count(txn_amount),0) lodgement_count_all --, isnull(sum(Txn_amount),0)/isnull(count(txn_amount),0), isnull(sum(Txn_amount),0)/6
                from [dbo].[Demo_Transactions_dup] txn
				-- where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
                where txn.[Txn_Amount] is not null and txn.Txn_type =  'C'  
				group by custid, Txn_Type) netc
on cdt.CUSTID = netc.CUSTID
--join and compute Total Debit transaction
left outer join (select custid, isnull(sum(txn.txn_amount),0) withdrawal_all, isnull(count(txn_amount),0) withdrawal_count_all --, isnull(sum(Txn_amount),0)/isnull(count(txn_amount),0), isnull(sum(Txn_amount),0)/6
                from [dbo].[Demo_Transactions_dup] txn
				-- where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
                where txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  
				group by custid, Txn_Type) netd
on cdt.CUSTID = netd.CUSTID
--join and compute Monthly transactions for MoM comparison
left outer join (select custid, isnull(sum(txn.txn_amount),0) inflow_value_1, isnull(count(txn.txn_amount), 0) inflow_vol_1	
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'C'  
				group by custid, Txn_Type) c0 
on cdt.CUSTID = c0.CUSTID
 left outer join (select custid, isnull(sum(txn.txn_amount),0) outflow_value_1, isnull(count(txn.txn_amount), 0) outflow_vol_1
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  
				group by custid, Txn_Type) d0
on cdt.CUSTID = d0.CUSTID
left outer join (select custid, isnull(sum(txn.txn_amount),0) inflow_value_2, isnull(count(txn.txn_amount), 0) inflow_vol_2
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'C'  
				group by custid, Txn_Type) c1
on cdt.CUSTID = c1.CUSTID
 left outer join (select custid, isnull(sum(txn.txn_amount),0) outflow_value_2, isnull(count(txn.txn_amount), 0) outflow_vol_2
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  
				group by custid, Txn_Type) d1
on cdt.CUSTID = d1.CUSTID
left outer join (select custid, isnull(sum(txn.txn_amount),0) inflow_value_3, isnull(count(txn.txn_amount), 0) inflow_vol_3
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'C'  
				group by custid, Txn_Type) c2
on cdt.CUSTID = c2.CUSTID
 left outer join (select custid, isnull(sum(txn.txn_amount),0) outflow_value_3, isnull(count(txn.txn_amount), 0) outflow_vol_3
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  
				group by custid, Txn_Type) d2
on cdt.CUSTID = d2.CUSTID
left outer join (select custid, isnull(sum(txn.txn_amount),0) inflow_value_4, isnull(count(txn.txn_amount), 0) inflow_vol_4
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'C'  
				group by custid, Txn_Type) c3
on cdt.CUSTID = c3.CUSTID
 left outer join (select custid, isnull(sum(txn.txn_amount),0) outflow_value_4, isnull(count(txn.txn_amount), 0) outflow_vol_4
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  
				group by custid, Txn_Type) d3
on cdt.CUSTID = d3.CUSTID
left outer join (select custid, isnull(sum(txn.txn_amount),0) inflow_value_5, isnull(count(txn.txn_amount), 0) inflow_vol_5
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'C'  
				group by custid, Txn_Type) c4
on cdt.CUSTID = c4.CUSTID
 left outer join (select custid, isnull(sum(txn.txn_amount),0) outflow_value_5, isnull(count(txn.txn_amount), 0) outflow_vol_5
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  
				group by custid, Txn_Type) d4
on cdt.CUSTID = d4.CUSTID
left outer join (select custid, isnull(sum(txn.txn_amount),0) inflow_value_6, isnull(count(txn.txn_amount), 0) inflow_vol_6
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'C'  
				group by custid, Txn_Type) c5
on cdt.CUSTID = c5.CUSTID
 left outer join (select custid, isnull(sum(txn.txn_amount),0) outflow_value_6, isnull(count(txn.txn_amount), 0) outflow_vol_6
                from [dbo].[Demo_Transactions_dup] txn
				where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null and txn.Txn_type =  'D'  
				group by custid, Txn_Type) d5
on cdt.CUSTID = d5.CUSTID
left outer join (select custid, isnull(count(txn.txn_amount), 0) txn_vol_M1
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
                group by custid) m1
on bio.CUSTID = m1.CUSTID
left outer join (select custid, isnull(count(txn.txn_amount), 0) txn_vol_M2
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
                group by custid) m2
on bio.CUSTID = m2.CUSTID
left outer join (select custid, isnull(count(txn.txn_amount), 0) txn_vol_M3
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
                group by custid) m3
on bio.CUSTID = m3.CUSTID
left outer join (select custid, isnull(count(txn.txn_amount), 0) txn_vol_M4
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
                group by custid) m4
on bio.CUSTID = m4.CUSTID
left outer join (select custid, isnull(count(txn.txn_amount), 0) txn_vol_M5
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
                group by custid) m5
on bio.CUSTID = m5.CUSTID
left outer join (select custid, isnull(count(txn.txn_amount), 0) txn_vol_M6
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
                group by custid) m6
on bio.CUSTID = m6.CUSTID
left outer join (select custid, max(txn.TxnDate) as Latest_TxnDate
				from [dbo].[Demo_Transactions_dup] txn
				group by CUSTID) m7
on bio.CUSTID = m7.CUSTID
--join and compute Monthly Transaction consistency
left outer join (select custid,	case when try_convert(int, isnull(count(txn.txn_amount), 0)) > 0 then 1 else 0 end txn_consistency_1
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -1,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
				group by custid) r1
on bio.CUSTID = r1.CUSTID
left outer join (select custid,	case when try_convert(int, isnull(count(txn.txn_amount), 0)) > 0 then 1 else 0 end txn_consistency_2
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -2,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
				group by custid) r2
on bio.CUSTID = r2.CUSTID
left outer join (select custid,	case when try_convert(int, isnull(count(txn.txn_amount), 0)) > 0 then 1 else 0 end txn_consistency_3
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -3,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
				group by custid) r3
on bio.CUSTID = r3.CUSTID
left outer join (select custid,	case when try_convert(int, isnull(count(txn.txn_amount), 0)) > 0 then 1 else 0 end txn_consistency_4
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -4,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
				group by custid) r4
on bio.CUSTID = r4.CUSTID
left outer join (select custid,	case when try_convert(int, isnull(count(txn.txn_amount), 0)) > 0 then 1 else 0 end txn_consistency_5
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -5,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
				group by custid) r5
on bio.CUSTID = r5.CUSTID
left outer join (select custid,	case when try_convert(int, isnull(count(txn.txn_amount), 0)) > 0 then 1 else 0 end txn_consistency_6
                from [dbo].[Demo_Transactions_dup] txn
                where FORMAT (txn.[TxnDate], 'MM-yyyy') = FORMAT (dateadd(month, -6,getdate()), 'MM-yyyy')
                and txn.[Txn_Amount] is not null
				group by custid) r6
on bio.CUSTID = r6.CUSTID
) AS csc;
--order by Credit_Score desc


