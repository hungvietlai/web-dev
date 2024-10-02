# My Blog Website

This repository contains all the code necessary to deploy a simple blog application that I created using Bootstrap, Node.js, and EJS. It also demonstrates different deployment methods.

---

## Table of Contents

- [Local Deployment](#localdeployment)
- [Docker Deployment](#dockerdeployment)
- [AWS Deployment](#awsdeployment)
- [Image](#image)

---

## Local Deployment

- Ensure you have **Node.js** and the **Live Server** extension installed on VSCode.
- Run the following commands to clone the repository and install the necessary dependencies:

```bash

git clone https://github.com/hungvietlai/web-dev.git

cd web-dev/my_blog_website/

npm install 

```

- You should be able to access the application by navigating to **localhost:3000** in your browser.

---

## Docker Deployment

- Ensure Docker is installed. You can find the installation guide here: (https://docs.docker.com/get-started/get-docker/)

- Run the following commands to build and run the Docker container. The application will be accessible at **localhost:3000**:

```bash
git clone https://github.com/hungvietlai/web-dev.git

cd web-dev/my_blog_website/

docker build -t <image_name>:<tag> .

docker run -d -p 3000:3000 -- name <container_name> <image_name>:<tag>

```

- To persist blog data across container restarts, map the container’s volume where the database is stored to a location on your local machine. This ensures that your data remains intact even if the container is stopped or removed. Use the following command:

```bash

docker run -d -p 3000:3000 -v <path/to/your/data>:/app/blog.db <container_name> <image_name>:<tag>

```

---

## AWS Deployment

- Ensure you have an AWS account set up. You can follow this guide to create one: (https://aws.amazon.com/getting-started/guides/setup-environment/)

- Create an Access Key/Secret Key through IAM: (https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)

- Make sure you have your Access Key and Secret Key stored in **~/.aws/config** and **~/.aws/credentials** on your local machine.

- Ensure Terraform is installed. You can follow this guide: (https://developer.hashicorp.com/terraform/install)

- Run the following commands to deploy the application to AWS:

```bash
git clone https://github.com/hungvietlai/web-dev.git

cd web-dev/my_blog_website/

cd terraform/

terraform init

terraform apply

```

- You can access the application via **<public_ip>:3000** or **<DNS>:3000** in your browser.

- To clean up and remove the AWS resources, run:

```bash
terraform destroy

```

---

# Image

![blog_app_image](https://github.com/hungvietlai/web-dev/blob/main/my_blog_website/image/blog_app.png)




