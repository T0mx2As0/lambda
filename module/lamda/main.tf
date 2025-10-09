/*
l'alarme deve rilevare qunado la CPU è al di sopra dell'60 percento e la funzione lamda modificare
l' instance.type 

1) Instanza Creata 

2) Creazione allarme con aws_cloudwatch_metric_alarm usare dimension per mappare istanza

3) Creare funzione lambda

  period = 120   CloudWatch prende la metrica CPUUtilization e calcola il suo valore ogni 120 secondi. Piu il valore è basso èiu l'allarme scatta piu rapidamente
  evaluation_periods = 2    significa che la condizione deve essere vera per 2 periodi consecutivi prima che l'allarme si attivi. Quindi in questo caso la CPU deve essere maggiore di 40 per piu di 4 min (240 sec)
*/


# Il ROLE si interfaccia con le risorse del cloud, la POLICY dice cosa, la risorsa nel ROLE, puo o non puo fare 

resource "aws_iam_role" "LambdaRole" { ## LA FUNZIONE LAMBDA ASSUMERA QUESTO RUOLO

  name        = "LambdaFuncionRole"
  description = "Allows Lambda to access EC2 instances"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy" "EC2access" { ### PRENDO L'ARN DELLA POLICY 
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

data "aws_iam_policy" "CloudWatchLogs" { ### PRENDO L'ARN DELLA POLICY PER LOG SU CLOUDWATCH
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AttachPolicy1" { ### ASSOCIO LA POLICY AL ROLE 
  role       = aws_iam_role.LambdaRole.name
  policy_arn = data.aws_iam_policy.EC2access.arn
}

resource "aws_iam_role_policy_attachment" "AttachPolicy2" { ### ASSOCIO LA POLICY AL ROLE PER LOG SU CLOUDWATCH
  role       = aws_iam_role.LambdaRole.name
  policy_arn = data.aws_iam_policy.CloudWatchLogs.arn
}

data "archive_file" "LambdaZip" {
  type        = "zip"
  source_file = "${path.module}/funcion.py"
  output_path = "${path.module}/funcion.zip"
}

resource "aws_lambda_function" "Lambda" {
  filename      = data.archive_file.LambdaZip.output_path
  function_name = "My_First_Terraform_Lambda_Funcion"
  role          = aws_iam_role.LambdaRole.arn
  runtime       = "python3.13"
  handler       = "function.lambda_handler"
}

resource "aws_cloudwatch_metric_alarm" "MyAlarm" { #Aggiungere azione all'allarme cloudwatch --> esegiure funzione lambda
  alarm_name          = "TestLambda"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  period              = 30
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  threshold           = 50
  dimensions = {
    InstanceId = var.ID_vm
  }
  actions_enabled = "true"
  alarm_actions   = [aws_lambda_function.Lambda.arn]
}


resource "aws_lambda_permission" "Invokefuncion" {

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Lambda.function_name
  principal     = "lambda.alarms.cloudwatch.amazonaws.com"
  source_arn    = aws_cloudwatch_metric_alarm.MyAlarm.arn

  depends_on = [aws_cloudwatch_metric_alarm.MyAlarm]
}



/*
  Now i have to create 4 different things:

  data aws_iam_policy_document -> it sets up a role
  resource aws_iam_role  -> Provide an IAM Role, allows lambda funzion to assume that role
  data archive_file --> Contains lambda funcion code
  resource aws_lambda_funcion --> consumed the archive file, and create tthe funcion, i have to assign it a role (first created)
*/