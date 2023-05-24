import functions_framework
import googleapiclient.discovery


# CloudEvent function to be triggered by an Eventarc Cloud Audit Logging trigger
# Note: this is NOT designed for second-party (Cloud Audit Logs -> Pub/Sub) triggers!
@functions_framework.cloud_event
def instance_stop(cloudevent):
    
    payload = cloudevent.data.get("resource")
    instance_id = payload.get('labels', dict()).get('instance_id')
    zone = payload.get('labels', dict()).get('zone')
    projectid = payload.get('labels', dict()).get('project_id')

    compute = googleapiclient.discovery.build('compute','v1')

    #restart the stoped intance 
    execution = compute.instances().start(project = projectid, zone = zone, instance = instance_id).execute()

    

    # Set the tags on the instance
    executionget = compute.instances().get(project = projectid, zone = zone, instance = instance_id).execute()
    fingerprintUpdate = executionget.get('tags', dict()).get('fingerprint')

    request_body = {
        'items': ['infected-instance'], 
        'fingerprint' : fingerprintUpdate
    }

    taginstance = compute.instances().setTags(project = projectid, zone = zone, instance = instance_id, body = request_body).execute()

    # set the snapshot body 
    snapshot_body = {
        'name': 'infected-vm',
        'sourceDisk' : instance_id
    }
    
    # Get the disk from the instance  
    disk_parse = executionget.get('disks')
    disk_d = disk_parse[0]
    disk_name = disk_d.get('deviceName')


    snapshot = compute.disks().createSnapshot(project = projectid, zone = zone, disk = disk_name, body = snapshot_body).execute()
    

    print(f"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@: {executionget}")
    print(f"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@: {disk_name}")
     #   print(f"Principal: {payload.get('zone')}")
