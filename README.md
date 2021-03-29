# myrepo

Basic Troubleshooting - Issues encountered and steps taken to rectify them.
  
	Verify SSH connectivity before executing scripts. The scripts should function without an issue if SSH connectivity between the two instances are okay. If it's two EC2    instances, please make sure the .pem keyfile is available in the given location. If it's two on-prem Linux hosts, set up SSH keys first using ssh-keygen utility.
https://www.ssh.com/ssh/keygen/#creating-an-ssh-key-pair-for-user-authentication
	
	Follow the steps outlined in the document to set up a NAT Gateway to provide access to the instance in the private subnet. Otherwise you won't be able to download the required packages needed to complete this setup.
	
	In the script for task 4, if the tar command and file manipulation commands are not working, set owner of /var in the webserver to ec2-user.
	
	Please make sure that the extra files needed for input are available in the script location. The folder structure should be same as the one shown in this repo.
