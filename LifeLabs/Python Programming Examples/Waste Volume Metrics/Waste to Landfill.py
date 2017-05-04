import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import style
style.use('fivethirtyeight')

Belleville_Data = pd.read_csv('Belleville Progressive Waste.csv', index_col = 4)
BRL_Data = pd.read_csv('BRL Progressive Waste.csv', index_col = 4)
IRL_Data = pd.read_csv('IRL Progressive Waste.csv', index_col = 4)
St_Catharines_Data = pd.read_csv('St Catharine Progressive Waste.csv', index_col = 4)

Belleville_Data['Total'] = Belleville_Data.sum(axis=1)
Belleville_Data['Total Recycling'] = Belleville_Data['Cardboard Recycling']+Belleville_Data['Mixed Recycling']+Belleville_Data['Organics/Compost']
Belleville_Data['Waste to Landfill'] = Belleville_Data['Compacted Waste']
Belleville_Data['% Recycling'] = Belleville_Data['Total Recycling']/Belleville_Data['Total']
Belleville_Data['% Waste to Landfill'] = Belleville_Data['Waste to Landfill']/Belleville_Data['Total']
Belleville_Data['% Hazardous Waste'] = Belleville_Data['Biohazardous Waste']/Belleville_Data['Total']
Belleville_Data = Belleville_Data.tail(14)
Belleville_Data.to_csv("Belleville_Test.csv")

BRL_Data['Total'] = BRL_Data.sum(axis=1)
BRL_Data['Total Recycling'] = BRL_Data['Cardboard Recycling']+BRL_Data['Mixed Recycling']+BRL_Data['Organics/Compost']
BRL_Data['Waste to Landfill'] = BRL_Data['Compacted Waste']
BRL_Data['% Recycling'] = BRL_Data['Total Recycling']/BRL_Data['Total']
BRL_Data['% Waste to Landfill'] = BRL_Data['Waste to Landfill']/BRL_Data['Total']
BRL_Data['% Hazardous Waste'] = BRL_Data['Biohazardous Waste']/BRL_Data['Total']
BRL_Data = BRL_Data.tail(14)
BRL_Data.to_csv("BRL_Test.csv")

IRL_Data['Total'] = IRL_Data.sum(axis=1)
IRL_Data['Total Recycling'] = IRL_Data['Cardboard Recycling']+IRL_Data['Mixed Recycling']+IRL_Data['Organics/Compost']
IRL_Data['Waste to Landfill'] = IRL_Data['Compacted Waste']
IRL_Data['% Recycling'] = IRL_Data['Total Recycling']/IRL_Data['Total']
IRL_Data['% Waste to Landfill'] = IRL_Data['Waste to Landfill']/IRL_Data['Total']
IRL_Data['% Hazardous Waste'] = IRL_Data['Biohazardous Waste']/IRL_Data['Total']
IRL_Data = IRL_Data.tail(14)
IRL_Data.to_csv("IRL_Test.csv")

St_Catharines_Data['Total'] = St_Catharines_Data.sum(axis=1)
St_Catharines_Data['Total Recycling'] = St_Catharines_Data['Cardboard Recycling']+St_Catharines_Data['Mixed Recycling']+St_Catharines_Data['Organics/Compost']
St_Catharines_Data['Waste to Landfill'] = St_Catharines_Data['Compacted Waste']
St_Catharines_Data['% Recycling'] = St_Catharines_Data['Total Recycling']/St_Catharines_Data['Total']
St_Catharines_Data['% Waste to Landfill'] = St_Catharines_Data['Waste to Landfill']/St_Catharines_Data['Total']
St_Catharines_Data['% Hazardous Waste'] = St_Catharines_Data['Biohazardous Waste']/St_Catharines_Data['Total']
St_Catharines_Data = St_Catharines_Data.tail(14)
St_Catharines_Data.to_csv("St_Catharines_Test.csv")

fig = plt.figure()
ax1 = plt.subplot2grid((1,1), (0,0))
BRL_Data[['% Recycling', '% Waste to Landfill', '% Hazardous Waste']].plot(colormap='jet', title = 'BRL Waste Diversion', ax=ax1)
vals = ax1.get_yticks()
ax1.set_yticklabels(['{:2.0f}%'.format(x*100) for x in vals])
ax1.legend(loc = 'upper right', prop={'size':8.5})
plt.xlabel("Month")
labels = ax1.get_xticklabels()
plt.setp(labels, rotation=30, fontsize=10)

plt.show()