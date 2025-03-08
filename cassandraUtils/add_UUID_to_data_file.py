import sys
from optparse import OptionParser


parser = OptionParser()

parser.add_option("-f", "--fin", dest="fileIn", action="store", type="string")

(options, args) = parser.parse_args()

# read in.csv adding one column for UUID

import csv
import uuid
fileName = options.fileIn
fin = open(fileName, 'r')
fout = open("uuid"+fileName, 'w')

reader = csv.reader(fin, delimiter=',', quotechar='"')
writer = csv.writer(fout, delimiter=',', quotechar='"')

firstrow = True
for row in reader:
    row.append(uuid.uuid4())
    writer.writerow(row)


