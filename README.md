# terraform-htmlcv

Add your-cv.html to root folder

Add yout-cv.html as you base cv and edit s3 object resource in s3-iam.tf as below. #To do convert cv as input variable

################################################

  resource "aws_s3_bucket_object" "website" {
    bucket = aws_s3_bucket.web_bucket.bucket
    key    = "/website/index.html"
    source = "./<add_ur_cv_here>.html"

################################################

#To-do 

Update s3 sync to upload multiple files to support full website

replace instance resource with Auto Scaling group with Launch config

replace Bootstrap provision with shell script

