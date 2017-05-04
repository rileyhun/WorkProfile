import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import style
style.use('fivethirtyeight')

Belleville_Data = pd.read_csv('Belleville Progressive Waste.csv', index_col = 4)
BRL_Data = pd.read_csv('BRL Progressive Waste.csv', index_col = 4)
IRL_Data = pd.read_csv('IRL Progressive Waste.csv', index_col = 4)
St_Catharines_Data = pd.read_csv('St Catharine Progressive Waste.csv', index_col = 4)

Belleville_Data = Belleville_Data[['Location', 'Compacted Waste', 'Cardboard Recycling', 'Mixed Recycling',
'Organics/Compost', 'Biohazardous Waste']]
Belleville_Data.dropna(axis=1, how='all', inplace=True)
Belleville_Data['Compacted Waste'].fillna(Belleville_Data['Compacted Waste'].mean(), inplace=True)
Belleville_Data['Biohazardous Waste'].fillna(Belleville_Data['Biohazardous Waste'].mean(), inplace=True)
Belleville_Data['Compacted Waste Rolling Average'] = pd.rolling_mean(Belleville_Data['Compacted Waste'], 6)
Belleville_Data['Biohazardous Waste Rolling Average'] = pd.rolling_mean(Belleville_Data['Biohazardous Waste'], 6)


BRL_Data = BRL_Data[['Location', 'Compacted Waste', 'Cardboard Recycling', 'Mixed Recycling',
'Organics/Compost', 'Biohazardous Waste']]
BRL_Data.dropna(axis=1, how='all', inplace=True)
BRL_Data['Mixed Recycling'].fillna(BRL_Data['Mixed Recycling'].mean(), inplace=True)
BRL_Data['Organics/Compost'].fillna(BRL_Data['Organics/Compost'].mean(), inplace=True)
BRL_Data['Mixed Recycling Rolling Average'] = pd.rolling_mean(BRL_Data['Mixed Recycling'], 6)
BRL_Data['Organics/Compost Rolling Average'] = pd.rolling_mean(BRL_Data['Organics/Compost'], 6)
BRL_Data['Cardboard Rolling Average'] = pd.rolling_mean(BRL_Data['Cardboard Recycling'], 6)
BRL_Data['Biohazardous Rolling Average'] = pd.rolling_mean(BRL_Data['Biohazardous Waste'], 6)
BRL_Data = BRL_Data.ix[6:]

St_Catharines_Data = St_Catharines_Data[['Location', 'Compacted Waste', 'Cardboard Recycling', 'Mixed Recycling',
'Organics/Compost', 'Biohazardous Waste']]
St_Catharines_Data.dropna(axis=1, how='all', inplace=True)
St_Catharines_Data['Compacted Waste'].fillna(St_Catharines_Data['Compacted Waste'].mean(), inplace=True)
St_Catharines_Data['Cardboard Recycling'].fillna(St_Catharines_Data['Cardboard Recycling'].mean(), inplace=True)
St_Catharines_Data['Mixed Recycling'].fillna(St_Catharines_Data['Mixed Recycling'].mean(), inplace=True)
St_Catharines_Data['Biohazardous Waste'].fillna(St_Catharines_Data['Biohazardous Waste'].mean(), inplace=True)
St_Catharines_Data['Mixed Recycling Rolling Average'] = pd.rolling_mean(St_Catharines_Data['Mixed Recycling'], 6)
St_Catharines_Data['Compacted Waste Rolling Average'] = pd.rolling_mean(St_Catharines_Data['Compacted Waste'], 6)
St_Catharines_Data['Cardboard Rolling Average'] = pd.rolling_mean(St_Catharines_Data['Cardboard Recycling'], 6)
St_Catharines_Data['Biohazardous Rolling Average'] = pd.rolling_mean(St_Catharines_Data['Biohazardous Waste'], 6)


IRL_Data = IRL_Data[['Location', 'Compacted Waste', 'Cardboard Recycling', 'Mixed Recycling',
'Organics/Compost', 'Biohazardous Waste']]
IRL_Data.dropna(axis=1, how='all', inplace=True)
IRL_Data['Compacted Waste'].fillna(IRL_Data['Compacted Waste'].mean(), inplace=True)
IRL_Data['Cardboard Recycling'].fillna(IRL_Data['Cardboard Recycling'].mean(), inplace=True)
IRL_Data['Mixed Recycling'].fillna(IRL_Data['Mixed Recycling'].mean(), inplace=True)
IRL_Data['Organics/Compost'].fillna(IRL_Data['Organics/Compost'].mean(), inplace=True)
IRL_Data['Biohazardous Waste'].fillna(IRL_Data['Biohazardous Waste'].mean(), inplace=True)
IRL_Data['Mixed Recycling Rolling Average'] = pd.rolling_mean(IRL_Data['Mixed Recycling'], 6)
IRL_Data['Compacted Waste Rolling Average'] = pd.rolling_mean(IRL_Data['Compacted Waste'], 6)
IRL_Data['Cardboard Rolling Average'] = pd.rolling_mean(IRL_Data['Cardboard Recycling'], 6)
IRL_Data['Organics/Compost Rolling Average'] = pd.rolling_mean(IRL_Data['Organics/Compost'], 6)
IRL_Data['Biohazardous Rolling Average'] = pd.rolling_mean(IRL_Data['Biohazardous Waste'], 6)

fig = plt.figure()
ax1 = plt.subplot2grid((2,2), (0,0))
ax2 = plt.subplot2grid((2,2), (1,0))
ax3 = plt.subplot2grid((2,2), (0,1))
ax4 = plt.subplot2grid((2,2), (1,1))



Belleville_Data[['Compacted Waste Rolling Average', 'Biohazardous Waste Rolling Average']].plot(colormap='winter', title = 'Belleville Waste Output', ax=ax1)
BRL_Data[['Mixed Recycling Rolling Average', 'Organics/Compost Rolling Average', 'Cardboard Rolling Average', 'Biohazardous Rolling Average']].plot(colormap='jet', title = 'BRL Waste Output', ax= ax2)
St_Catharines_Data[['Mixed Recycling Rolling Average', 'Compacted Waste Rolling Average', 'Cardboard Rolling Average', 'Biohazardous Rolling Average']].plot(colormap='jet', title = 'St Catharines Waste Output', ax=ax3)
IRL_Data[['Mixed Recycling Rolling Average', 'Compacted Waste Rolling Average', 'Cardboard Rolling Average', 'Organics/Compost Rolling Average', 'Biohazardous Rolling Average']].plot(colormap='copper', title = 'IRL Waste Output', ax=ax4)

ax1.legend().remove()
ax2.legend().remove()
ax3.legend().remove()
ax4.legend().remove()
ax1.legend(loc = 'upper right', prop={'size':7.5})
ax2.legend(loc = 'upper right', prop={'size':7.5})
ax3.legend(loc = 'upper right', prop={'size':7.5})
ax4.legend(loc = 'upper left', prop={'size':7.5})


ax1.set_xlabel('')
ax2.set_xlabel('')
ax3.set_xlabel('')
ax4.set_xlabel('')
ax1.set_ylabel('mass (kg)')
ax2.set_ylabel('mass (kg)')


labels1 = ax1.get_xticklabels()
labels2 = ax2.get_xticklabels()
labels3 = ax3.get_xticklabels()
labels4 = ax4.get_xticklabels()
plt.setp(labels1, rotation=30, fontsize=9)
plt.setp(labels2, rotation=30, fontsize=9)
plt.setp(labels3, rotation=30, fontsize=9)
plt.setp(labels4, rotation=30, fontsize=9)

plt.show()
