setup() {
  load '../../test_helper/bats-support/load'
  load '../../test_helper/bats-assert/load'
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
}


@test "Can process one paragraph" {
  TFILE="${DIR}/para001.in"
  TRESULT="$(cat $TFILE)"
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/para_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/para_tests_tmp"
  assert_success
}



@test "Can process two simple paragraphs" {
  TFILE="${DIR}/para002.in"
  TRESULT="$(cat $TFILE)"
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/para_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/para_tests_tmp"
  assert_success
}
