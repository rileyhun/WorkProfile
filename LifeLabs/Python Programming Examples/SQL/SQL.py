import sqlite3
import pandas as pd
conn = sqlite3.connect('example.db')

c = conn.cursor()

# import csv file to sql database as Table
def csvtosql(file, title):
    if '.csv' in file:
        df = pd.read_csv(file)
        df.to_sql(title, conn, index=False)

# creating a custom table
def create_table():
    c.execute('''CREATE TABLE NewTraining
            (id INTEGER PRIMARY KEY, FirstName TEXT, LastName TEXT, ManagerName TEXT, Score REAL, Location TEXT)''')

# Insert a row of data into custom table
def new_row(FirstName, LastName, ManagerName, Score, Location):
    c.execute('''INSERT INTO Training (FirstName, LastName, ManagerName, Score, Location)
    VALUES (?, ?, ?, ?, ?)''', (FirstName, LastName, ManagerName, Score, Location))

# Print SQL Query
def output_sql():
    c.execute(""" SELECT * FROM Training LIMIT 10 """)
    output = c.fetchall()
    print(pd.DataFrame(output))

# Drop Table
def drop_table(name):
    c.execute("DROP table IF EXISTS %s" % name)


# Example of fetching one row
# t = ('RHAT',)
# c.execute('SELECT * FROM stocks WHERE symbol=?', t)
# print(c.fetchone())

# Larger example of fetching list of matching rows
# purchases = [('2006-03-28', 'BUY', 'IBM', 1000, 45.00),
#              ('2006-04-05', 'BUY', 'MSFT', 1000, 72.00),
#              ('2006-04-06', 'SELL', 'IBM', 500, 53.00),
#              ('2016-05-10', 'BUY','APPL', 1800, 100.00),
#              ('2016-04-08', 'SELL', 'SONY', 600, 58.00),
#              ('2015-08-08', 'SELL', 'NINT', 800, 80.00),
#              ('2015-04-04', 'BUY', 'MSFT', 700, 35.00),
#              ('2015-09-12', 'SELL', 'SMSG', 500, 55.00),
#              ('2015-04-09', 'BUY', 'TOSH', 200, 37.00)
#              ]
# c.executemany('INSERT INTO stocks(date, trans, symbol, qty, price) VALUES (?, ?, ?, ?, ?)', purchases)

# c.execute("UPDATE stocks SET date='2010-01-01' WHERE id=1")

# for row in c.execute("SELECT * FROM Training WHERE FirstName LIKE '%Bob%'"):
#     print(row)

# Save (commit) the changes
conn.commit()

# Close connection
conn.close()