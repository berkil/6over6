## 6over6 Devops Exercise

* docker:
  * Contains a Dockerfile with the script of fibonacci function running infinitely, and printing the value every minute.

* terraform:
  * Contains a TF code to provision an ECS task with above dockerized fibonacci function

* vagrant:
  * Contains Vagrant file and Ansible role for creating 2 nodes, and installing Gitlab.  
    I have tried using Jenkins as suggested in the exercise, 
    but than decided I do not have sadistic personality,  
    so I commented it and proceeded with a more human friendly CICD system.

I have left the last part testing and deploying the fibonacci container into the second instance created by Vagrant using the CICD system 