import boto3
import pandas as pd
import time
import datetime
from flask import Flask, request
import json



transcribe = boto3.client('transcribe',
aws_access_key_id = 'AKIAS3QPCMPOKNO4EDUH',
aws_secret_access_key = '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',
region_name = 'us-east-1')


def check_job_name(job_name):
    job_verification = True

    # all the transcriptions
    existed_jobs = transcribe.list_transcription_jobs()

    for job in existed_jobs['TranscriptionJobSummaries']:
        if job_name == job['TranscriptionJobName']:
            job_verification = False
            break

    if job_verification == False:
        command = input(job_name + " has existed. \nDo you want to override the existed job (Y/N): ")
        if command.lower() == "y" or command.lower() == "yes":
            transcribe.delete_transcription_job(TranscriptionJobName=job_name)
        elif command.lower() == "n" or command.lower() == "no":
            job_name = input("Insert new job name? ")
            check_job_name(job_name)
        else:
            print("Input can only be (Y/N)")
            command = input(job_name + " has existed. \nDo you want to override the existed job (Y/N): ")
    return job_name


def amazon_transcribe(audio_file_name, bucket_name):
    job_uri =  "s3://transcribe-videonotes/" + audio_file_name
    # your S3 access link
    # Usually, I put like this to automate the process with the file name
    # "s3://bucket_name" + audio_file_name

    # Usually, file names have spaces and have the file extension like .mp3
    # we take only a file name and delete all the space to name the job
    job_name = (audio_file_name.split('.')[0]).replace(" ", "")

    # file format
    file_format = audio_file_name.split('.')[1]

    # check if name is taken or not
    job_name = check_job_name(job_name)
    transcribe.start_transcription_job(
        TranscriptionJobName=job_name,
        Media={'MediaFileUri': job_uri},
        OutputBucketName=bucket_name,
        OutputKey='output-transcriptions/' + (job_name).split('.')[0] + ".json",
        MediaFormat=file_format,
        LanguageCode='en-US')

    while True:
        result = transcribe.get_transcription_job(TranscriptionJobName=job_name)
        if result['TranscriptionJob']['TranscriptionJobStatus'] in ['COMPLETED', 'FAILED']:
            print("FAILED")
            break
        time.sleep(15)

    if result['TranscriptionJob']['TranscriptionJobStatus'] == "COMPLETED":
        data = pd.read_json(result['TranscriptionJob']['Transcript']['TranscriptFileUri'])

        return data['results'][1][0]['transcript']


def amazon_transcribe(audio_file_name, bucket_name, max_speakers=-1):
    if max_speakers > 10:
        raise ValueError("Maximum detected speakers is 10.")

    job_uri = "s3://transcribe-videonotes/" + audio_file_name
    job_name = (audio_file_name.split('.')[0]).replace(" ", "")

    # check if name is taken or not
    job_name = check_job_name(job_name)

    if max_speakers != -1:
        transcribe.start_transcription_job(
            TranscriptionJobName=job_name,
            Media={'MediaFileUri': job_uri},
            MediaFormat=audio_file_name.split('.')[1],
            LanguageCode='en-US',
            OutputBucketName=bucket_name,
            OutputKey='output-transcriptions/'+(job_name).split('.')[0]+".json",
            Settings={'ShowSpeakerLabels': True,
                      'MaxSpeakerLabels': max_speakers
                      }
        )
    else:
        transcribe.start_transcription_job(
            TranscriptionJobName=job_name,
            Media={'MediaFileUri': job_uri},
            MediaFormat=audio_file_name.split('.')[1],
            LanguageCode='en-US',
            OutputBucketName=bucket_name,
            OutputKey='output-transcriptions/' + (job_name).split('.')[0] + ".json",
            Settings={'ShowSpeakerLabels': True
                      }
        )

    while True:
        result = transcribe.get_transcription_job(TranscriptionJobName=job_name)
        if result['TranscriptionJob']['TranscriptionJobStatus'] in ['COMPLETED', 'FAILED']:
            break
        time.sleep(15)
#if result['TranscriptionJob']['TranscriptionJobStatus'] == 'COMPLETED':
 #       data = pd.read_json(result['TranscriptionJob']['Transcript']['TranscriptFileUri'])
    return result, job_uri

#data = pd.read_json(result['TranscriptionJob']['Transcript']['TranscriptFileUri'])
#transcript = data['results'][2][0]['transcript']




def read_output(filename):
    # example filename: audio.json

    # take the input as the filename

    filename = (filename).split('.')[0]

    # Create an output txt file
    print(filename + '.txt')
    with open(filename + '.txt', 'w') as w:
        with open(filename+'.json') as f:

            data = json.loads(f.read())
            labels = data['results']['speaker_labels']['segments']
            speaker_start_times = {}

            for label in labels:
                for item in label['items']:
                    speaker_start_times[item['start_time']] = item['speaker_label']

            items = data['results']['items']
            lines = []
            line = ''
            time = 0
            speaker = 'null'
            i = 0

            # loop through all elements
            for item in items:
                i = i + 1
                content = item['alternatives'][0]['content']

                # if it's starting time
                if item.get('start_time'):
                    current_speaker = speaker_start_times[item['start_time']]

                # in AWS output, there are types as punctuation
                elif item['type'] == 'punctuation':
                    line = line + content

                # handle different speaker
                if current_speaker != speaker:
                    if speaker:
                        lines.append({'speaker': speaker, 'line': line, 'time': time})
                    line = content
                    speaker = current_speaker
                    time = item['start_time']

                elif item['type'] != 'punctuation':
                    line = line + ' ' + content
            lines.append({'speaker': speaker, 'line': line, 'time': time})

            # sort the results by the time
            sorted_lines = sorted(lines, key=lambda k: float(k['time']))

            # write into the .txt file
            for line_data in sorted_lines:
                line = '[' + str(
                    datetime.timedelta(seconds=int(round(float(line_data['time']))))) + '] ' + line_data.get(
                    'speaker') + ': ' + line_data.get('line')
                w.write(line + '\n\n')

# define AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and bucket_name
# bucket_name: name of s3 storage folder



app = Flask(__name__)

response = ""
@app.route('/nae', methods=["GET", "POST"])

def main():
    s3 = boto3.client('s3',
                      aws_access_key_id='AKIAS3QPCMPOKNO4EDUH',
                      aws_secret_access_key='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',
                      region_name="us-east-1"
                      )
    file_path = 'C:/Users/HP/Downloads/Newname.mp4'


    if (request.method =='POST'):
        request_data = request.data
        request_data = json.loads(request_data.decode('utf-8'))
        name = request_data['name']
        file_path = name
        head_tail = os.path.split(file_path)
        bucket_name = 'transcribe-videonotes'
    #response = s3.list_buckets()
    # print('Existing buckets:')
    # for bucket in response['Buckets']:
    #     print(f'  {bucket["Name"]}')
        file_name = 't' + datetime.datetime.now().strftime("%Y%M%H%M%S") + head_tail[1]
        s3.upload_file(file_path, bucket_name, file_name)
        #print(amazon_transcribe(file_name,bucket_name, 7))
        amazon_transcribe(file_name,bucket_name, 7)
        s3.download_file(Bucket=bucket_name, Key= 'output-transcriptions/'+(file_name).split('.')[0]+".json", Filename= (file_name).split('.')[0]+'.json')
        read_output(file_name)
        return file_name
    else: print("did not work")




import os

if __name__ == "__main__":
    main()

