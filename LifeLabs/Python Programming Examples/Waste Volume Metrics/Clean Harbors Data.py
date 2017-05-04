import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import style
style.use('fivethirtyeight')

Cities = ["Barrie", "Belleville", "BRL", "IRL", "Kitchener", "London", "Ottawa", "Thorold"]

files = []
for v in Cities:
    files.append("Clean Harbors "+ v + ".csv")
print(files)

main_df = pd.DataFrame()
for i in files:
    df = pd.read_csv(i, index_col = 0)

    if main_df.empty:
        main_df = df
    else:
        main_df = main_df.append(df)

print(main_df.head())

main_df = main_df.groupby(main_df.index).sum()
main_df.index = pd.to_datetime(main_df.index)
main_df = main_df.sort_index()
main_df = main_df.fillna(0)
main_df.to_csv('Clean Harbors Consolidated.csv')
main_df.index.name = 'Date'

main_df.plot(colormap='jet', title = 'Waste Volume by LifeLabs Location')
plt.ylabel('Volume (L)')
plt.legend(loc = 'center left', bbox_to_anchor=(1.0, 0.5))
plt.subplots_adjust(right =0.8)
plt.show()


