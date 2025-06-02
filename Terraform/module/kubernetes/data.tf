data "aws_iam_role" "fastfood_role" {
  name = "LabRole"
}

data "aws_cognito_user_pools" "fastfood_user_pools" {
  name = "fastfoodapi-user-pool"
}

data "aws_cognito_user_pool" "fastfood_user_pool" {
  user_pool_id = data.aws_cognito_user_pools.fastfood_user_pools.ids[0]
}
