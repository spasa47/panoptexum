setup() {
  load '../../test_helper/bats-support/load'
  load '../../test_helper/bats-assert/load'
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
}


@test "Can process line block" {
  TFILE="${DIR}/block001.in"
  TRESULT="$(printf 'Line one\\hfil\\break\nLine two\\hfil\\break\nLine three')"
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "Line one\hfil\break"
  echo "$output" >"${BATS_TEST_TMPDIR}/block_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/block_tests_tmp"
  assert_success
}

@test "Can process definition list" {
  TFILE="${DIR}/block002.in"
  TRESULT="$(printf '{\\bf Term}\nDefinition here.')"
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial '{\bf Term}'
  assert_output --partial 'Definition here.'
  echo "$output" >"${BATS_TEST_TMPDIR}/block_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/block_tests_tmp"
  assert_success
}

@test "Can process multi-item definition list" {
  TFILE="${DIR}/block003.in"
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output --partial '{\bf Apple}'
  assert_output --partial 'A fruit.'
  assert_output --partial '{\bf Orange}'
  assert_output --partial 'Another fruit.'
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial '{\bf Apple}'
  assert_output --partial '{\bf Orange}'
  echo "$output" >"${BATS_TEST_TMPDIR}/block_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/block_tests_tmp"
  assert_success
}

@test "Can process div (passes through content)" {
  TFILE="${DIR}/block004.in"
  TRESULT='Content in a div.'
  run pandoc -d optex -f markdown "$TFILE"
  assert_success
  assert_output "$TRESULT"
  run pandoc -d optex-standalone -f markdown "$TFILE"
  assert_success
  assert_output --partial "$TRESULT"
  echo "$output" >"${BATS_TEST_TMPDIR}/block_tests_tmp"
  run optex --output-directory="${BATS_TEST_TMPDIR}" "${BATS_TEST_TMPDIR}/block_tests_tmp"
  assert_success
}
