import csv
import os, uuid
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient

try:
       
    print("Azure Blob Storage Python quickstart sample")
    account_url = "https://devusecollectorasa.blob.core.windows.net"
    default_credential = DefaultAzureCredential()

    # Create the BlobServiceClient object
    blob_service_client = BlobServiceClient(account_url, credential=default_credential)
    # Quickstart code goes here
    # Create a unique name for the container
    container_name = str('doorstep')
    # Create the container
    #container_client = blob_service_client.create_container(container_name)

    # Create a local directory to hold blob data
    local_path = "C:\Qasim\data"
    # os.mkdir(local_path)

    # Create a file in the local data directory to upload and download
    # local_file_name = str(uuid.uuid4()) + ".csv"
    local_file_name = str("netflix_titles1.csv")
    upload_file_path = os.path.join(local_path, local_file_name)


    # Create a csv file with fictitious data
    file = open(file=upload_file_path, mode='w')
    
    file.write("show_id,type,title,director,cast,country,date_added,release_year,rating,duration,listed_in,description\n")
    file.write("s7788,Movie,ZZ TOP: THAT LITTLE OL BAND FROM TEXAS,Sam Dunn,,United Kingdom,\"March 1, 2020\",2019,TV-MA,90 min,\"Documentaries, Music & Musicals\",This documentary delves into the mystique behind the blues-rock trio and explores how the enigmatic band created their iconic look and sound.\n")
    file.write("s7789,TV Show,ZZ TOP: OL,Sam Dunn,,Canada,\"March 23, 2022\",2020,TV-MA,60 min,\"Music & Musicals\",This music delves into the mystique behind the blues-rock trio and explores how the enigmatic band created their iconic look and sound.\n")
    # update existing records
    file.write("s7786,Movie,Zumbo's Just Desserts,,\"Adriano Zumbo, Rachel Khoo\",Australia,\"October 31, 2020\",2019,TV-PG,1 Season,\"International TV Shows, Reality TV\",\"Dessert wizard Adriano Zumbo looks for the next \"Willy Wonka\" in this tense competition that finds skilled amateurs competing for a $100,000 prize.\"\n")
    file.close()

    # Create a blob client using the local file name as the name for the blob
    blob_client = blob_service_client.get_blob_client(container=container_name, blob=local_file_name)

    print("\nUploading to Azure Storage as blob:\n\t" + local_file_name)

    # Upload the created file
    with open(file=upload_file_path, mode="rb") as data:
        blob_client.upload_blob(data)
    
    print("\n\tFile " + local_file_name + " has been successfully uploaded to Azure Storage blob.\n")

except Exception as ex:
    print('Exception:')
    print(ex)