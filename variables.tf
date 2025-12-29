 variable "ami_id" {
    type = string
    default = "ami-09c813fb71547fc4f"
    description = "ami id of the ec2 instance"
 }


 variable "instance_type" {
   default = "t3.micro"
   type = string
    description = "Type of the EC2 instance"

    validation {
      condition = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
      error_message = "Invalid instance type. Please choose from t3.micro, t3.small, or t3.medium."
    }
 }

 variable "sg_ids" {   ###mandatory to provide
   type = list(string)
   default = []
 }
 variable "tags" {
    type = map
   
 }