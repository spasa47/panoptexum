
setup() {
  load '../test_helper/bats-support/load'
  load '../test_helper/bats-assert/load'
}

@test "Can run pandoc" {
  run pandoc -v
  assert_success
}

@test "Pandoc has lua support" {
  run pandoc -v
  assert_success
  assert_output --partial "+lua"
}

@test "Pandoc loads our defaults files" {
  run pandoc -d optex </dev/null
  assert_success
  run pandoc -d optex-standalone </dev/null
  assert_success
}
