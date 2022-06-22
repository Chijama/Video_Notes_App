import datetime
import os
file_path = r'C:\Users\HP\Videos\DEMO\How to Make a UML Sequence Diagram.mp4'
head_tail = os.path.split(file_path)
bucket_name = 'transcribe-videonotes'
#response = s3.list_buckets()
# print('Existing buckets:')
# for bucket in response['Buckets']:
#     print(f'  {bucket["Name"]}')
file_name = 't' + datetime.datetime.now().strftime("%Y%M%H%M%S") + head_tail[1]
print((file_name.strip()).split('.')[0]+'.json')
for i in file_name:
    if i == " ":
        file_name.replace(i,"")

print(file_name.replace(' ',''))
