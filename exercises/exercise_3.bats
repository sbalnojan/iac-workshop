#!./libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'


@test "Should create a bucket with my name with TF..." {
  BUCKET="01234my-test-bucket"
  (cd my_solutions/exercise3 ; sh exercise_3)

  aws_cli_output=$(aws s3api get-bucket-location --bucket $BUCKET --endpoint-url http://127.0.0.1:5000/ | jq length)

  echo "Output is...$aws_cli_output"
    assert_equal $aws_cli_output 1
}
