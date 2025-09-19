🚀 AI Recruitment Agent (LangChain + Streamlit + AWS + GitHub Actions)

This project is an AI Recruitment Agent built with LangChain and Streamlit, deployed using AWS (ECR + EC2) and automated with GitHub Actions.

Follow the steps below to set up the development environment, deploy to AWS, and manage CI/CD.

🛠️ Local Development Setup

#1 Create & Activate Virtual Environment
python -m venv venv
source venv/bin/activate   # Mac/Linux
venv\Scripts\activate      # Windows

#2 Install Dependencies
pip install -r requirements.txt

#3 Run the App
streamlit run app.py


☁️ AWS Deployment Guide
1️⃣ Create an IAM User for GitHub Actions

Go to AWS IAM Console
Create a new IAM User with Programmatic Access
Attach the following policies:
AmazonECR-FullAccess
AmazonEC2ContainerRegistryFullAccess


2️⃣ Create an ECR Repository

Navigate to AWS ECR Console
Click Create Repository
Enter a name (e.g., streamlit-app)
Keep default settings and click Create
Copy the Repository URI
Example: 627327986499.dkr.ecr.ap-south-1.amazonaws.com/ai_recruitment_repo


3️⃣ Launch an EC2 Instance

Go to AWS EC2 Console
Launch a new instance:
AMI: Ubuntu Server 20.04 LTS
Instance Type: t2.micro (free tier) or larger
Security Groups:
SSH (22)
HTTP (80)
HTTPS (443)
Custom TCP (8501)
Create and download a new key pair (.pem file)

4️⃣ Attach IAM Role to EC2

Go to EC2 Console
Select your instance → Actions → Security → Modify IAM Role
Attach the IAM Role created earlier

5️⃣ Configure GitHub Secrets

In your GitHub Repository → Settings → Secrets → Actions
Add the following secrets:
| Secret Name             | Value (Example)                                       |
| ----------------------- | ----------------------------------------------------- |
| `AWS_ACCESS_KEY_ID`     | Your IAM Access Key                                   |
| `AWS_SECRET_ACCESS_KEY` | Your IAM Secret Key                                   |
| `AWS_REGION`            | e.g., `ap-south-1`                                    |
| `ECR_REPOSITORY`        | `ai_recruitment_repo`                                 |
| `EC2_HOST`              | Your EC2 Public IP / DNS                              |
| `EC2_SSH_KEY`           | Paste the content of `.pem` file (`cat your-key.pem`) |


⚙️ GitHub Actions Runner Setup
Install Runner as a Service
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status


#Stop & Remove Runner
sudo docker stop streamlit-container
sudo docker rm streamlit-container

sudo ./svc.sh stop
sudo ./svc.sh uninstall
./config.sh remove --token <OLD_TOKEN>


#Add a New Runner
./config.sh --url https://github.com/<your-username>/<your-repo> --token <NEW_TOKEN>
sudo ./svc.sh install
sudo ./svc.sh start

✅ Run & Manage the App

Once the CI/CD pipeline is set up:
Push changes → GitHub Actions will build & push Docker image → Deploy to EC2
Access your Streamlit app via:
http://<EC2-PUBLIC-IP>:8501
