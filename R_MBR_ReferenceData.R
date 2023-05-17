library(tidyverse)
library(googlesheets4)

# -------------------------------------------------------------------------

# get current data
in_wbook <- 'https://docs.google.com/spreadsheets/d/1SIFJPCA8duV7qFnq6u1eq8o8tHEXMMFGCVa4Ea6nCWc/edit#gid=482107966'
in_sheet <- 'Member List (1)'

print(paste0(' ... Reading ', in_sheet))
df_in <- googlesheets4::read_sheet(in_wbook, sheet = in_sheet)

# -------------------------------------------------------------------------

# reformat as required
df_out <- df_in %>% 
  mutate(member_date_start = as.character(Start_Date__c)) %>% 
  mutate(member_date_end = as.character(End_Date__c)) %>% 
  select(member_id = Membership_Number__c,
         member_name = Name,
         member_short = Short_Name__c,
         member_date_start,
         member_date_end) %>% 
  mutate(member_aws = str_replace(member_id, '/',''), .after='member_id') %>% 
  mutate(upload_date = Sys.Date()) %>% 
  identity()

# -------------------------------------------------------------------------

out_wbook <- 'https://docs.google.com/spreadsheets/d/1FEcmgQmYk_Dmf9IgjM1CdYjSFTMQzHB2DyiMpzpbCas/edit#gid=405822670'
out_sheet <- 'reference_mbr'
print(paste0(' ... Writing to ', out_sheet, ' ',nrow(df_out),' records'))

googlesheets4::write_sheet(df_out, out_wbook, out_sheet)


# -------------------------------------------------------------------------
print(' ... Finished !')

