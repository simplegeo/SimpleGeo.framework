import urllib2
import json

def cleanName(name):
    return name.replace(' ','').replace('(','').replace(')','').replace(',','').replace('-','').replace('&','And')

file = urllib2.urlopen('http://api.simplegeo.com/1.0/features/categories.json')
contents = json.loads(file.read())

types = []
fcats = []
fsubcats = []
pcats = []
psubcats = []

for entry in contents:
    thisType = entry['type']
    thisCat = entry['category']
    thisSubcat = entry['subcategory']

    if thisType and thisType != '':
        try:
            types.index(thisType)
        except:
            types.append(thisType)

    cats = pcats
    subcats = psubcats
    if thisType == 'Region':
        cats = fcats
        subcats = fsubcats

    if thisCat and thisCat != '':
        try:
            cats.index(thisCat)
        except:
            cats.append(thisCat)

    if thisSubcat and thisSubcat != '':
        try:
            subcats.index(thisSubcat)
        except:
            subcats.append(thisSubcat)

output = 'typedef NSString * SGFeatureType;\n\
typedef NSString * SGFeatureCategory;\n\
typedef NSString * SGFeatureSubcategory;\n'

# feature types

output += '\n#pragma mark Feature Types\n\n'
for typ in types:
    output += '#define SGFeatureType' + cleanName(typ) + ' @\"' + typ + '\"\n'

# feature categories

output += '\n#pragma mark Feature Categories (Context)\n\n'
for cat in fcats:
    output += '#define SGFeatureCategory' + cleanName(cat) + ' @\"' + cat + '\"\n'

output += '\n#pragma mark Feature Subcategories (Context)\n\n'
for subcat in fsubcats:
    output += '#define SGFeatureSubcategory' + cleanName(subcat) + ' @\"' + subcat + '\"\n'

# places categories

output += '\n#pragma mark Feature Categories (Places)\n\n'
for cat in pcats:
    output += '#define SGPlaceCategory' + cleanName(cat) + ' @\"' + cat + '\"\n'

output += '\n#pragma mark Feature Subcategories (Places)\n\n'
for subcat in psubcats:
    output += '#define SGPlaceSubcategory' + cleanName(subcat) + ' @\"' + subcat + '\"\n'

# write file

output = '\
//\n\
//  SGCategories.h\n\
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

outputFile = open('../Classes/Client/Params/SGCategories.h','w+')
outputFile.write(output)
outputFile.close()
