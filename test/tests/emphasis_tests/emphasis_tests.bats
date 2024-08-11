setup() {
  load '../../test_helper/bats-support/load'
  load '../../test_helper/bats-assert/load'
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
}


@test "Can process italics" {
  TFILE="${DIR}/emph001.in"
  TRESULT="This is text with the word {\em  italics} in {\em  italics}."
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/emphasis_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/emphasis_tests_tmp"
  assert_success
}



@test "Can process bold text" {
  TFILE="${DIR}/emph002.in"
  TRESULT="This is text with the word {\bf  bold} being {\bf  bold}."
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/emphasis_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/emphasis_tests_tmp"
  assert_success
}

@test "Can process bold italics" {
  TFILE="${DIR}/emph003.in"
  TRESULT="This is text with the phrase {\bf  {\em  bold italics}} being in {\bf  {\em  bold italics}}."
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/emphasis_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/emphasis_tests_tmp"
  assert_success
}
