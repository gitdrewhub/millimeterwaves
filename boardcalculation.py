import csv

s11 = []
s12 = []
s21 = []
s22 = []

s13 = []
s31 = []
s33 = []
s34 = []
s43 = []
s44 = []
with open('dutIM.csv') as dutIMdata:
    readCSV = csv.reader(dutIMdata, delimiter = ',')
    next(readCSV, None)
    for row in readCSV:
        s11.append(row[1])
        s12.append(row[2])
        s13.append(row[3])

        s21.append(row[7])
        s22.append(row[8])

        s31.append(row[13])
        s33.append(row[15])
        s34.append(row[16])
        s43.append(row[21])
        s44.append(row[22])

print(s44)