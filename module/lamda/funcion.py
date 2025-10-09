import json
import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    
    instance_id = event["alarmData"]["configuration"]["metrics"][0]["metricStat"]["metric"]["dimensions"]["InstanceId"]

    alarmName = event["alarmData"]["alarmName"]

    state = event["alarmData"]["state"]["value"]

    if alarmName == "TestLambda":
        if state == "ALARM":
            ec2.stop_instances(InstanceIds=[str(instance_id)])
            # vm_state = ec2.describe_instance_status(InstanceIds=[str(instance_id)])

            # print(vm_state)
            
            # while vm_state["InstanceStatuses"][0]["InstanceState"]["Name"] != "stopped":
                
            #     print("VM SI STA SPEGNENDO")

            ec2.get_waiter('instance_stopped').wait(InstanceIds=[str(instance_id)])
            print("VM SPENTA")

            ec2.modify_instance_attribute(InstanceId=str(instance_id), InstanceType={'Value': 't3.small'})
            print("CAMBIO INSTANCE TYPE")
            ec2.start_instances(InstanceIds=[str(instance_id)])
            ec2.get_waiter('instance_running').wait(InstanceIds=[str(instance_id)])
            print("VM RUNNING")
    return {
        'statusCode': 200
    }