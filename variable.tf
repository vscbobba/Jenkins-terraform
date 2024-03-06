variable "port" {
  type = list(number)
  default = [22,8080,443,8081,9000]
}
variable "ami" {
  type = list(string)
  default = ["ami-053b0d53c279acc90","ami-0453898e98046c639"]
}
variable "instance_type" {
  type = list(string)
  default = ["t2.micro","t2.medium","t2.large"]
}
variable "create_instance1" {
    default = true
}
variable "create_instance2" {
    default = false
}
variable "create_instance3" {
    default = false
}