# AWS ec2 instance creation using Modules

You can create ec2 instance in roboshop using this modules

## Inputs

* ami_id(optional) - AMi id that need to be used by instance. defualt ami_id is DevOps-Practice
* instance_type (optional) - Instance type to be used for creating instance. valid values are t3.micro, t3.small, t3.medium.
                             the defualt instance type is t3.micro.

* sg_ids(required) - a list of security group IDS to attach instance
* tags(required) - a map of tags to be associated with the instance

## Outputs

* public_ip - public ip of the instance created
* private_ip - private ip of the instance created
* instance_id - instance id of the instance created
