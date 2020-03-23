# terra-gke-jumpstart

## K8s on GKE with Terragrunt
  
** "quickly spin up a GKE Private Cluster (with Helm configured and Tiller installed)"**   
   **base repo:** https://github.com/gruntwork-io/terraform-google-gke   
   **example source:** https://github.com/gruntwork-io/terraform-google-gke/tree/master/examples/gke-private-tiller  

### Set up: ###
1. Create GCP Account  
2. Activate Cloud Shell (upper right corner, far left)   
3.  Install Tools (not in Google Cloud Shell by default)   
    - install homebrew (for terragrunt) and add to path (https://docs.brew.sh/Homebrew-on-Linux)
       ```  
         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
         test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
         test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)   
         test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile   
         echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
        ```
	- install terragrunt
	(https://terragrunt.gruntwork.io/docs/getting-started/install/)   
	  ```brew install terragrunt```   
	- install kubergrunt   
	(https://github.com/gruntwork-io/gruntwork-installer.git)   
	  ```
      mkdir ~/bin/
      wget -O ~/bin/kubergrunt https://github.com/gruntwork-io/kubergrunt/releases/download/v0.5.11/kubergrunt_linux_amd64   
      chmod +x ~/bin/kubergrunt
      echo 'export PATH="~/bin/:$PATH"' >> .bashrc   
      source .bashrc
      sudo ln -s ~/bin/kubergrunt /usr/local/bin/
    ```   

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
8. Clone Repo   
    ```git clone https://github.com/gruntwork-io/terraform-google-gke.git```   
9. Navigate into Repo   
    ```cd terraform-google-gke```    
10. Init, Plan & Apply   
(on plan and apply: at prompt, enter region(us-central1), project(terra-gke-jumpstart) and enter region again(us-central1)      
    ```terraform init```   
	```terraform plan```   
	```terraform apply```   
11. Add kubectl access   
    ```gcloud container clusters get-credentials example-cluster --region us-central1 --project terra-gke-jumpstart```   
12. Try out kubectl   
    ```kubectl get cs```   

13. Delete with Terraform
    ```terraform destroy```
  OR delete project (terra-gke-jumpstart) to delete resources
