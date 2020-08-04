# terra-gke-jumpstart

-------------------------

# Day 2 K8s on GKE with Terraform and Ansible
  
### **"quickly spin up a GKE Public Cluster (with added gke-based alerts & notification channel) via Terraform"**    
**https://github.com/gruntwork-io/terraform-google-gke**



### **"configure k8s RBAC and provision workloads via Ansible"**   
**https://github.com/consistent-solutions/gke-with-day-two-operations**
   

-------------------------

## Cluster level Features

### child repo: https://github.com/consistent-solutions/gke-with-day-two-operations

-------------------------
   
### Set up Environment (Cloud Shell): ###
1. Create GCP Account   

2. Activate Cloud Shell (upper right corner, far left)   

3.  Install Tools (not in Google Cloud Shell by default)   
    - install Ansible   
     (step doesn't persist across Google Cloud Shell sessions)   
     NOTE: may want to run with ```--force-reinstall``` option to avoid installing side-by-side with other installed versions.   
      ```pip install ansible==2.9.6```
    

### Prepare Project: ###
4. Create GCP Project   
    NOTE: in our example, we have terra-gke-jumpstart. HOWEVER replace this with your unique project name all throughout following steps   
    ```gcloud projects create terra-gke-jumpstart```   


5. Enable (create or link) Billing Account for Project     
     https://console.developers.google.com/project/terra-gke-jumpstart/settings   
    

6. Enable Proper Apis for Project   
    ```gcloud services enable compute.googleapis.com --project terra-gke-jumpstart```     
    ```gcloud services enable container.googleapis.com --project terra-gke-jumpstart```   

7. Set Project   
    ```gcloud config set project terra-gke-jumpstart```   

### Clone and Modify Terraform Code: ###
8. Clone Repo   
    ```git clone https://github.com/gruntwork-io/terraform-google-gke.git```   
    
9. Navigate into Repo   
    ```cd terraform-google-gke```    

10. Add GKE Alerts and Notification Channel   
    - copy ```alerts_and_notification.tf``` to ```terraform-google-gke/```
    - copy over ```gke-notification-channel/``` to ```modules/```   
    
11. Create ```terraform.tfvars``` with content: (change values as needed)   
```project = "terra-gke-jumpstart"```   
```location = "us-central1"```   
```region = "us-central1"```   

### Provision Infrastructure: ###
12. Init, Plan & Apply     
    ```terraform init```   
	```terraform plan```   
	```terraform apply```   


13. Add kubectl access   
    ```gcloud container clusters get-credentials example-cluster --region us-central1 --project terra-gke-jumpstart```   
    
### Verify Kubectl Access: ###
14. Try out kubectl   
    ```kubectl get cs```   
    ```kubectl get po --all-namespaces```

### Configure k8s RBAC and Provision Workloads with Ansible: ###
15. Clone Repo   
   ```git clone https://github.com/consistent-solutions/gke-with-day-two-operations.git```

16. Navigate into Repo directory   
   ```cd gke-with-day-two-operations```
  
17. Run ansible-playbook command   
   ```~/.local/bin/ansible-playbook -i ansible/environments/dev ansible/dev.yml```   
   NOTE: for teardown, run:   
   ```~/.local/bin/ansible-playbook -i ansible/environments/dev ansible/delete_k8s_cluster_app_resources.yml```     

### Cleanup: ###
19. Teardown GCP infra with Terraform (from ```terraform-google-gke``` repo directory)   
    ```terraform destroy```   OR delete project (terra-gke-jumpstart) to delete resources   
