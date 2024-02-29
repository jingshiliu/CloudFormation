#!/usr/bin/env zsh

aws s3 cp template.yaml s3://jingshi-cloudformation-templates/study-template.yaml

aws cloudformation update-stack \
		--stack-name WebServer \
		--template-url https://jingshi-cloudformation-templates.s3.amazonaws.com/study-template.yaml