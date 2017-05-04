import pandas as pd
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup
from selenium.webdriver.support.ui import WebDriverWait


# read accounts information from spreadsheet
data = pd.read_csv("HWIN Accounts.csv")
data.dropna()

# Parameters to be called
url = 'https://www.hwin.ca/hwin/index.jsp'
USERNAME = data['Username']
PASSWORD = data['Password']
ID = data['Generator ID']
all_data = []

# Find Outstanding Payments Due on Payment Tab
def find_address(html):
    soup = BeautifulSoup(html)
    information = soup.findAll("span", {'class': 'body10'})
    elements = [ele.text.replace('\xa0', '') for ele in information]
    return elements

# Sign into HWIN looping through each individual account
browser = webdriver.Firefox()
for i in range(len(USERNAME)):
    browser.get(url)
# Input Login information into form
    username = browser.find_element_by_name("userName")
    username.send_keys(USERNAME[i])
    password = browser.find_element_by_name("password")
    password.send_keys(PASSWORD[i])
    form = browser.find_element_by_name("btnLogin")
    form.click()
# Extract Account Status Tab
    html = browser.page_source
    address = find_address(html)
    all_data.append(address)
# Close Browser
browser.close()
df = pd.DataFrame(all_data)
df.to_csv("HWIN_address.csv", index=False)
