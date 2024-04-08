import csv
import pandas as pd

#information about csv header and row size
with open('bottom.csv') as csv_file:

    csv_reader = csv.reader(csv_file, delimiter = ',')
    list_of_column_names = []

    for row in csv_reader:
        list_of_column_names.append(row)
        break

    #printing the first number of rows
    rows = 701
    #print(list_of_column_names[0])
    for i, row in enumerate(csv_reader):
        print(row)
        if(i >= rows-1):
            break

#counts row (does not include header)
    numline = len(csv_file.readlines())
    print("Total rows = ", f"{numline:,}")

print("Splitting csv file")

df = pd.read_csv('bottom.csv')
range_size = 701
n = 0
for start in range(0, len(df), range_size):
    df_slice = df.iloc[start:start+range_size]
    df_slice.to_csv('sampler/t_{}.csv'.format(n), index=False)
    print('Progress: Written t_{}.csv'.format(n))
    n += 1
