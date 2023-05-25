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
    
    # Need to get the latest fingerprint since it auto generated  
    request_body = {
        'items': ['infected-instance'], 
        'fingerprint' : fingerprintUpdate
    }

    #excute the tagging for the infected instance
    taginstance = compute.instances().setTags(project = projectid, zone = zone, instance = instance_id, body = request_body).execute()

    print(f"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@: {projectid}")
    print(f"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@: {zone}")
    print(f"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@: {instance_id}")

