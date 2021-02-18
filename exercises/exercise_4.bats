#!./libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'


@test "Create a EC2 Instance with an apache webserver" {
  BUCKET="01234my-test-bucket"
  (cd my_solutions/exercise4_1 ; sh exercise_4_1)

  aws_cli_output=$(aws ec2 describe-instances --filters "Name=tag-value,Values=MyTestInstance" )

  echo "Output is...$aws_cli_output"
    assert_contains $aws_cli_output "MyTestInstance"
}
