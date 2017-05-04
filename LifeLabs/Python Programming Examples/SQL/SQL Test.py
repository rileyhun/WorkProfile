import sqlite3

createDb = sqlite3.connect('tutorial.db')
queryCurs = createDb.cursor()

def createTable():
    queryCurs.execute('''CREATE TABLE customers
    (id INTEGER PRIMARY KEY, name TEXT, street TEXT, city TEXT, state TEXT, balance REAL)''')

def addCust(name, street, city, state, balance):
    queryCurs.execute('''INSERT INTO customers (name, street, city, state, balance)
    VALUES (?, ?, ?, ?, ?)''', (name, street, city, state, balance))

def main():
    # createTable()

    addCust("Derek Banas", "5708 Highway Ave", "Verona", "PA", 150.76)
    addCust("Monty Davis", "1709 First St", "Irwin", "PA", 350.60)
    addCust("Paul Smith", "810 Center Ave", "East Liberty", "PA", 0.00)
    addCust("Sue Smith", "712 Third St", "Garfield", "PA", 50.90)

    createDb.commit()

    queryCurs.execute('SELECT * FROM customers ORDER BY balance DESC LIMIT 2')

    listTitle = ['ID Num ', 'Name ', 'Street ', 'City ', 'State ', 'Balance ']
    k = 0

    for i in queryCurs:
        print("\n")
        for j in i:
            print(listTitle[k], end=" ")
            print(j)
            if k < 5: k+=1
            else: k = 0

    queryCurs.close()
#if __name__ == '__main__': main()
