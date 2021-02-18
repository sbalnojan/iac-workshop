#!./libs/bats/bin/bats
# run from directory above...

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "Should create a bucket with my name..." {
  ./my_solutions/exercise_2 my-bucket test
  aws_cli_output=$(aws s3api get-bucket-location --bucket my-bucket --endpoint-url http://127.0.0.1:5000/ | jq length)

  echo "Output is...$aws_cli_output"

    assert_equal $aws_cli_output 1
}
