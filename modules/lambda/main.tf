
# Create IAM role for Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach the AWS managed Lambda basic execution role to our IAM role
resource "aws_iam_role_policy_attachment" "attach_execution_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "allow_lambda_actions" {
  name = "allow_start_stop_and_instance_status_policies"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ec2:StartInstances"
        Resource = "arn:aws:ec2:${var.region}:${var.account_id}:instance/${var.instance_id}"
      },
      {
        Effect   = "Allow"
        Action   = "ec2:StopInstances"
        Resource = "arn:aws:ec2:${var.region}:${var.account_id}:instance/${var.instance_id}"
      },
      {
        Effect   = "Allow"
        Action   = "ec2:DescribeInstances"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow_lambda_actions.arn
}

# Create the Lambda function
resource "aws_lambda_function" "example" {
  filename      = "./modules/lambda/lambda-function/lambda_function_payload_2.zip"
  function_name = "example_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  
  # You can zip the dummy function code we created earlier and upload here
  # source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs20.x"

  environment {
    variables = {
      INSTANCE_IP = var.instance_id
      PASSWORD = var.password
    }
  }
}

# Create the API Gateway
resource "aws_api_gateway_rest_api" "example" {
  name        = "example_api"
  description = "Example API"
}

# Create a resource under the API, this could represent an entity - e.g. "/users"
resource "aws_api_gateway_resource" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "myresource"
}

# Define a GET method on the "/users" resource. 
resource "aws_api_gateway_method" "example" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.example.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integration between the GET method and the Lambda function
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.example.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example.invoke_arn
}

# Granting API Gateway permissions to invoke the Lambda function
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/${aws_api_gateway_method.example.http_method}${aws_api_gateway_resource.example.path}"
}

# Deployment of the API
resource "aws_api_gateway_deployment" "example" {
  depends_on  = [aws_api_gateway_integration.lambda]
  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "test"
}


