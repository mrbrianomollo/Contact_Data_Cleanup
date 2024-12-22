# This script collects, cleans, and prepares contact data for bulk SMS and email marketing platforms

# Load necessary libraries
library(dplyr)
library(readr)
library(stringr)

# Load the csv data files
source1 <- read_csv("source1.csv")
source2 <- read_csv("source2.csv")
source3 <- read_csv("source3.csv")

# Rename columns in `` for clarity and consistency
colnames(source1) <- c("First_name", "Last_name", "Primary_email", "Primary_phone", "Organization", "Tags", "Last_seen_on")

# Standardize column names in both data frames
source1 <- source1 %>%
  rename(
    first_name = First_name,
    last_name = Last_name,
    email_address = Primary_email,
    phone_number = Primary_phone
  ) %>%
  # Convert phone_number to character
  mutate(phone_number = as.character(phone_number)) %>%
  # Remove the unnecessary columns from `source1`
  select(-Organization, -Tags, -Last_seen_on)

source2 <- source2 %>%
  rename(
    first_name = firstname,
    last_name = lastname,
    email_address = email,
    phone_number = telephone
  ) %>%
  # Convert phone_number to character
  mutate(phone_number = as.character(phone_number))

source3 <- source3 %>%
  rename(
    first_name = first_name,
    last_name = last_name,
    email_address = email_address,
    phone_number = phone_number
  ) %>%
  # Convert phone_number to character
  mutate(phone_number = as.character(phone_number))

# Combine the 3 data frames by rows
combined_data <- bind_rows(source2, source1, source3)

# Remove rows where both email_address and phone_number are missing
cleaned_data <- combined_data %>%
  filter(!(is.na(email_address) & is.na(phone_number)))

# Standardize phone numbers to +############ and replace invalid formats with NA
cleaned_data <- cleaned_data %>%
  mutate(phone_number = case_when(
    # 10 digits starting with 07 or 01 (e.g., 07XXXXXXXX, 01XXXXXXXX) -> replace first digit with +254
    grepl("^(07|01)\\d{8}$", phone_number) ~ paste0("+254", substr(phone_number, 2, 10)),
    
    # 12 digits with + prefix (+############) -> keep as is
    grepl("^\\+\\d{12}$", phone_number) ~ phone_number,
    
    # 12 digits without + prefix (############) -> add + prefix
    grepl("^\\d{12}$", phone_number) ~ paste0("+", phone_number),
    
    # 9 digits starting with 7 or 1 (e.g., 7XXXXXXXX, 1XXXXXXXX) -> add +254 prefix
    grepl("^(7|1)\\d{8}$", phone_number) ~ paste0("+254", phone_number),
    
    # If none of the patterns match, replace with NA
    TRUE ~ NA_character_
  ))


# View the standardized `cleaned_data`
print(cleaned_data)

# Remove duplicates based on phone_number and email_address columns
cleaned_data <- cleaned_data %>%
  distinct(phone_number, email_address, .keep_all = TRUE)

# Check if BigCustomerA Number exists in the data set
if (any(cleaned_data$phone_number %in% c("0722222222", "+254722222222"))) {
  print("The specified phone number(s) exist in the dataset.")
} else {
  print("The specified phone number(s) do not exist in the dataset.")
}

# Remove rows with BigCustomeA Number
cleaned_data <- cleaned_data %>%
  filter(!phone_number %in% c("0722222222", "+254722222222"))

# View the cleaned data
print(cleaned_data)

# Create `email_list` with columns `email`, `first_name`, and `last_name`
email_list <- cleaned_data %>%
  select(email = email_address, first_name, last_name) %>%
  # Remove rows where `email` is blank
  filter(!is.na(email) & email != "") %>%
  # Remove duplicate emails
  distinct(email, .keep_all = TRUE)


# Create `bulk_sms` with numbers that match the specified prefixes
bulk_sms <- cleaned_data %>%
  # Select `phone_number`, `first_name`, and `last_name`
  select(phone_number, first_name, last_name) %>%
  # Filter to keep only numbers that match the specified +254 prefixes
  filter(str_detect(phone_number, "^\\+254(70|71|72|740|741|742|743|745|746|748|757|758|759|768|769|79|112|113|114|115)")) %>%
  # Remove duplicate phone numbers
  distinct(phone_number, .keep_all = TRUE) %>%
  # Combine `first_name` and `last_name` to create `name` column
  mutate(name = paste(first_name, last_name)) %>%
  # Select only `phone_number` and `name` columns for final output
  select(phone_number, name)

# Create `bulk_sms_airtel` for numbers that don't match the specified prefixes
bulk_sms_airtel <- cleaned_data %>%
  # Select `phone_number`, `first_name`, and `last_name`
  select(phone_number, first_name, last_name) %>%
  # Filter to keep only numbers that don't match the specified +254 prefixes
  filter(!str_detect(phone_number, "^\\+254(70|71|72|740|741|742|743|745|746|748|757|758|759|768|769|79|112|113|114|115)")) %>%
  # Remove duplicate phone numbers
  distinct(phone_number, .keep_all = TRUE) %>%
  # Combine `first_name` and `last_name` to create `name` column
  mutate(name = paste(first_name, last_name)) %>%
  # Select only `phone_number` and `name` columns for final output
  select(phone_number, name)

# View the filtered `bulk_sms` and `bulk_sms_airtel`
print(bulk_sms)
print(bulk_sms_airtel)

# Save to CSV files if needed
write_csv(bulk_sms, "bulk_sms.csv")
write_csv(bulk_sms_airtel, "bulk_sms_airtel.csv")
write_csv(email_list, "email_list.csv")

