# ------------------------------
# Outputs
# ------------------------------

output "lambda_invoke_url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}
