## Sources:
# https://github.com/aws/aws-cli
# https://aws.amazon.com/cli/
# http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html
##

# Requires Python 2.6 or higher 
sudo python get-pip.py 

sudo pip install awscli

# Enable bash completion
complete -C aws_completer aws

# Export config file
export AWS_CONFIG_FILE=~/.aws/config

# Configure credentials
aws configure