import functions_framework
import googleapiclient.discovery


# CloudEvent function to be triggered by an Eventarc Cloud Audit Logging trigger
# Note: this is NOT designed for second-party (Cloud Audit Logs -> Pub/Sub) triggers!
@functions_framework.cloud_event
def hello_auditlog(cloudevent):
    # Print out the CloudEvent's (required) `type` property
    
    service = googleapiclient.discovery.build('compute','v1')

    # data
    audit_data = cloudevent.data.get("resource")
    instance_id = audit_data.get('labels', dict()).get('instance_id')
    zone = audit_data.get('labels', dict()).get('zone')
    project_id = audit_data.get('labels', dict()).get('project_id')

    # network interface data 

    network_data = service.instances().get(project=project_id, zone=zone, instance= instance_id).execute()

    
    network_name = network_data.get('networkInterfaces')
    network_interface = network_name[0].get('name')
    

    access_config_name = ''

    if network_name[0].get('accessConfigs'):  
        access_confi = network_name[0].get('accessConfigs')
        access_config_name = access_confi[0].get('name')
    else:
        return None

    request = service.instances().deleteAccessConfig(project=project_id, zone=zone, instance=instance_id, accessConfig=access_config_name, networkInterface=network_interface)
    response = request.execute()

    print(f"Someone tried to assing an external IP to an instance   Isntance : {instance_id} , Zone : {zone}, Project : {project_id}")
    #print(f"Principal: {payload.get('authenticationInfo', dict()).get('principalEmail')}")

