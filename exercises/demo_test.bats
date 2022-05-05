#!./libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "Should add numbers together" {
    assert_equal $(echo 1+1 | bc) 2
}

@test "Should contain some text" {
  run echo "mybucketnameissven"
  assert_output --partial "sven"
}



























#
#@test "Should contain my bucket name..." {
#  run echo "my_bucketname"
##  assert_output --partial "bucketname"
#}
