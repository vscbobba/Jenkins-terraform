output "aws_jenkins" {
    value = aws_instance.lab_Jenkins.public_ip
}
# output "aws_ansible_manager" {
#     value = aws_instance.lab_ansible_manger.public_ip
# }
# output "aws_ansible_node1" {
#     value = aws_instance.lab_ansible_node1.public_ip
# }
# output "aws_ansible_node2" {
#     value = aws_instance.lab_ansible_node2.public_ip
# }