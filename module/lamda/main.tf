/*
l'alarme deve rilevare qunado la CPU è al di sopra dell'60 percento e la funzione lamda modificare
l' instance.type 

1) Instanza Creata 

2) Creazione allarme con aws_cloudwatch_metric_alarm usare dimension per mappare istanza

3) Creare funzione lambda

*/

/*
  period = 120   CloudWatch prende la metrica CPUUtilization e calcola il suo valore ogni 120 secondi. Piu il valore è basso èiu l'allarme scatta piu rapidamente
  evaluation_periods = 2    significa che la condizione deve essere vera per 2 periodi consecutivi prima che l'allarme si attivi. Quindi in questo caso la CPU deve essere maggiore di 40 per piu di 4 min (240 sec)
*/



resource "aws_cloudwatch_metric_alarm" "name" {
  alarm_name = "TestLambda"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 3
  period = 60
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  statistic = "Average"
  threshold = 80
  dimensions = {
    InstanceId = var.ID_vm
  }
}