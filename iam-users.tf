

# Create IAM users using the 'for_each' meta-argument
resource "aws_iam_user" "my_fam_users_for_each" {
    for_each = var.iam_usernames
    name = each.key             # Or use each.value instead as this is a set of strings.
                                # In case of a dictionary/map datatype, we use each.key & each.value accordingly

}

resource "aws_iam_user_policy" "myfam_policy" {
    name = "myfam-policy"
    for_each = aws_iam_user.my_fam_users_for_each
    user = each.value.name
    policy = <<EOF
    {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Sid": "Statement2",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF

}
