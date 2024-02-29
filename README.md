# CloudFormation CLI

### Validate YAML

`cfn-lint template.yaml`

### Create Stack

```yaml
aws cloudformation create-stack \
		--stack-name WebServer \
		--template-url https://jingshi-cloudformation-templates.s3.amazonaws.com/study-template.yaml \
		--parameters ParameterKey=VpcId,ParameterValue=vpc-0197b577da975b52b \
								 ParameterKey=SSHKeyName,ParameterValue=Bajor-EC2
```

### Update Stack

```yaml
aws cloudformation update-stack \
		--stack-name WebServer \
		--template-url https://jingshi-cloudformation-templates.s3.amazonaws.com/study-template.yaml
```

### Delete Stack

```yaml
aws cloudformation delete-stack \
		--stack-name WebServer 
```

### Template YAML

```yaml
AWSTemplateFormatVersion: 2010-09-09
Description: >-
  Infrastructure for studying cloudformation template
Parameters:
  ImageId:
    Description: Amazon Linux 2023 AMI
    Default: ami-0440d3b780d96b29d
    Type: AWS::EC2::Image::Id
  VpcId:
    Description: VPC used by SG
    Type: String
  SSHKeyName:
    Description: Name of an existing EC2 KeyPair to enable SSH access to the instance
    Type: AWS::EC2::KeyPair::KeyName
    ConstraintDescription: Must be the name of an existing EC2 KeyPair.
Resources:
  WebServer:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t2.micro
      ImageId: !Ref ImageId
      SecurityGroupIds:
        - !GetAtt WebServerSecurityGroup.GroupId
      KeyName: !Ref SSHKeyName
      Tags:
        - Key: Name
          Value: Webserver
        - Key: Environment
          Value: Hello
  WebServerSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: >-
        Description of WebServer Instance
      VpcId: !Ref VpcId
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: "0.0.0.0/0"
        - IpProtocol: tcp 
          FromPort: 22
          ToPort: 22
          CidrIp: "0.0.0.0/0"
Outputs:
  PublicIp:
    Value: !GetAtt WebServer.PublicIp

```

### Save A set of CLI Command in a SH File

```yaml
touch update-template.sh
chmod u+x update-template.sh
code update-template.sh
```

**Write following to the file**

```yaml
#!/usr/bin/env zsh

aws s3 cp template.yaml s3://jingshi-cloudformation-templates/study-template.yaml
```

**Run the File**

`./update-template.sh`