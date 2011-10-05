import os
import urllib2
import csv
import re

##### Convert a name to a variable name

def cleanName(name):
    return re.sub('[\W_]+', '', name.replace('&','And'))

##### Load the categories endpoint

file = urllib2.urlopen('http://wiki.developer.factual.com/f/Categories.csv')
r = csv.reader(file)

##### Form the list

cats = []

for entry in r:
    this_cat = entry[0].split(' > ').pop()
    try:
        cats.index(this_cat)
    except:
        cats.append(this_cat)

##### Generate the file

output = ''

output += '\n#pragma mark Factual Categories (Places >= 1.2)\n\n'
for cat in cats:
    output += '#define FactualCategory' + cleanName(cat) + ' @\"' + cat + '\"\n'

##### Write file

output = '\
//\n\
//  FactualCategories.h\n\
//  SimpleGeo.framework\n\
//\n\
//  Copyright (c) 2010, SimpleGeo Inc.\n\
//  All rights reserved.\n\
//\n\
// Redistribution and use in source and binary forms, with or without\n\
// modification, are permitted provided that the following conditions are met:\n\
//     * Redistributions of source code must retain the above copyright\n\
//       notice, this list of conditions and the following disclaimer.\n\
//     * Redistributions in binary form must reproduce the above copyright\n\
//       notice, this list of conditions and the following disclaimer in the\n\
//       documentation and/or other materials provided with the distribution.\n\
//     * Neither the name of the <organization> nor the\n\
//       names of its contributors may be used to endorse or promote products\n\
//       derived from this software without specific prior written permission.\n\
//\n\
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND\n\
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED\n\
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE\n\
// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY\n\
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES\n\
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;\n\
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND\n\
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT\n\
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS\n\
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n\
//\n\n' + output

script_path = os.path.realpath(__file__)
base_path = script_path.split('Scripts')[0]
output_path = base_path + 'Project/Shared/Classes/Client/Params/FactualCategories.h'

outputFile = open(output_path,'w+')
outputFile.write(output)
outputFile.close()
