# Contact Data Cleanup for Bulk SMS and Email Marketing

## Overview
This repository contains an R script designed to clean and prepare contact data for bulk SMS and email marketing campaigns. The script performs data cleaning, carrier classification, opt-out verification, and prepares data files for easy upload to marketing platforms.

## Features
- **Data Cleaning**:
  - Combines data from multiple sources.
  - Removes duplicates and rows with missing contact details.
  - Standardizes phone numbers to ensure uniformity.
- **Carrier Classification**:
  - Separates contacts into Airtel and Safaricom carriers for cost optimization in bulk SMS campaigns.
- **Opt-Out Compliance**:
  - Ensures a specific customer's number is excluded to comply with opt-out requests.
- **Data Preparation**:
  - Creates separate files for bulk SMS and email marketing.
  - Saves cleaned and categorized data into CSV files.
- **Automation Ready**:
  - Prepares data for seamless upload to bulk SMS and email marketing platforms.

## Prerequisites
- **R Version**: R version 4.0 or higher
- **Required Packages**: 
  - `dplyr` for data manipulation
  - `readr` for reading and writing files
  - `stringr` for string operations

## Usage Instructions

### Data Collection:
- Ensure all raw data files (e.g., `source1.csv`, `source2.csv`, `source3.csv`) are in the working directory or specify their file paths in the script.

### Run the Script:
1. Open the script in RStudio or your preferred R environment.
2. Execute the script to process the data.

### Verify Output:
The script generates the following output files:
- **`bulk_sms.csv`**: Cleaned contacts categorized for Safaricom bulk SMS campaigns.
- **`bulk_sms_airtel.csv`**: Cleaned contacts categorized for Airtel bulk SMS campaigns.
- **`email_list.csv`**: Cleaned contact list for email marketing.

### Upload Files:
- Upload `bulk_sms.csv` and `bulk_sms_airtel.csv` to your bulk SMS platform.
- Upload `email_list.csv` to your email marketing platform.

### Send Campaigns:
- Use the respective platforms to send out marketing campaigns.

---

## Important Notes
- Ensure raw data files are formatted with consistent headers for contact details.
- Double-check the opt-out verification to maintain customer preferences.
- Modify the script as needed to accommodate additional data sources or new requirements.

---

## Script Description

### The script performs the following steps:

#### Load Raw Data:
- Reads contact data from multiple CSV files.
- Standardizes column names and data types.

#### Data Cleaning:
- Removes duplicates and rows with missing contact details.
- Standardizes phone numbers to a uniform format.

#### Carrier Classification:
- Categorizes numbers based on prefixes to separate Safaricom and Airtel contacts.

#### Opt-Out Verification:
- Ensures specified numbers are excluded from the dataset.

#### Data Preparation:
- Creates separate files for bulk SMS (Safaricom and Airtel) and email marketing.

#### Save Files:
- Saves the cleaned and categorized data into CSV files for further use.
