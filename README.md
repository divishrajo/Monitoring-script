
# Deployment and Monitoring Automation with Ansible and Shell Script
This repository contains an Ansible playbook and a shell script designed to automate the deployment, monitoring, and alerting of server health. The solution checks **CPU** , **MEMORY**, and **DISK** usage across target nodes and handles failures through robust error-checking and email notifications.

**Features**        
Automated Deployment: Seamlessly deploy monitoring scripts to target servers using Ansible.              
System Monitoring: Utilize shell scripts to monitor CPU usage, memory, and disk usage.                        
Error Handling: Automatically detect and handle errors during script execution.                          
Email Notifications: Get immediate alerts via email if any issues are detected.                              

**Prerequisites**                             
Ansible [installed](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)  and [configured](https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html) on the control node                                
SMTP credentials configured for email notifications.                      

**Monitoring Script (monitoring.sh)**                          
The monitoring script performs several tasks:                                      
                1) Sends email alerts if CPU, disk, or memory usage exceeds specified thresholds.                    
                2) Logs messages to a log file.                     
                3) Archives log files older than 7 days.             

**Ansible-Playbook (Deploy_monitor.yml)**                           
Gathering System Facts: Uses the setup module to gather detailed system information.              
Copying the Monitoring Script: Copies the monitoring script to the specified location on the target nodes and ensures it has executable permissions.          
Fail if Script Copy Fails: Stops the playbook if the script fails to copy.                    
Rollback if Script Deployment Fails: Removes the script if the copy operation fails.                
Check Script Existence: Verifies if the script exists on the target nodes.                  
Running Script and Checking for Errors: Runs the script and checks for any errors.                      
Print Script Output: Prints the output of the script if it runs successfully.                 
Include Additional Variables: Includes additional variables from a specified file.                       
Send Email Alerts if Script Fails: Sends an [email notification](https://docs.ansible.com/ansible/latest/collections/community/general/mail_module.html) if the script fails to execute.                        

**Using Ansible Vault**                 
Creating a Vault File using              ```ansible-vault create vault.yml ```                  
Setup the Password for the file                
Add contents in key value pair for Eg : email_username: "12344@gmail.com"               

**Giving Permissions to the file**                          
```chmod 0755 monitoring.sh```             
```chmod 0755 Deploy_monitor.yml```

**Running the Ansible playbook**                    
```ansible-playbook Deploy_monitor.yml --ask-vault-pass --syntax-check```(Checking syntax before running)                    
```ansible-playbook Deploy_monitor.yml --ask-vault-pass```(ask-vault-pass Prompts to enter the vault password)

## Divishraj O                    

For any questions or contributions, feel free to reach out at divish727@gmail.com


