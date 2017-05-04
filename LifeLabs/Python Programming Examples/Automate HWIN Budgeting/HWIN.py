import requests
import pandas as pd
import datetime
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup
import numpy as np
import re

# Calculate Monthly Average Values for each Generator and organize into spreadsheet
def Report(data):
    data = data[(data['Transaction Type'].str.contains("Registration")==False) & (data['Transaction Type'] != 'Prepaid')]
    data.Date = pd.to_datetime(data.Date)
    data['Amount'] = data['Amount'].astype(str)
    data['Amount'] = data['Amount'].str.lstrip('$')
    data['Amount'] = data['Amount'].astype(float)
    data = data[['GeneratorID', 'Date', 'Amount']]
    grouped = data.groupby('GeneratorID')
    result = grouped.apply(lambda x: x.set_index('Date').resample('M', how=np.sum))
    result.fillna(0, inplace=True)
    result.reset_index(inplace=True)
    result.set_index('Date', inplace=True)
    result = result.ix['2016-01-01':'2016-12-31']
    result = result.groupby('GeneratorID')['Amount'].mean()
    result.to_csv("HWIN LL.csv")

# read accounts information from spreadsheet
data = pd.read_csv("HWIN Accounts.csv")
data.dropna()

# Parameters to be called
url = 'https://www.hwin.ca/hwin/login.jsp'
USERNAME = data['Username']
PASSWORD = data['Password']
ID = data['Generator ID']
all_data = []
all_data2 = []
payment_data = []

# Find Outstanding Payments Due on Payment Tab
def find_payment(html):
    soup = BeautifulSoup(html)
    if soup.find(text="There is no pending manifest payment") is not None:
        payment_data.append(["$0", ID[i]])
    else:
        amount = soup.find('td', {'class': 'bodytext'}, width="35%")
        payment_data.append([amount.text.replace("Total amount due:", ""), ID[i]])
    return payment_data

# Find Account Status
def account_status(htmls):
    soup = BeautifulSoup(htmls)
    table = soup.find('table', border="0", cellpadding="2")
    table_body = table.find('tbody')
    rows = table_body.find_all('tr')
    account_data =[]
    for row in rows:
        cols = row.find_all('td')
        cols = [ele.text.strip() for ele in cols]
        account_data.append([ele for ele in cols if ele])
    return account_data

# Sign into HWIN looping through each individual account
browser = webdriver.Firefox()
browser.get(url)
for i in range(len(USERNAME)):
# Input Login information into form
    username = browser.find_element_by_name("userName")
    username.send_keys(USERNAME[i])
    password = browser.find_element_by_name("password")
    password.send_keys(PASSWORD[i])
    form = browser.find_element_by_name("imageField")
    form.submit()
# Navigate to Account Status Tab
    browser.find_element_by_link_text("Account status").click()
# Extract Account Status Tab
    htmls = browser.page_source
    account_data = account_status(htmls)
    df = pd.DataFrame(account_data, columns=["Date", "Transaction Type", "Manifest No.", "Date Shipped", "Payment Type",
                                             "Amount", "Prepaid Balance"]).ix[1:]
    df['GeneratorID']= ID[i]
    all_data.append(df)
    concatenated = pd.concat(all_data)
# Navigate to Payments Tab
    browser.find_element_by_name("payments").click()
# Extract Payment data
    html = browser.page_source
    payment_data = find_payment(html)
    df2 = pd.DataFrame(payment_data, columns=["Payment Due?", "Generator ID"])
# Close Browser
    browser.get(url)

# export Payment Data and Account Transactions Data into csv files
browser.quit()
df2.to_csv("Payment Due.csv", index=False)
concatenated = concatenated.reset_index(drop=True)
concatenated = concatenated[(concatenated['Date'].str.contains("/")==True)]
concatenated.to_csv("Account Status.csv", index=False)
Report(concatenated)




# with requests.Session() as c:
#     url = 'https://www.hwin.ca/hwin/login.jsp'
#     USERNAME = 'jac17215'
#     PASSWORD = 'cml'
#     c.get(url)
#     login_data = dict(userName=USERNAME, password=PASSWORD, imageField="Login")
#     c.post(url, data=login_data, headers={"Referer": "https:/www.hwin.ca/"})
#     page = c.get('https://www.hwin.ca/hwin/generator/generatorhome.jsp')
#     print(page.content)

