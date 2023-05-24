library(tidyverse)
library(googlesheets4)

# -------------------------------------------------------------------------

# get current LSS data for MBRs
in_wbook <- 'https://docs.google.com/spreadsheets/d/1SIFJPCA8duV7qFnq6u1eq8o8tHEXMMFGCVa4Ea6nCWc/edit#gid=482107966'
in_sheet <- 'Member List (1)'

print(paste0(' ... Reading ', in_sheet))
df_in <- googlesheets4::read_sheet(in_wbook, sheet = in_sheet)

# -------------------------------------------------------------------------
# send to reference data V1

# reformat as required
df_out <- df_in %>% 
  select(member_id = Membership_Number__c,
         ref.lss.fullname = Name,
         ref.lss.shortname = Short_Name__c) %>% 
  mutate(member_aws = str_replace(member_id, '/',''), .after='member_id') %>% 
  select(member_aws, ref.lss.fullname, ref.lss.shortname) %>% 
  identity()

# Reference Data - Calls dataset - 2023-05-24 onwards
out_wbook <- 'https://docs.google.com/spreadsheets/d/1jmzZXW3gKeG_e3l_x2ECMQ1sE84AeSj8UiAlknU5-us/edit#gid=222075267'
out_sheet <- 'reference_mbr'
print(paste0(' ... Writing to ', out_sheet, ' ',nrow(df_out),' records'))

googlesheets4::write_sheet(df_out, out_wbook, out_sheet)

# -------------------------------------------------------------------------
# send to reference data V2

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

# Reporting Reference Data Updates - running workbook
out_wbook <- 'https://docs.google.com/spreadsheets/d/1FEcmgQmYk_Dmf9IgjM1CdYjSFTMQzHB2DyiMpzpbCas/edit#gid=405822670'
out_sheet <- 'reference_mbr'
print(paste0(' ... Writing to ', out_sheet, ' ',nrow(df_out),' records'))

googlesheets4::write_sheet(df_out, out_wbook, out_sheet)

# -------------------------------------------------------------------------
print(' ... Finished !')

