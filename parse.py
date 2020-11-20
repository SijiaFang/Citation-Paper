import json
import os
import argparse

if os.path.exists("Paper.txt"):
    os.remove("Paper.txt")
if os.path.exists("Author.txt"):
    os.remove("Author.txt")
if os.path.exists("Field.txt"):
    os.remove("Field.txt")
if os.path.exists("Citation.txt"):
    os.remove("Citation.txt")

Paper = open("Paper.txt","a")
Author = open("Author.txt","a")
Field = open('Field.txt',"a")
Cite = open('Citation.txt',"a")
Paper.write('Id'+'|'+'Year'+'|'+'Journal'+'|'+'Title'+'|'+'Abstract'+'\n')
Author.write('PaperID'+'|'+'AuthorID'+'|'+'AuthorName'+'\n')
Field.write('PaperID'+'|'+'field'+'\n')
Cite.write('PaperID'+'|'+'title'+'|'+'InCiteId'+'\n')

for i in range(187):
    file_id = '%03d' % i
    file_path = 'processed-s2-corpus-' + file_id + '.json'

    CMD1='mv '+file_path+' '+'processed-s2-corpus-' + file_id + '.txt'
    os.system(CMD1)

    with open('processed-s2-corpus-' + file_id + '.txt',) as txt_file:
        hehe = txt_file.readlines()
    f = open('new-processed' + file_id + '.txt','a')
    print('[',file=f)
    for i in range(len(hehe)-1):
        if hehe[i]== '}\n':
            print('  '+'},',file=f)
        else:
            print('  '+hehe[i][0:-1],file=f)
    print('  }',file=f)
    print(']',file=f)
    f.close()

    CMD2='mv '+'new-processed' + file_id + '.txt'+' '+'new-processed' + file_id + '.json'
    os.system(CMD2)


    with open('new-processed' + file_id + '.json','r') as json_file:
        data = json.load(json_file)
        for item in data:
            id = item['id']
            year = item['year']
            journal = item['journalName']
            title = item['title']
            abstract = item['paperAbstract']
            # list
            field = item['fieldsOfStudy']
            authors = item['authors']
            inCitations = item['inCitations']
            Paper.write(id+'|'+str(year)+'|'+journal+'|'+title+'|'+abstract+'\n')
            # field    
            for f in field:
                Field.write(id+'|'+f+'\n')
            # author
            for author in authors:
                try:
                    AuthorId = author['ids'][0]
                except:
                    AuthorId = ''
                Author.write(id+'|'+AuthorId+'|'+author['name']+'\n')
            # citation
            for cite in inCitations:
                Cite.write(id+'|'+title+'|'+cite+'\n')
    print(file_id+' is done.')

Field.close()
Author.close()
Cite.close()
Paper.close()
    
    


